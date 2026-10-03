local SurfingLogger = BaseClass("SurfingLogger")
local CommonCompressor = CS.CommonCompressor
local table_insert = table.insert
local table_clear = table.clear
local table_IsNullOrEmpty = table.IsNullOrEmpty
local table_concat = table.concat
local string_pack = string.pack
local string_unpack = string.unpack
local RECORD_TYPES = {
  HEADER = 1,
  BUFF_INFO = 2,
  BUFF_INFO_END = 3,
  FRAME_DATA = 4,
  OBJ_DATA = 5,
  OBJ_DATA_END = 6,
  EVENT_DATA = 7,
  SUB_END = 8,
  EXIT_INFO = 9
}
local CACHE_MAX_COUNT = 5

function SurfingLogger:__init(uploadType, isEditor, isDebug)
  self.header = {}
  self.frameInfo = {}
  self.eventInfo = {}
  self.objInfo = {}
  self.buffInfoDic = {}
  self.exitInfo = {}
  self.stageSceneIds = {}
  self.monsterLog = {}
  self.logCache = {}
  self.curFrame = 0
  self.filePath = nil
  self.lastTimer = 0
  self.timerOffset = 0
  self.position = 1
  self.sceneIndex = 0
  self.order = 0
  self.uploadType = uploadType or PVELogFuncType.Surfing
  self.isEditor = isEditor
  self.isDebug = isDebug
  self.isAppendLog = isEditor or isDebug and GMUtils.GetBool(GMConst.SurfingLogOutput, false)
  self.frameTabPool = {}
  self.frameTabCount = 0
end

function SurfingLogger:__delete()
  self.header = nil
  self.frameInfo = nil
  self.eventInfo = nil
  self.objInfo = nil
  self.exitInfo = nil
  self.stageSceneIds = nil
  self.curFrame = nil
  self.filePath = nil
  self.lastTimer = nil
  self.timerOffset = nil
  self.position = nil
  self.sceneIndex = nil
  self.order = nil
  self.frameTabPool = nil
  self.frameTabCount = nil
end

function SurfingLogger:OnUpdate(deltaTime)
  self:StartFrame()
end

local function PackBits(values, bit)
  local bitPosition = 0
  local tempByte = 0
  local count = 0
  bit = bit or 4
  local data = ""
  for _, num in ipairs(values) do
    tempByte = tempByte | num << 8 - bit - bitPosition
    bitPosition = bitPosition + bit
    if 8 <= bitPosition then
      data = data .. string.pack("B", tempByte)
      tempByte = 0
      bitPosition = bitPosition - 8
    end
    count = count + 1
  end
  if 0 < bitPosition then
    data = data .. string.pack("B", tempByte)
  end
  return data, count
end

local function UnpackBits(data, position, count, bit)
  local numbers = {}
  local bitsInBuffer = 0
  bit = bit or 4
  local tempByte, offset, value
  local flag = bit == 4 and 15 or 3
  for i = 1, count do
    if bitsInBuffer == 0 then
      tempByte, offset = string_unpack("<B", data, position)
      position = offset
      bitsInBuffer = 8
    end
    bitsInBuffer = bitsInBuffer - bit
    value = tempByte >> bitsInBuffer & flag
    numbers[i] = value
  end
  return numbers, position
end

function SurfingLogger:AppendMonsterLog(index, level, mId)
  table_insert(self.monsterLog, "index = " .. index .. " level = " .. (level or 0) .. "  mId = " .. mId)
end

function SurfingLogger:LogStageId(stageId, uuid, startTs)
  self.header.stageId = stageId
  self.header.uuid = uuid or 0
  self.header.version = 10
  self.startTs = startTs
  self:SerializeHeader(self.header)
end

function SurfingLogger:LogDeadline(flag, posZ, timer)
  local info = {
    exitFlag = flag,
    deadline = posZ,
    deadTimer = timer
  }
  table_insert(self.exitInfo, info)
end

function SurfingLogger:LogEvent(flag, timer, speed)
  local info = {eventFlag = flag, eventTimer = timer}
  if self.eventLog == nil then
    self.eventLog = "flag = " .. flag .. ", timer = " .. timer .. ", speed = " .. speed .. "\n"
  else
    self.eventLog = self.eventLog .. "flag = " .. flag .. ", timer = " .. timer .. ", speed = " .. speed .. "\n"
  end
  table_insert(self.eventInfo, info)
