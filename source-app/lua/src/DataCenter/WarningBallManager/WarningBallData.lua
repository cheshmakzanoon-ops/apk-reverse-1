local WarningBallData = BaseClass("WarningBallData")

local function __init(self)
  self.msgType = MessageBallType.None
  self.ballIcon = ""
  self.ballName = ""
  self.clickAction = nil
  self.isVanish = true
  self.order = -1
  self.param = nil
  self.id = 0
  self.land_cd = 0
  self.warn_cd = 0
  self.ballState = WarningBallState.Free
  self.endTime = 0
  self.needCheckFlag = 1
  self.describe = ""
  self.condition = {}
  self.forbidden = {}
end

local function __delete(self)
  self.msgType = nil
  self.ballIcon = nil
  self.ballName = nil
  self.clickAction = nil
  self.isVanish = nil
  self.order = nil
  self.param = nil
  self.describe = nil
end

local function InitData(self, row, startTime)
  self.id = row:getValue("id")
  self.msgType = row:getValue("type")
  self.ballIcon = row:getValue("icon_pre")
  self.ballName = row:getValue("name")
  self.order = row:getValue("order")
  self.land_cd = row:getValue("land_cd")
  self.warn_cd = row:getValue("warn_cd")
  self.describe = row:getValue("describe")
  if self.land_cd ~= nil and self.land_cd > 0 then
    self.endTime = self.land_cd * 1000 + startTime
    self:SetBallState(WarningBallState.Wait)
  else
    self:SetBallState(WarningBallState.Free)
  end
  local conditionStr = row:getValue("condition") or ""
  local forbiddenStr = row:getValue("Forbidden") or ""
  local conditionArr = string.split(conditionStr, ",")
  local forbiddenArr = string.split(forbiddenStr, ",")
  if #conditionArr == 2 then
    self.condition[toInt(conditionArr[1])] = toInt(conditionArr[2])
  end
  if #forbiddenArr == 2 then
    self.forbidden[toInt(forbiddenArr[1])] = toInt(forbiddenArr[2])
  end
end

local function CheckIsCanCheck(self, curTime)
  if curTime < self.endTime then
    return false
  end
  if self:IsInGuide() then
    return false
  end
  for k, v in pairs(self.condition) do
    local level = DataCenter.BuildManager:GetMaxBuildingLevel(k)
    if v > level then
      return false
    end
  end
  for k, v in pairs(self.forbidden) do
    local level = DataCenter.BuildManager:GetMaxBuildingLevel(k)
    if v <= level then
      return false
    end
  end
  return true
end

local function IsInGuide(self)
  return DataCenter.GuideManager:InGuide()
end

local function ResetCDTime(self)
  self.endTime = 0
end

local function SetBallState(self, state)
  if state == WarningBallState.Show then
    local a = 1
  end
  self.ballState = state
end

local function ChangeNeedCheckFlag(self, state)
  if state then
    self.needCheckFlag = 1
  else
    self.needCheckFlag = 0
  end
end

