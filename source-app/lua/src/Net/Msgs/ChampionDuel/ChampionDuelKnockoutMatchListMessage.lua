local ChampionDuelKnockoutMatchListMessage = BaseClass("ChampionDuelKnockoutMatchListMessage", SFSBaseMessage)
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
end

ChampionDuelKnockoutMatchListMessage.OnCreate = OnCreate
ChampionDuelKnockoutMatchListMessage.HandleMessage = HandleMessage
return ChampionDuelKnockoutMatchListMessage
