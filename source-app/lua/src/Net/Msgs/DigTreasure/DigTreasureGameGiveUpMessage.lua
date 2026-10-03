local DigTreasureGameGiveUpMessage = BaseClass("DigTreasureGameGiveUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DigTreasureGameGiveUpMessage:OnCreate(uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

function DigTreasureGameGiveUpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.DigTreasureManager:OnGiveUpTimeLimitMap()
  end
end

return DigTreasureGameGiveUpMessage
