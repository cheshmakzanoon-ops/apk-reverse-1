local ZoneMobilizationRankRewardPreviewMessage = BaseClass("ZoneMobilizationRankRewardPreviewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ZoneMobilizationRankRewardPreviewMessage:OnCreate()
  base.OnCreate(self)
end

function ZoneMobilizationRankRewardPreviewMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWZoneMobilizationManager:HandleRankRewardPreviewData(message)
  end
end

return ZoneMobilizationRankRewardPreviewMessage
