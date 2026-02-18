mkdir -p ~/downloads
mkdir -p data/datasets

SIGNED_S3_LINK=$(curl --request POST --url https://api-production.data.gov.sg/v2/internal/api/datasets/d_8b84c4ee58e3cfc0ece0d773c8ca6abc/initiate-download --header 'content-type: application/json' --data '{}' | jq -r '.data.url')

echo $SIGNED_S3_LINK

CURR_CSV_MD5=$(md5sum ~/downloads/2017_onwards.csv 2>/dev/null | awk '{ print $1 }')
conditional-get --etags ~/downloads/etags.json  --output ~/downloads/2017_onwards.csv $SIGNED_S3_LINK
NEW_CSV_MD5=$(md5sum ~/downloads/2017_onwards.csv | awk '{ print $1 }')

# if [ "$CURR_CSV_MD5" = "$NEW_CSV_MD5" ]; then
#     echo "No new dataset found"
#     exit 1
# fi

# unzip ~/downloads/datasets.zip -d data/datasets
cp ~/downloads/2017_onwards.csv data/datasets/resale-flat-prices-based-on-registration-date-from-jan-2017-onwards.csv
