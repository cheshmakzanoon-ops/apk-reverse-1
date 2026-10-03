local PushHeroLotteryMessage = BaseClass("PushHeroLotteryMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  DataCenter.LotteryDataManager:InitData(message)
  EventManager:GetInstance():Broadcast(EventId.CheckPubBubble, true)
end

PushHeroLotteryMessage.OnCreate = OnCreate
PushHeroLotteryMessage.HandleMessage = HandleMessage
return PushHeroLotteryMessage
