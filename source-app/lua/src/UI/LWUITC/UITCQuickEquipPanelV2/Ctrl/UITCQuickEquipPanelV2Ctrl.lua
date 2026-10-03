local UITCQuickEquipPanelV2Ctrl = BaseClass("UITCQuickEquipPanelV2Ctrl", UIBaseCtrl)

function UITCQuickEquipPanelV2Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITCQuickEquipPanelV2)
end

function UITCQuickEquipPanelV2Ctrl.ReqCustomData()
  DataCenter.TacticalCardDataManager:ReqCustomPlanList()
end

return UITCQuickEquipPanelV2Ctrl
