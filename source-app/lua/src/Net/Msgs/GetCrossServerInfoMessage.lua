local GetCrossServerInfoMessage = BaseClass("GetCrossServerInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllWorldsManager:onServerList(t)
    EventManager:GetInstance():Broadcast(EventId.OnGetServerDataRefresh)
  end
end

GetCrossServerInfoMessage.OnCreate = OnCreate
GetCrossServerInfoMessage.HandleMessage = HandleMessage
return GetCrossServerInfoMessage
