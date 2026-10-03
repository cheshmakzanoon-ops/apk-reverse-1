local LWSeasonTowerStageTemplate = BaseClass("LWSeasonTowerStageTemplate")
local LWSeasonTowerDifficultyTemplate = require("DataCenter/LWSeasonTowerManager/LWSeasonTowerDifficultyTemplate")

function LWSeasonTowerStageTemplate:__init()
  self.id = 0
  self.group = 0
  self.openDay = 0
  self.armyList = {}
  self.allBuff = {}
  self.stageReward = {}
  self.all_buff_info = ""
  self.name = ""
  self.stage_difficulty = ""
  self.stageDifficulty = nil
  self.all_buff_icon = ""
  self.all_buff_info_num = ""
  self.allBuffInfoNumList = {}
end

function LWSeasonTowerStageTemplate:__delete()
  self.id = 0
  self.group = 0
  self.openDay = 0
  self.armyList = {}
  self.allBuff = {}
  self.stageReward = {}
  self.all_buff_info = ""
  self.name = ""
  self.stage_difficulty = ""
  self.stageDifficulty = nil
  self.all_buff_icon = ""
  self.all_buff_info_num = ""
  self.allBuffInfoNumList = {}
end

function LWSeasonTowerStageTemplate:InitData(stageId)
  local rowData = LocalController:instance():getLine(TableName.SEASON_TOWER_STAGE, stageId)
  if not rowData then
    Logger.LogError("LWSeasonTowerStageTemplate:InitData rowData is nil, stageId: " .. stageId)
    return
  end
  self.id = rowData.id or 0
  self.group = rowData.group or 0
  self.openDay = rowData.open_day or 0
  self.stage_difficulty = rowData.stage_difficulty or ""
  self.armyList = {}
  if not string.IsNullOrEmpty(rowData.army) then
    local armyList = string.string2array_num(rowData.army, ";", "|")
    for _, v in pairs(armyList) do
      if #v == 3 then
        table.insert(self.armyList, {
          floor = tonumber(v[1]),
          armyId = v[2],
          score = v[3]
        })
      end
    end
    table.sort(self.armyList, function(a, b)
      return a.floor < b.floor
    end)
  end
  self.allBuff = rowData.all_buff or {}
  self.stageReward = {}
  if not string.IsNullOrEmpty(rowData.stage_reward) then
    local rewards = string.string2array_num(rowData.stage_reward, ";", "|")
    for _, v in pairs(rewards) do
      if #v == 2 then
        table.insert(self.stageReward, {
          floor = tonumber(v[1]),
          rewardId = v[2]
        })
      end
    end
    table.sort(self.stageReward, function(a, b)
      return a.floor < b.floor
    end)
  end
  self.allBuffInfoNumList = {}
  if not string.IsNullOrEmpty(rowData.all_buff_info_num) then
    self.allBuffInfoNumList = string.split(rowData.all_buff_info_num, "|")
  end
  self.all_buff_info = rowData.all_buff_info or ""
  self.name = rowData.name or ""
  self.all_buff_icon = rowData.all_buff_icon or ""
end

function LWSeasonTowerStageTemplate:GetDifficulty()
  if self.stageDifficulty ~= nil then
    return self.stageDifficulty
  end
  self.stageDifficulty = {}
  if not string.IsNullOrEmpty(self.stage_difficulty) then
    local difficulties = string.split(self.stage_difficulty, ";")
    for _, v in pairs(difficulties) do
      local template = LWSeasonTowerDifficultyTemplate.New()
      template:InitData(v)
      table.insert(self.stageDifficulty, template)
    end
    table.sort(self.stageDifficulty, function(a, b)
      return a.id < b.id
    end)
  end
  return self.stageDifficulty
end

function LWSeasonTowerStageTemplate:GetMaxFloor()
  local maxFloor = 0
  for _, v in ipairs(self.armyList) do
    maxFloor = math.max(maxFloor, v.floor)
  end
  return maxFloor
end

function LWSeasonTowerStageTemplate:GetTotalScore(startFloor, endFloor)
  local fromFloor = math.floor(tonumber(startFloor) or 0)
  local toFloor = math.floor(tonumber(endFloor) or 0)
  if fromFloor >= toFloor then
    return 0
  end
  local armyList = self.armyList
  local armyCount = #armyList
  if armyCount <= 0 then
    return 0
  end
  local totalScore = 0
  local armyIndex = 1
  local currentScore = tonumber(armyList[armyIndex].score) or 0
  for floor = 1, toFloor do
    while true do
      if not (armyCount > armyIndex and floor >= (tonumber(armyList[armyIndex + 1].floor) or 0)) then
        break
      end
      armyIndex = armyIndex + 1
      currentScore = tonumber(armyList[armyIndex].score) or 0
    end
    if floor > fromFloor then
      totalScore = totalScore + currentScore
    end
  end
  return totalScore
end

return LWSeasonTowerStageTemplate
