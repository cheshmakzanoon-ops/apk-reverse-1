local ItemUseMessage = require("Net.Msgs.ItemUseMessage")
local RewardManager = require("DataCenter.RewardManager.RewardManager")
local LwHeroTryOutTagTemplate = BaseClass("LwHeroTryOutTagTemplate")
local Localization = CS.GameEntry.Localization

function LwHeroTryOutTagTemplate:__init()
  self.id = 0
  self.order = 0
  self.hero_id = 0
  self.tag_key = ""
  self.open_time_type = ""
  self.skip_limit = ""
  self.try_out_id = {}
  self.stage_open_time = {}
  self.group_key = {}
  self.cacheAllTryOutTemplatesInGroup = nil
end

function LwHeroTryOutTagTemplate:__delete()
  self.id = nil
  self.order = nil
  self.hero_id = nil
  self.tag_key = nil
  self.open_time_type = nil
  self.skip_limit = nil
  self.try_out_id = nil
  self.stage_open_time = nil
  self.group_key = nil
  self.cacheAllTryOutTemplatesInGroup = nil
end

function LwHeroTryOutTagTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.order = rowData:getValue("order") or 0
  self.hero_id = rowData:getValue("hero_id") or 0
  self.tag_key = rowData:getValue("tag_key") or ""
  self.open_time_type = rowData:getValue("open_time_type") or ""
  self.skip_limit = rowData:getValue("skip_limit") or ""
  self.try_out_id = rowData:getValue("try_out_id") or {}
  self.stage_open_time = rowData:getValue("stage_open_time") or {}
  self.group_key = rowData:getValue("group_key") or {}
end

local function IsTimeOpen(str)
  local conditionParamSplit = string.split(str, ";")
  local startSeason = tonumber(conditionParamSplit[1])
  local startSeasonDay = tonumber(conditionParamSplit[2])
  if startSeason == 0 then
    local curOpenServerDay = UITimeManager:GetInstance():GetServerOpenDays()
    local startOpenServerDay = startSeasonDay
    return curOpenServerDay >= startOpenServerDay
  else
    local curSeason = SeasonUtil.GetSeason()
    if startSeason < curSeason then
      return true
    end
    if startSeason > curSeason then
      return false
    end
    local seasonDay = SeasonUtil.GetSeasonDay()
    return startSeasonDay <= seasonDay
  end
end

function LwHeroTryOutTagTemplate:IsTagOpen()
  if self.open_time_type == "0" or string.IsNullOrEmpty(self.open_time_type) then
    return true
  end
  local splitOpenTimeType = string.split(self.open_time_type, "|")
  if #splitOpenTimeType == 2 and tonumber(splitOpenTimeType[1]) == 1 then
    return IsTimeOpen(splitOpenTimeType[2])
  end
  return false
end

function LwHeroTryOutTagTemplate:GetAllTryOutTemplatesInGroup()
  if self.cacheAllTryOutTemplatesInGroup ~= nil then
    return self.cacheAllTryOutTemplatesInGroup
  end
  local res = {}
  local needGroup = not table.IsNullOrEmpty(self.try_out_id)
  if not needGroup then
    LocalController:instance():visitTable(TableName.LW_HERO_TRY_OUT, function(id, lineData)
      if lineData ~= nil and lineData.hero_id == self.hero_id and lineData.tag_id == self.id then
        if res[1] == nil then
          res[1] = {
            groupId = 0,
            tryOutTemplates = {},
            groupIndex = 1
          }
        end
        local template = DataCenter.HeroTryOutManager:GetLWHeroTryOutTemplateById(id)
        if template then
          table.insert(res[1].tryOutTemplates, template)
        end
      end
    end)
    if res[1] ~= nil then
      table.sort(res[1].tryOutTemplates, function(a, b)
        return a.order < b.order
      end)
    end
  else
    local groupIdList = self.try_out_id
    for index, groupId in ipairs(groupIdList) do
      table.insert(res, {
        groupId = groupId,
        tryOutTemplates = {},
        groupIndex = index
      })
    end
    LocalController:instance():visitTable(TableName.LW_HERO_TRY_OUT, function(id, lineData)
      if lineData ~= nil and lineData.hero_id == self.hero_id and lineData.tag_id == self.id then
        for _, groupData in ipairs(res) do
          if groupData.groupId == lineData.group_id then
            local template = DataCenter.HeroTryOutManager:GetLWHeroTryOutTemplateById(id)
            if template then
              table.insert(groupData.tryOutTemplates, template)
            end
            break
          end
        end
      end
    end)
    for _, groupData in ipairs(res) do
      table.sort(groupData.tryOutTemplates, function(a, b)
        return a.order < b.order
      end)
    end
  end
  self.cacheAllTryOutTemplatesInGroup = res
  return self.cacheAllTryOutTemplatesInGroup
end

function LwHeroTryOutTagTemplate:GetAllOpenTryOutTemplatesInGroup()
  local allTemplates = self:GetAllTryOutTemplatesInGroup()
  local res = {}
  for _, groupData in ipairs(allTemplates) do
    if groupData.groupId == 0 then
      table.insert(res, groupData)
    else
      local groupIndex = groupData.groupIndex
      local stageOpenTimeStr = self.stage_open_time ~= nil and self.stage_open_time[groupIndex] or nil
      if string.IsNullOrEmpty(stageOpenTimeStr) then
        table.insert(res, groupData)
      elseif IsTimeOpen(stageOpenTimeStr) then
        table.insert(res, groupData)
      end
    end
  end
  return res
