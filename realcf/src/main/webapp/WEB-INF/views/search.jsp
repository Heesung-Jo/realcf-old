<%@ page contentType="text/html; charset=utf-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="t" %>
<%@ page session="false" %>

            <form id="search" method = "post" action = "">
              <div id = "contentitem"> 
                </br>
                <div >
                    <span>업종 선택</span>
                    <span id = "business" class = "listmanage"></span>
                    <span>
                         <input type ="button" class = "button" id = "businessplus" value = "+"/>
                    </span>
                </div>
            
               </br>
                <div>
                    <span>회사 선택</span>
                    <span id = "company" class = "listmanage"></span>
                    <span >    
                        <input type ="button" class = "button" id = "companyplus" value = "+"/>
                    </span>
                </div>
                
                </br>
                <div>
                    <span>계정 선택</span>
                    <span id = "coa" class = "listmanage"></span>
                    <span>    
                        <input type ="button" class = "button" id = "coaplus" value = "+"/>
                    </span>
                </div>
                
                </br>
                <div style = "left: 300px">
                    <input type ="button" id = "submitbutton" value = "제출하기"/>
                </div>
            
                </br>
                
              </div>
              
              <div id = "tableitem"> 
                  <div id = 'tablediv'>
                  </div>
              </div>
                             
            </form>
            
            
            <div id = 'subtablediv'>
                <table id ='subtable'></table>
            </div>
            
<style>


#subtable tr:hover th {
   background: yellow;
}

span {
    display: inline-block;
    height: 20px;
    vertical-align: middle;
    font-weight: bold;
    
}

#contentitem {
    position: relative;
    width: 1050px;
    margin: 20px 0 5px 120px;
    padding: 20px 0 5px 28px;
    border: 1px solid black; 
    background: #f7f9fa;
 }



.listmanage{
  height: 20px;
  width: 900px;
  display: inline-block;
  border: 1px solid #444444;
  font-weight: bold;
  background: white;
  padding: 0px;
  overflow: hidden;
  
}

.bundle{

  float: left;
  padding: 0px;
  
  height: 100%;
}

.detailcontent{
  float : left; 
  border: 1px solid black; 
  height: 100%; 
  border: 0px;
}

.button {
  width: 15px;
  height: 20px;
  border: 1px solid #444444;
  padding: 0px;
}


#submitbutton {

  width: 995px;
}


table {
    border-collapse: collapse;
    
  }
  
table th {
  border: 1px solid #444444;
  font-weight: bold;
  background: #dcdcd1;
  width: 200px;
  height: 20px;
}

table td {
    border: 1px solid #444444;
    background: white;
    height: 20px;
}


#tableitem {
    
    width: 1080px;
    margin: 20px 0 5px 120px;
    border: 1px solid black; 
    background: #f7f9fa;
    border-collapse: collapse;
 }


#tablediv {
   align-items: center;
   justify-content: center;
}






</style>            
            
<script src = "http://code.jquery.com/jquery-3.4.1.js"></script>
            
<script type="text/javascript">


class showing{

