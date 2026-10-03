local WorldPointSelectViewDataManager = BaseClass("WorldPointSelectViewDataManager")
local MobileTouchCamera = CS.BitBenderGames.MobileTouchCamera
local waiteTime = 10000

local function __init(self)
  self.entryType = nil
  self.entryParam = nil
  self.entryWaitExpireTime = nil
  self.zoomMax = nil
  self.mainCamera = nil
  self.touchCamera = nil
  self.saveShareData = nil
  self.beforeJumpSceneID = nil
  self.beforeJumpTargetPos = nil
  self.beforeJumpTargetZoom = nil
end

local function __delete(self)
  self.entryType = nil
  self.entryParam = nil
  self.entryWaitExpireTime = nil
  self.zoomMax = nil
  self.mainCamera = nil
  self.touchCamera = nil
  self.saveShareData = nil
  self.beforeJumpSceneID = nil
  self.beforeJumpTargetPos = nil
  self.beforeJumpTargetZoom = nil
end

local function StartSelect(self, entryType, entryParam)
  self.entryType = entryType
  self.entryParam = entryParam
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.entryWaitExpireTime = curTime + waiteTime
  self.saveShareData = nil
  self.beforeJumpSceneID = nil
  self.beforeJumpTargetPos = nil
  self.beforeJumpTargetZoom = nil
  local canGotoSelectWorldPoint = self:CanGotoSelectWorldPoint()
  if not canGotoSelectWorldPoint then
    return
  end
  self:TryInitZoomMax()
  self.beforeJumpSceneID = CS.SceneManager.CurrSceneID
  if self.touchCamera then
    self.beforeJumpTargetPos = self.touchCamera:GetCameraTargetPos()
    self.beforeJumpTargetZoom = self.touchCamera.CamZoom
  end
  GoToUtil.CloseAllWindows()
  local serverId = LuaEntry.Player:GetCurServerId()
  local pointId = self:GetDefaultJumpPosAndZoneId()
  GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), self.zoomMax, nil, function()
    self:TryOpenSelectPointView()
  end, serverId)
end

local function TryOpenSelectPointView(self)
  local canOpen = self:CheckCanOpenSelectPointView()
  if not canOpen then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMainMapPointToSelect)
end

local function EndSelect(self, shareData)
  self:SetTouchCameraZoomChangeBlock(false)
  if self.entryType == nil then
    return
  end
  
  local function completeFunc()
    if self.entryType == WorldPointSelectViewEntryType.AllianceNotice then
      local selectRoomGroup = self.entryParam.selectRoomGroup
      local saveParam = self.entryParam.saveParam
      if shareData and saveParam then
        if saveParam.extraJsonData == nil then
          saveParam.extraJsonData = {}
        end
        local notice = saveParam.notice or ""
        local extraJsonData = saveParam.extraJsonData
        local insertPosData = self.entryParam.insertPosData
        ChatInterface.AddOnePointShareDataInsertToTarget(notice, extraJsonData, insertPosData, shareData, saveParam)
      end
      if selectRoomGroup and saveParam then
        local RoomManager = ChatManager2:GetInstance().Room
        local allianceRoomData = RoomManager:GetRoomDataByGroup(selectRoomGroup)
        if allianceRoomData then
          GoToUtil.OpenChatView(false, {anim = false, immediately = true}, {
            roomId = allianceRoomData.roomId
          })
          if DataCenter.AllianceBaseDataManager:IsR4orR5() then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIPostAllianceNotice, {anim = true}, saveParam)
          end
        end
      end
    end
    self.entryType = nil
    self.entryParam = nil
    self.entryWaitExpireTime = nil
  end
  
  completeFunc()
end

local function CanGotoSelectWorldPoint(self)
  local isInDragon = BattleFieldUtil.InBattleField()
  if isInDragon then
    return false
  end
  local curScene = CS.SceneManager.CurrSceneID
  if curScene == SceneManagerSceneID.City then
    local unlock, lockTips = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_WorldBtn)
    if not unlock then
      return false
    end
  end
  if LuaEntry.Player:GetMainWorldPos() < 0 then
    return false
  end
  return true
end

