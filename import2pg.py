import pandas as pd

df = pd.read_excel('spreadsheet_name.xlsx') # for another file type, just look for it online

df.columns = [i.lower().strip() for i in df.columns]

from sqlalchemy import create_engine
engine = create_engine('postgresql://username:password@localhost:5432/db_name')
df.to_sql("table_name", engine)
