local SeasonMonsterEventTaskGetRewardMessage = BaseClass("SeasonMonsterEventTaskGetRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonMonsterEventTaskGetRewardMessage:OnCreate(actId, taskId)
  base.OnCreate(self)
  self.sfsObj:PutInt("actId", actId)
  self.sfsObj:PutInt("taskId", taskId)
end

function SeasonMonsterEventTaskGetRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.JungleTrialDataManager:HandleJungleTrialTaskClaimReward(t)
  end
end

return SeasonMonsterEventTaskGetRewardMessage
