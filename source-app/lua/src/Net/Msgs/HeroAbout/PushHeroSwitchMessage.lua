local PushHeroSwitchMessage = BaseClass("PushHeroSwitchMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local freeCount = message.freeCount or 0
  local freeMax = message.freeMax or 0
  local nextCampLotteryId = message.nextdayId or 0
  DataCenter.LotteryDataManager:SetCampChangeInfo(freeCount, freeMax, nextCampLotteryId)
  EventManager:GetInstance():Broadcast(EventId.RecruitCampChange)
end

PushHeroSwitchMessage.OnCreate = OnCreate
PushHeroSwitchMessage.HandleMessage = HandleMessage
return PushHeroSwitchMessage
