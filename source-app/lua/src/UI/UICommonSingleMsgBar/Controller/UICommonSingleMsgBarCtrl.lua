local UICommonSingleMsgBarCtrl = BaseClass("UICommonSingleMsgBarCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonSingleMsgBar, {anim = true, playEffect = false})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UICommonSingleMsgBarCtrl.CloseSelf = CloseSelf
UICommonSingleMsgBarCtrl.Close = Close
return UICommonSingleMsgBarCtrl
