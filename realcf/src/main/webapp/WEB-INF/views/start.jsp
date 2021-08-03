<%@ page contentType="text/html; charset=utf-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="t" %>
<%@ page session="false" %>

<html>


<style>


table.maintable {
    border: 1px solid #444444;
    border-collapse: collapse;
  }
  
table.maintable th {
  border: 1px solid #444444;
  font-weight: bold;
  background: #dcdcd1;

  }

table.maintable td {
    border: 1px solid #444444;
    background: white
  }

table.settlement {
  border-collapse: collapse;
  text-align: left;
  line-height: 1.5;
  border-left: 1px solid #ccc;
  
}

table.settlement thead th {
  padding: 10px;
  font-weight: bold;
  border-top: 1px solid #ccc;
  border-right: 1px solid #ccc;
  border-bottom: 2px solid black;
  background: #dcdcd1;
}
table.settlement tbody th {
  width: 700px;
  padding: 5px;
  font-weight: bold;
  vertical-align: top;
  border-right: 1px solid #ccc;
  border-bottom: 1px solid #ccc;
  background: #ececec;
}
table.settlement td {
  width: 700px;
  padding: 5px;
  vertical-align: top;
  border-right: 1px solid #ccc;
  border-bottom: 1px solid #ccc;
  background: white
}





</style>

<script src = "http://code.jquery.com/jquery-3.4.1.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.14.3/xlsx.full.min.js"></script>
<script>




// https://docs.sheetjs.com/ 참고할 것
var table = {}; //테이블 전역변수라고 생각하자

var processmap = {} // 서버에서 넘어와서 있다고 가정
var coaarray = {}  // 저거 패키지 있으니, readfile로 읽어드릴 것. 서버에서 이런식으로 넘어와서 있다고 가정
var oppositecoa = {}
//210223 아래줄 추가함
var oppositesub = {}
var bs_val = {}
var divisionmapping = {}
var processteam = {}
var subwin = {}

var successtest = {0: [], 1: [], 2: [], 3: [], 4: []}


class subcal{

	// 210609 계산후 0.0004 등 소수점 문제해결할 것
	// 210609 이제 계정 애매한 것을 처리하기 위해서 sub window 생성하는 코드 만들 것
	// 그리고 손익만 있는 거래는 계산안하는 코드 집어넣을 것
	
    constructor(mainarr, num, prob, smallval, sortedrealcoa){
        this.mainarr = mainarr;
        this.number = num;
        this.successtestnum = 0 // 나중에 삭제해도 되는 것임
        
        this.makingcounter = 23; // 20개 정도를 초과하면 시간이 급수적으로 늘어남 // 그래도 재귀함수(배열.slice() 시간에서 많이 까먹음)보단 월등히 빠름

        this.typenumber = 0; // abc[1]의 숫자로 잘 분해되었는지에 대한 값을 저장함
                             // 0은 명확하게 나누어졌을때, 1은 확률카운터로 어느정도 명확할 때, 2는 afterfail 실행
        this.grouparr = [];
        this.splitarr = []; // 나중에 차감계정과 메인계정을 잠시 분리해내기 위해서 만든 배열임
        this.probresult = [];
        
        this.testcount = 0;
        this.probmodel = prob;
        this.smallval = smallval;
        this.valrelated = 0.6;
        this.deepnodeprob = 0;
        this.sortedrealcoa = sortedrealcoa;
        // mainarr를 통해서 계정들 배열 만들기
        this.coaarray = new Set();
        for(var i in mainarr){
            this.coaarray.add(mainarr[i]["계정과목"])
        }    
        
        this.probdistarray = {} // 실패가 2 이상일때, probdistcal을 실행해서 이것을 만듬

        // mainarr 복제해서 grouparr 만들기
        // 옵션값에 따라서 계정과목별로 grouping 할 것
        
        this.coagrouping(); // coagrouping 사용 안하려면, 아래 /* 지울 것
        
        /*
        for(var i in mainarr){
            var temp = JSON.parse(JSON.stringify(mainarr[i]));
            temp.ref = [i]
            this.grouparr.push(temp);
        }
        */
        
        this.solvearr = [];
        this.solvegroup = [];
        this.countmodel = [];

	    this.execute_condition = "continue";
	}    

    //^^ 연산 및 분류하는 함수
    
    
    execute = () => {
        
        if(this.execute_condition == "stop"){
        	return;
        }
   	
        var abc = this.making(0, this.grouparr);
        var 임시=[]
        
        this.typenumber = abc[1];
       	if(this.number == 100016){
       		console.log(this.grouparr.length)
       		console.log(this.grouparr)
    		console.log("comecome")
    		console.log(abc)
    	}
       
        if(abc[1] > 1){
            
            // prob적으로 가까운 것 count만큼 모아서, making하는 함수
            // 앞으로 오류 숫자를 명확히 정의할 것. 지금은 임시로 3로함
            // 쪼개지긴 하는데 여러 경우가 발생하여, 이를 해결할 필요가 있는 경우

            if(abc[1] == 2){
               
               
               // 이것은 execute2로 연산을 시킴 왜냐하면 countmodel이 만들어진 후에 의미가 있을 것이므로
               //var test = this.making3(0, this.grouparr, []);

               // 210329 해야할 일
               // test 나온 것을 바탕으로 전표 만들기
               // 또한 자기계정이 자기계정으로 확률 집계되는 것도 막아야함
               // 또한 현재 probmodel에 차변/대변이 정확하게 들어가는 것 같지 않음. 확인해보고 수정할 것  
            }

            // prob적으로 가까운 것 count만큼 모아서, making하는 함수
            // 비고란의 문자까지 고려하는 함수
            //this.probmaking2(this.grouparr, 25);


            // making2 함수를 돌려보기

            // 위의 것이 실패하면 그룹핑할 것
            


            // 그룹핑해서, 다시 making 해보기


            // 그래도 실패하면 미지급등 현금화 계정제외하고 군집분석 수행하기 


            // 여기 앞단에서 이 함수 저함수를 통해서 더 쪼개는 방향을 생각하고 최종적으로 안될때
            // 아래 돌리자
           // this.solvearr = this.afterfail(this.grouparr, this.smallval)
            

            /*
            for(var i in abc3){
                var imsi = i.slice();
                imsi.push(1)
                imsi.push(1)
                임시.append(imsi)
             }
            */

        }else{

            var abc2 = this.erase(abc[0]);
            

            for(var i in abc2){
            	var temp = [];
            	if(abc2[i].size > 0){
                    var 차변 = 0;
                    var 대변 = 0;

            		for(var j of abc2[i]){
                		temp.push(this.grouparr[j])
                		
                		if(this.grouparr[j]["금액"] > 0){
                			차변 += 1;
                		}else{
                			대변 += 1;
                		}
                		
            		}
            	
                    if(차변 != 1 && 대변 != 1){
                    	// 결국 어느쪽 합계가 한쪽에서 커버되지 않으므로 분해가 불가능하므로 넘겨버릴 것
                     	this.typenumber = 10;
                    	return
                    }

            	}
            	this.solvegroup.push(temp)
            }
            
            
            
            // 분해가 가능하므로 분해할 것
            var related = 0     //예를들어 {0, 1, 2} {3, 4}로 쪼개진 전표의 경우, 
                                // 첫번째 set은 1, 두번째 set은 2로 구분을 주고
                                // 이 구분자로 나중에 손익류 처리 등을 나누어서 처리할 수 있도록 함
                           
            for(var i in abc2){
            	related += 1;
                // maxval 결정하기
                var maxval = 0;
                var maxnum = 0;
                for(var i2 of abc2[i]){
                    if(Math.abs(this.grouparr[i2]["금액"]) > maxval){
                        maxval = Math.abs(this.grouparr[i2]["금액"]);
                        maxnum = i2; 
                    }
                }

                // 각 쪼개진 전표(solvearr) 만들기
                for(var i2 of abc2[i]){

                    if(i2 != maxnum){
                        // 작은쪽 값 집어넣기 
                        var temp = JSON.parse(JSON.stringify(this.grouparr[i2]));

                        temp["상대계정"] = this.grouparr[maxnum]["계정과목"];
                        temp["related"] = related
                        this.solvearr.push(temp);

                        // 큰쪽 값 쪼개서 집어넣기
                        var temp = JSON.parse(JSON.stringify(this.grouparr[maxnum]));
                        temp["상대계정"] = this.grouparr[i2]["계정과목"];
                        temp["related"] = related
                        temp["금액"] = -1 * this.grouparr[i2]["금액"];
                        this.solvearr.push(temp);

                    }
                }
            }  

            // 여기까지 오면 성공한 것임
            // 리턴값을 줘서, 성공할때의 구별된 로직을 구현토록 하자(execute4에서)
            this.execute_condition = "stop";
            if(this.successtestnum == 0){
                successtest[1].push(this.number);
            }
            return "success";
            
          }

         
    }
    
    execute5(){
        if(this.execute_condition == "stop"){
        	return;
        }
    	
    	this.solvearr = this.afterfail(this.grouparr, this.probmodel, this.smallval)
    	this.typenumber = 2;
    	successtest[4].push(this.number);
    }
    

    execute4(){
 
        if(this.execute_condition == "stop"){
        	return;
        }
    	
    	// 감누 1400 || 건물 2000
    	// 현금 1000 || 처분손익 400
    	// 이런것은 양빵 대응이 안되므로 포기하고 넘기게 됨
    	// 이 경우 감누 1400 이랑 건물 1400은 일단 grouparr에서 빼버리고 
        // execute를 실행함. 그 후 빼버린 것을 다시 합쳐줌
        
        // 일단 grouparr를 복제해두기 // 
        var grouparr_temp =  JSON.parse(JSON.stringify(this.grouparr));
        
    	var existence = 0;
        for(var i in this.grouparr){
        	var coa = this.grouparr[i]['계정과목'];
        	if('main' in this.sortedrealcoa[coa] == true){
        		var main = this.sortedrealcoa[coa]['main'];
        		for(var j in this.grouparr){
        			
        			if(this.grouparr[j]['계정과목'] == main){
        				// 이 경우, 차감계정과 메인계정이 같이 있는 상태임
        				// 차감계정을 0으로 만들면서 grouparr에서 빼주고, 그 숫자만큼 메인계정에서 더해줌
        				// 그리고 splitarr에 빼버린 차감계정과 그리고 더해준 메인계정을 복제해서 만들고 그 것들을 집어넣어줌
        			    existence = 1;
        				this.grouparr[j]['금액'] += this.grouparr[i]['금액'];  
        				var maincoa = JSON.parse(JSON.stringify(this.grouparr[j]));
        				
        				maincoa['금액'] = -1 * this.grouparr[i]['금액'];
        				var minuscoa = this.grouparr.splice(i, 1)[0];
        				minuscoa['상대계정'] = maincoa['계정과목'];
        				maincoa['상대계정'] = minuscoa['계정과목'];
        				
        				this.splitarr.push(minuscoa);
        				this.splitarr.push(maincoa);
        				console.log(this.grouparr)
        				
        			}
        		}
        	}
        }
        
        // 차감계정이 존재한 경우
        if(existence == 1){
        	this.successtestnum = 1
        	var result = this.execute();
        	if(result == "success"){
        		this.solvearr = this.solvearr.concat(this.splitarr);
        		this.execute_condition = "stop";
                successtest[3].push(this.number);
                
        	}
        }
        
        // grouparr 다시 복원시키기
        this.grouparr = grouparr_temp;
    
    }
    
