local GetAllianceWarListMessage = BaseClass("GetAllianceWarListMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, targetServer)
  base.OnCreate(self)
  if targetServer ~= -1 then
    self.sfsObj:PutInt("targetServer", targetServer)
    self.sfsObj:PutInt("worldId", LuaEntry.Player:GetCurWorldId())
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.teams then
    DataCenter.AllianceWarDataManager:InitAllianceWarList(t)
    local isActive = true
    EventManager:GetInstance():Broadcast(EventId.AllianceWarUpdate, isActive)
  end
end

GetAllianceWarListMessage.OnCreate = OnCreate
GetAllianceWarListMessage.HandleMessage = HandleMessage
return GetAllianceWarListMessage
