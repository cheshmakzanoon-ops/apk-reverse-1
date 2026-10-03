local CrazyRockSongMeterData = BaseClass("CrazyRockSongMeterData")
local CrazyRockNoteBaseData = require("DataCenter.ActCrazyRockDataManager.Data.GamePlay.CrazyRockNoteBaseData")
local CrazyRockSingleNoteData = require("DataCenter.ActCrazyRockDataManager.Data.GamePlay.CrazyRockSingleNoteData")
local CrazyRockContinueNoteData = require("DataCenter.ActCrazyRockDataManager.Data.GamePlay.CrazyRockContinueNoteData")
local ActivityFesSongnoteTemplate = require("DataCenter.ActCrazyRockDataManager.Template.ActivityFesSongnoteTemplate")
local noteDataClassMap = {
  [CrazyRockNoteType.SingleClick] = CrazyRockSingleNoteData,
  [CrazyRockNoteType.Continue] = CrazyRockContinueNoteData
}

local function __init(self)
  self.meterId = -1
  self.meterIndex = 1
  self.noteDataList = {}
  self.continueNumInfoList = {}
  self.curContinuePosIndex = 1
  self.meterTmp = nil
  self.nextMeterData = nil
  self.isEndMeter = false
end

local function __delete(self)
  self.meterId = nil
  self.meterIndex = nil
  self.noteDataList = nil
  self.continueNumInfoList = nil
  self.curContinuePosIndex = nil
  self.meterTmp = nil
  self.nextMeterData = nil
  self.isEndMeter = nil
end

function CrazyRockSongMeterData:UpdateData(meterMetaId, meterId, songConfig)
  self.meterMetaId = meterMetaId
  self.meterId = meterId
  self.songConfig = songConfig
  self.beatPerMeter = songConfig.beatsPreMeter
  self:ParseData()
end

function CrazyRockSongMeterData:ParseData()
  local line = LocalController:instance():getLine(TableName.CRAZY_ROCK_SONG_NOTE, self.meterMetaId)
  if not line then
    Logger.LogError("CrazyRockSongData:ParseSongMeterData() line is nil! plz check it !")
    return
  end
  self.meterTmp = ActivityFesSongnoteTemplate.New()
  self.meterTmp:UpdateData(line)
  self.meterIndex = self.meterTmp.meter
  local noteInfoStr = self.meterTmp.note_type
  local prevNoteData
  local notEmptyNoteIndex = 1
  for i = 1, #noteInfoStr do
    local noteType = toInt(string.sub(noteInfoStr, i, i))
    local params = {}
    params.songConfig = self.songConfig
    if noteType == CrazyRockNoteType.Continue then
      if self.curContinuePosIndex <= #self.meterTmp.hit_max then
        local continueClickInfo = string.split(self.meterTmp.hit_max[self.curContinuePosIndex], ";")
        if #continueClickInfo == 2 then
          params.continueClickCount = toInt(continueClickInfo[1])
          params.continueClickKeepNoteCount = toInt(continueClickInfo[2])
        end
      else
        noteType = CrazyRockNoteType.Empty
        if CS.UnityEngine.Application.isEditor then
          UIUtil.ShowTips(string.format("note id:%s \232\191\158\229\135\187\233\159\179\231\172\166\233\133\141\231\189\174\230\156\137\233\151\174\233\162\152!", self.meterTmp.id))
        end
      end
      self.curContinuePosIndex = self.curContinuePosIndex + 1
    end
    if noteType ~= CrazyRockNoteType.Empty then
      if notEmptyNoteIndex <= #self.meterTmp.note_sound then
        params.clickSoundId = self.meterTmp.note_sound[notEmptyNoteIndex]
      end
      notEmptyNoteIndex = notEmptyNoteIndex + 1
    end
    local noteData = self:CreateNoteDataByType(noteType)
    local nodeIndex = i
    noteData:UpdateData(self.meterId, nodeIndex, noteType, params)
    local isEndNote = i == #noteInfoStr
    if isEndNote then
      noteData:SetEndNote()
    end
    table.insert(self.noteDataList, noteData)
    if prevNoteData then
      prevNoteData:SetNextNoteData(noteData)
    end
    prevNoteData = noteData
  end
end

function CrazyRockSongMeterData:SetNextMeterData(nextMeterData)
  self.nextMeterData = nextMeterData
end

function CrazyRockSongMeterData:SetIsEndMeter(isEndMeter)
  self.isEndMeter = isEndMeter
end

function CrazyRockSongMeterData:GetFirstNoteData()
  if not self.noteDataList or #self.noteDataList <= 0 then
    Logger.LogError("CrazyRockSongMeterData:GetFirstNoteData() noteDataList is nil! plz check it !")
    return nil
  end
  return self.noteDataList[1]
end

function CrazyRockSongMeterData:CreateNoteDataByType(noteType)
  local noteDataClass = noteDataClassMap[noteType]
  if not noteDataClass then
    return CrazyRockNoteBaseData.New()
  end
  return noteDataClass.New()
end

CrazyRockSongMeterData.__init = __init
CrazyRockSongMeterData.__delete = __delete
return CrazyRockSongMeterData
