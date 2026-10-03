local HeroEquipPromoteMessage = BaseClass("HeroEquipPromoteMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, equipUuid)
  base.OnCreate(self)
  if equipUuid == nil then
    return
  end
  self.sfsObj:PutLong("uid", equipUuid)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  local res = message.resource
  if res ~= nil then
    LuaEntry.Resource:UpdateResource(res)
  end
  local equipUuid = message.uid
  EventManager:GetInstance():Broadcast(EventId.HeorEquipPromote, equipUuid)
end

HeroEquipPromoteMessage.OnCreate = OnCreate
HeroEquipPromoteMessage.HandleMessage = HandleMessage
return HeroEquipPromoteMessage
