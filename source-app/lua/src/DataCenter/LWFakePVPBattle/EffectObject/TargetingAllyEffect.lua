local base = require("DataCenter.LWFakePVPBattle.EffectObject.TargetingEffect")
local TargetingAllyEffect = BaseClass("TargetingAllyEffect", base)
local SEARCH_MAP = {
  [1] = {
    4,
    3,
    2,
    5
  },
  [2] = {
    5,
    4,
    1,
    3
  },
  [3] = {
    4,
    1,
    5,
    2
  },
  [4] = {
    3,
    5,
    1,
    2
  },
  [5] = {
    4,
    2,
    1,
    3
  },
  [6] = {
    9,
    8,
    7,
    10
  },
  [7] = {
    10,
    9,
    7,
    8
  },
  [8] = {
    9,
    10,
    7,
    8
  },
  [9] = {
    8,
    10,
    6,
    7
  },
  [10] = {
    9,
    8,
    6,
    7
  }
}

function TargetingAllyEffect.GetOppositeIdx(sceneData, allUnits, idx)
  local searchMap = SEARCH_MAP[idx]
  if not searchMap then
    return nil
  end
  for i = 1, #searchMap do
    local pos = searchMap[i]
    if allUnits[pos] then
      return pos
    end
  end
  return nil
end

return TargetingAllyEffect
