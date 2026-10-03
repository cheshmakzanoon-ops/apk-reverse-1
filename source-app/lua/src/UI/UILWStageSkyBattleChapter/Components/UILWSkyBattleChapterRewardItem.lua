local base = UIBaseContainer
local UILWSkyBattleChapterRewardItem = BaseClass("UIStageFeatureChapterRewardItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWSkyBattleChapterRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSkyBattleChapterRewardItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSkyBattleChapterRewardItem:ComponentDefine()
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

function UILWSkyBattleChapterRewardItem:ComponentDestroy()
  self.btnItem = nil
  self.imgOpen = nil
  self.text = nil
end

function UILWSkyBattleChapterRewardItem:DataDefine()
end

function UILWSkyBattleChapterRewardItem:Refresh(boxData, canReceive)
  self.effectBoxLight:SetActive(false)
  if boxData then
    self.labelText:SetText(string.format("%d", boxData.TargetCompleteNum or 0))
    self.imgOpen:SetActive(boxData.Got)
    self.imgUnOpen:SetActive(not boxData.Got)
    if canReceive and not boxData.Got then
      self.effectBoxLight:SetActive(true)
    end
  end
end

function UILWSkyBattleChapterRewardItem:SetOnClick(onClick)
  self.OnBoxClick = onClick
end

function UILWSkyBattleChapterRewardItem:DataDestroy()
  self.OnBoxClick = nil
end

function UILWSkyBattleChapterRewardItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWSkyBattleChapterRewardItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UILWSkyBattleChapterRewardItem