end

function SurfingLogger:LogInput(input, timer)
  local frame = self.curFrame
  local frameData = self:GetOrCreateFrame(frame)
  frameData.input = input
  frameData.timer = timer
  if self.isAppendLog then
    self:AppendLog("LogInput " .. "[" .. input .. "] [" .. timer .. "]")
  end
end

function SurfingLogger:LogSceneIds(stageSceneId)
  table_insert(self.stageSceneIds, stageSceneId)
  self.sceneIndex = self.sceneIndex + 1
  if self.sceneIndex >= CACHE_MAX_COUNT then
    self:SerializeData()
    self.sceneIndex = 0
    self.curFrame = 0
  end
end

function SurfingLogger:LogMonsterObj(index, level, mId)
  if index then
    table_insert(self.objInfo, index)
    if self.isAppendLog then
      self:AppendMonsterLog(index, level, mId)
    end
  end
end

function SurfingLogger:StartFrame()
  self.curFrame = self.curFrame + 1
end

function SurfingLogger:GetCurrentFrame()
  return self.curFrame
end

function SurfingLogger:AppendLog(log)
  table_insert(self.logCache, log)
end

function SurfingLogger:SerializeData()
  ProfilerUtil.BeginSample("SurfingLogic:SerializeFile")
  local data = self:Serialize()
  ProfilerUtil.EndSample()
  self:WriteBytesToFile(data)
end

function SurfingLogger:WriteBytesToFile(data, path)
  if string.IsNullOrEmpty(data) then
    return
  end
  path = path or self:GetLogPath()
  local oriPath = path .. "_ori"
  ProfilerUtil.BeginSample("SurfingLogic:WriteBytesToFile")
  local file, err = io.open(oriPath, "ab")
  if not file then
    Logger.LogWarning("Surfing -- cannot open file: " .. oriPath .. ", error:" .. (err or ""))
    local p = self:GetLogDirectory()
    if not CS.System.IO.Directory.Exists(p) then
      CS.System.IO.Directory.CreateDirectory(p)
      file, err = io.open(oriPath, "ab")
    end
  end
  if not file then
    Logger.LogError("Surfing -- still cannot open file: " .. oriPath .. ", error:" .. (err or ""))
    ProfilerUtil.EndSample()
    return
  end
  file:write(data)
  file:close()
  ProfilerUtil.EndSample()
end

function SurfingLogger:SaveLog(path)
  if self.logCache then
    local str = table_concat(self.logCache, "\n")
    Logger.Log("Surfing -- Surfing Log txt: \n" .. str)
    path = path or self:GetLogPath()
    path = path .. ".txt"
    local f = io.open(path, "w")
    if f then
      f:write("Surfing Log txt: \n" .. str)
      f:close()
    end
    self.logCache = nil
  end
end

function SurfingLogger:SaveSceneIdsLog(path)
  if self.stageSceneIds then
    local ids = table_concat(self.stageSceneIds, ",")
    Logger.Log("Surfing -- Surfing Scene txt: \n" .. ids)
    local tPath = path .. "_scene.txt"
    local f = io.open(tPath, "w")
    if f then
      f:write(ids)
      f:close()
    end
    self.stageSceneIds = nil
  end
end

function SurfingLogger:SaveMonstersLog(path)
  if self.monsterLog then
    local ids = table_concat(self.monsterLog, "\n")
    Logger.Log("Surfing -- Surfing monster txt: \n" .. ids)
    local tPath = path .. "_monster.txt"
    local f = io.open(tPath, "w")
    if f then
      f:write(ids)
      f:close()
    end
    self.monsterLog = nil
  end
end

function SurfingLogger:SaveSpeedLog(logStr, path)
  if not string.IsNullOrEmpty(logStr) then
    Logger.Log("Surfing -- Speed Log txt: \n" .. logStr)
    path = path or self:GetLogPath()
    path = path .. "_speed.txt"
    local f = io.open(path, "w")
    if f then
      f:write("Surfing Log txt: \n" .. logStr)
      f:close()
    end
  end
end

