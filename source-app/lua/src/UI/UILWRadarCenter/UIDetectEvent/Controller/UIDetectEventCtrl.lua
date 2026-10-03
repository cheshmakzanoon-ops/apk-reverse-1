local UIDetectEventCtrl = BaseClass("UIDetectEventCtrl", UIBaseCtrl)
local Screen = CS.UnityEngine.Screen
local Localization = CS.GameEntry.Localization
local defaultPoint = {
  Vector3.New(364, 156, 0),
  Vector3.New(353, -126, 0),
  Vector3.New(-364, 156, 0),
  Vector3.New(-353, -126, 0)
}
local big_map_img_width = 810
local big_map_img_range_width = 740
local big_map_img_left_empty_width = (big_map_img_width - big_map_img_range_width) / 2
local big_map_width = 1000

local function CloseSelf(self)
  DataCenter.RadarFakeUIMarchManager:FinishAll()
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
  param.helpInfo = data.helpInfo
  param.completeByHelper = data.completeByHelper
  return param
end

local function Goto(self, uuid)
  local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
  if data ~= nil then
    if not DataCenter.GuideManager:InGuide() then
      EventManager:GetInstance():Broadcast(EventId.ShowWorldMarchByType, NewMarchType.EXPLORE)
    end
    if data.state == DetectEventState.DETECT_EVENT_STATE_NOT_IN_WORLD then
      SFSNetwork.SendMessage(MsgDefines.DetectEventPutPointInWorld, data.uuid)
    else
      local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
      if template ~= nil and template.type == DetectEventType.DetectEventTypeBoss then
        local level = 1
        if not string.IsNullOrEmpty(template.c_para) then
          level = toInt(template.c_para)
        else
          local maxLevel, checkType
          if template.monsterTypeList then
            maxLevel, checkType = DataCenter.MonsterTemplateManager:GetMonsterMaxLevelATypeByTypeList(template.monsterTypeList)
          else
            checkType = LWWorldMonsterType.Boss
            maxLevel = DataCenter.MonsterTemplateManager:GetMonsterMaxLevelbyType(checkType) or 30
          end
          level = DataCenter.SearchPanelDataManager:GetUserSearch(UISearchType.Boss, checkType) or 1
          level = math.min(level, maxLevel)
        end
        DataCenter.RadarCenterDataManager:FindMonsterBoss(level)
        DataCenter.RadarCenterDataManager:TryDetectFirstGotoPlot(uuid)
        return
      elseif template ~= nil and template.type == DetectEventType.PARKOUR_BATTLE then
        SFSNetwork.SendMessage(MsgDefines.DetectEventPveFeatureStart, uuid)
        return
      elseif template ~= nil and template.type == DetectEventType.WANDERING_BOSS then
        SFSNetwork.SendMessage(MsgDefines.DetectEventFindRunningBoss, uuid)
        return
      end
      DataCenter.WorldPointWaitOpenManager.byDetect = 1
      if template ~= nil and template.type == DetectEventType.ZOMBIE_BUS_TRAIN then
        DataCenter.RadarCenterDataManager:RequestToJumpZombieBusTrain(uuid, DetectEventZombieBusTrainJumpToType.RadarUI)
      else
        local marchUUId = data.marchUuid or uuid
        local serverId = data.serverId or LuaEntry.Player:GetSelfServerId()
        GoToUtil.MoveToWorldPointAndOpen(data.pointId, data.type, marchUUId, serverId)
      end
      EventManager:GetInstance():Broadcast(EventId.GF_detect_event_goto_clicked, data.eventId)
      DataCenter.RadarCenterDataManager:TryDetectFirstGotoPlot(uuid)
      self:CloseSelf()
    end
  else
    self:CloseSelf()
  end
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
    self.eventUid2PointIdCache = {}
  end
  local deleteCache = {}
  table.walk(self.posCache, function(k, v)
    if DataCenter.RadarCenterDataManager:GetDetectEventInfo(k) == nil then
      table.insert(deleteCache, k)
    end
  end)
  table.walk(deleteCache, function(_, v)
    self.posCache[v] = nil
    self.eventUid2PointIdCache[v] = nil
  end)
  local allEvent = DataCenter.RadarCenterDataManager:GetDetectEventInfoUuids()
  local currentDefaultIndex = 1
  local totalDefault = table.count(defaultPoint)
  self.movingEvents = {}
  table.walk(allEvent, function(_, v)
    local event = DataCenter.RadarCenterDataManager:GetDetectEventInfo(v)
    if event ~= nil then
      if self.posCache[v] ~= nil and self.eventUid2PointIdCache[v] ~= nil and self.eventUid2PointIdCache[v] == event.pointId then
        return self.posCache[v]
      end
      if event.template.type == DetectEventType.ZOMBIE_BUS_TRAIN then
        self.movingEvents[v] = 1
      else
        local pointId = event.pointId
        local x, y = self:GetDetectEventCurPosition(v)
        if x and y then
          for _, posData in pairs(self.posCache) do
            if posData ~= nil and math.abs(x - posData.x) <= 0 and 0 >= math.abs(y - posData.y) then
              local dx = math.random(0, 80)
              local dy = math.ceil(math.sqrt(6400 - dx * dx))
              if x <= 0 then
                x = x + dx
              else
                x = x - dx
              end
              if y <= 0 then
                y = y + dy
                break
              end
              y = y - dy
              break
            end
          end
          self.posCache[v] = Vector3.New(x, y, 0)
          self.eventUid2PointIdCache[v] = pointId
        end
      end
    end
  end)
