local GhostParkourLogger = BaseClass("GhostParkourLogger")
local util = require("Common.Tools.cjson.util")
local CommonCompressor = CS.CommonCompressor
local table_insert = table.insert
local table_clear = table.clear
local table_is_nil_or_empty = table.IsNullOrEmpty
local table_concat = table.concat
local string_pack = string.pack
local string_unpack = string.unpack
local tostring = _ENV.tostring
local os_date = os.date
local io_open = io.open
local os_remove = os.remove
local Logger = _ENV.Logger
local Directory = CS.System.IO.Directory
local File = CS.System.IO.File
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
local DEFAULT_BIT = 4
local VALID_BITS = {
  [2] = true,
  [4] = true
}
local MAX_CACHE_FILES = 100
local DELETE_RATIO = 0.2

function GhostParkourLogger:__init(uploadType)
  self.header = {}
  self.frameInfo = {}
  self.eventInfo = {}
  self.exitInfo = {}
  self.logCache = {}
  self.filePath = nil
  self.lastTimer = 0
  self.timerOffset = 0
  self.position = 1
  self.order = 0
  self.uploadType = uploadType or PVELogFuncType.Surfing
  self.isDebug = CS.CommonUtils.IsDebug()
  self.isEditor = CS.UnityEngine.Application.isEditor
  self.isPC = Config.IsPC()
  self.isAppendLog = not self.isEditor and self.isDebug and GMUtils.GetBool(GMConst.SurfingLogOutput, false)
  self.frameTabPool = {}
  self.frameTabCount = 0
end

function GhostParkourLogger:__delete()
  self.header = nil
  self.frameInfo = nil
  self.eventInfo = nil
  self.exitInfo = nil
  self.logCache = nil
  self.filePath = nil
  self.lastTimer = nil
  self.timerOffset = nil
  self.position = nil
  self.order = nil
  self.uploadType = nil
  self.isEditor = nil
  self.isDebug = nil
  self.isPC = nil
  self.isAppendLog = nil
  self.frameTabPool = nil
  self.frameTabCount = nil
end

