local ZoneMobilizationBuildToWorldMessage = BaseClass("ZoneMobilizationBuildToWorldMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ZoneMobilizationBuildToWorldMessage:OnCreate(pointId)
  base.OnCreate(self)
  self.sfsObj:PutInt("pointId", pointId)
end

function ZoneMobilizationBuildToWorldMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(4)
  end
end

return ZoneMobilizationBuildToWorldMessage
