<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
 <html>
    <head>

       <meta name="_csrf_header" content="${_csrf.headerName}">
       <meta name="_csrf" content="${_csrf.token}">
    
    <body>

        <div id = "mywork" style = "overflow: hidden">
            <c:forEach var = "q" items = "${processlist}" >
             <div style = "float: left;">
              <input type = "radio"  name = "myworkradio" value = "${q}"> </input>
              ${q}
             </div>
           </c:forEach>
             <input type = "button" id = "myworkbutton" value = "불러오기"></input>
        </div>

      <div style = "position: absolute; top: 327px; width: 248px; height: 196px; margin-right: 2px; border: solid 1px blue;"> 
        <div> 부모:
          <select id = "DiagramSelect_pa"></select>
        </div>
        <div> 자식:
          <select id = "DiagramSelect_ch"></select>
        </div>
        <div> 팀:  
          <select id = "DiagramTeamSelect"> </select>
        </div>
        <div> 부모 자식 사이에:  
          <input type = "checkbox" id = "Diagramcheckbox"> </input>
        </div>
        <div>   
          <input type = "button" value = "입력하기" id = "DiagramButton"/>
        </div>
      </div>   


      <div style="width: 1300px; display: flex; justify-content: space-between">
        <div id="myPaletteDiv" style="width: 250px; height:200px; margin-right: 2px; border: solid 1px blue;">
         
         </div>


         <div id="myDiagramDiv" style="border: solid 1px blue; width:650px; height:400px"></div>
         <div id= "myexplain" style="width: 400px; height: 400px; margin-right: 2px; border: solid 1px blue; overflow: hidden"></div>
      </div>
 
      <div style="width: 1300px; display: flex; justify-content: space-between">
         <div id= "mycontrol" style="width: 1300px; height: 200px; margin-right: 2px; border: solid 1px blue;"></div>
      </div>
 
 
 
    </body>
 
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
 
 
    <script src="go-debug.js"></script>
    <script src="Figures.js"></script>
    <script src = "http://code.jquery.com/jquery-3.4.1.js"></script>

  <script>

  

  
  var $$ = go.GraphObject.make;
  var request;
  
  function createRequest(){
		
		try{
			request = new XMLHttpRequest();
			
			
		} catch (exception){
			try {
				request = new ActiveXObjet('Msxml2.XMLHTTP');
			} catch (innerException){
				request = new ActiveXObject('Microsoft.XMLHTTP');
			}
			
		}
	     return request;	
	   }
  
  
  
