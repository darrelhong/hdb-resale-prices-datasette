mkdir -p ~/downloads
mkdir -p data/datasets
conditional-get --etags ~/downloads/etags.json  --output ~/downloads/datasets.zip 'https://storage.data.gov.sg/resale-flat-prices/resale-flat-prices.zip'

unzip ~/downloads/datasets.zip -d data/datasets
