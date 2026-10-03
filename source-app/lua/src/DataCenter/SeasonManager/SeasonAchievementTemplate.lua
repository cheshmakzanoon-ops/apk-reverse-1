local SeasonAchievementTemplate = BaseClass("SeasonAchievementTemplate")

function SeasonAchievementTemplate:__init(info)
  self.id = info.id
  self.group = info.group
  self.flag = info.flag
  self.order = toInt(self.id)
  self.title = info.title
  self.icon = info.icon
  self.value = info.value
  self.description = info.description
  self.bg = info.bg
  self.tab_title = info.tab_title
end

function SeasonAchievementTemplate:__delete(self)
  self.id = nil
  self.group = nil
  self.flag = nil
  self.order = nil
  self.title = nil
  self.icon = nil
  self.value = nil
  self.description = nil
  self.bg = nil
  self.tab_title = nil
end

return SeasonAchievementTemplate