class diagram{
    constructor(i){
       this.divisionsize_y = 100;
       this.divisionsize_x = 100;
       this.divisions = {};
       this.divisionpos = {};
       this.datasetting = {}; // nodedata 관련된 것을 담아 이것을 돌려서 그릴 것
       this.datapool = [];

       this.width = 150;
       this.height = 100;

       
       // 아래쪽 테그 관련한 것들
       // 210505 이 부분을 클릭하면 이제 아작스로 받아오는 것으로 바꿀것
       // 대신에 기존에 아작스로 받아오는 부분은 수정해야함 
       this.myworkradio = document.getElementsByName('myworkradio');
       
       this.myworkbutton = document.getElementById('myworkbutton');
       this.addlisten(this.myworkbutton);
       
       this.diagramselect_pa = document.getElementById('DiagramSelect_pa');
       this.diagramselect_ch = document.getElementById('DiagramSelect_ch');
       this.diagramteamselect = document.getElementById('DiagramTeamSelect');
       this.diagramcheckbox = document.getElementById('Diagramcheckbox');
       this.diagramexplain = document.getElementById('myexplain');
       this.diagramexplaincontrol = document.getElementById('mycontrol');
       
       // 이 아래쪽은 위의 diagramexplain과 관련된 우측의 table과 button에 관한 것들
       this.tablesize = {width : 3, height : 11};
       this.tablearr = {};
       this.selectlabel = {};
       
       this.testbutton = document.createElement("input");
	   this.testbutton.setAttribute('type', "button");
	   this.testbutton.value = "테스트하기"
	   this.diagramexplain.appendChild(this.testbutton)   
	   this.additem3(this.testbutton);

	   this.table = document.createElement("table"); // div 가 나은것 같으면
       
	   this.table.setAttribute("border", "10");
	   this.maketable();
	   this.diagramexplain.appendChild(this.table); 
	   
       this.tablearr[0][0].innerText = "세부프로세스";
       this.tablearr[0][1].innerText = "설명";
	   this.makelabel(this.tablearr);
	   
	   
	   // 이 아래쪽은 위의 diagramexplain 항목을 선택했을때 나타나는 아래쪽 테이블 관련
       this.table2size = {width : 3, height : 11};
       this.table2arr = {};
	   this.table2 = document.createElement("table"); // div 가 나은것 같으면
       this.diagramexplaincontrol.appendChild(this.table2); 
	   this.table2.setAttribute("border", "10");
	   this.maketable2();
       this.table2arr[0][0].innerText = "통제활동";
       this.table2arr[0][1].innerText = "설명";
	   this.makelabel(this.table2arr);


       // diagramselect에 관한 것               
       this.makeselect(this.diagramteamselect, ["영업팀", "회계팀", "자금팀"]) 
       this.diagrambutton = document.getElementById('DiagramButton');

       this.diagram = new go.Diagram("myDiagramDiv");
       this.Palette = {};

       // 지우거나 추가할때 아래 3개가 함께 고려해서 지우거나 해야한다는 것 기억할 것
       this.nodedata = []
       this.graphdata = []; //210419 추가됨
       this.passeddata = new Set([]);

       //template 세팅
       this.diagram.nodeTemplate =
          $$(go.Node, "Auto", 
            {
              click: (e, node) => {
                 var cmd = this.diagram.commandHandler;
                 this.diagramselect_pa.value = node.data.realkey;
                 
                 if(node.data.type == 2){
                	 
                     var arr = {};
                	 for(var i in this.datapool){
                		 
                		 if(i in this.datasetting == false){
                 			arr[i] = i; 
                 		 }
                	 } 
                	 
                     // 210418 내일 할 일
                     // 우측쪽 table 선택하면 realkey가 없음일때는 선택된 제목으로 텍스트 문자가 바뀌도록 하고
                     // 그렇지 않을때는 아래쪽 table을 추가하여 통제활동을 보여주도록 하자

                	 console.log(arr);
                	 this.inputtable(arr, this.datapool, node.data);
                	 
                 }else{
                     console.log(node.data);
                     // 여기와 연동되어 서버에서 값 받아오기
                     this.ajaxmethod(node.data.key);
                     // 현재는 서버에서 값 받아오나, 이거 이미 받아온 값으로 수정하도록 하는게 나을 듯
                	 
                 }
                 
                 
              },
              
              contextClick: (e, node) => {
                  var cmd = this.diagram.commandHandler;
                  this.diagramselect_ch.value = node.data.realkey;
                  
                  
                  console.log(this.diagramselect_ch.value);
                  // 여기와 연동되어 서버에서 값 받아오기
                  this.ajaxmethod(node.data.key);
               }
              
     
            },
          new go.Binding("location", "loc", go.Point.parse),
          $$(go.Shape,new go.Binding("stroke", "stroke"), new go.Binding("width", "wid"), 
            new go.Binding("angle", "angle"), new go.Binding("height", "hei"), new go.Binding("figure", "fig"), new go.Binding("fill", "color")),
          $$(go.TextBlock, { margin: 5}, new go.Binding("stretch", "stretch"), 
             new go.Binding("text", "key"), new go.Binding("font", "font")),

        );

      this.diagram.linkTemplate =
          $$(go.Link, { routing: go.Link.AvoidsNodes}, 
          $$(go.Shape),
          $$(go.Shape, { toArrow: "Standard" })
      );

      // 팔레트 세팅
      this.Palette = 
        $$(go.Palette, "myPaletteDiv",  // must name or refer to the DIV HTML element
          {
            // Instead of the default animation, use a custom fade-down

            nodeTemplate: this.diagram.nodeTemplate,  // share the templates used by myDiagram
            linkTemplate: this.diagram.linkTemplate,
            model: new go.TreeModel([  // specify the contents of the Palette
              {key: "없음", realkey: "없음", before: "", team: "", shape: "Rectangle", 
               wid: 100, hei: 50, color: "white", type: 2}
             ])
            });
     
     // 210417 이제 앞 뒤로 들어가는 것 만들 것 지금은 부모 기능밖에 없음
     // 210417 그 후 이제 엑셀데이터랑 연동하는 것 만들것

     

     
     
     // button 이벤트
     this.diagrambutton.addEventListener('click',()=> {
            var data = this.Palette.model.nodeDataArray[0];
            data.parent = this.diagramselect_pa.value;
            data.child = this.diagramselect_ch.value;
            data.team = this.diagramteamselect.value;
            
            
            this.datasetting[data.key] = {name: data.key, next: [data.child], before: [data.parent], team: data.team, shape: "Rectangle" };
            // 부모 집어넣기
            this.datasetting[data.child].before.push(data.key);
            // 자식 집어넣기
            this.datasetting[data.parent].next.push(data.key);
            
            
            // 체크박스가 선택되어 있으면, 원래의 것 부모와 자식 관계 지우기
            if(this.diagramcheckbox.checked == true){
            	
            	
            	for(var i = 0; i < this.datasetting[data.child].before.length; i++){
            		if(this.datasetting[data.child].before[i] == data.parent){
            			this.datasetting[data.child].before.splice(i, 1);
            		}
            	}
            	
            	for(var i = 0; i < this.datasetting[data.parent].next.length; i++){
            		if(this.datasetting[data.parent].next[i] == data.child){
            			this.datasetting[data.parent].next.splice(i, 1);
            		}
            	}
            	
            }
            
            
            // 3개 데이터 삭제
            this.nodedata = []
            this.passeddata =  new Set([]);
            this.graphdata = [];

            this.diagram.model.nodeDataArray = [];
            
            this.nodedatasetting_graph(this.datasetting, this.datasetting["전표 접수"]);
            this.picture("graph");
         });

/*   nodeTemplateMap 기능에 대해서도 알아 둘 필요가 있음 gojs 사이트 참고하면됨
     
     안진/엑셀쪽에 flowchart1.html 받아둔 것 있으니,
     그거 활용하면 앞 뒤로 화살표나 이런것도 모두 추가가 됨
      
      this.diagram.nodeTemplateMap.add("",  // the default category
        $(go.Node, "Table", this.nodeStyle(),
          // the main object is a Panel that surrounds a TextBlock with a rectangular Shape
          $(go.Panel, "Auto",
            $(go.Shape, "Rectangle",
              { fill: "#282c34", stroke: "#00A9C9", strokeWidth: 3.5 },
              new go.Binding("figure", "figure")),
            $(go.TextBlock, this.textStyle(),
              {
                margin: 8,
                maxSize: new go.Size(160, NaN),
                wrap: go.TextBlock.WrapFit,
                editable: true
              },
              new go.Binding("text").makeTwoWay())
          ),
          // four named ports, one on each side:
          this.makePort("T", go.Spot.Top, go.Spot.TopSide, false, true),
          this.makePort("L", go.Spot.Left, go.Spot.LeftSide, true, true),
          this.makePort("R", go.Spot.Right, go.Spot.RightSide, true, true),
          this.makePort("B", go.Spot.Bottom, go.Spot.BottomSide, true, false)
        ));
*/


    }
  