    execute2(){
        if(this.execute_condition == "stop"){
        	return;
        }
    	
        if(this.typenumber > 0){
        	
            // prob적으로 가까운 것 count만큼 모아서, making하는 함수
            // 쪼개지긴 하는데 여러 경우가 발생하여, 이를 해결할 필요가 있는 경우
            
            
            this.making3(0, this.grouparr, []);

            if(this.typenumber == 1){
                var abc2 =  this.solvegroup;
                

                for(var i in abc2){
                    // maxval 결정하기
                    var maxval = 0;
                    var maxnum = 0;
                    for(var i2 in abc2[i]){
                    	
                        if(Math.abs(abc2[i][i2]["금액"]) > maxval){
                            maxval = Math.abs(abc2[i][i2]["금액"]);
                            maxnum = i2; 
                        }
                    }
                   
                    // 각 쪼개진 전표(solvearr) 만들기
                    for(var i2 in abc2[i]){
                    	
                        if(i2 != maxnum){
                            // 작은쪽 값 집어넣기 
                            var temp = JSON.parse(JSON.stringify(abc2[i][i2]));

                            temp["상대계정"] = abc2[i][maxnum]["계정과목"];
                            this.solvearr.push(temp);

                            // 큰쪽 값 쪼개서 집어넣기
                            var temp = JSON.parse(JSON.stringify(abc2[i][maxnum]));
                            temp["상대계정"] = abc2[i][i2]["계정과목"];
                            temp["금액"] = -1 * abc2[i][i2]["금액"];
                            this.solvearr.push(temp);
                            
                        }
                    }
                }
                successtest[2].push(this.number);
                this.execute_condition = "stop";
                
            }
                  
        }
        
    }
    
    
    // 3으로 표시되어 있으나, 이게 시작포인트임
    execute3(realcoa, 손익){
        if(this.execute_condition == "stop"){
        	return;
        }
    	
       // 손익계정으로만 된 것은 더 이상 분해하지 않고, 종료시킴    	
    	for(var i in this.grouparr){
    		var coa = this.grouparr[i]["계정과목"];
    		if(realcoa[coa]["분류1"] in 손익 == false){
    			return
    		} 
    	}
        successtest[0].push(this.number);
        this.execute_condition = "stop";
    }
    
    
    
    execute_incometype(realcoa , middlecoa){
    	// 손익류 || 현금 처리를 다른 것으로 처리해야함
    	
    	
    	for(var i in this.solvearr){
    	    var coa = this.solvearr[i]["계정과목"];
		    var relatedcoa = this.solvearr[i]["상대계정"];
		    var relatedarr = this.find_relativeaccount(coa, i);
		    var 분류2 = middlecoa[realcoa[coa]['분류2']]['분류2']
		    var 분류2_relate = middlecoa[realcoa[relatedcoa]['분류2']]['분류2']
		    
    		if(realcoa[coa]["분류1"] == "현금흐름이 없는 손익" && 분류2_relate == "현금" ){
    			// 이런 경우 상대계정이 현금류이면 해당계정과 가장 유사한 계정으로 바꿔치기 해줘야함
                console.log("발생함");
    			this.incometype_afterwork(i, {"현금": 0}, realcoa, middlecoa);
    		}
    		
    		if(realcoa[coa]["분류1"] == "처분손익" && 
    			(분류2_relate == "현금"  || 분류2_relate == "중간")){
    			// 이런 경우 상대계정이 현금 또는 중간류이면 바꿔치기 해줘야함
                console.log("발생함");
    			this.incometype_afterwork(i, {"현금": 0, "중간": 0},realcoa,  middlecoa);
    		}
    	}
    	
    }
    
    incometype_afterwork(i, hash, realcoa, middlecoa){

    	    var coa = this.solvearr[i]["계정과목"];
		    var relatedcoa = this.solvearr[i]["상대계정"];
		    var relatedarr = this.find_relativeaccount(coa, i);
		    var 차변대변 = this.solvearr[i]["금액"] > 0 ? "차변" : "대변"
		    var prob = 0;
			var selection = ""; // 찾을 유사계정을 의미함
			for(var j in this.solvearr){
			 
			  if(this.solvearr[i]['related'] == this.solvearr[j]['related'] && 
					  middlecoa[realcoa[this.solvearr[j]['계정과목']]["분류2"]]["분류2"] in hash == false){
  		    	var prob_temp = this.probcal(coa, this.solvearr[j]['계정과목'], 차변대변);
  		    	console.log(this.probmodel)
		        if(prob_temp > prob){
		        	prob = prob_temp;
		        	
		        	selection = this.solvearr[j]['계정과목'];
		        }
				  
			  }	
			}
			
			// 유사계정을 못찾은 경우 전체 prob에서 가장 큰 값으로 선택해야 함
			
			if(selection == ""){
				for(var i in this.probmodel[coa][차변대변]){
					var val = 0;
					if(i != "total"){
						var val_temp = this.probmodel[coa][차변대변][i];
						if(val_temp > val){
							val = val_temp;
							selection = i;
						}
					}
				}
				
			}
			console.log(selection)
			
			// 새전표생성 두개(유사계정 + -) 생성해서 solvearr에 집어넣기
			
			var similar1 = JSON.parse(JSON.stringify(relatedarr));
			console.log("relatedarr:" + similar1["계정과목"] + "^" + similar1["상대계정"])
			similar1["계정과목"] = selection
			var similar2 = JSON.parse(JSON.stringify(this.solvearr[i]));
			console.log("realarr:" + similar2["계정과목"] + "^" + similar2["상대계정"])
			similar2["계정과목"] = selection
			
			this.solvearr.push(similar1);
			this.solvearr.push(similar2);
			
			// 상대계정 유사계정으로 바꾸기 두개
			relatedarr['상대계정'] = selection;
			this.solvearr[i]['상대계정'] = selection;    	
    }
    
    find_relativeaccount(arr, i){

    	var coa = this.solvearr[i]["계정과목"];
    	var related = this.solvearr[i]["related"];
    	var relative = this.solvearr[i]["상대계정"];
    	
    	for(var j in this.solvearr){
    		if(this.solvearr[j]['계정과목'] == relative && this.solvearr[j]['related'] == related){
    			if(this.solvearr[j]['금액'] == -1 * this.solvearr[i]['금액']){
                    console.log("있는데");
    				return this.solvearr[j];
    				
    			}
    		}
    		
    	}
    }
    
    
    coagrouping(){
    	// 계정번호 같은 것을 그룹핑하기 위해서 만들었음
    	var arr = {}
        for(var i in this.mainarr){
        	var 계정과목 = this.mainarr[i]["계정과목"];
        	if(계정과목 in arr){
        		// 금액 합치기
        		arr[계정과목]["금액"] += this.mainarr[i]["금액"];
        		
        		// ref 반영할 것
        		arr[계정과목]["ref"].push(i)
        		// 나중에 비고 반영할 것
        		
        	}else{
        		
        		arr[계정과목] = {};
        		// 금액 넣기
        		arr[계정과목]["금액"] = this.mainarr[i]["금액"];
        		
        		// ref 반영할 것
        		arr[계정과목]["ref"] = [i]

        		// 전표번호 및 계정과목
        		arr[계정과목]["계정과목"] = 계정과목
        		arr[계정과목]["전표번호"] = this.mainarr[i]["전표번호"];
        		arr[계정과목]["related"] = 0;
        		// 나중에 비고 반영할 것
        		
        		
        	}

        }
    	
    	this.grouparr = Object.values(arr);
    	
    }
    
    

  // 군집화하기 // 현재는 버려진 함수임
  grouping = (arr, count) => {
      
      // 처음에 군집개수만큼 순차적으로 group에 집어넣음
      var group = [];

      for(var j = 0; j < count; j++){
          var temp = []
          for(var i = 0; i < Math.floor(arr.length/count); i++){
             temp.push(arr[i])
          }
          group.push(temp)
      }

      for(var i in group){
          // 해당 그룹의 그룹확률 계산하기
          group[i].probsum = 0;
          for(var j in group[i]){
              for(var k in group[i]){
                if(j != k){
                   var probval1 = this.probcal(group[i][j][1], group[i][k][1]);
                   var probval2 = this.probcal(group[i][k][1], group[i][j][1]);
                   var probval = (probval1 + probval2)/2;
                }  
                group[i].probsum += probval;
             }
          }
      }  


      for(var i in group){

          for(var item_i in group[i]){

              // 1. 먼저 해당 그룹안에서 해당 item의 확률값 계산하기
              var probval_i = 0;
              for(var item in group[i]){

                  if(item_i != item){
                      var probval1 = this.probcal(group[i][item_i][1], group[i][item][1]);
                      var probval2 = this.probcal(group[i][item][1], group[i][item_i][1]);
                      probval_i += (probval1 + probval2)/2; 
                  }
              }

              probval_i = probval_i/group[i].length;

              //해당 아이템이 다른 group으로 바뀌는 것이 좋은지 계산하기
              // 2. 다른 그룹안에서 해당 item의 확률값 계산하기
              
              var sel = 0; 
              var probsum = 0;
              for(var j in group){
                 
                if(this.equal(group[i], group[j]) == false){
                   
                   var probsum_j = 0;
                   for(var item_j in group[j]){
                       var probval1 = this.probcal(group[j][item_j][1], group[i][item_i][1]);
                       var probval2 = this.probcal(group[i][item_i][1], group[j][item_j][1]);
                       var probval_j = (probval1 + probval2)/2; 
                       probsum_j += probval_j;          
                   }
                   // 그룹별로 돌려봐서, 제일 큰 그룹뽑기
                     probsum_j = probsum_j/group[j].length; 
                     if(probsum_j > probsum){
                         sel = j;
                         probsum = probsum_j
                     }
                 } 
             }

 
          }
      }  


  }

  // 현재는 차변, 대변 평균이나, 차변만, 대변만 옵션들 추가해야 할듯 
  probcal = (a, b, opt) => {

      var prob = this.smallval
      
      if(opt == "차변"){
         prob = b in this.probmodel[a]['차변'] ? this.probmodel[a]['차변'][b]/this.probmodel[a]['차변']["total"] : this.smallval;
      }else if(opt == "대변"){
         prob = b in this.probmodel[a]['대변'] ? this.probmodel[a]['대변'][b]/this.probmodel[a]['대변']["total"] : this.smallval;
      }else{
         var 차변 = b in this.probmodel[a]['차변'] ? this.probmodel[a]['차변'][b]/this.probmodel[a]['차변']["total"] : this.smallval;
         var 대변 = b in this.probmodel[a]['대변'] ? this.probmodel[a]['대변'][b]/this.probmodel[a]['대변']["total"] : this.smallval;
         prob = (차변 + 대변)/(this.probmodel[a]['차변']["total"] + this.probmodel[a]['대변']["total"]);

      }
      

      return prob;
  }

 // 확률값 계산
 probcal_count(arr){
	 
	 // 전체에서 사건 등을 뽑을 확율을 사실 항아리속에서 여러 모양의 주사위를 뽑는 것과 동일함
	 // 그 가정하에서 결국 그 case가 얼마나 발생했느냐로 계산함
	 // 다만, case가 없는 것들은 각 갯수만큼 smallval로 처리함
	 
	 for(var i in this.countmodel){
		 if(this.equal(this.countmodel[i].type, arr) == true){
			 
			 return this.countmodel[i].count * this.smallval;
		 }
	 }
	 
	 var prob = 1;
	 for(var i of arr){
		 prob *= this.smallval;
	 }
	 
	 return prob;
 }
 
 
 
 
 probcal_ind = (arr) => {
      // 조건부 독립은 아닐테지만, 조건부 독립을 가정하여, 확률값 계산
      // P(a,b,c,d ......) = P(b, c, d, ......|a) * P(a)
      // P(a)는 이미 발생했다고 가정하면 = P(b, c, d, ......|a) = P(b|a) * P(c|a) * P(d|a) .........
      
      var prob = 0;
      for(var i in arr){
          
          // i란 사건이 이미 발생했다고 가정함
          var temp = 1;
          var opt = arr[i]["금액"] > 0 ? "차변" : "대변";   

          for(var j in arr){
             if(i != j){
                 temp = temp * this.probcal(arr[i]["계정과목"], arr[j]["계정과목"], opt)
                 
             }

          }
          
          // 특정 i가 일어났을때, 확률값이 최대값인 것을 뽑음
          if(temp > prob){
              prob = temp;
          }
      }
       
       return prob; 
 }

