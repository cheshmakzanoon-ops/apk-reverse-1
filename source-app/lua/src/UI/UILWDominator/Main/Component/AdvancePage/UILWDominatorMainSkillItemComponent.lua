local base = UIBaseContainer
local UILWDominatorMainSkillItemComponent = BaseClass("UILWDominatorMainSkillItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWDominatorMainSkillItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorMainSkillItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorMainSkillItemComponent:ComponentDefine()
  self.btnContentContainer = self:AddComponent(UIButton, "ContentContainer")
  self.btnContentContainer:SetOnClick(function()
    self:OnBtnContentContainerClick()
  end)
  self.imgIcon = self:AddComponent(UIImage, "ContentContainer/Icon")
  self.compSkillFrame = self:AddComponent(UIBaseContainer, "ContentContainer/SkillFrame")
  self.textStar = self:AddComponent(UIText, "ContentContainer/StarText")
end

function UILWDominatorMainSkillItemComponent:ComponentDestroy()
  self.btnContentContainer = nil
  self.imgIcon = nil
  self.compSkillFrame = nil
  self.textStar = nil
end

function UILWDominatorMainSkillItemComponent:ReInit(param)
  self.param = param
  if self.param == nil then
    return
  end
  self.skillId = self.param.skillId
  self.skillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(self.skillId)
  if self.skillTemplate == nil then
    return
  end
  self.imgIcon:LoadSprite(self.skillTemplate.icon)
  self.textStar:SetText("\195\151" .. self.skillTemplate.star)
end

function UILWDominatorMainSkillItemComponent:DataDefine()
end

function UILWDominatorMainSkillItemComponent:DataDestroy()
end

function UILWDominatorMainSkillItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorMainSkillItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWDominatorMainSkillItemComponent:OnBtnContentContainerClick()
  if self.param and self.param.clickCallback then
    self.param.clickCallback(self.param, self)
  end
end

return UILWDominatorMainSkillItemComponent
