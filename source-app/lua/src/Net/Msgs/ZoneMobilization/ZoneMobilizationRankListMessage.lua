local ZoneMobilizationDonateRankMessage = BaseClass("ZoneMobilizationDonateRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ZoneMobilizationDonateRankMessage:OnCreate(type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
end

function ZoneMobilizationDonateRankMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWZoneMobilizationManager:HandleRankListData(message)
  end
end

return ZoneMobilizationDonateRankMessage
