local StorageShopUnlockSlotMessage = BaseClass("StorageShopUnlockSlotMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.StorageShopManager:OnRecvUnlcokSlot(t)
  end
end

StorageShopUnlockSlotMessage.OnCreate = OnCreate
StorageShopUnlockSlotMessage.HandleMessage = HandleMessage
return StorageShopUnlockSlotMessage
