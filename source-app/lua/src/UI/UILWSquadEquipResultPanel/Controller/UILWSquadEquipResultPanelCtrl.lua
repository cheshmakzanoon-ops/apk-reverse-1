local UILWSquadEquipResultPanelCtrl = BaseClass("UILWSquadEquipResultPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSquadEquipResultPanel)
end

UILWSquadEquipResultPanelCtrl.CloseSelf = CloseSelf
return UILWSquadEquipResultPanelCtrl
