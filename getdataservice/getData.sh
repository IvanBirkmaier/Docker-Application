# Function get and parse ticker data to json
function getTickerData () {
    aktieTickerSymbol=$1
    aktieName=$2

    # Thank you for using Alpha Vantage! Our standard API call frequency is 5 calls per minute and 500 calls per day.
    sleep 10

    curl --max-time 10 --retry 5 -i -s -H "Accept: application/json" "https://www.alphavantage.co/query?function=TIME_SERIES_WEEKLY&symbol="${aktieTickerSymbol}"&interval=1min&apikey="${ALPHA_VANTAGE_FREE_KEY}"" > /data/rohdata/${aktieName}.json
    sed -e '1,11d' /data/rohdata/${aktieName}.json > /data/rohdata/${aktieName}temp.json
    rm -rf /data/rohdata/${aktieName}.json
    mv /data/rohdata/${aktieName}temp.json /data/rohdata/${aktieName}.json
    sed -i 's/Weekly Time Series/WeeklyTimeSeries/g' /data/rohdata/${aktieName}.json
    sed -i 's/1. open/open/g' /data/rohdata/${aktieName}.json
    sed -i 's/2. high/high/g' /data/rohdata/${aktieName}.json
    sed -i 's/3. low/low/g' /data/rohdata/${aktieName}.json
    sed -i 's/4. close/close/g' /data/rohdata/${aktieName}.json
    sed -i 's/5. volume/volume/g' /data/rohdata/${aktieName}.json

    jq -r '"date,open,high,low,close,volume",(.WeeklyTimeSeries | keys[] as $k | "\($k),\(.[$k] | .open),\(.[$k] | .high),\(.[$k] | .low),\(.[$k] | .close),\(.[$k] | .volume)")' /data/rohdata/${aktieName}.json > /data/csv/${aktieName}.csv 
}

# Function remove data if this is invalid
function removeInvalidData (){
    aktieName=$1

    rm -rf /data/csv/${aktieName}.csv 
    echo "${aktieName} data is broken"
}

# Check if format is right LF vs. CRLF
dos2unix app/dax-aktien.txt

# Get data from alphavantage
while read aktie || [ -n "$aktie" ]; do
    aktieTickerSymbol=`echo "$aktie" | cut -d"," -f 2`
    aktieName=`echo "$aktie" | cut -d"," -f 1` 
    echo ${aktieTickerSymbol}
    aktieName=`echo ${aktieName//[[:blank:]]/}`
    echo ${aktieName}
    getTickerData ${aktieTickerSymbol} ${aktieName} || getTickerData ${aktieTickerSymbol} ${aktieName} || removeInvalidData ${aktieName} 
done </app/dax-aktien.txt