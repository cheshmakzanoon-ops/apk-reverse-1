local TreasureChestDataManager = BaseClass("TreasureChestDataManager")
local CFG_NAME = "monopoly_treasure"

function TreasureChestDataManager:__init()
end

function TreasureChestDataManager:GetBoxRewardDatas(cfgId)
  if not cfgId then
    return
  end
  if not self.boxDatas then
    self.boxDatas = {}
  end
  if not self.boxDatas[cfgId] then
    local boxDatas = {}
    self.boxDatas[cfgId] = boxDatas
    local rewards = LocalController:instance():getValue(CFG_NAME, cfgId, "reward_id")
    local bestReward = LocalController:instance():getValue(CFG_NAME, cfgId, "mystery_reward")
    local diamondValue = LocalController:instance():getValue(CFG_NAME, cfgId, "diamond_value")
    local bestBoxIndex = 0
    local extraRewardId = 0
    if not string.IsNullOrEmpty(bestReward) then
      local indexAndTimeStrs = string.split(bestReward, "|")
      if indexAndTimeStrs[1] then
        bestBoxIndex = tonumber(indexAndTimeStrs[1])
      end
      if indexAndTimeStrs[2] then
        extraRewardId = tonumber(indexAndTimeStrs[2])
      end
    end
    local valueStrs
    if not string.IsNullOrEmpty(diamondValue) then
      valueStrs = string.split(diamondValue, "|")
    end
    if not string.IsNullOrEmpty(rewards) then
      local rewardIdStrs = string.split(rewards, "|")
      for i, rewardIdStr in ipairs(rewardIdStrs) do
        local rewardId = tonumber(rewardIdStr)
        local data = {}
        data.rewardId = rewardId
        data.IsBest = i == bestBoxIndex
        data.extraRewardId = data.IsBest and extraRewardId or 0
        data.diamondValue = 0
        if valueStrs and valueStrs[i] then
          data.diamondValue = tonumber(valueStrs[i]) or 0
        end
        boxDatas[i] = data
      end
    end
  end
  return self.boxDatas[cfgId]
end

function TreasureChestDataManager:GetTreasureChestEnterType(cfgId)
  if not cfgId then
    return 0
  end
  local type = LocalController:instance():getValue(CFG_NAME, cfgId, "type") or 0
  return tonumber(type)
end

function TreasureChestDataManager:GetSwitchTimeSequence(cfgId)
  if not cfgId then
    return
  end
  if not self.switchTimeSequences then
    self.switchTimeSequences = {}
  end
  if not self.switchTimeSequences[cfgId] then
    local sequencesGroup = {}
    self.switchTimeSequences[cfgId] = sequencesGroup
    local str = LocalController:instance():getValue(CFG_NAME, cfgId, "change_time")
    if not string.IsNullOrEmpty(str) then
      local sequenceStrs = string.split(str, ";")
      for i, sequenceStr in ipairs(sequenceStrs) do
        if not string.IsNullOrEmpty(sequenceStr) then
          local indexAndTimeStrs = string.split(sequenceStr, "|")
          local indexStrs = indexAndTimeStrs[1]
          if not string.IsNullOrEmpty(indexStrs) then
            local index = string.split(indexStrs, ",")
            if #index == 2 then
              local sequence = {}
              sequence[1] = tonumber(index[1])
              sequence[2] = tonumber(index[2])
              local switchTime = indexAndTimeStrs[2] and tonumber(indexAndTimeStrs[2]) or 0.5
              sequence[3] = tonumber(switchTime)
              table.insert(sequencesGroup, sequence)
            end
          end
        end
      end
    end
  end
  return self.switchTimeSequences[cfgId]
end

function TreasureChestDataManager:__delete()
  self.switchTimeSequences = nil
  self.boxDatas = nil
end

return TreasureChestDataManager
