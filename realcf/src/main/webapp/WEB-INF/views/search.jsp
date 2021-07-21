 <%@ page contentType="text/html; charset=utf-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>   
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
            
            
<script type="text/javascript">


class showing{

	constructor(obj){
		
	  // tag 세팅
	  this.business = document.getElementById("business");  
	  this.company = document.getElementById("company");    
	  this.coa = document.getElementById("coa");           

	  
	  this.businessbutton = document.getElementById("businessplus");  // 내용(select) + x표시
	  this.companybutton = document.getElementById("companyplus");    // 내용(text) +  x표시 
	  this.coabutton = document.getElementById("coaplus");            // 내용(select) + 금액/비율 + x표시
	  
	  this.businessarr = []; // 서버에서 받아올 것
	  this.coaarr = [];  // 서버에서 받아올 것
	  
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
        
        for(var i in arr){
            var opt = document.createElement('option');
            opt.innerText = arr[i];
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
