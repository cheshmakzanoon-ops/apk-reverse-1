local UIDetectEventCtrl = BaseClass("UIDetectEventCtrl", UIBaseCtrl)
local Screen = CS.UnityEngine.Screen
local Localization = CS.GameEntry.Localization
local defaultPoint = {
  Vector3.New(364, 156, 0),
  Vector3.New(353, -126, 0),
  Vector3.New(-364, 156, 0),
  Vector3.New(-353, -126, 0)
}

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDetectEvent)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetRadarCenterPositionList(self)
  local list = DataCenter.RadarCenterDataManager:GetDetectEventInfoUuids()
  local result = {}
  table.walk(list, function(k, v)
    local param = self:GetOneEventData(v)
    if param ~= nil then
      table.insert(result, param)
    end
  end)
  return result
end

local function GetOneEventData(self, uuid)
  local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
  if data == nil then
    return nil
  end
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
  if template == nil then
    return nil
  end
  local param = {}
  param.uuid = uuid
  param.eventId = data.eventId
  param.state = data.state
  param.pointId = data.pointId
  param.type = template.type
  return param
end

local function Goto(self, uuid)
  local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
  if data ~= nil then
    if not DataCenter.GuideManager:InGuide() then
      EventManager:GetInstance():Broadcast(EventId.ShowWorldMarchByType, NewMarchType.EXPLORE)
    end
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
    if template ~= nil and template.type == DetectEventType.DetectEventTypeBoss then
      local level = 1
      if not string.IsNullOrEmpty(template.para) then
        level = toInt(template.para)
      end
      DataCenter.RadarCenterDataManager:FindMonsterBoss(level)
      return
    end
    GoToUtil.MoveToWorldPointAndOpen(data.pointId, data.type, uuid)
  end
  self:CloseSelf()
end

local function GetRefreshLeftTime(self)
  local nextTime = DataCenter.RadarCenterDataManager:GetDetectInfoNextRefreshTime()
  if nextTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    return (nextTime - curTime) / 1000
  end
  return -1
end

local function ResetAllPosition(self)
  if self.posCache == nil then
    self.posCache = {}
  end
  local deleteCache = {}
  table.walk(self.posCache, function(k, v)
    if DataCenter.RadarCenterDataManager:GetDetectEventInfo(k) == nil then
      table.insert(deleteCache, k)
    end
  end)
  table.walk(deleteCache, function(_, v)
    self.posCache[v] = nil
  end)
  local allEvent = DataCenter.RadarCenterDataManager:GetDetectEventInfoUuids()
  local currentDefaultIndex = 1
  local totalDefault = table.count(defaultPoint)
  table.walk(allEvent, function(_, v)
    local event = DataCenter.RadarCenterDataManager:GetDetectEventInfo(v)
    if event ~= nil then
      local pointId = event.pointId
      local pos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
      local selfPos = SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
      local ratio = 14
      local x = ratio * (pos.x - selfPos.x)
      local y = ratio * (pos.y - selfPos.y)
      local maxX = (Screen.width - 100) / 2
      local minX = -maxX
      local maxY = (Screen.height - 100) / 2
      local minY = -maxY
      x = math.min(x, maxX)
      x = math.max(x, minX)
      y = math.min(y, maxY)
      y = math.max(y, minY)
      self.posCache[v] = Vector3.New(x, y, 0)
    end
  end)
end

local function GetDetectEventPosition(self, uuid)
  if self.posCache ~= nil and self.posCache[uuid] ~= nil then
    return self.posCache[uuid]
  end
  return Vector3.New(0, 0, 0)
end

local function GetDetectEventMaxLevel(self)
  local key1 = "detect_config"
  if LuaEntry.Player:IsMonopolyDetectB() then
    key1 = "detect_config_new"
  end
  local result = LuaEntry.DataConfig:TryGetNum(key1, "k1")
  return result
end

local function GetDetectEventPowerMaxLevel(self)
  local key1 = "detect_config"
  if LuaEntry.Player:IsMonopolyDetectB() then
    key1 = "detect_config_new"
  end
  local result = LuaEntry.DataConfig:TryGetNum(key1, "k5")
  return result
