local HeroLotterySwitchWishMessage = BaseClass("HeroLotterySwitchWishMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("id", param.lotteryId)
  self.sfsObj:PutUtfString("wishHero", param.wishHero)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    local lang = Localization:GetString(message.errorCode)
    UIUtil.ShowTips(lang or message.errorCode)
    return
  end
  DataCenter.LotteryDataManager:UpdateOneLottery(message)
  EventManager:GetInstance():Broadcast(EventId.HeroLotterySwitchWishSuccess)
end

HeroLotterySwitchWishMessage.OnCreate = OnCreate
HeroLotterySwitchWishMessage.HandleMessage = HandleMessage
return HeroLotterySwitchWishMessage
