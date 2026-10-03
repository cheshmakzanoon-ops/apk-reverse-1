local RedPoint = BaseClass("SeasonPhotoTaskGroup", RedPointGroup)

function RedPoint:__init(nodeName)
  self:AddListener(EventId.SeasonPhotoTaskListUpdate, self.SeasonPhotoTaskListUpdate)
end

function RedPoint:__delete()
end

function RedPoint:SetData(activityId)
  self.activityId = tostring(activityId)
  self:SeasonPhotoTaskListUpdate(self.activityId)
end

function RedPoint:SeasonPhotoTaskListUpdate(activityId)
  if activityId and self.activityId ~= tostring(activityId) then
    return
  end
  local taskList = DataCenter.SeasonPhotoManager.taskList
  if table.IsNullOrEmpty(taskList) then
    self:Reset()
    return
  end
  for _, task in ipairs(taskList) do
    local node = self:GetOrAddChild(RedDef.SeasonPhotoTaskItem, task.taskId)
    node:SetCountBoolean(task and task.state == TaskState.CanReceive)
  end
end

return RedPoint
