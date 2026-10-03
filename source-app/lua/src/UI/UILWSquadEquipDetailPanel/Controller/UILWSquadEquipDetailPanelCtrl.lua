local UILWSquadEquipDetailPanelCtrl = BaseClass("UILWSquadEquipDetailPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSquadEquipDetailPanel)
end

UILWSquadEquipDetailPanelCtrl.CloseSelf = CloseSelf
return UILWSquadEquipDetailPanelCtrl
