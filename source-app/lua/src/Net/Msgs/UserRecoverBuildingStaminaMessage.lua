local UserRecoverBuildingStaminaMessage = BaseClass("UserRecoverBuildingStaminaMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, bUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", bUuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(t.errorCode))
  else
    DataCenter.BuildManager:AddBuilding(t)
    if t.resource ~= nil then
      LuaEntry.Resource:UpdateResource(t.resource)
    end
    if t.uuid ~= nil then
      EventManager:GetInstance():Broadcast(EventId.ShowIsOnFire, t.uuid)
    end
    UIUtil.ShowTipsId(300541)
  end
end

UserRecoverBuildingStaminaMessage.OnCreate = OnCreate
UserRecoverBuildingStaminaMessage.HandleMessage = HandleMessage
return UserRecoverBuildingStaminaMessage
