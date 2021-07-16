<%@ page contentType="text/html; charset=utf-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>


<style>

  table {
    width: 100%;
    border: 1px solid #444444;
    border-collapse: collapse;
  }
  th, td {
    border: 1px solid #444444;
  }

</style>


<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.14.3/xlsx.full.min.js"></script>
<script>


// https://docs.sheetjs.com/ 참고할 것
var processmap = {} // 서버에서 넘어와서 있다고 가정
var mainsubprocess = {}
var coaarray = {}  // 저거 패키지 있으니, readfile로 읽어드릴 것. 서버에서 이런식으로 넘어와서 있다고 가정
var oppositecoa = {}
var bs_val = {}
var divisionmapping = {}
var processteam = {}


// 이것으론 BS 및 PL 및 Team만
function hashdatafromexcel(wb, hash, sheet, opt, arr){ // arr는 있다면 사용할 것

    var total = wb.Sheets[sheet]["!ref"]
    var start = total.indexOf(":");
    var lastcell = total.substring(start + 1, 10);
    var range = XLSX.utils.decode_cell(lastcell);
           
        
    // 사실 아래 작업은 서버에서 하는 역할 임시적으로 하는 것이니 서버에서는 달라져야함
    for(var r = 0; r <= range.r; r++){
      
      if(opt == 1){ // 컬럼 2 ~ n을 컬럼 1에 있는 내용으로 매핑시킬 사전 만들기  

        for(var c = 0; c <= range.c; c++){
            if(wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: c})] && wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: 0})]){
               hash[wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: c})].v] = wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: 0})].v
            }
        }

      }else if(opt == 2){ // 컬럼 2의 값을 1의 값에 매핑시키기

         hash[wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: 0})].v] = wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: 1})].v
      
      }else if(opt == 3){ //컬럼 2 ~ n을 컬럼 1의 배열로 집어넣기
        
        hash[wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: 0})].v] = []
        for(var c = 1; c <= range.c; c++){
            if(wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: c})]){
                hash[wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: 0})].v].push(wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: c})].v);
            }            
        }

      }else if(opt == 4){ // arr에 있는 값으로 매핑하기 위해서 만듬
         
         hash[wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: 0})].v] = arr[wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: 0})].v]

      }else if(opt == 5){ // arr에 있는 값으로 반대로 array가 되도록 매핑
      	 
      	 var val = arr[wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: 0})].v];
      	 if(hash[val]){
      	 	hash[val].push(wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: 0})].v)
      	 }else{
      	 	hash[val] = [wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: 0})].v]
      	 }

      }

        
    }

    return hash;        	

}

function arraydatafromexcel(arr){
    
}


window.onload = function(){
    var kkk =/(비){0,1}유동/g
    console.log("유동상각자산".replace(kkk, ""))
    
    // 서버자료 세팅해주기
    oppositecoa["BS"] = {};
    oppositecoa["IS"] = {};
    coaarray["BS"] = {};
    coaarray["IS"] = {};
    
    
    <c:forEach var = "q" items = "${oppositecoa_bs}" >
        oppositecoa["BS"]["${q.key}"] = "${q.value}"	    
    </c:forEach>    
    <c:forEach var = "q" items = "${oppositecoa_is}" >
        oppositecoa["IS"]["${q.key}"] = "${q.value}"	    
    </c:forEach>    

        
        
    <c:forEach var = "q" items = "${coaarray_bs}" >
      coaarray["BS"]["${q.key}"] = []
      <c:forEach var = "r" items = "${q.value}" >
        coaarray["BS"]["${q.key}"].push("${r}"); 
      </c:forEach>
    </c:forEach>    
   
    <c:forEach var = "q" items = "${coaarray_is}" >
      coaarray["IS"]["${q.key}"] = []
      <c:forEach var = "r" items = "${q.value}" >
        coaarray["IS"]["${q.key}"].push("${r}"); 
      </c:forEach>
    </c:forEach>    

    
    // processmap 매핑하기
    <c:forEach var = "q" items = "${processmap}" >
      processmap["${q.key}"] = {}
      <c:forEach var = "r" items = "${q.value}" >
      
        processmap["${q.key}"]["${r.key}"] = "${r.value}"; 
      </c:forEach>
    </c:forEach>    
    
    // coaprocess 매핑하기
    
    var coaprocessmap = {}
    
    <c:forEach var = "q" items = "${coaprocessmap}" >
      coaprocessmap["${q.key}"] = []
      <c:forEach var = "r" items = "${q.value}" >
        coaprocessmap["${q.key}"].push("${r}"); 
      </c:forEach>
    </c:forEach>      
    
    // 프로세스 및 팀 매핑하기    
    var processteammap = {}
    <c:forEach var = "q" items = "${processteammap}" >
       processteammap["${q.key}"] = "${q.value}"	    
    </c:forEach>    


    // 팀 vs 팀 매핑하기
    var teamteam1map = {}
    var teamteam2map = {}

    <c:forEach var = "q" items = "${teamteam1map}" >
       teamteam1map["${q.key}"] = "${q.value}"	    
    </c:forEach>    
       
    <c:forEach var = "q" items = "${teamteam2map}" >
        teamteam2map["${q.key}"] = []
       <c:forEach var = "r" items = "${q.value}" >
        teamteam2map["${q.key}"].push("${r}"); 
       </c:forEach>
    </c:forEach>      
       
    
    console.log(processmap);
    console.log(coaarray);
    console.log(mainsubprocess);
    console.log(coaprocessmap);
    console.log(processteammap);
    console.log(teamteam1map);
    console.log(teamteam2map);
}

