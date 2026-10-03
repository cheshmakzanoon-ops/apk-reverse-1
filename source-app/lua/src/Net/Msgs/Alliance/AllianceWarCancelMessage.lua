local AllianceWarCancelMessage = BaseClass("AllianceWarCancelMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, teamUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("teamUuid", teamUuid)
  local data = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(teamUuid)
  if data then
    self.sfsObj:PutInt("targetServer", data.server)
    self.sfsObj:PutInt("worldId", data.worldId)
  else
    self.sfsObj:PutInt("targetServer", LuaEntry.Player:GetCurServerId())
    self.sfsObj:PutInt("worldId", LuaEntry.Player:GetCurWorldId())
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

AllianceWarCancelMessage.OnCreate = OnCreate
AllianceWarCancelMessage.HandleMessage = HandleMessage
return AllianceWarCancelMessage