  nodedatapos = (arr) => {
    // 리스트들 순환하면서 팀 위치를 만들 것
   

    // team hash 만들기
    for(var i in arr){
      
      if(this.divisions[arr[i]["team"]]){
        this.divisions[arr[i]["team"]] = 0;
      }else{
        this.divisions[arr[i]["team"]] = 0;
      }

    }

   // team hash에 위치 세팅하기
   var pos = 0;
   for(var i in this.divisions){
      this.divisionpos[i] = pos;
      pos += this.divisionsize_y;
   }


  }

  possetting = (arr) => {
     
     // 팀별로 갯수세기
     var team = {};
     var team_other = {}; // 팀별로 위치를 세팅하기 위해서 만든 것 // 이건 그냥 리턴 값임
     var num = 0;
     var team_current = "";
     var team_start = ""


     for(var i in arr){
         
         if(arr[i].team in team){
            team[arr[i].team].count += 1;

         }else{
            team[arr[i].team] = {count: 1, 가로: 0, 세로: num, before: team_current};

            if(team_current != ""){
              team[team_current]["next"] = arr[i].team;
            }else{
              team_other["team_start"] = arr[i].team;
            }
            num += 1;
         }

         team_current =  arr[i].team;
     }

     // 팀 갯수 분할하기
     var 최초 = Math.ceil(Math.sqrt(Object.keys(arr).length));

     var 가로 = 최초;
     var 세로 = 0;
     for(var i in team){
        
        세로 += Math.ceil(team[i].count/가로);

     }
     
     var 최소 = Math.max(가로, 세로);
     var 결정가로 = 가로;
     var 결정세로 = 세로;
     //세로가 최초보다 클때까지는 가로를 늘려가면서 최적 팀별 위치 쪼개기 

     while(세로 > 최초){
        가로 += 1;
        세로 = 0;
        for(var i in team){

           세로 += Math.ceil(team[i].count/가로);
        }
        
        if(최소 > Math.max(가로, 세로)){
            결정가로 = 가로;
            결정세로 = 세로;
        }

     }
     
     var next = team[team_other["team_start"]];
     team_other["결정가로"] = 결정가로;
     team_other["결정세로"] = 결정세로;

     var num = 0;

     while(next){
         
         next.세로 = num;
         num += Math.ceil(next.count/결정가로);
         

         if(next.next){
            next = team[next.next];
         }else{
            next = "";
         }

     }
     // 210406 아래 함수 nodedatasetting2에서 활용할 것
     // 먼저 이 console부터 보고 시작할 것
     

     
     return {team: team, team_other: team_other}
  


  }
   
