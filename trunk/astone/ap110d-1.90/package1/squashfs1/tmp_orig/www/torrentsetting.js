var xmlHttp;

function createXMLHttpRequest()
{
    if (window.ActiveXObject)
    {
        xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
    } 
    else if (window.XMLHttpRequest)
    {
        xmlHttp = new XMLHttpRequest();
    }
}

function responseTorrentSetting()
{

	var xmlDoc = xmlHttp.responseXML;
	
	var operation = xmlDoc.getElementsByTagName("operation").item(0);
	var command = operation.getElementsByTagName("command").item(0);
	var commandVal = command.firstChild.nodeValue;

	var ret = operation.getElementsByTagName("return");
	var retVal = ret[0].firstChild.nodeValue;
	
	if (retVal != "OK")
	{
		return;
	}
	
	var partitionlist = xmlDoc.getElementsByTagName("partitionlist")[0];
	var letter = new Array(10);
	letter[0] = "a";
	letter[1] = "b";
	letter[2] = "c";
	letter[3] = "d";
	letter[4] = "e";
	letter[5] = "f";
	letter[6] = "g";
	letter[7] = "h";
	letter[8] = "i";
	letter[9] = "j";
	var part;
	var fspace;

	var select_storage = document.getElementById("btstoragepath");
	
	select_storage.options.length = 0;
	for(var i=0;i<10;i++){
		part = partitionlist.getElementsByTagName("part"+letter[i]);	
		fspace = partitionlist.getElementsByTagName("space"+letter[i]);	
		if(part[0].firstChild.nodeValue != "none"){
			select_storage.options[i] = new Option(part[0].firstChild.nodeValue+" ,free space:"+fspace[0].firstChild.nodeValue+"MB", "/tmp/usbmounts/"+part[0].firstChild.nodeValue);
		}else{
			break;
		}
	}

	var daemon = xmlDoc.getElementsByTagName("daemon")[0];
	var uprate = daemon.getElementsByTagName("upload");	
	var dwrate = daemon.getElementsByTagName("download");	
	var maxseedtime = daemon.getElementsByTagName("maxseedtime");
	var maxactivetr = daemon.getElementsByTagName("maxactivetr");
	var maxinactivetm = daemon.getElementsByTagName("maxinactivetm");
	var autodel= daemon.getElementsByTagName("autodelfinish");
	var btstoragepath = daemon.getElementsByTagName("btstoragepath");
	var checkswap = daemon.getElementsByTagName("checkswap");
	var customerId = daemon.getElementsByTagName("customerId");
	
	var uprateVal = uprate[0].firstChild.nodeValue;
	var dwrateVal = dwrate[0].firstChild.nodeValue;
	var maxseedtimeVal = maxseedtime[0].firstChild.nodeValue;
	var maxactivetrVal = maxactivetr[0].firstChild.nodeValue;
	var maxinactivetmVal = maxinactivetm[0].firstChild.nodeValue;
	var autodelValue= autodel[0].firstChild.nodeValue;
	var btstoragepathValue= btstoragepath[0].firstChild.nodeValue;
	var checkswapValue= checkswap[0].firstChild.nodeValue;
	var customerIdValue= customerId[0].firstChild.nodeValue;
	
	var input_maxdwrate = document.getElementById("maxdwrate");
	input_maxdwrate.value=dwrateVal;
	var input_maxuprate = document.getElementById("maxuprate");
	input_maxuprate.value = uprateVal;
	var input_timetostop = document.getElementById("timetostop");
	input_timetostop.value = maxinactivetmVal;
	var input_timetonext = document.getElementById("timetonext");
	input_timetonext.value = maxseedtimeVal;
	var input_maxtask = document.getElementById("maxtask");
	input_maxtask.value = maxactivetrVal;
	var input_autodel = document.getElementById("autodelfinish");
	input_autodel.value = autodelValue;
	
	var bt_storage_path = document.getElementById("btstoragepath");
	bt_storage_path.value = btstoragepathValue;
	
	var swap_exist = document.getElementById("swapExist");
	swap_exist.value=checkswapValue;
	
	if(customerIdValue == "45"){
		document.getElementById("down_title_1").style.visibility = "hidden";
		document.getElementById("down_title_1").style.display = "none";
	}else{
		document.getElementById("down_title").style.visibility = "hidden";
		document.getElementById("down_title").style.display = "none";
	}

	if(customerIdValue == "45"){
		document.getElementById("up_title_1").style.visibility = "hidden";
		document.getElementById("up_title_1").style.display = "none";
	}else{
		document.getElementById("up_title").style.visibility = "hidden";
		document.getElementById("up_title").style.display = "none";
	}
}

