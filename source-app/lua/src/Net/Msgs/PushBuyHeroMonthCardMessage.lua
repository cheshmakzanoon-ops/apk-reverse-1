local PushBuyHeroMonthCardMessage = BaseClass("PushBuyHeroMonthCardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local activityId = t.activityId
  if activityId then
    DataCenter.HeroMonthCardManager:DoWhenBuyCard(activityId)
  end
end

PushBuyHeroMonthCardMessage.OnCreate = OnCreate
PushBuyHeroMonthCardMessage.HandleMessage = HandleMessage
return PushBuyHeroMonthCardMessage
