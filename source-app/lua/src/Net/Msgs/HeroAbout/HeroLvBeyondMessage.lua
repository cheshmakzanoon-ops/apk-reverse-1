local HeroLvBeyondMessage = BaseClass("HeroLvBeyondMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, heroUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", heroUuid)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    return
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Hero_Upgrade3, false)
  local res = message.resource
  if res ~= nil then
    LuaEntry.Resource:UpdateResource(res)
  end
  DataCenter.HeroDataManager:UpdateOneHero(message.hero)
  local heroUuid = message.hero.uuid
  EventManager:GetInstance():Broadcast(EventId.HeroLvUpSuccess, heroUuid)
  EventManager:GetInstance():Broadcast(EventId.HeroBeyondSuccess, heroUuid)
  EventManager:GetInstance():Broadcast(EventId.HeroStationUpdate)
  UIUtil.ShowTipsId(120062)
end

HeroLvBeyondMessage.OnCreate = OnCreate
HeroLvBeyondMessage.HandleMessage = HandleMessage
return HeroLvBeyondMessage
