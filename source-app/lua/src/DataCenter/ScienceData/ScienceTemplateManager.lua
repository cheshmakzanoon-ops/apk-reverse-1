local ScienceTemplateManager = BaseClass("ScienceTemplateManager")
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.scienceTemplateDic = {}
  self.scienceTabTemplateDic = {}
  self.lineTab = {}
  self.lineTabCount = 0
  
  function self.FuncOnPassDay()
    self.scienceTemplateDic = {}
    self.scienceTabTemplateDic = {}
    self.lineTab = {}
    self.lineTabCount = 0
    self:InitAllTemplate()
  end
  
  EventManager:GetInstance():AddListener(EventId.OnPassDay, self.FuncOnPassDay)
end

local function __delete(self)
  self.scienceTemplateDic = nil
  self.scienceTabTemplateDic = nil
  self.lineTab = nil
  if self.delayInitTimer then
    self.delayInitTimer:Stop()
    self.delayInitTimer = nil
  end
  EventManager:GetInstance():RemoveListener(EventId.OnPassDay, self.FuncOnPassDay)
end

local function DelayInitAllTemplate(self)
  self.delayInitTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:InitAllTemplate()
  end, 5)
end

local function InitAllTemplate(self)
  self:TryInitAllTab()
end

local function GetScienceTemplate(self, id, lv)
  if lv == nil or lv <= 0 then
    lv = 1
  end
  local index = CommonUtil.GetScienceBaseType(tonumber(id)) + lv
  if self.scienceTemplateDic[index] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.ScienceNew, index)
    if oneTemplate ~= nil then
      local item = ScienceTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.scienceTemplateDic[item.id] = item
      end
    end
  end
  return self.scienceTemplateDic[index]
end

local function GetScienceTemplateById(self, id)
  local level = id % ScienceLevelCap
  local baseId = id - level
  return self:GetScienceTemplate(baseId, level)
end

local function GetScienceTabTemplate(self, id)
  self:TryInitAllTab()
  if self.scienceTabTemplateDic[id] == nil then
    local oneTemplate = LocalController:instance():getLine(TableName.APSScienceTab, id)
    if oneTemplate ~= nil then
      local item = ScienceTabTemplate.New()
      item:InitData(oneTemplate)
      if item.id ~= nil then
        self.scienceTabTemplateDic[item.id] = item
      end
    end
  end
  return self.scienceTabTemplateDic[id]
end

local function GetCurShowTab(self, scienceType, noSort)
  self:TryInitAllTab()
  local result = {}
  local mainLv = DataCenter.BuildManager.MainLv
  for k, v in pairs(self.scienceTabTemplateDic) do
    if v.type == scienceType then
      if v.unlockConditionType == 1 then
        if DataCenter.ActivityListDataManager:CheckIfAlCompeteActivityOpen() then
          table.insert(result, v)
        end
      else
        table.insert(result, v)
      end
    end
  end
  if not noSort then
    table.sort(result, function(a, b)
      if a.order ~= b.order then
        return a.order < b.order
      else
        return a.id < b.id
      end
    end)
  end
  if self.lineTabCount == 0 then
    self:InitTabLine()
  end
  return result
end

local function TryInitAllTab(self)
  if self.scienceTabTemplateDic and table.count(self.scienceTabTemplateDic) > 0 then
    return
  end
  LocalController:instance():visitTable(TableName.APSScienceTab, function(id, lineData)
    local item = ScienceTabTemplate.New()
    item:InitData(lineData)
    if self.scienceTabTemplateDic[item.id] == nil then
      self.scienceTabTemplateDic[item.id] = item
    end
  end)
end

local greenColorStr = "#5FEF87"
local whiteColorStr = "#FFFFFF"

