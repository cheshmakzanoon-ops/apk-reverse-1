local ChampionBattleBetViewMessage = BaseClass("ChampionBattleBetViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, phase, location)
  base.OnCreate(self)
  self.sfsObj:PutLong("phase", phase)
  self.sfsObj:PutLong("location", location)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.ChampionBattleBetViewBack, message)
end

ChampionBattleBetViewMessage.OnCreate = OnCreate
ChampionBattleBetViewMessage.HandleMessage = HandleMessage
return ChampionBattleBetViewMessage
