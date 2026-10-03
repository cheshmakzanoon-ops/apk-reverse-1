local PushStorageShopUnlockMessage = BaseClass("PushStorageShopUnlockMessage", SFSBaseMessage)
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

PushStorageShopUnlockMessage.OnCreate = OnCreate
PushStorageShopUnlockMessage.HandleMessage = HandleMessage
return PushStorageShopUnlockMessage
