local ActivityTipsMeta = BaseClass("ActivityTipsMeta")

local function __init(self)
  self.requestActivityDataCount = 0
end

local function __delete(self)
  self.tips = nil
  self.tipsContent = nil
  self.btn_name = nil
end

local function InitConfig(self, lineData)
  if lineData == nil then
    return
  end
  self.id = tonumber(lineData.id)
  self.activity_type = tonumber(lineData.activity_type)
  self.type = tonumber(lineData.type)
  self.priority = tonumber(lineData.priority)
  self.condition = tonumber(lineData.condition)
  self.tips = tostring(lineData.tips)
  self.tips_value = tonumber(lineData.tips_value)
  self.btn_name = tostring(lineData.btn_name)
end

local function SetTipsContent(self, tipsContent)
  self.tipsContent = tipsContent
  if self.condition == MainUITipCondition.SeasonCityOccupy_CityOpen then
    local cityWarInfo = DataCenter.WorldAllianceCityDataManager.theCityWarInfo
    if cityWarInfo ~= nil and cityWarInfo.nextOpen ~= nil then
      local openLevel = toInt(cityWarInfo.nextOpen.level or 7) - 1
      tipsContent = CS.GameEntry.Localization:GetString("season_activity_tips_02", openLevel)
    end
  end
end

local function InitFake(self, type, condition, tipsContent, btn_name)
  self.type = tonumber(type)
  self.condition = tonumber(condition)
  self.tipsContent = tostring(tipsContent)
  self.btn_name = tostring(btn_name)
end

function ActivityTipsMeta:RecordClick()
  if self.type == MainUITipType.Season then
    self:RecordClickSeason()
  end
end