  // 이 함수 일단 버림// 확률적으로 맞는것 같지 않음
  probcal_mul = (arr) => {
      
      // arr 안에 있는 각 확률 중에서 가장 높은 확률의 항목들끼리 곱함
      // 각 항목 중에서 가장 높은 확률이 그 항목끼리 이어진 확률이라고 생각이 듬
      var prob = 1;
      for(var i = 0; i < arr.length; i++){
        
        var thisprob = 0;  
        for(var j = 0; j < arr.length; j++){
           if(i =! j){
             var a = this.probcal(arr[i]["계정과목"], arr[j]["계정과목"]);
             var b = this.probcal(arr[j]["계정과목"], arr[i]["계정과목"]);
             var temp = Math.max(a, b); 

             if(temp > thisprob){
                 thisprob = temp;
             } 
           }  
       
             
        }

        prob = prob * thisprob;  
      }

      return prob;

  }
 

 

 // 이것을 현재는 사용하지 않음. 확률적으로 맞는 것 같지 않음 
 // 확률거리를 계산하기 위한 함수 
 probdistcal = () => {
      
      // 이미 한 계정으로 아래 함수 잘 돌아가는 것 확인했으나,
      // this.coaarray로는 확인이 안되었으니, 이것만 확인하면 됨
      
      for(var a of this.coaarray){
         var arr = {};     // 계정별로 {거리, 이전계정, 통과여부} 이렇게 arr를 구성함
         arr[a] = {거리: 1};

         // 모든 가능한 것을 다 돌려보면 비효율이므로 5번까지만 일단 돌려봄
         for(var i = 0; i < 5; i++){
              arr = this.findpath(arr);
         }
         this.probdistarray[a] = arr    
      }
 }

  findpath = (arr) => {
     
    for(var a in arr){ 

       var possiblearr = Object.keys(this.probmodel[a]["차변"]).concat(Object.keys(this.probmodel[a]["대변"]))
       var possiblearr = new Set(possiblearr);
       // 전체 거리 배열 만들기
       for(var i of possiblearr){
           if(i != "total"){
               

               var dist = arr[a]["거리"] * Math.max(this.probcal(a, i), this.probcal(i, a))

               if(i in arr){
                   // 확률이 더 높아지는지 보고 더 높아지면 숫자를 바꿔끼울것
                   if(dist > arr[i]["거리"]){
                       arr[i]["거리"] = dist;
                   }
               }else{
                   
                   arr[i] = {거리: dist, 이전계정: a, 통과여부: 0}
               }
           }
       }
     }
       
     return arr;
  }

  // 확률상 높은 계정들만 모아서, making함수 실행하기
  // 이것도 현재 버려진 함수임
  probmaking = (arr, current, count) => {
         
         var realarr = [];
         // 순환하면서, 현재 이 계정과 가장 확률이 높은 계정들 count만큼 뽑아내기 
         for(var i = 0; i < arr.length; i++){

             var probval = Math.max(this.probcal(current[i][1], arr[i][1]), this.probcal(arr[i][1], current[i][1]));
             //확률이 더 크면 arr에 추가시킬것
             if(realarr[realarr.length - 1].prob < probval){
                 if(realarr.length >= count){
                     realarr.pop();
                 }

                 var temp = arr[i].slice();
                 temp.prob = probval;
                 realarr.push(temp);

                 // 정렬하기
                 realarr.sort((a, b)=>{

                 if (a.prob > b.prob) {
                     return 1;
                 }
                 if (a.prob < b.prob) {
                     return -1;
                 }
                 // a must be equal to b
                 return 0;
                 })

             } 
         }
         
         
 
  }

  afterfail = (arr,prob,valsmall) => {

/*
##### making을 통해서 원장을 명확히 매핑시키지 못한경우
##### 계정별 확률분포를 통해 원장을 매핑시킴
##### 발생확률이 없는 경우 최소값으로 valsmall(값은 변경가능)을 사용함
##### ab는 값이 0보다 큰 값들(차변)을 집어넣고
##### cd는 값이 0보다 작은것을 집어넣음
##### ab는 행, cd는 열로 보고 행에서 열로 대응되는 확률값을 계산함
##### [100,건물],[-100,현금],[100,미수수익],[-100,이자수익]이 있다면
##### 회계를 조금만 알아도 건물과 현금이 매핑되고, 미수수익과 이자수익이 매핑되는 것을 알지만, 컴퓨터는 그러지 못함

#####               현금       이자수익
#####  건물         확률값1     확률값2       
#####  미수수익     확률값3     확률값4
##### 
#####  
#####               현금       이자수익
#####  건물         금액1       금액2       
#####  미수수익     금액3       금액4

#####  금액1+금액3=100,금액2+금액4=100, 금액1+금액2=100, 금액2+금액4=100이며
#####  금액1*확률값1+금액2*확률값2+금액3*확률값3+금액4*확률값4가 최대가 되도록 반복계산을 수행하여,
#####  계정을 매핑시킴, 확률분포에 건물이 이자수익보다 현금에 보다 확률이 높기때문에,
#####  건물과 현금이 매핑되고, 미수수익과 이자수익이 매핑되는 결과가 도출이 됨
*/

    
    
    var ab = [];
    var cd = [];
    var abcd = [];
    for(var i in arr){
        if(arr[i]["금액"] > 0){
            ab.push([Math.abs(arr[i]["금액"]),arr[i]["계정과목"], arr[i]["ref"]])
        }else{
            cd.push([Math.abs(arr[i]["금액"]),arr[i]["계정과목"], arr[i]["ref"]])
        }
    }
    
    var arrprob = [];
    
    for(var i in ab){
        var test = []
        for(var j in cd){
            if(cd[j][1] in prob[ab[i][1]]['차변']){
                var val1 = prob[ab[i][1]]['차변'][cd[j][1]]/prob[ab[i][1]]['차변']['total']
            	
            	// 만약에 차감형 계정이라면 관련 거래가 없었어도 이건 충분히 확률을 높여줘야함
                val1 = this.cal_relatedcoa(ab[i][1], cd[j][1], val1)            	
            }else{
                var val1=valsmall
                val1 = this.cal_relatedcoa(ab[i][1], cd[j][1], val1)            	
 
            }

            if(ab[i][1] in prob[cd[j][1]]['대변']){
                var val2=prob[cd[j][1]]['대변'][ab[i][1]]/prob[cd[j][1]]['대변']['total']
                val2 = this.cal_relatedcoa(ab[i][1], cd[j][1], val2)            	

            
            }else{
                var val2=valsmall
                val2 = this.cal_relatedcoa(ab[i][1], cd[j][1], val2)            	

            }
            var val = Math.max(val1,val2)
            test.push(val)
        }    
        arrprob.push(test)
    }
    
    var coavalue = []
    var sumval = 0
    for(var j in cd){
        sumval = sumval + cd[j][0]
    }
        
    // 최초시점에는 확률분포를 고려하지않고 금액비율로 값을 배분시킴
    
    for(var i in ab){
        test=[]
        for(var j in cd){
            val=cd[j][0]/sumval*ab[i][0]
            test.push(val)
        }
        coavalue.push(test)
    }

/*
    # 확률분포를 사용하여 값을 다시 분배시킴 
    # 행렬을 가정한다면 계정별금액 자체는 변동하지 않으므로
    # 계정별 배분할 금액이 변동한다면 원소 (i1,j1),(i2,j2) 원소 (i1,j2),(i2,j1)의 금액은 동일하게 변동하게 됨
    # 이 성질을 이용해 원소 (i1,j1),(i2,j2) 원소 (i1,j2),(i2,j1) 확률값 합계를 비교해서 더 큰쪽으로 금액을 배분시킴
*/
    
    for(var i1 = 0; i1 < ab.length; i1++){
        for(var j1 = 0; j1 < cd.length; j1++){
            for(var i2 = 0; i2 < ab.length; i2++){
                for(var j2 = 0; j2 < cd.length; j2++){
                    if(i1 != i2 && j1 != j2){
                        val1 = arrprob[i1][j1]+arrprob[i2][j2]
                        val2 = arrprob[i2][j1]+arrprob[i1][j2]
                        
                        if(val1 > val2){
                            var val3 = Math.min(coavalue[i2][j1],coavalue[i1][j2])
                            coavalue[i1][j1]=coavalue[i1][j1]+val3
                            coavalue[i2][j2]=coavalue[i2][j2]+val3
                            coavalue[i2][j1]=coavalue[i2][j1]-val3
                            coavalue[i1][j2]=coavalue[i1][j2]-val3
                        }else{
                            var val3 = Math.min(coavalue[i1][j1],coavalue[i2][j2])
                            coavalue[i1][j1]=coavalue[i1][j1]-val3
                            coavalue[i2][j2]=coavalue[i2][j2]-val3
                            coavalue[i2][j1]=coavalue[i2][j1]+val3
                            coavalue[i1][j2]=coavalue[i1][j2]+val3
                        }
                      }
                   }
           }
       }
    }                        
    // array make
    var realarr=[]

    for(var i1 = 0; i1 < ab.length; i1++){
        for(var j1 = 0; j1 < cd.length; j1++){
            if(coavalue[i1][j1] > 0){
                realarr.push({전표번호: this.number*1, 금액: Math.round(coavalue[i1][j1]),계정과목: ab[i1][1], 상대계정: cd[j1][1], ref: ab[i1][2]})
                realarr.push({전표번호: this.number*1, 금액: -Math.round(coavalue[i1][j1]),계정과목: cd[j1][1], 상대계정: ab[i1][1], ref: cd[j1][2]})
                
            }
        }
    }
    
    
    return realarr

}



   cal_relatedcoa(coa1, coa2, val){
	 
	   // 실제 prob의 확률과 다르게, 임의로 확률수치르 보정함
	   // 사건이 발생하지 않아서 그렇지, 자산과 그에 대한 차감계정은 높은 확률 관계가 있는 것이므로
	 if(coa1 in this.sortedrealcoa){  
     	if('main' in this.sortedrealcoa[coa1]){
    	    if(this.sortedrealcoa[coa1]['main'] == coa2){
	            return Math.max(val, this.valrelated)	
    	    }
	    }
	 }
	 if(coa2 in this.sortedrealcoa){  
	     	if('main' in this.sortedrealcoa[coa2]){
	    	    if(this.sortedrealcoa[coa2]['main'] == coa1){
		            return Math.max(val, this.valrelated)	
	    	    }
		    }
		 }
	 
	 return val
   }





    //^^ 확률관련 함수들
    makeprob = (prob2) => {

/*
#### 원장(arrma)을 가져와서 이 원장을 원장번호가 일치하는 것으로 분리함
#### 이 분리된 원장을 arr3에 집어넣고, 
#### making(하단 함수에 내용참고)이란 함수를 실행함. making실행후
#### 리턴값을 erase함수(하단 함수에 내용참고)에 집어넣고 
#### 나온 리턴값으로 확률모델을 생성함
*/    

// 원장은 전표번호별로 이미 분리되었기 때문에, 저 아래만 사용함

/*            
###### 하단은 확률모델
###### 회계의 전표의 특징은 무조건 합계가 0이 되어야함. 그리고 값이 0보다 큰것은 차변, 0보다 작은것은 대변으로 분류
###### 미수이자 300   
###### 이자수익 -300 
###### 이라는 전표가 있다면, 확률모델은 다음과 같이 됨
###### {미수이자:{차변:{'total':1,'이자수익':1}},이자수익:{'대변':{'total':1,'미수이자':1}}}
###### 이 후 다음과 같은  전표가 추가로 발생한다면
###### 미수이자 -300
###### 현금     300
###### 이라는 전표가 만들어지면서 미수이자가 사라지고 현금이 들어오게 된다는 의미이며, 확률모델은
###### {미수이자:{차변:{'total':1,'이자수익':1},대변:{'total':1,'현금':1}},
######  이자수익:{'대변':{'total':1,'미수이자':1}},현금:{'차변':{'total':1,'미수이자':1}}}
*/        
        
        var arr3 = this.grouparr;   
        var abc = this.making(0, arr3)
        
        
        // 2가 아닐때는 성공이기 때문에 prob에 반영함
        if(abc[1] != 2){
            var abc2 = this.erase(abc[0])
            
            for(var i in abc2){
                for(var i2 of abc2[i]){
                    for(var i3 of abc2[i]){
                        if(abc2[i2] != abc2[i3]){
                            
                            if(arr3[i2]["금액"] > 0){
                
                                prob2[arr3[i2]["계정과목"]]["차변"]["total"] = prob2[arr3[i2]["계정과목"]]["차변"]["total"] + 1
                                if(arr3[i3]["계정과목"] in prob2[arr3[i2]["계정과목"]]["차변"]){
                                    prob2[arr3[i2]["계정과목"]]["차변"][arr3[i3]["계정과목"]] = prob2[arr3[i2]["계정과목"]]["차변"][arr3[i3]["계정과목"]]+1
                                }else{
                                    prob2[arr3[i2]["계정과목"]]["차변"][arr3[i3]["계정과목"]] = 1
                                }

                            }else{
                                prob2[arr3[i2]["계정과목"]]["대변"]["total"] = prob2[arr3[i2]["계정과목"]]["대변"]["total"]+1
                                if(arr3[i3]["계정과목"] in prob2[arr3[i2]["계정과목"]]["대변"]){
                                    prob2[arr3[i2]["계정과목"]]["대변"][arr3[i3]["계정과목"]] = prob2[arr3[i2]["계정과목"]]["대변"][arr3[i3]["계정과목"]]+1
                                }else{
                                    prob2[arr3[i2]["계정과목"]]["대변"][arr3[i3]["계정과목"]] = 1
                                }
                            }
                        }
                    }
                }
            }
        }

        return prob2;
    }                            
    


