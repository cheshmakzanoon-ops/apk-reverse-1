local ArmyFormationPowerSourceItem = BaseClass("ArmyFormationPowerSourceItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function ArmyFormationPowerSourceItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ArmyFormationPowerSourceItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ArmyFormationPowerSourceItem:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "")
  self.name = self:AddComponent(UIText, "name")
  self.value = self:AddComponent(UIText, "value")
end

function ArmyFormationPowerSourceItem:ComponentDestroy()
  self.root = nil
  self.name = nil
  self.value = nil
end

function ArmyFormationPowerSourceItem:DataDefine()
end

function ArmyFormationPowerSourceItem:DataDestroy()
end

function ArmyFormationPowerSourceItem:Refresh(data)
  self.data = data
  self.name:SetLocalText(self.data.name)
  self.value:SetText(string.GetFormattedSeperatorNum(math.floor(self.data.val)))
end

return ArmyFormationPowerSourceItem
