local UIEquipPromoteSuccessCtrl = BaseClass("UIEquipPromoteSuccessCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEquipPromoteSuccess)
end

UIEquipPromoteSuccessCtrl.CloseSelf = CloseSelf
return UIEquipPromoteSuccessCtrl
