local base = UIBaseContainer
local UILWDominatorTrainPreviewCellSmallComponent = BaseClass("UILWDominatorTrainPreviewCellSmallComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWDominatorTrainPreviewCellSmallComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorTrainPreviewCellSmallComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorTrainPreviewCellSmallComponent:ReInit(template, isLastOne, isFirstOne)
  self.template = template
  if self.template == nil then
    return
  end
  self.textTitle:SetText(self.template:GetColoredName(false))
  self.textInit:SetText(Localization:GetString("dominator_train_grade_view_2"))
  self.compInit:SetActive(isFirstOne)
  self.slider:SetValue(1)
  self.slider:SetActive(not isLastOne)
end

function UILWDominatorTrainPreviewCellSmallComponent:ComponentDefine()
  self.slider = self:AddComponent(UISlider, "Slider")
  self.textTitle = self:AddComponent(UIText, "Title/TitleText")
  self.compInit = self:AddComponent(UIBaseContainer, "Init")
  self.textInit = self:AddComponent(UIText, "Init/InitText")
end

function UILWDominatorTrainPreviewCellSmallComponent:ComponentDestroy()
  self.slider = nil
  self.textTitle = nil
  self.textInit = nil
  self.compInit = nil
end

function UILWDominatorTrainPreviewCellSmallComponent:DataDefine()
end

function UILWDominatorTrainPreviewCellSmallComponent:DataDestroy()
end

function UILWDominatorTrainPreviewCellSmallComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorTrainPreviewCellSmallComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UILWDominatorTrainPreviewCellSmallComponent
