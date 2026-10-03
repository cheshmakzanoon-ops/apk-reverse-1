local RevivalOpenRewardBoxMessage = BaseClass("RevivalOpenRewardBoxMessage", SFSBaseMessage)
local base = SFSBaseMessage

function RevivalOpenRewardBoxMessage:OnCreate(param)
  base.OnCreate(self)
end

function RevivalOpenRewardBoxMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RevivalPlanManager:OnBoxOpenReward(t)
  end
end

return RevivalOpenRewardBoxMessage
