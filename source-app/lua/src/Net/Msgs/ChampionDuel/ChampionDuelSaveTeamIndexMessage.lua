local ChampionDuelSaveTeamIndexMessage = BaseClass("ChampionDuelSaveTeamIndexMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, order)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("order", order)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ChampionDuelManager:HandleTeamIndex(t)
end

ChampionDuelSaveTeamIndexMessage.OnCreate = OnCreate
ChampionDuelSaveTeamIndexMessage.HandleMessage = HandleMessage
return ChampionDuelSaveTeamIndexMessage
