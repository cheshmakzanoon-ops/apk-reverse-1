local PushEpidemicZoneCommanderOptMessage = BaseClass("PushEpidemicZoneCommanderOptMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushEpidemicZoneCommanderOptMessage:OnCreate()
  base.OnCreate(self)
end

function PushEpidemicZoneCommanderOptMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleCommanderOptPush(t)
end

return PushEpidemicZoneCommanderOptMessage