end

function UIDetectEventCtrl:GetDetectEventCurPosition(uuid)
  local event = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
  if event ~= nil then
    local pointId = event.pointId
    local pos = {x = 0, y = 0}
    local selfPos = SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
    if event.template and event.template.type == DetectEventType.ZOMBIE_BUS_TRAIN then
      local data = DataCenter.RadarCenterDataManager:GetZombieBusTrainCityData()
      if data and data.busList and 0 < #data.busList then
        pos = Vector3.New(selfPos.x, selfPos.y + 3, 0)
      elseif event.curPoint then
        pos = SceneUtils.IndexToTilePos(event.curPoint, ForceChangeScene.World)
      end
    elseif 0 < pointId then
      pos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
    end
    local ratio = 30
    local UIPosW = 810
    local UIPosH = 1110
    if LuaEntry.DataConfig:CheckSwitch("radar_click_area") then
      if DefaultScreenWidth / DefaultScreenHeight > Screen.width / Screen.height then
        local scaler = Screen.width / Screen.height
        UIPosH = (DefaultScreenWidth / scaler - 900) / 0.7
      else
        UIPosH = (DefaultScreenHeight - 900) / 0.7
      end
    end
    local x = ratio * (pos.x - selfPos.x)
    local y = ratio * (pos.y - selfPos.y)
    local maxX = (UIPosW - 50) / 2
    local minX = -maxX
    local maxY = (UIPosH - 50) / 2
    local minY = -maxY
    x = math.min(x, maxX)
    x = math.max(x, minX)
    y = math.min(y, maxY)
    y = math.max(y, minY)
    return x, y
  end
end

function UIDetectEventCtrl:GetMoveDetectEventPosition(uuid)
  if self.movingEvents ~= nil and self.movingEvents[uuid] ~= nil then
    return self:GetDetectEventCurPosition(uuid)
  end
end

local function GetDetectEventPosition(self, uuid)
  local moveX, moveY = self:GetMoveDetectEventPosition(uuid)
  if moveX and moveY then
    return Vector3.New(moveX, moveY, 0)
  end
  if self.posCache ~= nil and self.posCache[uuid] ~= nil then
    return self.posCache[uuid]
  end
  return Vector3.New(0, 0, 0)
end

local function GetSelfWorldMapImgPosition(self)
  local x = 0
  local y = 0
  local selfPos = SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
  local oneGridWidth = big_map_img_range_width / big_map_width
  x = oneGridWidth * selfPos.x - big_map_img_range_width / 2
  y = oneGridWidth * selfPos.y - big_map_img_range_width / 2
  return Vector2.New(x, y)
end

local function GetSelfWorldMapImgScale(self)
  local oneGridWidth = big_map_img_range_width / big_map_width
  local gridEndScale = 14
  local imgScale = gridEndScale / oneGridWidth * 0.4
  return imgScale
end

