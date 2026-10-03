local GetSeasonInfosMessage = BaseClass("GetSeasonInfosMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetSeasonInfosMessage:OnCreate(param)
  base.OnCreate(self)
end

function GetSeasonInfosMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.GetSeasonStartTime, t.seasonArr)
  end
end

return GetSeasonInfosMessage
