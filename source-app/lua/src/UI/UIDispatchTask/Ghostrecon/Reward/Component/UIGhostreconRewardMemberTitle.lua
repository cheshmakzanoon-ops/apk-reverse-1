local UIGhostreconRewardMemberTitle = BaseClass("local UIGhostreconRewardMemberTitle", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIGhostreconRewardMemberTitle:OnCreate()
  base.OnCreate(self)
  self.title = self:AddComponent(UITextMeshProUGUIEx, "")
  self.title:SetText(Localization:GetString("ghostrecon_019"))
end

function UIGhostreconRewardMemberTitle:OnDestroy()
  self.title = nil
  base.OnDestroy(self)
end

return UIGhostreconRewardMemberTitle
