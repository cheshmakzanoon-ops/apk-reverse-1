local rapidjson = require("rapidjson")
local HangUpRewardMessage = BaseClass("HangUpRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local isShow

local function OnCreate(self, action, notShowUI)
  base.OnCreate(self)
  self.sfsObj:PutInt("action", action)
  isShow = not notShowUI
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  local openUI = isShow
  DataCenter.DomintorStageManager:UpdateHangUpReward(message.lastDominatorIdleRewardTimeStamp, message.idleRewardDominatorUpId, message.dominatorReward)
  DataCenter.StageManager:UpdateHangUpReward(message.lastIdleRewardTimeStamp, message.idleRewardStageId, message.reward)
  if message.action == 0 then
    local lastDominatorUpId
    if message.lastDominatorUpId then
      local cfg = DataCenter.DominatorUpTemplateManager:GetDominatorUpUnlockTemplate(message.lastDominatorUpId)
      if cfg then
        lastDominatorUpId = cfg.idle_reward_stageid
      end
    end
    local param = {
      lastStageId = message.lastStageId,
      lastPerReward = DataCenter.RewardManager:ReturnRewardParamForMessage(message.lastPerReward),
      perReward = DataCenter.RewardManager:ReturnRewardParamForMessage(message.perReward),
      lastDominatorUpId = lastDominatorUpId,
      lastDominatorPerReward = DataCenter.RewardManager:ReturnRewardParamForMessage(message.lastDominatorPerReward),
      dominatorPerReward = DataCenter.RewardManager:ReturnRewardParamForMessage(message.dominatorPerReward)
    }
    local silent = DataCenter.BuildManager.isFetchHangUpRewardSilently
    local resLack = UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWResourceLack)
    local goodLack = UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWGoodsLack)
    local specialResLack = UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWSpecialResLack)
    local resLackReceiveSilently = DataCenter.LWResourceLackManager:GetReceiveHangUpRewardSilentlySign()
    local rewardShow = UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGetRewardView) or UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGiftPackageRewardGet)
    if not silent and not resLack and not goodLack and not specialResLack and not rewardShow and openUI and not resLackReceiveSilently then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIZombieBattleHangUpReward, {anim = true}, param)
    end
    EventManager:GetInstance():Broadcast(EventId.OnGetQueryHangUpRewardResult, param)
    DataCenter.BuildManager.isFetchHangUpRewardSilently = nil
    if resLackReceiveSilently then
      DataCenter.LWResourceLackManager:ResetReceiveHangUpRewardSilentlySign()
    end
  else
    DataCenter.RewardManager:AddRewardsAndRes(message)
    local resLackReceiveSilently = DataCenter.LWResourceLackManager:GetReceiveHangUpRewardSilentlySign()
    if not resLackReceiveSilently and message and not table.IsNullOrEmpty(message.reward) then
      DataCenter.RewardManager:ShowCommonReward(message)
    end
    SFSNetwork.SendMessage(MsgDefines.HangUpRewardMessage, 0, not openUI)
  end
end

HangUpRewardMessage.OnCreate = OnCreate
HangUpRewardMessage.HandleMessage = HandleMessage
return HangUpRewardMessage
