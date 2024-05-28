mkdir -p ~/downloads
mkdir -p data/datasets

CURR_CSV_MD5=$(md5sum ~/downloads/2017_onwards.csv 2>/dev/null | awk '{ print $1 }')
conditional-get --etags ~/downloads/etags.json  --output ~/downloads/2017_onwards.csv 'https://s3.ap-southeast-1.amazonaws.com/table-downloads-ingest.data.gov.sg/d_8b84c4ee58e3cfc0ece0d773c8ca6abc/6f8109f7bce05c219b3825a999cc7f3a02cbc19fe536138a5eaf86bfe6d8711f.csv?AWSAccessKeyId=ASIAU7LWPY2WIWUWRH7A&Expires=1716892490&Signature=sIVAz40GmULXtUnhw8s0%2B%2BDzt%2B0%3D&X-Amzn-Trace-Id=Root%3D1-6655a53a-2879062e5cea283e044d0b1c%3BParent%3D28a9e07c3c902c46%3BSampled%3D0%3BLineage%3D9e07a47d%3A0&response-content-disposition=attachment%3B%20filename%3D%22ResaleflatpricesbasedonregistrationdatefromJan2017onwards.csv%22&x-amz-security-token=IQoJb3JpZ2luX2VjEHEaDmFwLXNvdXRoZWFzdC0xIkcwRQIhAPcXeMMZ92bCZ79qt6UkFjl5QLVi1So%2Ful2gdpgfYORdAiAc1wB4UISbCSv1P3n5VCDUDGxstz88UFGpcWb%2BZGz15CqxAwjq%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F8BEAQaDDM0MjIzNTI2ODc4MCIMYxjhgNlYb9RphADoKoUDCNw3Qqsh41GSI8%2FeoZF8uyvQbjvw5HFXS%2FsWewbUK6PiwLBJm%2BpId%2BIhomH%2FH26QQnnFLzj7HwgmEaKUbcxaUQm42cCCLn4StABd01oB2TUNSP2u6nsyPGt6BjqTNIVU4rbWjPuFTm7oGTewi0KEbd7FkOZ3m%2FFgC7rEKixhQQ1GAeOolSPrvmTcQEHkFxvoYB9O6bKxyQWqsXE5ZwMkqMB7H2NZ9k%2FNRVbX3P3JsSC6n94KtWTpxn75Jjg0Gf09pa9ICK%2FRPCMY4SWRHOujFtsP2KaIgGpcjVEu1l3Ik7V1fuqChV8TVb7%2B87tFS4RN1wZTgOgIGRGgVLio%2ByRdPwZ5jGMwcOkUB6vRbYdNaf4aKEV0bX2PYW%2FMN0BYx%2FOzRBqRf%2FZOYkYJV1ZNi7WI3pgyQbQiNtjSqQaAgjSX5wdDID8CXn46DHOU6puYnDSfi3Zd9Y508LRIBaio0vdMSna1%2FG5qVvaMSLKRLEB8SyV6ue48WAdmu8TaSy5pP%2BWvR33pmJ0whbXWsgY6nQFAkS%2B%2FaFpFr8oWYJ3Uuj3ot5UkNYvVXC6mMai2JUM329a9FK%2Fpi4tiT7UTSQM47ARDauIXhM5BAWzR4QLUt7a94sIcoFhWDvYE0cBoU%2BYThiMPlGLDyOCv1WSeXQYA318R3tBBWULsEIgoIX%2FHZAsvdxNiuxX1KqX9x5oYrtot5jkLrl6OL99JZ7wZEK61WFa2Mu4vBq6u%2Bj0bMUqD'
NEW_CSV_MD5=$(md5sum ~/downloads/2017_onwards.csv | awk '{ print $1 }')

if [ "$CURR_CSV_MD5" = "$NEW_CSV_MD5" ]; then
    echo "No new dataset found"
    exit 1
fi

# unzip ~/downloads/datasets.zip -d data/datasets
cp ~/downloads/2017_onwards.csv data/datasets/resale-flat-prices-based-on-registration-date-from-jan-2017-onwards.csv
