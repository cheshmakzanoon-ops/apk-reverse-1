local GiftPackageChangeTemplate = BaseClass("GiftPackageChangeTemplate")

function GiftPackageChangeTemplate:__init()
  self.id = 0
  self.group = 0
  self.condition = ""
  self.server = ""
  self.change_list = ""
  self.type = 0
  self.order = 0
  self.entry_text = ""
end

function GiftPackageChangeTemplate:__delete()
  self.id = nil
  self.group = nil
  self.condition = nil
  self.server = nil
  self.change_list = nil
  self.type = nil
  self.order = nil
  self.entry_text = nil
end

function GiftPackageChangeTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group = rowData:getValue("group") or 0
  self.condition = rowData:getValue("condition") or ""
  self.server = rowData:getValue("server") or ""
  self.change_list = rowData:getValue("change_list") or ""
  self.type = rowData:getValue("type") or 0
  self.order = rowData:getValue("order") or 0
  self.entry_text = rowData:getValue("entry_text") or ""
end

function GiftPackageChangeTemplate:CheckTimeCondition()
  return TimeConditionUtils.CheckTimeConditionsByStr(self.condition)
end

function GiftPackageChangeTemplate:CheckServerCondition()
  if string.IsNullOrEmpty(self.server) then
    return true
  end
  local result = true
  local conditionStrSplit = string.split(self.server, ";")
  for i, v in ipairs(conditionStrSplit) do
    local conditionStrSplit2 = string.split(v, "|")
    if #conditionStrSplit2 == 2 then
      local check = self:CheckSingleServerCondition(conditionStrSplit2[1], conditionStrSplit2[2])
      if check ~= nil and check == false then
        result = false
        break
      end
    end
  end
  return result
end

function GiftPackageChangeTemplate:GetSeason()
  if string.IsNullOrEmpty(self.condition) then
    return -1
  end
  local conditionStrSplit = string.split(self.condition, "|")
  for _, conditionStr in ipairs(conditionStrSplit) do
    local pair = string.split(conditionStr, ";")
    if #pair == 2 then
      local conditionType = tonumber(pair[1])
      if conditionType == TimeConditionType.Type_144 then
        local conditionParamSplit = string.split(pair[2], "-")
        if #conditionParamSplit == 2 then
          local startSeason = tonumber(conditionParamSplit[1])
          local endSeason = tonumber(conditionParamSplit[2])
          return startSeason
        end
      elseif conditionType == TimeConditionType.Type_149 then
        local conditionParamSplit = string.split(pair[2], ",")
        if #conditionParamSplit == 2 then
          local startSeason = tonumber(conditionParamSplit[1])
          return startSeason
        end
      end
    end
  end
  return 0
end

function GiftPackageChangeTemplate:GetDay()
  if string.IsNullOrEmpty(self.condition) then
    return -1
  end
  local conditionStrSplit = string.split(self.condition, "|")
  for _, conditionStr in ipairs(conditionStrSplit) do
    local pair = string.split(conditionStr, ";")
    if #pair == 2 then
      local conditionType = tonumber(pair[1])
      if conditionType == TimeConditionType.Type_148 then
        local conditionParamSplit = string.split(pair[2], "-")
        if #conditionParamSplit == 2 then
          local startSeasonDay = tonumber(conditionParamSplit[1])
          return startSeasonDay
        end
      elseif conditionType == TimeConditionType.Type_8 then
        local startOpenServerDay = tonumber(pair[2])
        return startOpenServerDay
      elseif conditionType == TimeConditionType.Type_149 then
        local conditionParamSplit = string.split(pair[2], ",")
        if #conditionParamSplit == 2 then
          local startSeasonDay = tonumber(conditionParamSplit[2])
          return startSeasonDay
        end
      end
    end
  end
  return 0
end

function GiftPackageChangeTemplate:GetPreReward()
  if string.IsNullOrEmpty(self.change_list) then
    return nil
  end
  local changeListStrSplit = string.split(self.change_list, "|")
  if #changeListStrSplit == 2 then
    local pair = string.split(changeListStrSplit[1], ";")
    if #pair == 2 then
      return {
        rewardType = tonumber(pair[1]),
        itemId = tonumber(pair[2]),
        count = 1
      }
    end
  end
end

function GiftPackageChangeTemplate:GetCurReward()
  if string.IsNullOrEmpty(self.change_list) then
    return nil
  end
  local changeListStrSplit = string.split(self.change_list, "|")
  if #changeListStrSplit == 2 then
    local pair = string.split(changeListStrSplit[2], ";")
    if #pair == 2 then
      return {
        rewardType = tonumber(pair[1]),
        itemId = tonumber(pair[2]),
        count = 1
      }
    end
  end
end

function GiftPackageChangeTemplate:GetRewardShowData()
  local preReward = self:GetPreReward()
  local curReward = self:GetCurReward()
  if preReward == nil or curReward == nil then
    return nil
  end
  local preTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(preReward.itemId)
  local curTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(curReward.itemId)
  if preTemplate == nil or curTemplate == nil then
    return nil
  end
  if not preTemplate:IsSelectBox() or not curTemplate:IsSelectBox() then
    return nil
  end
  local preRewards = {}
  local preParaList = string.split(preTemplate.serverPara1, "|")
  for i, v in ipairs(preParaList) do
    local pair = string.split(v, ",")
    if #pair == 2 then
      local rewardId = pair[1]
      local count = tonumber(pair[2])
      if preRewards[rewardId] then
        preRewards[rewardId] = preRewards[rewardId] + count
      else
        preRewards[rewardId] = count
      end
    end
  end
  local result = {}
  local curParaList = string.split(curTemplate.serverPara1, "|")
  for i, v in ipairs(curParaList) do
    local pair = string.split(v, ",")
    if #pair == 2 then
      local rewardId = pair[1]
      local count = tonumber(pair[2])
      if preRewards[rewardId] then
        count = count - preRewards[rewardId]
      end
      if 0 < count then
        table.insert(result, {
          rewardType = RewardType.GOODS,
          itemId = tonumber(rewardId),
          count = count
        })
      end
    end
  end
  return result
end

function GiftPackageChangeTemplate:CheckSingleServerCondition(conditionType, conditionParam)
  if string.IsNullOrEmpty(conditionType) or string.IsNullOrEmpty(conditionParam) then
    return false
  end
  local conditionTypeNum = tonumber(conditionType)
  if conditionTypeNum == 25 then
    if CS.NetworkURLConfig.IsOnline then
      local conditionParamSplit = string.split(conditionParam, "-")
      if #conditionParamSplit == 2 then
        local startServerId = tonumber(conditionParamSplit[1])
        local endServerId = tonumber(conditionParamSplit[2])
        local myServerId = LuaEntry.Player:GetSourceServerId()
        return startServerId <= myServerId and endServerId >= myServerId
      end
    else
      return nil
    end
  elseif conditionTypeNum == 225 then
    if CS.NetworkURLConfig.IsLocal or CS.NetworkURLConfig.IsPressureTest then
      local conditionParamSplit = string.split(conditionParam, "-")
      if #conditionParamSplit == 2 then
        local startServerId = tonumber(conditionParamSplit[1])
        local endServerId = tonumber(conditionParamSplit[2])
        local myServerId = LuaEntry.Player:GetSourceServerId()
        return startServerId <= myServerId and endServerId >= myServerId
      end
    else
      return nil
    end
  end
  return false
end

return GiftPackageChangeTemplate