local function TryInitZoomMax(self)
  if self.mainCamera == nil then
    self.mainCamera = CS.UnityEngine.Camera.main
    if self.mainCamera then
      self.touchCamera = self.mainCamera:GetComponent(typeof(MobileTouchCamera))
    end
  end
  local seasonType = SeasonMapType.Nothing
  local curServerId = LuaEntry.Player:GetCurServerId()
  local seasonInfo = SeasonUtil.GetSeasonInfo(curServerId)
  if seasonInfo == nil then
    local config = DataCenter.SeasonTemplateManager:GetConfigDataByServerId(curServerId)
    if config ~= nil then
      seasonType = config.server_type
    end
  else
    seasonType = seasonInfo:GetServerType(false)
  end
  if seasonType == SeasonMapType.NineNation then
    self.zoomMax = 6500
  elseif seasonType == SeasonMapType.Mummy then
    self.zoomMax = 2750.0
  else
    self.zoomMax = 5000
  end
end

local function CheckCanOpenSelectPointView(self)
  local canOpen = true
  local curScene = CS.SceneManager.CurrSceneID
  if curScene ~= SceneManagerSceneID.World then
    canOpen = false
  end
  local curZoom = CS.SceneManager.World.Zoom
  if self.zoomMax == nil then
    canOpen = false
  elseif curZoom < self.zoomMax * 0.95 then
    canOpen = false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.entryWaitExpireTime then
    canOpen = false
  end
  return canOpen
end

local function GetZoomMax(self)
  self:TryInitZoomMax()
  return self.zoomMax
end

local function SetTouchCameraZoomChangeBlock(self, val)
  if self.touchCamera then
    self.touchCamera:SetIsCamZoomChangeBlock(val)
  end
end

local function GetTouchCamera(self)
  return self.touchCamera
end

local function GetDefaultJumpPosAndZoneId(self)
  local pointId = LuaEntry.Player:GetMainWorldPos()
  local zoneId = ""
  local template = DataCenter.AllianceCityTemplateManager:GetAllTemplate()
  local serverId = LuaEntry.Player:GetCurServerId()
  if self.entryType == WorldPointSelectViewEntryType.AllianceNotice then
    local isGetAlZone = false
    local alZoneLevel = -1
    local allianceId = LuaEntry.Player:GetAllianceUid()
    if not string.IsNullOrEmpty(allianceId) then
      local occupied, unmanned = DataCenter.AllianceCityTemplateManager:GetOccupiedCityList(allianceId, false)
      if occupied and 0 < #occupied then
        for i, v in ipairs(occupied) do
          local curId = v.id
          local curLv = v.level
          if alZoneLevel < curLv then
            alZoneLevel = curLv
            zoneId = curId
            pointId = SceneUtils.TileXYToIndex(v.pos.x, v.pos.y, ForceChangeScene.World)
            serverId = v:GetCurServerId()
            isGetAlZone = true
          end
        end
      end
    end
    if not isGetAlZone then
      local targetZone = DataCenter.AllianceCityTemplateManager:GetCityByType(WorldAllianceCityType.King, serverId)
      if targetZone then
        zoneId = targetZone.id
        pointId = targetZone:GetPointId()
      end
    end
  end
  return pointId, zoneId, serverId
end

WorldPointSelectViewDataManager.__init = __init
WorldPointSelectViewDataManager.__delete = __delete
WorldPointSelectViewDataManager.StartSelect = StartSelect
WorldPointSelectViewDataManager.EndSelect = EndSelect
WorldPointSelectViewDataManager.CanGotoSelectWorldPoint = CanGotoSelectWorldPoint
WorldPointSelectViewDataManager.TryInitZoomMax = TryInitZoomMax
WorldPointSelectViewDataManager.TryOpenSelectPointView = TryOpenSelectPointView
WorldPointSelectViewDataManager.CheckCanOpenSelectPointView = CheckCanOpenSelectPointView
WorldPointSelectViewDataManager.SetTouchCameraZoomChangeBlock = SetTouchCameraZoomChangeBlock
WorldPointSelectViewDataManager.GetTouchCamera = GetTouchCamera
WorldPointSelectViewDataManager.GetDefaultJumpPosAndZoneId = GetDefaultJumpPosAndZoneId
WorldPointSelectViewDataManager.GetZoomMax = GetZoomMax
return WorldPointSelectViewDataManager
