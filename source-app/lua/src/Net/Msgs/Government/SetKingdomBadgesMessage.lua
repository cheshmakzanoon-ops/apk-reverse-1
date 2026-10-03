local SetKingdomBadgesMessage = BaseClass("SetKingdomBadgesMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SetKingdomBadgesMessage:OnCreate(cfgId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("cfgId", tostring(cfgId))
end

function SetKingdomBadgesMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t.resources ~= nil then
    LuaEntry.Resource:UpdateResource(t.resources)
  end
  if t.gold ~= nil then
    LuaEntry.Player.gold = t.gold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  DataCenter.GovernmentManager:SetKingdomBadgesHandler(t)
end

return SetKingdomBadgesMessage