local function OnActionClick(self)
  if self.param ~= nil then
    local param = self.param
    if param ~= nil then
      if param.msgType == MessageBallType.BuildingUpgrade then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(param.buildUuid)
        if buildData ~= nil then
          local pointId = buildData.pointId
          GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(pointId), CS.SceneManager.World.InitZoom)
          GoToUtil.CloseAllWindows()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldTileUI, {
            anim = true,
            playEffect = false,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, pointId)
        end
      elseif param.msgType == MessageBallType.CanGatherFarm then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(param.buildUuid)
        if buildData ~= nil then
          local pointId = buildData.pointId
          local onComplete
          
          function onComplete()
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIFarmGather, {
              anim = true,
              playEffect = false,
              UIMainAnim = UIMainAnimType.LeftRightBottomHide
            }, param.buildUuid)
          end
          
          CS.SceneManager.World:AutoFocus(SceneUtils.TileIndexToWorld(pointId), CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, true, onComplete)
          GoToUtil.CloseAllWindows()
        end
      elseif param.msgType == MessageBallType.EmptyFarm then
        local buildIdList = DataCenter.QueueDataManager:GetBuildUuidInFreeQueueByType(NewQueueType.Field)
        local bUuid = 0
        if buildIdList ~= nil and 0 < table.count(buildIdList) then
          if CS.SceneManager:IsInWorld() or CS.SceneManager:IsInCity() then
            local pos = CS.SceneManager.World.CurTarget
            local tile = SceneUtils.WorldToTileIndex(pos)
            local currentCenterPos = SceneUtils.IndexToTilePos(tile)
            table.sort(buildIdList, function(k, v)
              local buildDataA = DataCenter.BuildManager:GetBuildingDataByUuid(k)
              local buildDataB = DataCenter.BuildManager:GetBuildingDataByUuid(v)
              if buildDataB == nil or buildDataA == nil then
                return false
              end
              local posA = SceneUtils.IndexToTilePos(buildDataA.pointId)
              local posB = SceneUtils.IndexToTilePos(buildDataB.pointId)
              return Vector2.Distance(currentCenterPos, posB) > Vector2.Distance(currentCenterPos, posA)
            end)
          end
          bUuid = buildIdList[1]
        end
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
        if buildData ~= nil then
          do
            local pointId = buildData.pointId
            local onComplete
            
            function onComplete()
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIFarm, {
                anim = true,
                playEffect = false,
                UIMainAnim = UIMainAnimType.LeftRightBottomHide
              }, bUuid)
            end
            
            CS.SceneManager.World:AutoFocus(SceneUtils.TileIndexToWorld(pointId), CS.LookAtFocusState.FarmPlant, LookAtFocusTime, true, true, onComplete)
            GoToUtil.CloseAllWindows()
          end
        end
      elseif param.msgType == MessageBallType.JoinRoad then
        GoToUtil.GotoBuildRoad(param.buildUuid, false, true)
      elseif param.msgType == MessageBallType.MoneyFull then
        GoToUtil.GotoCityByBuildUuid(param.buildUuid)
      elseif param.msgType == MessageBallType.WaterFull then
        GoToUtil.GotoCityByBuildUuid(param.buildUuid)
      elseif param.msgType == MessageBallType.OilFull then
        GoToUtil.GotoCityByBuildUuid(param.buildUuid)
      elseif param.msgType == MessageBallType.MetalFull then
        GoToUtil.GotoCityByBuildUuid(param.buildUuid)
      elseif param.msgType == MessageBallType.ElectricityFull then
        GoToUtil.GotoCityByBuildUuid(param.buildUuid)
      elseif param.msgType == MessageBallType.BuildingComplete then
        GoToUtil.GotoCityByBuildUuid(param.buildUuid)
      elseif param.msgType == MessageBallType.SoldierTrainComplete then
        GoToUtil.GotoCityByBuildUuid(param.buildUuid)
      elseif param.msgType == MessageBallType.ScienceSearchComplete then
        GoToUtil.GotoCityByBuildUuid(param.buildUuid)
      elseif param.msgType == MessageBallType.ArmyQueueFree then
        GoToUtil.GotoCityByBuildUuid(param.buildUuid)
      elseif param.msgType == MessageBallType.EmptyPasture then
        GoToUtil.GotoPastureByUuid(param.buildUuid)
      elseif param.msgType == MessageBallType.CanGatherPasture then
        GoToUtil.GotoPastureByUuid(param.buildUuid)
      elseif param.msgType == MessageBallType.FactoryFree then
        GoToUtil.GotoCityByBuildUuid(param.buildUuid)
      elseif param.msgType == MessageBallType.FactoryCanGather then
        GoToUtil.GotoCityByBuildUuid(param.buildUuid, nil, false)
      elseif param.msgType == MessageBallType.HeroStationWarning then
        local buildId = DataCenter.HeroStationManager:GetBuildIdByStationId(param.stationId)
        GoToUtil.GotoCityByBuildId(buildId, WorldTileBtnType.Hero_Station)
      elseif param.msgType == MessageBallType.FactoryFreeNew then
        GoToUtil.GotoCityByBuildUuid(param.buildUuid)
      elseif param.msgType == MessageBallType.BagMax then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityFull)
      end
      if self.warn_cd ~= nil then
        if 0 < self.warn_cd then
          local curTime = UITimeManager:GetInstance():GetServerTime()
          self.endTime = self.warn_cd * 1000 + curTime
          self:SetBallState(WarningBallState.Cold)
        elseif self.warn_cd == -1 then
          self.endTime = 0
          self:SetBallState(WarningBallState.ShowOnce)
        end
        self.needCheckFlag = 1
      end
    end
  end
end

local function SetClickAction(self, func)
  self.clickAction = func
end

local function SetParam(self, param)
  self.param = param
end

WarningBallData.__init = __init
WarningBallData.__delete = __delete
WarningBallData.InitData = InitData
WarningBallData.OnActionClick = OnActionClick
WarningBallData.SetClickAction = SetClickAction
WarningBallData.SetBallState = SetBallState
WarningBallData.SetParam = SetParam
WarningBallData.ChangeNeedCheckFlag = ChangeNeedCheckFlag
WarningBallData.ResetCDTime = ResetCDTime
WarningBallData.CheckIsCanCheck = CheckIsCanCheck
WarningBallData.IsInGuide = IsInGuide
return WarningBallData
