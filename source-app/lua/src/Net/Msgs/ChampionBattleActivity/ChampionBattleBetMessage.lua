local ChampionBattleBetMessage = BaseClass("ChampionBattleBetMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, phase, location, bettedIndex, count)
  base.OnCreate(self)
  self.sfsObj:PutLong("phase", phase)
  self.sfsObj:PutLong("location", location)
  self.sfsObj:PutLong("bettedIndex", bettedIndex)
  self.sfsObj:PutLong("count", count)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.ChampionBattleBetBack, message)
end

ChampionBattleBetMessage.OnCreate = OnCreate
ChampionBattleBetMessage.HandleMessage = HandleMessage
return ChampionBattleBetMessage
