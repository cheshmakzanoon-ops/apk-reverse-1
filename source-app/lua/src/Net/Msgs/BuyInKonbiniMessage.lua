local BuyInKonbiniMessage = BaseClass("BuyInKonbiniMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", param.index)
  self.sfsObj:PutBool("useFree", param.useFree)
  if param.useItemCount then
    self.sfsObj:PutInt("useItemCount", param.useItemCount)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.resources ~= nil then
    LuaEntry.Resource:UpdateResource(t.resources)
  end
  if t.gold ~= nil then
    LuaEntry.Player.gold = t.gold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  LuaEntry.Player:UpdateKonbiniInfo(t)
  EventManager:GetInstance():Broadcast(EventId.BuyKonbiniRefresh)
end

BuyInKonbiniMessage.OnCreate = OnCreate
BuyInKonbiniMessage.HandleMessage = HandleMessage
return BuyInKonbiniMessage
