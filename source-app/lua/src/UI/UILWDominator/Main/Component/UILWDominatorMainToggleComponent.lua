local base = UIBaseContainer
local UILWDominatorMainToggleComponent = BaseClass("UILWDominatorMainToggleComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWDominatorMainToggleComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorMainToggleComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorMainToggleComponent:ComponentDefine()
  self.btnBasicPageToggle = self:AddComponent(UIButton, "")
  self.btnBasicPageToggle:SetOnClick(function()
    self:OnBtnBasicPageToggleClick()
  end)
  self.textToggle = self:AddComponent(UIText, "ToggleText")
  self.compToggleSelectedBg = self:AddComponent(UIBaseContainer, "ToggleSelectedBg")
  self.textToggleSelect = self:AddComponent(UIText, "ToggleSelectedBg/ToggleTextSelect")
end

function UILWDominatorMainToggleComponent:ComponentDestroy()
  self.btnBasicPageToggle = nil
  self.textToggle = nil
  self.compToggleSelectedBg = nil
  self.textToggleSelect = nil
end

function UILWDominatorMainToggleComponent:DataDefine()
end

function UILWDominatorMainToggleComponent:DataDestroy()
end

function UILWDominatorMainToggleComponent:ReInit(tag, mainId)
  self.tag = tag
  self.mainId = mainId
  local isShow = self.view.ctrl:IsShowPageTag(self.tag, self.mainId)
  self.transform.gameObject:SetActive(isShow)
  if isShow then
    self.textToggle:SetText(self.view.ctrl:GetPageTagText(self.tag))
    self.textToggleSelect:SetText(self.view.ctrl:GetPageTagText(self.tag))
    self:UpdateSelect()
  end
end

function UILWDominatorMainToggleComponent:UpdateSelect()
  local curSelectTag = self.view:GetCurShowPageTag()
  self.compToggleSelectedBg:SetActive(curSelectTag == self.tag)
end

function UILWDominatorMainToggleComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorMainToggleComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWDominatorMainToggleComponent:OnBtnBasicPageToggleClick()
  if self.tag and self.view then
    self.view:SetCurShowPageTag(self.tag)
  end
end

return UILWDominatorMainToggleComponent
