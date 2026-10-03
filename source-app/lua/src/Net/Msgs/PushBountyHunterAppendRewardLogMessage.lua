local PushBountyHunterAppendRewardLogMessage = BaseClass("PushBountyHunterAppendRewardLogMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushBountyHunterAppendRewardLogMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushBountyHunterAppendRewardLogMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.activityId then
    local activityId = toInt(t.activityId)
    local actData = DataCenter.BountyHunterActDataManager:GetActData(activityId)
    if not actData then
      return
    end
    actData:AppendBatLogData(t)
    if t.removes then
      for i, v in ipairs(t.removes) do
        actData:RemoveBatLogData(v)
      end
    end
  end
end

return PushBountyHunterAppendRewardLogMessage
