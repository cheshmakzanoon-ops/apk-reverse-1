local UIShopBuyMessage = BaseClass("UIShopBuyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutUtfString("itemId", param.itemId)
    self.sfsObj:PutInt("num", param.num)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ItemManager:ItemBuyHandle(t)
end

UIShopBuyMessage.OnCreate = OnCreate
UIShopBuyMessage.HandleMessage = HandleMessage
return UIShopBuyMessage