local function GetTabState(self, id)
  local status = self:GetScienceTabSetting(id)
  if status == ScienceTabState.UnLock then
    return ScienceTabState.UnLock
  else
    local template = self:GetScienceTabTemplate(id)
    if template ~= nil then
      local highestBuildingLevel = DataCenter.ScienceManager:GetHighestScienceBuildingLevel()
      local hasPercentCondition = false
      hasPercentCondition = template.unlockCondition ~= nil
      local unlockState = true
      local lockedTip = ""
      unlockState = highestBuildingLevel >= template.unlock_level
      lockedTip = string.format("<color=%s>%s</color>", highestBuildingLevel >= template.unlock_level and greenColorStr or whiteColorStr, Localization:GetString("200519", template.unlock_level))
      if hasPercentCondition then
        local minPercentId, minPercent
        local curTotalPercent = 0
        local unlockConditionIdList = template.unlockCondition.idList
        local needPercent = template.unlockCondition.totalPercent
        for i, id in ipairs(unlockConditionIdList) do
          local percent = self:GetScienceTabPro(id)
          if not minPercent or minPercent > percent then
            minPercent = percent
            minPercentId = id
          end
          curTotalPercent = curTotalPercent + percent * 100
        end
        local tempUnlock = needPercent <= curTotalPercent
        if not tempUnlock then
          unlockState = false
        end
        local tabTemplate = self:GetScienceTabTemplate(minPercentId)
        if tabTemplate then
          local tip
          if not string.IsNullOrEmpty(template.unlock_dialog) then
            tip = Localization:GetString(template.unlock_dialog, needPercent)
          else
            tip = Localization:GetString("tech_research002", Localization:GetString(tabTemplate.name), needPercent)
          end
          if string.IsNullOrEmpty(lockedTip) then
            lockedTip = string.format("<color=%s>%s</color>", tempUnlock and greenColorStr or whiteColorStr, tip)
          else
            lockedTip = string.format([[
%s
<color=%s>%s</color>]], lockedTip, tempUnlock and greenColorStr or whiteColorStr, tip)
          end
        end
      end
      if template.unlock_effect_id and #template.unlock_effect_id == 2 and unlockState then
        local targetId = template.unlock_effect_id[1]
        local targetVal = template.unlock_effect_id[2]
        local effectVal = LuaEntry.Effect:GetGameEffect(targetId)
        if targetVal > effectVal then
          unlockState = false
          local nameStr = GetTableData(TableName.LW_Effect_Number, targetId, "name")
          lockedTip = Localization:GetString("science_effect_condition_tips", Localization:GetString(nameStr), targetVal)
        end
      end
      if template.unlock_open_time and #template.unlock_open_time == 2 and unlockState then
        local targetId = template.unlock_open_time[1]
        local targetDayNum = template.unlock_open_time[2]
        local seasonId = DataCenter.SeasonDataManager:GetSeason()
        local seasonStartTime = DataCenter.SeasonDataManager:GetSeasonStartTime()
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if seasonId == 0 then
          seasonStartTime = LuaEntry.Player.openServerTime
        end
        if targetId > seasonId or seasonId == targetId and curTime < seasonStartTime + (targetDayNum - 1) * 24 * 60 * 60 * 1000 then
          unlockState = false
          lockedTip = Localization:GetString("science_time_condition_tips", targetId, targetDayNum)
        end
      end
      if unlockState then
        if id == month_card_science_tab_id then
          if DataCenter.MonthCardNewManager:CheckIfMonthCardActive() then
            return ScienceTabState.UnLock
          else
            local tip = Localization:GetString("tech_research004")
            if string.IsNullOrEmpty(lockedTip) then
              lockedTip = string.format("<color=%s>%s</color>", whiteColorStr, tip)
            else
              lockedTip = string.format([[
%s
<color=%s>%s</color>]], lockedTip, whiteColorStr, tip)
            end
          end
        else
          return ScienceTabState.UnLock
        end
      end
      local pro = self:GetScienceTabPro(id)
      if 0 < pro then
        return ScienceTabState.UnLock
      end
      local lock_see = template.show_progress
      local show_level = template.show_level
      if not string.IsNullOrEmpty(lock_see) then
        local arrSee = string.split(lock_see, ";")
        if #arrSee == 2 then
          local tempId = tonumber(arrSee[1])
          local needPercent = tonumber(arrSee[2])
          local tempPro = self:GetScienceTabPro(tempId)
          if needPercent > tempPro * 100 then
            return ScienceTabState.Lock, lockedTip
          end
        end
      end
      if not string.IsNullOrEmpty(show_level) then
        local showNum = tonumber(show_level)
        if highestBuildingLevel < showNum then
          return ScienceTabState.Lock, lockedTip
        end
      end
      if template.show_effect_id and #template.show_effect_id == 2 then
        local targetId = template.show_effect_id[1]
        local targetVal = template.show_effect_id[2]
        local effectVal = LuaEntry.Effect:GetGameEffect(targetId)
        if targetVal > effectVal then
          return ScienceTabState.Lock, lockedTip
        end
      end
      if template.show_open_time and #template.show_open_time == 2 then
        local targetId = template.show_open_time[1]
        local targetDayNum = template.show_open_time[2]
        local seasonId = DataCenter.SeasonDataManager:GetSeason()
        local seasonStartTime = DataCenter.SeasonDataManager:GetSeasonStartTime()
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if seasonId == 0 then
          seasonStartTime = LuaEntry.Player.openServerTime
        end
        if targetId > seasonId or seasonId == targetId and curTime < seasonStartTime + (targetDayNum - 1) * 24 * 60 * 60 * 1000 then
          return ScienceTabState.Lock, lockedTip
        end
      end
      return ScienceTabState.LockShow, lockedTip
    end
  end
  return ScienceTabState.Lock
