local HeroLotteryClaimWishMessage = BaseClass("HeroLotteryClaimWishMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("id", param.lotteryId)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    local lang = Localization:GetString(message.errorCode)
    UIUtil.ShowTips(lang or message.errorCode)
    return
  end
  DataCenter.LotteryDataManager:UpdateOneLottery(message)
  DataCenter.LotteryDataManager:OnClaimWishHeroCallback(message)
end

HeroLotteryClaimWishMessage.OnCreate = OnCreate
HeroLotteryClaimWishMessage.HandleMessage = HandleMessage
return HeroLotteryClaimWishMessage
