local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "dominator_train_level_interval"
condition.params = {"string"}

function condition.__Check(params)
  if not string.IsNullOrEmpty(params) then
    local splitStr = string.split(params, ";")
    if 0 < #splitStr then
      for i, v in pairs(splitStr) do
        local splitStrSub = string.split(v, "-")
        if #splitStrSub == 2 then
          local minId = tonumber(splitStrSub[1]) or 0
          local maxId = tonumber(splitStrSub[2]) or 0
          local trainTemplateMin = DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(minId)
          local trainTemplateMax = DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(maxId)
          if trainTemplateMin and trainTemplateMax and trainTemplateMin.level_group == trainTemplateMax.level_group then
            local trainGroupTemplate = trainTemplateMin:GetGroupTemplate()
            if trainGroupTemplate then
              local curTrainInfo = DataCenter.DominatorManager:GetTrainInfoByGroupId(trainGroupTemplate.id)
              if curTrainInfo then
                local curLevel = curTrainInfo:GetCurLevel()
                local isInRange = curLevel >= trainTemplateMin.level_order and curLevel <= trainTemplateMax.level_order
                if not isInRange then
                  return false
                end
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

return condition