function excelExport(event){

    var input = event.target;
    var reader = new FileReader();
    reader.onload = function(){
        var fileData = reader.result;
        var wb = XLSX.read(fileData, {type : 'binary'});
        // coaarray 읽어드려서 만들기
        //coaarray["BS"] = hashdatafromexcel(wb, {}, "BS", 3);
        //oppositecoa["BS"] = hashdatafromexcel(wb, {}, "BS", 1);
        //coaarray["IS"] = hashdatafromexcel(wb, {}, "IS", 3);
        //oppositecoa["IS"] = hashdatafromexcel(wb, {}, "IS", 1);

        divisionmapping = hashdatafromexcel(wb, divisionmapping, 'teammapping', 1);
        processteam = hashdatafromexcel(wb, processteam, 'team', 2);
        processmap =  hashdatafromexcel(wb, processmap, 'processmap', 3);
        
        // 사실 여기부터 필요있는 코드임. 위의 코드는 원래는 그냥 서버에서 넘겨받는 것임

        // BS/IS 읽어드리기
        var arr = ["realbs", "realis"] 
        var form = new makecoa();

        for(var data in arr){
           var sheet = arr[data]
           form[sheet] = hashdatafromexcel(wb, form[sheet], sheet, 2);
        }
        
        // 회사 팀 읽어드리기
        form['realteam'] = hashdatafromexcel(wb, {}, 'realteam', 5, divisionmapping);
        form['companyteam'] = hashdatafromexcel(wb, {}, 'realteam', 4, divisionmapping);
        console.log(form['companyteam']);

        form.makeform();

        wb.SheetNames.forEach(function(sheetName){
	        
	        // 아래 참고하면 경로 읽는 법 알수 있음
	        //var test = wb.Sheets[sheetName][XLSX.utils.encode_cell({c: 1, r: 1})];
	        //var test = wb.Sheets[sheetName]["A1"];

            // A3:B7  => {s:{c:0, r:2}, e:{c:1, r:6}}.
	        //var rowObj =XLSX.utils.sheet_to_json(wb.Sheets[sheetName]);
	        //console.log(JSON.stringify(rowObj));
        })
    };
    reader.readAsBinaryString(input.files[0]);
}




class makecoa{

	constructor(){
        this.realbs = {};
        this.realis = {};
        this.realteam = {};
        this.coamap = {};
        this.realcoa = {};
        this.maintag = {};
        this.button = {};
        this.processlist = {};
	    this.companyteam = {};
	    this.divisionmapping = divisionmapping
	    this.processteam = processteam;
	    this.bi = ["비유동", "비금융", "비상각"]
	    this.remove = ["/(비){0,1}유동/g", "/(비){0,1}금융/g", "/(비){0,1}상각/g"]

	}


    processmap = () => {
       
       this.maintag.parentNode.removeChild(this.maintag); 
       for(var i in this.realcoa){
           for(var j in processmap[i]){
               var pro = processmap[i][j];
               if(this.processlist[pro]){
                  this.processlist[pro].push(i);
               }else{
                  this.processlist[pro] = [i];
               }

           }
       }

       this.makeprocessform();

    }

    makeprocessform = () => {
    	
       var form = document.createElement("form");
	   form.setAttribute("charset", "UTF-8");
	   form.setAttribute("name", "controlform");
	   form.setAttribute("method", "Post");  //Post 방식
	   document.body.appendChild(form)
	   
	   var field = document.createElement("input");
		field.setAttribute("type", "submit");
		field.setAttribute("value", "제출해보자");
		form.appendChild(field);
	   
	   //form.style = "position : absolute; top : " + this.top + "px";   
	   form.setAttribute("action", "processsubmit");   
    	
    	var div = document.createElement("table"); // div 가 나은것 같으면
    	form.appendChild(div)             // div로 바꾸고
    	this.maintag = div;                        //밑의 함수는 ~~~div2
                                                   //가 아닌 ~~~div로
        // processlist 반영하기 
    	for(var i in this.processlist){
    		console.log(i);
    		var subdiv = this.makebuttondiv2(i, this.processlist[i])

    		div.appendChild(subdiv)
    	}

    }
    

