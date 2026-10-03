local base = require("DataCenter.GetDuelScore.GetDuelScoreInfoBase")
local GetPersonDuelScoreInfo = BaseClass("GetPersonDuelScoreInfo", base)

local function OnPushScoreChange(self, data)
  self:ServerAddScore(tonumber(data.cur_sc), tonumber(data.change))
end

local function OnSetScoreData(self, data)
  self.scoreData = data
  if self.scoreData then
    local scoreList = string.split(data.scores, "|")
    self.speedScoreCfgs = {}
    for index, value in ipairs(scoreList) do
      local cfg = LocalController:instance():getLine(TableName.Score, value)
      if cfg and cfg.type == ScoreType.Speed then
        self.speedScoreCfgs[value] = cfg
      end
    end
    self:SetCurScore(data.sc)
    self.targetScoreList = {}
    for index, value in ipairs(data.score_rewards) do
      table.insert(self.targetScoreList, tonumber(value.target))
    end
  end
end

local function OnUseSpeed(self, scoreValue, speedNum)
  if self.speedScoreCfgs and DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.PersonalArmsNew.Type) then
    for key, cfg in pairs(self.speedScoreCfgs) do
      if tonumber(cfg.value) == scoreValue then
        local num = speedNum * tonumber(cfg.points)
        self:FakeAddScore(num)
        break
      end
    end
  end
end

GetPersonDuelScoreInfo.OnPushScoreChange = OnPushScoreChange
GetPersonDuelScoreInfo.OnSetScoreData = OnSetScoreData
GetPersonDuelScoreInfo.OnUseSpeed = OnUseSpeed
return GetPersonDuelScoreInfo
