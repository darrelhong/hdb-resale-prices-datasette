#!/bin/sh

# create db
sqlite-utils insert app/resale.db resale_prices data/resale.csv --csv

# build index
sqlite-utils create-index app/resale.db resale_prices month
sqlite-utils create-index app/resale.db resale_prices town
sqlite-utils create-index app/resale.db resale_prices flat_type
sqlite-utils create-index app/resale.db resale_prices flat_model
sqlite-utils create-index app/resale.db resale_prices block
sqlite-utils create-index app/resale.db resale_prices street_name


# build _footer.html
FORMATTED_DATE=$(date +"%-d %b %Y")

mkdir -p app/templates

cat > app/templates/_footer.html << EOF
{% include "default:_footer.html" %}

Last updated: <strong>$FORMATTED_DATE</strong>
EOF