function handleTorrentSetting()
{
	if(xmlHttp.readyState == 4)
	{
		if(xmlHttp.status == 200)
		{
			responseTorrentSetting();
		}
	}
}

function showTorrentSetting()
{
	var url = "/cgi-bin/UniCGI.cgi?id=7&op=13&opid=0";
	createXMLHttpRequest();
	xmlHttp.onreadystatechange = handleTorrentSetting;
	xmlHttp.open("GET", url, true);
	xmlHttp.setRequestHeader("If-Modified-Since", "0");
	xmlHttp.send(null);
}

/* Save settings */
function responseSaveSetting()
{
	var xmlDoc = xmlHttp.responseXML;
	var operation = xmlDoc.getElementsByTagName("operation").item(0);
	var command = operation.getElementsByTagName("command").item(0);
	var commandVal = command.firstChild.nodeValue;
	var ret = operation.getElementsByTagName("return");

	var retString = operation.getElementsByTagName("string");
	window.location="./index.html";
}

function handleSaveSetting()
{
	if(xmlHttp.readyState == 4)
	{
		if(xmlHttp.status == 200)
		{
			responseSaveSetting();
		}
	}
}

function onSettingsSave()
{
/*	var optindex = document.getElementById("storagelist").options.selectedIndex;
	if (optindex >= 0)
	{
		var input_storage = document.getElementById("storagelist").options[optindex].text;
	}
	else
	{
		var input_storage = "";
	} 
*/
	var input_maxdwrate = document.getElementById("maxdwrate").value;
	var input_maxuprate = document.getElementById("maxuprate").value;
	var input_timetostop = document.getElementById("timetostop").value;
	var input_timetonext = document.getElementById("timetonext").value;
	var input_maxtask = document.getElementById("maxtask").value;
	var input_autodel= document.getElementById("autodelfinish").value;
	var bt_storage_path = document.getElementById("btstoragepath").value;
	var swap_exist = document.getElementById("swapExist").value;

	if(input_maxdwrate!=0){
		if(input_maxdwrate < 15 || input_maxdwrate > 70 ){
			alert("download rate must be 15~70");
			return false;
		}
	}
	if(input_maxuprate != 0){
		if(input_maxuprate < 10 || input_maxuprate > 30 ){
			alert("upload rate must be 10~30");
			return false;
		}
	}

//	var url = "/cgi-bin/UniCGI.cgi?id=7&op=14&opid=0&up=" + input_maxuprate + "&down=" + input_maxdwrate + "&storage=" + input_storage + "&seed=" + input_timetonext + "&idmin=" + input_timetostop + "&nact=" + input_maxtask + "&autodel=" + input_autodel;
	var url = "/cgi-bin/UniCGI.cgi?id=7&op=14&opid=0&up=" + input_maxuprate + "&down=" + input_maxdwrate + "&seed=" + input_timetonext + "&idmin=" + input_timetostop + "&nact=" + input_maxtask + "&autodel=" + input_autodel + "&bt_storage_path=" + bt_storage_path;
	createXMLHttpRequest();
	xmlHttp.onreadystatechange = handleSaveSetting;
	xmlHttp.open("GET", url, true);
	xmlHttp.setRequestHeader("If-Modified-Since", "0");
	xmlHttp.send(null);
}

/* Set default */
function onSettingsDefault()
{
//	var input_storage = document.getElementById("storagelist");
	var input_maxdwrate = document.getElementById("maxdwrate");
	var input_maxuprate = document.getElementById("maxuprate");
	var input_timetostop = document.getElementById("timetostop");
	var input_timetonext = document.getElementById("timetonext");
	var input_maxtask = document.getElementById("maxtask");	
	var input_autodel= document.getElementById("autodelfinish");	
	var bt_storage_path = document.getElementById("btstoragepath");
	
	input_maxdwrate.value = "0";
	input_maxuprate.value = "0";
	input_timetostop.value = "1";
	input_timetonext.value = "24";
	input_maxtask.value = "3";
	input_autodel.value="0";
	bt_storage_path.options.selectedIndex=0;
}
