local GetCrossDeclareWarInfoMessage = BaseClass("GetCrossDeclareWarInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetCrossDeclareWarInfoMessage:OnCreate(param)
  base.OnCreate(self)
  local allianceid = param and param.allianceid or LuaEntry.Player.allianceId
  if not string.IsNullOrEmpty(allianceid) then
    self.sfsObj:PutUtfString("allianceid", allianceid)
  end
end

function GetCrossDeclareWarInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonDataManager.CrossDeclareWarInfo = t
  EventManager:GetInstance():Broadcast(EventId.LWSeasonCrossDeclareWarInfo)
  DataCenter.SeasonCampDestroyManager:OnGetInfoCallback(t)
end

return GetCrossDeclareWarInfoMessage
