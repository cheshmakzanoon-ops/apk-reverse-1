local BlueShopBuyMessage = BaseClass("BlueShopBuyMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function BlueShopBuyMessage:OnCreate(activityId, shopId, num)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutUtfString("shopId", shopId)
  self.sfsObj:PutInt("num", num)
end

function BlueShopBuyMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWTitaniumBlueStoreManager:UpdateProductDataAfterBuy(message)
  end
end

return BlueShopBuyMessage
