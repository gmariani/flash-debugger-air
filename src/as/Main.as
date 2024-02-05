import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.FileFilter;

import mx.controls.ComboBox;
import mx.controls.TabBar;
import mx.events.FlexEvent;
import mx.events.ItemClickEvent;
import mx.collections.ArrayCollection;

private var updateScroll:Boolean = true;
private var fileSOL:File = new File();
private var fileFlashLog:File = File.userDirectory;
private var fsFlashLog:FileStream = new FileStream();
private var strOS:String;

[Bindable]
public var STATE_ARRAY:Array = [
	{label:"Trace Ouput", data:"tracer"},
    {label:"SOL Editor", data:"editor"}
];

[Bindable]
public var FONT_SIZES:ArrayCollection = new ArrayCollection(
	[{label:"6", data:6},
	{label:"7", data:7},
	{label:"8", data:8},
	{label:"9", data:9},
	{label:"10", data:10},
	{label:"11", data:11},
	{label:"12", data:12},
	{label:"13", data:13},
	{label:"14", data:14},
	{label:"15", data:15},
	{label:"16", data:16} ]);
// Todo: Read/Edit mm.cfg file to enable or disable errors
/*
Macintosh OS X - MacHD:Library:Application Support:macromedia:mm.cfg 
Microsoft Windows XP - C:\Documents and Settings\user_name\mm.cfg
Windows 2000 - C:\mm.cfg
Linux - ~/.macromedia/Flash_Player/Logs/mm.cfg

mm.cfg
ErrorReportingEnable   1 to enable, 0 to disable def 0
MaxWarnings  def 100  set to 0 to remove limit
TraceOutputFileEnable  1 to enable, 0 to disable def 0
*/

private function init(e:FlexEvent):void {
	var strUserDir:String = fileFlashLog.url;
	
	// Find location of flashlog.txt
	fileFlashLog = fileFlashLog.resolvePath(strUserDir + "/Application Data/Macromedia/Flash Player/Logs/flashlog.txt"); // Win
	trace("Check Windows: " + fileFlashLog.url);
	if(fileFlashLog.exists) {
		strOS = "Win";
	} else {
		fileFlashLog = fileFlashLog.resolvePath(strUserDir + "/Library/Preferences/Macromedia/Flash Player/Logs/flashlog.txt"); // Mac
		trace("Check mac: " + fileFlashLog.url);
		if(fileFlashLog.exists) {
			strOS = "Mac";
		} else {
			fileFlashLog = fileFlashLog.resolvePath(strUserDir + "/.macromedia/Flash_Player/Logs/flashlog.txt"); // Linux
			trace("Check Linux: " + fileFlashLog.url);
			strOS = "Linux"
		}
	}
	
	// Open file
	fsFlashLog.addEventListener(ProgressEvent.PROGRESS, readProgressHandler);
	fsFlashLog.addEventListener(Event.COMPLETE, readCompleteHandler);
	fsFlashLog.addEventListener(IOErrorEvent.IO_ERROR, readIOErrorHandler);
	fsFlashLog.openAsync(fileFlashLog, FileMode.READ); // .open
}

private function readProgressHandler(e:ProgressEvent):void {
	taBuffer.text += "Progress";
}

private function readCompleteHandler(e:Event):void {
	var str:String = fsFlashLog.readMultiByte(fsFlashLog.bytesAvailable, File.systemCharset);
	taBuffer.text += str;
	//fsFlashLog.close();
}

private function readIOErrorHandler(e:IOErrorEvent):void {
	taBuffer.text = "Error reading file";
}

private function onClickTab(event:ItemClickEvent):void {
	var targetComp:TabBar = TabBar(event.currentTarget);
	var data:String = targetComp.dataProvider[event.index].data;
	var label:String = event.label;
}

private function onClickClear():void {
	taBuffer.text = "";
}

private function onClickLock():void {
	updateScroll = !updateScroll;
}

private function onClickOptions():void {
	vsMain.selectedChild = TracerOptions;
}

private function onClickPause():void {
	//
}

private function onClickBrowse():void {
	browse();
}

private function onClickDownload():void {
	var u:URLRequest = new URLRequest("http://www.adobe.com/support/flashplayer/downloads.html");
	navigateToURL(u,"_blank"); 
}

private function onClickSave():void {
	vsMain.selectedChild = TracerMain;
}

private function onClickCancel():void {
	vsMain.selectedChild = TracerMain;
}

private function onClickWrap(e:Event):void {
	taBuffer.wordWrap = e.currentTarget.selected;
}

private function onEnterFrame():void {
	//
}

private function onCloseDD(e:Event):void {
	taBuffer.setStyle("fontSize", ComboBox(e.target).selectedItem.data);
}

private function browse():void {
	var fileFilters:Array = new Array();
	fileFilters.push(new FileFilter("SOL Files", "*.sol", "SOL"));
	fileSOL.addEventListener(Event.SELECT, onFileSelection);
	fileSOL.browse(fileFilters);
}

private function onFileSelection(e:Event):void {
	var objData:Object = new Object();
	var bytes:FileStream = new FileStream();
	bytes.open(fileSOL, FileMode.READ);
	
	// Start reading in text
}