local BloodNightTaskGetRewardMessage = BaseClass("BloodNightTaskGetRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BloodNightTaskGetRewardMessage:OnCreate(stageId, taskId)
  base.OnCreate(self)
  self.sfsObj:PutInt("planId", stageId)
  self.sfsObj:PutInt("taskId", taskId)
end

function BloodNightTaskGetRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BloodyNightDataManager:HandleTaskClaimReward(t)
  end
end

return BloodNightTaskGetRewardMessage
