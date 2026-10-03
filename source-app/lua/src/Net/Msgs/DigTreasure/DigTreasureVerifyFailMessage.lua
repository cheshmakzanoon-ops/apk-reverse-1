local DigTreasureVerifyFailMessage = BaseClass("DigTreasureVerifyFailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DigTreasureVerifyFailMessage:OnCreate(uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

function DigTreasureVerifyFailMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.DigTreasureManager:ClearTimeLimitMapInfo()
    EventManager:GetInstance():Broadcast(EventId.DigTreasureUpdateMapData)
  end
end

return DigTreasureVerifyFailMessage
