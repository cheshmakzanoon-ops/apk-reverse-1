local base = UIBaseContainer
local UILWDominatorTrainPreviewCellSmallLockedComponent = BaseClass("UILWDominatorTrainPreviewCellSmallLockedComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWDominatorTrainPreviewCellSmallLockedComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorTrainPreviewCellSmallLockedComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorTrainPreviewCellSmallLockedComponent:ReInit(template, isLastOne)
  self.template = template
  if self.template == nil then
    return
  end
  self.textTitle:SetText(self.template:GetColoredName(false))
  self.slider:SetValue(0)
  self.slider:SetActive(not isLastOne)
  local showRequire = false
  local curInfo = DataCenter.DominatorManager:GetMainTrainGroupInfo()
  if curInfo then
    local curTemplate = curInfo:GetCurLevelTemplate()
    if curTemplate and curTemplate:GetBigLevel() + 1 == self.template:GetBigLevel() then
      showRequire = true
    end
  end
  self.compRequire:SetActive(showRequire)
  if showRequire then
    local preTemplate = self.template:GetPreviousLevelTemplate()
    if preTemplate then
      self.textRequire:SetText(preTemplate:GetRequireTextForPreview())
      local isOk = preTemplate:IsRequireOK()
      if isOk then
        self.textRequire:SetColorRGBA255(95, 239, 135, 255)
      else
        self.textRequire:SetColorRGBA255(187, 58, 46, 255)
      end
    end
    self.rectTransform:Set_sizeDelta(810, 230)
  else
    self.rectTransform:Set_sizeDelta(810, 170)
  end
end

function UILWDominatorTrainPreviewCellSmallLockedComponent:ComponentDefine()
  self.slider = self:AddComponent(UISlider, "Slider")
  self.textTitle = self:AddComponent(UIText, "Title/TitleText")
  self.compRequire = self:AddComponent(UIBaseContainer, "RequireBase")
  self.textRequire = self:AddComponent(UIText, "RequireBase/RequireText")
end

function UILWDominatorTrainPreviewCellSmallLockedComponent:ComponentDestroy()
  self.textTitle = nil
  self.slider = nil
  self.textRequire = nil
  self.compRequire = nil
end

function UILWDominatorTrainPreviewCellSmallLockedComponent:DataDefine()
end

function UILWDominatorTrainPreviewCellSmallLockedComponent:DataDestroy()
end

function UILWDominatorTrainPreviewCellSmallLockedComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorTrainPreviewCellSmallLockedComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UILWDominatorTrainPreviewCellSmallLockedComponent
