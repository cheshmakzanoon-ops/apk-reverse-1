local CrossKingRoundInfoNowMessage = BaseClass("CrossKingRoundInfoNowMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CrossKingRoundInfoNowMessage:OnCreate()
  base.OnCreate(self)
end

function CrossKingRoundInfoNowMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ZoneWarManager:SetCrossKingRoundInfoNow(t)
end

return CrossKingRoundInfoNowMessage
