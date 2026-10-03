local ChampionDuelKnockoutMatchListPushMessage = BaseClass("ChampionDuelKnockoutMatchListPushMessage", SFSBaseMessage)
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
  DataCenter.ChampionDuelManager:HandleFinalMatchList(t)
end

ChampionDuelKnockoutMatchListPushMessage.OnCreate = OnCreate
ChampionDuelKnockoutMatchListPushMessage.HandleMessage = HandleMessage
return ChampionDuelKnockoutMatchListPushMessage
