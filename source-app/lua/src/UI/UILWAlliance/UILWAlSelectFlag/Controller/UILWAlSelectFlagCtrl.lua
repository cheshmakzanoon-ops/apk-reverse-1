local UILWAlSelectFlagCtrl = BaseClass("UILWAlSelectFlagCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlSelectFlag)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UILWAlSelectFlagCtrl.CloseSelf = CloseSelf
UILWAlSelectFlagCtrl.Close = Close
return UILWAlSelectFlagCtrl
