local ChampionDuelBetMainMessage = BaseClass("ChampionDuelBetMainMessage", SFSBaseMessage)
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
  DataCenter.ChampionDuelManager:HandleBetMain(t)
end

ChampionDuelBetMainMessage.OnCreate = OnCreate
ChampionDuelBetMainMessage.HandleMessage = HandleMessage
return ChampionDuelBetMainMessage
