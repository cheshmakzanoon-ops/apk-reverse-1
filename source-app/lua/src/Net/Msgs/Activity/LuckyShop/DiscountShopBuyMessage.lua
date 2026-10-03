local DiscountShopBuyMessage = BaseClass("DiscountShopBuyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, id)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("shopId", id)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.LuckyShopManager:BuyItemHandler(t)
end

DiscountShopBuyMessage.OnCreate = OnCreate
DiscountShopBuyMessage.HandleMessage = HandleMessage
return DiscountShopBuyMessage