    // tr, td로 구성
    makebuttondiv2 = (text, coas) => {
       
     	var div = document.createElement("tr")
    	var subdiv = document.createElement("td")
    	subdiv.innerText = text;
        div.appendChild(subdiv);
        
        var divisions = this.finddivision(text);

        var subdiv = document.createElement("td") 
        for(var j in divisions){
           var select = this.makeselect(this.companyteam);
           select.setAttribute("name", text);
           select.value = divisions[j];
           subdiv.appendChild(select);
        }         
        div.appendChild(subdiv);
        
    	var subdiv = document.createElement("td");
    	subdiv.innerText = "여기는 프로세스 설명을 담을 것";
        div.appendChild(subdiv);

        // 여기는 관련 계정을 담을 것
        var subdiv = document.createElement("td");
        var word = "";
        for(var i in coas){
           word = word + coas[i] + ", "
        }
        subdiv.innerText = word;
        div.appendChild(subdiv); 
        
        // 관련 계정은 hidden input으로 하여 넘겨버릴것
        var hiddendiv = document.createElement("input");
        hiddendiv.setAttribute("type", "hidden");
        hiddendiv.setAttribute("name", text + "_hidden");
        hiddendiv.setAttribute("value", word);

        div.appendChild(hiddendiv); 
        
        // 지금 바로는 원하는데로 안받아지므로, submit를 바꿔서, ajax 형태로 입력되도록 수정할 것
        
        return div;       
    }   
    
    // div로 구성
    makebuttondiv = (text, coas) => {
        
    	var div = document.createElement("div")
        div.style = "overflow : hidden";

    	var subdiv = document.createElement("div")
    	subdiv.style = "float : left; width : 150px; margin: 1px; border: 1px solid gold;";
    	subdiv.innerText = text;
        div.appendChild(subdiv);
        
        var divisions = this.finddivision(text);

        for(var j in divisions){
           var select = this.makeselect(this.companyteam);
           select.value = divisions[j];
           div.appendChild(select);
        }         
        
        

    	var subdiv = document.createElement("div");
    	subdiv.style = "float : left; width : 150px; border: 1px solid gold;";
    	subdiv.innerText = "여기는 프로세스 설명을 담을 것";
        div.appendChild(subdiv);

        // 여기는 관련 계정을 담을 것
        var subdiv = document.createElement("div");
        subdiv.style = "float : left; width : 150px;  border: 1px solid gold;";
        var word = "";
        for(var i in coas){
           word = word + coas[i] + ", "
        }
        subdiv.innerText = word;
        div.appendChild(subdiv); 
        return div;
    }
 

    finddivision = (process) => {

    	var team = this.processteam[process];
    	return this.realteam[team]; // 일단은 이렇게 하고 알고리즘 추가해갈것
    }

    makeform = () => {

    	var div = document.createElement("div")
    	document.body.appendChild(div)
    	this.maintag = div;

        // BS/IS 반영하기 
    	for(var i in this.realbs){
    		var subdiv = this.makediv(i, this.realbs[i], "BS")
    		div.appendChild(subdiv)
    	}
    	for(var i in this.realis){
    		var subdiv = this.makediv(i, this.realis[i], "IS")
    		div.appendChild(subdiv)
    	}

    	// 컨펌 버튼 추가하기
    	var button = this.makebutton();
        document.body.appendChild(button) 
    	this.button = button;

    }


    
    makebutton = () => {
        var button = document.createElement("Input");
        button.setAttribute('type', "button");
        button.setAttribute('value', "Confirm");
        button.addEventListener('click',()=>{this.coamapping()});
        return button;
    } 

    coamapping = () => {
        
        for(var i in this.coamap){
            this.realcoa[this.coamap[i].value] = 1
        }

        this.processmap()    
    }


   comma = (str) => { 
      str = String(str); 
      return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'); 
   } 

   numbertag = (str, tag) => {
   	  str = String(str); 
   	  var arr = /[^0-9]/g.exec(str);
   	  

   	  if(arr){
   	  	return tag; 
   	  }else{
   	  	return tag + "text-align: right;"
   	  }
 
   }


