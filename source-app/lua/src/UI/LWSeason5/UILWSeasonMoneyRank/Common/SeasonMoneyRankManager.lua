local SeasonMoneyRankLogData = require("UI.LWSeason5.UILWSeasonMoneyRank.Common.SeasonMoneyRankLogData")
local SeasonMoneyRankManager = BaseClass("SeasonMoneyRankManager")

function SeasonMoneyRankManager:__init()
  self:InitVars()
end

function SeasonMoneyRankManager:__delete()
end

function SeasonMoneyRankManager:InitVars()
  self.RankMode = {Simple = 1, Full = 2}
  self.RangeType = {
    None = 0,
    Alliance = 1,
    Person = 2
  }
  self.RankType = {
    None = 0,
    AllPerson = 1,
    AllAlliance = 2,
    Shoot = 3,
    BankManage = 4,
    BankRob = 5,
    Train = 6,
    BankManageAlliance = 7,
    BankRobAlliance = 8,
    TrainAlliance = 9
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
          RankType = self.RankType.AllAlliance,
          TabLocKey = "season_s5_activity_1200046_desc13"
        },
        {
          RankType = self.RankType.BankManageAlliance,
          TabLocKey = "season_s5_activity_1200046_desc14"
        },
        {
          RankType = self.RankType.BankRobAlliance,
          TabLocKey = "season_s5_activity_1200046_desc16"
        },
        {
          RankType = self.RankType.TrainAlliance,
          TabLocKey = "season_s5_activity_1200046_desc17"
        }
      }
    },
    {
      RangeType = self.RangeType.Person,
      TabLocKey = "season_s5_activity_1200046_desc24",
      RankType = {
        {
          RankType = self.RankType.AllPerson,
          TabLocKey = "season_s5_activity_1200046_desc13"
        },
        {
          RankType = self.RankType.BankManage,
          TabLocKey = "season_s5_activity_1200046_desc14"
        },
        {
          RankType = self.RankType.BankRob,
          TabLocKey = "s5_rank_460_title"
        },
        {
          RankType = self.RankType.Shoot,
          TabLocKey = "season_s5_activity_1200046_desc15"
        },
        {
          RankType = self.RankType.Train,
          TabLocKey = "season_s5_activity_1200046_desc17"
        }
      }
    }
  }
  self.RankViewTabPeriodTypeData = {
    {
      PeriodType = self.PeriodType.Day,
      TabLocKey = "season_s5_activity_1200046_desc25"
    },
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
      RankType = self.RankType.BankManage,
      Title = "season_s5_activity_1200046_desc10",
      Icon = "Assets/Main/SeasonRes/S5/Sprites/SeasonMoneyRank/LXYS5_Jingjin_Icon4_banner.png",
      PeriodType = {
        [self.ActState.Normal] = self.PeriodType.Week,
        [self.ActState.EndShow] = self.PeriodType.Total
      }
    },
    {
      RankType = self.RankType.BankRob,
      Title = "season_s5_activity_1200046_desc11",
      Icon = "Assets/Main/SeasonRes/S5/Sprites/SeasonMoneyRank/LXYS5_Jingjin_Icon6_banner.png",
      PeriodType = {
        [self.ActState.Normal] = self.PeriodType.Week,
        [self.ActState.EndShow] = self.PeriodType.Total
      }
    },
    {
      RankType = self.RankType.Shoot,
      ActType = EnumActivity.BiuBiu.Type,
      Title = "season_s5_activity_1200046_desc09",
      Icon = "Assets/Main/SeasonRes/S5/Sprites/SeasonMoneyRank/LXYS5_Jingjin_Icon7_banner.png",
      PeriodType = {
        [self.ActState.Normal] = self.PeriodType.Week,
        [self.ActState.EndShow] = self.PeriodType.Total
      }
    },
    {
      RankType = self.RankType.Train,
      ActType = EnumActivity.HighSpeedRailway.Type,
      Title = "season_s5_activity_1200046_desc12",
      Icon = "Assets/Main/SeasonRes/S5/Sprites/SeasonMoneyRank/LXYS5_Jingjin_Icon5_banner.png",
      PeriodType = {
        [self.ActState.Normal] = self.PeriodType.Week,
        [self.ActState.EndShow] = self.PeriodType.Total
      }
    }
  }
  self.EntryOrder = {
    [self.RankType.BankManage] = 1,
    [self.RankType.BankRob] = 2,
    [self.RankType.Shoot] = 3,
    [self.RankType.Train] = 4
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

function SeasonMoneyRankManager:SetActId(actId)
  self.ActId = actId
end

function SeasonMoneyRankManager:GetActData()
  return DataCenter.ActivityListDataManager:GetActivityDataById(self.ActId)
end

function SeasonMoneyRankManager:GetCurActState()
  local endShowStartTime = self:GetEndShowStartTime()
  if endShowStartTime > UITimeManager:GetInstance():GetServerTime() then
    return self.ActState.Normal
  end
  return self.ActState.EndShow
end

function SeasonMoneyRankManager:GetEndShowStartTime()
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

function SeasonMoneyRankManager:GetActCell()
  if checknumber(self.ActId) > 0 then
    return LocalController:instance():getLine(TableName.Activity, checknumber(self.ActId))
  end
  return nil
end

function SeasonMoneyRankManager:SendGetRank(rankType, periodType, rankMode)
  if self:IsWaitingRank(rankType, periodType, rankMode) then
    return
  end
  self:SetWaitingRank(rankType, periodType, rankMode, true)
  local param = {}
  param.rankType = rankType
  param.periodType = periodType
  if rankMode == self.RankMode.Simple then
    SFSNetwork.SendMessage(MsgDefines.MoneyRankSimpleInfoView, param)
  else
    SFSNetwork.SendMessage(MsgDefines.MoneyRankInfoView, param)
  end
end

function SeasonMoneyRankManager:OnGetRankCallback(rankMode, res)
  if res == nil then
    return
  end
  if rankMode == self.RankMode.Simple then
    local periodType = checknumber(res.periodType)
    if not table.IsNullOrEmpty(res.rankTypeArr) then
      for _, rankData in pairs(res.rankTypeArr) do
        local rankType = checknumber(rankData.rankType)
        self:SetCacheRankData(rankType, periodType, rankMode, rankData)
        self:SetWaitingRank(rankType, periodType, rankMode, false)
      end
    end
  else
    local rankType = checknumber(res.rankType)
    local periodType = checknumber(res.periodType)
    self:SetCacheRankData(rankType, periodType, rankMode, res)
    self:SetWaitingRank(rankType, periodType, rankMode, false)
  end
end

function SeasonMoneyRankManager:IsWaitingRank(rankType, periodType, rankMode)
  if rankMode == self.RankMode.Simple then
    return self.WaitingSimpleRankData[periodType]
  end
  if self.WaitingRankData[rankType] == nil then
    return false
  end
  return self.WaitingRankData[rankType][periodType]
end

function SeasonMoneyRankManager:SetWaitingRank(rankType, periodType, rankMode, waiting)
  if rankMode == self.RankMode.Simple then
    self.WaitingSimpleRankData[periodType] = waiting
    return
  end
  if self.WaitingRankData[rankType] == nil then
    self.WaitingRankData[rankType] = {}
  end
  self.WaitingRankData[rankType][periodType] = waiting
end

function SeasonMoneyRankManager:SetCacheRankData(rankType, periodType, rankMode, data)
  if self.CacheRankData[rankType] == nil then
    self.CacheRankData[rankType] = {}
  end
  if self.CacheRankData[rankType][periodType] == nil then
    self.CacheRankData[rankType][periodType] = {}
  end
  self.CacheRankData[rankType][periodType][rankMode] = data
  EventManager:GetInstance():Broadcast(EventId.SeasonMoneyRankRankUpdate, {
    RankType = rankType,
    PeriodType = periodType,
    RankMode = rankMode
  })
end

function SeasonMoneyRankManager:GetCacheRankData(rankType, periodType, rankMode)
  if self.CacheRankData[rankType] == nil then
    return nil
  end
  if self.CacheRankData[rankType][periodType] == nil then
    return nil
  end
  return self.CacheRankData[rankType][periodType][rankMode]
end

function SeasonMoneyRankManager:ClearRankData()
  self.CacheRankData = {}
  self.WaitingRankData = {}
  self.WaitingSimpleRankData = {}
end

function SeasonMoneyRankManager:SendGetLog(logType)
  logType = Mathf.Clamp(checknumber(logType), 1, self.LogType.Train)
  if self.WaitingLogData[logType] then
    return
  end
  self.WaitingLogData[logType] = true
  local param = {}
  param.type = logType
  SFSNetwork.SendMessage(MsgDefines.UserMoneyRankLogView, param)
end

function SeasonMoneyRankManager:OnGetLogCallback(res)
  if res == nil then
    return
  end
  local logType = checknumber(res.type)
  self.WaitingLogData[logType] = false
  self.CacheLogData[logType] = {}
  if not table.IsNullOrEmpty(res.userMoneyRankLogArr) then
    for _, log in pairs(res.userMoneyRankLogArr) do
      local logData = SeasonMoneyRankLogData.New(logType)
      logData:SetData(log)
      table.insert(self.CacheLogData[logType], logData)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonMoneyRankLogUpdate, logType)
end

function SeasonMoneyRankManager:GetCacheLogData(logType)
  return self.CacheLogData[logType]
end

function SeasonMoneyRankManager:ClearLogCache()
  self.CacheLogData = {}
  self.WaitingLogData = {}
end

return SeasonMoneyRankManager
