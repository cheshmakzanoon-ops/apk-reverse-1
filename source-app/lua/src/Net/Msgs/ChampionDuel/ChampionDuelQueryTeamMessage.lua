local ChampionDuelQueryTeamMessage = BaseClass("ChampionDuelQueryTeamMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uid", uid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ChampionDuelManager:HandleTeam(t)
end

ChampionDuelQueryTeamMessage.OnCreate = OnCreate
ChampionDuelQueryTeamMessage.HandleMessage = HandleMessage
return ChampionDuelQueryTeamMessage