end

local function GetScienceTabSetting(self, id)
  return Setting:GetInt(LuaEntry.Player.uid .. SettingKeys.SCIENCE_TAB_UNLOCK .. id, ScienceTabState.Lock)
end

local function SetScienceTabSetting(self, id)
  return Setting:SetInt(LuaEntry.Player.uid .. SettingKeys.SCIENCE_TAB_UNLOCK .. id, ScienceTabState.UnLock)
end

local function GetScienceTabPro(self, id)
  if DataCenter.ScienceDataManager:IsScienceTabProgressOptimizeFunctionOn() then
    return DataCenter.ScienceDataManager:GetScienceTabProgress(id)
  else
    local result = 0
    local list = self:GetLineListByTab(id)
    if list ~= nil then
      local total = 0
      local now = 0
      for k, v in pairs(list) do
        for k1, v1 in pairs(v) do
          local level = DataCenter.ScienceManager:GetScienceLevel(v1)
          now = now + level
          local scienceTemplate = self:GetScienceTemplate(v1, 1)
          if scienceTemplate ~= nil then
            total = total + scienceTemplate.max_level
          end
        end
      end
      if 0 < total then
        result = now / total
      end
      if 0 < result and result < 0.01 then
        result = math.ceil(result * 100) / 100
      elseif 0.99 < result then
        result = math.floor(result * 100) / 100
      else
        result = math.floor(result * 100 + 0.5) / 100
      end
    end
    return result
  end
end

function ScienceTemplateManager:GetScienceTabProIntValue(id)
  local value = self:GetScienceTabPro(id)
  return Mathf.Round(value * 100)
end

local function InitTabLine(self)
  LocalController:instance():visitTable(TableName.ScienceNew, function(id, row)
    local tid = row:getValue("id")
    local tab = row:getValue("tab")
    if self.lineTab[tab] == nil then
      self.lineTab[tab] = {}
      self.lineTabCount = 0
    end
    local position = row:getValue("position")
    if position ~= nil and position ~= "" then
      local spl = string.split_ii_array(position, ";")
      if table.count(spl) > 1 then
        local positionX = spl[1]
        local positionY = spl[2]
        if 0 < positionX and 0 < positionY then
          local time_condition = row:getValue("time_condition")
          if not string.IsNullOrEmpty(time_condition) then
            local spl = string.split(time_condition, ";")
            if table.count(spl) == 2 then
              local condition = {
                tonumber(spl[1]),
                tonumber(spl[2])
              }
              local seasonNum = SeasonUtil.GetSeason()
              if seasonNum < condition[1] then
                return
              end
              if seasonNum == condition[1] and condition[2] > SeasonUtil.GetSeasonDay() then
                return
              end
            end
          end
          local science_id = row:getValue("science_id")
          if science_id and science_id == DataCenter.AllyDuelScoreGachaManager.unlockScienceId then
            local gachaSwitch = LuaEntry.DataConfig:CheckSwitch("alliance_duel_zhuanpan")
            if not gachaSwitch then
              return
            end
          end
          local scienceId = CommonUtil.GetScienceBaseType(tid)
          if self.lineTab[tab][positionX] == nil then
            self.lineTab[tab][positionX] = {}
          end
          self.lineTab[tab][positionX][positionY] = scienceId
        end
      end
    end
  end)
  self.lineTabCount = table.count(self.lineTab)
end

local function GetLineListByTab(self, tab)
  if self.lineTabCount == 0 then
    self:InitTabLine()
  end
  return self.lineTab[tab]
end

ScienceTemplateManager.__init = __init
ScienceTemplateManager.__delete = __delete
ScienceTemplateManager.GetScienceTemplate = GetScienceTemplate
ScienceTemplateManager.GetScienceTemplateById = GetScienceTemplateById
ScienceTemplateManager.GetScienceTabTemplate = GetScienceTabTemplate
ScienceTemplateManager.TryInitAllTab = TryInitAllTab
ScienceTemplateManager.GetCurShowTab = GetCurShowTab
ScienceTemplateManager.GetScienceTabSetting = GetScienceTabSetting
ScienceTemplateManager.SetScienceTabSetting = SetScienceTabSetting
ScienceTemplateManager.GetScienceTabPro = GetScienceTabPro
ScienceTemplateManager.GetTabState = GetTabState
ScienceTemplateManager.InitTabLine = InitTabLine
ScienceTemplateManager.GetLineListByTab = GetLineListByTab
ScienceTemplateManager.DelayInitAllTemplate = DelayInitAllTemplate
ScienceTemplateManager.InitAllTemplate = InitAllTemplate
return ScienceTemplateManager
