local HeroExchangeFragmentMessage = BaseClass("HeroExchangeFragmentMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, heroUuid, exchangeNum)
  base.OnCreate(self)
  self.sfsObj:PutLong("heroId", heroUuid)
  self.sfsObj:PutInt("exchangeNum", exchangeNum)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    local lang = Localization:GetString(message.errorCode)
    UIUtil.ShowTips(lang or message.errorCode)
    return
  end
  UIUtil.ShowTipsId(120120)
end

HeroExchangeFragmentMessage.OnCreate = OnCreate
HeroExchangeFragmentMessage.HandleMessage = HandleMessage
return HeroExchangeFragmentMessage
