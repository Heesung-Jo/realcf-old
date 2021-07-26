<%@ page contentType="text/html; charset=utf-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="t" %>
<%@ page session="false" %>

            <form id="search" method = "post" action = "">
                
                </br>
                <div>
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
                <div>
                    <input type ="button" id = "submitbutton" value = "제출하기" style = "width: 300px"/>
                </div>
            
            </form>
            
            
<style>

span {
    display: inline-block;
    height: 20px;
    vertical-align: middle;
    font-weight: bold;
    
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
	  this.businessarr = new Set([]); // 서버에서 받아올 것
	  this.coaarr = new Set([]);  // 서버에서 받아올 것
	  this.companyarr = new Set([]); // 서버에서 받아올 것
	  
	  // 임시의 코드임
	  this.businessarr.add("반도체")
      this.coaarr.add("투자주식")
      this.companyarr.add("삼성전자")
	  this.companyarr.add("3S")
	  
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
		this.ajaxmethod("searchrequest", data);
		
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
    
    closediv(item){
    	item.parentNode.removeChild(item); 
    }
    
    
}

window.onload = () => {
	show = new showing()
	
}

</script>
