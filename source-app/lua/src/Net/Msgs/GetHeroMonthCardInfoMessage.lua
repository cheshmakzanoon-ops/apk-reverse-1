local GetHeroMonthCardInfoMessage = BaseClass("GetHeroMonthCardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  DataCenter.HeroMonthCardManager:DoWhenAllDataBack(message)
end

GetHeroMonthCardInfoMessage.OnCreate = OnCreate
GetHeroMonthCardInfoMessage.HandleMessage = HandleMessage
return GetHeroMonthCardInfoMessage
