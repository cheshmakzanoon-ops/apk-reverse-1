local UIFormationRestraintCtrl = BaseClass("UIFormationStateCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFormationRestraint)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIFormationRestraintCtrl.CloseSelf = CloseSelf
UIFormationRestraintCtrl.Close = Close
return UIFormationRestraintCtrl
