local ChampionDuelSignUpMessage = BaseClass("ChampionDuelSignUpMessage", SFSBaseMessage)
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
  DataCenter.ChampionDuelManager:HandleSignUp(t)
end

ChampionDuelSignUpMessage.OnCreate = OnCreate
ChampionDuelSignUpMessage.HandleMessage = HandleMessage
return ChampionDuelSignUpMessage
