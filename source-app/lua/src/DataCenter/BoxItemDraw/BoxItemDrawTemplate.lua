local BoxItemDrawTemplate = BaseClass("BoxItemDrawTemplate")
local ActivityTorchRelayConfigTemplate = require("DataCenter/ActivityTorchRelay/ActivityTorchRelayConfigTemplate")

function BoxItemDrawTemplate:__init()
  self.id = 0
  self.group_id = 0
  self.round_range = ""
  self.reward = ""
  self.rare_show = 0
  self.reward_show = ""
end

function BoxItemDrawTemplate:__delete()
  self.id = nil
  self.group_id = nil
  self.round_range = nil
  self.reward = nil
  self.rare_show = nil
  self.reward_show = nil
end

function BoxItemDrawTemplate:InitData(row)
  self.id = tonumber(row:getValue("id")) or 0
  self.group_id = tonumber(row:getValue("group_id")) or 0
  self.round_range = row:getValue("round_range") or ""
  self.reward = row:getValue("reward") or ""
  self.rare_show = tonumber(row:getValue("rare_show")) or 0
  self.reward_show = row:getValue("reward_show") or ""
end

function BoxItemDrawTemplate:GetRoundRange()
  if not string.IsNullOrEmpty(self.round_range) then
    local str1 = string.split(self.round_range, "-")
    if #str1 == 2 then
      return tonumber(str1[1]), tonumber(str1[2])
    end
  end
  return 0, 0
end

function BoxItemDrawTemplate:GetRewards()
  local res = {}
  if not string.IsNullOrEmpty(self.reward_show) then
    local str1 = string.split(self.reward_show, "|")
    for i, v in pairs(str1) do
      local str2 = string.split(v, ";")
      if #str2 == 6 then
        local data = {
          rewardType = tonumber(str2[1]),
          itemId = tonumber(str2[2]),
          count = tonumber(str2[3]),
          limit = tonumber(str2[4]),
          weight = tonumber(str2[5]),
          bannedTime = tonumber(str2[6]),
          index = i
        }
        table.insert(res, data)
      end
    end
  end
  return res
end

function BoxItemDrawTemplate:GetRewardsById(rewardId)
  local groups = {}
  if rewardId == nil or rewardId == 0 then
    return groups
  end
  local line = LocalController:instance():getLine(TableName.RewardConfig, rewardId)
  if line == nil then
    return groups
  end
  local itemValues = line:getValue("item") or ""
  local numValues = line:getValue("num") or ""
  local MyStrNull = string.IsNullOrEmpty
  local MySplit = string.split
  local MyInsert = table.insert
  if not MyStrNull(itemValues) and not MyStrNull(numValues) then
    local ids = MySplit(itemValues, "|")
    local nums = MySplit(numValues, "|")
    if ids ~= nil and 0 < #ids then
      for i, id in pairs(ids) do
        local oneData = {}
        oneData.itemId = id
        oneData.count = nums[i] or 0
        oneData.rewardType = RewardType.GOODS
        MyInsert(groups, oneData)
      end
    end
  end
  local itemValuesRes = line:getValue("resource_randomtype") or ""
  local numValuesRes = line:getValue("resource_rate") or ""
  if not MyStrNull(itemValuesRes) and not MyStrNull(numValuesRes) then
    local idsRes = MySplit(itemValuesRes, "|")
    local numsRes = MySplit(numValuesRes, "|")
    if idsRes ~= nil and 0 < #idsRes then
      for i, id in pairs(idsRes) do
        local oneData = {}
        oneData.itemId = id
        local numss = MySplit(numsRes[i], ";")
        oneData.count = numss[1] or 0
        oneData.rewardType = RewardType.RESOURCE
        MyInsert(groups, oneData)
      end
    end
  end
  return groups
end

function BoxItemDrawTemplate:IsBigReward(index)
  return self.rare_show == index - 1
end

function BoxItemDrawTemplate:GetBigRewardShowData()
  local rewardDataList = self:GetRewards()
  for i, v in pairs(rewardDataList) do
    if v.index - 1 == self.rare_show then
      return v
    end
  end
end

function BoxItemDrawTemplate:GetProbability(index)
  local rewards = self:GetRewards()
  local total = 0
  local cur = 0
  for i, v in pairs(rewards) do
    if v.index == index then
      cur = v.weight
    end
    total = total + v.weight
  end
  if 0 < total then
    return cur / total
  end
  return 0
end

return BoxItemDrawTemplate
