local CrossKingScheduleMessage = BaseClass("CrossKingScheduleMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CrossKingScheduleMessage:OnCreate()
  base.OnCreate(self)
end

function CrossKingScheduleMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    Logger.LogInfo(string.format("CrossKingSchedule.error (%s)", errCode))
    return
  end
  DataCenter.ZoneWarManager:SetCrossKingSchedule(t)
end

return CrossKingScheduleMessage
