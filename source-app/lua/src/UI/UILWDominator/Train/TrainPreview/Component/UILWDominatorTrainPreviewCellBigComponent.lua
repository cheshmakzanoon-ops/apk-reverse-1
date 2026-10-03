local base = UIBaseContainer
local UILWDominatorTrainPreviewCellBigComponent = BaseClass("UILWDominatorTrainPreviewCellBigComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UILWDominatorTrainBigLevelItemComponent = require("UI/UILWDominator/Train/TrainPreview/Component/UILWDominatorTrainBigLevelItemComponent")

function UILWDominatorTrainPreviewCellBigComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorTrainPreviewCellBigComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorTrainPreviewCellBigComponent:ReInit(template, isLastOne)
  self.template = template
  if self.template == nil then
    return
  end
  self.textTitle:SetText(self.template:GetColoredName(false))
  local preTemplate = self.template:GetPreviousLevelTemplate()
  if preTemplate then
    self.textRequire:SetText(preTemplate:GetRequireTextForPreview())
  end
  self.compUILWDominatorTrainBigLevelItemLeft:ReInit(self.template)
  local maxTemplate = self.template:GetMaxLevelTemplateInThisBigLevel()
  if maxTemplate then
    self.compUILWDominatorTrainBigLevelItemRight:ReInit(maxTemplate)
    local curInfo = DataCenter.DominatorManager:GetMainTrainGroupInfo()
    if curInfo then
      local curTemplate = curInfo:GetCurLevelTemplate()
      if curTemplate then
        local progress = 0
        if 0 < self.template.grade_num then
          progress = curTemplate.grade_num / maxTemplate.grade_num
        end
        self.slider:SetValue(progress)
      end
    end
  end
  self.slider:SetActive(not isLastOne)
end

function UILWDominatorTrainPreviewCellBigComponent:ComponentDefine()
  self.textTitle = self:AddComponent(UIText, "Title/TitleText")
  self.slider = self:AddComponent(UISlider, "Slider")
  self.textRequire = self:AddComponent(UIText, "Title/RequireText")
  self.compUILWDominatorTrainBigLevelItemLeft = self:AddComponent(UILWDominatorTrainBigLevelItemComponent, "Title/UILWDominatorTrainBigLevelItemLeft")
  self.compUILWDominatorTrainBigLevelItemRight = self:AddComponent(UILWDominatorTrainBigLevelItemComponent, "Title/UILWDominatorTrainBigLevelItemRight")
  self.textState = self:AddComponent(UIText, "State/StateText")
  self.textState:SetLocalText("dominator_train_grade_view_3")
end

function UILWDominatorTrainPreviewCellBigComponent:ComponentDestroy()
  self.textTitle = nil
  self.slider = nil
  self.textRequire = nil
  self.compUILWDominatorTrainBigLevelItemLeft = nil
  self.compUILWDominatorTrainBigLevelItemRight = nil
  self.textState = nil
end

function UILWDominatorTrainPreviewCellBigComponent:DataDefine()
end

function UILWDominatorTrainPreviewCellBigComponent:DataDestroy()
end

function UILWDominatorTrainPreviewCellBigComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorTrainPreviewCellBigComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UILWDominatorTrainPreviewCellBigComponent
