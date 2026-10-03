local ChampionDuelHotActInfoMessage = BaseClass("ChampionDuelHotActInfoMessage", SFSBaseMessage)
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
  DataCenter.ChampionDuelManager:HandleDonateActInfo(t)
  EventManager:GetInstance():Broadcast(EventId.ChampionDuelDonateActInfoGet)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

ChampionDuelHotActInfoMessage.OnCreate = OnCreate
ChampionDuelHotActInfoMessage.HandleMessage = HandleMessage
return ChampionDuelHotActInfoMessage
