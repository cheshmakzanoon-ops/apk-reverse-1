local SeasonMilitaryEliteLogData = require("UI.LWSeason6.UILWSeasonMilitaryElite.Main.SeasonMilitaryEliteLogData")
local SeasonMilitaryEliteManager = BaseClass("SeasonMilitaryEliteManager")

function SeasonMilitaryEliteManager:__init()
  self:InitVars()
end

function SeasonMilitaryEliteManager:__delete()
end

function SeasonMilitaryEliteManager:InitVars()
  self.OpenParam = {}
  self.RankMode = {Simple = 1, Full = 2}
  self.RangeType = {
    None = 0,
    Alliance = 1,
    Person = 2
  }
  self.RankType = {
    None = 0,
    Person_All = 101,
    Person_Kill = 103,
    Person_Destroy = 104,
    Person_Assistant = 105,
    Person_Donate = 106,
    Person_Enhance = 107,
    Person_Game = 108,
    Alliance_All = 102,
    Alliance_Kill = 110,
    Alliance_Destroy = 111,
    Alliance_Assistant = 112,
    Alliance_Donate = 113,
    Alliance_Enhance = 114,
    Alliance_Game = 115
  }
  self.PeriodType = {
    Day = 1,
    Week = 2,
    Total = 3
  }
  self.RankViewTabRangeTypeData = {
    {
      RangeType = self.RangeType.Alliance,
      TabLocKey = "season_s5_activity_1200046_desc23",
      RankType = {
        {
          RankType = self.RankType.Alliance_All,
          TabLocKey = "season_military_rank_type_name_1"
        },
        {
          RankType = self.RankType.Alliance_Kill,
          TabLocKey = "season_military_rank_type_name_3"
        },
        {
          RankType = self.RankType.Alliance_Destroy,
          TabLocKey = "season_military_rank_type_name_4"
        },
        {
          RankType = self.RankType.Alliance_Assistant,
          TabLocKey = "season_military_rank_type_name_5"
        },
        {
          RankType = self.RankType.Alliance_Donate,
          TabLocKey = "season_military_rank_type_name_6"
        },
        {
          RankType = self.RankType.Alliance_Enhance,
          TabLocKey = "season_military_rank_type_name_7"
        },
        {
          RankType = self.RankType.Alliance_Game,
          TabLocKey = "season_military_rank_type_name_8"
        }
      }
    },
    {
      RangeType = self.RangeType.Person,
      TabLocKey = "season_s5_activity_1200046_desc24",
      RankType = {
        {
          RankType = self.RankType.Person_All,
          TabLocKey = "season_military_rank_type_name_1"
        },
        {
          RankType = self.RankType.Person_Kill,
          TabLocKey = "season_military_rank_type_name_3"
        },
        {
          RankType = self.RankType.Person_Destroy,
          TabLocKey = "season_military_rank_type_name_4"
        },
        {
          RankType = self.RankType.Person_Assistant,
          TabLocKey = "season_military_rank_type_name_5"
        },
        {
          RankType = self.RankType.Person_Donate,
          TabLocKey = "season_military_rank_type_name_6"
        },
        {
          RankType = self.RankType.Person_Enhance,
          TabLocKey = "season_military_rank_type_name_7"
        },
        {
          RankType = self.RankType.Person_Game,
          TabLocKey = "season_military_rank_type_name_8"
        }
      }
    }
  }
  self.RankViewTabPeriodTypeData = {
    {
      PeriodType = self.PeriodType.Week,
      TabLocKey = "season_s5_activity_1200046_desc26"
    },
    {
      PeriodType = self.PeriodType.Total,
      TabLocKey = "season_s5_activity_1200046_desc27"
    }
  }
  self.LogType = {
    BankTrans = 1,
    BankRob = 2,
    Shoot = 3,
    Train = 4
  }
  self.LogTabTitle = {
    [self.LogType.BankTrans] = "season_s5_activity_1200046_desc10",
    [self.LogType.BankRob] = "season_s5_activity_1200046_desc11",
    [self.LogType.Shoot] = "season_s5_activity_1200046_desc09",
    [self.LogType.Train] = "season_s5_activity_1200046_desc12"
  }
  self.ActState = {Normal = 1, EndShow = 2}
  self.EntryData = {
    {
      RankType = self.RankType.Person_Kill
    },
    {
      RankType = self.RankType.Person_Destroy
    },
    {
      RankType = self.RankType.Person_Assistant
    },
    {
      RankType = self.RankType.Person_Donate
    },
    {
      RankType = self.RankType.Person_Enhance
    },
    {
      RankType = self.RankType.Person_Game
    }
  }
  self.EntryOrder = {
    [self.RankType.Person_Kill] = 1,
    [self.RankType.Person_Destroy] = 2,
    [self.RankType.Person_Assistant] = 3,
    [self.RankType.Person_Donate] = 4,
    [self.RankType.Person_Enhance] = 5,
    [self.RankType.Person_Game] = 6
  }
  self.TopThreeAnimDirection = {
    None = 0,
    Up = 1,
    Down = 2,
    Left = 3,
    Right = 4
  }
  self.WaitingSimpleRankData = {}
  self.CacheRankData = {}
  self.WaitingRankData = {}
  self.CacheLogData = {}
  self.WaitingLogData = {}
end

function SeasonMilitaryEliteManager:SetActId(actId)
  self.ActId = actId
  self.ActCell = LocalController:instance():getLine(TableName.Activity, checknumber(self.ActId))
end

function SeasonMilitaryEliteManager:GetActData()
  return DataCenter.ActivityListDataManager:GetActivityDataById(self.ActId)
end

