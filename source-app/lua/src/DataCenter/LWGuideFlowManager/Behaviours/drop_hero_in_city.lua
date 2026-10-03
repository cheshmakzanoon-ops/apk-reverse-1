local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"number", "heroId"},
  {
    "bool",
    "exitWhenAnimOver"
  }
}

function behaviour:__Awake()
  function self.OnDropAnimDone(heroId)
    if self.heroId == heroId then
      self.done = true
    end
  end
end

local BLOCKER_EXPIRE_TIME = 4.5

function behaviour:Begin()
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, BLOCKER_EXPIRE_TIME)
  DataCenter.BuildHeroManager:CreateBuildHero(self.heroId)
  if self.exitWhenAnimOver then
    EventManager:GetInstance():AddListener(EventId.GF_city_hero_drop_anim_done, self.OnDropAnimDone)
  else
    self.done = true
  end
end

function behaviour:End()
  UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  self.__blockerHandleID = nil
end

return behaviour
