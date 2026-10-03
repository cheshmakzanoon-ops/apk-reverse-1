local HeroSkillUnlockMessage = BaseClass("HeroSkillUnlockMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, heroUuid, slotId)
  base.OnCreate(self)
  self.sfsObj:PutLong("heroUuid", heroUuid)
  self.sfsObj:PutInt("slot", slotId)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.HeroDataManager:UpdateOneHero(message.hero)
    EventManager:GetInstance():Broadcast(EventId.HeroSkillUnlockBack, message)
    UIUtil.ShowTipsId(151097)
  end
end

HeroSkillUnlockMessage.OnCreate = OnCreate
HeroSkillUnlockMessage.HandleMessage = HandleMessage
return HeroSkillUnlockMessage
