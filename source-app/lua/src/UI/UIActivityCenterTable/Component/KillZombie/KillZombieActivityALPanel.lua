local base = UIBaseContainer
local KillZombieActivityALPanel = BaseClass("KillZombieActivityALPanel", base)
local ALReward = require("UI.UIActivityCenterTable.Component.KillZombie.KillZombieActivityALReward")
local ALRewardWait = require("UI.UIActivityCenterTable.Component.KillZombie.KillZombieActivityALRewardWait")
local ALTask = require("UI.UIActivityCenterTable.Component.KillZombie.KillZombieActivityALTask")
local ALLevel = require("UI.UIActivityCenterTable.Component.KillZombie.KillZombieActivityALLevel")
local lock_path = "lock"
local lock_tips_path = "lock/lock_tips"
local join_al_path = "lock/JoinAL"
local join_text_path = "lock/JoinAL/JoinText"
local al_list_btn_path = "AlListBtn"

function KillZombieActivityALPanel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function KillZombieActivityALPanel:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function KillZombieActivityALPanel:ComponentDefine()
  self.mALReward = self:AddComponent(ALReward, "reward")
  self.mALRewardWait = self:AddComponent(ALRewardWait, "reward_wait")
  self.mALTask = self:AddComponent(ALTask, "task")
  self.mALLevel = self:AddComponent(ALLevel, "ScrollView")
  self.lock = self:AddComponent(UIButton, lock_path)
  self.lock_tips = self:AddComponent(UIText, lock_tips_path)
  self.lock_tips:SetLocalText("2010218")
  self.join_al_btn = self:AddComponent(UIButton, join_al_path)
  self.join_al_btn:SetOnClick(function()
    self:OnLockBtnClick()
  end)
  self.join_text = self:AddComponent(UIText, join_text_path)
  self.join_text:SetLocalText("110007")
  self.alList_btn = self:AddComponent(UIButton, al_list_btn_path)
  self.alList_btn:SetOnClick(function()
    self:OnShowAlListBtnClick()
  end)
end

function KillZombieActivityALPanel:ComponentDestroy()
  self.mALReward = nil
  self.mALRewardWait = nil
  self.mALTask = nil
  self.mALLevel = nil
  self.lock = nil
  self.lock_tips = nil
  self.join_al_btn = nil
  self.join_text = nil
  self.alList_btn = nil
end

function KillZombieActivityALPanel:DataDefine()
  self.alListParam = {}
end

function KillZombieActivityALPanel:DataDestroy()
  self.alListParam = nil
end

function KillZombieActivityALPanel:SetData(data)
  if data == nil then
    return
  end
  self.mALReward:SetData(data)
  self.mALRewardWait:SetData(data)
  self.mALTask:SetData(data)
  self.mALLevel:SetData(data, self.mALRewardWait, self.mALTask, self.mALReward, self.join_al_btn)
  self:RefreshUI()
end

function KillZombieActivityALPanel:OnAddListener()
  base.OnAddListener(self)
end

function KillZombieActivityALPanel:OnRemoveListener()
  base.OnRemoveListener(self)
end

function KillZombieActivityALPanel:RefreshUI()
  self.alList_btn:SetActive(LuaEntry.Player:IsInAlliance())
  self.mALTask:SetActive(false)
  self.mALReward:SetActive(false)
  self.mALRewardWait:SetActive(false)
  self.mALLevel:SetActive(true)
  local server_data = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_AL_INFO)
  local isInAlliance = LuaEntry.Player:IsInAlliance()
  if isInAlliance then
    if server_data == nil then
      self.lock:SetActive(true)
      self.lock_tips:SetLocalText("E100008")
      self.join_al_btn:SetActive(false)
    else
      self.lock:SetActive(false)
      self.mALLevel:UpdateData()
    end
  else
    self.lock:SetActive(true)
    self.join_al_btn:SetActive(true)
    self.lock_tips:SetLocalText("2010218")
  end
end

function KillZombieActivityALPanel:OnLockBtnClick()
  local params = {
    guide = false,
    al_success_callback = function()
      SFSNetwork.SendMessage(MsgDefines.KillZombieDataPull)
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlCreateJoin)
      self:SelectTab(2)
    end,
    al_lose_callback = function()
    end
  }
  if LuaEntry.Player:IsFirstJoinAlliance() == true then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true}, params)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
  end
end

function KillZombieActivityALPanel:OnShowAlListBtnClick()
  if self.mALLevel then
    local conditionDifficulty = self.mALLevel:GetCurConditionDifficulty()
    local curDifficult = self.mALLevel:GetCurSelectDifficulty()
    if conditionDifficulty and 0 < conditionDifficulty and curDifficult then
      self.alListParam.difficulty = conditionDifficulty
      self.alListParam.curDifficult = curDifficult
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIALChallengeRank, {anim = true}, self.alListParam)
    end
  end
end

return KillZombieActivityALPanel
