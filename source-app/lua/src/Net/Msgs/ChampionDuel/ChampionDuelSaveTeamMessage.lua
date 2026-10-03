local ChampionDuelSaveTeamMessage = BaseClass("ChampionDuelSaveTeamMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, sfsArray)
  base.OnCreate(self)
  self.sfsObj:PutSFSArray("teamInfos", sfsArray)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ChampionDuelManager:HandleTeamOperation(t, false)
end

ChampionDuelSaveTeamMessage.OnCreate = OnCreate
ChampionDuelSaveTeamMessage.HandleMessage = HandleMessage
return ChampionDuelSaveTeamMessage