end

function LwHeroTryOutTagTemplate:IsGroupTimeOpenByGroupIndex(groupIndex)
  local stageOpenTimeStr = self.stage_open_time ~= nil and self.stage_open_time[groupIndex] or nil
  if string.IsNullOrEmpty(stageOpenTimeStr) then
    return true
  else
    return IsTimeOpen(stageOpenTimeStr)
  end
end

function LwHeroTryOutTagTemplate:GetGroupTitleTextByGroupIndex(groupIndex)
  local title = Localization:GetString(self.group_key[groupIndex] or "")
  local isTimeOpen = self:IsGroupTimeOpenByGroupIndex(groupIndex)
  if isTimeOpen then
    local totalCount = 0
    local finishCount = 0
    local allTryOutTemplatesInGroup = self:GetAllTryOutTemplatesInGroup()
    if not table.IsNullOrEmpty(allTryOutTemplatesInGroup) then
      for _, groupData in ipairs(allTryOutTemplatesInGroup) do
        if groupData.groupIndex == groupIndex then
          totalCount = #groupData.tryOutTemplates
          finishCount = 0
          for _, tryOutTemplate in ipairs(groupData.tryOutTemplates) do
            if tryOutTemplate:IsFinished() then
              finishCount = finishCount + 1
            end
          end
        end
      end
    end
    return title .. finishCount .. "/" .. totalCount
  else
    local stageOpenTimeStr = self.stage_open_time ~= nil and self.stage_open_time[groupIndex] or nil
    if not string.IsNullOrEmpty(stageOpenTimeStr) then
      local conditionParamSplit = string.split(stageOpenTimeStr, ";")
      local startSeason = tonumber(conditionParamSplit[1])
      local startSeasonDay = tonumber(conditionParamSplit[2])
      if startSeason == 0 then
        local startOpenServerDay = startSeasonDay
        local openServerDayZeroTimeMS = UITimeManager:GetInstance():GetTodayZeroServerTime(LuaEntry.Player.openServerTime / 1000) * 1000
        local startOpenServerTimeMS = openServerDayZeroTimeMS + (startOpenServerDay - 1) * 24 * 3600 * 1000
        local timeNow = UITimeManager:GetInstance():GetServerTime()
        local leftTime = startOpenServerTimeMS - timeNow
        local leftTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(math.max(leftTime, 0))
        local localizationStr = Localization:GetString("hero_try_out_desc_7", leftTimeStr)
        return title .. localizationStr
      else
        local curSeason = SeasonUtil.GetSeason()
        if curSeason ~= startSeason then
          return title
        else
          local theSeasonStartTime = DataCenter.SeasonDataManager:GetSeasonStartTime()
          local seasonStartDayZeroTimeMS = UITimeManager:GetInstance():GetTodayZeroServerTime(theSeasonStartTime / 1000) * 1000
          local startSeasonDayZeroTimeMS = seasonStartDayZeroTimeMS + (startSeasonDay - 1) * 24 * 3600 * 1000
          local timeNow = UITimeManager:GetInstance():GetServerTime()
          local leftTime = startSeasonDayZeroTimeMS - timeNow
          local leftTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(math.max(leftTime, 0))
          local localizationStr = Localization:GetString("hero_try_out_desc_7", leftTimeStr)
          return title .. localizationStr
        end
      end
    end
  end
  return title
end

function LwHeroTryOutTagTemplate:IsSkipConditionOK()
  if string.IsNullOrEmpty(self.skip_limit) then
    return true
  end
  local conditionParamSplit = string.split(self.skip_limit, "|")
  if #conditionParamSplit == 2 then
    local openTimeStr = conditionParamSplit[1]
    local isOpenTime = IsTimeOpen(openTimeStr)
    if not isOpenTime then
      return false
    end
    local commonBuyConditions = DataCenter.RewardManager:ParseBuyConditionStr(conditionParamSplit[2])
    local inconsistentConditions = DataCenter.RewardManager:GetInconsistentBuyConditions(commonBuyConditions)
    if not table.IsNullOrEmpty(inconsistentConditions) then
      return false
    end
    return true
  end
  return false
end

function LwHeroTryOutTagTemplate:IsFinishedAll()
  local allTryOutTemplatesInGroup = self:GetAllTryOutTemplatesInGroup()
  if table.IsNullOrEmpty(allTryOutTemplatesInGroup) then
    return true
  end
  local isAnyOneNotFinished = false
  for _, groupData in ipairs(allTryOutTemplatesInGroup) do
    for _, tryOutTemplate in ipairs(groupData.tryOutTemplates) do
      if not tryOutTemplate:IsFinished() then
        isAnyOneNotFinished = true
        break
      end
    end
  end
  return not isAnyOneNotFinished
end

function LwHeroTryOutTagTemplate:IsCanSkip()
  if not self:IsSkipConditionOK() then
    return false
  end
  return not self:IsFinishedAll()
end

function LwHeroTryOutTagTemplate:IsHasShownTag()
  local key = "hero_try_out_new_tag_" .. tostring(self.id)
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, false)
end

function LwHeroTryOutTagTemplate:SetHasShownTag()
  local key = "hero_try_out_new_tag_" .. tostring(self.id)
  CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, true)
end

function LwHeroTryOutTagTemplate:IsShowNewRed()
  return self:IsTagOpen() and not self:IsFinishedAll() and not self:IsHasShownTag()
end

return LwHeroTryOutTagTemplate
