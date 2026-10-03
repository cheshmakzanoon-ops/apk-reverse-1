local HeroLotteryClaimWishGuideRewardMessage = BaseClass("HeroLotteryClaimWishGuideRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    local lang = Localization:GetString(message.errorCode)
    UIUtil.ShowTips(lang or message.errorCode)
    return
  end
  DataCenter.LotteryDataManager:OnClaimWishGuideReward(message)
end

HeroLotteryClaimWishGuideRewardMessage.OnCreate = OnCreate
HeroLotteryClaimWishGuideRewardMessage.HandleMessage = HandleMessage
return HeroLotteryClaimWishGuideRewardMessage
