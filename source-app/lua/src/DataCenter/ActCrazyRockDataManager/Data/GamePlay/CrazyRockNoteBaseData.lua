local CrazyRockNoteBaseData = BaseClass("CrazyRockNoteBaseData")
local DEFAULT_HIT_SE_CONFIG_ID = 90101

local function __init(self)
  self.meterId = -1
  self.noteIndex = -1
  self.noteType = CrazyRockNoteType.Empty
  self.params = 0
  self.nextNoteData = nil
  self.isEndNote = false
  self.singleNoteDuration = 0
  self.beatsPreMeter = 0
  self.isBeHit = false
  self.isEndNote = false
  self.isEndMusicNote = false
end

local function __delete(self)
  self.meterId = nil
  self.noteIndex = nil
  self.noteType = nil
  self.params = nil
  self.nextNoteData = nil
  self.isEndNote = nil
  self.singleNoteDuration = nil
  self.beatsPreMeter = nil
end

function CrazyRockNoteBaseData:UpdateData(meterId, noteIndex, noteType, params)
  self.meterId = meterId
  self.noteType = noteType
  self.params = params
  self.noteIndex = noteIndex
  self.songConfig = params.songConfig
  self.singleNoteDuration = self.songConfig.singleNoteDuration
  self.beatsPreMeter = self.songConfig.beatsPreMeter
  self.songOffset = self.songConfig.songOffset or 0
  self.clickCheckRightRange = self.songConfig.clickCheckRightRange
  self.clickCheckLeftRange = self.songConfig.clickCheckLeftRange
  self:UpdateNoteTimePos()
  self.clickSoundId = params.clickSoundId or DEFAULT_HIT_SE_CONFIG_ID
end

function CrazyRockNoteBaseData:SetNextNoteData(nextNoteData)
  self.nextNoteData = nextNoteData
end

function CrazyRockNoteBaseData:SetEndNote()
  self.isEndNote = true
end

function CrazyRockNoteBaseData:SetEndMusicNote()
  self.isEndMusicNote = true
end

function CrazyRockNoteBaseData:GetNoteTimeLine()
  return (self.meterId - 1) * self.beatsPreMeter * self.singleNoteDuration + self.noteIndex * self.singleNoteDuration + self.songOffset
end

function CrazyRockNoteBaseData:UpdateNoteTimePos()
  self.noteTimePos = self:GetNoteTimeLine()
end

function CrazyRockNoteBaseData:IsInBeforeTimeLine(targetTime)
  return targetTime >= self.noteTimePos
end

function CrazyRockNoteBaseData:IsInAfterTimeLine(targetTime)
  return targetTime < self.noteTimePos
end

function CrazyRockNoteBaseData:IsNotEmptyNote()
  return self.noteType ~= CrazyRockNoteType.Empty
end

function CrazyRockNoteBaseData:DisappearTimeWhenPassHitTime()
  return 0
end

function CrazyRockNoteBaseData:GetTotalHitTimes()
  return 1
end

function CrazyRockNoteBaseData:CheckIsHit(targetTimePos)
  return true
end

function CrazyRockNoteBaseData:GetScoreInfoByHitPos(hitTimePos, hitType)
  local score = 0
  local scoreType = CrazyRockScoreType.Empty
  return score, scoreType
end

function CrazyRockNoteBaseData:IsPerfectHit(hitTimePos)
  return hitTimePos >= self.prefectCheckMinTimePos and hitTimePos <= self.prefectCheckMaxTimePos
end

function CrazyRockNoteBaseData:ShowMusicLog(info)
  Logger.LogCustom(string.format("[music]%s", info))
end

CrazyRockNoteBaseData.__init = __init
CrazyRockNoteBaseData.__delete = __delete
return CrazyRockNoteBaseData
