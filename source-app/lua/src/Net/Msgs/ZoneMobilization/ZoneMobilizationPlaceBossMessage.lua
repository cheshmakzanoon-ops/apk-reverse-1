local ZoneMobilizationPlaceBossMessage = BaseClass("ZoneMobilizationPlaceBossMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ZoneMobilizationPlaceBossMessage:OnCreate(pointId, serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("pointId", pointId)
  self.sfsObj:PutInt("serverId", serverId)
end

function ZoneMobilizationPlaceBossMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
end

return ZoneMobilizationPlaceBossMessage
