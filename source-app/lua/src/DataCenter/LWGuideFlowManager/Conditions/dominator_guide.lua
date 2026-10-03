local base = require("DataCenter.LWGuideFlowManager.Conditions.ConditionBase")
local metatbl = {__index = base}
local condition = setmetatable({}, metatbl)
condition.name = "dominator_guide"
condition.params = {"number", "number"}

function condition.__Check(dominatorId, conditionId)
  if DataCenter.DominatorManager:IsDominatorFunctionOn() then
    if dominatorId == DominatorId.Gorilla then
      if conditionId == DominatorGuideConditionId.STEP_0 then
        if not DataCenter.DominatorGuideManager:HasStartGorillaGuide() then
          local detectInfoList1 = DataCenter.RadarCenterDataManager:GetDetectEventsInfoByEventId(DataCenter.DominatorGuideManager:GetSmallGorillaDetectEventId())
          if table.IsNullOrEmpty(detectInfoList1) then
            local detectInfoList2 = DataCenter.RadarCenterDataManager:GetDetectEventsInfoByEventId(DataCenter.DominatorGuideManager:GetBigGorillaDetectEventId())
            if table.IsNullOrEmpty(detectInfoList2) then
              return not DataCenter.BuildManager:HasBuilding(BuildingTypes.LW_BUILD_DOMINATOR_MAIN)
            end
          end
        end
        return false
      elseif conditionId == DominatorGuideConditionId.STEP_1 then
        if DataCenter.DominatorGuideManager:IsBigGorillaDetectEventClaimed() then
          return not DataCenter.BuildManager:HasBuilding(BuildingTypes.LW_BUILD_DOMINATOR_MAIN)
        end
        return false
      elseif conditionId == DominatorGuideConditionId.STEP_2 then
        local dominatorInfo = DataCenter.DominatorManager:GetInfoById(DominatorId.Gorilla)
        if dominatorInfo and dominatorInfo:IsFinishTreatment() then
          return true
        end
        return false
      elseif conditionId == DominatorGuideConditionId.STEP_3 then
        local dominatorInfo = DataCenter.DominatorManager:GetInfoById(dominatorId)
        if dominatorInfo and dominatorInfo:GetCurState() == dominatorInfo.State.March then
          return true
        end
        return false
      elseif conditionId == DominatorGuideConditionId.STEP_4 then
        if DataCenter.DomintorStageManager:IsUnlock() then
          return true
        end
        return false
      end
    elseif dominatorId == DominatorId.Cockatrice then
      if not DataCenter.DominatorManager:IsDominatorFunctionOnByDominatorId(DominatorId.Cockatrice) then
        return false
      end
      if conditionId == DominatorGuideConditionId.STEP_0 then
        local dominatorInfo = DataCenter.DominatorManager:GetInfoById(dominatorId)
        if dominatorInfo == nil then
          return true
        end
      elseif conditionId == DominatorGuideConditionId.STEP_1 then
        return true
      end
    end
  end
  return false
end

return condition
