const JSON = {};
var table_name;
var json_name;

const handleResponse = (item) => {  
    JSON.list = item;
    JSON.show();
};

JSON.sortByName = () => {
    JSON.list.sort((a, b) => {
        return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
    });
};

JSON.sortByStyle = () => {
    JSON.list.sort((a, b) => {
        return a.style.name.toUpperCase().localeCompare(b.style.name.toUpperCase());
    });
};

JSON.sortByBrewery = () => {
    JSON.list.sort((a, b) => {
        return a.brewery.name
        .toUpperCase()
        .localeCompare(b.brewery.name.toUpperCase());
    });
};

JSON.sortByYear = () => {
    JSON.list.sort((a, b) => {
        return b.year - a.year
    });
};

JSON.sortByNumberOfBeers = () => {
    JSON.list.sort((a, b) => {
        return b.beers.number_of_beers - a.beers.number_of_beers
    });
};

JSON.sortByActive = () => {
    JSON.list.sort((a, b) => {
        return a.active.toString().toUpperCase().localeCompare(b.active.toString().toUpperCase());
    });
};


JSON.show = () => {
    document.querySelectorAll(".tablerow").forEach((el) => el.remove());
    const table = document.getElementById(table_name);

    JSON.list.forEach((item) => {
      const tr = createTableRow(item);
      table.appendChild(tr);
    });
};


const createTableRow = (item) => {
    const tr = document.createElement("tr");
    tr.classList.add("tablerow");

    const name = tr.appendChild(document.createElement("td"));
        name.innerHTML = item.name;

    if (table_name == "beertable") {
        const style = tr.appendChild(document.createElement("td"));
        style.innerHTML = item.style.name;

        const brewery = tr.appendChild(document.createElement("td"));
        brewery.innerHTML = item.brewery.name;
    } else if (table_name == "brewerytable") {
        const year = tr.appendChild(document.createElement("td"));
        year.innerHTML = item.year;

        const number = tr.appendChild(document.createElement("td"));
        number.innerHTML = item.beers.number_of_beers;

        const active = tr.appendChild(document.createElement("td"));
        active.innerHTML = item.active;
    }
    return tr;
  };


const beertable = () => {
    if (document.querySelectorAll("#beertable").length >= 1) {
        table_name = "beertable";
        json_name = "beers";

        document.getElementById("name").addEventListener("click", (e) => {
            e.preventDefault;
            JSON.sortByName();
            JSON.show();
        });
        
        document.getElementById("style").addEventListener("click", (e) => {
            e.preventDefault;
            JSON.sortByStyle();
            JSON.show();
        });
        
        document.getElementById("brewery").addEventListener("click", (e) => {
            e.preventDefault;
            JSON.sortByBrewery();
            JSON.show();
        });

    } else if (document.querySelectorAll("#brewerytable").length >= 1) {
        table_name = "brewerytable";
        json_name = "breweries";

        document.getElementById("name").addEventListener("click", (e) => {
            e.preventDefault;
            JSON.sortByName();
            JSON.show();
        });
        
        document.getElementById("founded").addEventListener("click", (e) => {
            e.preventDefault;
            JSON.sortByYear();
            JSON.show();
        });
        
        document.getElementById("number_of_beers").addEventListener("click", (e) => {
            e.preventDefault;
            JSON.sortByNumberOfBeers();
            JSON.show();
        });

        document.getElementById("active").addEventListener("click", (e) => {
            e.preventDefault;
            JSON.sortByActive();
            JSON.show();
        });
    } else {
        return;
    }
    
    fetch(json_name + ".json")
    .then((response) => response.json())
    .then(handleResponse);

    // var request = new XMLHttpRequest();
    // request.onload = handleResponse;

    // request.open("get", "beers.json", true);
    // request.send();
};


export { beertable };