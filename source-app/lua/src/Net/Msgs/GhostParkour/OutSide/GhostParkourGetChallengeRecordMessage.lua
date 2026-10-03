local GhostParkourGetChallengeRecordMessage = BaseClass("GhostParkourGetChallengeRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GhostParkourGetChallengeRecordMessage:OnCreate(param)
  base.OnCreate(self)
end

function GhostParkourGetChallengeRecordMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWGhostParkourDataManager:SaveChallengeRecordInfos(t)
  end
end

return GhostParkourGetChallengeRecordMessage
