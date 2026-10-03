local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
local Const = require("Scene.CityVisitor.Const")
behaviour.params = {
  {
    "number",
    "dominatorId"
  },
  {
    "number",
    "behaviourId"
  }
}

function behaviour:Begin()
  if self.dominatorId and self.behaviourId and self.dominatorId == DominatorId.Cockatrice then
    if not DataCenter.DominatorManager:IsDominatorFunctionOnByDominatorId(DominatorId.Cockatrice) then
      self.done = true
      return
    end
    if self.behaviourId == DominatorGuideBehaviourId.STEP_0 then
      if DataCenter.DominatorManager:GetInfoById(DominatorId.Cockatrice) ~= nil then
        self.done = true
        return
      end
      DataCenter.DominatorCockatriceUnlockManager:SendSetGuideProgressMessage(1)
    elseif self.behaviourId == DominatorGuideBehaviourId.STEP_1 then
      local visitorId = DataCenter.DominatorCockatriceUnlockManager:GetVisitorEventId()
      local visitorData = DataCenter.CityVisitorManager.GetVisitorByEventId(visitorId, Const.VisitorType.STAGE)
      if visitorData and visitorData.model then
        visitorData.model:OnTriggerClick()
      end
    elseif self.behaviourId == DominatorGuideBehaviourId.STEP_2 then
      if not CS.SceneManager:IsInCity() then
        SceneUtils.ChangeToCity()
      end
      DataCenter.DominatorManager:SetIsShowCityBuildingDominator(false)
    elseif self.behaviourId == DominatorGuideBehaviourId.STEP_3 then
      DataCenter.DominatorManager:SetIsShowCityBuildingDominator(true)
    elseif self.behaviourId == DominatorGuideBehaviourId.STEP_4 then
      local info = DataCenter.DominatorManager:GetInfoById(DominatorId.Cockatrice)
      if info and info:IsUnlocked() then
        local curRankShowTemplate = info:GetCurRankShowTemplate()
        if curRankShowTemplate then
          local param = {curRankShowTemplate = curRankShowTemplate}
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDominatorUpgradeBigRank, {anim = false}, param)
        end
      end
    end
  end
  self.done = true
end

function behaviour:End()
end

return behaviour
