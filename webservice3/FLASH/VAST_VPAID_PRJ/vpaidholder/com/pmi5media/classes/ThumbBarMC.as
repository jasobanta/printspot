﻿package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.IOErrorEvent;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	import fl.transitions.TweenEvent;
	import flash.display.PixelSnapping;
	import flash.display.Bitmap;


	public class ThumbBarMC extends MovieClip {

		private var barXmlList: XMLList = new XMLList();
		private var smallXmlList: XMLList = new XMLList();
		private var smallTotLen: int;

		private var objPrv: MovieClip = new ThumbBarPrvMC();
		private var objNext: MovieClip = new ThumbBarNextMC();
		private var btnClicked: uint = 0;
		private var objPicHolder: MovieClip = new MovieClip();

		private var loadedArray: Array = new Array();
		private var counter: int = 0;
		private var maxArrLenNo: uint = 0;
		private var curIconName: int = -1;

		private var IconsBar: MovieClip = new MovieClip();
		private var objBarMask: Shape = new Shape();
		private var objBarBgMC: MovieClip = new MovieClip();
		private var objBarBg: Shape = new Shape();

		private var iconName: * ;
		private var isVerticalBar: Boolean;
		private var pageNo: int = 0;
		private var totalImgLen: int = 0;
		private var _maxSpeed: uint = 15;
		private var _speed: Number;
		private var _paddingTop: int;
		private var barOuterLen: int = 0;
		private var barTween: Tween;


		public function ThumbBarMC() {
			// constructor code

		}


		public function loadBarData(pData: XMLList): void {
			barXmlList = pData;
			smallXmlList = barXmlList..small;
			smallTotLen = smallXmlList.length() - 1; //for gallery pics length 
			isVerticalBar = barXmlList.@isvertical.toLowerCase() == "true";
			loadImage();
		}

		function loadImage(): void {
			var loader: Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errOnLoad, false, 0, true);
			loader.load(new URLRequest(smallXmlList[counter].imgpath));
		}

		function loaded(e: Event): void {
			e.target.removeEventListener(Event.COMPLETE, loaded);

			var objIcon: Sprite = new Sprite();
			var iconBmp:Bitmap = e.target.content as Bitmap;
			iconBmp.smoothing=true;
			iconBmp.pixelSnapping=PixelSnapping.AUTO;
			
			//objIcon.addChild(e.target.content);
			objIcon.addChild(iconBmp);
			objIcon.name = "" + counter;
			objIcon.addEventListener(MouseEvent.CLICK, onIconClick);
			objIcon.addEventListener(MouseEvent.MOUSE_OVER, onIconOver);
			objIcon.addEventListener(MouseEvent.MOUSE_OUT, onIconOut);
			objIcon.width = int(barXmlList.@iconwidth);
			objIcon.height = int(barXmlList.@iconheight);
			loadedArray.push(objIcon);

			maxArrLenNo = loadedArray.length - 1;
			if (counter == smallTotLen) {
				showThumnials(0);
			} else {
				counter++;
				loadImage();
			}
		}


		function onIconClick(e: MouseEvent): void {
			iconName = e.target.name
			for (var m: uint = 0; m < loadedArray.length; m++) {
				Sprite(loadedArray[m]).alpha = 1;
			}
			removeEffect(Sprite(e.target))
			Sprite(loadedArray[iconName]).alpha = .6;
			curIconName = iconName;
			dispatchEvent(new ThumbBarEvent(ThumbBarEvent.ICON_CLICK, iconName, true));
		}

		function onIconOver(e: MouseEvent): void {
			removeEffect(Sprite(e.target));
			addEffect(Sprite(e.target));
		}

		function onIconOut(e: MouseEvent): void {
			removeEffect(Sprite(e.target));
		}


		private function addEffect(pObj: * ): void {
			if (barXmlList.@effecttype == "jump") {
				if (isVerticalBar) {
					pObj.x -= 3;
				} else {
					pObj.y += 3;
				}
			} else {
				pObj.alpha = .6;
			}
		}

		private function removeEffect(pObj: * ): void {
			if (barXmlList.@effecttype == "jump") {
				if (isVerticalBar) {
					pObj.x = 0;
				} else {
					pObj.y = 0;
				}
			} else {
				pObj.alpha = 1;
			}
		}



		function errOnLoad(e: IOErrorEvent): void {
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, errOnLoad);
			var tempImg: Sprite = new Sprite();
			tempImg.name = "img" + counter;
			loadedArray.push(tempImg);
			counter++;
			loadImage();
		}


		function showThumnials(picno: int): void {
			totalImgLen = 0;

			if (isVerticalBar) {
				for (var k: uint = 0; k < loadedArray.length; k++) {
					loadedArray[k].y = (barXmlList.@iconheight * k)
					IconsBar.addChild(loadedArray[k]);
					totalImgLen = int(barXmlList.@iconheight) * (k + 1);
				}
			} else {
				for (var m: uint = 0; m < loadedArray.length; m++) {
					loadedArray[m].x = (barXmlList.@iconwidth * m);
					IconsBar.addChild(loadedArray[m]);
					totalImgLen = int(barXmlList.@iconwidth) * (m + 1);
				}
			}

			IconsBar.x = barXmlList.@offsetx;
			IconsBar.y = barXmlList.@offsety;
			addChild(IconsBar);

			objBarMask.graphics.beginFill(0xf00f00, .2);
			objBarMask.graphics.drawRect(barXmlList.@offsetx, barXmlList.@offsety, barXmlList.@width, barXmlList.@height);
			objBarMask.graphics.endFill();
			addChild(objBarMask);
			IconsBar.mask = objBarMask;

			if (isVerticalBar) {

				if (totalImgLen > int(barXmlList.@height)) {

					barOuterLen = IconsBar.height - (int(barXmlList.@height) + int(barXmlList.@offsety));
					objPrv.x = int(barXmlList.@offsetx) + (int(barXmlList.@width) * .5) + (AppConst.TBAR_PRV_W * .5);
					objPrv.y = int(barXmlList.@offsety);
					objPrv.rotation = 90;
					addChild(objPrv);

					objNext.x = int(barXmlList.@offsetx) + (int(barXmlList.@width) * .5) + (AppConst.TBAR_PRV_W * .5);
					objNext.y = (int(barXmlList.@offsety) + int(barXmlList.@height)) - AppConst.TBAR_NEXT_H;
					objNext.rotation = 90;
					addChild(objNext);

					_paddingTop = barXmlList.@offsety;
					addPNCustEvts();


				}
			} else {
				if (totalImgLen > int(barXmlList.@width)) {

					barOuterLen = IconsBar.width - (int(barXmlList.@width) + int(barXmlList.@offsetx));
					objPrv.x = barXmlList.@offsetx;
					objPrv.y = int(barXmlList.@offsety) + ((int(barXmlList.@iconheigh) * .5) + (int(barXmlList.@iconheight) * .5) - (AppConst.TBAR_PRV_H * .5));
					addChild(objPrv);
					objNext.x = (int(barXmlList.@width) + int(barXmlList.@offsetx)) - AppConst.TBAR_NEXT_W;
					objNext.y = int(barXmlList.@offsety) + ((int(barXmlList.@iconheigh) * .5) + (int(barXmlList.@iconheight) * .5) - (AppConst.TBAR_NEXT_H * .5));
					addChild(objNext);
					_paddingTop = barXmlList.@offsetx;
					addPNCustEvts()

				}
			}

		}

		private function addPNCustEvts(): void {
			this.addEventListener(AppConst.EVENT_TBAR_PRV_CLK, prvClick);
			this.addEventListener(AppConst.EVENT_TBAR_NEXT_CLK, nextClick);

			objPrv.visible = false;
		}

		private function movingBarOnOver(): void {
			IconsBar.addEventListener(Event.ENTER_FRAME, enterIconbarFrame, false, 0, true);
		}

		private function movingBarOut(evt: MouseEvent): void {
			IconsBar.removeEventListener(Event.ENTER_FRAME, enterIconbarFrame);
		}

		function enterIconbarFrame(evt: Event): void {

			if (isVerticalBar) {
				_speed = (objBarMask.height / 2 - objBarMask.mouseY) / (objBarMask.height / 2) * _maxSpeed;
				IconsBar.y += _speed;
				if (IconsBar.y >= _paddingTop) {
					removeEventListener(Event.ENTER_FRAME, enterIconbarFrame);
					IconsBar.y = _paddingTop;
				} else if (IconsBar.y <= ((objBarMask.height - IconsBar.height + _paddingTop - AppConst.TBAR_NEXT_H)) + AppConst.TBAR_NEXT_H) {
					removeEventListener(Event.ENTER_FRAME, enterIconbarFrame);
					IconsBar.y = (objBarMask.height - IconsBar.height + _paddingTop - AppConst.TBAR_NEXT_H) + AppConst.TBAR_NEXT_H;
				}
			} else {

				if (btnClicked == 2) {
					IconsBar.x -= int(barXmlList.@iconwidth);
					if (IconsBar.x >= (_paddingTop)) {
						removeEventListener(Event.ENTER_FRAME, enterIconbarFrame);
						IconsBar.x = (_paddingTop);
					}
				}

			}

		}


		function nextClick(e: Event): void {
			if (!isVerticalBar) {
				if (IconsBar.x <= (-barOuterLen)) {
					objNext.visible = false;
				} else {
					IconsBar.x -= int(barXmlList.@iconwidth);
					objPrv.visible = true;
					objNext.visible = true;
				}
			} else {
				if (IconsBar.y <= (-barOuterLen)) {
					objNext.visible = false;
					objPrv.visible = true;
				} else {
					IconsBar.y -= int(barXmlList.@iconheight);
					objPrv.visible = true;
				}

			}

		}

		function prvClick(e: Event): void {
			if (!isVerticalBar) {
				if (IconsBar.x < barXmlList.@offsetx) {
					IconsBar.x += int(barXmlList.@iconwidth);
					objNext.visible = true;
				} else {
					objPrv.visible = false;
					objNext.visible = true;
				}

			} else {
				if (IconsBar.y < barXmlList.@offsety) {
					IconsBar.y += int(barXmlList.@iconheight);
					objNext.visible = true;
				} else {
					objPrv.visible = false;
					objNext.visible = true;
				}
			}

		}

		private function moveBar(pDirection: * , pFrom: * , pTo: * ): void {
			return;
			disableBtns();
			barTween = new Tween(IconsBar, pDirection, Strong.easeOut, pFrom, pTo, .3, true);
			barTween.addEventListener(TweenEvent.MOTION_FINISH, onTweenFin, false, 0, true);
			barTween.stop();
			barTween.start();
		}

		private function onTweenFin(e: TweenEvent): void {
			barTween.removeEventListener(TweenEvent.MOTION_FINISH, onTweenFin);
			barTween = null;
			enableBtns();
		}

		private function enableBtns(): void {
			objPrv.enabled = true;
			objNext.enabled = true;
		}

		private function disableBtns(): void {
			objPrv.enabled = false;
			objNext.enabled = false;
		}

	} //class
}