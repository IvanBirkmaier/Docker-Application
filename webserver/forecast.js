
const comapnies = ["adidas", "Airbus","Allianz","BASF","Bayer",
"BMW","Brenntag","Continental","Convestro","DaimlerTruck","DeliveryHero",
"DeutscheBank","DeutscheBörse","DeutschePost", "DeutscheTelekom", "E.ON","Fresenius",
"FreseniusMedicalCare","HannoverRück","HeidelbergCement", "HelloFresh",
"Henkelvz"];


function listOfLinksforDropdown(){
  for(let i = 0; i < comapnies.length; i++){
    var a = document.createElement('a');
    var linkText = document.createTextNode(comapnies[i]);
    a.appendChild(linkText);
    a.id = comapnies[i];
    a.title = comapnies[i];
    a.href = "/data/forecast/"+comapnies[i]+".csv.html";
    document.getElementById("myDropdown").appendChild(a);
  } 
}
/* When the user clicks on the button,
toggle between hiding and showing the dropdown content */
function myFunction() {
  document.getElementById("myDropdown").classList.toggle("show");
  }
  // Close the dropdown menu if the user clicks outside of it
  window.onclick = function(event) {
    if (!event.target.matches('.dropbtn')) {
      var dropdowns = document.getElementsByClassName("dropdown-content");
      var i;
      for (i = 0; i < dropdowns.length; i++) {
        var openDropdown = dropdowns[i];
        if (openDropdown.classList.contains('show')) {
          openDropdown.classList.remove('show');
        }
      }
    }
  }

