local RedPoint = BaseClass("SeasonLastWar", RedPointNode)

function RedPoint:__init(nodeName)
  self:AddListener(EventId.EveDecisiveBattleInfo, self.Update)
end

function RedPoint:SetData(activityId)
  self.activityId = activityId
  self:Update(activityId)
end

function RedPoint:Update()
  local hasRed = false
  local tasks = DataCenter.ActivityListDataManager:GetExtraData(EVE_DECISIVE_BATTLE_TASK)
  if tasks then
    for _, task in pairs(tasks) do
      if task and task.state == TaskState.CanReceive then
        hasRed = true
        break
      end
    end
  end
  self:SetCountBoolean(hasRed)
end

return RedPoint
