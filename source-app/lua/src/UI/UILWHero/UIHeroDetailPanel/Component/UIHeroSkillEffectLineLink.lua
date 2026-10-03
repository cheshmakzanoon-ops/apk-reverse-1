local base = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillEffectLine")
local UIHeroSkillEffectLineLink = BaseClass("UIHeroSkillEffectLine", base)
local UIHeroSkillStar = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillStar")
local UIHeroSkillDesc = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillDesc")

function UIHeroSkillEffectLineLink:ComponentDefine()
  self.starIcon = self:AddComponent(UIHeroSkillStar, "Star/SkillStar")
  self.activeStateText = self:AddComponent(UIHeroSkillDesc, "ActiveStateText")
  self.inactiveStateText = self:AddComponent(UIHeroSkillDesc, "InactiveStateText")
  self.activeStateText:SetAlpha(1)
  self.inactiveStateText:SetAlpha(1)
end

return UIHeroSkillEffectLineLink
