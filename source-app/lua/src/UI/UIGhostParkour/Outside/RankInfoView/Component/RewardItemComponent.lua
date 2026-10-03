local base = UIBaseContainer
local RewardItemComponent = BaseClass("RewardItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonResItem = require("UI.UICommonResItem.UICommonResItem")

function RewardItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RewardItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RewardItemComponent:ComponentDefine()
  self.compUICommonResItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.textRewardScore = self:AddComponent(UITextMeshProUGUIEx, "Image/rewardScore")
  self.btn = self:AddComponent(UIButton, "btn")
  self.btn:SetSafeClickMode(true)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.rewarded = self:AddComponent(UIImage, "imgRewarded")
  self.imgRewardScore = self:AddComponent(UIImage, "Image")
end

function RewardItemComponent:ComponentDestroy()
  self.compUICommonResItem = nil
  self.textRewardScore = nil
  self.btn = nil
  self.rewarded = nil
  self.imgRewardScore = nil
end

function RewardItemComponent:DataDefine()
end

function RewardItemComponent:DataDestroy()
end

function RewardItemComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GhostParkourRankInfoRewardRefresh, self.UpdateState)
end

function RewardItemComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.GhostParkourRankInfoRewardRefresh, self.UpdateState)
  base.OnRemoveListener(self)
end

function RewardItemComponent:ReInit(data, tier)
  self.data = data
  self.tier = tier
  local reward = data and data.reward
  if reward and reward[1] then
    reward = DataCenter.RewardManager:ReturnRewardParamForMessage(reward)
    self.compUICommonResItem:ReInit(reward[1])
    self.btn.gameObject:SetActive(data.state == GhostParkourTierRewardState.CanReward)
    self.textRewardScore:SetText(data.exp)
    self.rewarded.gameObject:SetActive(data.state == GhostParkourTierRewardState.Rewarded)
  end
end

function RewardItemComponent:OnBtnClick()
  DataCenter.LWGhostParkourDataManager:SendGetGhostParkourTierRewardMessage(self.tier, self.data.id)
end

function RewardItemComponent:UpdateState(id)
  if self.data.id == id then
    self.btn.gameObject:SetActive(self.data.state == GhostParkourTierRewardState.CanReward)
    self.rewarded.gameObject:SetActive(self.data.state == GhostParkourTierRewardState.Rewarded)
  end
end

function RewardItemComponent:UpdateGuideState(value)
  self.imgRewardScore.gameObject:SetActive(value)
end

return RewardItemComponent