    makediv = (text1, text2, opt) => {
    	var div = document.createElement("div")
        div.style = "overflow : hidden; ";

    	var subdiv1 = document.createElement("div")
    	var style = "float : left; width : 150px; border: 1px solid gold;";
    	subdiv1.style = this.numbertag(text1, style);
    	subdiv1.innerText = this.comma(text1);
    	this.numbertag(text1);

    	var subdiv2 = document.createElement("div")
    	var style = "float : left; width : 150px;border: 1px solid gold;";
    	subdiv2.style =this.numbertag(text2, style);
        subdiv2.innerText = this.comma(text2);

        div.appendChild(subdiv1);
        div.appendChild(subdiv2);
        
        // 선택가능한 계정 집어 넣어주기
        var subdiv3 = document.createElement("div")
        var select = this.makeselect(coaarray[opt]);
        subdiv3.appendChild(select);
        subdiv3.style = "float : left; height: 21px; width : 200px;border: 1px solid gold";

        div.appendChild(subdiv3);

        this.coamap[text1] = select;
        

        // 가장 유사한 계정 선택해주기
        var similar = this.typefind(text1, opt); //
        if(similar){
        	select.value = similar;
        }

        return div;
    }

    makeselect = (arr) => {
        

        var select = document.createElement('select');
        
        for(var i in arr){
            var opt = document.createElement('option');
            //opt.setAttribute('value', i)
            opt.innerText = i;
            select.appendChild(opt)
        }
        return select;

    }





// 이 하단부터는 주로 써칭하는 알고리즘에 관한 것 기술할 것
    typefind = (name, opt) => {
        // 위의 type 만들것 
        // array는 임시로 가정함. array = {'계정명' : '수익 등 real 계정'}
        if(oppositecoa[opt][name]){
            return oppositecoa[opt][name]
        }
      //  if(oppositesub[name]){
      //      return oppositesub[name]
      //  }
        // 완전히 똑같이 일치하는 것이 없으니 순환하면서 가장 유사한 것 찾기
        var grade1 = 0;
        var decide1 = "";
        
        

        for(var i in oppositecoa[opt]){
            
            var compare = i;
            //compare = compare.replace("(", "");
            //compare = compare.replace(")", "");
            var val = this.wordprocess(name, compare);
            this.wordprocess2(name, compare);
            var temp = this.similarmatch(name, compare) + val;
            
            if(temp > grade1){
                grade1 = temp;
                decide1 = oppositecoa[opt][i];
            }    
        }

        return decide1;
/*
       var grade2 = 0;
       var decide2 = "";

       for(var i in oppositesub){
            
            var compare = i;
            //compare = compare.replace("(", "");
            //compare = compare.replace(")", "");
            
            var temp = this.similarmatch(name, compare);
            
            if(temp > grade2){
                grade2 = temp;
                decide2 = oppositesub[i];
            }    
        }
        
        if(grade1 > grade2){
            return decide1;
        }else{
            return decide2;   
        }
 */
    }
 
 wordprocess2 = (name) => {

     for(var i in this.remove){
         name.replace(i, "");
     }

     return name;
 }

 wordprocess = (word, compare) => {
     var grade = 0;
     for(var i in this.bi){
         if(word.match(i) && compare.match(i)){
             grade += i.length;
         }  
     }

     return grade;
 }

 similarmatch = (word1, word2) => {

    var before = 0;
    var realsimil = 0;
    var simil = 0;
    var simil_pos = 0;
    var tem = 0;
    var arg = 2;

    for(var i = 2; i <= word1.length + 1; i++){
        
        var pos = word2.match(word1.substring(before, i));
       
        
        if(pos && i != word1.length + 1){
            simil = simil + 1
            var pos_record = pos.index;
            tem = tem + 1
        
        }else{

            if(tem > 0){
                var a1 = before / word1.length
                var a2 = pos_record / word2.length
                var dist1 = Math.sqrt((a1 - a2) * (a1 - a2))

                // 보통자본금/보통adsfasfasdfadf자본금
                // 앞으로만 dist를 계산하면 사실 끝단어인데도 불구하고 차이가 커짐
                // 즉 뒤에서 읽는 거리도 포함하여 더 거리가 작은것을 기준으로 반영
                a1 = (i - 1) / word1.length;
                a2 = (pos_record + i - 1 - before)/word2.length;
                var dist2 = Math.sqrt((a1 - a2) * (a1 - a2))
                var dist = (dist1 + dist2)/2; // 처음에는 min을 사용했으나
                                              // 단기금융상품/상품 찾지못하여
                                              // 평균을 사용함
                realsimil = realsimil + (arg - dist) * tem
                
                tem = 0
            }

            before = i - 1
        }
    
    }
    
    // word2가 보통 길이가 더 긴것을 보정해주기 위하여
    return realsimil/Math.max(1, (word2.length/word1.length));

   }

}



</script>

<body>

<input type="file" id="excelFile" onchange="excelExport(event)"/>

</body>
