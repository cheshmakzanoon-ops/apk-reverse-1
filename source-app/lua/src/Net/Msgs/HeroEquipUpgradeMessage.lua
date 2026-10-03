local HeroEquipUpgradeMessage = BaseClass("HeroEquipUpgradeMessage", SFSBaseMessage)
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
  local totalLv = tonumber(message.totalLevel)
  Logger.Log("HeroEquipUpgradeMessage           total equip Lv:  " .. totalLv)
  DataCenter.EquipDataManager:UpdateTotalLevel(HeroEquipQuality.Orange, totalLv)
  local equipUuid = message.uid
  EventManager:GetInstance():Broadcast(EventId.HeroEquipUpgrade, equipUuid)
end

HeroEquipUpgradeMessage.OnCreate = OnCreate
HeroEquipUpgradeMessage.HandleMessage = HandleMessage
return HeroEquipUpgradeMessage
