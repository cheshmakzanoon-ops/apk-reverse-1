local StorageShopRemoveGoodsMessage = BaseClass("StorageShopRemoveGoodsMessage", SFSBaseMessage)
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
    DataCenter.StorageShopManager:OnRecvRemoveGoods(t)
  end
end

StorageShopRemoveGoodsMessage.OnCreate = OnCreate
StorageShopRemoveGoodsMessage.HandleMessage = HandleMessage
return StorageShopRemoveGoodsMessage
