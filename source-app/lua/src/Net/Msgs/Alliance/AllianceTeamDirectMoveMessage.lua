local AllianceTeamDirectMoveMessage = BaseClass("AllianceTeamDirectMoveMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, teamUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("teamUuid", teamUuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
end

AllianceTeamDirectMoveMessage.OnCreate = OnCreate
AllianceTeamDirectMoveMessage.HandleMessage = HandleMessage
return AllianceTeamDirectMoveMessage
