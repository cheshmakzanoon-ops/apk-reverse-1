local ArmyFormationDetailPowerSourceItem = BaseClass("ArmyFormationDetailPowerSourceItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function ArmyFormationDetailPowerSourceItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ArmyFormationDetailPowerSourceItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ArmyFormationDetailPowerSourceItem:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "")
  self.name = self:AddComponent(UIText, "name")
  self.value = self:AddComponent(UIText, "value")
end

function ArmyFormationDetailPowerSourceItem:ComponentDestroy()
  self.root = nil
  self.name = nil
  self.value = nil
end

function ArmyFormationDetailPowerSourceItem:DataDefine()
end

function ArmyFormationDetailPowerSourceItem:DataDestroy()
end

function ArmyFormationDetailPowerSourceItem:Refresh(data)
  self.data = data
  self.name:SetLocalText(self.data.name)
  self.value:SetText(string.GetFormattedSeperatorNum(math.floor(self.data.val)))
end

return ArmyFormationDetailPowerSourceItem
