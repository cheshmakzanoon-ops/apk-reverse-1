local TreasureChestPickOneStartMessage = BaseClass("TreasureChestPickOneStartMessage", SFSBaseMessage)
local base = SFSBaseMessage

function TreasureChestPickOneStartMessage:OnCreate(id, extraInfo)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", id)
  self.sfsObj:PutUtfString("extraInfo", extraInfo)
end

function TreasureChestPickOneStartMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.TreasureChestStartRequestResult, true)
  end
end

return TreasureChestPickOneStartMessage
