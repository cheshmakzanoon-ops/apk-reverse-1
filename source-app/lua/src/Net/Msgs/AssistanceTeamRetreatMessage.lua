local AssistanceTeamRetreatMessage = BaseClass("AssistanceTeamRetreatMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, bUuid, marchUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("bUuid", bUuid)
  self.sfsObj:PutLong("marchUuid", marchUuid)
  self.sfsObj:PutInt("targetServer", LuaEntry.Player:GetCurServerId())
  self.sfsObj:PutInt("worldId", LuaEntry.Player:GetCurWorldId())
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.FormationAssistanceDataManager:OnAssistanceTeamRetreat(t)
  end
end

AssistanceTeamRetreatMessage.OnCreate = OnCreate
AssistanceTeamRetreatMessage.HandleMessage = HandleMessage
return AssistanceTeamRetreatMessage
