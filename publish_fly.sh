#!/bin/sh
datasette install git+https://github.com/cldellow/datasette-publish-fly@33d3b73cd275e059e2b10d6775dc82aba72a4d92

datasette publish fly \
app/resale.db \
--app="hdb-resale-prices" \
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
--region sin 