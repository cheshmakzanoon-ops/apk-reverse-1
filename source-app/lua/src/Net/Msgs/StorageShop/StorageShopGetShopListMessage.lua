local StorageShopGetShopListMessage = BaseClass("StorageShopGetShopListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, refreshType)
  base.OnCreate(self)
  if refreshType ~= nil then
    self.sfsObj:PutInt("type", refreshType)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.StorageShopManager:OnRecvShopsList(t)
  end
end

StorageShopGetShopListMessage.OnCreate = OnCreate
StorageShopGetShopListMessage.HandleMessage = HandleMessage
return StorageShopGetShopListMessage
