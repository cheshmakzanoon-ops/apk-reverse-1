local UserShopHonorCacheUpdateMessage = BaseClass("UserShopHonorCacheUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserShopHonorCacheUpdateMessage:OnCreate(curShopIdList)
  base.OnCreate(self)
  self.sfsObj:PutIntArray("newShopIds", curShopIdList)
end

function UserShopHonorCacheUpdateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.CommonShopManager:OnGetHonorShopItemsCacheMessage(t)
  end
end

return UserShopHonorCacheUpdateMessage