	constructor(obj){
		
	  // tag 세팅
	  this.business = document.getElementById("business");  
	  this.company = document.getElementById("company");    
	  this.coa = document.getElementById("coa");           
      this.subtablediv = document.getElementById("subtablediv");
      this.subtable = document.getElementById("subtable"); // div 가 나은것 같으면
      this.subtablearr = {};
	  
	  // 회사선택, 계정선택 등을 위한 구성화면과 그에 따른 리스너
	  this.businessarr = []; // 서버에서 받아올 것
	  this.coaarr = [];  // 서버에서 받아올 것
	  this.companyarr = []; // 서버에서 받아올 것
	  
	  this.searcharr = {}; // user의 요청에 대한 서버의 회신 arr
	  
	  // 임시의 코드임
	  this.businessarr.push("반도체")
	  
	  this.businessbutton = document.getElementById("businessplus");  // 내용(select) + x표시
	  this.companybutton = document.getElementById("companyplus");    // 내용(text) +  x표시 
	  this.coabutton = document.getElementById("coaplus");            // 내용(select) + 금액/비율 + x표시
	  
	  this.submitbutton = document.getElementById("submitbutton"); 
	  
	  // x 버튼을 누르면 삭제하기 위해서 만듬
	  this.businessbutton.addEventListener('click',(me) => {
		  var div = this.makediv(this.businessarr, null, "X");
		  this.business.appendChild(div);
      });        

	  this.keyeventcount = "";
	  this.companybutton.addEventListener('click',(me) => {
		  var div = this.makediv("select", null, "X");  
		  this.company.appendChild(div);
		  var text = div.querySelector("input[type='text']");

	      text.addEventListener('input', (me)=>{
	    	  this.decidecompanysmall(me.target.value, me)})

	      text.addEventListener('blur', (me)=>{
	    	  this.keyeventcount = "";
  			  this.subtablediv.style =  "position: absolute;z-index: -100"
     		        for(var k = this.subtable.childNodes.length - 1; k >= 0; k--){
     		        	this.subtable.removeChild(this.subtable.childNodes[k]); 
     		       }	    	  
	    	  
          })

	    	  
	      text.addEventListener('keydown', (e)=>{

	    	  if(e.key == "Enter"){
       			  this.subtablediv.style =  "position: absolute;z-index: -100"
       		        for(var k = this.subtable.childNodes.length - 1; k >= 0; k--){
       		        	this.subtable.removeChild(this.subtable.childNodes[k]); 
       		       }
       			  event.preventDefault();
	    	  }
	    	  
	    	  if(e.key == "ArrowDown"){
	    		  console.log(this.keyeventcount);
	    		  
	    		  if(this.keyeventcount ===""){
	    			  console.log("why1")
		    		  this.keyeventcount = 0;
	    		  }else if(this.keyeventcount >= this.subtable.childNodes.length - 1){
	    			  console.log("why2")
	    			  return;
	    		  }else{
		    		  this.subtable.childNodes[this.keyeventcount].childNodes[0].style = "";
		    		  this.keyeventcount += 1
		    		  console.log("why3")
	    		  }
	    		  e.target.value = this.subtable.childNodes[this.keyeventcount].innerText;
	    		  this.subtable.childNodes[this.keyeventcount].childNodes[0].style = "background: yellow;"
	    		  console.log(this.keyeventcount);
	    		  
	    	  }else if(e.key == "ArrowUp"){

	    		  if(this.keyeventcount ==""){
		    		  this.keyeventcount = 0;
	    		  }else if(this.keyeventcount <= 0){
	    		     return;
	    		  }else{
		    		  this.subtable.childNodes[this.keyeventcount].childNodes[0].style = "";
		    		  this.keyeventcount -= 1
	    		  }

	    		  e.target.value = this.subtable.childNodes[this.keyeventcount].innerText;
	    		  this.subtable.childNodes[this.keyeventcount].childNodes[0].style = "background: yellow;"
	    	  }
	    	  
	    	  
	       })
	    	  
	  
	  });        

	  this.coabutton.addEventListener('click',(me) => {
		  var div = this.makediv(this.coaarr, ["금액", "비율"], "X"); 
		  this.coa.appendChild(div);
     });        

	  // 제출하기 버튼. 안의 값이 비었는지 등을 확인하고 서버에 요청하자
      
	  this.submitbutton.addEventListener('click',(me) => {
              this.submittest();
	  });        
	  
	  var func = (res) => {
		  this.coaarr = new Set(res.coa);
		  this.companyarr = res.company;
		  this.companyarr.sort();
		  console.log(this.companyarr)
		  
	
		  
		  
	  }

      this.ajaxmethod("searcharray", {}, func);

	  
	  // 테이블 만들기
	   this.tablearr = {}
	   this.table = this.maketable();
 	   var temp = document.getElementById("tablediv")
 	   temp.appendChild(this.table);
	  
	}
	
	
	async submittest(){
		// 먼저 값들이 모두 들어가 있는지 확인하기
		var arr = [this.business, this.coa, this.company]
		var data = {"business": new Set([]), "coa": new Set([]), "company": new Set([])}
		
		for(var i in arr){
	        for(var k = 0; k < arr[i].childNodes.length; k++){
                
	        	// 어떤 요소인지 찾기
	        	var id = arr[i].id;
	        	
	        	var select = arr[i].childNodes[k].querySelector("select");
	        	
	        	if(select != null){
	        		var val = select.value;
	        		if(this[id + 'arr'].has(val) == false){
	        			alert(id + "을 올바르게 선택해주세요");
	        			return
	        		}else{
	        		    data[id].add(val)	
	        		}
	        	}
	            
	        	var text = arr[i].childNodes[k].querySelector("input[type=text]");
	        	if(text != null){
	        		var val = text.value;
		        	if(this[id + 'arr'].has(val) == false){
		        		alert(id + "을 올바르게 선택해주세요");
		        		return
		        	}else{
		        		data[id].add(val)
		        	}
	        	}
	        	
	       }
		}
		
		// data 변환
		for(var i in data){
			data[i] = Array.from(data[i])
		}
		
		
		// ajaxmethod
		
		var func = (res) => {
   		    	this.searcharr = res;
   		    	
   		    	this.table.parentNode.removeChild(this.table); 
   		    	this.table = this.maketable(this.searcharr);
   		    	var temp = document.getElementById("tablediv")
   		 	    temp.appendChild(this.table);
		}
		
		await this.ajaxmethod("searchrequest", data, func);
		
	}
	
	
	ajaxmethod(link, data, act){
		
		return new Promise((resolve) => {
		
		// 스프링 시큐리티 관련
		var header = $("meta[name='_csrf_header']").attr('content');
		var token = $("meta[name='_csrf']").attr('content');
		
   		$.ajax({
   			type : "POST",
   			url : "/view/" + link,
   			data : data,
   			beforeSend: function(xhr){
   			  if(token && header) {
   				  //console.log(header);
   				  //console.log(token);
   		       // xhr.setRequestHeader(header, token);
   			  } 
   		    },
   		    success : (res) => {
   				
   		    	console.log(res)
   		    	if("error" in res){
   		    		alert(res['error']);
   		    	}else{
   	                act(res); 
   		    	}
   		    	resolve()
                
   		    	
   				
 
   			},
            error: function (jqXHR, textStatus, errorThrown)
            {
                   console.log(errorThrown + " " + textStatus);
            }
   		})		
	  })
	}	
	
