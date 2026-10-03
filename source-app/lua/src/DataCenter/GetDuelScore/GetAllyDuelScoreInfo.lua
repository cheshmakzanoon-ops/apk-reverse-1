local base = require("DataCenter.GetDuelScore.GetDuelScoreInfoBase")
local GetAllyDuelScoreInfo = BaseClass("GetAllyDuelScoreInfo", base)

local function OnPushScoreChange(self, data)
  self.curMyAlScore = data.alScore or 0
  self.curEnemyAlScore = data.vsAlScore or 0
  self:ServerAddScore(tonumber(data.score), tonumber(data.addScore))
  EventManager:GetInstance():Broadcast(EventId.AllyDuelScoreRefresh)
end

local function OnSetScoreData(self, data)
  self.scoreData = data
  if self.scoreData then
    local scoreList = data.scoreIdList
    self.speedScoreCfgs = {}
    for index, value in ipairs(scoreList) do
      local cfg = LocalController:instance():getLine(TableName.Score, value)
      if cfg and cfg.type == ScoreType.Speed then
        self.speedScoreCfgs[value] = cfg
      end
    end
    self:SetCurScore(data.curScore)
    self.targetScoreList = {}
    for index, value in ipairs(data.targetList) do
      table.insert(self.targetScoreList, tonumber(value))
    end
  end
end

local function OnUseSpeed(self, scoreValue, speedNum)
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if not actInfo then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local start = actInfo.startTime
  local finish = actInfo.endTime
  if self.speedScoreCfgs and now > start and now < finish then
    for key, cfg in pairs(self.speedScoreCfgs) do
      if tonumber(cfg.value) == scoreValue then
        local effectList = self:GetEffectListByCfgId(cfg.id)
        local num = speedNum * tonumber(cfg.points) * 10
        if effectList then
          num = LuaEntry.Effect:GetAllianceArmsEffectNum(num, effectList)
        end
        num = num * 0.1
        self:FakeAddScore(num)
        break
      end
    end
  end
end

local function GetEffectListByCfgId(self, cfgId)
  local effectList
  if self.scoreData and self.scoreData.scoreIdListNew then
    for index, value in ipairs(self.scoreData.scoreIdListNew) do
      if tonumber(value.id) == cfgId then
        effectList = value.effectList
        break
      end
    end
  end
  return effectList
end

GetAllyDuelScoreInfo.OnPushScoreChange = OnPushScoreChange
GetAllyDuelScoreInfo.OnSetScoreData = OnSetScoreData
GetAllyDuelScoreInfo.OnUseSpeed = OnUseSpeed
GetAllyDuelScoreInfo.GetEffectListByCfgId = GetEffectListByCfgId
return GetAllyDuelScoreInfo
