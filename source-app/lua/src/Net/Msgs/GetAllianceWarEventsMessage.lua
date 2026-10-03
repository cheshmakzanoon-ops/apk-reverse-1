local GetAllianceWarEventsMessage = BaseClass("GetAllianceWarEventsMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetAllianceWarEventsMessage:OnCreate(param)
  base.OnCreate(self)
end

function GetAllianceWarEventsMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.events then
    DataCenter.AllianceWarEventDataManager:HandleGetAllianceWarEventsMessage(t.events)
  end
end

return GetAllianceWarEventsMessage
