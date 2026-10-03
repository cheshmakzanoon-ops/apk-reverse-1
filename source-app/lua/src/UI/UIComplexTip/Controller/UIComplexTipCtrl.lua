local UIComplexTipCtrl = BaseClass("UIComplexTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIComplexTip, {anim = true, playEffect = false})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIComplexTipCtrl.CloseSelf = CloseSelf
UIComplexTipCtrl.Close = Close
return UIComplexTipCtrl
