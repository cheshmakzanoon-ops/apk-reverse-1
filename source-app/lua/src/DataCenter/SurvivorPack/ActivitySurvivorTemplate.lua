local ActivitySurvivorTemplate = BaseClass("ActivitySurvivorTemplate")

function ActivitySurvivorTemplate:__init(info)
  self.id = 0
  self.bar_reward = ""
  self.list_group = ""
  self.score_item = ""
  self.rules = ""
  self:InitData(info)
end

function ActivitySurvivorTemplate:__delete()
  self.id = nil
  self.bar_reward = nil
  self.list_group = nil
  self.score_item = nil
  self.rules = nil
end

function ActivitySurvivorTemplate:InitData(lineData)
  if lineData == nil then
    return
  end
  self.id = lineData:getValue("id") or 0
  self.bar_reward = lineData:getValue("bar_reward") or ""
  self.list_group = lineData:getValue("list_group") or ""
  self.score_item = lineData:getValue("score_item") or ""
  self.rules = lineData:getValue("rules") or ""
end

return ActivitySurvivorTemplate
