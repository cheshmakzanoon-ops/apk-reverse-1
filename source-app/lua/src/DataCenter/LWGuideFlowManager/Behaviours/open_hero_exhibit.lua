local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"number", "heroId"}
}
behaviour.optionalParams = {
  {
    "bool",
    "closeWhenClear",
    false
  }
}

function behaviour:__Awake()
end

function behaviour:Begin()
  if self.heroId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroExhibitPanel, {anim = false}, self.heroId, {
      self.heroId
    }, nil, true)
  end
  self.done = true
end

function behaviour:Clear()
  if self.closeWhenClear then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroExhibitPanel)
  end
end

return behaviour