function SurfingLogger:GetSceneIds(filename)
  if string.IsNullOrEmpty(filename) then
    Logger.LogError("Surfing -- scene id config is nil")
    return
  end
  local path = self:GetLogPath(filename)
  path = path .. "_scene.txt"
  local file, err = io.open(path, "rb")
  if not file then
    Logger.LogError("Surfing -- cannot open file, error: " .. (err or ""))
    return
  end
  local content = file:read("*a")
  file:close()
  return content
end

local function DeleteFile(path)
  if string.IsNullOrEmpty(path) then
    Logger.LogError("Surfing -- path is nil or empty")
    return false
  end
  local success, err = os.remove(path)
  if not success then
    Logger.LogWarning("Surfing -- delete failed : " .. err)
    return false
  end
  Logger.LogInfo("Surfing -- delete success : " .. path)
  return true
end

function SurfingLogger:Save()
  self:SerializeData()
  local path = self:GetLogPath()
  local oriPath = path .. "_ori"
  ProfilerUtil.BeginSample("SurfingLogic:CompressFile")
  CommonCompressor.CompressFile(oriPath, path)
  ProfilerUtil.EndSample()
  if self.isAppendLog then
    self:SaveLog()
    self:SaveSceneIdsLog(path)
    self:SaveMonstersLog(path)
  end
  local uuid = self.header.uuid
  if 0 < uuid then
    local ok, result = pcall(function()
      self:UploadLog(uuid, oriPath, path)
    end)
    if ok then
      Logger.LogInfo("Surfing -- upload log success")
    else
      Logger.LogError("Surfing -- upload log error:", result)
    end
  end
end

function SurfingLogger:UploadLog(uuid, oriPath, path, callback, beginTime)
  local funcType = self.uploadType or PVELogFuncType.Surfing
  CS.PVELogManager.Instance:UploadPVESurfingLogFile(LuaEntry.Player.uid, tostring(uuid), path, function(succeed)
    Logger.LogInfo("Surfing -- pveLogUpload : " .. uuid .. tostring(succeed))
    if callback then
      callback(uuid, succeed)
    end
  end, funcType, tostring(beginTime))
end

function SurfingLogger:Exit()
  if self.isEditor then
    return
  end
  local path = self:GetLogPath()
  local oriPath = path .. "_ori"
  DeleteFile(oriPath)
end

function SurfingLogger:GetOrCreateFrame(frame)
  if not self.frameInfo[frame] then
    local tab = self:GetOneFrameTable()
    self.order = self.order + 1
    tab.order = self.order
    self.frameInfo[frame] = tab
  end
  return self.frameInfo[frame]
end

function SurfingLogger:GetLogPath(fileName)
  if fileName == nil then
    if string.IsNullOrEmpty(self.filePath) then
      local startTs = self.startTs
      local format = os.date("*t", startTs)
      local timeStr = string.format("%d%0d%0d_%02d%02d%02d", format.year, format.month, format.day, format.hour, format.min, format.sec)
      local stageId = self.header.stageId or 0
      local uuid = self.header.uuid or 0
      self.filePath = string.format("surfing_log_%s_%s_%s", timeStr, stageId, uuid)
    end
    fileName = self.filePath
  end
  if self.path == nil then
    local path = self:GetLogDirectory()
    self.path = path .. (fileName or "replay_" .. os.date("%Y%m%d_%H%M%S"))
  end
  return self.path
end

function SurfingLogger:GetLogDirectory()
  if self.directoryPath == nil then
    local name = SURFING_DOWNLOAD_LOG_PATH
    if self.uploadType == PVELogFuncType.GhostParkour then
      name = PVE_LOG_LOCAL_PATH .. PVELogFilePathName[self.uploadType]
    end
    self.directoryPath = CS.UnityEngine.Application.persistentDataPath .. name
  end
  return self.directoryPath
end

function SurfingLogger:GetOneFrameTable()
  if self.frameTabPool == nil or self.frameTabCount == nil or self.frameTabCount == 0 then
    return {}
  end
  local tab = self.frameTabPool[self.frameTabCount]
  self.frameTabPool[self.frameTabCount] = nil
  self.frameTabCount = self.frameTabCount - 1
  return tab
end

