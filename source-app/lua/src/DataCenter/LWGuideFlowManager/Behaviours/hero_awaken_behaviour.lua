local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
local Const = require("Scene.CityVisitor.Const")
behaviour.params = {
  {
    "number",
    "behaviourId"
  },
  {"string", "extParam"}
}

function behaviour:Begin()
  if self.behaviourId and self.behaviourId == HeroUtils.HeroAwakenGuideFlowBehaviour.Behaviour_1 then
    local heroUuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(self.extParam)
    if heroUuid then
      local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroListPanel)
      if window and window.View and window.View.ShowFingerArrowAtHeroUuid then
        window.View:ShowFingerArrowAtHeroUuid(heroUuid)
      end
    end
  end
  self.done = true
end

function behaviour:End()
end

return behaviour
