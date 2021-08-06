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
                    <input type ="button" id = "submitbutton" value = "제출하기" style = "width: 500px;"/>
                </div>
            
                </br>
                
              </div>
              
              <div id = "tableitem"> 
                  <div id = 'tablediv'>
                  </div>
              </div>
                             
            </form>
            
            
<style>

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


table {
    border: 1px solid black;
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
    position: relative;
    width: 1080px;
    margin: 20px 0 5px 120px;
    border: 1px solid black; 
    background: #f7f9fa;
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

	  this.companybutton.addEventListener('click',(me) => {
		  var div = this.makediv("select", null, "X");  
		  this.company.appendChild(div);
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
		  this.coaarr = new Set(res.coa)
		  this.companyarr = new Set(res.company)
		  console.log(this.coaarr)
	  }

      this.ajaxmethod("searcharray", {}, func);

	  
	  // 테이블 만들기
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
	       var temcount = arr ? Object.keys(arr).length : 0;
           var count = Math.max(20, temcount);	       
           
   		   
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
