function test(){
    var user = document.getElementById("exampleInputEmail1").value
    var von = document.getElementById("exampleInputPassword1").value
    var bis = document.getElementById("exampleInputPassword2").value
    window.open("http://localhost:12345/twitterscraper/"+String(user)+"/"+String(bis)+"/"+String(von));
}