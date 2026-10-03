local UIHeroCampRestraintCtrl = BaseClass("UIFormationStateCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroCampRestraint)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIHeroCampRestraintCtrl.CloseSelf = CloseSelf
UIHeroCampRestraintCtrl.Close = Close
return UIHeroCampRestraintCtrl
