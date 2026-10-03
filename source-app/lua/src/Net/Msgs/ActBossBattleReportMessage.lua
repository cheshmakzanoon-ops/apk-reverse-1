local ActBossBattleReportMessage = BaseClass("ActBossBattleReportMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ActBossBattleReportMessage:OnCreate()
  base.OnCreate(self)
end

function ActBossBattleReportMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActBossDataManager:HandleBossBattleReportData(message)
  end
end

return ActBossBattleReportMessage
