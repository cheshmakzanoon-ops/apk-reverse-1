local DispatchGetAllianceTasksMessage = BaseClass("DispatchGetAllianceTasksMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function DispatchGetAllianceTasksMessage:OnCreate()
  base.OnCreate(self)
end

function DispatchGetAllianceTasksMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif message.ls then
    DataCenter.ActDispatchTaskDataManager:UpdateAllAllianceTasks(message.ls)
  end
end

return DispatchGetAllianceTasksMessage
