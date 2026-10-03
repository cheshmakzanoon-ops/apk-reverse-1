local UIAllianceCareerCtrl = BaseClass("UIAllianceCareerCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceCareerEdit)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIAllianceCareerCtrl.CloseSelf = CloseSelf
UIAllianceCareerCtrl.Close = Close
return UIAllianceCareerCtrl
