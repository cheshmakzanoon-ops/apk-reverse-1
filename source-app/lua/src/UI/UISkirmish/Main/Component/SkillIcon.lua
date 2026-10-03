local SkillIcon = BaseClass("SkillIcon", UIBaseContainer)
local base = UIBaseContainer

function SkillIcon:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function SkillIcon:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SkillIcon:ComponentDefine()
  self.skillBubble = self:AddComponent(UIAnimator, "")
  self.skillImg = self:AddComponent(UIImage, "Image/Image")
  self.skillBubble:SetActive(false)
end

function SkillIcon:ComponentDestroy()
  self.skillBubble = nil
  self.skillImg = nil
end

function SkillIcon:SetData(skillWorldPos, icon)
  self.skillBubble:SetActive(true)
  self.skillBubble:SetPosition(skillWorldPos)
  self.skillImg:LoadSprite(icon)
  self.skillBubble:Play("Eff_ui_jinengshifang_show", 0, 0)
end

return SkillIcon
