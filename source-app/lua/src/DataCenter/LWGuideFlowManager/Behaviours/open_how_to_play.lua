local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {
    "string",
    "HowToPlayCfgIds"
  }
}

function behaviour:__Awake()
end

function behaviour:Begin()
  if self.HowToPlayCfgIds then
    local list = string.string2array_i_oneSep(self.HowToPlayCfgIds, ";")
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {howToPlayList = list})
  end
  self.done = true
end

return behaviour
