local PushGhostParkourRoundChangeMessage = BaseClass("PushGhostParkourRoundChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushGhostParkourRoundChangeMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushGhostParkourRoundChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWGhostParkourDataManager:SendGetGhostParkourInfosMessage(nil, true)
  end
end

return PushGhostParkourRoundChangeMessage