  오류검증 = (arr3) => {

    var arr = [];    
    var prob = {};
    for(var i in arr3){
        if(i[1] in prob){
            prob[i[1]] = prob[i[1]] + i[0];
        }else{
            prob[i[1]] = i[0];
        }
    }

    for(var i in prob){
      if(prob[i] != 0){
        arr.push([prob[i],i])
      }  
    }
        
    return arr
  }
  
  

    //^^ 거래를 쪼개는 함수들
  
    
  making_func(arr){
  	
      var time = new Date().getTime()
       this.realcount = 0
		for(var i = 0; i < arr.length; i++){
  		this.making_repeat(arr, [], i, 0)
  	}
  	
      var time = new Date().getTime()
 
  }
  
  making_repeat(arr, temp, count, num){
     
  	for(var i = num; i < arr.length; i++){
  		if(temp.length < count){
  			var im= temp.slice();
  			im.push(i)
  			this.making_repeat(arr, im, count, i + 1);
  		}
  	}
  	
  	if(temp.length == count){
      	//console.log(temp);
  		this.realcount += 1
  	}
  	
		
  }
    
    
    making = (s1, arr) => {

       var 합=[0]
       var 합1=[0,0,0,0,0,0]
       var im=[0]
       var 합계=[0]
       var 진짜배열=[]
       var n = arr.length;
       var mm=0
       var result=[]
       
       var i=0
       var 실패=0
       var 지속=0
       
       합계[0]=s1
       if(arr.length > this.makingcounter){
            실패 = 20    //실패를 20은 숫자초과로 행렬곱으로 계산해야하는 것들
                      // 10은 나머지인데 확률카운터로 한번 더 걸러냄
                      // 손익만 있는 거래는 이것을 하지 않음
        }

    while(im[0] < n-1){

        for(var ii = im[i]; ii < n; ii++){
                         합[0] = 합1[0] + arr[ii]["금액"]
                         지속 = 지속 + 1
           
            // 아래 같다로 바꾸어도 문제없음
            if(합계[0] < 합[0]+ 1 && 합계[0] > 합[0] - 1){
                im[i] = ii
                
                // alert succeed

                var imcopy = new Set(im);
                result.push(imcopy)
                 var ars = this.erase(result.slice())
                ars = this.failsure(ars,arr)
                result = ars[1].slice()
                
                // if fail then, 실패 ==1
                if(ars[0] == 1){
                	console.log("실패임")
                    실패 = 10
                    break
                }
            }


                if(ii == n-1){
                	
                    im.splice(i, 1)
                    
                    i = i - 1
                    if(i < 0){
                        실패 = 11
                        break
                     }

                    im[i] = im[i] + 1
                    
                    if(i > 0){
                        합1[0] = 0
                        for(var kk = 0; kk < i; kk++){
                            합1[0] = 합1[0] + arr[im[kk]]["금액"];
                        }

                    }else{
                        합1[0]=0
                    }
                    break
                }else{
                    im[i] = ii
                    
                    i=i+1
                    im.push(ii + 1)
                    

                    합1[0]=합[0]
                    break
                }

            
         } // 첫번째 for 문 닫기
         
         if(실패 >= 1){
           break
         } 

       } // while 문 끝
       

       return [result,실패];
        
    }
     
    // 50의 합이 100인데, 5개 이하 등의 갯수의 제한을 둬서 그 갯수의 합이 100인 것을 찾도록
    // 갯수의 제한을 두는 함수
    // 즉 50개에서 빼가면서 쪼개가는 것임
    // 어떻게 순환하면서 처리할지 좀 더 고민해볼 것 
    making2 = (s1, arr, count) => {

       var 합=[0]
       var 합1=[0,0,0,0,0,0]
       var im=[0]
       var 합계=[0]
       var 진짜배열=[]
       var n = arr.length;
       var mm=0
       var result=[]
       
       var i=0
       var 실패=0
       var 지속=0
       
       합계[0]=s1
       if(arr.length > this.makingcounter){
           실패 = 20    //실패를 20은 숫자초과로 행렬곱으로 계산해야하는 것들
                     // 10은 나머지인데 확률카운터로 한번 더 걸러냄
                     // 손익만 있는 거래는 이것을 하지 않음
       }

    while(im[0] < n-1){

        for(var ii = im[i]; ii < n; ii++){
            합[0] = 합1[0] + arr[ii]["금액"]
            지속 = 지속 + 1
          
            // 아래 같다로 바꾸어도 문제없음
            if(합계[0] < 합[0]+ 1 && 합계[0] > 합[0] - 1){
                im[i] = ii
                // alert succeed

                result.push(im.slice());
                
            }

            //[[13], [-5], [24], [-8], [21]]

             
            // 아래도 -0.3 빼고 <=로 바꿔도 문제없음         
          
                
                if(ii == n-1){
                    im.splice(i, 1)

                    i = i - 1
                    if(i < 0){
                        실패 = 1
                        break
                     }

                    im[i] = im[i] + 1
                    if(i > 0){
                        합1[0] = 0
                        for(var kk = 0; kk < i; kk++){
                            합1[0] = 합1[0] + arr[im[kk]]["금액"];
                        }

                    }else{
                        합1[0]=0
                    }

                    break
                }else if(im.length >= count){

                   //making2는 여기가 새로 추가 되었음
                   // im개수가 count를 초과하면 그냥 다음 숫자로 넘길 것
                   

                    
                }else{
                    im[i] = ii
                    i=i+1
                    im.push(ii + 1)
                    합1[0]=합[0]
                    break
                }
           
                   
    
         } // 첫번째 for 문 닫기


       } // while 문 끝
       

       return result;
        
    }

    // 숫자는 쪼개지는데, 다양한 경우의 수가 나올경우, 가장 높은 확률
    making3 = (s1, arr, result) => {
            
       

       var 합=[0]
       var 합1=[0,0,0,0,0,0]
       var im=[0]
       var 합계=[0]
       var 진짜배열=[]
       var n = arr.length;
       var mm=0
       
       var i = 0
       var 실패 = 0
       var 지속 = 0
       
       합계[0] = s1
       if(arr.length > this.makingcounter){
           실패 = 20    //실패를 20은 숫자초과로 행렬곱으로 계산해야하는 것들
                     // 10은 나머지인데 확률카운터로 한번 더 걸러냄
                     // 손익만 있는 거래는 이것을 하지 않음
       }

    while(im[0] < n-1){

        for(var ii = im[i]; ii < n; ii++){
                          합[0] = 합1[0] + arr[ii]["금액"]
                          지속 = 지속 + 1
           
            // 아래 같다로 바꾸어도 문제없음
            // 이 부분이 성공영역이고 여기서 대부분 컨트롤
            if(합계[0] < 합[0]+ 1 && 합계[0] > 합[0] - 1){

                im[i] = ii
                // alert succeed
                var temp = [];
                var imcopy = im.slice().sort().reverse();
                
                
                var arrcopy = arr.slice();
                
                for(var sa in imcopy){
                    temp.push(arrcopy.splice(imcopy[sa], 1).pop());
                }
                var deepresult = result.slice();
                deepresult.push(temp)

                if(arrcopy.length > 0){
                   this.making3(s1, arrcopy, deepresult)
            
                }else{
                    // 여기서 최고 높은 가능한 거래로 쪼개는 것을 남기는 것임
                    
                    var deepnodeprob = 1;
                    for(var pro1 in deepresult){

                    	var 차변 = 0;
                        var 대변 = 0;
                   	
                    	// 먼저 확률값 계산하기
                    	var temp = new Set([]);
                    	for(var a in deepresult[pro1]) {
                    		temp.add(deepresult[pro1][a]["계정과목"]);

                    		// 다음으로 차변, 대변이 하나만 있어야함. 그래야지 나머지 항목을 무조건적으로 귀속시키므로
                        	if(deepresult[pro1][a]["금액"] > 0){
                        		차변 += 1;
                        	}else{
                        		대변 += 1;
                        	}

                    	}
                    	deepnodeprob *= this.probcal_count(temp);
                        // 쪼개진 거래는 한쪽의 합계가 무조건 나머지 합계전체와 같아야함
                        var calcul = 0;
                        if(차변 == 1 || 대변 == 1){
                        	calcul = 1;
                        }
                    	
                    }
                    
                    if(this.deepnodeprob < deepnodeprob && calcul == 1){
                        this.deepnodeprob = deepnodeprob;
                        this.solvegroup = deepresult.slice()
                        this.typenumber = 1;
                    }

                    /* probcal_ind 방식으로 갈지 probcal_count로 갈 지 고민할 것
                    var deepnodeprob = 1;
                    for(var pro1 in deepresult){

                    	deepnodeprob = deepnodeprob * this.probcal_ind(deepresult[pro1]);
                    }

                    if(this.deepnodeprob < deepnodeprob){
                        this.deepnodeprob = deepnodeprob;
                        this.deepresult = deepresult.slice()
                    }
                    
                    */
                    
                }

            }

 
                
                if(ii == n-1){
                    im.splice(i, 1);

                    i = i - 1
                    if(i < 0){
                        실패 = 1
                        break
                     }

                    im[i] = im[i] + 1
                    if(i > 0){
                        합1[0] = 0
                        for(var kk = 0; kk < i; kk++){
                            합1[0] = 합1[0] + arr[im[kk]]["금액"];
                        }

                    }else{
                        합1[0]=0
                    }

                    break
            //    }else if(im.length >= count){

                   //making2는 여기가 새로 추가 되었음
                   // im개수가 count를 초과하면 그냥 다음 숫자로 넘길 것
                                       
                }else{
                    im[i] = ii
                    i=i+1
                    im.push(ii + 1)
                    합1[0]=합[0]
                    break
                }
            
                   
    
         } // 첫번째 for 문 닫기

         if(실패 >= 1){
           break
         } 

       } // while 문 끝
       

       
        
    }


  equal = (as, bs) => {
    if (as.size !== bs.size) return false;
    for (var a of as) if (!bs.has(a)) return false;
    return true;
   }


