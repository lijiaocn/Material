var codeEditor = document.getElementById("codeEditor");
var jsonEditor = document.getElementById("jsonEditor");
var jsonBtn = document.getElementById("jsonBtn");
var codeBtn = document.getElementById("codeBtn");
var compact = document.getElementById("compact");
var format = document.getElementById("format");
var save = document.getElementById("save");

//初始化编辑器模式
var codeOptions = {
	mode: 'code',
	modes: ['code'],
	onError: function(err) {
		alert(err.toString());
	}
};

var jsonOptions = {
	mode: 'tree',
	modes: ['code', 'form', 'text', 'tree', 'view'],
	onError: function(err) {
		alert(err.toString());
	}
};

//初始化编辑器内容
var codeEditor = new JSONEditor(codeEditor, codeOptions, {"a":1});
var jsonEditor = new JSONEditor(jsonEditor, jsonOptions,{"a":1});

//视图化
jsonBtn.onclick = function(){
	try{
		var codeContent = codeEditor.get();
		if(codeContent == ""){
			alert("请输入JSON数据后再转换！");
		}else{
			jsonEditor.set(codeContent);
		}
	}catch(e){
		alert("JSON数据有误！");
	}

}

//代码化
codeBtn.onclick = function(){
	try{
		var jsonContent = jsonEditor.get();
		codeEditor.set(jsonContent);
	}catch(e){
		alert("JSON数据有误！");
	}
}

//压缩
compact.onclick = function(){
	try{
		var codeContent = codeEditor.getText();
		if(codeContent == ""){
			alert("请输入JSON数据后再转换！");
		}else{
			codeContent = JSON.stringify(eval('(' + codeContent + ')'))
			codeEditor.setText(codeContent);
		}
	}catch(e){
		alert("JSON数据有误！");
	}
}

//格式化
format.onclick = function(){
	try{
		var codeContent = codeEditor.getText();
		if(codeContent == ""){
			alert("请输入JSON数据后再转换！");
		}else{
			codeContent = JSON.stringify(eval('(' + codeContent + ')'), null, 2);
			codeEditor.setText(codeContent);
		}
	}catch(e){
		alert("JSON数据有误！");
	}
}

//保存
save.onclick = function(){
	try{
		var codeContent = codeEditor.getText();
		if(codeContent == ""){
			alert("请输入JSON数据后再转换！");
		}else{
			alert(codeContent);
		}
	}catch(e){
		alert("JSON数据有误！");
	}
}
