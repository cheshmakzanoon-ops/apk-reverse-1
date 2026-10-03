local base = require("DataCenter.LWGuideFlowManager.Triggers.TriggerBase")
local metatbl = {__index = base}
local trigger = setmetatable({}, metatbl)
trigger.name = "dominator_train_level"
trigger.params = {"string"}

function trigger.OnTrigger(eventInfo)
  base.TryTrigger(trigger, eventInfo)
end

EventManager:GetInstance():AddListener(EventId.DominatorTrainUpgradeSuccess, trigger.OnTrigger)

function trigger.CheckParams(params, evtParam)
  if params and not string.IsNullOrEmpty(params[1]) then
    local splitStr = string.split(params[1], ";")
    if 0 < #splitStr then
      for i, v in pairs(splitStr) do
        local trainId = tonumber(v) or 0
        if 0 < trainId then
          local trainTemplate = DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(trainId)
          if trainTemplate then
            local trainGroupTemplate = trainTemplate:GetGroupTemplate()
            if trainGroupTemplate then
              local curTrainInfo = DataCenter.DominatorManager:GetTrainInfoByGroupId()
              if not curTrainInfo or curTrainInfo:GetCurLevelId() ~= trainTemplate.id then
                return false
              end
            end
          end
        end
      end
      return true
    end
  end
  return false
end

return trigger
