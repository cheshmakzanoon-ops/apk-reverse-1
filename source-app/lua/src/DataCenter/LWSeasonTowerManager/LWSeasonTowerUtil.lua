local LWSeasonTowerUtil = {}

function LWSeasonTowerUtil.GetDifficulty(stageId, floor)
  floor = math.max(1, floor)
  local stageData = DataCenter.LWSeasonTowerManager:GetStageDataById(stageId)
  if stageData == nil then
    return
  end
  local template = stageData:GetTemplate()
  local difficulties = template:GetDifficulty()
  for _, v in ipairs(difficulties) do
    if v:IsInDifficulty(floor) then
      return v
    end
  end
end

function LWSeasonTowerUtil.GetStrengthInfoByFloor(stageId, floor)
  if floor == 0 then
    return {strength = 1, floor = 1}
  end
  local difficultyTemplate = LWSeasonTowerUtil.GetDifficulty(stageId, floor)
  if difficultyTemplate == nil then
    return {strength = 1, floor = 1}
  end
  return {
    strength = difficultyTemplate.difficulty,
    floor = difficultyTemplate:GetShowFloor(floor)
  }
end

local LEVEL_3_Floor = 100
local LEVEL_2_Floor = 10
local LEVEL_1_Floor = 1
local StepToLevel = {
  [LEVEL_3_Floor] = 3,
  [LEVEL_2_Floor] = 2,
  [LEVEL_1_Floor] = 1
}

local function GetLeftFloorMoveStep(allMoveFloor)
  local step = LEVEL_1_Floor
  if allMoveFloor >= LEVEL_3_Floor then
    step = LEVEL_3_Floor
  elseif allMoveFloor >= LEVEL_2_Floor then
    step = LEVEL_2_Floor
  end
  return step
end

local function GetEffectShowListForLeftFloor(num)
  local stageData = DataCenter.LWSeasonTowerManager:GetCurSelectStageData()
  if stageData == nil then
    return
  end
  local difficultyTemplate = LWSeasonTowerUtil.GetDifficulty(stageData.stageId, stageData.floor)
  if difficultyTemplate == nil then
    return {}, num, {}
  end
  local range = difficultyTemplate:GetFloorRange()
  local diff = range[2] - stageData.floor
  if diff == 0 then
    return {}, num, {}
  end
  if num <= diff then
    return {}, num, {}
  end
  local step = GetLeftFloorMoveStep(num)
  local result = {}
  local resultFloors = {}
  local level = 0
  if step == LEVEL_1_Floor then
    level = num
  else
    level = math.floor(diff / (step + 1)) + 1
  end
  local left = diff
  for i = 1, level do
    table.insert(result, StepToLevel[step])
    if step <= left then
      left = left - step
      table.insert(resultFloors, step)
    else
      table.insert(resultFloors, left)
    end
  end
  return result, math.max(0, num - diff), resultFloors
end

function LWSeasonTowerUtil.GetEffectShowListByNum(num)
  local result, resultFloors
  result, num, resultFloors = GetEffectShowListForLeftFloor(num)
  if num <= 0 then
    return result, resultFloors
  end
  local level3 = math.floor(num / LEVEL_3_Floor)
  local level2 = math.floor(num % LEVEL_3_Floor / LEVEL_2_Floor)
  local level1 = num % LEVEL_2_Floor
  for i = 1, level3 do
    table.insert(result, 3)
    table.insert(resultFloors, LEVEL_3_Floor)
  end
  for i = 1, level2 do
    table.insert(result, 2)
    table.insert(resultFloors, LEVEL_2_Floor)
  end
  for i = 1, level1 do
    table.insert(result, 1)
    table.insert(resultFloors, LEVEL_1_Floor)
  end
  return result, resultFloors
end

return LWSeasonTowerUtil
