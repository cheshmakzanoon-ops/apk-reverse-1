local base = UIBaseContainer
local UICAbundantHarvestSkillTipItem = BaseClass("UICAbundantHarvestSkillTipItem", base)
local RewardUtil = require("Util.RewardUtil")
local sr_RewardScroll_path = "RewardScroll"
local txt_title_path = "title/txt_title"

function UICAbundantHarvestSkillTipItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UICAbundantHarvestSkillTipItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICAbundantHarvestSkillTipItem:ComponentDefine()
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.sr_RewardScroll = self:AddComponent(UIScrollViewSimple, sr_RewardScroll_path)
  self.sr_RewardScroll:Init(UICommonResItem)
end

function UICAbundantHarvestSkillTipItem:ComponentDestroy()
  self.sr_RewardScroll = nil
  self.txt_title = nil
end

function UICAbundantHarvestSkillTipItem:ReInit(data, txtDesc)
  local skillName = CS.GameEntry.Localization:GetString(data.scoreConfig.skill_name)
  txtDesc:SetLocalText("season_s6_government_skill_desc14", skillName)
  self.txt_title:SetLocalText("season_s6_government_skill_desc15")
  self:RefreshReward(data)
end

function UICAbundantHarvestSkillTipItem:RefreshReward(data)
  self.sr_RewardScroll:Clear()
  local skillRewardId = data.config.skill_para1
  local rewards = RewardUtil.GetRewardsById(skillRewardId)
  local rewardCount = #rewards
  for index = 1, rewardCount do
    self.sr_RewardScroll:AddData(rewards[index])
  end
  self.sr_RewardScroll:Show()
end

return UICAbundantHarvestSkillTipItem