function SeasonMilitaryEliteManager:GetCurActState()
  local endShowStartTime = self:GetEndShowStartTime()
  if endShowStartTime > UITimeManager:GetInstance():GetServerTime() then
    return self.ActState.Normal
  end
  return self.ActState.EndShow
end

function SeasonMilitaryEliteManager:GetEndShowStartTime()
  local actData = self:GetActData()
  if actData ~= nil then
    local startTime = actData:GetShowStartTime()
    local actCell = self:GetActCell()
    if actCell ~= nil then
      local normalDay = checknumber(actCell.para_6)
      return startTime + normalDay * 24 * 3600 * 1000
    end
  end
  return 0
end

function SeasonMilitaryEliteManager:GetActCell()
  if checknumber(self.ActId) > 0 then
    return LocalController:instance():getLine(TableName.Activity, checknumber(self.ActId))
  end
  return nil
end

function SeasonMilitaryEliteManager:SetOpenParam(key, value)
  if key == nil then
    return
  end
  self.OpenParam[key] = value
end

function SeasonMilitaryEliteManager:GetOpenParam(key, clear)
  if key == nil then
    return nil
  end
  local value = self.OpenParam[key]
  if clear then
    self.OpenParam[key] = nil
  end
  return value
end

function SeasonMilitaryEliteManager:SendGetRank(rankType, periodType, rankMode, isLocal)
  if self:IsWaitingRank(rankType, periodType, rankMode) then
    return
  end
  self:SetWaitingRank(rankType, periodType, rankMode, true)
  local param = {}
  param.rankType = rankType
  param.periodType = periodType
  if isLocal then
    param.isLocal = isLocal
  end
  if rankMode == self.RankMode.Simple then
    SFSNetwork.SendMessage(MsgDefines.MilitaryRankSimpleInfoView, param)
  else
    SFSNetwork.SendMessage(MsgDefines.MilitaryRankInfoView, param)
  end
end

function SeasonMilitaryEliteManager:OnGetRankCallback(rankMode, res)
  if res == nil then
    return
  end
  if rankMode == self.RankMode.Simple then
    local periodType = checknumber(res.periodType)
    if not table.IsNullOrEmpty(res.rankTypeArr) then
      for _, rankData in pairs(res.rankTypeArr) do
        local rankType = checknumber(rankData.militaryRankId)
        self:SetCacheRankData(rankType, periodType, rankMode, rankData)
        self:SetWaitingRank(rankType, periodType, rankMode, false)
      end
    end
  else
    local rankType = checknumber(res.militaryRankId)
    local periodType = checknumber(res.periodType)
    self:SetCacheRankData(rankType, periodType, rankMode, res)
    self:SetWaitingRank(rankType, periodType, rankMode, false)
  end
end

function SeasonMilitaryEliteManager:IsWaitingRank(rankType, periodType, rankMode)
  if rankMode == self.RankMode.Simple then
    return self.WaitingSimpleRankData[periodType]
  end
  if self.WaitingRankData[rankType] == nil then
    return false
  end
  return self.WaitingRankData[rankType][periodType]
end

function SeasonMilitaryEliteManager:SetWaitingRank(rankType, periodType, rankMode, waiting)
  if rankMode == self.RankMode.Simple then
    self.WaitingSimpleRankData[periodType] = waiting
    return
  end
  if self.WaitingRankData[rankType] == nil then
    self.WaitingRankData[rankType] = {}
  end
  self.WaitingRankData[rankType][periodType] = waiting
end

function SeasonMilitaryEliteManager:SetCacheRankData(rankType, periodType, rankMode, data)
  if self.CacheRankData[rankType] == nil then
    self.CacheRankData[rankType] = {}
  end
  if self.CacheRankData[rankType][periodType] == nil then
    self.CacheRankData[rankType][periodType] = {}
  end
  self.CacheRankData[rankType][periodType][rankMode] = data
  EventManager:GetInstance():Broadcast(EventId.SeasonMilitaryEliteRankUpdate, {
    RankType = rankType,
    PeriodType = periodType,
    RankMode = rankMode
  })
end

function SeasonMilitaryEliteManager:GetCacheRankData(rankType, periodType, rankMode)
  if self.CacheRankData[rankType] == nil then
    return nil
  end
  if self.CacheRankData[rankType][periodType] == nil then
    return nil
  end
  return self.CacheRankData[rankType][periodType][rankMode]
end

function SeasonMilitaryEliteManager:ClearRankData()
  self.CacheRankData = {}
  self.WaitingRankData = {}
  self.WaitingSimpleRankData = {}
end

function SeasonMilitaryEliteManager:SendGetLog(logType)
  logType = Mathf.Clamp(checknumber(logType), 1, self.LogType.Train)
  if self.WaitingLogData[logType] then
    return
  end
  self.WaitingLogData[logType] = true
  local param = {}
  param.type = logType
  SFSNetwork.SendMessage(MsgDefines.UserMilitaryRankLogView, param)
end

function SeasonMilitaryEliteManager:OnGetLogCallback(res)
  if res == nil then
    return
  end
  local logType = checknumber(res.type)
  self.WaitingLogData[logType] = false
  self.CacheLogData[logType] = {}
  if not table.IsNullOrEmpty(res.userMoneyRankLogArr) then
    for _, log in pairs(res.userMoneyRankLogArr) do
      local logData = SeasonMilitaryEliteLogData.New(logType)
      logData:SetData(log)
      table.insert(self.CacheLogData[logType], logData)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonMilitaryEliteLogUpdate, logType)
end

function SeasonMilitaryEliteManager:GetCacheLogData(logType)
  return self.CacheLogData[logType]
end

function SeasonMilitaryEliteManager:ClearLogCache()
  self.CacheLogData = {}
  self.WaitingLogData = {}
end

return SeasonMilitaryEliteManager
