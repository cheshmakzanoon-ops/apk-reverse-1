local ChampionDuelSyncTeamMessage = BaseClass("ChampionDuelSyncTeamMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ChampionDuelManager:HandleTeamOperation(t, true)
end

ChampionDuelSyncTeamMessage.OnCreate = OnCreate
ChampionDuelSyncTeamMessage.HandleMessage = HandleMessage
return ChampionDuelSyncTeamMessage
