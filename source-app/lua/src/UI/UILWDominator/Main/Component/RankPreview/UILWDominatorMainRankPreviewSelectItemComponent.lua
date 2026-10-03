local base = UIBaseContainer
local UILWDominatorMainRankPreviewSelectItemComponent = BaseClass("UILWDominatorMainRankPreviewSelectItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWDominatorMainRankPreviewSelectItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorMainRankPreviewSelectItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorMainRankPreviewSelectItemComponent:ReInit(rankShowTemplate, clickCallback)
  self.rankShowTemplate = rankShowTemplate
  self.clickCallback = clickCallback
  if self.rankShowTemplate == nil then
    return
  end
  self.textLevel:SetText(self.rankShowTemplate:GetPreviewShowLevelText())
end

function UILWDominatorMainRankPreviewSelectItemComponent:SetBgActive(value)
  self.compBg:SetActive(value)
end

function UILWDominatorMainRankPreviewSelectItemComponent:ComponentDefine()
  self.btnLevelItem = self:AddComponent(UIButton, "")
  self.btnLevelItem:SetOnClick(function()
    self:OnBtnLevelItemClick()
  end)
  self.compBg = self:AddComponent(UIBaseContainer, "bg")
  self.textLevel = self:AddComponent(UIText, "levelText")
end

function UILWDominatorMainRankPreviewSelectItemComponent:ComponentDestroy()
  self.btnLevelItem = nil
  self.compBg = nil
  self.textLevel = nil
end

function UILWDominatorMainRankPreviewSelectItemComponent:DataDefine()
end

function UILWDominatorMainRankPreviewSelectItemComponent:DataDestroy()
end

function UILWDominatorMainRankPreviewSelectItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorMainRankPreviewSelectItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWDominatorMainRankPreviewSelectItemComponent:OnBtnLevelItemClick()
  if self.clickCallback and self.rankShowTemplate then
    self.clickCallback(self.rankShowTemplate)
  end
end

return UILWDominatorMainRankPreviewSelectItemComponent
