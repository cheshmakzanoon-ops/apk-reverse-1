local base = UIBaseContainer
local LWS6CampReward = BaseClass("LWS6CampReward", base)
local Localization = CS.GameEntry.Localization
local LWS6CampRewardItem = require("UI.LWSeason6.UILWSeason6Reward.Comp.LWS6CampRewardItem")
local alliance_reward_item_path = "root/Reward/ScrollView/AllianceRewardItem"
local scroll_view_path = "root/Reward/ScrollView"
local hint_layout = "root/Reward"
local hint_root_path = "root/Reward/content_hint"
local des_btn_path = "root/Reward/content_hint/DesBtn"
local personal_condition_path = "root/Reward/content_hint/personalCondition"

function LWS6CampReward:OnCreate()
  base.OnCreate(self)
  self.alliance_reward_item = self:AddComponent(UIBaseContainer, alliance_reward_item_path)
  self.personal_condition = self:AddComponent(UITextMeshProUGUIEx, personal_condition_path)
  self.scroll_view = self:AddComponent(UIScrollViewSimple, scroll_view_path)
  self.hint_layout = self:AddComponent(UIBaseContainer, hint_layout)
  self.hint_root = self:AddComponent(UIBaseContainer, hint_root_path)
  self.des_btn = self:AddComponent(UIButton, des_btn_path)
  self.des_btn:SetOnClick(function()
    self:DesClick()
  end)
  self.des_btn:SetActive(false)
  self.hint_root:SetActive(false)
end

function LWS6CampReward:OnDestroy()
  self.alliance_reward_item = nil
  self.des_btn = nil
  self.hint_root = nil
  self.hint_layout = nil
  self.personal_condition = nil
  self.scroll_view = nil
  base.OnDestroy(self)
end

function LWS6CampReward:OnEnable()
  base.OnEnable(self)
end

function LWS6CampReward:OnDisable()
  base.OnDisable(self)
end

function LWS6CampReward:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonCampRankRewardInfoUpdate, self.RewardDataUpdate)
end

function LWS6CampReward:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonCampRankRewardInfoUpdate, self.RewardDataUpdate)
  base.OnRemoveListener(self)
end

function LWS6CampReward:SetData(panelType)
  self.panelType = panelType
  if self.panelType == LWSeasonBattleFieldRewardPanelType.Camp then
    local data = DataCenter.SeasonRewardDataManager:GetSeasonCampRankRewardInfo()
    SFSNetwork.SendMessage(MsgDefines.LwSeasonCampTierRewardInfo, SeasonUtil.IsInSeasonPrepareMode())
  end
  self:RefreshReward()
end

function LWS6CampReward:RefreshReward()
  self.reward = nil
  local info
  if self.panelType == LWSeasonBattleFieldRewardPanelType.Camp then
    info = DataCenter.SeasonRewardDataManager:GetSeasonCampRankRewardInfo()
    self.des_btn:SetActive(not SeasonUtil.IsInSeasonPrepareMode())
    if info then
      self.personal_condition:SetText(info.personalCondition)
      self.personal_condition:SetActive(true)
      self.hint_root:SetActive(not SeasonUtil.IsInSeasonPrepareMode())
    else
      self.hint_root:SetActive(false)
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.hint_layout.transform)
  end
  self.scroll_view:Clear()
  self.scroll_view:Init(LWS6CampRewardItem)
  if info then
    self.reward = info.rewardInfo
    self.tier = info.tier
  end
  if self.reward and #self.reward > 0 then
    for _, reward in pairs(self.reward) do
      local data = {}
      data.data = reward
      data.title1 = reward.title
      data.title2 = reward.titleDes
      data.isCur = reward.tier > 0 and reward.tier == checknumber(self.tier)
      self.scroll_view:AddData(data)
    end
    self.scroll_view:Show()
  end
end

function LWS6CampReward:RewardDataUpdate()
  self:RefreshReward()
end

function LWS6CampReward:DesClick()
  if self.panelType == LWSeasonBattleFieldRewardPanelType.Camp then
    local info = DataCenter.SeasonRewardDataManager:GetSeasonCampRankRewardInfo()
    if info and info.helpDes then
      local param = {}
      param.subTitle = "170001"
      param.activityRulesStr = info.helpDes
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
    end
  end
end

return LWS6CampReward
