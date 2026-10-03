local PushAllianceCongratulationCongratulationListChangeMessage = BaseClass("PushAllianceCongratulationCongratulationListChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceCongratulationCongratulationListChangeMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceCongratulationCongratulationListChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceCongratulationDataManager:SendGetAllianceCongratulationList()
  end
end

return PushAllianceCongratulationCongratulationListChangeMessage
