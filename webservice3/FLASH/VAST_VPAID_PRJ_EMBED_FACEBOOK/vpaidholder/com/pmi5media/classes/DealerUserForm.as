﻿package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.text.TextFieldType;
	import flash.display.Shape;
	import flash.text.TextFormat;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;


	public class DealerUserForm extends MovieClip {

		private var objFindBtn: SimpleButton = new FindBtn();
		private var objUserInput: TextField = new TextField();
		private var objTextFormat: TextFormat = new TextFormat();
		private var formXMLList: XMLList = new XMLList();

		public function DealerUserForm() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
		}

		private function added(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, added);

			objTextFormat.font = "verdana";
			objTextFormat.bold = true;
			objTextFormat.size = 26;
			objUserInput.x = 34;
			objUserInput.y = 100;
			objUserInput.height = 44;
			objUserInput.width = 244;
			objUserInput.type = TextFieldType.INPUT;
			objUserInput.defaultTextFormat = objTextFormat;

			this.addChild(objUserInput);

			objFindBtn.x = 290;
			objFindBtn.y = 76;

			this.addChild(objFindBtn);

			objFindBtn.addEventListener(MouseEvent.CLICK, findClick, false, 0, true);


		}

		public function formData(pData: XMLList): void {
			formXMLList = pData;
			this.x = formXMLList.offsetx;
			this.y = formXMLList.offsety;

		}
		private function findClick(e: MouseEvent): void {
			navigateToURL(new URLRequest(formXMLList.mapurl + "" + formXMLList.keywords + "+" + objUserInput.text));
		}

	} //class
} //pkg