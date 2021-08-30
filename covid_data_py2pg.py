import pandas as pd

df = pd.read_excel('Nashville Housing Data for Data Cleaning.xlsx')

df.columns = [i.lower() for i in df.columns]

from sqlalchemy import create_engine
engine = create_engine('postgresql://postgres:janganribetribet@localhost:5432/db_uas')
df.to_sql("NASHVILE_DATA_3", engine)