  nodedatasetting = (pos) => {
   // 그럼 위의 것이 나온다고 생각하면 됨
   
   /*
    this.diagram.add(
    $(go.Part, "Vertical",
      $(go.Node, "Auto", {location: "0 0"}),
      $(go.TextBlock, {text: "통제활동", font: '15px serif', margin: 2 }),
    )) 
   */

   var realarr = []
   


   //팀 세팅
   /* 팀 그림은 딱 고정되도록 canvas로 그리는게 좋을 듯
   var team =  {key : "회계팀", hei: 100, loc: "-150 0", fig: "Rectangle", color: "white"}
   realarr.push(team);
   var team =  {key : "자금팀", hei: 100, loc: "-150 100", fig: "Rectangle", color: "white"}
   realarr.push(team);
   */
   
   var arr = {} // 서버에서 받을 배열, 현재는 있다고 가정
   var shape = [{shape : "Rectangle", wid : 50, hei : 50}, {shape : "Decision", wid : 70, hei : 50}, 
                {shape : "Cylinder1", wid : 50, hei : 50}, {shape : "SquareArrow", wid : 50, hei : 50, angle: 90}]

   for(var i = 0; i < 4; i++){
      // sublistloop를 가져다 쓰는 것이 바탕이 되야함
      // 기본 그림
      // 지금은 임의로 내가 위치를 세팅 시켰는데, 서버에서 프로세스 배열이 넘어오면
      // 이런식으로 세팅할 것(아래 3문장 참고)
      //var y = this.divisionpos[arr["team"]]
      //var x = this.divisions[arr["team"]] * this.divisionsize_x;
      //this.divisions[arr["team"]] += 1;      

      var x = pos;
      var y = 70 * i;
      var obj = {key : "취득" + i,  fig: shape[i].shape, wid: shape[i].wid,
                 hei: shape[i].hei, angle: shape[i].angle, color: "white", loc: x + " " + y}
      

      // 부모 넣어주기
      if(i > 0){
        var before = i - 1;
        obj.parent = "취득" + before; 
      }
      this.nodedata.push(obj);
      
      // 통제활동이 있으면 추가할 것
      if(1 == 1){  // 나중에 조건 집어넣을 것
         this.pic_control(x, y)
      }

      // erp가 있으면 추가할 것
      if(1 == 1){  // 나중에 조건 집어넣을 것
         this.pic_erp(x, y)
      }



     }
     
   }


  nodedatasetting2 = (totalarr, first) => {
   // 그럼 위의 것이 나온다고 생각하면 됨
   
   var temp = this.possetting(totalarr);
   var team = temp.team;
   var team_other = temp.team_other;

   // return 된 team의 구조
   // {team_start: "영업팀"
   // 영업팀: {count: 3, 가로: 0, 세로: 0, before: "", next: "회계팀"}
   // 회계팀: {count: 1, 가로: 0, 세로: 2, before: "영업팀"}   }

   var realarr = []
   
   var arr = [first.name];
   

   var shape = [{shape : "Rectangle", wid : 50, hei : 50}, {shape : "Decision", wid : 70, hei : 50}, 
                {shape : "Cylinder1", wid : 50, hei : 50}, {shape : "SquareArrow", wid : 50, hei : 50, angle: 90}]

   var count = 1;
   var co = 0;
   while(count > 0 && co < 10){
    co += 1;
    
    var next = [];

    for(var i in arr){
      // sublistloop를 가져다 쓰는 것이 바탕이 되야함
      // 기본 그림
      // 지금은 임의로 내가 위치를 세팅 시켰는데, 서버에서 프로세스 배열이 넘어오면
      // 이런식으로 세팅할 것(아래 3문장 참고)
      //var y = this.divisionpos[arr["team"]]
      //var x = this.divisions[arr["team"]] * this.divisionsize_x;
      //this.divisions[arr["team"]] += 1;      
      
      next = next.concat(totalarr[arr[i]].next);
      
      var turn = totalarr[arr[i]];
        
      
      // 위치결정
      var x = team[turn.team]["가로"] * this.width + 50;
      var y = team[turn.team]["세로"] * this.height + 50;

      // 다음 위치 배정하기      
      team[turn.team]["가로"] += 1;
      if(team[turn.team]["가로"] >= team_other["결정가로"]){
        team[turn.team]["가로"] = 0;
        team[turn.team]["세로"] += 1;
      }


      var obj = {key : turn.name,  fig: turn.shape, wid: turn.name.length * 15, 
                 hei: 50, angle: shape[i].angle, color: "white", loc: x + " " + y,
                 parent: turn.before, realkey: turn.name, }
      

      this.nodedata.push(obj);

      // 부모 넣어주기
      if(i > 0){
        var before = i - 1;
        //obj.parent = "취득" + before; 
      }
      
      // 통제활동이 있으면 추가할 것
      if(1 == 1){  // 나중에 조건 집어넣을 것
         this.pic_control(x, y)
      }

      // erp가 있으면 추가할 것
      if(1 == 1){  // 나중에 조건 집어넣을 것
         this.pic_erp(x, y)
      }



      }

      count = next.length;
      arr = next.slice();
      
    } 
     
   }


