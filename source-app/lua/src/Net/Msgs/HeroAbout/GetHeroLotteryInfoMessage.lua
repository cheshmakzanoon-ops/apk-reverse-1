local GetHeroLotteryInfoMessage = BaseClass("GetHeroLotteryInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    local lang = Localization:GetString(message.errorCode)
    UIUtil.ShowTips(lang or message.errorCode)
    return
  end
  DataCenter.LotteryDataManager:UpdateLotteryData(message)
  EventManager:GetInstance():Broadcast(EventId.HeroLotteryInfoUpdate)
end

GetHeroLotteryInfoMessage.OnCreate = OnCreate
GetHeroLotteryInfoMessage.HandleMessage = HandleMessage
return GetHeroLotteryInfoMessage
