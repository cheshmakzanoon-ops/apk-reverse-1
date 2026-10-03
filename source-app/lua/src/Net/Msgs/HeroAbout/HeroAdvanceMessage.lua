local HeroAdvanceMessage = BaseClass("HeroAdvanceMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, heroUuid, costHeroes)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", heroUuid)
  self.sfsObj:PutLongArray("costHeroes", costHeroes)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    local lang = Localization:GetString(message.errorCode)
    UIUtil.ShowTips(lang or message.errorCode)
    return
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Hero_Upgrade1, false)
  HeroAdvanceController:GetInstance():OnHandleHeroAdvance(message)
  EventManager:GetInstance():Broadcast(EventId.CheckPubBubble, true)
  DataCenter.HeroStationManager:CheckStationEffectOldVal()
end

HeroAdvanceMessage.OnCreate = OnCreate
HeroAdvanceMessage.HandleMessage = HandleMessage
return HeroAdvanceMessage