local function GetDetectEventMaxLevel(self)
  local result = DataCenter.DetectLevelTemplateManager:GetMaxLevel()
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
  local eventNum = 1
  local template = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.DETECT_LEVEL), level)
  if template ~= nil then
    eventNum = template.detect_show_num
  end
  return eventNum
end

local function GetDetectEventLevelUpNum(self, level)
  local num = -1
  local template = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.DETECT_LEVEL), level)
  if template ~= nil then
    num = template.exp
  end
  return num
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

local function GetEventRecoverNum(self, level)
  if level == nil then
    level = DataCenter.RadarCenterDataManager:GetDetectInfoLevel()
  end
  if level == nil then
    return 0
  end
  local num = 0
  local numStr = ""
  local template = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.DETECT_LEVEL), level)
  if template ~= nil then
    numStr = template.refresh
    local numStrArry = string.split(numStr, ";")
    if 2 <= #numStrArry then
      num = tonumber(numStrArry[2])
    end
  end
  return num
end

local function GetEventResEffect(self, level)
  local maxLv = self:GetDetectEventMaxLevel()
  level = math.min(level, maxLv)
  local effectNum = 0
  local template = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.DETECT_LEVEL), level)
  if template ~= nil then
    effectNum = tonumber(template.res_increase_num) or 0
  end
  return effectNum
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
  if level == nil then
    level = DataCenter.RadarCenterDataManager:GetDetectInfoLevel()
  end
  if level < 1 then
    return 1
  end
  local num = 1
  local template = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.DETECT_LEVEL), level)
  if template ~= nil then
    num = template.detect_max_num
  end
  return num
end

local function HasPvePointRewardAndOverflow(self, rewards)
  if rewards == nil then
    return false
  end
  return false
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
    local showMaxNum = self:GetDetectEventNum(currentLv)
    local curShowNum = DataCenter.RadarCenterDataManager:GetDetectEventCount()
    local recoverNum = self:GetEventRecoverNum(currentLv)
    local value = math.max(maxNum - currentNum + math.max(showMaxNum - curShowNum, 0) - recoverNum, 0)
    local t2 = 0
    if 0 < recoverNum then
      t2 = math.ceil(value / recoverNum) * 6 * 60 * 60 * 1000
    end
    local now = UITimeManager:GetInstance():GetServerTime()
    local t1 = result.currentEndTime - now
    result.totalEndTime = now + t1 + t2
  end
  return result
end

local function GetQueueImgByType(type)
  local imgPath
  if DetectEventType.DetectEventTypeBoss == type or DetectEventType.WANDERING_BOSS == type then
    imgPath = "Assets/Main/Sprites/UI/UIRadarCenter/lyp_leida_xingjun"
  end
  return imgPath
end

local function BackHome(self)
  local curScene = CS.SceneManager.CurrSceneID
  if curScene == SceneManagerSceneID.World then
    if CrossServerUtil:GetIsCrossServer() then
      GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos()), nil, 0.02, function()
        SceneUtils.ChangeToCity(function()
        end)
      end, LuaEntry.Player:GetSelfServerId())
    else
      SceneUtils.ChangeToCity(function()
      end)
    end
  else
    self:CloseSelf()
  end
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
UIDetectEventCtrl.GetEventRecoverNum = GetEventRecoverNum
UIDetectEventCtrl.GetEventResEffect = GetEventResEffect
UIDetectEventCtrl.IsCanReset = IsCanReset
UIDetectEventCtrl.ResetDetectEvent = ResetDetectEvent
UIDetectEventCtrl.GetEventStoreMax = GetEventStoreMax
UIDetectEventCtrl.HasPvePointRewardAndOverflow = HasPvePointRewardAndOverflow
UIDetectEventCtrl.GetNormalEventInfo = GetNormalEventInfo
UIDetectEventCtrl.GetReward = GetReward
UIDetectEventCtrl.ResetAllPosition = ResetAllPosition
UIDetectEventCtrl.GetSelfWorldMapImgPosition = GetSelfWorldMapImgPosition
UIDetectEventCtrl.GetSelfWorldMapImgScale = GetSelfWorldMapImgScale
UIDetectEventCtrl.GetQueueImgByType = GetQueueImgByType
UIDetectEventCtrl.BackHome = BackHome
UIDetectEventCtrl.GotoWorldPoint = GotoWorldPoint
return UIDetectEventCtrl
