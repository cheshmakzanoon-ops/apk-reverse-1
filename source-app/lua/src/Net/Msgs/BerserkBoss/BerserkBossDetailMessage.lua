local BerserkBossDetailMessage = BaseClass("BerserkBossDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BerserkBossDetailMessage:OnCreate(bossUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", bossUuid)
end

function BerserkBossDetailMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWBerserkBossManager:HandleBerserkBossDetailData(message)
  end
end

return BerserkBossDetailMessage
