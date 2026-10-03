local PushUserMarchCostRollbackMessage = BaseClass("PushUserMarchCostRollbackMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushUserMarchCostRollbackMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushUserMarchCostRollbackMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.reward ~= nil then
    DataCenter.RewardManager:AddRewards(t.reward)
  end
end

return PushUserMarchCostRollbackMessage