	makediv(opt1, opt2, opt3){
		// 내용 + 금액/비율 + x표시
    	var div = document.createElement("div")
        div.setAttribute('class', "bundle");
        // 내용
        if(opt1 != null){
          if(typeof(opt1) == "object"){
        	var subdiv1 = this.makeselect(opt1);
        	subdiv1.setAttribute('class', "detailcontent");
        	subdiv1.style = "width: 150px;"
            div.appendChild(subdiv1);
          }else{
          	var subdiv1 = this.maketext();
        	subdiv1.setAttribute('class', "detailcontent");
        	subdiv1.style = "width: 150px;"
          	div.appendChild(subdiv1);
          }
        }

        // 금액/비율 
        if(opt2 != null){
        	var subdiv2 = this.makeselect(["금액", "비율"]);
        	subdiv2.setAttribute('class', "detailcontent");
        	subdiv2.style = "width: 50px;"
            div.appendChild(subdiv2);		
        }

        // x표시
        if(opt3 != null){
        	var subdiv3 = this.makebutton(opt3);
        	subdiv3.setAttribute('class', "detailcontent");
        	subdiv3.style = "width: 15px; font-weight: bold;"
            div.appendChild(subdiv3);		
        }
    	
        return div
	} 
	
	
    makeselect(arr){
        var select = document.createElement('select');
        
        for(var i of arr){
            var opt = document.createElement('option');
            opt.innerText = i;
            select.appendChild(opt)
        }
        return select;
    }

    
    maketext(){
    	var text = document.createElement("input");
    	text.setAttribute('type', "text");
    	return text
    }
    
