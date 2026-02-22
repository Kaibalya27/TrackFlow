// Function to get cookie value by name
function getCookie(name) {
	let cookies = document.cookie.split('; ');
	for(let cookie of cookies) {
		let [key, value] = cookie.split('=');
		if(key === name) {
			return decodeURIComponent(value);
		}
	}
	return null;
}

async function players(){
	try{
		let result=await fetch("players");
		if(!result.ok){
			throw new Error("Server is not responding");
		}
		let data=await result.json();
		
		let name=document.querySelector("#name");
		let name2=document.querySelector("#SearchPlayer");
		
		for(let i of data){
			let option=document.createElement("option");
			let id=i["id"];
			let username=i["name"];
			let phone=i["phone"];
			if(i.error){
				throw new Error(i.error);
			}
			option.value=id;
			option.innerText=username+" | "+phone;
			
			if(name != null) {
				name.append(option);
			}
			
			if(name2 != null) {
				let option2=option.cloneNode(true);
				name2.append(option2);
			}
		}
		
		// Add event listener after players are loaded
		if(name != null) {
			name.addEventListener('change', function() {
				document.cookie = "selectedPlayerId=" + this.value + "; path=/; max-age=" + 60*60*24*365*10; 
				showPlayerStatus(this.value);
			});
			
			// Auto-select saved player from cookie
			let savedPlayerId = getCookie('selectedPlayerId');
			if(savedPlayerId) {
				name.value = savedPlayerId;
				showPlayerStatus(savedPlayerId);
			}
		}
	}
	catch(error){
		alert(error+" \n reload the page");
	}
	
}

function showPlayerStatus(playerId) {
	if(playerId) {
		document.getElementById('resultFrame').src = 'searchPlayer.jsp?Id=' + playerId;
		document.getElementById('resultFrame').style.display = 'block';
	} else {
		document.getElementById('resultFrame').style.display = 'none';
	}
}

players();