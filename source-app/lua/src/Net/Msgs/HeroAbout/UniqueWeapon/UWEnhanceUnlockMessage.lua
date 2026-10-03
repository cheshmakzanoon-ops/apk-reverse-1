local UWEnhanceUnlockMessage = BaseClass("UWEnhanceUnlockMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, heroUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("heroUuid", heroUuid)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  DataCenter.HeroDataManager:UnlockHeroUWEnhance(message.heroUuid)
  EventManager:GetInstance():Broadcast(EventId.HeroUWEnhanceUnlocked, message.heroUuid)
end

UWEnhanceUnlockMessage.OnCreate = OnCreate
UWEnhanceUnlockMessage.HandleMessage = HandleMessage
return UWEnhanceUnlockMessage