function SurfingLogger:ReleaseFrameTable(tab)
  if table_IsNullOrEmpty(tab) then
    return
  end
  if self.frameTabPool == nil then
    self.frameTabPool = {}
  end
  if self.frameTabCount == nil then
    self.frameTabCount = 0
  end
  local count = self.frameTabCount + 1
  self.frameTabCount = count
  self.frameTabPool[count] = tab
end

function SurfingLogger:ReleaseFrameTables(tabs)
  if table_IsNullOrEmpty(tabs) then
    return
  end
  if self.frameTabPool == nil then
    self.frameTabPool = {}
  end
  if self.frameTabCount == nil then
    self.frameTabCount = 0
  end
  local index = self.frameTabCount
  local count = #tabs
  for i = 1, count do
    index = index + 1
    self.frameTabPool[index] = tabs[i]
    tabs[i] = nil
  end
  self.frameTabCount = index
end

function SurfingLogger:Serialize()
  local serialized = {}
  table_insert(serialized, self:SerializeFrames(self.frameInfo))
  table_insert(serialized, self:SerializeObjs(self.objInfo))
  table_insert(serialized, self:SerializeExitInfo())
  table_insert(serialized, self:SerializeEventInfo())
  if not table_IsNullOrEmpty(self.frameInfo) then
    table_clear(self.frameInfo)
  end
  self.order = 0
  if not table_IsNullOrEmpty(self.objInfo) then
    table_clear(self.objInfo)
  end
  local result = table_concat(serialized) .. string_pack("<B", RECORD_TYPES.SUB_END)
  return result
end

function SurfingLogger:SerializeHeader(header)
  if header == nil then
    return ""
  end
  local recordType = RECORD_TYPES.HEADER
  local data = string_pack("<BI4I8B", recordType, header.stageId, header.uuid, header.version)
  data = data .. self:SerializeBuffInfo()
  self:WriteBytesToFile(data)
end

function SurfingLogger:SerializeBuffInfo()
  local data
  local buffList = DataCenter.LWSurfingDataManager:GetSurfingBuffData()
  if buffList then
    data = string_pack("<B", RECORD_TYPES.BUFF_INFO)
    local id, meta, level, type, value
    local count = 0
    local bData = ""
    for _, v in ipairs(buffList) do
      id = v.id
      meta = DataCenter.LWSurfingBuffTemplateManager:GetTemplate(id)
      if meta then
        level = meta.level
        type = v.type
        value = type << 4 | level
        bData = bData .. string_pack("<B", value)
        count = count + 1
      end
    end
    data = data .. string_pack("<B", count) .. bData .. string_pack("<B", RECORD_TYPES.BUFF_INFO_END)
  end
  return data or ""
end

function SurfingLogger:SerializeExitInfo()
  local data = ""
  if not table_IsNullOrEmpty(self.exitInfo) then
    for _, v in ipairs(self.exitInfo) do
      data = data .. string_pack("<BBff", RECORD_TYPES.EXIT_INFO, v.exitFlag, v.deadline, v.deadTimer)
    end
    table_clear(self.exitInfo)
  end
  return data
end

function SurfingLogger:SerializeEventInfo()
  local data = ""
  local str = ""
  if not table_IsNullOrEmpty(self.eventInfo) then
    for _, v in ipairs(self.eventInfo) do
      data = data .. string_pack("<BBf", RECORD_TYPES.EVENT_DATA, v.eventFlag, v.eventTimer)
      str = "eventFlag = " .. v.eventFlag .. ", eventTimer = " .. v.eventTimer
    end
    table_clear(self.eventInfo)
  end
  return data
end

function SurfingLogger:SerializeFrames(frames)
  local data = ""
  ProfilerUtil.BeginSample("SurfingLogic:SerializeFrames")
  if frames then
    local lData = {}
    for _, v in pairs(frames) do
      lData[v.order] = self:SerializeFrame(v)
      self:ReleaseFrameTable(v)
    end
    data = table_concat(lData)
  end
  ProfilerUtil.EndSample()
  return data
end

function SurfingLogger:SerializeFrame(record)
  local data
  if record and record.input ~= nil then
    data = string_pack("<B f B", RECORD_TYPES.FRAME_DATA, record.timer, record.input)
  end
  return data or ""
end

