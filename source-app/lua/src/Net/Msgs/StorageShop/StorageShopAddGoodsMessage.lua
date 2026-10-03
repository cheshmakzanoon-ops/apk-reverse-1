local StorageShopAddGoodsMessage = BaseClass("StorageShopAddGoodsMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutLong("uuid", param.uuid)
    self.sfsObj:PutInt("itemId", param.itemId)
    self.sfsObj:PutInt("num", param.num)
    self.sfsObj:PutInt("price", param.price)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.StorageShopManager:OnRecvAddGoods(t)
  end
end

StorageShopAddGoodsMessage.OnCreate = OnCreate
StorageShopAddGoodsMessage.HandleMessage = HandleMessage
return StorageShopAddGoodsMessage
