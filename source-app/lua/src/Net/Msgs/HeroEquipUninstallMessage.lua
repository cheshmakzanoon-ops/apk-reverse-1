local HeroEquipUninstallMessage = BaseClass("HeroEquipUninstallMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, heroUuid, slots)
  base.OnCreate(self)
  if heroUuid ~= nil and not table.IsNullOrEmpty(slots) then
    self.sfsObj:PutLong("heroUid", heroUuid)
    self.sfsObj:PutIntArray("slot", slots)
  end
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  EventManager:GetInstance():Broadcast(EventId.HeroEquipInstall, message.heroUid)
end

HeroEquipUninstallMessage.OnCreate = OnCreate
HeroEquipUninstallMessage.HandleMessage = HandleMessage
return HeroEquipUninstallMessage
