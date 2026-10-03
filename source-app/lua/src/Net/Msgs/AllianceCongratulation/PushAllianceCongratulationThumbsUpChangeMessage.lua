local PushAllianceCongratulationThumbsUpChangeMessage = BaseClass("PushAllianceCongratulationThumbsUpChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceCongratulationThumbsUpChangeMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceCongratulationThumbsUpChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceCongratulationDataManager:ChangeThumbsUpTarget(t)
    EventManager:GetInstance():Broadcast(EventId.AllianceCongratulationThumbsUpChange)
  end
end

return PushAllianceCongratulationThumbsUpChangeMessage
