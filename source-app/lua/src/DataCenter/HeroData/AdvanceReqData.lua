local AdvanceReqData = DataClass("AdvanceReqData")

local function __init(self, configQuality)
  local advanceConfig = HeroAdvanceController:GetInstance():GetAdvanceConfigByQuality(configQuality)
  local consume1Str = advanceConfig and advanceConfig.consume1 or ""
  local consume2Str = advanceConfig and advanceConfig.consume2 or ""
  self.conditions = {}
  
  local function addCondition(consumeStr, type)
    if string.IsNullOrEmpty(consumeStr) then
      return
    end
    local vec = string.split(consumeStr, ";")
    if vec ~= nil and table.count(vec) == 2 then
      local quality = tonumber(vec[1])
      local num = tonumber(vec[2])
      local condition = {}
      condition.requireType = type
      condition.requireQuality = quality
      condition.requireNum = num
      table.insert(self.conditions, condition)
    end
  end
  
  addCondition(consume1Str, HeroAdvanceConsumeType.ConsumeType_Same_Hero)
  addCondition(consume2Str, HeroAdvanceConsumeType.ConsumeType_Same_Camp)
end

local function __delete(self)
  self.conditions = nil
end

local function GetConditionByType(self, type)
  for _, v in ipairs(self.conditions) do
    if v.requireType == type then
      return v.requireQuality, v.requireNum
    end
  end
  return nil, nil
end

local function GetTotalNeedNum(self)
  local result = 0
  table.walk(self.conditions, function(_, v)
    result = result + v.requireNum
  end)
  return result
end

AdvanceReqData.__init = __init
AdvanceReqData.__delete = __delete
AdvanceReqData.GetConditionByType = GetConditionByType
AdvanceReqData.GetTotalNeedNum = GetTotalNeedNum
return AdvanceReqData
