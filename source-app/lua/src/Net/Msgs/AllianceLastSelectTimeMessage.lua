local AllianceLastSelectTimeMessage = BaseClass("AllianceLastSelectTimeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function AllianceLastSelectTimeMessage:OnCreate(allianceId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("allianceId", allianceId)
end

function AllianceLastSelectTimeMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.AllyDrillDataManager:RecMsgLastTimeInfo(message)
end

return AllianceLastSelectTimeMessage
