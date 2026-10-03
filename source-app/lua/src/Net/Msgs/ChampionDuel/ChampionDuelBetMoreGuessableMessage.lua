local ChampionDuelBetMoreGuessableMessage = BaseClass("ChampionDuelBetMoreGuessableMessage", SFSBaseMessage)
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
  DataCenter.ChampionDuelManager:HandleBetRivalList(t, true)
end

ChampionDuelBetMoreGuessableMessage.OnCreate = OnCreate
ChampionDuelBetMoreGuessableMessage.HandleMessage = HandleMessage
return ChampionDuelBetMoreGuessableMessage
