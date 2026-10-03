local CrazyRockNoteBaseData = require("DataCenter.ActCrazyRockDataManager.Data.GamePlay.CrazyRockNoteBaseData")
local base = CrazyRockNoteBaseData
local CrazyRockSingleNoteData = BaseClass("CrazyRockSingleNoteData", CrazyRockNoteBaseData)

local function __init(self)
  base.__init(self)
end

local function __delete(self)
  base.__delete(self)
end

function CrazyRockSingleNoteData:UpdateData(meterId, noteIndex, noteType, params)
  base.UpdateData(self, meterId, noteIndex, noteType, params)
  self:CalculateTimePos()
end

function CrazyRockSingleNoteData:CalculateTimePos()
  self.minClickTimePos = self.noteTimePos - self.clickCheckLeftRange
  self.maxClickTimePos = self.noteTimePos + self.clickCheckRightRange
  self.prefectCheckMinTimePos = self.noteTimePos - self.clickCheckLeftRange * self.songConfig.prefectClickRightPercent
  self.prefectCheckMaxTimePos = self.noteTimePos + self.clickCheckRightRange * self.songConfig.prefectClickLeftPercent
  self.singleHitGoodScore = self.songConfig.singleHitGoodScore
  self.singleHitPerfectScore = self.songConfig.singleHitPerfectScore
end

function CrazyRockSingleNoteData:DisappearTimeWhenPassHitTime()
  return self.clickCheckRightRange
end

function CrazyRockSingleNoteData:GetTotalHitTimes()
  return 1
end

function CrazyRockSingleNoteData:CheckIsHit(targetTimePos)
  return targetTimePos >= self.minClickTimePos and targetTimePos <= self.maxClickTimePos
end

function CrazyRockSingleNoteData:GetScoreInfoByHitPos(hitTimePos, hitType)
  local score = 0
  local scoreType = CrazyRockScoreType.Empty
  local isPerfect = self:IsPerfectHit(hitTimePos)
  scoreType = isPerfect and CrazyRockScoreType.Perfect or CrazyRockScoreType.Good
  score = isPerfect and self.singleHitPerfectScore or self.singleHitGoodScore
  return score, scoreType
end

CrazyRockSingleNoteData.__init = __init
CrazyRockSingleNoteData.__delete = __delete
return CrazyRockSingleNoteData
