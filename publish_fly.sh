#!/bin/sh
set -e

GENERATE_DIR="$(mktemp -d)"
APP_NAME="hdb-resale-prices"

# Install the datasette-publish-fly plugin
datasette install datasette-publish-fly

# Step 1: Generate deployment files without deploying
datasette publish fly \
  app/resale.db \
  --app="$APP_NAME" \
  --metadata="app/metadata.json" \
  --template-dir="app/templates/" \
  --install datasette-cluster-map \
  --install datasette-vega \
  --setting facet_time_limit_ms 1000 \
  --setting sql_time_limit_ms 20000 \
  --setting suggest_facets off \
  --setting default_cache_ttl 604800 \
  --setting allow_download off \
  --static static:app/static/ \
  --region sin \
  --generate-dir "$GENERATE_DIR"

# Step 2: Patch the generated Dockerfile to add Anubis
# The generated CMD is shell-form: CMD datasette serve ... --port $PORT
# We extract it, embed it in our entrypoint with port 8081, and replace CMD.

# Extract the original datasette command from the CMD line
ORIGINAL_CMD=$(grep '^CMD ' "$GENERATE_DIR/Dockerfile" | sed 's/^CMD //')

# Write entrypoint that runs datasette on 8081 and Anubis on $PORT (8080)
cat > "$GENERATE_DIR/entrypoint.sh" <<ENTRYPOINT
#!/bin/bash

# Start Datasette on port 8081 (internal)
$(echo "$ORIGINAL_CMD" | sed 's/\$PORT/8081/g') &

# Start Anubis on port 8080 (public), proxying to Datasette
export BIND=":\${PORT:-8080}"
export TARGET="http://localhost:8081"
export DIFFICULTY="\${ANUBIS_DIFFICULTY:-4}"
export SERVE_ROBOTS_TXT="\${ANUBIS_SERVE_ROBOTS_TXT:-true}"

/usr/local/bin/anubis &

# Wait for any process to exit
wait -n
exit \$?
ENTRYPOINT

# Remove original CMD and append Anubis setup + new CMD
sed -i.bak '/^CMD /d' "$GENERATE_DIR/Dockerfile"
rm -f "$GENERATE_DIR/Dockerfile.bak"

cat >> "$GENERATE_DIR/Dockerfile" <<'DOCKERFILE'

# --- Anubis proof-of-work firewall ---
COPY --from=ghcr.io/techarohq/anubis:latest /ko-app/anubis /usr/local/bin/anubis
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
CMD ["/usr/local/bin/entrypoint.sh"]
DOCKERFILE

# Step 3: Deploy with flyctl
cd "$GENERATE_DIR"
flyctl deploy . --app "$APP_NAME" --config fly.toml --remote-only

# Cleanup
rm -rf "$GENERATE_DIR"