local ActChampionBattleSingUpMessage = BaseClass("ActChampionBattleSingUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  DataCenter.ActChampionBattleManager:RefreshChampionBattleInfo(message)
  EventManager:GetInstance():Broadcast(EventId.ChampionBattleSingUpBack)
end

ActChampionBattleSingUpMessage.OnCreate = OnCreate
ActChampionBattleSingUpMessage.HandleMessage = HandleMessage
return ActChampionBattleSingUpMessage
