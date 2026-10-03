local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "count_of_done_quests"
condition.params = {"number"}

function condition.__Check(needCount)
  local count = 0
  for _, task in ipairs(DataCenter.ChapterTaskManager:GetAllChapterTask()) do
    if task.state == TaskState.CanReceive then
      count = count + 1
      if needCount <= count then
        return true
      end
    end
  end
  return false
end

return condition
