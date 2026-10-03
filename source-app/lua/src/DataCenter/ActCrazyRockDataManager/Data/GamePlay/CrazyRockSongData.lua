local CrazyRockSongData = BaseClass("CrazyRockSongData")
local SongMeterData = require("DataCenter.ActCrazyRockDataManager.Data.GamePlay.CrazyRockSongMeterData")
local ActivityFesSongTemplate = require("DataCenter.ActCrazyRockDataManager.Template.ActivityFesSongTemplate")

local function __init(self)
  self.songId = -1
  self.songTmp = nil
  self.songNameKey = ""
  self.duration = 0
  self.bpm = 0
  self.beatsPreMeter = 0
  self.songMeterStartIndex = 0
  self.songMeterEndIndex = 0
  self.songDuration = 0
  self.minClickInterval = 0
  self.normalClickBaseScore = 0
  self.continueClickFirstScore = 0
  self.continueClickScore = 0
  self.maxScore = 0
  self.songOffset = 0
  self.clickCheckLeftRange = 0
  self.clickCheckRightRange = 0
  self.prefectClickLeftPercent = 0
  self.prefectClickRightPercent = 0
  self.prefectClickScoreRatio = 0
  self.normalClickScoreRatio = 0
  self.notePreviewTime = 0
  self.comboScoreRatioConfig = {}
  self.completeScore = 0
  self.songMeterDataList = {}
  self.songMeterDic = {}
end

local function __delete(self)
  self.songId = nil
  self.songTmp = nil
  self.songNameKey = ""
  self.duration = nil
  self.bpm = nil
  self.beatsPreMeter = nil
  self.songMeterStartIndex = nil
  self.songMeterEndIndex = nil
  self.songDuration = nil
  self.minClickInterval = nil
  self.normalClickBaseScore = nil
  self.continueClickFirstScore = nil
  self.continueClickScore = nil
  self.maxScore = nil
  self.songOffset = nil
  self.clickCheckLeftRange = nil
  self.clickCheckRightRange = nil
  self.prefectClickLeftPercent = nil
  self.prefectClickRightPercent = nil
  self.prefectClickScoreRatio = nil
  self.normalClickScoreRatio = nil
  self.notePreviewTime = nil
  self.comboScoreRatioConfig = nil
  self.completeScore = nil
  self.songMeterDataList = nil
  self.songMeterDic = nil
end

function CrazyRockSongData:UpdateData(songId)
  self.songId = songId
  self:ParseSongData()
  self:ParseSongNoteData()
end

function CrazyRockSongData:ParseSongData()
  local line = LocalController:instance():getLine(TableName.CRAZY_ROCK_SONG, self.songId)
  if not line then
    Logger.LogError("CrazyRockSongData:ParseData() line is nil! plz check it !")
    return
  end
  self.songTmp = ActivityFesSongTemplate.New()
  self.songTmp:UpdateData(line)
  self.bgmMetaId = self.songTmp.sound_id
  self.songNameKey = self.songTmp.name_key
  self.duration = self.songTmp.time
  self.bpm = self.songTmp.bpm
  self.beatsPreMeter = self.songTmp.beats
  self.songNoteStartIndex = self.songTmp.note_group[1]
  self.songNoteEndIndex = self.songTmp.note_group[2]
  self.songDuration = self.songTmp.time
  self.minClickInterval = self.songTmp.space
  self.normalClickBaseScore = self.songTmp.score[1]
  self.continueClickFirstScore = self.songTmp.score[2]
  self.continueClickScore = self.songTmp.score[3]
  self.maxScore = self.songTmp.score_max
  self.songOffset = self.songTmp.offset
  self.clickCheckLeftRange = self.songTmp.success_area[1]
  self.clickCheckRightRange = self.songTmp.success_area[2]
  self.prefectClickLeftPercent = self.songTmp.perfect_area[1] / 10000
  self.prefectClickRightPercent = self.songTmp.perfect_area[2] / 10000
  self.normalClickScoreRatio = self.songTmp.verify[2]
  self.prefectClickScoreRatio = self.songTmp.verify[1]
  self.notePreviewTime = self.songTmp.drop_time
  self.songMeterStartIndex = self.songTmp.note_group[1]
  self.songMeterEndIndex = self.songTmp.note_group[2]
  self.bpm_act = self.songTmp.bpm_act
  self.disappear_time = self.songTmp.disappear_time
  self.blank_time = self.songTmp.blank_time
  local singleHitBaseScore = self.songTmp.score[1]
  self.singleHitGoodScore = Mathf.Ceil(singleHitBaseScore * self.normalClickScoreRatio)
  self.singleHitPerfectScore = Mathf.Ceil(singleHitBaseScore * self.prefectClickScoreRatio)
  local continueFirstHitBaseScore = self.songTmp.score[2]
  self.continueFirstHitGoodScore = Mathf.Ceil(continueFirstHitBaseScore * self.normalClickScoreRatio)
  self.continueFirstHitPerfectScore = Mathf.Ceil(continueFirstHitBaseScore * self.prefectClickScoreRatio)
  self.continueHitScore = self.songTmp.score[3]
  for _, v in ipairs(self.songTmp.combo_score) do
    local comboScoreRatioStrArr = string.split(v, ";")
    if #comboScoreRatioStrArr == 3 then
      local comboRangeLeft = tonumber(comboScoreRatioStrArr[1])
      local comboRangeRight = tonumber(comboScoreRatioStrArr[2])
      local comboScoreRatio = tonumber(comboScoreRatioStrArr[3])
      local config = {}
      config.comboRangeLeft = comboRangeLeft
      config.comboRangeRight = comboRangeRight
      config.comboScoreRatio = comboScoreRatio
      table.insert(self.comboScoreRatioConfig, config)
    end
  end
  self.completeScore = self.songTmp.finished_point or 0
