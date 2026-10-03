local UICommonMessageSpecialBarCtrl = BaseClass("UICommonMessageSpecialBarCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonMessageSpecialBar, {anim = true, playEffect = false})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UICommonMessageSpecialBarCtrl.CloseSelf = CloseSelf
UICommonMessageSpecialBarCtrl.Close = Close
return UICommonMessageSpecialBarCtrl
