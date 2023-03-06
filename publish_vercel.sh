datasette publish vercel \
app/resale.db \
--project="hdb-resale-prices" \
--metadata="app/metadata.json" \
--template-dir="app/templates/" \
--install datasette-cluster-map \
--install datasette-vega \
--setting facet_time_limit_ms 1000 \
--setting suggest_facets off \
--setting default_cache_ttl 604800 \
--setting allow_download off \
--static static:app/static/