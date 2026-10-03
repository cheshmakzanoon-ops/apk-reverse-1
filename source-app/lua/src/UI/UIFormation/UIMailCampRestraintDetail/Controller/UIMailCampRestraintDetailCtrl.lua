local UIMailCampRestraintDetailCtrl = BaseClass("UIFormationStateCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMailCampRestraintDetail)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIMailCampRestraintDetailCtrl.CloseSelf = CloseSelf
UIMailCampRestraintDetailCtrl.Close = Close
return UIMailCampRestraintDetailCtrl
