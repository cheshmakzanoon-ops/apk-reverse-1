local PushStorageShopSoldSuccMessage = BaseClass("PushStorageShopSoldSuccMessage", SFSBaseMessage)
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
    DataCenter.StorageShopManager:OnRecvSoldSucc(t)
  end
end

PushStorageShopSoldSuccMessage.OnCreate = OnCreate
PushStorageShopSoldSuccMessage.HandleMessage = HandleMessage
return PushStorageShopSoldSuccMessage
