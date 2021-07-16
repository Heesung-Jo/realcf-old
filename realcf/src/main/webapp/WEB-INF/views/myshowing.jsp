<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<html>

<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.14.3/xlsx.full.min.js"></script>
<script>




// https://docs.sheetjs.com/ 참고할 것
var rcmarray ={}    // 저거 패키지 있으니, readfile로 읽어드릴 것. 서버에서 이런식으로 넘어와서 있다고 가정

// 이것으론 BS 및 PL 및 Team만



function excelExport(event){
    var input = event.target;
    var reader = new FileReader();
    reader.onload = function(){

        var form = new makecoa();
        var fileData = reader.result;
        var wb = XLSX.read(fileData, {type : 'binary'});
        // coaarray 읽어드려서 만들기
        var arr = ["0.Total"] 
        for(var data in arr){
           var sheet = arr[data];	
           var total = wb.Sheets[sheet]["!ref"]
           var start = total.indexOf(":");
           var lastcell = total.substring(start + 1, 10);
           var range = XLSX.utils.decode_cell(lastcell);
           
        
        // 사실 아래 작업은 서버에서 하는 역할 임시적으로 하는 것이니 서버에서는 달라져야함
           for(var r = 8; r <= range.r; r++){
               var str = "K" + r;
               var str2 = "L" + r;
               var str3 = "O" + r;
               var str4 = "F" + r;

               if(str in wb.Sheets[sheet]){
                  form.rcmarray[wb.Sheets[sheet][str].v] = {설명: wb.Sheets[sheet][str2].v,
                                                    통제설명: wb.Sheets[sheet][str3].v,
                                                    서브: wb.Sheets[sheet][str4].v}

                  form.subarray.push(wb.Sheets[sheet][str4].v);                                  
               }
           }        	
        }

        console.log(form.rcmarray)

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
	    this.rcmarray = {};
	    this.subarray = [];
        this.maintag = {};
        this.button = {};
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
        console.log(this.processlist);

    	var div = document.createElement("div")
    	document.body.appendChild(div)
    	this.maintag = div;

        // processlist 반영하기 
    	for(var i in this.processlist){
    		var subdiv = this.makebuttondiv(i, this.processlist[i])
    		div.appendChild(subdiv)
    	}

    }

    makebuttondiv = (text, coas) => {
        

    	var div = document.createElement("div")
        div.style = "overflow : hidden";

    	var subdiv = document.createElement("div")
    	subdiv.style = "float : left; width : 150px";
    	subdiv.innerText = text;

        var division = this.finddivision(text);
        var select = this.makeselect(this.divisions)
        div.appendChild(subdiv);
        div.appendChild(select);

    	var subdiv = document.createElement("div");
    	subdiv.style = "float : left; width : 150px";
    	subdiv.innerText = "여기는 프로세스 설명을 담을 것";
        div.appendChild(subdiv);

        // 여기는 관련 계정을 담을 것
        var subdiv = document.createElement("div");
        subdiv.style = "float : left; width : 150px";
        var word = "";
        for(var i in coas){
           word = word + coas[i] + ", "
        }
        subdiv.innerText = word;
        div.appendChild(subdiv); 
        return div;
    }
 

    finddivision = () => {
        return "회계팀"; // 일단은 이렇게 하고 알고리즘 추가해갈것
    }

    makeform = () => {

    	var div = document.createElement("div")
    	document.body.appendChild(div)
    	this.maintag = div;

        // BS/IS 반영하기 
    	for(var i in this.rcmarray){
    		var subdiv = this.makediv(this.rcmarray[i]["서브"], i, this.rcmarray[i]["설명"], this.rcmarray[i]["통제설명"])
    		div.appendChild(subdiv)
    	}


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
            
        console.log(this.realcoa);

        this.processmap()    
    }

    makediv = (text1, text2, text3, text4) => {
    	var div = document.createElement("div")
        div.style = "overflow : hidden";

    	var subdiv1 = document.createElement("div")
    	subdiv1.innerText = text1
    	var subdiv2 = document.createElement("div")
    	subdiv2.innerText = text2
    	var subdiv3 = document.createElement("div")
    	subdiv3.innerText = text3
    	var subdiv4 = document.createElement("div")
    	subdiv4.innerText = text4

        subdiv1.style = "float : left; width : 150px";
        subdiv2.style = "float : left; width : 150px";
        subdiv3.style = "float : left; width : 300px";
        subdiv4.style = "float : left; width : 300px";

        div.appendChild(subdiv1);
        div.appendChild(subdiv2);
        div.appendChild(subdiv3);
        div.appendChild(subdiv4);
        
        // 선택가능한 계정 집어 넣어주기
        var select = this.makeselect({선택: "선택", 해당없음: "N/A"});
        div.appendChild(select);

        return div;
    }

    makeselect = (arr) => {
        console.log(arr);

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
    typefind = (name) => {
        // 위의 type 만들것 
        // array는 임시로 가정함. array = {'계정명' : '수익 등 real 계정'}
        if(oppositecoa[name]){
            return oppositecoa[name]
        }
        if(oppositesub[name]){
            return oppositesub[name]
        }

        return null;
    }


}

/*
class coa{
    constructor() {
        this.coaarray = {} // 이건 메인 coa를 컨트롤하기 위해서 만들었음
        this.subcoa = {}  // 이건 감가상각누계액, 현재가치할인차금, 사채할인발행차금 등을 컨트롤하기 위해서 만들었음
        this.oppositecoa = {} // 이게 반대로 coaarray 접근을 위한 계정명임 즉 이것을 유사성으로 순환문으로 돌리는 것임
        this.oppositesub = {} // 이것도 역시 반대로 ,subcoa 접근임
        this.companycoa = {}
        this.processmap = {} // SUBPROCESS 기준으로 쓸 것, 엑셀 기준으론
                             // ['법인카드', '자금프로세스']
        this.coaprocessmap = {} // 이것으로 coa와 프로세스 연계
                                // {현금: ['법인카드', '법인인감' ..... 등]}                      
        this.processcoamap = {} // 위의 것과 반대
    }    


    processmapmake = (self, filename, sheetname) => {
        // 이제 프로세스랑 매핑할 방법 찾기
        file = xl.load_workbook(filename)
        sheetname = sheetname
        if sheet.title == sheetname:
            for i in range(1, sheet.max_row + 1):
                if sheet.cell(row = i, column = 1).value != "":
                    this.processmap[sheet.cell(row = i, column = 1).value] = sheet.cell(row = i, column = 2).value
    }
        
    def coaarraymake(self, array, opposite, filename, sheetname):
        file = xl.load_workbook(filename)
        sheetname = sheetname
        realarray = array
        for sheet in file.worksheets:
            if sheet.title == sheetname:
                for i in range(1, sheet.max_row + 1):
                    if sheet.cell(row = i, column = 1).value != "":
                        realarray[sheet.cell(row = i, column = 1).value] = {}
                        for j in range(1, sheet.max_column):
                            if sheet.cell(row = i, column = j).value != "":
                                realarray[sheet.cell(row = i, column = 1).value]["type"] = sheetname
                                opposite[sheet.cell(row = i, column = j).value] = sheet.cell(row = i, column = 1).value
                                 
                        ## before, after를 만들려고 했으나, 어차피 i에서 +1, -1이라서 제외
                        # type를 만들어야 함. 그것이 매출유형인지, 원가유형인지, 급여인지 등으로 분류할 것임
                        # cashflow도 참고할 것
                break
            
    def typefind(self, name):
        # 위의 type 만들것 
        # array는 임시로 가정함. array = {'계정명' : '수익 등 real 계정'}
        if name in self.oppositecoa:
            self.companycoa[name] = self.oppositecoa[name]
        if name in self.oppositesub:
            self.companycoa[name] = self.oppositesub[name]
        # 단어 갯수 등으로 찾는 것은 이 뒤에 추가할 것


}

*/

/* 자바스크립트 코드로 바꿀 것
class coa:
    def __init__(self):
        self.coaarray = {} # 이건 메인 coa를 컨트롤하기 위해서 만들었음
        self.subcoa = {}   # 이건 감가상각누계액, 현재가치할인차금, 사채할인발행차금 등을 컨트롤하기 위해서 만들었음
        self.oppositecoa = {} # 이게 반대로 coaarray 접근을 위한 계정명임 즉 이것을 유사성으로 순환문으로 돌리는 것임
        self.oppositesub = {} # 이것도 역시 반대로 ,subcoa 접근임
        self.companycoa = {}
        self.processmap = {} # SUBPROCESS 기준으로 쓸 것, 엑셀 기준으론
                             # ['법인카드', '자금프로세스']
        self.coaprocessmap = {} # 이것으로 coa와 프로세스 연계
                                # {현금: ['법인카드', '법인인감' ..... 등]}                      
        self.processcoamap = {} # 위의 것과 반대
        
    def processmapmake(self, filename, sheetname):
        # 이제 프로세스랑 매핑할 방법 찾기
        file = xl.load_workbook(filename)
        sheetname = sheetname
        for sheet in file.worksheets:
            if sheet.title == sheetname:
                for i in range(1, sheet.max_row + 1):
                    if sheet.cell(row = i, column = 1).value != "":
                        self.processmap[sheet.cell(row = i, column = 1).value] = sheet.cell(row = i, column = 2).value
        
        
    def coaarraymake(self, array, opposite, filename, sheetname):
        file = xl.load_workbook(filename)
        sheetname = sheetname
        realarray = array
        for sheet in file.worksheets:
            if sheet.title == sheetname:
                for i in range(1, sheet.max_row + 1):
                    if sheet.cell(row = i, column = 1).value != "":
                        realarray[sheet.cell(row = i, column = 1).value] = {}
                        for j in range(1, sheet.max_column):
                            if sheet.cell(row = i, column = j).value != "":
                                realarray[sheet.cell(row = i, column = 1).value]["type"] = sheetname
                                opposite[sheet.cell(row = i, column = j).value] = sheet.cell(row = i, column = 1).value
                                 
                        ## before, after를 만들려고 했으나, 어차피 i에서 +1, -1이라서 제외
                        # type를 만들어야 함. 그것이 매출유형인지, 원가유형인지, 급여인지 등으로 분류할 것임
                        # cashflow도 참고할 것
                break
            
    def typefind(self, name):
        # 위의 type 만들것 
        # array는 임시로 가정함. array = {'계정명' : '수익 등 real 계정'}
        if name in self.oppositecoa:
            self.companycoa[name] = self.oppositecoa[name]
        if name in self.oppositesub:
            self.companycoa[name] = self.oppositesub[name]
        # 단어 갯수 등으로 찾는 것은 이 뒤에 추가할 것
        
*/

</script>

<body>

<input type="file" id="excelFile" onchange="excelExport(event)"/>

</body>