    makebutton(val){
        var button = document.createElement("Input");
        button.setAttribute('type', "button");
        button.setAttribute('value', val);
        button.addEventListener('click',()=>{this.closediv(button.parentNode)});
        return button;
    } 
    
    
    decidecompanysmall(word, me){
    	
    	
    	var count_min = 1; 
    	var count_max = this.companyarr.length;
    	
    	for(var i = 0; i < 15; i++){
    		
    		var count = Math.round((count_min + count_max)/2)
    		
    		if(count_max - count_min <= 1)
    		    break
    		else if(this.companyarr[count] < word ){
    			count_min = count
    		}else{
    			count_max = count
    		}
    		
    	}
    	
    	
    	var arr = []
    	
    	for(var i = 0; i < 4; i++){
        	arr.push(this.companyarr[count_min + i])
    		if(count_min + i >= this.companyarr.length - 1){
    			break
    		}
    	}
    	
    	this.makesubtable(arr, me)
    	
    }
    
    
    makesubtable(arr, me){
        for(var k = this.subtable.childNodes.length - 1; k >= 0; k--){
        	this.subtable.removeChild(this.subtable.childNodes[k]); 
       }

    	var pos = me.target.getBoundingClientRect();

    	var left = Math.round(pos.left - 200) + 'px';
    	var top = Math.round(pos.top - 20) + 'px';
    	this.subtablediv.style = "position: absolute; left: " + left + "; top: " +top+ ";"
    	
    	// processlist 반영하기 
    	for(var i = 0; i < arr.length;i++){
    	    this.subtablearr[i] = {}
    	    var subdiv = this.maketrtd(this.subtablearr[i], 1, null, {"width": "100px"});
     		this.subtable.appendChild(subdiv)
    	    this.subtablearr[i][0].innerText = arr[i]
     		
     		this.addsubtest(me, i)
     		this.subtablearr[i][0].addEventListener("click", (real) => {
     			me.target.value = real.target.innerText;
     			this.subtablediv.style =  "position: absolute;z-index: -100"
       		        for(var k = this.subtable.childNodes.length - 1; k >= 0; k--){
       		        	this.subtable.removeChild(this.subtable.childNodes[k]); 
       		       }

     		})     		
    	}
    	         	
    }
    

    addsubtest(me, i){
 		this.subtablearr[i][0].addEventListener("mouseover", (real) => {
 			if(this.keyeventcount != ""){
     			this.subtable.childNodes[this.keyeventcount].childNodes[0].style = "";
 			}
 			this.keyeventcount = i;
 			me.target.value = real.target.innerText;
 		})
    }
    
	maketable(arr){
		   
		   // 이제 집어넣기 
	       // 테이블 만들어 추가하기
	   	   var temptable = document.createElement("table");
		   this.tablearr = {}  // 기존 tablearr 비우기
	       
	       // 제목행 
	       var thead = document.createElement("thead");
	   	   temptable.appendChild(thead);
	       var temp = {}
	       
	       if(arr){
		       var count = Object.keys(arr).length + 2
	       }else{
	    	   count = 3
	       }

	       
	       var subdiv = this.maketrtd(temp, count, "th");
	       temp[0].innerText = "계정명"
	       temp[1].innerText = "계정종류"
		   if(arr){
			   var count = Object.keys(arr).length + 2
		       num = 0;
			   for(var i in arr){
		        	   temp[num + 2].innerText = i;
		               num += 1;
			   }

		    }else{
		       temp[2].innerText = "금액"
	       }
	       
	       
	       thead.appendChild(subdiv);

	       // 내용행
	       var tbody = document.createElement("tbody");
	       temptable.appendChild(tbody);
	       
	       // 테이블 갯수 최소가 20개이고 배열이 더 많으면 그 이상 만들기
	      // var temcount = arr ? Object.keys(arr).length : 0;
          // var count = Math.max(20, temcount);	       
           
   		   
           if(arr){
        	    // 회사별 정렬임
        	    console.log("why")
     		   // 순서대로 표시하기 위해서 this.coaarr를 활용함
     		   
        	   for(var k of this.coaarr){
                   var check = 0;
                   var num = 0;
                   var temparr = {}
                   
                   // 먼저 k란 계정을 반드시 집어넣어야 하는지 체크하기
                   for(var j in arr){
        			   num += 1;
    				   if(k in arr[j]){
    					   check = 1;
    					   break
    				   }
    			   }
        		   
                   // 체크가 되었다면, 이제 집어넣기
        		   if(check == 1){
    	    		   var temp = {}
           			   var subdiv = this.maketrtd(temp, count);
              		   tbody.appendChild(subdiv)

        			   temp[0].innerText = arr[j][k]['name'];
    			       temp[1].innerText = arr[j][k]['bspl'];
    			       var num = 0;
                       for(var j in arr){
            			   
        				   if(k in arr[j]){
        					   check = 1;
        					   console.log(arr[j][k])
        				       temp[2 + num].innerText = arr[j][k]['val'];
        				   }
        				   num += 1;
        			   }
    			       
        		   }

    		   }

	       }else{
	    	   for(var i = 0; i < 20; i++){
	    		   var temp = {}
       			   var subdiv = this.maketrtd(temp, count);
          		   tbody.appendChild(subdiv)
	    		   
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
    
    
    
    
    closediv(item){
    	item.parentNode.removeChild(item); 
    }
    
    
}

window.onload = () => {
	show = new showing()

}

</script>