  nodedatasetting_graph = (totalarr, first) => {
   // 그럼 위의 것이 나온다고 생각하면 됨
   
   var temp = this.possetting(totalarr);
   var team = temp.team;
   var team_other = temp.team_other;

   // return 된 team의 구조
   // {team_start: "영업팀"
   // 영업팀: {count: 3, 가로: 0, 세로: 0, before: "", next: "회계팀"}
   // 회계팀: {count: 1, 가로: 0, 세로: 2, before: "영업팀"}   }
   
   // 210504 team에 새로운 팀이 추가되면 오류가 발생함 오류 해결 방안 고민할 것
   
   var realarr = []
   var arr = [first.name];
   
   for(var i in team){
	   this.nodedata.push({"key": i, "isGroup": true, "text": i, "horiz": true});
   }

   var shape = [{shape : "Rectangle", wid : 50, hei : 50}, {shape : "Decision", wid : 70, hei : 50}, 
                {shape : "Cylinder1", wid : 50, hei : 50}, {shape : "SquareArrow", wid : 50, hei : 50, angle: 90}]

   var count = 1;
   var co = 0;
   while(count > 0 && co < 10){
    co += 1;
    
    var next = [];

    for(var i in arr){
      // sublistloop를 가져다 쓰는 것이 바탕이 되야함
      // 기본 그림
      // 지금은 임의로 내가 위치를 세팅 시켰는데, 서버에서 프로세스 배열이 넘어오면
      // 이런식으로 세팅할 것(아래 3문장 참고)
      //var y = this.divisionpos[arr["team"]]
      //var x = this.divisions[arr["team"]] * this.divisionsize_x;
      //this.divisions[arr["team"]] += 1;      
      
      
       
      for(var j in totalarr[arr[i]].next){
         if(this.passeddata.has(totalarr[arr[i]].next[j]) == false){
            this.passeddata.add(totalarr[arr[i]].next[j]);
            

            next.push(totalarr[arr[i]].next[j]) 
         }
      }

      var turn = totalarr[arr[i]];
        
      
      // 위치결정
      var x = team[turn.team]["가로"] * this.width + 50;
      var y = team[turn.team]["세로"] * this.height + 50;

      // 다음 위치 배정하기      
      team[turn.team]["가로"] += 1;
      if(team[turn.team]["가로"] >= team_other["결정가로"]){
        team[turn.team]["가로"] = 0;
        team[turn.team]["세로"] += 1;
      }


      var obj = {key : turn.name, group: turn.team, fig: turn.shape, wid: turn.name.length * 15, 
                 hei: 50, angle: shape[i].angle, color: "white", loc: x + " " + y,
                 parent: turn.before, realkey: turn.name, stretch: go.GraphObject.Vertical}
     
      var obj2 = [];
      for(var j in turn.next){
         var temp = {from: turn.name,to: turn.next[j]}   
         obj2.push(temp);     
      }

     

      this.nodedata.push(obj);
      this.graphdata = this.graphdata.concat(obj2); 
      // 부모 넣어주기
      if(i > 0){
        var before = i - 1;
        //obj.parent = "취득" + before; 
      }
      
      // 통제활동이 있으면 추가할 것
      if(1 == 1){  // 나중에 조건 집어넣을 것
         this.pic_control(x, y)
      }

      // erp가 있으면 추가할 것
      if(1 == 1){  // 나중에 조건 집어넣을 것
         this.pic_erp(x, y)
      }



      }

      count = next.length;
      arr = next.slice();
      
    } 


     
   }

 
  pic_erp = (x, y) => {
     // erp 그림 추가할 것

  }
  
