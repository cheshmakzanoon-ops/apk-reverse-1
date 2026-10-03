local UITacticalAttributeInfoCtrl = BaseClass("UITacticalAttributeInfoCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalAttributeInfo)
end

UITacticalAttributeInfoCtrl.CloseSelf = CloseSelf
return UITacticalAttributeInfoCtrl
