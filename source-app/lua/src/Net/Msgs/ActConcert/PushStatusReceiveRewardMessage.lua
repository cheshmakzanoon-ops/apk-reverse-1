local PushStatusReceiveRewardMessage = BaseClass("PushStatusReceiveRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushStatusReceiveRewardMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushStatusReceiveRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActConcertDataManager:AddBuildMainSpecialRewardRecord(t.record)
    DataCenter.ActConcertDataManager:RefreshClaimRewardCount(t.statusId, t.curTimes)
  end
end

return PushStatusReceiveRewardMessage