  pic_control = (x, y) => {
      // 통제활동 그리기

      var x = x + 70 ;
      
      var obj = {wid: 15, hei: 15, font : '0px serif',  fig: "Triangle", color: "lightgreen", loc: x + " " + y}
      this.nodedata.push(obj);

      var x = x + 20;
      var obj = {wid: 15, hei: 15, font : '0px serif', fig: "Triangle", color: "darkred", loc: x + " " + y}
      this.nodedata.push(obj);

      var y = y + 16;
      var x = x - 15
      var obj = {wid: 30, hei: 10,stroke: null, key: "통제활동", font : '5px serif', color: "white", loc: x + " " + y}
      this.nodedata.push(obj);

  }
  
  
  picture = (opt) => {
    
    if(opt == "tree"){
       this.diagram.model = new go.TreeModel(this.nodedata);
    }else if(opt == "graph"){
       this.diagram.model = new go.GraphLinksModel(this.nodedata, this.graphdata);
    }

    this.makeselect(this.diagramselect_pa, this.diagram.model.nodeDataArray, "realkey");
    this.makeselect(this.diagramselect_ch, this.diagram.model.nodeDataArray, "realkey");
  }

  picture2 = () => {

  
  }


  makeselect = (tag, arr, key) => {
     
        var select = tag;
        
        for(var i in arr){
          
          if(key){
            if(key in arr[i]){
              var opt = document.createElement('option');
              //opt.setAttribute('value', i)
              opt.innerText = arr[i][key];
              select.appendChild(opt)
            }  
          }else{
            var opt = document.createElement('option');
            //opt.setAttribute('value', i)
            opt.innerText = arr[i];
            select.appendChild(opt)
          }
        }
        return select;

    }

// ajax 관련

	ajaxmethod = (name) => {
		
		var processname = "재무보고";
		var subprocess = "전표관리";  // 현재는 임의로 세팅해줌
        var detailprocessname = name;
		
		var data = {processname: processname, subprocess: subprocess, detailprocessname: detailprocessname};
		
		
		// 스프링 시큐리티 관련
		var header = $("meta[name='_csrf_header']").attr('content');
		var token = $("meta[name='_csrf']").attr('content');
		
   		$.ajax({
   			type : "POST",
   			url : "/sp5-chap11/register/controlmethod",
   			data : data,
   			beforeSend: function(xhr){
   			  if(token && header) {
   				  //console.log(header);
   				  //console.log(token);
   		       // xhr.setRequestHeader(header, token);
   			  } 
   		    },
   		    success : (res) => {
   				
   				this.inputtable(res)
 
   			},
            error: function (jqXHR, textStatus, errorThrown)
            {
                   console.log(errorThrown + " " + textStatus);
            }
   		})		
	}

	poolmake = (name) => {
		
		
		// 스프링 시큐리티 관련
		var header = $("meta[name='_csrf_header']").attr('content');
		var token = $("meta[name='_csrf']").attr('content');
		
		console.log(name);
		
		// ajax 관련
   		$.ajax({
   			type : "POST",
   			url : "/sp5-chap11/register/poolmake",
   			beforeSend: function(xhr){
   			  if(token && header) {
   				  //console.log(header);
   				  //console.log(token);
   		       // xhr.setRequestHeader(header, token);
   			  } 
   		    },
   		    success : (res) => {
   				
   				this.datapool = res;
 
   			},
            error: function (jqXHR, textStatus, errorThrown)
            {
                   console.log(errorThrown + " " + textStatus);
            }
   		})		
	}	
	
// tag 관련

     //^^ viex에 관한 함수
    maketable = () => {
        // processlist 반영하기 
    	for(var i = 0; i < this.tablesize.height;i++){
    	    this.tablearr[i] = {}
    	    var subdiv = this.maketrtd(this.tablearr[i]);
     		this.table.appendChild(subdiv)
    	}
    }

    maketable2 = () => {
        // processlist 반영하기 
    	for(var i = 0; i < this.table2size.height;i++){
    	    this.table2arr[i] = {}
    	    var subdiv = this.maketrtd(this.table2arr[i]);
     		this.table2.appendChild(subdiv)
    	}
    }
    
    
    
    inputtable = (arr, data, node) => {

        var rowval = Math.min(arr.length, this.tablesize.height - 1);
    	
        if(data == null){
        	data = arr
        }
        
        var r = 0;    
    	for(var i in arr){
                r += 1;
                try{
                   this.tablearr[r][0].innerText = data[i].detailprocessname;
                   this.tablearr[r][1].innerText = data[i].processexplain;
                   console.log(arr);
                   if(node != null){
                	   // 좌측의 팔레트를 클릭했을때임
                       this.additem4(this.tablearr[r][2], this.tablearr[r][0], node);
                   }else{
                	   // 가운데의 다이어크램을 클릭했을때임
                       console.log("여기는 안옴");
                	   this.additem5(this.tablearr[r][2], data[i]);
                   }

                }catch{
                   
                }
                
                if(r > rowval){
                	break;
                }

            
         }
    }

