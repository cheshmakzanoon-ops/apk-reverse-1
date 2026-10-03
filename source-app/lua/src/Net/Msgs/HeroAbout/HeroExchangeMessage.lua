local HeroExchangeMessage = BaseClass("HeroExchangeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, itemId, exchangeCount)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("itemId", tostring(itemId))
  self.sfsObj:PutInt("count", exchangeCount)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    local lang = Localization:GetString(message.errorCode)
    UIUtil.ShowTips(lang or message.errorCode)
    return
  end
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UINewHero)
  if window == nil and message.reward ~= nil and message.reward[1] ~= nil then
    local heroUuid = message.reward[1].value.uuid
    if DataCenter.HeroDataManager:NeedShowNewHeroWindow(heroUuid) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroExhibitPanel, {anim = false}, heroUuid, {heroUuid}, nil, true)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.HeroStationUpdate)
end

HeroExchangeMessage.OnCreate = OnCreate
HeroExchangeMessage.HandleMessage = HandleMessage
return HeroExchangeMessage
