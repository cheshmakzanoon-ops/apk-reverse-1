local base = UIBaseContainer
local UILWTorchRelayBattleMainDebugItemComponent = BaseClass("UILWTorchRelayBattleMainDebugItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWTorchRelayBattleMainDebugItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWTorchRelayBattleMainDebugItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTorchRelayBattleMainDebugItemComponent:ComponentDefine()
  self.textTitle = self:AddComponent(UIText, "TitleText")
  self.textValue = self:AddComponent(UIText, "ValueText")
end

function UILWTorchRelayBattleMainDebugItemComponent:ComponentDestroy()
  self.textTitle = nil
  self.textValue = nil
end

function UILWTorchRelayBattleMainDebugItemComponent:DataDefine()
end

function UILWTorchRelayBattleMainDebugItemComponent:DataDestroy()
end

function UILWTorchRelayBattleMainDebugItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWTorchRelayBattleMainDebugItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWTorchRelayBattleMainDebugItemComponent:SetData(key, value)
  self.textTitle:SetText(key)
  self.textValue:SetText(value)
end

return UILWTorchRelayBattleMainDebugItemComponent
