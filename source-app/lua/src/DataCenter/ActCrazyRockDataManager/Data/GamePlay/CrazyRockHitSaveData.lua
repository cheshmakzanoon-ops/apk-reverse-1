local CrazyRockHitSaveData = BaseClass("CrazyRockHitSaveData")

local function __init(self)
  self.allHitDataDic = {}
  self.allHitDataList = {}
end

local function __delete(self)
  self.allHitDataDic = nil
  self.allHitDataList = nil
end

function CrazyRockHitSaveData:AddHitData(hitRet)
  local hitType = hitRet.hitType
  local meterId = hitRet.meterId
  local noteIndex = hitRet.noteIndex
  local uid = 10000 * meterId + noteIndex
  if hitType == CrazyRockHitType.SingleNoteHit then
    self.allHitDataDic[uid] = hitRet
    table.insert(self.allHitDataList, hitRet)
  elseif hitType == CrazyRockHitType.ContinueFirstNoteHit or hitType == CrazyRockHitType.ContinueHit then
    local noteHitData = self.allHitDataDic[uid]
    if noteHitData then
      noteHitData.continueHitCount = noteHitData.continueHitCount + 1
    else
      hitRet.continueHitCount = 0
      self.allHitDataDic[uid] = hitRet
      table.insert(self.allHitDataList, hitRet)
    end
  end
end

function CrazyRockHitSaveData:GetFormatDataList()
  local ret = {}
  for k, v in ipairs(self.allHitDataList) do
    local hitInfo
    if v.hitType == CrazyRockHitType.SingleNoteHit then
      hitInfo = string.format("%s|%s|%s", v.meterId, v.noteIndex, v.hitTimePos)
    elseif v.hitType == CrazyRockHitType.ContinueFirstNoteHit then
      hitInfo = string.format("%s|%s|%s|%s", v.meterId, v.noteIndex, v.hitTimePos, v.continueHitCount)
    end
    table.insert(ret, hitInfo)
    Logger.Log("hitInfo:" .. hitInfo)
  end
  return ret
end

function CrazyRockHitSaveData:Clear()
  self.allHitDataDic = {}
  self.allHitDataList = {}
end

CrazyRockHitSaveData.__init = __init
CrazyRockHitSaveData.__delete = __delete
return CrazyRockHitSaveData
