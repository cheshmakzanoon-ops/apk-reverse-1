local DispatchGetTasksMessage = BaseClass("DispatchGetTasksMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function DispatchGetTasksMessage:OnCreate()
  base.OnCreate(self)
end

function DispatchGetTasksMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif message then
    DataCenter.ActDispatchTaskDataManager:UpdateAllSingleTasks(message)
  end
end

return DispatchGetTasksMessage
