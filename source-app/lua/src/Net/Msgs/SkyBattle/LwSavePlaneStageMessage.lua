local LwSavePlaneStageMessage = BaseClass("LwSavePlaneStageMessage", SFSBaseMessage)
local base = SFSBaseMessage

function LwSavePlaneStageMessage:OnCreate(id, isWin)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", id)
  self.sfsObj:PutBool("isWin", isWin)
end

function LwSavePlaneStageMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif message.reward then
    DataCenter.LWSkyBattleChapterManager:CacheReward(message.stageId, message.reward)
    DataCenter.RewardManager:AddRewardsAndRes(message)
    EventManager:GetInstance():Broadcast(EventId.SkyBattleReward, {
      reward = message.reward,
      isGrowthMode = false
    })
  end
end

return LwSavePlaneStageMessage