local function PackBits(values, bit)
  bit = bit or DEFAULT_BIT
  if not VALID_BITS[bit] then
    Logger.LogError("GhostParkour -- [PackBits]: invalid bit length " .. bit)
    return
  end
  local out = {}
  local bitPos = 0
  local temp = 0
  local count = 0
  for i = 1, #values do
    local num = values[i]
    temp = temp | num << 8 - bit - bitPos
    bitPos = bitPos + bit
    if 8 <= bitPos then
      out[#out + 1] = string_pack("B", temp)
      temp = 0
      bitPos = bitPos - 8
    end
    count = count + 1
  end
  if 0 < bitPos then
    out[#out + 1] = string_pack("B", temp)
  end
  return table_concat(out, ""), count
end

local function UnpackBits(data, position, count, bit)
  bit = bit or DEFAULT_BIT
  if not VALID_BITS[bit] then
    Logger.LogError("GhostParkour -- [UnpackBits]: invalid bit length " .. bit)
    return
  end
  local numbers = {}
  local bitsInBuf = 0
  local tempByte = 0
  local flag = bit == 4 and 15 or 3
  for i = 1, count do
    if bitsInBuf == 0 then
      tempByte, position = string_unpack("<B", data, position)
      bitsInBuf = 8
    end
    bitsInBuf = bitsInBuf - bit
    local value = tempByte >> bitsInBuf & flag
    numbers[i] = value
  end
  return numbers, position
end

function GhostParkourLogger:LogStageId(stageId, uuid, startTs)
  self.header.stageId = stageId
  self.header.uuid = uuid or 0
  self.header.version = 10
  self.startTs = startTs
end

function GhostParkourLogger:LogDeadline(flag, posZ, timer)
  self.exitInfo[#self.exitInfo + 1] = {
    exitFlag = flag,
    deadline = posZ,
    deadTimer = timer
  }
end

function GhostParkourLogger:LogEvent(flag, speed, timer)
  self.eventInfo[#self.eventInfo + 1] = {eventFlag = flag, eventTimer = timer}
  if not self.eventLog then
    self.eventLog = string.format("flag = %s, timer = %s, speed = %s\n", tostring(flag), tostring(timer), tostring(speed))
  else
    self.eventLog = self.eventLog .. string.format("flag = %s, timer = %s, speed = %s\n", tostring(flag), tostring(timer), tostring(speed))
  end
end

function GhostParkourLogger:LogInput(input, timer, frame)
  local frameData = self:GetOrCreateFrame(frame)
  frameData.input = input
  frameData.timer = timer
  if self.isAppendLog then
    self:AppendLog(string.format("LogInput [%s] [%s]", tostring(input), tostring(timer)))
  end
end

function GhostParkourLogger:AppendLog(log)
  self.logCache[#self.logCache + 1] = log
end

function GhostParkourLogger:SaveLog(path)
  if not self.logCache or #self.logCache == 0 then
    return
  end
  local str = table_concat(self.logCache, "\n")
  Logger.Log("GhostParkour -- GhostParkour Log txt: \n" .. str)
  path = path or self:GetLogPath()
  path = path .. ".txt"
  local content = "GhostParkour Log txt: \n" .. str
  if self.isPC then
    local ok, err = util.cs_file_write(path, content)
    if not ok then
      Logger.LogError("GhostParkour -- PC cannot write log to " .. tostring(path) .. ", error: " .. (err or ""))
    end
    self.logCache = nil
    return
  end
  local f, err = io_open(path, "w")
  if f then
    f:write(content)
    f:close()
  else
    Logger.LogError("GhostParkour -- cannot write log to " .. tostring(path) .. ", error: " .. (err or ""))
  end
  self.logCache = nil
end

function GhostParkourLogger:SaveEventLog(path)
  if not self.eventLog then
    return
  end
  local tPath = path .. "_event.txt"
  if self.isPC then
    local ok, err = util.cs_file_write(tPath, self.eventLog)
    if not ok then
      Logger.LogError("GhostParkour -- PC cannot write event log to " .. tostring(tPath) .. ", error: " .. (err or ""))
    end
    self.eventLog = nil
    return
  end
  local f = io_open(tPath, "w")
  if f then
    f:write(self.eventLog)
    f:close()
  end
  self.eventLog = nil
end

function GhostParkourLogger:SaveSpeedLog(logStr, path)
  if not logStr or logStr == "" then
    return
  end
  Logger.Log("GhostParkour -- Speed Log txt: \n" .. logStr)
  path = path or self:GetLogPath()
  path = path .. "_speed.txt"
  local content = "GhostParkour Speed Log txt: \n" .. logStr
  if self.isPC then
    local ok, err = util.cs_file_write(path, content)
    if not ok then
      Logger.LogError("GhostParkour -- PC cannot write speed log to " .. tostring(path) .. ", error: " .. (err or ""))
    end
    return
  end
  local f = io_open(path, "w")
  if f then
    f:write(content)
    f:close()
  end
end

function GhostParkourLogger:WriteBytesToFile(data, path)
  if not data or data == "" then
    return
  end
  path = path or self:GetLogPath()
  local oriPath = path .. "_ori"
  ProfilerUtil.BeginSample("GhostParkourLogger:WriteBytesToFile")
  if self.isPC then
    local ok, err = util.cs_file_write(oriPath, data)
    if not ok then
      Logger.LogError("GhostParkour -- PC cannot write bytes to " .. tostring(oriPath) .. ", error: " .. (err or ""))
    end
    ProfilerUtil.EndSample()
    return
  end
  local file, err = io_open(oriPath, "ab")
  if not file then
    Logger.LogWarning("GhostParkour -- cannot open file: " .. oriPath .. ", error: " .. (err or ""))
    local p = self:GetLogDirectory()
    if not Directory.Exists(p) then
      Logger.LogWarning("GhostParkour -- file not Exists: " .. oriPath .. ", error: " .. (err or ""))
      Directory.CreateDirectory(p)
      file, err = io_open(oriPath, "ab")
    end
  end
  if not file then
    Logger.LogError("GhostParkour -- still cannot open file: " .. oriPath .. ", error: " .. (err or ""))
    ProfilerUtil.EndSample()
    return
  end
  file:write(data)
  file:close()
  ProfilerUtil.EndSample()
end

function GhostParkourLogger:GetOrCreateFrame(frame)
  if not self.frameInfo[frame] then
    local tab = self:GetOneFrameTable()
    self.order = self.order + 1
    tab.order = self.order
    self.frameInfo[frame] = tab
  end
  return self.frameInfo[frame]
end

function GhostParkourLogger:GetLogPath(fileName)
  if not fileName then
    if not self.filePath or self.filePath == "" then
      local startTs = self.startTs or SafeLocalOsTime()
      local fmt = os_date("*t", startTs)
      local timeStr = string.format("%04d%02d%02d_%02d%02d%02d", fmt.year, fmt.month, fmt.day, fmt.hour, fmt.min, fmt.sec)
      local stageId = self.header and (self.header.stageId or 0) or 0
      local uuid = self.header and (self.header.uuid or 0) or 0
      self.filePath = string.format("surfing_log_%s_%s_%s", timeStr, tostring(stageId), tostring(uuid))
    end
    fileName = self.filePath
  end
  if not self.path then
    local p = self:GetLogDirectory()
    self.path = p .. (fileName or "replay_" .. os_date("%Y%m%d_%H%M%S"))
  end
  return self.path
end

function GhostParkourLogger:GetLogDirectory()
  if not self.directoryPath then
    local name = SURFING_DOWNLOAD_LOG_PATH
    if self.uploadType == PVELogFuncType.GhostParkour then
      name = PVE_LOG_LOCAL_PATH .. PVELogFilePathName[self.uploadType]
    end
    self.directoryPath = CS.UnityEngine.Application.persistentDataPath .. name
  end
  return self.directoryPath
end

function GhostParkourLogger:GetOneFrameTable()
  if not (self.frameTabPool and self.frameTabCount) or self.frameTabCount == 0 then
    return {}
  end
  local tab = self.frameTabPool[self.frameTabCount]
  self.frameTabPool[self.frameTabCount] = nil
  self.frameTabCount = self.frameTabCount - 1
  return tab
end

function GhostParkourLogger:ReleaseFrameTable(tab)
  if table_is_nil_or_empty(tab) then
    return
  end
  self.frameTabPool = self.frameTabPool or {}
  self.frameTabCount = (self.frameTabCount or 0) + 1
  self.frameTabPool[self.frameTabCount] = tab
end

local function DeleteFile(self, path)
  if not path or path == "" then
    Logger.LogError("GhostParkour -- path is nil or empty")
    return false
  end
  if self.isPC then
    local ok, err = util.cs_file_delete(path)
    if not ok then
      Logger.LogWarning("GhostParkour -- PC delete failed : " .. err)
      return false
    end
    Logger.LogInfo("GhostParkour -- PC delete success : " .. path)
    return true
  end
  if File.Exists(path) then
    local success, err = os_remove(path)
    if not success then
      Logger.LogWarning("GhostParkour -- delete failed : " .. err)
      return false
    end
    Logger.LogInfo("GhostParkour -- delete success : " .. path)
    return true
  end
  return false
end

function GhostParkourLogger:SaveOutputLog(uuid, logStr)
  if not self.isEditor and not self.isDebug then
    return
  end
  local path
  if uuid and 0 < uuid then
    path = self:GetLogDirectory() .. uuid
  else
    path = self:GetLogPath()
  end
  local data = self:SerializeAll()
  if data then
    self:WriteBytesToFile(data, path)
  end
  local oriPath = path .. "_ori"
  ProfilerUtil.BeginSample("GhostParkourLogger:CompressFile")
  CommonCompressor.CompressFile(oriPath, path)
  ProfilerUtil.EndSample()
  if self.isAppendLog then
    self:SaveLog(path)
    self:SaveSpeedLog(logStr, path)
  end
  self:SaveEventLog(path)
end

local function ClearIfOverLimit(self, dirPath)
  if not Directory.Exists(dirPath) then
    return
  end
  local files = Directory.GetFiles(dirPath)
  if IsNull(files) then
    return
  end
  local count = files.Length
  if count <= MAX_CACHE_FILES then
    return
  end
  local removeCount = math.max(1, math.ceil(count * DELETE_RATIO))
  Logger.Log(string.format("\231\188\147\229\173\152\230\150\135\228\187\182\230\149\176 %d \232\182\133\229\135\186\228\184\138\233\153\144 %d\239\188\140\229\136\160\233\153\164 %d \228\184\170\230\150\135\228\187\182", count, MAX_CACHE_FILES, removeCount))
  for i = 0, removeCount - 1 do
    local path = files[i]
    DeleteFile(self, path)
  end
end

function GhostParkourLogger:SaveAll(uuid, callback, logStr, beginTime)
  local path
  if uuid and 0 < uuid then
    path = self:GetLogDirectory() .. uuid
  else
    path = self:GetLogPath()
  end
  local data = self:SerializeAll()
  if data then
    self:WriteBytesToFile(data, path)
  end
  local oriPath = path .. "_ori"
  ProfilerUtil.BeginSample("GhostParkourLogger:CompressFile")
  local ok, result = pcall(function()
    CommonCompressor.CompressFile(oriPath, path)
  end)
  if ok then
    Logger.LogInfo("GhostParkour -- CompressFile log success")
  else
    if callback then
      callback(uuid, false)
    end
    Logger.LogError("GhostParkour -- CompressFile log error:" .. tostring(result))
    ProfilerUtil.EndSample()
    return
  end
  ProfilerUtil.EndSample()
  if self.isAppendLog then
    self:SaveLog()
    self:SaveSpeedLog(logStr)
  end
  self:SaveEventLog(path)
  uuid = uuid or self.header and self.header.uuid or 0
  if 0 < uuid then
    ok, result = pcall(function()
      self:UploadLog(uuid, path, callback, beginTime)
    end)
    if ok then
      Logger.LogInfo("GhostParkour -- upload log success")
    else
      if callback then
        callback(uuid, false)
      end
      Logger.LogError("GhostParkour -- upload log error:" .. result)
    end
  end
end

function GhostParkourLogger:UploadFile(uuid, callback, beginTime)
  if not uuid or uuid == 0 then
    return
  end
  local path = self:GetLogDirectory() .. uuid
  local oriPath = path .. "_ori"
  ProfilerUtil.BeginSample("GhostParkourLogger:CompressFile")
  local ok, result = pcall(function()
    CommonCompressor.CompressFile(oriPath, path)
  end)
  if ok then
    Logger.LogInfo("GhostParkour -- CompressFile log success")
  else
    if callback then
      callback(uuid, false)
    end
    Logger.LogError("GhostParkour -- CompressFile log error:" .. tostring(result))
    ProfilerUtil.EndSample()
    return
  end
  ProfilerUtil.EndSample()
  ok, result = pcall(function()
    self:UploadLog(uuid, path, callback, beginTime)
  end)
  if ok then
    Logger.LogInfo("GhostParkour -- upload log success")
  else
    if callback then
      callback(uuid, false)
    end
    Logger.LogError("GhostParkour -- upload log error:" .. tostring(result))
  end
end

function GhostParkourLogger:UploadLog(uuid, path, callback, beginTime)
  local funcType = self.uploadType or PVELogFuncType.Surfing
  CS.PVELogManager.Instance:UploadPVESurfingLogFile(LuaEntry.Player.uid, tostring(uuid), path, function(succeed)
    Logger.LogInfo("GhostParkour -- pveLogUpload : " .. tostring(uuid) .. tostring(succeed))
    if callback then
      callback(uuid, succeed)
    end
  end, funcType, tostring(beginTime))
end

function GhostParkourLogger:DeleteLog()
  ClearIfOverLimit(self, self:GetLogDirectory())
end

local function CheckLocalFile(path)
  if File.Exists(path) then
    return true
  end
  return false
end

function GhostParkourLogger:DownloadLogFile(uid, uuid, callback)
  if not uid or uid == "" then
    Logger.LogError("GhostParkour -- DownloadLogFile uid error")
    return false
  end
  if not uuid or uuid == "" then
    Logger.LogError("GhostParkour -- DownloadLogFile uuid error")
    return false
  end
  local path = self:GetLogDirectory() .. uuid
  if CheckLocalFile(path) then
    local recordInfo = self:ReadRecords(path)
    if recordInfo then
      if callback then
        callback(recordInfo)
      end
      DataCenter.LWGhostParkourDataManager:LoadLogTrack(uuid, true, true)
      return true
    else
      DataCenter.LWGhostParkourDataManager:LoadLogTrack(uuid, true, true)
      return false
    end
  end
  local funcType = self.uploadType or PVELogFuncType.Surfing
  CS.PVELogManager.Instance:DownloadPVESurfingLog(uid, tostring(uuid), path, function(succeed)
    Logger.Log("pveLogDownload : " .. tostring(succeed) .. "  " .. tostring(uuid))
    DataCenter.LWGhostParkourDataManager:LoadLogTrack(uuid, succeed, false)
    if succeed then
      local recordInfo = self:ReadRecords(path)
      recordInfo = recordInfo or nil
      if callback then
        callback(recordInfo)
      end
    elseif callback then
      callback()
    end
  end, funcType)
  return true
end

function GhostParkourLogger:Exit()
  if self.isEditor then
    return
  end
  local path = self:GetLogPath()
  local oriPath = path .. "_ori"
  DeleteFile(self, oriPath)
end

function GhostParkourLogger:SerializeAll()
  local parts = {}
  parts[#parts + 1] = self:SerializeHeader(self.header, true)
  parts[#parts + 1] = self:SerializeExitInfo()
  parts[#parts + 1] = self:SerializeEventInfo()
  parts[#parts + 1] = self:SerializeFrames(self.frameInfo)
  table_clear(self.frameInfo)
  return table_concat(parts)
end

function GhostParkourLogger:SerializeHeader(header, notSeri)
  if not header then
    return ""
  end
  local recordType = RECORD_TYPES.HEADER
  local data = string_pack("<BI4I8B", recordType, header.stageId or 0, header.uuid or 0, header.version or 0)
  if not notSeri then
    self:WriteBytesToFile(data)
  else
    return data
  end
end

function GhostParkourLogger:SerializeExitInfo()
  if table_is_nil_or_empty(self.exitInfo) then
    return ""
  end
  local parts = {}
  for _, v in ipairs(self.exitInfo) do
    parts[#parts + 1] = string_pack("<BBff", RECORD_TYPES.EXIT_INFO, v.exitFlag, v.deadline, v.deadTimer)
  end
  table_clear(self.exitInfo)
  return table_concat(parts)
end

function GhostParkourLogger:SerializeEventInfo()
  if table_is_nil_or_empty(self.eventInfo) then
    return ""
  end
  local parts = {}
  for _, v in ipairs(self.eventInfo) do
    parts[#parts + 1] = string_pack("<BBf", RECORD_TYPES.EVENT_DATA, v.eventFlag, v.eventTimer)
  end
  table_clear(self.eventInfo)
  return table_concat(parts)
end

function GhostParkourLogger:SerializeFrames(frames)
  ProfilerUtil.BeginSample("GhostParkourLogger:SerializeFrames")
  if not frames then
    ProfilerUtil.EndSample()
    return ""
  end
  local lData = {}
  for _, v in pairs(frames) do
    lData[v.order] = self:SerializeFrame(v)
    self:ReleaseFrameTable(v)
  end
  local data = table_concat(lData)
  ProfilerUtil.EndSample()
  return data
end

function GhostParkourLogger:SerializeFrame(record)
  if not record or record.input == nil then
    return ""
  end
  return string_pack("<B f B", RECORD_TYPES.FRAME_DATA, record.timer, record.input)
end

function GhostParkourLogger:ReadRecords(path)
  if not path or path == "" then
    Logger.LogError("GhostParkour -- ReadRecords path error")
    return false
  end
  local tarPath = path .. "_compress"
  ProfilerUtil.BeginSample("GhostParkourLogger:DecompressFile")
  local ok, result = pcall(function()
    CommonCompressor.DecompressFile(path, tarPath)
  end)
  if ok then
    Logger.LogInfo("GhostParkour -- DecompressFile log success")
  else
    DeleteFile(self, path)
    DeleteFile(self, tarPath)
    Logger.LogError("GhostParkour -- DecompressFile log error:" .. tostring(result))
    return false
  end
  ProfilerUtil.EndSample()
  if self.isPC then
    local success, data, err = util.cs_file_read(tarPath)
    if success then
      Logger.LogInfo("GhostParkour -- PC ReadRecords read data success")
      DeleteFile(self, tarPath)
      self.position = 1
      return self:SubDeserialize(data)
    else
      Logger.LogError("GhostParkour -- PC ReadRecords cannot open file: " .. tarPath .. ", error: " .. (err or ""))
      return false
    end
  end
  local file, err = io_open(tarPath, "rb")
  if not file then
    Logger.LogError("GhostParkour -- ReadRecords cannot open file: " .. tarPath .. ", error: " .. (err or ""))
    return false
  end
  local content = file:read("*a")
  file:close()
  DeleteFile(self, tarPath)
  self.position = 1
  return self:SubDeserialize(content)
end

function GhostParkourLogger:SubDeserialize(content)
  if not content or content == "" then
    return false
  end
  local records, eventInfo, header, buffInfo, exitInfo
  local position = self.position or 1
  while position <= #content do
    local recordType, offset = string_unpack("<B", content, position)
    position = offset
    if recordType == RECORD_TYPES.HEADER then
      header = header or {}
      header.stageId, header.uuid, header.version, offset = string_unpack("<I4I8B", content, position)
      position = offset
      header.recordType = "header"
    elseif recordType == RECORD_TYPES.BUFF_INFO then
      local count
      count, offset = string_unpack("<B", content, position)
      position = offset
      if 0 < count then
        buffInfo = buffInfo or {}
        for _ = 1, count do
          local value
          value, offset = string_unpack("<B", content, position)
          position = offset
          local t = value >> 4 & 63
          local lvl = value & 15
          buffInfo[t] = lvl
        end
      end
      local endF
      endF, offset = string_unpack("<B", content, position)
      if endF ~= RECORD_TYPES.BUFF_INFO_END then
        Logger.LogError("GhostParkour -- [verify error] BUFF_INFO tail mismatch")
      end
      position = offset
    elseif recordType == RECORD_TYPES.EXIT_INFO then
      local info = {}
      info.exitFlag, info.deadline, info.deadTimer, offset = string_unpack("<Bff", content, position)
      position = offset
      exitInfo = exitInfo or {}
      table_insert(exitInfo, info)
    elseif recordType == RECORD_TYPES.FRAME_DATA then
      local frameRecord = {}
      frameRecord.timer, frameRecord.input, offset = string_unpack("<fB", content, position)
      position = offset
      frameRecord.recordType = "frame_data"
      records = records or {}
      table_insert(records, frameRecord)
    elseif recordType == RECORD_TYPES.EVENT_DATA then
      local info = {}
      info.eventFlag, info.eventTimer, offset = string_unpack("<Bf", content, position)
      position = offset
      eventInfo = eventInfo or {}
      table_insert(eventInfo, info)
    else
      if recordType == RECORD_TYPES.SUB_END then
        break
      end
      Logger.LogWarning("GhostParkour -- unknown recordType: " .. tostring(recordType))
    end
  end
  self.position = position
  return {
    header = header,
    frameInfo = records,
    eventInfo = eventInfo,
    buffInfo = buffInfo,
    exitInfo = exitInfo
  }
end

return GhostParkourLogger
