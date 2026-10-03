local TorchConstant = require("DataCenter/LWBattle/Logic/TorchRelayBattle/TorchRelayBattleConstant")
local TorchRelayBattleStageCheerConfigTemplate = BaseClass("TorchRelayBattleStageCheerConfigTemplate")

function TorchRelayBattleStageCheerConfigTemplate:__init()
  self.id = 0
  self.cheer_rare = 0
  self.cheer_position = ""
  self.buff_num = 0
  self.buff_group = ""
  self.rare_cheer_animation = 0
  self.rare_cheer_random = 0
end

function TorchRelayBattleStageCheerConfigTemplate:__delete()
  self.id = nil
  self.cheer_rare = nil
  self.cheer_position = nil
  self.buff_num = nil
  self.buff_group = nil
  self.rare_cheer_animation = nil
  self.rare_cheer_random = nil
end

function TorchRelayBattleStageCheerConfigTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id") or 0
  self.cheer_rare = row:getValue("cheer_rare") or 0
  self.cheer_position = row:getValue("cheer_position") or ""
  self.buff_num = row:getValue("buff_num") or 0
  self.buff_group = row:getValue("buff_group") or ""
  self.rare_cheer_animation = row:getValue("rare_cheer_animation") or 0
  self.rare_cheer_random = row:getValue("rare_cheer_random") or 0
end

function TorchRelayBattleStageCheerConfigTemplate:GetSceneData()
  local res = {}
  if not string.IsNullOrEmpty(self.cheer_position) then
    local split1 = string.split(self.cheer_position, "|")
    for _, v in pairs(split1) do
      local split2 = string.split(v, ";")
      if #split2 == 2 then
        local data = {}
        data.weight = tonumber(split2[2])
        local split3 = string.split(split2[1], "-")
        if #split3 == 2 then
          data.minIndex = tonumber(split3[1])
          data.maxIndex = tonumber(split3[2])
        end
        table.insert(res, data)
      end
    end
  end
  table.sort(res, function(a, b)
    return a.weight < b.weight
  end)
  return res
end

function TorchRelayBattleStageCheerConfigTemplate:GetRandomSceneIndex(bannedList)
  local function IsInBannedList(value)
    if table.IsNullOrEmpty(bannedList) then
      return false
    end
    for i, v in pairs(bannedList) do
      if v == value then
        return true
      end
    end
    return false
  end
  
  math.randomseed(SafeLocalOsTime())
  local sceneData = self:GetSceneData()
  local maxWeight = 0
  for i, v in pairs(sceneData) do
    if maxWeight < v.weight then
      maxWeight = v.weight
    end
  end
  if 0 < maxWeight then
    local randomMaxTime = 10000
    local randomTime = 0
    while randomMaxTime >= randomTime do
      local value = math.random(0, maxWeight)
      local data
      for i, v in ipairs(sceneData) do
        if value <= v.weight then
          data = v
        end
      end
      if data ~= nil then
        local sceneIndex = math.random(data.minIndex, data.maxIndex)
        if not IsInBannedList(sceneIndex) then
          return sceneIndex
        end
      end
      randomTime = randomTime + 1
    end
  end
  return 0
end

function TorchRelayBattleStageCheerConfigTemplate:GetRandomBuffData()
  local res = {}
  if not string.IsNullOrEmpty(self.buff_group) then
    local split1 = string.split(self.buff_group, "|")
    for i, v in pairs(split1) do
      local split2 = string.split(v, ";")
      if #split2 == 3 then
        local data = {
          id = tonumber(split2[1]),
          weight = tonumber(split2[2]),
          limit = tonumber(split2[3])
        }
        table.insert(res, data)
      end
    end
  end
  table.sort(res, function(a, b)
    return a.weight < b.weight
  end)
  return res
end

function TorchRelayBattleStageCheerConfigTemplate:GetRandomIdList()
  local randomBuffData = self:GetRandomBuffData()
  
  local function GetRandomOne()
    local totalWeight = 0
    for i, v in pairs(randomBuffData) do
      totalWeight = totalWeight + v.weight
    end
    local tmpList = {}
    if 0 < totalWeight then
      for i, v in ipairs(randomBuffData) do
        table.insert(tmpList, v.weight / totalWeight)
      end
      local number = math.random()
      for i, v in ipairs(tmpList) do
        if v > number then
          return randomBuffData[i]
        end
      end
    end
  end
  
  if not string.IsNullOrEmpty(self.buff_num) then
    local split = string.split(self.buff_num, "-")
    if #split == 2 then
      math.randomseed(SafeLocalOsTime())
      local num = math.random(tonumber(split[1]), tonumber(split[2]))
      local idList = {}
      
      local function IsValid(data)
        if data == nil then
          return false
        end
        local count = 0
        for i, v in pairs(idList) do
          if data.id == v then
            count = count + 1
          end
        end
        return count <= data.limit
      end
      
      for i = 1, num do
        local maxLoop = 999
        local index = 1
        local data
        repeat
          data = GetRandomOne()
        until maxLoop < index or IsValid(data)
        if data ~= nil then
          table.insert(idList, data.id)
        end
      end
      return idList
    end
  end
end

return TorchRelayBattleStageCheerConfigTemplate
