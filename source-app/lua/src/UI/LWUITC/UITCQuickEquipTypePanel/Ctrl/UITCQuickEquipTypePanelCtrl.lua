local UITCQuickEquipTypePanelCtrl = BaseClass("UITCQuickEquipTypePanelCtrl", UIBaseCtrl)

function UITCQuickEquipTypePanelCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITCQuickEquipTypePanel)
end

function UITCQuickEquipTypePanelCtrl:GetCurSeasonSortTypes()
  return DataCenter.TacticalCardDataManager:GetCurSeasonQuickEquipStyleTypes()
end

function UITCQuickEquipTypePanelCtrl:ConfirmQuickEquipStyleType(index)
  local curQuickEquipCardList = TacticalCardUtil.GetCurQuickEquipCardList(index)
  if not curQuickEquipCardList or table.count(curQuickEquipCardList) == 0 then
    self:CloseSelf()
    CommonUtil.PlayerPrefsSetInt(SettingKeys.TACTICAL_EQUIP_SORT_TYPE, index)
    UIUtil.ShowTipsId("battle_card_recommend_ok")
    return
  end
  local params = {}
  for slotId, v in pairs(curQuickEquipCardList) do
    local data = {}
    table.insert(params, data)
    data.uuid = v.uuid
    data.slotId = slotId
  end
  SFSNetwork.SendMessage(MsgDefines.BattleCardPutOn, params, true)
  CommonUtil.PlayerPrefsSetInt(SettingKeys.TACTICAL_EQUIP_SORT_TYPE, index)
  self:CloseSelf()
end

return UITCQuickEquipTypePanelCtrl
