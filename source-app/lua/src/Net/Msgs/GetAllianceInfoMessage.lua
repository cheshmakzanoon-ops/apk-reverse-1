local GetAllianceInfoMessage = BaseClass("GetAllianceInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, allianceId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("allianceId", allianceId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    EventManager:GetInstance():Broadcast(EventId.SearchAllianceError)
  else
    DataCenter.AllianceTempListManager:RefreshAllianceData(t)
    UIUtil.CheckShowAllianceInfo(t.ownerServerId, t.uid)
    EventManager:GetInstance():BroadcastDeferred(EventId.SearchAllianceSuccess)
  end
end

GetAllianceInfoMessage.OnCreate = OnCreate
GetAllianceInfoMessage.HandleMessage = HandleMessage
return GetAllianceInfoMessage