   erase = (abc) => {
     /*
#### making이란 함수를 통해 리턴된 값이 유일한 값인지를 검토함
#### 건물 100      0
#### 현금 -100     1
#### 기계 200      2
#### 현금 -200     3  이란 전표 
#### [[건물,100],[현금,-100],[기계,200],[현금,-200]]의 making의 리턴값은
#### {0,1},{2,3},{0,1,2,3}이 되었을 것임(합계가 0인되는 모든 경우를 계산하는 함수,
#### {0,1}=> 100+(-100)=0,{2,3}=> 200+(-200)=0,{0,1,2,3}=> 100-100+200-200=0)
#### 이 각각의 원소가 더 큰 원소에 포함될때 교집할을 계산하면 위의 상황은
#### {0,1},{2,3},{0,1}가 되고, 동일한 원소를 지워서 {0,1},{2,3}을 리턴시킴
     */
    var k1 = 0;

    for(var i = 0; i < abc.length; i++){
        var k2 = 0
        for(var j = 0; j < abc.length ; j++){

            if(k1 != k2){ 

                if(abc[i].size > abc[j].size && this.equal(abc[j], new Set([...abc[i]].filter(x => abc[j].has(x))))){
                    abc[k1] = new Set([...abc[i]].filter(x => !abc[j].has(x)));
                    break
                }    
            }
            k2 = k2 + 1
        }    
        k1 = k1 + 1
    }

    var erasing=[]
    k1=0
    for(var i = 0; i < abc.length; i++){

        k2 = 0;
        for(var j = 0; j < abc.length; j++){
            if(k1 != k2){
                if(this.equal(abc[i], abc[j])){
                    erasing.push(Math.min(k2,k1))
                }
            }
            k2=k2+1        
        }
        k1=k1+1
    }
    erasing = new Set(erasing)
    erasing = [...erasing]
    erasing.reverse()  
    
    for(var i = 0; i < erasing.length; i++){
        abc.splice(erasing[i], 1)
    }
    
    
    
    for(var i = 0; i < abc.length; i++){
        if(abc[i].length == 0){
            abc.remove(i)
            break
        }
    }
    return abc     

   }


 failsure = (abc,arr) => {
/*    
### erase함수를 통과후 쪼개진 값들이 유일한 값인지 확인하기 위해서 실행하는 함수
### [-100,100,-50,50,200,-200]이란 원장의 값이 있을때
### {0,1,2,3},{2,3,4,5}가 abc란 데이터로 failsure함수에 입력되었다고 가정한다면
### 교집합으로 이 데이터를 쪼개면 {0,1},{2,3},{4,5}로 쪼개짐
### 교집합인 {2,3}의 합이 0이면 원래 데이터의 합도 0이었기 때문에 
### {0,1},{2,3},{4,5}의 합도 모두 0이되고 원장이 이렇게 분리가 되게됨
### 그러나 값이 [-100,150,-100,50,250,-200,-50] 인 경우에는 
### {2,3}의 합이 0이 아니므로 {0,1},{2,3},{4,5} 이렇게 쪼개지 못하며
### 이럴경우 {0,1,2,3,4,5} 전체를 최소단위로 나눌수 없게됨
### 이런경우 원소 0과 1이 대응되는지 원소 0과 2가 대응되는지 알수 없으므로,
### fail값 1을 리턴시키고 확률모형을 돌려서 원소를 다른 원소에 대응을 시키게 됨
### 다만 이런 경우라도 [500,-100,-100,-100,-100,-100] 이런 상황은
### 원소 0과 원소 1,2,3,4,5가 대응되는 것은 명확하므로 대응을 시키게 됨
*/  
    
    var fail=0
    var k1 = 0
    var newreal=[]
    
    
    for(var i = 0; i < abc.length; i++){
        var k2 = 0
        for(var j = 0; j < abc.length; j++){
            if(!this.equal(abc[i], abc[j])){
                   
              if([...abc[i]].filter(x => abc[j].has(x)).length > 0){
                    
                    var new1 = new Set([...abc[i]].filter(x => abc[j].has(x)))
                    var new2 = new Set([...abc[i]].filter(x => !abc[j].has(x)))
                    var new3 = new Set([...abc[j]].filter(x => !abc[i].has(x)))
                    var 합계 = 0
                    
                    for(var ij of new1){
                                                       합계 = 합계 + arr[ij]["금액"]
                    }
                   
                    if(합계 == 0){
                        
                        newreal.push(new1)
                        newreal.push(new2)
                        newreal.push(new3)
                    }else{
                        fail = 1
                        break
                    }
                }
            }
         }               
    }  
    for(var i = 0; i < abc.length; i++){
       newreal.push(abc[i])
    }               

    var abcd = this.erase(newreal)
    return [fail,abcd]

  }

}

class showing{

    // 210518, 210712 설명열 추가할 것(지금은 계정과목, 전표번호 등 밖에 없는데 다른 설명열도 추가할 것)
    // 210712 정산표 보여줄 때, 자산순서 등을 유동성 등으로 우선순위 정할 것, 그리고 차감계정은 묶어서 처리할 것
    // 지금 생각으로는 sortedrealcoa에 rank변수를 추가하고, 자바스크립트 function(a, b){return a > b} 등으로 정렬하는 기능활용
	// sorting_sortedrealcoa라는 함수를 아래에 만듬. 거기가서 수정할 것은 수정할 것
    
    constructor(obj){
        // 처음 원장 받는 view와 관련된 것
        this.coasetarr = {}  // 서버에서 넘어올 것이고  
                             // {"차변": ["차변"], "대변": ["대변"], "합계": ["합계","잔액"], "계정과목": ["계정과목", "계정명"], "전표번호": ["전표번호"]}
                             // 자동으로 제목행 세팅을 위해서 만든 오브젝트 
        this.tablearr = {};  // 좌측 즉 메인테이블에 대한 컨트롤을 위해서
                             // 각 table[r][c]를 넣어놓음
        this.table = {};     // 좌측 즉 메인테이블 그 자체를 의미함
                             
        this.settlementarr = {} // 이건 정산표 모드일때 tablearr

        
        this.tablediv = document.getElementById("tablediv");
        this.selectsheet = {};  // wb(엑셀파일)에서 선택된 시트를 의미함
        this.testbutton = {};   // 원장분석을 시작하기 위한 버튼
        
        // 여기까지가 처음뷰 관련
        this.selectlabel = {}; // 행시작열에 달려있는 label들임
        this.itemselect = {};  // 행시작행에 달려있는 select
        this.itemarray = {};   // {제목행 : 1, 전표번호 : 3 ... 등의 오브젝트}
        this.tablesize = {width : 11, height : 11}; 
        this.realis = {};
        this.realcoa = new Set([]);  // coa 배열임
        this.realcoaobj = {};        // coa 관련 object
        
        this.coasum = {};            // subclass는 전표번호별로 만든 것이라면
                                     // 이것은 coa별로 subclass내용을 집계한 것임
                                           
                                     //반드시 this.coasum에 밑에랑 연동을 위해서                 
        // {분류: 이자수익} 등 속성을 추가할 것
        // 여기서부터 두번째 뷰인 정산표 관련된 변수임
        
        this.sortedcoa = {};         // ajax 후 리턴 된 coa
        this.sortedrealcoa = {}      // subwindow에서 최종 확정된 coa  
        this.coasortobj = {};
        this.middlecoa = {};
        this.makecoasortobj();  

        // 정산표 관련 tag
        this.maintag = {};  // 왼쪽의 maintable을 집어넣기 위한 것
        this.righttag = {}; // 오른쪽 것
        this.bottomtag = {}; // 아래쪽 것
        
        
        // 이것도 서버에서 받아올 것이며
        // {이자수익: {분류1: 손익, 분류2: 손익류 ... 등이 될 것임}}
        // 이건 prob와 subclass 관련                

        this.realteam = {};
        this.wb = {};
        this.sheetname = "";
        this.subsumarr = {};
        this.subclass = {};
        this.probmodel = {};
        this.probmodel_total = {};
        this.smallval = 0.000001; // 나중에는 전표숫자에 연동되도록 수정할 것
        this.countmodel = [] // [{type: new Set([]), count: 1}] 이런식으로 만들예정


        // 자산의 분류 // 간단한 것들은 서버에서 받아오지 않고 여기서 정의하고 끝냄
        this.중분류 = {"현금흐름이 없는 손익":"현금흐름이 없는 손익", "처분손익": "처분손익", 
		        "이자손익": "이자손익", "자산/부채에 차감하는 계정": "자산/부채에 차감하는 계정", 
		        "BS": "BS", "일반": "일반", "IS": "IS"}
        this.중분류_손익 = {"현금흐름이 없는 손익":"현금흐름이 없는 손익", "처분손익": "처분손익", 
		        "이자손익": "이자손익", "IS": "IS"}
        
        
	}

	
	//^^ 아작스 관련
	//
	//
	//

    

	
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
   				
   		    	
   		    	resolve()