function SurfingLogger:SerializeObjs(objs)
  local data
  ProfilerUtil.BeginSample("SurfingLogic:SerializeObjs")
  if objs then
    local recordType = RECORD_TYPES.OBJ_DATA
    data = string_pack("<B", recordType)
    local oData, count = PackBits(objs)
    data = data .. string_pack("<B", count)
    data = data .. oData .. string_pack("<B", RECORD_TYPES.OBJ_DATA_END)
  end
  ProfilerUtil.EndSample()
  return data or ""
end

function SurfingLogger:ReadRecords(path)
  if string.IsNullOrEmpty(path) then
    return
  end
  local tarPath = path .. "_compress"
  ProfilerUtil.BeginSample("SurfingLogic:DecompressFile")
  CommonCompressor.DecompressFile(path, tarPath)
  ProfilerUtil.EndSample()
  local file, err = io.open(tarPath, "rb")
  if not file then
    Logger.LogError("Surfing -- cannot open file, error: " .. (err or ""))
    return
  end
  local content = file:read("*a")
  file:close()
  DeleteFile(tarPath)
  return self:SubDeserialize(content)
end

function SurfingLogger:ReadSubRecords(filename)
  if string.IsNullOrEmpty(filename) then
    return
  end
  local path = self:GetLogDirectory()
  path = path .. filename
  return self:ReadRecords(path)
end

function SurfingLogger:SubDeserialize(content)
  if not content then
    return
  end
  local records, eventInfo, header, objInfo, buffInfo, exitInfo
  local position = self.position or 1
  while position <= #content do
    local recordType, offset = string_unpack("<B", content, position)
    position = offset
    if recordType == RECORD_TYPES.HEADER then
      if header == nil then
        header = {}
      end
      header.stageId, header.uuid, header.version, offset = string_unpack("<I4I8B", content, position)
      position = offset
      header.recordType = "header"
    elseif recordType == RECORD_TYPES.BUFF_INFO then
      local count
      count, offset = string_unpack("<B", content, position)
      position = offset
      if 0 < count then
        if buffInfo == nil then
          buffInfo = {}
        end
        local value, level, type
        for _ = 1, count do
          value, offset = string_unpack("<B", content, position)
          type = value >> 4 & 63
          level = value & 15
          position = offset
          buffInfo[type] = level
        end
      end
      local endF
      endF, offset = string_unpack("<B", content, position)
      if endF ~= RECORD_TYPES.BUFF_INFO_END then
        Logger.LogError("Surfing -- [verify error] recordType = " .. recordType .. " count = " .. count)
      end
      position = offset
    elseif recordType == RECORD_TYPES.EXIT_INFO then
      local info = {}
      info.exitFlag, info.deadline, info.deadTimer, offset = string_unpack("<Bff", content, position)
      if exitInfo == nil then
        exitInfo = {}
      end
      table_insert(exitInfo, info)
      position = offset
    elseif recordType == RECORD_TYPES.FRAME_DATA then
      local frameRecord = {}
      frameRecord.timer, frameRecord.input, offset = string_unpack("<fB", content, position)
      position = offset
      frameRecord.recordType = "frame_data"
      if records == nil then
        records = {}
      end
      table_insert(records, frameRecord)
    elseif recordType == RECORD_TYPES.EVENT_DATA then
      local info = {}
      info.eventFlag, info.eventTimer, offset = string_unpack("<Bf", content, position)
      if eventInfo == nil then
        eventInfo = {}
      end
      table_insert(eventInfo, info)
      position = offset
    elseif recordType == RECORD_TYPES.OBJ_DATA then
      local count
      count, offset = string_unpack("<B", content, position)
      position = offset
      if 0 < count then
        objInfo, position = UnpackBits(content, position, count)
      end
      local endF
      endF, offset = string_unpack("<B", content, position)
      if endF ~= RECORD_TYPES.OBJ_DATA_END then
        Logger.LogError("Surfing -- [verify error] recordType = " .. recordType .. " count = " .. count)
      end
      position = offset
    elseif recordType == RECORD_TYPES.SUB_END then
      break
    end
  end
  self.position = position
  return {
    header = header,
    frameInfo = records,
    eventInfo = eventInfo,
    objInfo = objInfo,
    buffInfo = buffInfo,
    exitInfo = exitInfo
  }
end

return SurfingLogger
