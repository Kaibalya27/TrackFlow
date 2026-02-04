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
				showPlayerStatus(this.value);
			});
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