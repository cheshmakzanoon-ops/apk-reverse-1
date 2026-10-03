local RewardTemplateManager = BaseClass("RewardTemplateManager")

function RewardTemplateManager:__init()
  self.TempDic = nil
  self:AddListener()
end

function RewardTemplateManager:__delete()
  self:RemoveListener()
end

function RewardTemplateManager:Startup()
end

function RewardTemplateManager:AddListener()
end

function RewardTemplateManager:RemoveListener()
end

function RewardTemplateManager:InitData(data)
end

function RewardTemplateManager:GetList(rewardId)
  rewardId = rewardId and tonumber(rewardId)
  if not rewardId then
    return nil
  end
  if not self.TempDic then
    self.TempDic = {}
  end
  if not self.TempDic[rewardId] then
    local line = LocalController:instance():getLine(TableName.RewardConfig, tonumber(rewardId))
    local res, index = {}, 0
    if line then
      local itemValuesRes = line:getValue("resource_item_random_type") or ""
      local numValuesRes = line:getValue("resource_item_rate") or ""
      if not string.IsNullOrEmpty(itemValuesRes) and not string.IsNullOrEmpty(numValuesRes) then
        local code = self:GetCode(itemValuesRes)
        local idsRes = string.split(itemValuesRes, code)
        local numsRes = string.split(numValuesRes, code)
        if idsRes ~= nil and 0 < #idsRes then
          for i, id in pairs(idsRes) do
            local oneData = {}
            oneData.itemId = id
            local numss = string.split(numsRes[i], ";")
            oneData.count = tonumber(numss[1]) or 0
            oneData.rewardType = RewardType.RESOURCE_ITEM
            index = index + 1
            res[index] = oneData
          end
        end
      end
      itemValuesRes = line:getValue("resource_randomtype") or ""
      numValuesRes = line:getValue("resource_rate") or ""
      if not string.IsNullOrEmpty(itemValuesRes) and not string.IsNullOrEmpty(numValuesRes) then
        local code = self:GetCode(itemValuesRes)
        local idsRes = string.split(itemValuesRes, code)
        local numsRes = string.split(numValuesRes, code)
        if idsRes ~= nil and 0 < #idsRes then
          for i, id in pairs(idsRes) do
            local oneData = {}
            oneData.itemId = id
            local numss = string.split(numsRes[i], ";")
            oneData.count = tonumber(numss[1]) or 0
            oneData.rewardType = RewardType.RESOURCE
            index = index + 1
            res[index] = oneData
          end
        end
      end
      local itemValues = line:getValue("item") or ""
      local numValues = line:getValue("num") or ""
      if not string.IsNullOrEmpty(itemValues) and not string.IsNullOrEmpty(numValues) then
        local code = self:GetCode(itemValues)
        local ids = string.split(itemValues, code)
        local nums = string.split(numValues, code)
        if ids ~= nil and 0 < #ids then
          for i, id in pairs(ids) do
            local oneData = {}
            oneData.itemId = id
            oneData.count = tonumber(nums[i]) or 0
            oneData.rewardType = RewardType.GOODS
            index = index + 1
            res[index] = oneData
          end
        end
      end
    end
    self.TempDic[rewardId] = res
  end
  return self.TempDic[rewardId]
end

function RewardTemplateManager:GetRewardByIdList(rewardIdList)
  local rewards = {}
  for i, v in ipairs(rewardIdList) do
    local list = DeepCopy(self:GetList(v))
    table.insertto(rewards, list)
  end
  rewards = DataCenter.RewardManager:CombineRewardList(rewards)
  return rewards
end

function RewardTemplateManager:GetCode(str)
  if string.IsNullOrEmpty(str) then
    return "|"
  end
  if string.find(str, "|") then
    return "|"
  end
  if string.find(str, ";") then
    return ";"
  end
  if string.find(str, ",") then
    return ","
  end
  return "|"
end

return RewardTemplateManager
