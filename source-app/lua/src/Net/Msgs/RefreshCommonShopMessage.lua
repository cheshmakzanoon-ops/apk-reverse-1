local RefreshCommonShopMessage = BaseClass("RefreshCommonShopMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, shopType)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", shopType)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.gold then
      LuaEntry.Player.gold = t.gold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    DataCenter.CommonShopManager:UpdateOneShopInfo(t)
  end
end

RefreshCommonShopMessage.OnCreate = OnCreate
RefreshCommonShopMessage.HandleMessage = HandleMessage
return RefreshCommonShopMessage