function ActivityTipsMeta:RecordClickSeason()
  if self.activity_type == nil or self.activity_type == 0 or not SeasonUtil.IsInSeason() then
    return
  end
  local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(self.activity_type)
  local actInfo = actList and actList[1] or nil
  if actInfo == nil or actInfo.id == nil or not actInfo:IsValid() then
    return
  end
  local theSeasonStartTime = DataCenter.SeasonDataManager:GetSeasonStartTime()
  if meta.condition == MainUITipCondition.SeasonCityOccupy_Declare then
    local state, declareInfo = DataCenter.AllianceDeclareWarManager:GetDeclareState()
    if state == DeclareWarState.Formal and declareInfo and declareInfo.content then
      local cityId = toInt(declareInfo.content)
      UIUtil.GetActiveCount(theSeasonStartTime, "SeasonCityOccupy_Declare" .. cityId, true)
    end
  elseif meta.condition == MainUITipCondition.SeasonCityOccupy_CityOpen then
    local cityWarInfo = DataCenter.WorldAllianceCityDataManager.theCityWarInfo
    if cityWarInfo ~= nil and cityWarInfo.nextOpen ~= nil then
      local openLevel = toInt(cityWarInfo.nextOpen.level or 7) - 1
      UIUtil.GetActiveCount(theSeasonStartTime, "SeasonCityOccupy_CityOpen" .. openLevel, true)
    end
  elseif meta.condition == MainUITipCondition.SeasonBlackKnight then
    UIUtil.GetTodayActiveCount("SeasonBlackKnight", true)
  elseif meta.condition == MainUITipCondition.SeasonCrossAttackCity_Open then
    UIUtil.GetActiveCount(theSeasonStartTime, "SeasonCrossAttackCity_Open", true)
  elseif meta.condition == MainUITipCondition.SeasonCrossAttackCity_HasBuild then
    local dataList = DataCenter.SeasonDataManager.ActCrossAttackDesertInfo
    if dataList then
      for i, v in ipairs(dataList) do
        local buildId = toInt(v.buildingId)
        if v.hasCreate == 1 and 0 < buildId then
          local key = "SeasonCrossAttackCity_HasBuild" .. buildId
          local cnt = UIUtil.GetActiveCount(theSeasonStartTime, key, false)
          if cnt == 0 then
            UIUtil.GetActiveCount(theSeasonStartTime, key, true)
            break
          end
        end
      end
    end
  elseif meta.condition == MainUITipCondition.SeasonCrossAttackCity_CanPutBuild then
    local dataList = DataCenter.SeasonDataManager.ActCrossAttackDesertInfo
    if dataList then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      for i, v in ipairs(dataList) do
        local buildId = toInt(v.buildingId)
        if v.hasCreate == 0 and 0 < buildId and v.openTime and curTime > v.openTime then
          local key = "SeasonCrossAttackCity_CanPutBuild" .. buildId
          local cnt = UIUtil.GetActiveCount(theSeasonStartTime, key, false)
          if cnt == 0 then
            UIUtil.GetActiveCount(theSeasonStartTime, key, true)
            break
          end
        end
      end
    end
  elseif meta.condition == MainUITipCondition.SeasonCrossDeclareWar_MyDeclare then
    local data = DataCenter.SeasonDataManager.CrossDeclareWarInfo
    if data and data.declareList then
      for _, v in ipairs(data.declareList) do
        if v.result == 0 then
          local key = "SeasonCrossDeclareWar_MyDeclare" .. v.cityId
          local cnt = UIUtil.GetTodayActiveCount(key, false)
          if cnt == 0 then
            UIUtil.GetTodayActiveCount(key, true)
          end
        end
      end
    end
  elseif meta.condition == MainUITipCondition.SeasonCrossDeclareWar_BeDeclare then
    local data = DataCenter.SeasonDataManager.CrossDeclareWarInfo
    if data and data.beDeclareList then
      for _, v in ipairs(data.beDeclareList) do
        if v.result == 0 then
          local key = "SeasonCrossDeclareWar_BeDeclare" .. v.cityId
          local cnt = UIUtil.GetTodayActiveCount(key, false)
          if cnt == 0 then
            UIUtil.GetTodayActiveCount(key, true)
          end
        end
      end
    end
  elseif meta.condition == MainUITipCondition.SeasonFactionSelection_Open then
    UIUtil.GetActiveCount(theSeasonStartTime, "SeasonFactionSelection_Open", true)
  elseif meta.condition == MainUITipCondition.SeasonFactionSelection_Shown then
    UIUtil.GetActiveCount(theSeasonStartTime, "SeasonFactionSelection_Shown", true)
  elseif meta.condition == MainUITipCondition.SeasonFactionSelection_Move then
    UIUtil.GetTodayActiveCount("SeasonFactionSelection_Move", true)
  elseif meta.condition == MainUITipCondition.SeasonFactionDeclareWar_Declare then
    UIUtil.GetTodayActiveCount("SeasonFactionDeclareWar_Declare", true)
  elseif meta.condition == MainUITipCondition.SeasonFactionDeclareWar_CanJoin then
    UIUtil.GetTodayActiveCount("SeasonFactionDeclareWar_CanJoin", true)
  elseif meta.condition == MainUITipCondition.SeasonFactionDeclareWar_Battle then
    UIUtil.GetTodayActiveCount("SeasonFactionKingWar_Start", true)
  elseif meta.condition == MainUITipCondition.SeasonFactionDeclareWar_CanInvite then
    UIUtil.GetTodayActiveCount("SeasonFactionDeclareWar_CanInvite", true)
  elseif meta.condition == MainUITipCondition.SeasonFactionDeclareWar_BeInvite then
    UIUtil.GetTodayActiveCount("SeasonFactionDeclareWar_BeInvite", true)
  elseif meta.condition == MainUITipCondition.SeasonFactionKingWar_Open then
    UIUtil.GetActiveCount(theSeasonStartTime, "SeasonFactionKingWar_Open", true)
  elseif meta.condition == MainUITipCondition.SeasonFactionKingWar_Start then
    UIUtil.GetTodayActiveCount("SeasonFactionKingWar_Start", true)
  elseif meta.condition == MainUITipCondition.SeasonHeroUpdate then
    UIUtil.GetActiveCount(theSeasonStartTime, "SeasonHeroUpdate", true)
  elseif meta.condition == MainUITipCondition.SeasonFactionBigWar then
    UIUtil.GetActiveCount(theSeasonStartTime, "SeasonFactionBigWar", true)
  elseif meta.condition == MainUITipCondition.SeasonNuclearActivityMonster or meta.condition == MainUITipCondition.SeasonNuclearActivityNonFinish then
  end
end

ActivityTipsMeta.__init = __init
ActivityTipsMeta.__delete = __delete
ActivityTipsMeta.InitConfig = InitConfig
ActivityTipsMeta.SetTipsContent = SetTipsContent
ActivityTipsMeta.InitFake = InitFake
return ActivityTipsMeta
