local base = UIBaseContainer
local UILWT11IdleGameBattleRewardPreviewProbabilityResItemComponent = BaseClass("UILWT11IdleGameBattleRewardPreviewProbabilityResItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWT11IdleGameBattleRewardPreviewProbabilityResItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWT11IdleGameBattleRewardPreviewProbabilityResItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWT11IdleGameBattleRewardPreviewProbabilityResItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUICommonResItem = self.viewSkin:AddComponent(self, UICommonResItem, 1)
  self.textProbability = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
end

function UILWT11IdleGameBattleRewardPreviewProbabilityResItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compUICommonResItem = nil
  self.textProbability = nil
end

function UILWT11IdleGameBattleRewardPreviewProbabilityResItemComponent:DataDefine()
end

function UILWT11IdleGameBattleRewardPreviewProbabilityResItemComponent:DataDestroy()
end

function UILWT11IdleGameBattleRewardPreviewProbabilityResItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWT11IdleGameBattleRewardPreviewProbabilityResItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWT11IdleGameBattleRewardPreviewProbabilityResItemComponent:ReInit(data)
  self.compUICommonResItem:ReInit(data.reward)
  self.textProbability:SetText(data.prob)
end

return UILWT11IdleGameBattleRewardPreviewProbabilityResItemComponent
