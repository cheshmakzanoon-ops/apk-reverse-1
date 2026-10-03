local StorageShopGetShopInfoMessage = BaseClass("StorageShopGetShopInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uid, targetServer)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uid", uid)
  self.sfsObj:PutInt("targetServer", targetServer)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.StorageShopManager:OnGetOtherPlayerShop(t)
  end
end

StorageShopGetShopInfoMessage.OnCreate = OnCreate
StorageShopGetShopInfoMessage.HandleMessage = HandleMessage
return StorageShopGetShopInfoMessage
