local KingdomBuildingGroupMailSendMessage = BaseClass("KingdomBuildingGroupMailSendMessage", SFSBaseMessage)
local base = SFSBaseMessage

function KingdomBuildingGroupMailSendMessage:OnCreate(title, content)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("title", title)
  self.sfsObj:PutUtfString("content", content)
end

function KingdomBuildingGroupMailSendMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BuildingOfficialManager:SetEightMailCost(t)
    if t.remainGold then
      LuaEntry.Player.gold = t.remainGold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
  end
end

return KingdomBuildingGroupMailSendMessage
