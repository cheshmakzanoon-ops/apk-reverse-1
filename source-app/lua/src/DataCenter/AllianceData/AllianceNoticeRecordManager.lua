local AllianceNoticeRecordManager = BaseClass("AllianceNoticeRecordManager")
local AllianceNoticeRecordData = require("DataCenter/AllianceData/AllianceNoticeRecordData")
local onceReqGetDataNum = 10
local maxCount = 100
local startReqTime = 86400000

function AllianceNoticeRecordManager:__init()
  self.isAlBaseDataDirty = true
  self.reqAlId = nil
  self.alTypeDataDict = {}
  self.alDataDict = {}
  self.alTypeDataFinDict = {}
  self.alTypeNextStartReqTime = {}
  self:AddListener()
end

function AllianceNoticeRecordManager:__delete()
  self.isAlBaseDataDirty = nil
  self.reqAlId = nil
  self.alTypeDataDict = nil
  self.alDataDict = nil
  self.alTypeDataFinDict = nil
  self.alTypeNextStartReqTime = nil
  self:RemoveListener()
end

function AllianceNoticeRecordManager:ClearAllData()
  self.reqAlId = nil
  self.alTypeDataDict = {}
  self.alDataDict = {}
  self.alTypeDataFinDict = {}
  self.alTypeNextStartReqTime = {}
end

function AllianceNoticeRecordManager:ClearNextReqTime()
  self.alTypeNextStartReqTime = {}
end

function AllianceNoticeRecordManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.AllianceBaseDataUpdated, self.SetAlBaseDataDirty)
end

function AllianceNoticeRecordManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.AllianceBaseDataUpdated, self.SetAlBaseDataDirty)
end

function AllianceNoticeRecordManager.SetAlBaseDataDirty()
  DataCenter.AllianceNoticeRecordManager.isAlBaseDataDirty = true
end

function AllianceNoticeRecordManager:CheckDataIsNeedAllRefresh()
  local isClear = false
  if self.isAlBaseDataDirty == true then
    self.isAlBaseDataDirty = false
    local aid = ChatInterface.getAllianceId()
    if aid == nil or aid ~= self.reqAlId then
      self:ClearAllData()
      self.reqAlId = aid
      isClear = true
    end
  end
  return isClear
end

function AllianceNoticeRecordManager:GetDataById(id)
  return self.alDataDict[id]
end

function AllianceNoticeRecordManager:GetDataIdList(filterType)
  local isClear = self:CheckDataIsNeedAllRefresh()
  local dataList = {}
  if self.alTypeDataDict[filterType] then
    dataList = self.alTypeDataDict[filterType]
  end
  return dataList
end

function AllianceNoticeRecordManager:TryReqMoreRecordData(filterType)
  local isClear = self:CheckDataIsNeedAllRefresh()
  if self.reqAlId == nil then
    return
  end
  if self.alTypeDataFinDict[filterType] == true then
    return
  end
  local lastTime = 0
  local lastUid = 0
  if self.alTypeDataDict[filterType] and 0 < #self.alTypeDataDict[filterType] then
    local listLen = #self.alTypeDataDict[filterType]
    local id = self.alTypeDataDict[filterType][listLen]
    local data = self.alDataDict[id]
    lastTime = data.time
    lastUid = data.uuid
  end
  self:ReqRecordData(filterType, lastTime, lastUid)
end

function AllianceNoticeRecordManager:TryReqStartRecordData(filterType)
  local isClear = self:CheckDataIsNeedAllRefresh()
  if self.reqAlId == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.alTypeNextStartReqTime[filterType] and curTime < self.alTypeNextStartReqTime[filterType] then
    return
  end
  self.alTypeNextStartReqTime[filterType] = curTime + startReqTime
  local lastTime = 0
  local lastUid = 0
  self:ReqRecordData(filterType, lastTime, lastUid)
end

function AllianceNoticeRecordManager:ReqRecordData(filterType, lastTime, lastUid)
  SFSNetwork.SendMessage(MsgDefines.AllianceNoticeOperateNotes, self.reqAlId, filterType, lastTime, lastUid)
end

function AllianceNoticeRecordManager:GetRecordDataListMsg(msg)
  local alId = msg.allianceId
  if alId ~= self.reqAlId then
    return
  end
  local filterType = msg.opType
  local dataList = msg.opLogs
  local listLen = dataList and #dataList or 0
  if listLen < onceReqGetDataNum then
    self.alTypeDataFinDict[filterType] = true
  end
  if listLen == 0 then
    return
  end
  local lastTime = msg.lastTime
  local lastUid = msg.uuid
  if self.alTypeDataDict[filterType] == nil then
    self.alTypeDataDict[filterType] = {}
  end
  local curList = self.alTypeDataDict[filterType]
  local curListLen = #curList
  local isReAddData = false
  if curListLen == 0 then
    isReAddData = true
    for i = 1, listLen do
      local data = dataList[i]
      curList[i] = data.uuid
      self:AddDataToAlDataDict(data)
    end
  elseif lastTime == 0 and lastUid == 0 then
    local curFirstId = curList[1]
    local insertPos = -1
    for i = 1, listLen do
      local data = dataList[i]
      local id = data.uuid
      if id == curFirstId then
        insertPos = i
        break
      end
    end
    if insertPos == -1 then
      isReAddData = true
      table.clear(curList)
      for i = 1, listLen do
        local data = dataList[i]
        curList[i] = data.uuid
        self:AddDataToAlDataDict(data)
      end
    else
      local insertNum = insertPos - 1
      if 0 < insertNum then
        for i = curListLen + insertNum, 1, -1 do
          if i > insertNum then
            curList[i] = curList[i - insertNum]
          else
            local data = dataList[i]
            curList[i] = data.uuid
            self:AddDataToAlDataDict(data)
          end
        end
      end
    end
  else
    local curLastId = curList[curListLen]
    if curLastId == lastUid then
      for i = 1, listLen do
        local data = dataList[i]
        local id = data.uuid
        self:AddDataToAlDataDict(data)
        table.insert(curList, id)
      end
    end
  end
  if isReAddData == true and listLen >= onceReqGetDataNum then
    self.alTypeDataFinDict[filterType] = false
  end
end

function AllianceNoticeRecordManager:AddDataToAlDataDict(data)
  local id = data.uuid
  if self.alDataDict[id] then
    return
  end
  local recordData = AllianceNoticeRecordData:New()
  self.alDataDict[id] = recordData
  recordData:UpdateInfo(data)
end

return AllianceNoticeRecordManager