   				act(res)
 
   			},
            error: function (jqXHR, textStatus, errorThrown)
            {
                   console.log(errorThrown + " " + textStatus);
            }
   		})		
	  })
	}
	
	
	

    //^^ 가공 후 자료 보여주는 함수 기술
    //
    //
    //
    //
    makesettlement = () => {
        
        // 기존 테이블 삭제하기
        this.table.parentNode.removeChild(this.table);
        this.selectsheet.parentNode.removeChild(this.selectsheet);
        this.testbutton.parentNode.removeChild(this.testbutton);

        // 구조를 좌측, 오른쪽, 아래쪽 세 구도를 잡기위해서
        // tablediv에 upperdiv를 만들고 집어넣고, upperdiv에는 좌측 ,오른쪽을 집어넣고, float: left함
        // 아래쪽은 그냥 tablediv에 집어넣음
        
        var upperdiv = document.createElement("div")
        this.tablediv.appendChild(upperdiv)
       
        // 정산표 관련 테이블 만들기
        var tableup = document.createElement("div");
        
        
    	var table = document.createElement("table")
        table.setAttribute("class", "settlement");

    	upperdiv.appendChild(tableup);
    	tableup.appendChild(table);
    	this.maintag = table;
        
        tableup.style = "float: left; overflow: scroll; width: 700px;  height: 400px; border: 1px solid #444444;"
        // 계정과목별로 펼치기
        // 210518 이것도 이제 손익, 영업, 투자, 재무로 쪼개서 보여줄 것
        // 구조 계정과목, 손익, 숫자, 영업, 숫자, 투자, 숫자, 재무, 숫자, 대체, 숫자 총 11개
        
        
        
        // 제목열 만들기
    	var thead = document.createElement("thead");
   	    this.maintag.appendChild(thead);
   	    var temp = {}
    	var subdiv = this.maketrtd(temp, 6, "th");
   	    temp[0].innerText = "계정";
   	    temp[1].innerText = "손익";
   	    temp[2].innerText = "영업";
   	    temp[3].innerText = "투자";
   	    temp[4].innerText = "재무";
   	    temp[5].innerText = "대체";

   	    thead.appendChild(subdiv);
        
        // 내용열 만들기
    	var tbody = document.createElement("tbody");
    	this.maintag.appendChild(tbody);
      
    	
    	// 보여줄 계정들 순서 정렬하기
    	console.log(this.sortedrealcoa);
    	
    	var turn = []
        for(var i of this.realcoa){
    	  
           if(this.sortedrealcoa[i]["분류1"] == "BS"){
        	   turn.push(i);
        	   
           }
         }
    	
        for(var i of this.realcoa){
      	  
            if(this.sortedrealcoa[i]["분류1"] == "자산/부채에 차감하는 계정" ){
         	   //주계정의 위치찾기
         	   var main = this.sortedrealcoa[i]['main'];
         	   for(var j = 0; j < turn.length; j++){
         		   if(turn[j] == main){
         			   turn.splice(j + 1, 0, i)
         			   break
         		   }
         	   }
            }
    	
        }

    	
    	// 이제 집어넣기
        
      for(var i in turn){
    	  
    	    this.settlementarr[turn[i]] = {}
    		var subsum = this.cal_subsum2(turn[i]);
    	    var subdiv = this.maketrtd(this.settlementarr[turn[i]], 6);
    	    tbody.appendChild(subdiv)
    	   
     		this.settlementarr[turn[i]][0].innerText = turn[i];
    	    this.settlementarr[turn[i]][1].innerText = this.comma(subsum["손익"].sum);
    	    this.settlementarr[turn[i]][2].innerText = this.comma(subsum["영업"].sum);
    	    this.settlementarr[turn[i]][3].innerText = this.comma(subsum["투자"].sum);
    	    this.settlementarr[turn[i]][4].innerText = this.comma(subsum["재무"].sum);
    	    this.settlementarr[turn[i]][5].innerText = this.comma(subsum["대체"].sum);

    	    for(var num = 1; num <= 5; num++){
    			var field = document.createElement("input");
    			field.setAttribute("type", "checkbox");
    	        this.settlementarr[turn[i]][num].appendChild(field)
    	    	this.settlementarr[turn[i]][num].style = "text-align: right;"
    	    	this.additem4(field, turn[i], subsum[temp[num].innerText].arr);
    	    }

    		this.beforecoa = turn[i];
       }
        // 우측 상세내역 볼 테이블
    	var div = document.createElement("div")
    	upperdiv.appendChild(div)
    	this.righttag = div;
     
    	div.style = "float: left; overflow: scroll; width: 300px;  height: 400px; border: 1px solid black;"
        
        // 아래쪽 테이블 전표번호별 수정가능한 테이블 만들기
        // 210408 수정되는 기능 추가해야함. 드랍다운 기능 추가해야함
        var div = document.createElement("div")
        this.tablediv.appendChild(div)
        this.bottomtag = div;
        div.style = "overflow: scroll; width: 1005px;  height: 150px; border: 1px solid black;"

        
    }

    sorting_sortedrealcoa(){
    	
    	var arr = [];
    	for(var i in this.sortedrealcoa){
    		arr.push({coa: i, rank: 1})  //210712 여기서 rank 1의 값을 middlecoa에 rank반영하게하고 해서 여기서 가져오게 해야함
    	}
    	
    	arr.sort((a, b) => {
    		return a.rank - b.rank
    	})
    	
    	
    }
    
    
    
    cal_subsum = (coa) => {
        var sum = 0;


        for(var i in this.coasum[coa]){
            sum += this.coasum[coa][i]["sum"];
        }

        return sum;
    }


    coasort(coa){
    	
        for(var i = 0; i <= 2; i++){
        	
        	if(i in this.sortedcoa[coa] == true){
        	    return this.sortedcoa[coa][i]
        	}
        }
        
        
    }
    
    cal_subsum2 = (coa) => {
    	
        var sum = {"손익": {sum: 0, arr: new Set([])}, "영업": {sum: 0, arr: new Set([])}, "투자": {sum: 0, arr: new Set([])}, "재무": {sum: 0, arr: new Set([])}, "대체": {sum: 0, arr: new Set([])}};
        console.log(this.coasum[coa])
        for(var i in this.coasum[coa]){
        	
           // 이건 과거코드였음 var sortcoa = this.middlecoa[this.coasortobj[this.coasort(i)]]["분류3"]
           // 이제 계정 선택을 sortedrealcoa로 했기때문에 그것으로 선택하도록 할 것
           if(this.sortedrealcoa[i]["분류1"] == "현금흐름이 없는 손익" ||
        		   this.sortedrealcoa[i]["분류1"] == "처분손익" ||
        		   this.sortedrealcoa[i]["분류1"] == "이자손익"){
        	   var sortcoa = "손익"
           }else{
        	   sortcoa = "영업" // 210709 sortedrealcoa에 나중에는 투자 대체계정까지 나누어지도록 분류를 더 추가할 것
           }
           
           sum[sortcoa]["sum"] += this.coasum[coa][i]["sum"];
           sum[sortcoa]["arr"].add(i);
        }
   
        return sum;
    }

    makecoasortobj = () => {
       // 210620 서버에서 이 부분은 연산시키자
       // 영업, 투자, 재무에서 대체로 돌리는 것 적용할 것
       // 그리고 손익까지 지금 계정별로 뜨는데 이것도 개선할 것
       // 그리고 순서도 유동순서와 주계정 순서로 뜨도록 바꿀 것
       // this.realcoa가 결정되면 이 배열을 ajax로 넘기고
       // 연산해서 coasortobj가 결정되는 구조로 가자
       this.ajaxmethod("sortobj", {}, (res) => {
    	   
           this.coasortobj = res.sortobj;
           this.middlecoa = res.middlecoa;
           console.log(res);
           
       })
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
   	  var arr = /[^0-9\-\,]/g.exec(str);

   	  if(arr){
   	  	return tag; 
   	  }else{
   	  	return tag + "text-align: right;"
   	  }
 
   }

    // 이거 테이블로 바꿀것 // 이미 다 구조 테이블로 바꿈
    makediv2 = (arr) => {
    	var div = document.createElement("div")
        div.style = "overflow : hidden; width: 500px ";
        
        for(var i in arr){
        	var subdiv1 = document.createElement("div")
        	var style = "float : left; width : 100px; border: 1px solid gold;";
     	    subdiv1.style = style;
     	    subdiv1.innerText = arr[i];
            div.appendChild(subdiv1);

        }

        return div;

    }


    makediv = (text1, text2, text3) => {
    	var div = document.createElement("div")
        div.style = "overflow: hidden; width: 500px ";

    	var subdiv1 = document.createElement("div")
    	var style = "float: left; width : 100px; border: 1px solid gold;";
    	subdiv1.style = this.numbertag(text1, style);
    	subdiv1.innerText = this.comma(text1);
    	this.numbertag(text1);

    	var subdiv2 = document.createElement("div")
    	var style = "float: left; width : 100px; border: 1px solid gold;";
    	subdiv2.style =this.numbertag(text2, style);
        subdiv2.innerText = this.comma(text2);
        


        div.appendChild(subdiv1);
        div.appendChild(subdiv2);

        if(text3){
        	var subdiv3 = document.createElement("div")
        	var style = "float : left; width : 150px;border: 1px solid gold;";
        	subdiv3.style =this.numbertag(text3, style);
            subdiv3.innerText = this.comma(text3);
            div.appendChild(subdiv3);
        }  
        return div;
    }

   
    makedivarr = (arr) => {

      var div = document.createElement("div")
      div.style = "overflow: hidden; width: 500px ";

      for(var i in arr){

    	var subdiv1 = document.createElement("div")
    	var style = "float: left; width : 100px; border: 1px solid gold;";
    	subdiv1.style = this.numbertag(arr[i], style);
    	subdiv1.innerText = this.comma(arr[i]);
    	this.numbertag(arr[i]);

        div.appendChild(subdiv1);
      }
      return div;
        
    }
   


    makespan = (text1, text2) => {
    	var div = document.createElement("div")
        div.style = "overflow : hidden; ";

    	var subdiv1 = document.createElement("span")
    	var style = "width: 5%; border: 1px solid gold;";
    	subdiv1.style = this.numbertag(text1, style);
    	subdiv1.innerText = this.comma(text1);
    	this.numbertag(text1);

    	var subdiv2 = document.createElement("span")
    	var style = "width: 5%; border: 1px solid gold;";
    	subdiv2.style =this.numbertag(text2, style);
        subdiv2.innerText = this.comma(text2);

        div.appendChild(subdiv1);
        div.appendChild(subdiv2);

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

    //^^ viex에 관한 함수
    maketable(){
    	this.table = document.createElement("table"); // div 가 나은것 같으면
    	
    	
    	this.tablediv.appendChild(this.table); 
    	this.selectsheet = document.createElement("select");
    	this.testbutton = document.createElement("input");
    	this.testbutton.setAttribute('type', "button");
    	this.testbutton.value = "테스트하기"
        this.additem3(this.testbutton);

    	this.tablediv.appendChild(this.testbutton)   

    	this.tablediv.appendChild(this.selectsheet)             // div로 바꾸고
     	this.table.setAttribute("border", "10");
     	this.table.setAttribute("width", "100%");
     	this.table.setAttribute("class", "maintable");
    	                         //밑의 함수는 ~~~div2
                                                   //가 아닌 ~~~div로
        // processlist 반영하기 
    	for(var i = 0; i < this.tablesize.height;i++){
    	    this.tablearr[i] = {}
    	    var subdiv = this.maketrtd(this.tablearr[i], this.tablesize.width);
     		this.table.appendChild(subdiv)
    	}

    }
    
    

    maketrtd = (arr, count, td, stylearr) => {
       
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
    

    
    makelabel = () => {

        this.tablearr[0][0].innerText = "행시작"
        for(var i = 1; i <= 10; i++){
           // 라디오 버튼을 테이브 앞단에 둬, 제목열 선택할 수 있게할 것
           this.selectlabel[i] = document.createElement("input")
           this.selectlabel[i].setAttribute('type', "radio");
           this.selectlabel[i].setAttribute('name', "subject");
           
           this.additem2(this.selectlabel[i], i);

           this.tablearr[i][0].appendChild(this.selectlabel[i])   
        }
    }


    //이벤트 함수는 모두 additem 식으로 죽 늘려나갈 것
    additem1 = (item, i) => {
           item.addEventListener('change',(me)=>{
               if(me.target != "없음"){
                  this.itemarray[me.target.value] = i
               }
               
           });        
    }

    additem2 = (item, i) => {
           item.addEventListener('change',(me)=>{
                this.itemarray["제목행"] = i;
           })
    }

    additem3 = (item) => {
           item.addEventListener('click',(me)=>{
                
                this.nextlevel()
           })

    }
    
    // 정산표 계정과목이 선택되면 그 안의 내용을 보여주기 위한 것 
    additem4(item, coa, subarr){
        
       item.addEventListener('click',(me)=>{

               // 기존의 우측에 있던 노드 삭제 
           if(item.parentNode.childNodes.length > 1){
               for(var k = item.parentNode.childNodes.length - 1; k > 1; k--){
                    item.parentNode.removeChild(item.parentNode.childNodes[k]); 
               }
           }

           if(item.checked == true){
                
                // 테이블 만들어 추가하기
               	var table = document.createElement("table");
               	item.parentNode.appendChild(table);
               
               
                // 제목행 
               	var thead = document.createElement("thead");
               	table.appendChild(thead);
   	            var temp = {}
    	        var subdiv = this.maketrtd(temp, 2, "th");
   	            temp[0].innerText = "계정";
   	            temp[1].innerText = "금액";
   	           
   	            thead.appendChild(subdiv)

               // 내용행
        	    var tbody = document.createElement("tbody");
   	            table.setAttribute("class", "settlement");
   	            table.appendChild(tbody);
        

        	for(var i in this.coasum[coa]){
         		
        		if(subarr.has(i) == true){
        	      var tem = {}
        	      var subdiv = this.maketrtd(tem, 2);
        	      tbody.appendChild(subdiv)
        		  tem[0].innerText = i;
        	      tem[1].innerText = this.comma(this.coasum[coa][i]["sum"]);
        	      tem[1].style = "text-align: right;"
                  this.additem5(subdiv, coa, i);
        		}
        	}               
          }      
       })
    }

    additem5 = (item, coa1, coa2) => {

      
      item.addEventListener('click',(me)=>{
            // 기존의 노드가 있으면 삭제
            
           if(this.righttag.childNodes){
              for(var k = this.righttag.childNodes.length - 1; k >= 0; k--){
        	     this.righttag.removeChild(this.righttag.childNodes[k]); 
              }
           }
           // 테이블 만들어 추가하기
           var table = document.createElement("table");
           this.righttag.appendChild(table);
               
               
           // 제목행 
           var thead = document.createElement("thead");
           table.appendChild(thead);
   	       var temp = {}
    	   var subdiv = this.maketrtd(temp, 3, "th");
   	       temp[0].innerText = "전표번호";
   	       temp[1].innerText = "금액";
   	       temp[2].innerText = "보기"; 
   	       thead.appendChild(subdiv)

            // 내용행
    	    var tbody = document.createElement("tbody");
   	        table.setAttribute("class", "settlement");
   	        table.appendChild(tbody);
        
            	
            for(var i in this.coasum[coa1][coa2].arr){

       	      var tem = {}
       	      var subdiv = this.maketrtd(tem, 3);
       	      tbody.appendChild(subdiv)
       		  tem[0].innerText = this.coasum[coa1][coa2].arr[i]["전표번호"];
       	      tem[1].innerText = this.comma(this.coasum[coa1][coa2].arr[i]["금액"]);
       	      tem[1].style = "text-align: right;";
   	          tem[2].innerText = "보기";
              this.additem6(subdiv, this.coasum[coa1][coa2].arr[i]["전표번호"]);
             
            }

          
        })
    }

    
    additem6 = (item, num) => {

        item.addEventListener('click',(me)=>{

               // 기존의 우측에 있던 노드 삭제 
           while (this.bottomtag.hasChildNodes()){
                   this.bottomtag.removeChild(this.bottomtag.firstChild);
           } 

           // 이제 우리가 원하는 것 집어넣기
           // 210408 mainarr가 뭉쳐서 들어가도록 solvearr 집어넣도록 보완해야함
           // 테이블 만들어 추가하기
           var table = document.createElement("table");
           this.bottomtag.appendChild(table);
               
               
           // 제목행 
           var thead = document.createElement("thead");
           table.appendChild(thead);
   	       var temp = {}
    	   var subdiv = this.maketrtd(temp, 4, "th");
   	       temp[0].innerText = "전표번호";
   	       temp[1].innerText = "계정과목";
   	       temp[2].innerText = "금액"; 
   	       temp[3].innerText = "상대계정"; 
   	       thead.appendChild(subdiv)

            // 내용행
    	    var tbody = document.createElement("tbody");
   	        table.setAttribute("class", "settlement");
   	        table.appendChild(tbody);
        
            	
            for(var i in this.subclass[num].solvearr){

       	      var tem = {}
       	      var subdiv = this.maketrtd(tem, 4);
       	      tbody.appendChild(subdiv)
       		  tem[0].innerText = this.subclass[num].solvearr[i]["전표번호"];
       	      tem[1].innerText = this.subclass[num].solvearr[i]["계정과목"];
       	      tem[2].innerText = this.comma(this.subclass[num].solvearr[i]["금액"]);
       	      tem[2].style = "text-align: right;";
       	      tem[3].innerText = this.subclass[num].solvearr[i]["상대계정"];
            }
         })
    }



    // 각종 테스트 함수 등
    nextlevel = () => {
           
           // 파일 테스트
           if(this.sheetname == ""){
               alert("파일을 선택해주세요")
               return
           } 


           // 계정과목 테스트
           
           if(!this.itemarray["계정과목"]){
               alert("계정과목 열을 선택해주세요")
               return
           } 

           // 전표번호 테스트
           
           if(!this.itemarray["전표번호"]){
               alert("전표번호 열을 선택해주세요")
               return
           } 


           // 합계- 일단 합계만 두고, 추후에 차변, 대변 추가하는 것으로
           if(!this.itemarray["합계"]){
               alert("합계 열을 선택해주세요")
               return
           } 

            // 제목행 선택
            if(!this.itemarray["제목행"]){
               alert("제목 행을 선택해주세요")
               return
           } 
            
            // 계정코드 테스트 
            // 계정코드는 보통 숫자(100123 등의 구분자) 계정과목은 장기대여금 등의 구분자
            if(!this.itemarray["계정코드"]){
            	this.itemarray["계정코드"] = this.itemarray["계정과목"]
            }
            
            
            // 여기까지 통과했으면 이제 합계가 0이 뜨는지 확인하기
            this.excelsum();
           
            // 이제 전표번호별로 합계가 일치하는지 확인할 것
            const promise = new Promise((resolve) => {
            	this.excelsubsum(resolve);
            })
            

            
            promise.then(()=>{
                //subwind 부분으로 옮김
            	//this.makesettlement();
            })
             
    }

    testrow = () => {

    }

    testsum = () => {

    }


        
    // select 만드는 함수 등    
    makeitemselect = () => {
        for(var i = 1; i < 10; i++){

           // 라디오 버튼을 테이브 앞단에 둬, 제목열 선택할 수 있게할 것
           
           this.itemselect[i] = document.createElement("select");
           this.itemselect[i].style = "width: 100%;"
           // 선택할 옵션
           var opt = document.createElement('option');
           opt.innerText = "없음";
           this.itemselect[i].appendChild(opt);
           var opt = document.createElement('option');
           opt.innerText = "차변";
           this.itemselect[i].appendChild(opt);
           var opt = document.createElement('option');
           opt.innerText = "대변";
           this.itemselect[i].appendChild(opt);
           var opt = document.createElement('option');
           opt.innerText = "합계";
           this.itemselect[i].appendChild(opt);

           var opt = document.createElement('option');
           opt.innerText = "계정코드";
           this.itemselect[i].appendChild(opt);
           
           var opt = document.createElement('option');
           opt.innerText = "계정과목";
           this.itemselect[i].appendChild(opt);

           var opt = document.createElement('option');
           opt.innerText = "전표번호";
           this.itemselect[i].appendChild(opt);

           
           // 이벤트 함수 집어넣기
           this.additem1(this.itemselect[i], i);  
 
           // 옵션 집어넣기
           this.tablearr[0][i].appendChild(this.itemselect[i])   
           
        }

    }

    makeselect = (arr) => {
        

        this.selectsheet.parentNode.removeChild(this.selectsheet); 
        this.selectsheet = document.createElement("select");
        this.tablediv.appendChild(this.selectsheet)   
        this.selectsheet.addEventListener('change',()=>{this.fromexcel(this.wb, this.selectsheet.value)});
        
        for(var i in arr){
            var opt = document.createElement('option');
            //opt.setAttribute('value', i)
            opt.innerText = arr[i];
            this.selectsheet.appendChild(opt)
        }
        return this.selectsheet;
    }  
    
    //## subclass 관련함수
    // 계정과목 모델 만들기
    coamake = () => {
        // 이 부분은 추후 생각해야 함

    }

    // 확률모델 만들기
    makeprob = () => {
        for(var i in this.subclass){
            this.probmodel = this.subclass[i].makeprob(this.probmodel)
        }

        
    }
    
    // 확률모델 실패한 서브 클래스는 probdistcal 실행하기
    probdistcal = () => {
        for(var i in this.subclass){
            if(this.subclass[i].failsure > 1){
               this.subclass[i].probdistcal()
            }
        }
    }
        


 // 이것을 현재는 사용하지 않음. 확률적으로 맞는 것 같지 않음 
 // 확률거리를 계산하기 위한 함수 
  // 현재는 차변, 대변 평균이나, 차변만, 대변만 옵션들 추가해야 할듯 
  probcal = (a, b, opt) => {

      var prob = this.smallval
      
      if(opt == "차변"){
         prob = b in this.probmodel[a]['차변'] ? this.probmodel[a]['차변'][b]/this.probmodel[a]['차변']["total"] : this.smallval;
      }else if(opt == "대변"){
         prob = b in this.probmodel[a]['대변'] ? this.probmodel[a]['대변'][b]/this.probmodel[a]['대변']["total"] : this.smallval;
      }else{
         var 차변 = b in this.probmodel[a]['차변'] ? this.probmodel[a]['차변'][b] : 0;
         var 대변 = b in this.probmodel[a]['대변'] ? this.probmodel[a]['대변'][b] : 0;
         prob = (차변 + 대변)/(this.probmodel[a]['차변']["total"] + this.probmodel[a]['대변']["total"]);
         prob = prob > 0 ? prob : this.smallval; 
      }
      
      
      return prob;
  }





 makeprobtotal = () => {
      
      // 이미 한 계정으로 아래 함수 잘 돌아가는 것 확인했으나,
      // this.coaarray로는 확인이 안되었으니, 이것만 확인하면 됨
      
      for(var a of this.coaarray){
         var arr = {};     // 계정별로 {거리, 이전계정, 통과여부} 이렇게 arr를 구성함
         arr[a] = {거리: 1};

         // 모든 가능한 것을 다 돌려보면 비효율이므로 5번까지만 일단 돌려봄
         for(var i = 0; i < 5; i++){
              arr = this.findpath(arr);
         }
         this.probdistarray[a] = arr    
      }
 }
  
  test_prob = () => {
     

     //for(var i in this.probmodel){
        var arr = {};
        arr["투자주식"] = {확률: 1, 이전계정: [], 통과여부: 0}
        var result = this.makeprobtotal_cal(arr);
        this.probmodel_total["투자주식"] = result;
     //} 

     
  }

  optcal = (opt, coa) => {
         
      // 현재는 coa는 의미없음, 나중에 처분손익류는 방향이 같은 부분이 있기때문에 이를 위해서, coa도 받게했음
      if(opt == "차변"){
          return "대변";
      }

      if(opt == "대변"){
          return "차변";
      }
  }
   
  makeprobtotal_cal = (arr) => {
    
    // 장기대여금의 prob안에 이자수익, 대손충당금 등이 있겠지만, 
    // 없는 계정에 대한 확률을 임의로 추정해서 20개 이상의 making시 유사도 순을 뽑기위해서
    // 없는 계정에 대한 확률을 만듬
    // 차변 대변 구별없이 산정함
    
    // 다섯번까지 확장해봄. 나중에는 더 늘릴지 고민할 것 
    for(var num = 0; num < 5; num++){
       
       for(var a in arr){ 
               
          // 계정추가하기
          if(arr[a]["통과여부"] == 0){
              

              var temp = Object.keys(this.probmodel[a]["차변"]).concat(Object.keys(this.probmodel[a]["대변"]))
              var temp = new Set(temp);
              temp.delete("total");

              for(var i of temp){    
                   var prob = arr[a]["확률"] * this.probcal(a, i, "종합");
                   
                   // 차변 대변 구별을 위해서 optcal이란 함수를 만듬
                    
                   if(i in arr){
                          arr[i]["확률"] += prob;
                          arr[i]["이전계정"].push(a);
                   }else{
                      arr[i] = {확률: prob, 이전계정: [a], 통과여부: 0}
                   }
              }

              arr[a]["통과여부"] = 1;
          }
        }
     }  
     
     return arr;
  }

    // 연산 실행하기
    execute(){
        for(var i in this.subclass){
            this.subclass[i].execute()
            
     	   // 카운트 모델 만들기
     	   if(this.subclass[i].solvearr.length > 0){
        	   this.makecountmodel(this.subclass[i].solvegroup)
     	   }
        }
    }

    execute2(){
    	
    	// 카운터 모델에 의해 쪼갤질 가능성이 다양한 경우에는 확률에 따라 최적치 도출하기
        for(var i in this.subclass){
        	this.subclass[i].countmodel = this.countmodel;
            this.subclass[i].execute2()
            
        }
    	
        
    }

     
    execute3(){
        for(var i in this.subclass){
            this.subclass[i].execute3(this.sortedrealcoa, this.중분류_손익);
            
        }
    	
    }

    execute4(){
        for(var i in this.subclass){
            this.subclass[i].execute4();
            
        }
    }
    
    execute5(){
            for(var i in this.subclass){
                this.subclass[i].execute5();
                
            }
            
            console.log(successtest)
    }
    
   //
   
    execute_incometype(){
        for(var i in this.subclass){
            this.subclass[i].execute_incometype(this.sortedrealcoa, this.middlecoa);
            
        }
    	
    }
   
    
   // 정산표 배열에 집어넣기(coasum)
   inputcoasum = () => {
       
       // 이런 구조의 배열임
       // {장기대여금: {이자수익: {sum: , arr: []}, .....}}

       for(var i of this.realcoa){
           this.coasum[i] = [];
       } 


       for(var i in this.subclass){

           for(var j in this.subclass[i].solvearr){
               var 계정과목 = this.subclass[i].solvearr[j]["계정과목"];
               var 상대계정 = this.subclass[i].solvearr[j]["상대계정"];

               if(상대계정 in this.coasum[계정과목] == true){
                  this.coasum[계정과목][상대계정].arr.push(this.subclass[i].solvearr[j]);
                  this.coasum[계정과목][상대계정].sum += this.subclass[i].solvearr[j]["금액"];
               }else{
                  this.coasum[계정과목][상대계정] = {sum: this.subclass[i].solvearr[j]["금액"], arr: [this.subclass[i].solvearr[j]]};
               }               
           }

       }
   }
   
   makecountmodel(group){
	   
	   
	   // group = [{0,1,2}, {3, 4}] 합 0이 성공한 배열들 모음임
	   // arr는 mainarr말고 grouparr임
	 
	 for(var i in group){  
	   var dataset = new Set([])
	   for(var j in group[i]){
		   
		   dataset.add(group[i][j]["계정과목"])
	   }
	   
       	   
	   // 집합 비교연산하여 카운트 하기
	   var success = 0;
	   for(var i in this.countmodel){
		   if(this.equal(this.countmodel[i].type, dataset) == true){
			   this.countmodel[i].count += 1;
			   success = 1
			   break
		   }
	   }
	   
	   if(success == 0){
		   this.countmodel.push({count: 1, type: dataset})
	   }
	 }
   }
   
   
   // 집합 비교연산
   equal = (as, bs) => {
	    if (as.size !== bs.size) return false;
	    for (var a of as) if (!bs.has(a)) return false;
	    return true;
    }

    //## 엑셀파일에 대한 함수들
    
    
    excelsum(){

       var total = this.wb.Sheets[this.sheetname]["!ref"]
       var start = total.indexOf(":");
       var lastcell = total.substring(start + 1, 10);
       var range = XLSX.utils.decode_cell(lastcell);
           
       // 사실 아래 작업은 서버에서 하는 역할 임시적으로 하는 것이니 서버에서는 달라져야함
       var sum = 0;
       
       for(var r = this.itemarray["제목행"]; r <= range.r; r++){
               if(!Number(this.wb.Sheets[this.sheetname][XLSX.utils.encode_cell({r: r, c: this.itemarray["합계"]-1})].v)){
                   alert("숫자가 아닌 데이터가 있습니다. 확인해 주세요")
                   return
               };
               sum += this.wb.Sheets[this.sheetname][XLSX.utils.encode_cell({r: r, c: this.itemarray["합계"]-1})].v
       }

       if(sum != 0){
          alert("차변 대변 합계가 0이 아닙니다. 확인해 주세요");
          return   
       }
    } 

    async excelsubsum(resolve){
        // 여기에서 전표번호별 합계를 체크하고 맞으면 최종적으로 전표별로 sub class를 만들기
       
       var total = this.wb.Sheets[this.sheetname]["!ref"]
       var start = total.indexOf(":");
       var lastcell = total.substring(start + 1, 10);
       var range = XLSX.utils.decode_cell(lastcell);
           
       var sum = 0;
       
       for(var r = this.itemarray["제목행"]; r <= range.r; r++){
               
               var 계정과목 = this.wb.Sheets[this.sheetname][XLSX.utils.encode_cell({r: r, c: this.itemarray["계정과목"]-1})].v
               
               this.realcoa.add(계정과목);
               

          // 전표의 집어넣을 배열만들기
          var subarr = {
                            전표번호 : this.wb.Sheets[this.sheetname][XLSX.utils.encode_cell({r: r, c: this.itemarray["전표번호"]-1})].v,
                            계정과목 : this.wb.Sheets[this.sheetname][XLSX.utils.encode_cell({r: r, c: this.itemarray["계정과목"]-1})].v,
                            금액 : this.wb.Sheets[this.sheetname][XLSX.utils.encode_cell({r: r, c: this.itemarray["합계"]-1})].v,
          }

               // 계정과목별로 probmodel setting 하기
               if(subarr["계정과목"] in this.probmodel != true){
                   this.probmodel[subarr["계정과목"]] = {차변: {"total":0}, 대변: {"total":0}}
               }

               if(subarr["전표번호"] in this.subsumarr){
                   this.subsumarr[subarr["전표번호"]].sum += subarr["금액"]
                   // 배열의 내용 집어넣기
                   // 일단은 전표번호, 계정명, 합계만 끌어오고, 나머지는 추후에 생각하자
                   this.subsumarr[subarr["전표번호"]].arr.push(subarr) 
                   
               }else{
                   this.subsumarr[subarr["전표번호"]] = {}
                   this.subsumarr[subarr["전표번호"]].sum = this.wb.Sheets[this.sheetname][XLSX.utils.encode_cell({r: r, c: this.itemarray["합계"]-1})].v
                   this.subsumarr[subarr["전표번호"]].arr =[subarr]
               } 
        
    
      }           

       // subsumarr 점검하고 subclass 만들기 
       
       for(var i in this.subsumarr){
           if(this.subsumarr[i].sum != 0){
               alert("전표번호별 합계가 일치하지 않습니다.")
               return
           }else{
               // 전표별로 subclass 만들기
        	   this.subclass[i] = new subcal(this.subsumarr[i].arr, i, this.probmodel, this.smallval, this.sortedrealcoa);
               
           } 
       }
       
       
       // await 구문으로 수정함
       
       var data = {realcoa: [...this.realcoa]}
       await this.ajaxmethod("controlmethod", data, (res) => {
    	   this.sortedcoa = res;
    	   console.log(res)
    	      
       })
       
       // subwindow 코드 확인할 것
       this.openchild(); 
       resolve()
    }

    openchild(){
    	console.log(name);
        // window.name = "부모창 이름"; 
        window.name = "parentForm";
        // window.open("open할 window", "자식창 이름", "팝업창 옵션");
        var url = '<c:url value = "/subwindow" />'
        subwin = window.open(url,
                "childForm", "left = 500, top = 250, width=570, height=350, resizable = no, scrollbars = no");    
        
        
        
    }

    coasubwindow = () => {
 	   
       
       
 	   // subwindow table에 집어넣을 계정배열들 순서대로 정렬하기
 	   var arr = {"손익류": [], "차감형": [], "BS": [], "IS": []}
 	   for(var i in this.sortedcoa){
 		  // 손익류 , 차감형 등 집어넣기
 		  
          var sorting = this.middlecoa[this.coasortobj[this.coasort(i)]]["분류2"];
 		  if(sorting == "처분류" || sorting == "손익류"){
 			  arr["손익류"].push(i);
 		  }else if(sorting == "차감"){
 			  arr["차감"].push(i);
 		  }else{
 			  var bsis = this.middlecoa[this.coasortobj[this.coasort(i)]]["분류1"];
 			  arr[bsis].push(i);
 		  }
 	   }
        
 	    // 이제 집어넣기 
        // 테이블 만들어 추가하기
    	var temptable = document.createElement("table");
    
        // 제목행 
    	var thead = document.createElement("thead");
    	temptable.appendChild(thead);
        var temp = {}
        var subdiv = this.maketrtd(temp, 2, "th");
        temp[0].innerText = "계정"
        temp[1].innerText = "금액";
        
        thead.appendChild(subdiv);
        // 내용행
    
        var tbody = document.createElement("tbody");
        temptable.appendChild(tbody);

        for(var i in this.sortedcoa){
 	       var tem = {}
            var subdiv = this.maketrtd(tem, 2);
            tbody.appendChild(subdiv)
 	        tem[0].innerText = i;
            var sel = this.makeselect(this.coasortobj)
            tem[1].appendChild(sel);
        } 
        
        return temptable;

    }    
    
    
    autosetting(){
          
         // 자동으로 계정과목 세팅을 위해서 만들었음
         // 계정과목 배열은 서버에서 넘겨받을 것임
         // coasetarr 구조: {"차변": [], "대변": [], "합계": [], "계정과목": [], "전표번호": [], "설명": []}
         // 이와 같은 구조가 될 것임

         var row = 1;

         this.coasetarr = {"차변": ["차변"], "대변": ["대변"], "합계": ["합계","잔액"], "계정과목": ["계정과목", "계정명"], "전표번호": ["전표번호"]}
         // 210518 향후에는 coamapping 하는 것처럼 
         // 정규식 이런 것 사용해서 정확성 올릴 것           
         
         for(var c = 1; c <= this.tablesize.width - 1; c++){
            for(var i in this.coasetarr){
                var tem = this.tablearr[row][c].innerText;
                for(var z in this.coasetarr[i]){
                   if(this.coasetarr[i][z] == tem){
                      this.itemselect[c].value = i;
                      this.itemarray[i] = c;
                   }
                }
             }
         }
         


    }
   


    fromexcel(wb, sheet){ // arr는 있다면 사용할 것
    
       
       
       if(!sheet){
           sheet = wb.SheetNames[0];
       }
       
       // 엑셀파일 이름 세팅
       this.sheetname = sheet;
       
       var total = wb.Sheets[sheet]["!ref"]
       var start = total.indexOf(":");
       var lastcell = total.substring(start + 1, 10);
       var range = XLSX.utils.decode_cell(lastcell);
           
       
       var rowval = Math.min(range.r+1, this.tablesize.height - 1);
       var colval = Math.min(range.c+1, this.tablesize.width - 1);
      
       
       for(var r = 1; r <= rowval; r++){
          for(var c = 1; c <= colval; c++){

              try{
            	 var tem = this.comma(wb.Sheets[sheet][XLSX.utils.encode_cell({r: r-1, c: c-1})].v)
                 this.tablearr[r][c].innerText = tem
                 
                 this.tablearr[r][c].style = this.numbertag(tem, "")
              }catch{
                // this.tablearr[r][c].innerText = 0;
              }

          }
       }
       
       // 나중에 asyia, await 등 고민할 것 
       this.autosetting();
    }





        
}    


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


window.onload = function(){
	
      //real(1, arr, 0, arr[0])
      
      var tem = {"현금": 0, "중간": 0}
      console.log("개똥" in tem)
      
      var temp = {}
      
      table = new showing();
      table.maketable();
      table.makelabel();
      table.makeitemselect();

      var arr =[]
      for(var i = 0; i < 23; i++){
    	  arr.push(i)
      }
      var time = new Date().getTime()
      console.log(time);
      
      //table.making_func(arr)
      //table.making_test(0, arr)
      
      var abc = new subcal();
      
      var val = abc.making3(0, [{금액: 13}, {금액: -5}, {금액: -3}, {금액: -10}], [])
      console.log(val)
      var temp = [{금액: 6000000}, {금액: -10000000}, {금액:4000000}];
      var temp2 = [{금액: -6000000}, {금액: 10000000}, {금액:-4000000}];

      //var temp = [{금액: 13}, {금액: -5}, {금액: -3}, {금액: -10}, {금액: 24}, {금액: -8}, {금액: 100}, {금액: -83}, {금액: -21}, {금액: -7}];
      for(var i = 0; i < 1; i++){
         // var ar = abc.making3(0, temp, [])
      }

      //var ar = abc.making(0, temp)
      //var ar = abc.making(0, temp2)
      console.log(arr)
      //abc.erase([new Set([0, 1]), new Set([0,1,2,3])])

      


}

function excelExport(event){

    var input = event.target;
    var reader = new FileReader();
    reader.onload = function(){
        var fileData = reader.result;
        var wb = XLSX.read(fileData, {type : 'binary'});
        // coaarray 읽어드려서 만들기
        table.wb = wb;
        table.fromexcel(wb);
        table.makeselect(wb.SheetNames);

        // row를 2로 임의로 배정했으나, 앞으로 이것도 자동 추가해야함
        
        
        // 사실 여기부터 필요있는 코드임. 위의 코드는 원래는 그냥 서버에서 넘겨받는 것임



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
        this.realbs = {};  // 향후 재무제표를 집어넣는다면 bs를 의미
        this.realis = {};  // 향후 재무제표를 집어넣는다면 is를 의미
        this.realteam = {}; 
        this.coamap = {};
        this.beforecoa = "";
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
    	var div = document.createElement("table"); // div 가 나은것 같으면
    	this.tablediv.appendChild(div)             // div로 바꾸고
    	this.maintag = div;                        //밑의 함수는 ~~~div2
                                                   //가 아닌 ~~~div로
        // processlist 반영하기 
    	for(var i in this.processlist){
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
    	this.tablediv.appendChild(div)
    	this.maintag = div;

        // BS/IS 반영하기 
        
    	for(var i in this.realbs){
    		var subdiv = this.makediv(i, this.realbs[i], "BS");
    		div.appendChild(subdiv);
    		this.beforecoa = i;

    	}
    	for(var i in this.realis){
    		var subdiv = this.makediv(i, this.realis[i], "IS");
    		div.appendChild(subdiv)
    		this.beforecoa = i;
    	}

    	// 컨펌 버튼 추가하기
    	var button = this.makebutton();
        this.tablediv.appendChild(button) 
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
   	  var arr = /[^0-9\-]/g.exec(str);
   	  

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
        if(oppositesub[name]){
            return this.beforecoa;
        }
        // 완전히 똑같이 일치하는 것이 없으니 순환하면서 가장 유사한 것 찾기
        var grade1 = 0;
        var decide1 = "";
        
        

        for(var i in oppositecoa[opt]){
            
            var compare = i;
            //compare = compare.replace("(", "");
            //compare = compare.replace(")", "");
            var val = this.wordprocess(name, compare);


            var word = this.wordprocess2(name, compare);

            var temp = this.similarmatch(word, compare) + val;
            
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
<div id ="tablediv" ></div>
</body>