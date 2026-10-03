local ChampionBattleRewardView = BaseClass("ChampionBattleRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AllianceCompetePerReward = require("UI.UIAllianceCompete.UIAllianceCompeteReward.Component.AllianceCompetePerReward")
local title_path = "UICommonMidPopUpTitle/titleText"
local content_path = "ScrollView/Viewport/Content"
local closeBtn_path = "UICommonMidPopUpTitle/CloseBtn"
local maskBtn_path = "UICommonMidPopUpTitle/panel"
local Rank1Reward_path = "ScrollView/Viewport/Content/Rank1Reward"
local Rank2Reward_path = "ScrollView/Viewport/Content/Rank2Reward"
local Rank3Reward_path = "ScrollView/Viewport/Content/Rank3Reward"
local Rank4Reward_path = "ScrollView/Viewport/Content/Rank4Reward"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  DataCenter.ActChampionBattleManager:SendActChampBattleRewardPreviewCmd()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.maskBtnN = self:AddComponent(UIButton, maskBtn_path)
  self.maskBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleTxtN = self:AddComponent(UIText, title_path)
  self.contentN = self:AddComponent(UIBaseContainer, content_path)
  self.titleTxtN:SetLocalText(361012)
  self.rank_1_reward = self:AddComponent(AllianceCompetePerReward, Rank1Reward_path)
  self.rank_2_reward = self:AddComponent(AllianceCompetePerReward, Rank2Reward_path)
  self.rank_4To8_reward = self:AddComponent(AllianceCompetePerReward, Rank3Reward_path)
  self.rank_other_reward = self:AddComponent(AllianceCompetePerReward, Rank4Reward_path)
end

local function ComponentDestroy(self)
  self.closeBtnN = nil
  self.titleTxtN = nil
  self.contentN = nil
  self.rank_1_reward = nil
  self.rank_2_reward = nil
  self.rank_4To8_reward = nil
  self.rank_other_reward = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  self:AddUIListener(EventId.ChampionBattleRewardPreviewBack, self.ChampionBattleRewardPreviewBack)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ChampionBattleRewardPreviewBack, self.ChampionBattleRewardPreviewBack)
end

local function ChampionBattleRewardPreviewBack(self, message)
  self.rewards = message.reward
  self:ShowRewards()
end

local function ShowRewards(self)
  if self.rewards == nil then
    return
  end
  self:ShowRank1(self.rewards[1])
  self:ShowRank2(self.rewards[2])
  self:ShowRank3(self.rewards[3])
  self:ShowRank4(self.rewards[4])
  self:RepositionAll()
end

local function ShowRank1(self, reward)
  if reward == nil then
    return
  end
  local strTip = Localization:GetString("302057")
  self.rank_1_reward:ShowRewards(Localization:GetString("302053"), strTip, reward)
end

local function ShowRank2(self, reward)
  if reward == nil then
    return
  end
  local strTip = Localization:GetString("302058")
  self.rank_2_reward:ShowRewards(Localization:GetString("302054"), strTip, reward)
end

local function ShowRank3(self, reward)
  if reward == nil then
    return
  end
  local strTip = Localization:GetString("302059")
  self.rank_4To8_reward:ShowRewards(Localization:GetString("302055"), strTip, reward)
end

local function ShowRank4(self, reward)
  if reward == nil then
    return
  end
  local strTip = Localization:GetString("302060")
  self.rank_other_reward:ShowRewards(Localization:GetString("302056"), strTip, reward)
end

local function RepositionAll(self)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.contentN.rectTransform)
end

ChampionBattleRewardView.OnCreate = OnCreate
ChampionBattleRewardView.OnDestroy = OnDestroy
ChampionBattleRewardView.OnEnable = OnEnable
ChampionBattleRewardView.OnDisable = OnDisable
ChampionBattleRewardView.ComponentDefine = ComponentDefine
ChampionBattleRewardView.ComponentDestroy = ComponentDestroy
ChampionBattleRewardView.DataDefine = DataDefine
ChampionBattleRewardView.DataDestroy = DataDestroy
ChampionBattleRewardView.OnAddListener = OnAddListener
ChampionBattleRewardView.OnRemoveListener = OnRemoveListener
ChampionBattleRewardView.ChampionBattleRewardPreviewBack = ChampionBattleRewardPreviewBack
ChampionBattleRewardView.ShowRewards = ShowRewards
ChampionBattleRewardView.RepositionAll = RepositionAll
ChampionBattleRewardView.ShowRank1 = ShowRank1
ChampionBattleRewardView.ShowRank2 = ShowRank2
ChampionBattleRewardView.ShowRank3 = ShowRank3
ChampionBattleRewardView.ShowRank4 = ShowRank4
return ChampionBattleRewardView
