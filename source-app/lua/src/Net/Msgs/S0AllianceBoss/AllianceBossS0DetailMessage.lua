local AllianceBossS0DetailMessage = BaseClass("AllianceBossS0DetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceBossS0DetailMessage:OnCreate(allianceId, serverId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("allianceId", allianceId)
  self.sfsObj:PutInt("serverId", serverId)
end

function AllianceBossS0DetailMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errorCode = message.errorCode
  if errorCode ~= nil then
    UIUtil.ShowTipsId(errorCode)
    return
  end
  DataCenter.S0AllianceBossDataManager:ParseBossDetailInfo(message)
end

return AllianceBossS0DetailMessage
