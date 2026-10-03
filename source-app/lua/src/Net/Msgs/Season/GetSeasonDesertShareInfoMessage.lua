local GetSeasonDesertShareInfoMessage = BaseClass("GetSeasonDesertShareInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetSeasonDesertShareInfoMessage:OnCreate(desertUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", desertUuid)
end

function GetSeasonDesertShareInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    return
  end
  DataCenter.SeasonDataManager:SetShareDesertStatus(t.uuid, t.invalidFlag, t.recUser)
  EventManager:GetInstance():Broadcast(EventId.LWShareDesertStatusUpdate)
end

return GetSeasonDesertShareInfoMessage
