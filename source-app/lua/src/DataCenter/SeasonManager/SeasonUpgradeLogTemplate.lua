local SeasonUpgradeLogTemplate = BaseClass("SeasonUpgradeLogTemplate")

function SeasonUpgradeLogTemplate:__init(season, row)
  self.season = season
  local args = string.split(row.update_time, "|")
  self.year = toInt(args[1] or 0)
  self.month = toInt(args[2] or 0)
  self.day = toInt(args[3] or 0)
  self.sort = self.day + self.month * 100 + self.year * 100 * 100
  self.dateString = string.format("%s-%s-%s", self.year, self.month, self.day)
  self.update_description = row.update_description
end

return SeasonUpgradeLogTemplate
