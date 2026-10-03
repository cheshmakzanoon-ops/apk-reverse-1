local StorageShopClaimMoneyMessage = BaseClass("StorageShopClaimMoneyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId(320311)
    DataCenter.StorageShopManager:OnRecvClaimMoneyBack(t)
  end
end

StorageShopClaimMoneyMessage.OnCreate = OnCreate
StorageShopClaimMoneyMessage.HandleMessage = HandleMessage
return StorageShopClaimMoneyMessage
