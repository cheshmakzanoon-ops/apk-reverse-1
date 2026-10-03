local UIEquipMainPanelCtrl = BaseClass("UIEquipMainPanelCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEquipMainPanel)
end

UIEquipMainPanelCtrl.CloseSelf = CloseSelf
return UIEquipMainPanelCtrl
