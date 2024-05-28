mkdir -p ~/downloads
mkdir -p data/datasets

CURR_CSV_MD5=$(md5sum ~/downloads/datasets.zip | awk '{ print $1 }')
conditional-get --etags ~/downloads/etags.json  --output ~/downloads/datasets.zip 'https://storage.data.gov.sg/resale-flat-prices/resale-flat-prices.zip'
NEW_CSV_MD5=$(md5sum ~/downloads/datasets.zip | awk '{ print $1 }')

if [ "$CURR_CSV_MD5" = "$NEW_CSV_MD5" ]; then
    echo "No new dataset found"
    exit 1
fi

unzip ~/downloads/datasets.zip -d data/datasets
