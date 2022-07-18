from fastapi import FastAPI
from fastapi.responses import FileResponse
import snscrape.modules.twitter as sntwitter
import pandas as pd

app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "World"}



@app.get("/twitterscraper/{user}/{until}/{since}", response_class=FileResponse)
def read_item(user: str, until: str, since: str):
    query = "(from:"+user+") until:"+until+" since:"+since
    tweets = []
    for tweet in sntwitter.TwitterSearchScraper(query).get_items():
        tweets.append([tweet.date,tweet.user.username, tweet.content])
        df = pd.DataFrame(tweets, columns=['Date', 'User', 'Tweet'])
    df.to_csv(user+'tweetsfrom'+since+'TO'+until+'.csv')
    some_file_path = user+'tweetsfrom'+since+'TO'+until+'.csv'
    return some_file_path
        
        
