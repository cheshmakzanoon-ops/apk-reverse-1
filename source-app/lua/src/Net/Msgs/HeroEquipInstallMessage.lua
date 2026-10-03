local HeroEquipInstallMessage = BaseClass("HeroEquipInstallMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, heroUuid, equips)
  base.OnCreate(self)
  if heroUuid == nil or equips == nil or table.count(equips) < 1 then
    return
  end
  self.sfsObj:PutLong("heroUid", heroUuid)
  local equipArr = SFSArray.New()
  for slotId, equipUuId in pairs(equips) do
    local obj1 = SFSObject.New()
    obj1:PutInt("slot", slotId)
    obj1:PutLong("uid", equipUuId)
    equipArr:AddSFSObject(obj1)
  end
  self.sfsObj:PutSFSArray("slot2Uid", equipArr)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  EventManager:GetInstance():Broadcast(EventId.HeroEquipUninstall, message.heroUid)
end

HeroEquipInstallMessage.OnCreate = OnCreate
HeroEquipInstallMessage.HandleMessage = HandleMessage
return HeroEquipInstallMessage
