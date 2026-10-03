local base = UIBaseContainer
local UIHeroRecruitPreviewTagComponent = BaseClass("UIHeroRecruitPreviewTagComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIHeroRecruitPreviewTagComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIHeroRecruitPreviewTagComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHeroRecruitPreviewTagComponent:ComponentDefine()
  self.btnTabTemplate = self:AddComponent(UIButton, "")
  self.btnTabTemplate:SetOnClick(function()
    self:OnBtnTabTemplateClick()
  end)
  self.compCheck = self:AddComponent(UIBaseContainer, "Check")
end

function UIHeroRecruitPreviewTagComponent:ComponentDestroy()
  self.btnTabTemplate = nil
  self.compCheck = nil
end

function UIHeroRecruitPreviewTagComponent:DataDefine()
end

function UIHeroRecruitPreviewTagComponent:DataDestroy()
end

function UIHeroRecruitPreviewTagComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIHeroRecruitPreviewTagComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIHeroRecruitPreviewTagComponent:ReInit(param)
  self.info = param.info
  self.index = param.index
  self.selectCallback = param.selectCallback
end

function UIHeroRecruitPreviewTagComponent:UpdateSelect(curIndex)
  if not self.index then
    return
  end
  self.compCheck:SetActive(self.index == curIndex)
end

function UIHeroRecruitPreviewTagComponent:OnBtnTabTemplateClick()
  if self.selectCallback then
    self.selectCallback()
  end
end

return UIHeroRecruitPreviewTagComponent