    inputtable2 = (arr) => {

        var rowval = Math.min(arr.length, this.tablesize.height - 1);
        var r = 0;    
                 r += 1;
                try{
                   this.table2arr[r][0].innerText = arr.controlname;
                   this.table2arr[r][1].innerText = arr.controlexplain;
 

                }catch{
                   
                }
         
    }

    maketrtd = (arr) => {
       
     	var div = document.createElement("tr")

     	div.style = "height : 20px";

     	for(var i = 0; i < this.tablesize.width;i++){
    	   var subdiv = document.createElement("td");

    	   arr[i] = subdiv;
    	   if(i == 0){
        	   subdiv.setAttribute("width","30%");
    	   }else if(i == 1){
    		   subdiv.setAttribute("width","60%");
    	   }else if(i == 2){
    		   subdiv.setAttribute("width","10%");
    	   }
    	   div.appendChild(subdiv);
     	}
    	return div
    }  
    
    makelabel = (item) => {

    	item[0][2].innerText = "선택";
        
        for(var i = 1; i <= this.tablesize.height - 1; i++){
           // 라디오 버튼을 테이브 앞단에 둬, 제목열 선택할 수 있게할 것
           this.selectlabel[i] = document.createElement("input")
           this.selectlabel[i].setAttribute('type', "radio");
           this.selectlabel[i].setAttribute('name', "subject");
           
           // 나중에 이것으로 이벤트 추가할 것 this.additem2(this.selectlabel[i], i);

           item[i][2].appendChild(this.selectlabel[i])   
        }
    }

    additem2 = (item, i) => {
        item.addEventListener('change',(me)=>{
             this.itemarray["제목행"] = i;
        })
    }
    
    additem3 = (item) => {
        item.addEventListener('click',(me)=>{
             console.log("click");
             this.testselect()
        })

    }

    additem4 = (item, item2) => {
        item.addEventListener('click',() => {
        	  console.log(this.Palette.model.nodeDataArray);
        	  var temp = this.Palette.model.nodeDataArray[0] 
        	  var obj = {key : item2.innerText,  shape: temp.shape, wid: temp.wid, 
                  hei: temp.hei, color: temp.color, type: temp.type,
                  realkey: temp.realkey};
        	 
        	  this.Palette.model = new go.TreeModel([obj])
              
        })

    }    

    additem5 = (item, arr) => {
        item.addEventListener('click',(me)=>{
             console.log("click");
             this.inputtable2(arr);
        })
    }


    addlisten = (item) => {
        item.addEventListener('click',()=>{
             this.myworkradio.forEach((node) => {
            	    if(node.checked)  {
            	        console.log(node.value);
                	    //this.poolmake(name);
            	    }
         	  }) 
   
             
             
        })
    }

    
    // div에 관한 것
    
    makediv = (text1, text2, text3) => {
    	var div = document.createElement("div")
        div.style = "overflow : hidden; ";

    	var subdiv1 = document.createElement("div")
    	var style = "float : left; width : 100px; border: 1px solid gold;";
    	subdiv1.style = style;
    	subdiv1.innerText = text1;
    	

    	var subdiv2 = document.createElement("div")
    	var style = "float : left; width : 100px;border: 1px solid gold;";
    	subdiv2.style = style;
        subdiv2.innerText = text2;

    	var subdiv3 = document.createElement("div")
    	var style = "float : left; width : 100px;border: 1px solid gold;";
    	subdiv3.style = style;
        subdiv3.innerText = text3;

        div.appendChild(subdiv1);
        div.appendChild(subdiv2);
        div.appendChild(subdiv3);
        
        return div;
    }
  


// 복붙한 함수
     animateFadeDown(e) {
        var diagram = e.diagram;
        var animation = new go.Animation();
        animation.isViewportUnconstrained = true; // So Diagram positioning rules let the animation start off-screen
        animation.easing = go.Animation.EaseOutExpo;
        animation.duration = 900;
        // Fade "down", in other words, fade in from above
        animation.add(diagram, 'position', diagram.position.copy().offset(0, 200), diagram.position);
        animation.add(diagram, 'opacity', 0, 1);
        animation.start();
      }

      nodeStyle() {
        return [
          // The Node.location comes from the "loc" property of the node data,
          // converted by the Point.parse static method.
          // If the Node.location is changed, it updates the "loc" property of the node data,
          // converting back using the Point.stringify static method.
          new go.Binding("location", "loc", go.Point.parse).makeTwoWay(go.Point.stringify),
          {
            // the Node.location is at the center of each node
            locationSpot: go.Spot.Center
          }
        ];
      }

