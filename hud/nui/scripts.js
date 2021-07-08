window.addEventListener("message", function(event){
    let data = event.data
    if (data.action == "deschideHud") {
        icon = '<i class="fa fa-university" aria-hidden="true"></i>'
        iconusers = '<i class="fa fa-user" style = "font-size:13px; color:rgb(159,59,44);" aria-hidden="true"></i>'
        
        document.getElementById("allhud").style.display = "block";
        document.querySelector("#idsiuseritext").innerHTML = 'ID : ' + data.id + ' &nbsp' + iconusers +' ' + data.users + '/'+data.maxslots;
        document.querySelector("#mymoney").innerHTML = "$"+data.money;
        document.querySelector("#bankmoney").innerHTML = "$"+data.bankmoney + " "+ icon;	
    }
	if (data.action == "safezone") {
		document.getElementById("safezone").style.display = data.stil;
    }
    if (data.action == "hud") {
        document.getElementById("allhud").style.display = data.value;
    }
    if (data.action == "voicechat") {
        if (data.toggle == false) {
            voice = '<i class="fa fa-microphone-alt-slash" aria-hidden="true" style = "position:absolute;color:white;font-size: 20px;right: 10px;top: 13em; text-shadow: 0 0 3px rgb(0, 0, 0), 0 0 3px rgb(0, 0, 0); border-radius: 50%;border: 3px solid grey;padding: 8px;"></i>'

        }else if (data.toggle == true) {
            voice = '<i class="fa fa-microphone-alt" aria-hidden="true" style = "position:absolute;color:white;font-size: 20px;right: 10px;top: 13em; text-shadow: 0 0 3px rgb(0, 0, 0), 0 0 3px rgb(0, 0, 0); border-radius: 50%;border: 3px solid grey;padding: 8px;"></i>'

        }
		document.querySelector("#voceaMagicaAPorumbelului").innerHTML = voice;
    }
    if (data.action == "carhud") {
        if (data.toggle == 1 ) {
            document.getElementById("hudulrablei").style.display = 'block';
            document.querySelector("#vitezz").innerHTML = data.viteza+" KM/h";
            document.querySelector("#fuell").innerHTML = "F:"+data.fuel+"%";
            if (data.seatbelt == 1 ) {
                culoare = '<i  style = "color:rgb(86, 255, 86);" >CENTURA</i>'
                document.querySelector("#seatbelt").innerHTML = culoare;
            }
            if (data.seatbelt == 0 ) {
                culoare = '<i  style = "color:rgb(253, 68, 68);"">CENTURA</i>'
                document.querySelector("#seatbelt").innerHTML = culoare;
            }

        }
        if (data.toggle == 0 ) {
            document.getElementById("hudulrablei").style.display = 'none';
        }
    }
});