end

function CrazyRockSongData:ParseSongNoteData()
  if not self.songTmp then
    Logger.LogError("CrazyRockSongData:ParseSongNoteData() songTmp is nil! plz check it !")
    return
  end
  self.songMeterDic = {}
  self.songMeterDataList = {}
  local prevMeterData
  local songConfig = {}
  songConfig.singleNoteDuration = 60000 / self.bpm
  songConfig.beatsPreMeter = self.beatsPreMeter
  songConfig.clickCheckLeftRange = self.clickCheckLeftRange
  songConfig.clickCheckRightRange = self.clickCheckRightRange
  songConfig.prefectClickLeftPercent = self.prefectClickLeftPercent
  songConfig.prefectClickRightPercent = self.prefectClickRightPercent
  songConfig.songOffset = self.songOffset + (self.customOffset or 0)
  songConfig.singleHitGoodScore = self.singleHitGoodScore
  songConfig.singleHitPerfectScore = self.singleHitPerfectScore
  songConfig.continueFirstHitGoodScore = self.continueFirstHitGoodScore
  songConfig.continueFirstHitPerfectScore = self.continueFirstHitPerfectScore
  songConfig.continueHitScore = self.continueHitScore
  local meterId = 1
  for i = self.songMeterStartIndex, self.songMeterEndIndex do
    local meterMetaId = i
    local songMeterData = SongMeterData.New()
    if i == self.songMeterEndIndex then
      songMeterData:SetIsEndMeter(true)
    end
    songMeterData:UpdateData(meterMetaId, meterId, songConfig)
    if prevMeterData then
      songMeterData:SetNextMeterData(prevMeterData)
    end
    prevMeterData = songMeterData
    self.songMeterDic[meterId] = songMeterData
    table.insert(self.songMeterDataList, songMeterData)
    meterId = meterId + 1
  end
  self:FindAndConfirmEndMusicNote()
end

function CrazyRockSongData:FindAndConfirmEndMusicNote()
  if not self.songMeterDataList or #self.songMeterDataList <= 0 then
    Logger.LogError("CrazyRockSongData:FindAndConfirmEndMusicNote() songMeterDataList is nil! plz check it !")
    return
  end
  for i = #self.songMeterDataList, 1, -1 do
    local meterData = self.songMeterDataList[i]
    local allNoteDataList = meterData.noteDataList
    if allNoteDataList and not (#allNoteDataList <= 0) then
      for j = #allNoteDataList, 1, -1 do
        local noteData = allNoteDataList[j]
        if noteData.noteType ~= CrazyRockNoteType.Empty then
          noteData:SetEndMusicNote()
          return
        end
      end
    end
  end
end

function CrazyRockSongData:GetFirstMeterData()
  if not self.songMeterDataList or #self.songMeterDataList <= 0 then
    Logger.LogError("CrazyRockSongData:GetFirstMeterData() songMeterDataList is nil! plz check it !")
    return nil
  end
  return self.songMeterDataList[1]
end

function CrazyRockSongData:GetFirstNoteData()
  local firstMeterData = self:GetFirstMeterData()
  if not firstMeterData then
    Logger.LogError("CrazyRockSongData:GetFirstNoteData() firstMeterData is nil! plz check it !")
    return nil
  end
  return firstMeterData:GetFirstNoteData()
end

function CrazyRockSongData:GetMeterDataById(meterId)
  if not self.songMeterDic[meterId] then
    return nil
  end
  return self.songMeterDic[meterId]
end

function CrazyRockSongData:GetComboScoreRatioConfig(comboCount)
  local comboLv = 1
  if not self.comboScoreRatioConfig or #self.comboScoreRatioConfig <= 0 then
    Logger.LogError("CrazyRockSongData:GetComboScoreRatioConfig() comboScoreRatioConfig is nil! plz check it !")
    return 1, comboLv
  end
  for _, v in ipairs(self.comboScoreRatioConfig) do
    if comboCount >= v.comboRangeLeft and comboCount <= v.comboRangeRight then
      return v.comboScoreRatio / 10000, comboLv
    end
    comboLv = comboLv + 1
  end
  return 1, comboLv
end

function CrazyRockSongData:SetCustomOffset(value)
  self.customOffset = value
  self:ParseSongNoteData()
end

CrazyRockSongData.__init = __init
CrazyRockSongData.__delete = __delete
return CrazyRockSongData