end

local function GetDetectEventNum(self, level)
  local maxLv = self:GetDetectEventMaxLevel()
  level = math.min(level, maxLv)
  local key1 = "detect_config"
  if LuaEntry.Player:IsMonopolyDetectB() then
    key1 = "detect_config_new"
  end
  local result = LuaEntry.DataConfig:TryGetStr(key1, "k2")
  local vec = string.split(result, ";")
  if table.count(vec) == 0 then
    return 1
  end
  if level > table.count(vec) then
    return 1
  end
  return vec[level]
end

local function GetDetectEventLevelUpNum(self, level)
  local key1 = "detect_config"
  if LuaEntry.Player:IsMonopolyDetectB() then
    key1 = "detect_config_new"
  end
  local result = LuaEntry.DataConfig:TryGetStr(key1, "k4")
  local vec = string.split(result, ";")
  if level > table.count(vec) then
    return -1
  end
  return vec[level]
end

local function GetEventRecoverTime(self, level)
  if level == nil then
    level = DataCenter.RadarCenterDataManager:GetDetectInfoLevel()
  end
  if level == nil then
    return 0
  end
  local key1 = "detect_config"
  if LuaEntry.Player:IsMonopolyDetectB() then
    key1 = "detect_config_new"
  end
  local result = LuaEntry.DataConfig:TryGetStr(key1, "k3")
  local vec = string.split(result, ";")
  if table.count(vec) == 0 then
    return 0
  end
  if level > table.count(vec) then
    return vec[table.count(vec)] * 60 * 1000
  end
  return vec[level] * 60 * 1000
end

local function IsCanUpdate(self)
  return DataCenter.RadarCenterDataManager:IsCanUpdate()
end

local function IsCanReset(self, type)
  return DataCenter.RadarCenterDataManager:IsCanReset(type)
end

local function ResetDetectEvent(self, uuid)
  local currentNum = DataCenter.RadarCenterDataManager:GetMaxDetectNum()
  if currentNum == 0 then
    UIUtil.ShowTips(Localization:GetString("140072"))
    return
  end
  local key1 = "detect_config"
  if LuaEntry.Player:IsMonopolyDetectB() then
    key1 = "detect_config_new"
  end
  local costStr = LuaEntry.DataConfig:TryGetStr(key1, "k7")
  local vec = string.split(costStr, ";")
  if table.count(vec) == 0 then
    return
  end
  local level = DataCenter.RadarCenterDataManager:GetResetNum() + 1
  local need = 0
  if level > table.count(vec) then
    need = toInt(vec[table.count(vec)])
  else
    need = toInt(vec[level])
  end
  UIUtil.ShowMessage(Localization:GetString("140071", tostring(need)), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    if LuaEntry.Player.gold >= need then
      DataCenter.RadarCenterDataManager:ResetDetectEvent(uuid)
    else
      GoToUtil.GotoPayTips(need)
    end
  end)
end

local function GetEventStoreMax(self, level)
  local key1 = "detect_config"
  if LuaEntry.Player:IsMonopolyDetectB() then
    key1 = "detect_config_new"
  end
  local str = LuaEntry.DataConfig:TryGetStr(key1, "k6")
  local vec = string.split(str, ";")
  if table.count(vec) == 0 then
    return 1
  end
  if level == nil then
    level = DataCenter.RadarCenterDataManager:GetDetectInfoLevel()
  end
  if level < 1 then
    return 1
  end
  local max = 1
  if level > table.count(vec) then
    max = toInt(vec[table.count(vec)])
  else
    max = toInt(vec[level])
  end
  return max
end

local function HasPvePointRewardAndOverflow(self, rewards)
  if rewards == nil then
    return false
  end
  return false
end

