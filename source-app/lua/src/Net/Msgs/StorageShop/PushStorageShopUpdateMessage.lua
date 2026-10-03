local PushStorageShopUpdateMessage = BaseClass("PushStorageShopUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.StorageShopManager:InitShopData(t)
  end
end

PushStorageShopUpdateMessage.OnCreate = OnCreate
PushStorageShopUpdateMessage.HandleMessage = HandleMessage
return PushStorageShopUpdateMessage
