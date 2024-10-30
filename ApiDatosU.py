import pandas as pd
from sodapy import Socrata

# Unauthenticated client only works with public data sets. Note 'None'
# in place of application token, and no username or password:
client = Socrata("www.datos.gov.co", None)

# Save into a csv file
pd.DataFrame.from_records(client.get("3jdh-nmwu", limit=900000)).to_csv('data.csv', index=False)