local UIAllianceQaCtrl = BaseClass("UIAllianceQaCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceQa)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIAllianceQaCtrl.CloseSelf = CloseSelf
UIAllianceQaCtrl.Close = Close
return UIAllianceQaCtrl
