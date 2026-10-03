local RedPoint = BaseClass("SeasonSnowStormComing", RedPointNode)

function RedPoint:__init(nodeName)
  self:AddListener(EventId.SnowStormTaskSuccessReward, self.Update)
  self:AddListener(EventId.SeasonSnowStormActivityDataUpdate, self.Update)
  self:AddListener(EventId.SeasonSnowStormActivityTargetRewardGetSuccess, self.Update)
  self:AddListener(EventId.SeasonSnowStormActivityMainBuildTempUpdate, self.Update)
  self:AddListener(EventId.SeasonSnowStormActivityAllianceMemTempUpdate, self.Update)
  self:AddListener(EventId.SeasonSnowStormStart, self.Update)
  self:AddListener(EventId.SeasonSnowStormEnd, self.Update)
  self:AddListener(EventId.MainTaskUpdate, self.Update)
  self:AddListener(EventId.SeasonMainViewOpen, self.Update)
end

function RedPoint:SetData(activityId)
  self.activityId = activityId
  self:Update(activityId)
end

function RedPoint:Update()
  local flag = false
  local state = DataCenter.SeasonSnowStormDataManager:GetActivityStateData()
  if state ~= ActivitySnowStormState.SnowStorm then
    local curActivity = DataCenter.SeasonSnowStormDataManager.curActivity
    if curActivity then
      local configId = curActivity.cfgId
      local eventConfig = LocalController:instance():getLine(TableName.StormEvent, configId)
      if eventConfig then
        for index, value in ipairs(eventConfig.quest) do
          local taskData = DataCenter.TaskManager:FindTaskInfo(value)
          if taskData and taskData.state == TaskState.CanReceive then
            flag = true
            break
          end
        end
      end
    end
  end
  self:SetCountBoolean(flag)
end

return RedPoint
