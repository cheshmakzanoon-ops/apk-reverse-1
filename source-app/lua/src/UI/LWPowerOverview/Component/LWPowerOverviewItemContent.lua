local LWPowerOverviewItemContent = BaseClass("LWPowerOverviewItemContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function LWPowerOverviewItemContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWPowerOverviewItemContent:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWPowerOverviewItemContent:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "")
  self.name = self:AddComponent(UIText, "Content/name")
  self.value = self:AddComponent(UIText, "Content/value")
end

function LWPowerOverviewItemContent:ComponentDestroy()
  self.root = nil
  self.name = nil
  self.value = nil
end

function LWPowerOverviewItemContent:DataDefine()
end

function LWPowerOverviewItemContent:DataDestroy()
end

function LWPowerOverviewItemContent:OnBtnClick()
end

function LWPowerOverviewItemContent:Refresh(data)
  self.data = data
  self.name:SetLocalText(self.view.ctrl:GetNameKeyBySourceType(self.data.sourceType))
  self.value:SetText(string.GetFormattedSeperatorNum(math.floor(self.data.sourceVal)))
end

return LWPowerOverviewItemContent
