local CrazyRockNoteBaseData = require("DataCenter.ActCrazyRockDataManager.Data.GamePlay.CrazyRockNoteBaseData")
local base = CrazyRockNoteBaseData
local CrazyRockContinueNoteData = BaseClass("CrazyRockContinueNoteData", CrazyRockNoteBaseData)

local function __init(self)
  base.__init(self)
end

local function __delete(self)
  base.__delete(self)
end

function CrazyRockContinueNoteData:UpdateData(meterId, noteIndex, noteType, params)
  base.UpdateData(self, meterId, noteIndex, noteType, params)
  self.continueClickKeepNoteCount = self.params.continueClickKeepNoteCount
  self.continueClickCount = self.params.continueClickCount
  self.totalDuration = self.continueClickKeepNoteCount * self.singleNoteDuration
  self:CalculateTimePos()
end

function CrazyRockContinueNoteData:CalculateTimePos()
  self.minClickTimePos = self.noteTimePos - self.clickCheckLeftRange
  self.maxClickTimePos = self.noteTimePos + self.totalDuration
  self.prefectCheckMinTimePos = self.noteTimePos - self.clickCheckLeftRange * self.songConfig.prefectClickRightPercent
  self.prefectCheckMaxTimePos = self.noteTimePos + self.clickCheckRightRange * self.songConfig.prefectClickLeftPercent
  self.continueFirstHitGoodScore = self.songConfig.continueFirstHitGoodScore
  self.continueFirstHitPerfectScore = self.songConfig.continueFirstHitPerfectScore
  self.continueHitScore = self.songConfig.continueHitScore
end

function CrazyRockContinueNoteData:DisappearTimeWhenPassHitTime()
  return self.totalDuration
end

function CrazyRockContinueNoteData:GetTotalHitTimes()
  return self.continueClickCount
end

function CrazyRockContinueNoteData:CheckIsHit(targetTimePos)
  return targetTimePos >= self.minClickTimePos and targetTimePos <= self.maxClickTimePos
end

function CrazyRockContinueNoteData:GetScoreInfoByHitPos(hitTimePos, hitType)
  local score = 0
  local scoreType = CrazyRockScoreType.Empty
  if hitType == CrazyRockHitType.ContinueFirstNoteHit then
    local isPerfect = self:IsPerfectHit(hitTimePos)
    scoreType = isPerfect and CrazyRockScoreType.Perfect or CrazyRockScoreType.Good
    score = isPerfect and self.continueFirstHitPerfectScore or self.continueFirstHitGoodScore
  elseif hitType == CrazyRockHitType.ContinueHit then
    scoreType = CrazyRockScoreType.Perfect
    score = self.continueHitScore
  end
  return score, scoreType
end

CrazyRockContinueNoteData.__init = __init
CrazyRockContinueNoteData.__delete = __delete
return CrazyRockContinueNoteData
