local BattleResultDataItem = BaseClass("BattleResultDataItem", UIBaseContainer)
local base = UIBaseContainer

function BattleResultDataItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function BattleResultDataItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BattleResultDataItem:ComponentDefine()
  self.selfDataText = self:AddComponent(UIText, "SelfData")
  self.dataNameText = self:AddComponent(UIText, "DataName")
  self.otherDataText = self:AddComponent(UIText, "OtherData")
end

function BattleResultDataItem:ComponentDestroy()
  self.selfDataText = nil
  self.dataNameText = nil
  self.otherDataText = nil
end

function BattleResultDataItem:SetData(data)
  if data then
    if data.selfData then
      self.selfDataText:SetText(string.GetFormattedSeperatorNum(data.selfData))
    end
    if data.dataName then
      self.dataNameText:SetText(data.dataName)
    end
    if data.otherData then
      self.otherDataText:SetText(string.GetFormattedSeperatorNum(data.otherData))
    end
  end
end

return BattleResultDataItem
