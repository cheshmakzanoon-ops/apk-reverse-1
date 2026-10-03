local UIBusinessCenterCtrl = BaseClass("UIBusinessCenterCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBusinessCenter)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIBusinessCenterCtrl.CloseSelf = CloseSelf
UIBusinessCenterCtrl.Close = Close
return UIBusinessCenterCtrl
