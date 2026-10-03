local base = UIBaseCtrl
local UIRaceEntranceCtrl = BaseClass("UIRaceEntranceCtrl", base)

function UIRaceEntranceCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRaceEntrance)
end

function UIRaceEntranceCtrl:OnCustomKeyCodeEscape()
  if self.view then
    self.view:OnBtnClick()
  else
    self:CloseSelf()
  end
end

function UIRaceEntranceCtrl:SetView(view)
  self.view = view
end

function UIRaceEntranceCtrl:GetTopItemPrefabPathAndCls(actType)
  if actType == EnumActivity.ActDsbDuel.Type then
    return "Assets/Main/Prefabs/UI/UIRaceEntrance/UIRaceEntranceDsbTopItem.prefab", "UI.UIRaceEntrance.Component.UIRaceEntranceDsbTopItemComponent"
  end
end

return UIRaceEntranceCtrl
