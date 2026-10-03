local AllianceBossS0BattleRecordMessage = BaseClass("AllianceBossS0BattleRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceBossS0BattleRecordMessage:OnCreate()
  base.OnCreate(self)
end

function AllianceBossS0BattleRecordMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errorCode = message.errorCode
  if errorCode ~= nil then
    UIUtil.ShowTipsId(errorCode)
    return
  end
  DataCenter.S0AllianceBossDataManager:ParseBattleRecordInfo(message)
  EventManager:GetInstance():Broadcast(EventId.OnS0AllianceBossGetRecordInfo)
end

return AllianceBossS0BattleRecordMessage