      textStyle() {
        return {
          font: "bold 11pt Lato, Helvetica, Arial, sans-serif",
          stroke: "#F8F8F8"
        }
      }


      makePort = (name, align, spot, output, input) => {
        //console.log(this.nodedata)
        var horizontal = align.equals(go.Spot.Top) || align.equals(go.Spot.Bottom);
        // the port is basically just a transparent rectangle that stretches along the side of the node,
        // and becomes colored when the mouse passes over it
        return $$(go.Shape,
          {
            fill: "transparent",  // changed to a color in the mouseEnter event handler
            strokeWidth: 0,  // no stroke
            width: horizontal ? NaN : 8,  // if not stretching horizontally, just 8 wide
            height: !horizontal ? NaN : 8,  // if not stretching vertically, just 8 tall
            alignment: align,  // align the port on the main Shape
            stretch: (horizontal ? go.GraphObject.Horizontal : go.GraphObject.Vertical),
            portId: name,  // declare this object to be a "port"
            fromSpot: spot,  // declare where links may connect at this port
            fromLinkable: output,  // declare whether the user may draw links from here
            toSpot: spot,  // declare where links may connect at this port
            toLinkable: input,  // declare whether the user may draw links to here
            cursor: "pointer",  // show a different cursor to indicate potential link point
            mouseEnter: function(e, port) {  // the PORT argument will be this Shape
              if (!e.diagram.isReadOnly) port.fill = "rgba(255,0,255,0.5)";
            },
            mouseLeave: function(e, port) {
              port.fill = "transparent";
            }
          });
      }

}
  

  
//shape 관련 : Circle, Ellipse, Rectangle



  // 예제
  var nodeDataArray = [
    { key: "Alpha", color: "lightblue", fig: "Rectangle", loc: "0 0" },
    { key: "Beta", parent: "Alpha", color: "white", fig: "Ellipse", loc: "250 40"},  // note the "parent" property
    { key: "Gamma", parent: "Alpha", color: "white" , fig: "Ellipse", loc: "100 0"},
    { key: "Delta", parent: "Alpha", color: "white" , fig: "Ellipse", loc: "150 30"}
  ];
  
/*
  var datasetting = {
   계약체결: { name: "계약체결", next: ["주문하기", "전표작성"], before: "", team: "영업팀", shape: "Rectangle" },
   주문하기: { name: "주문하기", next: ["입고하기"], before: "계약체결", team: "영업팀", shape: "Rectangle" },  // note the "parent" property
   입고하기: { name: "입고하기", next: [], before: "주문하기", team: "영업팀", shape: "Rectangle" },  // note the "parent" property
   전표작성: { name: "전표작성", next: ["전표승인"], before: "계약체결", team: "회계팀", shape: "Rectangle" },
   전표승인: { name: "전표승인", next: ["결재하기"], before: "전표작성", team: "회계팀", shape: "Rectangle" },
   결재하기: { name: "결재하기", next: [], before: "전표승인", team: "자금팀", shape: "Rectangle" },
  };
*/
 
  var datasetting = {
      "전표 접수": { name: "전표 접수", next: ["전표 작성"], before: [], team: "회계팀", shape: "Rectangle", type: 1 },
      "전표 작성": { name: "전표 작성", next: ["전표 승인 권한 부여"], before: ["전표 접수"], team: "영업팀", shape: "Rectangle", type: 1 },  
      "전표 승인 권한 부여" : { name: "전표 승인 권한 부여", next: [], before: ["전표 작성"], team: "회계팀", shape: "Rectangle", type: 1 },  // note the "parent" property
  };
 


  window.onload = function(){
     
	 // diagram 관련 세팅 
	 var diagram1 = new diagram();
     //diagram1.nodedatasetting(0);
     
     
     
     // 데이타 세팅
     // 1. 서버에서 관련 데이터 풀 받아오기
     diagram1.poolmake("전표관리");
     
     // 2. 현재는 표준 플로우차트 열이 없어서 임의로 세팅함
     diagram1.datasetting = datasetting;

     diagram1.nodedatasetting_graph(datasetting, datasetting["전표 접수"]);
     
     diagram1.picture("graph");

     //diagram1.picture2();

    // ajax 관련 세팅 
    var request = createRequest(request);
 	request.onreadystatechange = function (event){
		if(request.readyState ==4){
			if (request.status == 200){
    			//console.log(request.response)
    			
			}
		}
	}


  }




 
  </script>