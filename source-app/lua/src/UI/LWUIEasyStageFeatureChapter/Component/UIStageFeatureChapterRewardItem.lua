local base = UIBaseContainer
local UIStageFeatureChapterRewardItem = BaseClass("UIStageFeatureChapterRewardItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIStageFeatureChapterRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIStageFeatureChapterRewardItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIStageFeatureChapterRewardItem:ComponentDefine()
  self.btnItem = self:AddComponent(UIButton, "")
  self.imgOpen = self:AddComponent(UIImage, "Open")
  self.imgUnOpen = self:AddComponent(UIImage, "UnOpen")
  self.labelText = self:AddComponent(UITextMeshProUGUIEx, "LabelImg/Text")
  self.effectBoxLight = self:AddComponent(UIBaseComponent, "CanReceiveEffect")
  self.btnItem:SetOnClick(function()
    if self.OnBoxClick then
      self.OnBoxClick()
    end
  end)
end

function UIStageFeatureChapterRewardItem:ComponentDestroy()
  self.btnItem = nil
  self.imgOpen = nil
  self.text = nil
end

function UIStageFeatureChapterRewardItem:DataDefine()
end

function UIStageFeatureChapterRewardItem:Refresh(boxData, canReceive)
  self.effectBoxLight:SetActive(false)
  if boxData then
    self.labelText:SetText(string.format("%d", boxData.TargetCompleteNum or 0))
    self.imgOpen:SetActive(boxData.Got)
    if canReceive and not boxData.Got then
      self.effectBoxLight:SetActive(true)
    end
  end
end

function UIStageFeatureChapterRewardItem:SetOnClick(onClick)
  self.OnBoxClick = onClick
end

function UIStageFeatureChapterRewardItem:DataDestroy()
  self.OnBoxClick = nil
end

function UIStageFeatureChapterRewardItem:OnAddListener()
  base.OnAddListener(self)
end

function UIStageFeatureChapterRewardItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UIStageFeatureChapterRewardItem
