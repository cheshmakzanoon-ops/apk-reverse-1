local AllianceCongratulationGainCongratulationListMessage = BaseClass("AllianceCongratulationGainCongratulationListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceCongratulationGainCongratulationListMessage:OnCreate(param)
  base.OnCreate(self)
end

function AllianceCongratulationGainCongratulationListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceCongratulationDataManager:SaveAllianceCongratulationList(t)
  end
end

return AllianceCongratulationGainCongratulationListMessage
