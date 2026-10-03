local PushRichmanShopBuyMessage = BaseClass("PushRichmanShopBuyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActMonopolyDataManager:UpdateShopItem(t)
    EventManager:GetInstance():Broadcast(EventId.GetActMonopolyShoUpdatepMsg)
  end
end

PushRichmanShopBuyMessage.OnCreate = OnCreate
PushRichmanShopBuyMessage.HandleMessage = HandleMessage
return PushRichmanShopBuyMessage
