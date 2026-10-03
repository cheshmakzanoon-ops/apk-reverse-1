local LWSeasonTowerDifficultyTemplate = BaseClass("LWSeasonTowerDifficultyTemplate")

function LWSeasonTowerDifficultyTemplate:__init()
  self.id = 0
  self.group = 0
  self.difficulty = 0
  self.layer = {}
  self.show = ""
  self.battle_show = ""
end

function LWSeasonTowerDifficultyTemplate:__delete()
  self.id = 0
  self.group = 0
  self.difficulty = 0
  self.layer = {}
  self.show = ""
  self.battle_show = ""
end

function LWSeasonTowerDifficultyTemplate:InitData(id)
  local rowData = LocalController:instance():getLine(TableName.SEASON_TOWER_DIFFICULTY, id)
  if not rowData then
    Logger.LogError("LWSeasonTowerDifficultyTemplate:InitData rowData is nil, id: " .. tostring(id))
    return
  end
  self.id = rowData.id or 0
  self.group = rowData.group or 0
  self.difficulty = rowData.difficulty or 0
  if string.IsNullOrEmpty(rowData.layer) then
    self.layer = {}
  else
    self.layer = string.split(rowData.layer, ";")
  end
  self.show = rowData.show or ""
  self.battle_show = rowData.battle_show or ""
end

function LWSeasonTowerDifficultyTemplate:IsInDifficulty(floor)
  if #self.layer ~= 2 then
    return false
  end
  return floor >= tonumber(self.layer[1]) and floor <= tonumber(self.layer[2])
end

function LWSeasonTowerDifficultyTemplate:GetShowFloor(floor)
  return floor - tonumber(self.layer[1]) + 1
end

function LWSeasonTowerDifficultyTemplate:GetFloorRange()
  return {
    tonumber(self.layer[1]),
    tonumber(self.layer[2])
  }
end

return LWSeasonTowerDifficultyTemplate
