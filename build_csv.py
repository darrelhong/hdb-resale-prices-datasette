import pandas as pd

# read 2017 to current csv
jan_2017_now_df = pd.read_csv(
    "data/datasets/resale-flat-prices-based-on-registration-date-from-jan-2017-onwards.csv"
)

# read 2017 to current csv
jan_1990_dec_2016_df = pd.read_csv("hdb-resale-prices-data/resale-flat-prices-jan-1990-dec-2016.csv")

# populate remaining_lease_years column
jan_2017_now_df["remaining_lease_years"] = (
    jan_2017_now_df["remaining_lease"].str.split(" ").str.get(0)
)

# combine dataframes
jan_2017_now_df = jan_2017_now_df.sort_values("month")
jan_1990_now_df = pd.concat([jan_1990_dec_2016_df, jan_2017_now_df])

# add lat long data
jan_1990_now_df['block_street_name'] = jan_1990_now_df['block'] + " " + jan_1990_now_df['street_name']
geocode = pd.read_csv('hdb-resale-prices-data/resale_blocks_geocode_block_street_name.csv')
jan_1990_now_lat_long_df = pd.merge(
    jan_1990_now_df, geocode, how="left", on="block_street_name"
)
jan_1990_now_lat_long_df = jan_1990_now_lat_long_df.drop(
    labels="block_street_name", axis=1
)

# sort by date of transaction desc
jan_1990_now_lat_long_df = jan_1990_now_lat_long_df.sort_values(
    "month", ascending=False
)

jan_1990_now_lat_long_df.to_csv('data/resale.csv', index=False)