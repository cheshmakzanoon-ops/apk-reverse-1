local AllianceWarRetreatMessage = BaseClass("AllianceWarRetreatMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, teamUuid, marchUuid)
  base.OnCreate(self)
  self.teamUuid = teamUuid
  self.marchUuid = marchUuid
  self.sfsObj:PutLong("teamUuid", teamUuid)
  self.sfsObj:PutLong("marchUuid", marchUuid)
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
  if t.success == true then
    UIUtil.ShowTipsId(390998)
  end
  if t.name then
    UIUtil.ShowTips(Localization:GetString("390804", t.name))
  end
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      UIUtil.ShowTips(Localization:GetString(errCode, table.unpack(t.errorPara2)))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
  end
end

AllianceWarRetreatMessage.OnCreate = OnCreate
AllianceWarRetreatMessage.HandleMessage = HandleMessage
return AllianceWarRetreatMessage
