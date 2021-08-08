<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html>
<head>
    <title>계정명확인</title>
</head>

<style>


table {
    border: 1px solid #444444;
    border-collapse: collapse;
  }
  
table th {
  border: 1px solid #444444;
  font-weight: bold;
  background: #dcdcd1;
  width: 200px;

  }

table td {
    border: 1px solid #444444;
    background: white;
  }


select {
      width: 100%;
      height: 100%;
      border: 0px;
}


</style>


<script type="text/javascript">


   

   
   
   function submitact(){
	   window.close();
   }

   
   // 윈도우 켜진후
   window.onload = function(){
	  
	  var subtable = new subwindow(opener.table.중분류);
	  
	  subtable.coasubwindow()
	  //210622 생성된 창을 보고 어떻게 수정할지 고민할 것
   }

   
   class subwindow{
	   
	   constructor(중분류){
		   
		   this.tag1 ={};
		   this.tablearr = {}
		   this.중분류 = 중분류
		   this.button = document.getElementById("button");
		   this.button.addEventListener('click',()=>{this.confirm()});
		   this.subject =  document.getElementById("subject");
		   this.condition = "coaconfirm";
	   }
	   
	   
	   // 처음에 이런 함수로 구성했다가 아래의 함수로 바꿈 
	   // 손익류, 차감형, 등을 나누는 것보다 그냥 죽 나열해서 바꾸게 하는게 나을 것 같으므로
	   coasubwindow2(){
	   	   
	 	   // subwindow table에 집어넣을 계정배열들 순서대로 정렬하기
	 	   var arr = {"손익류": [], "차감형": [], "BS": [], "IS": []}
	 	   
	 	   //210627 아무래도 손익류는 주계정은 없는게 맞을 듯
	 	   //차감형은 주계정이 있는게 맞는데, 대손상각비, 감가상각비 이런 것은 주계정없이, 여러개가 일반적으로 사용됨
	 	   // 추가적으로 만들어야하는 것은 갑자기 bs계정이라 생각했는데 차감형을 선택하면 위치를 차감형쪽으로 올리도록 수정
	 	   // 그리고 최종적으로 클릭하면 sortedcoa가 아니라,
	 	   // sortedrealcoa로 확정할 것
	 	   
	 	   
	 	   
	 	   for(var i in opener.table.sortedcoa){
	 		  // 손익류 , 차감형 등 집어넣기  
	          console.log(i)
	 		  var sorting = opener.table.middlecoa[opener.table.coasortobj[opener.table.coasort(i)]]["분류2"];
	 		  // 210622 이자류가 별도로 엑셀파일에 집계 안되었을 수도 있으니, 추후 집계할 것
	 		  if(sorting == "처분류" || sorting == "손익류" || sorting == "이자류"){
	 			  arr["손익류"].push(i);
	 		  }else if(sorting == "차감"){
	 			  arr["차감"].push(i);
	 		  }else{
	 			  var bsis = opener.table.middlecoa[opener.table.coasortobj[opener.table.coasort(i)]]["분류1"];
	 			  arr[bsis].push(i);
	 		  }
	 	   }
	 	   
	 	   this.tag1 = this.maketable(arr["손익류"]);
	 	   var temp = document.getElementById("tag1")
	 	   temp.appendChild(this.tag1);
	 
	 	  
	 	   this.tag2 = this.maketable(arr["차감형"], 1);
	 	   var temp = document.getElementById("tag2")
	 	   temp.appendChild(this.tag2);
	 	   
	 	  
	 	   this.tag3 = this.maketable(arr["BS"]);
	 	   var temp = document.getElementById("tag3")
	 	   temp.appendChild(this.tag3);
	 	   
	 	  
	 	   this.tag4 = this.maketable(arr["IS"]);
	 	   var temp = document.getElementById("tag4")
	 	   temp.appendChild(this.tag4);
	 	   
	 	   
	    }     

	   
	   coasubwindow(){
	   	   
	 	   // subwindow table에 집어넣을 계정배열들 순서대로 정렬하기
	 	   var arr = []
	 	   
	 	   //210627 아무래도 손익류는 주계정은 없는게 맞을 듯
	 	   //차감형은 주계정이 있는게 맞는데, 대손상각비, 감가상각비 이런 것은 주계정없이, 여러개가 일반적으로 사용됨
	 	   // 추가적으로 만들어야하는 것은 갑자기 bs계정이라 생각했는데 차감형을 선택하면 위치를 차감형쪽으로 올리도록 수정
	 	   // 그리고 최종적으로 클릭하면 sortedcoa가 아니라,
	 	   // sortedconcoa로 확정할 것
		 console.log(opener.table.sortedcoa)
	 	   for(var i in opener.table.sortedcoa){
	 		  // 손익류 , 차감형 등 집어넣기  
	          console.log(i)
	 		  
	 		  var sorting = opener.table.middlecoa[opener.table.coasortobj[opener.table.coasort(i)]]["분류2"];
	 		  // 210622 이자류가 별도로 엑셀파일에 집계 안되었을 수도 있으니, 추후 집계할 것

	 		  
	 		  if(sorting == "처분류"){
	 			arr.push([i, "처분손익"]);
	 		  }else if(sorting == "손익류"){
	 			arr.push([i, "현금흐름이 없는 손익"]);
	 		  }else if(sorting == "이자류"){
	 			arr.push([i, "이자손익"]);  
	 		  }else if(sorting == "차감"){
	 			arr.push([i, "자산/부채에 차감하는 계정"]);
	 		  }else{
	 			var bsis = opener.table.middlecoa[opener.table.coasortobj[opener.table.coasort(i)]]["분류1"];
	 			arr.push([i, bsis]);
	 		  }
	 		  
	 		  
	 	   }
	 	   
	 	   this.tag1 = this.maketable(arr);
	 	   var temp = document.getElementById("tag1")
	 	   temp.appendChild(this.tag1);
	    }  	   
	   
	   
	   makeselect(arr){
	       
	       var select = document.createElement('select');
	       for(var i in arr){
	           var opt = document.createElement('option');
	           //opt.setAttribute('value', i)
	           opt.innerText = i;
	           select.appendChild(opt)
	       }
	       return select;
	   }   

	   
	   // 첫번째 질문테이블 // 계정분류를 위한 질문테이블
	   maketable(arr){
		   
		   // 이제 집어넣기 
	       // 테이블 만들어 추가하기
	   	   var temptable = document.createElement("table");
		   
	       
	       // 제목행 
	       var thead = document.createElement("thead");
	   	   temptable.appendChild(thead);
	       var temp = {}
	       var subdiv = this.maketrtd(temp, 3, "th");
	       temp[0].innerText = "대분류"
	       temp[1].innerText = "계정"
	       temp[2].innerText = "계정분류";

	       
	       thead.appendChild(subdiv);
	       // 내용행

	       var tbody = document.createElement("tbody");
	       temptable.appendChild(tbody);
	       
	       for(var i in arr){
		       var tem = {}
	           var subdiv = this.maketrtd(tem, 3);
               
	           var sel = this.makeselect(this.중분류)
	           tem[0].appendChild(sel);
	           
	           sel.value = arr[i][1] 
		       
		       
		       tbody.appendChild(subdiv)
		       tem[1].innerText = arr[i][0];
	           var sel2 = this.makeselect(opener.table.middlecoa)
	           tem[2].appendChild(sel2);
	           sel2.value = opener.table.coasortobj[opener.table.coasort(arr[i][0])] 
	           this.tablearr[arr[i][0]] = {"분류1": sel, "분류2": sel2};
	           
	       } 

	       return temptable;
	   }

	   // 자산/부채 차감형 계정에 대한 메인계정을 추가하기 위한 질문테이블 만들기
	   maketable2(){
		   
		   // 이제 집어넣기 
	       // 테이블 만들어 추가하기
	   	   var temptable = document.createElement("table");
		   this.tablearr = {}  // 기존 tablearr 비우기
	       
	       // 제목행 
	       var thead = document.createElement("thead");
	   	   temptable.appendChild(thead);
	       var temp = {}
	       var subdiv = this.maketrtd(temp, 2, "th");
	       temp[0].innerText = "계정명"
	       temp[1].innerText = "메인계정"

	       
	       thead.appendChild(subdiv);

	       // 내용행
	       var tbody = document.createElement("tbody");
	       temptable.appendChild(tbody);
	       
	     for(var i in opener.table.sortedrealcoa){
	    	 
	    	if(opener.table.sortedrealcoa[i]["분류1"] == "자산/부채에 차감하는 계정"){
		       var tem = {}
	           var subdiv = this.maketrtd(tem, 2);
               
	           var sel = this.makeselect(opener.table.sortedrealcoa)
	           var opt = document.createElement('option');
	           opt.innerText = "고를것";
	           sel.appendChild(opt)

	           tem[1].appendChild(sel);
	           sel.value = "고를것"
		       tbody.appendChild(subdiv)
		       tem[0].innerText = i;
	           this.tablearr[i] = sel;
	    	}  
	     } 

	       return temptable;
	   }	   
	   
	   
	   maketrtd(arr, count, td, stylearr){
	       
	       var div = document.createElement("tr");
	    	for(var i = 0; i < count;i++){

	    		if(td){
	            	var subdiv = document.createElement(td)
	    		}else if(i == 0){
	            	var subdiv = document.createElement("th")
	            	
	       	}else{
	            	var subdiv = document.createElement("td")
	       	}

	   	   arr[i] = subdiv;
	   	   
	   	   
	   	   for(var j in stylearr){
	       	   subdiv.setAttribute(j, stylearr[j]);
	   	   }
	   	   
	   	   div.appendChild(subdiv);
	    	}
	   	return div
	   }    
	   
	   
	   confirm(){
		   this[this.condition]();
	   }
	   
	   coaconfirm(){
		   
		   // arr의 구조가 이럼
		   //210708 이거 할 차례임 이거 반영하고, 그 다음 바로 정산표가 뜨는게 아니도록 수정할 것
		   // table => td.innertext = 계정, td.sel = 분류
		   
		   for(var i in this.tablearr){
			   
			    var temp = {}
			    temp["분류1"] = this.tablearr[i]["분류1"].value
			    temp["분류2"] = this.tablearr[i]["분류2"].value
			    opener.table.sortedrealcoa[i] = temp
		   }
		   
	       this.tag1.parentNode.removeChild(this.tag1);		   
		   this.tag1 = this.maketable2()
	 	   var temp = document.getElementById("tag1")
	 	   temp.appendChild(this.tag1);
		   this.subject.innerText = "자산/부채 차감형 계정의 메인계정 선택하기"
		   this.condition = "coaconfirm2";
		   
	   }
	   

	   coaconfirm2(){
		   
		   // arr의 구조가 이럼
		   //210708 이거 할 차례임 이거 반영하고, 그 다음 바로 정산표가 뜨는게 아니도록 수정할 것
		   // table => td.innertext = 계정, td.sel = 분류
		   
		   for(var i in this.tablearr){
			  if(this.examtest(i) == true){
				    opener.table.sortedrealcoa[i]["main"] = this.tablearr[i].value
			  }else{
				    alert(i + "계정에 대한 차감계정을 선택해주세요. 단, 차감계정을 선택하면 안 됩니다.")
				    return
			  } 
		   }
	   
           // 210619 여기에 table 코드 집어넣을 것
           opener.table.makeprob();
	       opener.table.execute3();
	       opener.table.execute();
         
           opener.table.execute2();
           opener.table.execute4();
           opener.table.execute5();
           opener.table.execute_incometype();
           
           opener.table.inputcoasum();
           
           opener.table.makesettlement();
           
	       window.close();
	   }
	   

	   execute_func(arr_func){
		   for(var i in arr_func){
			   if(opener.table.execute_condition != "stop"){
			       arr_func[i]();
			   }else{
				   break
			   }
		   }
	   }
	   
	   examtest(i){
		   if(this.tablearr[i].value in opener.table.sortedrealcoa){
			   if(opener.table.sortedrealcoa[this.tablearr[i].value] != "자산/부채에 차감하는 계정"){
				   return true;
			   }
		   }
		   
		   return false;
	   }
	   
   }
   
   
   
   
</script>


<body>
    <h2 >계정과목별 분류표</h2>

    <input type = "button" id = "button" value = "확정하기" />

    <div id = "main">
      <p id = "subject">각종 계정과목 분류</p>
      <div id = "tag1"></div> 
    </div>
    

</body>
</html>
