local ActivityRewardChangeTemplate = BaseClass("ActivityRewardChangeTemplate")

function ActivityRewardChangeTemplate:__init()
  self.id = 0
  self.type = 0
  self.group = 0
  self.show_condition1 = ""
  self.show_condition2 = ""
  self.show_condition3 = ""
  self.change_type = 0
  self.type_para1 = ""
  self.type_para2 = ""
  self.config1 = 0
end

function ActivityRewardChangeTemplate:__delete()
  self.id = nil
  self.type = nil
  self.group = nil
  self.show_condition1 = nil
  self.show_condition2 = nil
  self.show_condition3 = nil
  self.change_type = nil
  self.type_para1 = nil
  self.type_para2 = nil
  self.config1 = nil
end

function ActivityRewardChangeTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.type = rowData:getValue("type") or 0
  self.group = rowData:getValue("group") or 0
  self.show_condition1 = rowData:getValue("show_condition1") or ""
  self.show_condition2 = rowData:getValue("show_condition2") or ""
  self.show_condition3 = rowData:getValue("show_condition3") or ""
  self.change_type = rowData:getValue("change_type") or 0
  self.type_para1 = rowData:getValue("type_para1") or ""
  self.type_para2 = rowData:getValue("type_para2") or ""
  self.config1 = rowData:getValue("config1") or 0
end

function ActivityRewardChangeTemplate:IsShowActivity(activityInfo)
  if not string.IsNullOrEmpty(self.show_condition3) then
    return self:__IsShowActivity_Condition3()
  end
  if self:__IsShowActivity_Condition1(activityInfo) then
    return true
  end
  if self:__IsShowActivity_Condition2(activityInfo) then
    return true
  end
  return false
end

function ActivityRewardChangeTemplate:__IsShowActivity_Condition1(activityInfo)
  if string.IsNullOrEmpty(self.show_condition1) then
    return false
  end
  if activityInfo.timeType == ActivityTimeType.TimeType_120 then
    local curRound = UIActivityCenterCommonUtil.GetActivityOpenRoundTimeType120(activityInfo)
    if 0 < curRound then
      return curRound == checknumber(self.show_condition1)
    end
  elseif activityInfo.timeType == ActivityTimeType.TimeType_200 then
    local curRound = UIActivityCenterCommonUtil.GetActivityOpenRoundTimeType200(activityInfo)
    if 0 < curRound then
      return curRound == checknumber(self.show_condition1)
    end
  end
  return false
end

function ActivityRewardChangeTemplate:__IsShowActivity_Condition2(activityInfo)
  if string.IsNullOrEmpty(self.show_condition2) then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local conditionPareStrList = string.split(self.show_condition2, "|")
  if #conditionPareStrList == 2 then
    local startConditionStrList = string.split(conditionPareStrList[1], "-")
    local endConditionStrList = string.split(conditionPareStrList[2], "-")
    if #startConditionStrList == 6 and #endConditionStrList == 6 then
      local startConditionTime = SafeLocalOsTime({
        year = tonumber(startConditionStrList[1]),
        month = tonumber(startConditionStrList[2]),
        day = tonumber(startConditionStrList[3]),
        hour = tonumber(startConditionStrList[4]),
        min = tonumber(startConditionStrList[5]),
        sec = tonumber(startConditionStrList[6])
      }) * 1000
      local endConditionTime = SafeLocalOsTime({
        year = tonumber(endConditionStrList[1]),
        month = tonumber(endConditionStrList[2]),
        day = tonumber(endConditionStrList[3]),
        hour = tonumber(endConditionStrList[4]),
        min = tonumber(endConditionStrList[5]),
        sec = tonumber(endConditionStrList[6])
      }) * 1000
      if curTime >= startConditionTime and curTime < endConditionTime then
        local activityStartTime = activityInfo:GetShowStartTime()
        if not UITimeManager:GetInstance():IsSameDayForServer(startConditionTime, activityStartTime) then
          Logger.LogError("reward change config error, not first day " .. tostring(startConditionTime) .. " " .. tostring(activityStartTime) .. " " .. tostring(self.id))
        end
        return true
      end
    end
  end
  return false
end

function ActivityRewardChangeTemplate:__IsShowActivity_Condition3()
  return TimeConditionUtils.CheckTimeConditionsByStr(self.show_condition3)
end

function ActivityRewardChangeTemplate:GetOptionalWeekCardClass()
  local strList = string.split(self.type_para1, "|")
  if #strList == 2 then
    return checknumber(strList[1])
  end
  return 0
end

function ActivityRewardChangeTemplate:GetOptionalWeekCardRewardTypeList()
  local res = {}
  local strList = string.split(self.type_para1, "|")
  if #strList == 2 then
    local strList2 = string.split(strList[2], ";")
    for i, v in ipairs(strList2) do
      table.insert(res, checknumber(v))
    end
  end
  return res
end

function ActivityRewardChangeTemplate:GetOptionalWeekCardRewardData()
  local res = {}
  local rewardTypeList = self:GetOptionalWeekCardRewardTypeList()
  local strList = string.split(self.type_para2, "|")
  if 0 < #strList then
    for i, v in ipairs(rewardTypeList) do
      table.insert(res, {
        rewardType = v,
        rewardsStr = strList[v] or strList[1]
      })
    end
  end
  return res
end

function ActivityRewardChangeTemplate:GetOptionalWeekCardRewardDataMustGet()
  local rewardData = self:GetOptionalWeekCardRewardData()
  for i, v in pairs(rewardData) do
    if v.rewardType == 1 then
      return v
    end
  end
end

function ActivityRewardChangeTemplate:GetOptionalWeekCardRewardDataSelect()
  local rewardData = self:GetOptionalWeekCardRewardData()
  for i, v in pairs(rewardData) do
    if v.rewardType == 2 then
      return v
    end
  end
end

return ActivityRewardChangeTemplate
