local base = UIBaseContainer
local LWSeason5AllianceRewardTop = BaseClass("LWSeason5AllianceRewardTop", base)
local LWSeason5AllianceRewardTopTier = require("UI.LWSeason.LWSeasonReward.Component.SeasonAllianceRewardTopTier")
local selectAnimator_path = ""
local tierCom_path = {
  "new_scene/Level1 (8)",
  "new_scene/Level1 (9)",
  "new_scene/Level1 (10)",
  "new_scene/Level1 (11)",
  "reward_scene/bg (1)/rewards_root/Level1",
  "reward_scene/bg (1)/rewards_root/Level1 (1)",
  "reward_scene/bg (1)/rewards_root/Level1 (2)",
  "reward_scene/bg (1)/rewards_root/Level1 (3)",
  "reward_scene/bg (1)/rewards_root/Level1 (4)",
  "reward_scene/bg (1)/rewards_root/Level1 (5)",
  "reward_scene/bg (1)/rewards_root/Level1 (6)",
  "reward_scene/bg (1)/rewards_root/Level1 (7)"
}
local p_btn_switch_path = "p_btn_switch"
local p_text_switch_path = "p_btn_switch/img_switch/p_text_switch"

function LWSeason5AllianceRewardTop:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWSeason5AllianceRewardTop:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeason5AllianceRewardTop:OnEnable()
  base.OnEnable(self)
end

function LWSeason5AllianceRewardTop:OnDisable()
  base.OnDisable(self)
end

function LWSeason5AllianceRewardTop:ComponentDefine()
  self.selectAnimator = self:AddComponent(UIAnimator, selectAnimator_path)
  self.p_btn_switch = self:AddComponent(UIButton, p_btn_switch_path)
  self.p_btn_switch:SetOnClick(BindCallback(self, self.OnSwitchClicked))
  self.p_text_switch = self:AddComponent(UITextMeshProUGUIEx, p_text_switch_path)
  self.tierCom = {
    self:AddComponent(LWSeason5AllianceRewardTopTier, tierCom_path[1]),
    self:AddComponent(LWSeason5AllianceRewardTopTier, tierCom_path[2]),
    self:AddComponent(LWSeason5AllianceRewardTopTier, tierCom_path[3]),
    self:AddComponent(LWSeason5AllianceRewardTopTier, tierCom_path[4]),
    self:AddComponent(LWSeason5AllianceRewardTopTier, tierCom_path[5]),
    self:AddComponent(LWSeason5AllianceRewardTopTier, tierCom_path[6]),
    self:AddComponent(LWSeason5AllianceRewardTopTier, tierCom_path[7]),
    self:AddComponent(LWSeason5AllianceRewardTopTier, tierCom_path[8]),
    self:AddComponent(LWSeason5AllianceRewardTopTier, tierCom_path[9]),
    self:AddComponent(LWSeason5AllianceRewardTopTier, tierCom_path[10]),
    self:AddComponent(LWSeason5AllianceRewardTopTier, tierCom_path[11]),
    self:AddComponent(LWSeason5AllianceRewardTopTier, tierCom_path[12])
  }
end

function LWSeason5AllianceRewardTop:ComponentDestroy()
  self.selectAnimator = nil
  self.tierCom = nil
  self.p_btn_switch = nil
  self.p_text_switch = nil
end

function LWSeason5AllianceRewardTop:DataDefine()
  self.AnimIn = "V_ui_S5SeasonRewardTopEight_in"
  self.AnimInSwitch = "V_ui_S5SeasonRewardTopEight_in_switch"
  self.AnimSwitch = "V_ui_S5SeasonRewardTopEight_switch"
  self.AnimBack = "V_ui_S5SeasonRewardTopEight_switch_back"
end

function LWSeason5AllianceRewardTop:DataDestroy()
  self.isInit = nil
  self.click = nil
end

function LWSeason5AllianceRewardTop:Init(initIndex, rewardTier, clickCall)
  self.IsSwitchState = false
  if not self.isInit then
    self.isInit = true
    self.curIndex = initIndex
    self.rewardTier = rewardTier
    self.click = clickCall
    for index, value in ipairs(self.tierCom) do
      value:Init(index, function(i)
        if self.click then
          self.click(i)
        end
      end)
    end
    initIndex = Mathf.Clamp(checknumber(initIndex), 1, 12)
    if self:IsChallenge(initIndex) then
      self.IsSwitchState = true
      if self.selectAnimator then
        self.selectAnimator:Play(self.AnimInSwitch)
      end
    elseif self:IsNormal(initIndex) and self.selectAnimator then
      self.selectAnimator:Play(self.AnimIn)
    end
  end
  self:UpdateText()
end

function LWSeason5AllianceRewardTop:UpdateText()
  self.p_text_switch:SetLocalText(self.IsSwitchState and "season_s5_rank_reward_2" or "season_s5_rank_reward_1")
end

function LWSeason5AllianceRewardTop:RefreshTierBg(i)
  self.rewardTier = i
  if not self.isInit then
    return
  end
  for index, value in ipairs(self.tierCom) do
    value:RefreshTierBg(i)
  end
end

function LWSeason5AllianceRewardTop:OnSelect(i)
  if not self.isInit then
    return
  end
  for index, value in ipairs(self.tierCom) do
    value:SelectTitle(i)
  end
end

function LWSeason5AllianceRewardTop:RefreshBtnRed(rewardTier, flag)
  for index, value in ipairs(self.tierCom) do
    value:RefreshBtnRed(rewardTier, flag)
  end
end

function LWSeason5AllianceRewardTop:OnSwitchClicked()
  self.IsSwitchState = not self.IsSwitchState
  if self.IsSwitchState then
    if self.selectAnimator then
      self.selectAnimator:Play(self.AnimSwitch)
    end
    if self:IsChallenge(self.rewardTier) then
      self.click(self.rewardTier)
    else
      self.click(1)
    end
  else
    if self.selectAnimator then
      self.selectAnimator:Play(self.AnimBack)
    end
    if self:IsNormal(self.rewardTier) then
      self.click(self.rewardTier)
    else
      self.click(5)
    end
  end
  self:UpdateText()
end

function LWSeason5AllianceRewardTop:IsNormal(index)
  return 5 <= index and index <= 12
end

function LWSeason5AllianceRewardTop:IsChallenge(index)
  return 1 <= index and index <= 4
end

function LWSeason5AllianceRewardTop:GetIsChallengeState()
  return self.IsSwitchState
end

return LWSeason5AllianceRewardTop
