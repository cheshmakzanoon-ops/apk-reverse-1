local AllianceGiftDataManager = BaseClass("AllianceGiftDataManager")

local function __init(self)
  self:ResetData()
end

local function __delete(self)
  self.curLevel = nil
  self.curExp = nil
  self.curMaxExp = nil
  self.alGiftHideName = nil
  self.giftNum = nil
  self.giftInfoList = nil
  self.type2RedPointNumDict = nil
end

local function ResetData(self)
  self.curLevel = 1
  self.curExp = 0
  self.curMaxExp = 0
  self.giftNum = 0
  self.alGiftHideName = ""
  self.giftInfoList = {}
  self.giftInfoList[1] = {}
  self.giftInfoList[2] = {}
  self.type2RedPointNumDict = {}
end

local function UpdateGiftInfoList(self, message)
  local info = message.info
  if info ~= nil then
    self:UpdateOneTypeGiftInfo(info, 1)
    self:UpdateOneTypeGiftInfo(info, 2)
  end
end

local function UpdateOneTypeGiftInfo(self, info, type)
  if info == nil then
    return
  end
  local theTypeArr = {}
  local dataList = info["list" .. type]
  if dataList ~= nil and next(dataList) then
    table.walk(dataList, function(k, v)
      local info = AllianceGiftData.New()
      info:ParseData(v)
      if not string.IsNullOrEmpty(info.uuid) then
        theTypeArr[info.uuid] = info
      end
    end)
  end
  if info["redPoint" .. type] then
    local redPointNum = info["redPoint" .. type]
    self:SetRedPointNum(type, redPointNum)
  end
  self.giftInfoList[type] = theTypeArr
end

local function UpdateOneGiftInfo(self, data, type)
  if data == nil then
    return
  end
  local info = AllianceGiftData.New()
  info:ParseData(data)
  if type == nil then
    type = info.rewardType
  end
  if not string.IsNullOrEmpty(info.uuid) then
    self.giftInfoList[type][info.uuid] = info
  end
end

local function RetBaseData(self, message)
  if message.onLevel ~= nil then
    self.curLevel = message.onLevel
  end
  if message.onCurrExp ~= nil then
    self.curExp = message.onCurrExp
  end
  if message.onMaxExp ~= nil then
    self.curMaxExp = message.onMaxExp
  end
  if message.alGiftHideName ~= nil then
    self.alGiftHideName = message.alGiftHideName
    LuaEntry.Player.alGiftHideName = message.alGiftHideName
  end
end

local function UpdateGiftNum(self, count)
  if 0 < count then
    self.giftNum = count
  else
    self.giftNum = 0
  end
  EventManager:GetInstance():Broadcast(EventId.UpdateMainAllianceRedCount)
end

local function RemoveAllianceGiftData(self, uuid, type)
  self.giftInfoList[type][uuid] = nil
end

local function RemoveAllianceGiftListData(self, uuidList, type)
  table.walk(uuidList, function(k, v)
    self.giftInfoList[type][v] = nil
  end)
end

local function RemoveAllReceiveGift(self, type)
  local deleteList = {}
  table.walk(self.giftInfoList[type], function(k, v)
    if v.receiveState == 1 and v.rewardType == type then
      table.insert(deleteList, v.uuid)
    end
  end)
  self:RemoveAllianceGiftListData(deleteList, type)
end

local function SetGiftReceive(self, uuid, type, time)
  if self.giftInfoList[type][uuid] ~= nil then
    self.giftInfoList[type][uuid].receiveState = 1
    if time then
      self.giftInfoList[type][uuid].receiveTime = time
    end
  end
end

local function SetAllGiftReceiveByType(self, type)
  table.walk(self.giftInfoList[type], function(k, v)
    self:SetGiftReceive(v.uuid, type)
  end)
end

local function RetGiftInfo(self, message, type)
  if message.uuid ~= nil then
    local uuid = message.uuid
    if self.giftInfoList[type][uuid] ~= nil and message.info ~= nil then
      self.giftInfoList[type][uuid].reward = message.info
    end
  end
end

local function GetGiftInfoList(self, type)
  local list = {}
  local deleteList = {}
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  table.walk(self.giftInfoList[type], function(k, v)
    if v.expirationTime < serverTime then
      table.insert(deleteList, v.uuid)
    elseif type == nil then
      list[v.uuid] = v
    elseif v.rewardType == type then
      list[v.uuid] = v
    end
  end)
  self:RemoveAllianceGiftListData(deleteList, type)
  return list
end

local function GetGiftDataByUuid(self, uuid, type)
  if type ~= nil then
    return self.giftInfoList[type][uuid]
  else
    local ret = self.giftInfoList[1][uuid]
    if ret == nil then
      ret = self.giftInfoList[2][uuid]
    end
    return ret
  end
end

local function GetCurLevel(self)
  return self.curLevel
end

local function GetCurExp(self)
  return self.curExp
end

local function GetMaxExp(self)
  return self.curMaxExp
end

local function GetGiftNum(self)
  return self.giftNum
end

local function SetCurLevel(self, level)
  self.curLevel = level
end

local function SetRedPointNum(self, type, num)
  self.type2RedPointNumDict[type] = num
end

local function GetRedPointNum(self, type)
  if self.type2RedPointNumDict[type] then
    return self.type2RedPointNumDict[type]
  end
  return 0
end

AllianceGiftDataManager.__init = __init
AllianceGiftDataManager.__delete = __delete
AllianceGiftDataManager.ResetData = ResetData
AllianceGiftDataManager.UpdateGiftInfoList = UpdateGiftInfoList
AllianceGiftDataManager.RetBaseData = RetBaseData
AllianceGiftDataManager.RetGiftInfo = RetGiftInfo
AllianceGiftDataManager.UpdateGiftNum = UpdateGiftNum
AllianceGiftDataManager.RemoveAllianceGiftData = RemoveAllianceGiftData
AllianceGiftDataManager.RemoveAllianceGiftListData = RemoveAllianceGiftListData
AllianceGiftDataManager.GetGiftInfoList = GetGiftInfoList
AllianceGiftDataManager.GetCurLevel = GetCurLevel
AllianceGiftDataManager.GetCurExp = GetCurExp
AllianceGiftDataManager.GetMaxExp = GetMaxExp
AllianceGiftDataManager.GetGiftNum = GetGiftNum
AllianceGiftDataManager.GetGiftDataByUuid = GetGiftDataByUuid
AllianceGiftDataManager.RemoveAllReceiveGift = RemoveAllReceiveGift
AllianceGiftDataManager.SetCurLevel = SetCurLevel
AllianceGiftDataManager.SetGiftReceive = SetGiftReceive
AllianceGiftDataManager.SetAllGiftReceiveByType = SetAllGiftReceiveByType
AllianceGiftDataManager.UpdateOneTypeGiftInfo = UpdateOneTypeGiftInfo
AllianceGiftDataManager.UpdateOneGiftInfo = UpdateOneGiftInfo
AllianceGiftDataManager.SetRedPointNum = SetRedPointNum
AllianceGiftDataManager.GetRedPointNum = GetRedPointNum
return AllianceGiftDataManager
