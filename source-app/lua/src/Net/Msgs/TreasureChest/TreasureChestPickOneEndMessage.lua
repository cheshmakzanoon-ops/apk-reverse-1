local TreasureChestPickOneEndMessage = BaseClass("TreasureChestPickOneEndMessage", SFSBaseMessage)
local base = SFSBaseMessage

function TreasureChestPickOneEndMessage:OnCreate(id, select, extraInfo)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", id)
  self.sfsObj:PutInt("progress", select)
  self.sfsObj:PutUtfString("extraInfo", extraInfo)
end

function TreasureChestPickOneEndMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.TreasureChestEndRequestResult, t)
  end
end

return TreasureChestPickOneEndMessage
