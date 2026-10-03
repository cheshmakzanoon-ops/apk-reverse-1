local LWUIMigrationView_PersonalItemContent = BaseClass("LWUIMigrationView_PersonalItemContent", UIBaseContainer)
local base = UIBaseContainer

function LWUIMigrationView_PersonalItemContent:OnCreate()
  base.OnCreate(self)
  self.root = self:AddComponent(UIBaseContainer, "")
  self.name = self:AddComponent(UIText, "Content/name")
  self.value = self:AddComponent(UIText, "Content/value")
end

function LWUIMigrationView_PersonalItemContent:OnDestroy()
  base.OnDestroy(self)
end

function LWUIMigrationView_PersonalItemContent:SetData(type, idx)
  local info = DataCenter.ActMigrationManager:GetScoreInfo()
  self.name:SetLocalText(info:GetNameKeyByTypeAndIdx(type, idx))
  self.value:SetText(string.GetFormattedSeparatorNum(math.floor(info:GetPower(type, idx))))
end

return LWUIMigrationView_PersonalItemContent
