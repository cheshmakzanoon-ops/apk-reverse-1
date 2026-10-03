local ChampionDuelHotActWordMessage = BaseClass("ChampionDuelHotActWordMessage", SFSBaseMessage)
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
  DataCenter.ChampionDuelManager:HandleDonateActWord(t)
  EventManager:GetInstance():Broadcast(EventId.ChampionDuelDonateActWordGet)
end

ChampionDuelHotActWordMessage.OnCreate = OnCreate
ChampionDuelHotActWordMessage.HandleMessage = HandleMessage
return ChampionDuelHotActWordMessage
