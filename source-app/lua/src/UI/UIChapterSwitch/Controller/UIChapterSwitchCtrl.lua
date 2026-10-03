local UIChapterSwitchCtrl = BaseClass("UIChapterSwitchCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIChapterSwitch, {anim = true})
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIChapterSwitchCtrl.CloseSelf = CloseSelf
UIChapterSwitchCtrl.Close = Close
return UIChapterSwitchCtrl