local function GetSpecialEventData(self)
  local detectInfo = DataCenter.RadarCenterDataManager:GetDetectInfo()
  if detectInfo ~= nil then
    local param = {}
    local order = detectInfo.specialOpsOrder or 0
    local num = detectInfo.specialOpsNum or 0
    param.showProgress = 0 < num
    param.maxNum = order + num
    param.currentNum = order
    local _, time = DataCenter.RadarCenterDataManager:GetNextSpecialEventRefreshTime()
    param.nameStr = DataCenter.RadarCenterDataManager:GetCurrentShowSpecialEventName()
    param.endTime = time
    return param
  end
  return nil
end

local function GetSpecialOpsEventInfo(self)
  local result = {}
  result.nameStr = DataCenter.RadarCenterDataManager:GetCurrentShowSpecialEventName()
  local special = DataCenter.RadarCenterDataManager:GetSpecialEvent()
  if special == nil then
    local gap, time = DataCenter.RadarCenterDataManager:GetNextSpecialEventRefreshTime()
    result.inCd = true
    result.endTime = time
  else
    result.inCd = false
    result.uuid = special.uuid
  end
  return result
end

local function GetNormalEventInfo(self)
  local result = {}
  local currentLv = DataCenter.RadarCenterDataManager:GetDetectInfoLevel()
  result.recoveryTime = self:GetEventRecoverTime(currentLv)
  result.currentEndTime = DataCenter.RadarCenterDataManager:GetDetectInfoNextRefreshTime()
  local maxNum = self:GetEventStoreMax()
  local currentNum = DataCenter.RadarCenterDataManager:GetMaxDetectNum()
  if maxNum <= currentNum then
    result.currentEndTime = 0
    result.totalEndTime = 0
  else
    local num = maxNum - currentNum - 1
    num = math.max(0, num)
    result.totalEndTime = result.currentEndTime + num * result.recoveryTime
  end
  return result
end

local function GetReward(self, data)
  local resourceItemNum = 0
  table.walk(data.rewardList, function(_, v)
    if v.rewardType == RewardType.RESOURCE_ITEM then
      resourceItemNum = resourceItemNum + v.count
    end
  end)
  if 0 <= resourceItemNum and DataCenter.ResourceItemDataManager:CheckIsStorageFull(resourceItemNum) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityFull)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.DetectEventRewardReceive, data.uuid)
end

UIDetectEventCtrl.CloseSelf = CloseSelf
UIDetectEventCtrl.Close = Close
UIDetectEventCtrl.GetRadarCenterPositionList = GetRadarCenterPositionList
UIDetectEventCtrl.GetRefreshLeftTime = GetRefreshLeftTime
UIDetectEventCtrl.Goto = Goto
UIDetectEventCtrl.GetDetectEventPosition = GetDetectEventPosition
UIDetectEventCtrl.GetDetectEventMaxLevel = GetDetectEventMaxLevel
UIDetectEventCtrl.GetDetectEventNum = GetDetectEventNum
UIDetectEventCtrl.GetDetectEventLevelUpNum = GetDetectEventLevelUpNum
UIDetectEventCtrl.GetDetectEventPowerMaxLevel = GetDetectEventPowerMaxLevel
UIDetectEventCtrl.GetOneEventData = GetOneEventData
UIDetectEventCtrl.IsCanUpdate = IsCanUpdate
UIDetectEventCtrl.GetEventRecoverTime = GetEventRecoverTime
UIDetectEventCtrl.IsCanReset = IsCanReset
UIDetectEventCtrl.ResetDetectEvent = ResetDetectEvent
UIDetectEventCtrl.GetEventStoreMax = GetEventStoreMax
UIDetectEventCtrl.HasPvePointRewardAndOverflow = HasPvePointRewardAndOverflow
UIDetectEventCtrl.GetSpecialEventData = GetSpecialEventData
UIDetectEventCtrl.GetSpecialOpsEventInfo = GetSpecialOpsEventInfo
UIDetectEventCtrl.GetNormalEventInfo = GetNormalEventInfo
UIDetectEventCtrl.GetReward = GetReward
UIDetectEventCtrl.ResetAllPosition = ResetAllPosition
return UIDetectEventCtrl
