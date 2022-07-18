#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pandas as pd
import sklearn
import numpy as np
import datetime
import os
import time
import minio
from minio import Minio
from io import BytesIO
import plotly.express as px


from sklearn.linear_model import LinearRegression
from sklearn import preprocessing
from sklearn.model_selection import train_test_split

getdataservice_name = os.environ.get('GETDATASERVICE_NAME')
check = True
while check==True:
    response = os.system("ping -c 1 " + getdataservice_name)
    if response == 0:
        print("getdataservice is up!")
        time.sleep (25)
    else:
        check = False
#time.sleep (240)
client = minio.Minio(
    endpoint="minio:9000",
    access_key="minioadmin",
    secret_key="miniopassword",
    secure=False
)
forecast_weeks = 4 #um die letzten 4 Wochen mergen zu können
objects = client.list_objects("csv")
for obj in objects:
    # print(obj.object_name)
    res=client.get_object("csv", obj.object_name)
 
    data= pd.read_csv(res)
   #print(data)

    #get spezific column for analyis
    data2 = data[['close']] #data
    ##############################################################
    # print(data)
    forecast_out = int(forecast_weeks)  # predicting week into future
    data2['Prediction'] = data2[['close']].shift(-forecast_out)  # label column with data shifted 4 units up

    X = np.array(data2.drop(['Prediction'], 1))
    X = preprocessing.scale(X)

    X_forecast = X[-forecast_out:]  # set X_forecast equal to last 4
    X = X[:-forecast_out]  # remove last 30 from X

    y = np.array(data2['Prediction'])
    y = y[:-forecast_out]

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2)
    #Training
    clf = LinearRegression()
    clf.fit(X_train,y_train)
    # Testing
    confidence = clf.score(X_test, y_test)
    # print("confidence: ", confidence)
    forecast_prediction = clf.predict(X_forecast)
    # print(forecast_prediction)
    forecast_df = pd.DataFrame({'Forecast Price':forecast_prediction})
    #print(forecast_df)

    date_format = "%Y-%m-%d"
    lastDate = datetime.datetime.strptime(data.iloc[-1, 0], date_format)
    data['Forecast'] = np.nan
    data.iloc[-1, -1] = data.iloc[-1, data.columns.get_loc('close')]
    for i in range(forecast_weeks):
        lastDate = lastDate + datetime.timedelta(7)
        date_string = str(lastDate.strftime(date_format))
        new_row = [date_string, np.nan, np.nan, np.nan, np.nan, np.nan, forecast_df.iloc[i, forecast_df.columns.get_loc('Forecast Price')]]
        nr = pd.Series(new_row, index=data.columns)
        data = data.append(nr, ignore_index=True)



    print(data)
    data = data.sort_values(by="date")
    fig = px.line(data, x='date', y=['close', 'Forecast'])
    #fig.show()
    fig.write_html("data/forecast/"+obj.object_name+".html") #namen andern  
    fig
    #put forecast csv to bucket
    csv = forecast_df.to_csv().encode('utf-8')
    client.put_object(
        "forecast",
        obj.object_name,
        data=BytesIO(csv),
        length=len(csv),
        content_type='application/csv'
    )