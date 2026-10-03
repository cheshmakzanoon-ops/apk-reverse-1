local LWOpeningStageDirtyWorks = {}

function LWOpeningStageDirtyWorks:Clear()
  self.flyingStarTasks = 0
  if self.listened_GF_guide_start then
    EventManager:GetInstance():RemoveListener(EventId.GF_guide_start, self.PlayAirTimelineBubbles)
    EventManager:GetInstance():RemoveListener(EventId.GF_play_timeline_loaded, self.OnTimelineLoaded)
    self.listened_GF_guide_start = false
  end
  DataCenter.LWOpeningStageManager.utils.ClearAllFingers()
  for i = 1, table.count(self.reqs) do
    if self.reqs[i] then
      self.reqs[i]:Destroy()
    end
  end
  self.reqs = {}
  for i = 1, table.count(self.tweens) do
    if self.tweens[i] then
      self.tweens[i]:Kill()
    end
  end
  self.tweens = {}
  self:ClearAllDelayTimers()
end

local fencesCache = {}
local fencesHided = false

local function __FindAllFences()
  fencesCache = {}
  local CityStatic = CS.UnityEngine.GameObject.Find("City/Static")
  if IsNull(CityStatic) then
    return
  end
  for i = 0, CityStatic.transform.childCount - 1 do
    local child = CityStatic.transform:GetChild(i).gameObject
    if child.name == "O_Object_juma_03(Clone)" or child.name == "O_env_madai_02(Clone)" or child.name == "O_env_madai_03(Clone)" or child.name == "O_env_madai_04(Clone)" then
      table.insert(fencesCache, child)
    end
  end
end

function LWOpeningStageDirtyWorks:HideAllFences()
  __FindAllFences()
  for _, fence in ipairs(fencesCache) do
    fence:SetActive(false)
  end
  fencesHided = true
end

local FENCE_APPEAR_VFX = "Assets/_Art_LastWar/Effect/Prefab/Arms/APS/VFX_animal_grow_big.prefab"
local fenceAppearVFXHandles = {}
local fenceAppearBlockHandle

function LWOpeningStageDirtyWorks:ShowAllFences()
  fenceAppearVFXHandles = {}
  local vfxHandle = CS.GameEntry.Resource:InstantiateAsync(FENCE_APPEAR_VFX)
  vfxHandle:completed("+", function(handle)
    if handle.isError then
      return
    end
    handle.gameObject:SetActive(false)
  end)
  table.insert(fenceAppearVFXHandles, vfxHandle)
  self:HideAllFences()
  table.sort(fencesCache, function(obj1, obj2)
    return obj1.transform.position.x < obj2.transform.position.x
  end)
  local camTrans = CS.UnityEngine.Camera.main.transform
  TimerManager:GetInstance():DelayInvoke(function()
    if IsNull(CS.SceneManager.World) then
      return
    end
    CS.SceneManager.World:LockCamera(Vector3(225.14, 207.7, -92), 0.5)
    camTrans:DOMove(Vector3(275.16, 207.7, -92), 1.8):SetDelay(1.2):OnComplete(function()
      camTrans:DOMove(Vector3(204.05, 150, -39.05), 0.5):SetDelay(0.75):OnComplete(function()
        UIManager:GetInstance():DisableInteractionBlocker(fenceAppearBlockHandle)
        CS.SceneManager.World:FreeCamera()
        for _, vfxHandle in ipairs(fenceAppearVFXHandles) do
          vfxHandle:RealDestroy()
        end
        fenceAppearBlockHandle = nil
        fenceAppearVFXHandles = nil
      end)
    end):OnStart(function()
      DataCenter.LWSoundManager:PlaySound(62235, false)
    end)
  end, 0.5)
  for i, fence in ipairs(fencesCache) do
    TimerManager:GetInstance():DelayInvoke(function()
      local vfxHandle = CS.GameEntry.Resource:InstantiateAsync(FENCE_APPEAR_VFX)
      vfxHandle:completed("+", function(handle)
        if handle.isError then
          return
        end
        handle.gameObject.transform.position = fence.transform.position
        handle.gameObject:SetActive(true)
      end)
      table.insert(fenceAppearVFXHandles, vfxHandle)
      fence:SetActive(true)
    end, 0.1 * i + 1.25)
  end
  fencesHided = false
end

function LWOpeningStageDirtyWorks.DropThreeHeros(bUuid)
  local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildingData == nil or buildingData.itemId ~= 10105000 then
    return
  end
  EventManager:GetInstance():RemoveListener(EventId.BuildUpgradeFinish, LWOpeningStageDirtyWorks.DropThreeHeros)
  CS.SceneManager.World:LockCamera(Vector3(193.8, 150, -36), 0.5)
  local blockHandle = UIManager:GetInstance():EnableInteractionBlocker(2, 5)
  local dropHeros = {
    30006,
    40010,
    30004
  }
  for i = 1, 3 do
    DataCenter.BuildHeroManager:RemoveHeroFromDropList(dropHeros[i])
  end
  TimerManager:GetInstance():DelayInvoke(function()
    CS.SceneManager.World:FreeCamera()
    local slotPos = {
      Vector3(91.7, 0, 66.4),
      Vector3(84.2, 0, 66.4),
      Vector3(91.7, 0, 71.8)
    }
    local squadData = DataCenter.ArmyFormationDataManager:GetFormationByType(EnterHeroSquadPanelWay.ParkingLotBuilding, 1)
    if squadData ~= nil then
      for i = 1, 3 do
        local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(dropHeros[i])
        if squadData.localIndexToHeroDic[i] == nil and heroData ~= nil then
          squadData:SetLocalHero(i, heroData.uuid)
          local vfx1Handle = CS.GameEntry.Resource:InstantiateAsync("Assets/_Art_LastWar/Effect/Prefab/Arms/APS/VFX_animal_grow.prefab")
          vfx1Handle:completed("+", function(handle)
            if handle.isError then
              return
            end
            handle.gameObject.transform.position = slotPos[i]
            TimerManager:GetInstance():DelayInvoke(function()
              handle:RealDestroy()
            end, 1)
          end)
          local vfx2Handle = CS.GameEntry.Resource:InstantiateAsync("Assets/_Art_LastWar/Effect/Prefab/Arms/APS/VFX_xinshou_kongtou.prefab")
          vfx2Handle:completed("+", function(handle)
            if handle.isError then
              return
            end
            handle.gameObject.transform.position = slotPos[i]
            TimerManager:GetInstance():DelayInvoke(function()
              handle:RealDestroy()
            end, 1)
          end)
        end
      end
      SFSNetwork.SendMessage(MsgDefines.NormalFormationInfoSave, squadData.uuid, squadData:GenerateServerHeroArray(), 1)
      UIManager:GetInstance():DisableInteractionBlocker(blockHandle)
    end
  end, 1)
end

local stage4BuildPointIds = {
  4846,
  4646,
  4446,
  4246
}
local stage5BuildPointIds = {
  4842,
  4642,
  4442,
  4242
}

function LWOpeningStageDirtyWorks:Do(enterGame)
  if self.reqs == ni then
    self.reqs = {}
  end
  if self.tweens == ni then
    self.tweens = {}
  end
  local mgr = DataCenter.LWOpeningStageManager
  if #mgr.closeStages == 0 then
    return
  end
  local currStageId = mgr.closeStages[1].id
  if currStageId <= 1 then
    self:HideAllFences()
    if DataCenter.LWGuideManager.curGuideId == GuideState.Soldier then
      local pos = Vector3.New(98, 8, 60)
      DataCenter.LWOpeningStageManager.utils.ClearAllFingers()
      TimerManager:GetInstance():DelayInvoke(function()
        LWOpeningStageDirtyWorks.LoadFingerBubble(pos, 2)
      end, 2)
    end
  elseif currStageId == 2 then
    DataCenter.LWOpeningStageManager.utils.ClearAllFingers()
    local pos = Vector3.New(98, 8, 74)
    if fencesHided then
      fenceAppearBlockHandle = UIManager:GetInstance():EnableInteractionBlocker(2, 5)
      DataCenter.LWOpeningStageManager.utils.SetStageBubbleVisible(currStageId + 1, false)
      TimerManager:GetInstance():DelayInvoke(function()
        self:ShowAllFences()
      end, 0.5)
      TimerManager:GetInstance():DelayInvoke(function()
        LWOpeningStageDirtyWorks.LoadFingerBubble(pos, 3)
        DataCenter.LWOpeningStageManager.utils.SetStageBubbleVisible(currStageId + 1, true)
      end, 4)
    else
      TimerManager:GetInstance():DelayInvoke(function()
        LWOpeningStageDirtyWorks.LoadFingerBubble(pos, 3)
      end, 2)
    end
  elseif currStageId == 3 then
    local gateBuilding = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_GATE)[1]
    if gateBuilding ~= nil and 0 < gateBuilding.level then
      local pos = Vector3.New(98, 8, 88)
      DataCenter.LWOpeningStageManager.utils.ClearAllFingers()
      TimerManager:GetInstance():DelayInvoke(function()
        LWOpeningStageDirtyWorks.LoadFingerBubble(pos, 4)
      end, 2)
    else
      DataCenter.LWOpeningStageManager.utils.SetStageBubbleVisible(currStageId + 1, false)
    end
  elseif currStageId == 4 then
    local pointIds = stage4BuildPointIds
    local birthPos = DataCenter.LWOpeningStageManager.squadProxy.cells[1].position
    local hasWorker = false
    for _, pointId in ipairs(pointIds) do
      local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(pointId)
      if buildData and buildData.level == 0 and buildData.state == BuildingStateType.Normal then
        for i = 1, 3 do
          TimerManager:GetInstance():DelayInvoke(function()
            DataCenter.GainWorkerManager:ShowFakeWorker(10012, buildData, birthPos)
          end, 0.5 * (i - 1))
        end
        hasWorker = true
      end
    end
    if hasWorker then
      DataCenter.LWSoundManager:PlaySound(62237, false)
      if CS.SceneManager.World then
        GoToUtil.GotoPos(Vector3(195.32, 150, -15.3), 150, 2)
      end
    else
      self:CheckShowStage4Finger()
    end
  elseif currStageId == 5 then
    local pointIds = stage5BuildPointIds
    local birthPos = DataCenter.LWOpeningStageManager.squadProxy.cells[1].position
    local hasWorker = false
    for _, pointId in ipairs(pointIds) do
      local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(pointId)
      if buildData and buildData.level == 0 and buildData.state == BuildingStateType.Normal then
        for i = 1, 3 do
          TimerManager:GetInstance():DelayInvoke(function()
            DataCenter.GainWorkerManager:ShowFakeWorker(10012, buildData, birthPos)
          end, 0.5 * (i - 1))
        end
        hasWorker = true
      end
    end
    if hasWorker then
      DataCenter.LWSoundManager:PlaySound(62241, false)
      if CS.SceneManager.World then
        GoToUtil.GotoPos(Vector3(187.38, 150, -14.96), 150, 4)
      end
    else
      self:CheckShowStage5Finger()
    end
  elseif currStageId == 6 then
    if enterGame then
      DataCenter.LWOpeningStageManager.utils.ClearAllFingers()
      local pos = Vector3.New(98, 11, 112.3)
      LWOpeningStageDirtyWorks.LoadFingerBubble(pos, 7)
    end
  elseif currStageId == 7 then
  end
  if not self.listened_GF_guide_start then
    EventManager:GetInstance():AddListener(EventId.GF_guide_start, self.PlayAirTimelineBubbles)
    EventManager:GetInstance():AddListener(EventId.GF_play_timeline_loaded, self.OnTimelineLoaded)
    self.listened_GF_guide_start = true
  end
end

function LWOpeningStageDirtyWorks.OnTimelineLoaded(params)
end

function LWOpeningStageDirtyWorks.PlayAirTimelineBubbles(flowId)
  return
end

function LWOpeningStageDirtyWorks:HeroDebut(mgr)
  local utils = DataCenter.LWOpeningStageManager.utils
  local currStage = mgr.closeStages[1]
  local nextStage = mgr.openStages[1]
  mgr.squadProxy:PlayAnim("run")
  local sid = DataCenter.LWSoundManager:PlaySound(62240)
  mgr.squadProxy.cells[1]:DOMove(utils.GetStagePosArr(currStage)[1], 4):SetEase(CS.DG.Tweening.Ease.Linear):OnComplete(function()
    mgr.squadProxy:PlayAnim("idle")
    if mgr.closeStages[1].over_plot > 0 then
      EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
        plotGroupId = mgr.closeStages[1].over_plot,
        hideMainUI = false
      })
    end
    local lastTime
    DataCenter.LWSoundManager:StopSound(sid)
    utils.ShowFingerClick(utils.GetStagePosArr(nextStage)[1] + Vector3(0, 7, 0), lastTime, 2)
  end)
end

function LWOpeningStageDirtyWorks:MoveToNextStageWaitingPos(callback)
  local stage = DataCenter.LWOpeningStageManager.openStages[1]
  local targetPos = DataCenter.LWOpeningStageManager.utils.GetStagePosArr(stage)[1] + Vector3.New(0, 0, -8)
  DataCenter.LWOpeningStageManager.dirtyWorks:HeroMoveTo(targetPos, callback)
end

function LWOpeningStageDirtyWorks:HeroMoveTo(targetPos, callback)
  local leader = DataCenter.LWOpeningStageManager.squadProxy.cells[1]
  local dir = (targetPos - leader.transform.position):Normalize()
  local dis = Vector3.Distance(targetPos, leader.transform.position)
  for _, cell in ipairs(DataCenter.LWOpeningStageManager.squadProxy.cells) do
    local cellPos = cell.transform.position
    local pos = cellPos + dir * dis
    local t = cell:DOMove(pos, dis * 0.1):SetEase(CS.DG.Tweening.Ease.Linear):OnComplete(function()
      DataCenter.LWOpeningStageManager.squadProxy:PlayAnim("idle")
      if callback ~= nil then
        callback()
      end
    end):OnStart(function()
      DataCenter.LWOpeningStageManager.squadProxy:PlayAnim("run")
    end):SetDelay(0.5)
    table.insert(self.tweens, t)
  end
end

function LWOpeningStageDirtyWorks:GateFixed()
  local pos = Vector3.New(98, 8, 88)
  DataCenter.LWOpeningStageManager.utils.ClearAllFingers()
  self:CreateDelayTimer(function()
    DataCenter.LWSoundManager:PlaySound(80015, false)
  end, 1)
  self:CreateDelayTimer(function()
    DataCenter.LWOpeningStageManager.dirtyWorks.LoadFingerBubble(pos, 4)
    DataCenter.LWOpeningStageManager.utils.SetStageBubbleVisible(4, true)
  end, 2)
end

function LWOpeningStageDirtyWorks:PlotGroupDone(plotGroupId)
  if DataCenter.LWOpeningStageManager.closeStages[1].id == 6 then
    DataCenter.LWOpeningStageManager.utils.SetStageBubbleVisible(7, true)
  elseif DataCenter.LWOpeningStageManager.closeStages[1].id == 7 then
    DataCenter.BuildBubbleManager:ShowBubbleNode()
  end
end

local starResPath = "Assets/Main/Prefabs/LWOpeningStage/Eff_xinshou_xingxingda_tuowei.prefab"
local levelUpVfxPath = "Assets/Main/Prefabs/LWOpeningStage/VFX_xinshou_yimin_jinbiglow.prefab"
local keepOnAbsorbStars, absorbStarDelayTimer
local currAbsorbStarHandle = 0

function LWOpeningStageDirtyWorks:AbsorbStars(count, buildingId, pointId)
  local utils = DataCenter.LWOpeningStageManager.utils
  if absorbStarDelayTimer ~= nil then
    absorbStarDelayTimer:Stop()
    absorbStarDelayTimer = nil
  end
  local absorbStarHandle = math.random(1, 99999999)
  currAbsorbStarHandle = absorbStarHandle
  self.flyingStarTasks = self.flyingStarTasks + 1
  local starWarmup = CS.GameEntry.Resource:InstantiateAsync(starResPath)
  starWarmup:completed("+", function(handle)
    if handle.isError then
      return
    end
    starWarmup:Destroy()
  end)
  local level, needStars, lackStars = utils.GetLeaderLevelInfo(DataCenter.LWOpeningStageManager.squadProxy.stars)
  if level == 1 and needStars == lackStars then
    utils.UpdateStarsHud(needStars, lackStars)
  end
  local starNumForThisTime = math.min(count, lackStars)
  DataCenter.LWOpeningStageManager.squadProxy.stars = DataCenter.LWOpeningStageManager.squadProxy.stars + starNumForThisTime
  local restStars = count - starNumForThisTime
  if 0 < restStars then
    keepOnAbsorbStars = {
      restStars,
      buildingId,
      pointId
    }
  end
  
  local function levelUpCallback()
    utils.FocusCameraToLeader(DataCenter.LWOpeningStageManager.squadProxy.cells[1], 0.25, function()
      TimerManager:GetInstance():DelayInvoke(function()
        local levelUpVfxHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/_Art_LastWar/Effect/Prefab/Arms/APS/VFX_xinshou_xiangzi_open.prefab")
        levelUpVfxHandle:completed("+", function(handle)
          if handle.isError then
            return
          end
          local level, needStars, lackStars = utils.GetLeaderLevelInfo(DataCenter.LWOpeningStageManager.squadProxy.stars)
          local appearence, heroId = utils.GetLeaderAppearenceByLevel(level)
          utils.LoadHeroRes(appearence.model_path, 1)
          utils.UpdateStarsHud(needStars, lackStars)
          handle.gameObject.transform.position = DataCenter.LWOpeningStageManager.squadProxy.cells[1].transform.position
          TimerManager:GetInstance():DelayInvoke(function()
            self.flyingStarTasks = self.flyingStarTasks - 1
            levelUpVfxHandle:Destroy()
            utils.FocusCameraToLeader(DataCenter.LWOpeningStageManager.squadProxy.cells[1], 0.5, function()
              self:KeepAbsorbStars()
            end, 150)
          end, 1)
          local bubblePlotId = LocalController:instance():getValue("lw_opening_hero", level, "plot_bubble")
          if 0 < bubblePlotId then
            local bubbleParams = {}
            bubbleParams.plotId = bubblePlotId
            bubbleParams.anchor = DataCenter.LWOpeningStageManager.squadProxy.cells[1].position + Vector3(0, 3, 0)
            bubbleParams.mode = "3D"
            EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, bubbleParams)
          end
          if level == 2 then
            for _, task in ipairs(DataCenter.ChapterTaskManager:GetAllChapterTask()) do
              if task.state == TaskState.CanReceive then
                local fingerHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger.prefab")
                fingerHandle:completed("+", function(handle)
                  if handle.isError then
                    return
                  end
                  local gameObject = handle.gameObject
                  local transform = gameObject.transform
                  transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Guide.Name).transform, false)
                  transform.position = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain).View.bottom:GetQuestPosition()
                  TimerManager:GetInstance():DelayInvoke(function()
                    fingerHandle:Destroy()
                  end, 3)
                end)
                break
              end
            end
          end
        end)
      end, 0.3)
    end, 130)
  end
  
  local function doneCallback()
    self.flyingStarTasks = self.flyingStarTasks - 1
    if currAbsorbStarHandle == absorbStarHandle then
      CS.SceneManager.World:FreeCamera()
    end
  end
  
  local srcPos = utils.BuildingPointID_to_WorldPos(buildingId, pointId) + Vector3(0, 4, 0)
  CS.SceneManager.World:LockCamera(utils.BuildingPointID_to_CameraPos(buildingId, pointId, 180), 0.5)
  for i = 1, starNumForThisTime do
    local jumpPosOffset, jump2Right
    local diffX = srcPos.x - DataCenter.LWOpeningStageManager.squadProxy.cells[1].position.x
    local diffZ = srcPos.z - DataCenter.LWOpeningStageManager.squadProxy.cells[1].position.z
    jump2Right = math.abs(diffX) > math.abs(diffZ) and 0 < diffX or 0 < diffZ
    if jump2Right then
      jumpPosOffset = Quaternion.Euler(0, 0, 10 + i * 16) * Vector3(4, 0, 4)
    else
      jumpPosOffset = Quaternion.Euler(10 + i * 16, 0, 0) * Vector3(-4, 0, -4)
    end
    TimerManager:GetInstance():DelayInvoke(function()
      utils.DoStarAnim(srcPos, srcPos + jumpPosOffset, i == starNumForThisTime and (lackStars <= count and levelUpCallback or doneCallback) or nil)
    end, 0.2 * (i - 1) + 0.5)
  end
  absorbStarDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
    utils.FocusCameraToLeader(DataCenter.LWOpeningStageManager.squadProxy.cells[1], 0.5, nil, 150)
  end, 1.2)
end

function LWOpeningStageDirtyWorks:KeepAbsorbStars()
  local utils = DataCenter.LWOpeningStageManager.utils
  if keepOnAbsorbStars ~= nil then
    local count = keepOnAbsorbStars[1]
    local buildingId = keepOnAbsorbStars[2]
    local pointId = keepOnAbsorbStars[3]
    keepOnAbsorbStars = nil
    self:AbsorbStars(count, buildingId, pointId)
  else
    local checkResult = DataCenter.LWOpeningStageManager:CheckNextStageConditions()
    if checkResult == 0 then
      utils.FocusCameraToNextStage(0.5, nil, 150)
    end
    CS.SceneManager.World:FreeCamera()
  end
end

local ZAKU_ZOMBIE_CONFIGS

function LWOpeningStageDirtyWorks:ShowInTroubledFellow()
  if ZAKU_ZOMBIE_CONFIGS == nil then
    ZAKU_ZOMBIE_CONFIGS = {
      {
        id = 1,
        pos = Vector3(96.32, 0.28, 110.42),
        rot = Quaternion.Euler(0, -198.97, 0),
        model = "Assets/Main/Prefabs/LWOpeningStage/ZakuB.prefab",
        walkTime = 6
      },
      {
        id = 2,
        pos = Vector3(98.88, 0.28, 110.97),
        rot = Quaternion.Euler(0, -172.1, 0),
        model = "Assets/Main/Prefabs/LWOpeningStage/ZakuB.prefab",
        walkTime = 6
      },
      {
        id = 3,
        pos = Vector3(97.6, 0.28, 110.05),
        rot = Quaternion.Euler(0, -185.5, 0),
        model = "Assets/Main/Prefabs/LWOpeningStage/ZakuC.prefab",
        walkTime = 5
      },
      {
        id = 4,
        pos = Vector3(96.75, 0.28, 108.81),
        rot = Quaternion.Euler(0, -195.6, 0),
        model = "Assets/Main/Prefabs/LWOpeningStage/ZakuC.prefab",
        walkTime = 4
      },
      {
        id = 5,
        pos = Vector3(98.92, 0.28, 109.3),
        rot = Quaternion.Euler(0, -169.6, 0),
        model = "Assets/Main/Prefabs/LWOpeningStage/ZakuB.prefab",
        walkTime = 4
      }
    }
  end
  local utils = DataCenter.LWOpeningStageManager.utils
  local soloHeroCfg = {
    rot = Quaternion.Euler(0, 0, 0),
    model = "Assets/Main/Prefabs/LWOpeningStage/SoloHero.prefab",
    size = 1.2
  }
  for _, stage in ipairs(DataCenter.LWOpeningStageManager.openStages) do
    if stage.id == 6 then
      soloHeroCfg.pos = utils.GetStagePosArr(stage)[1]
      break
    end
  end
  utils.CreateSoloHero(soloHeroCfg)
  for i = 1, #ZAKU_ZOMBIE_CONFIGS do
    TimerManager:GetInstance():DelayInvoke(function()
      utils.CreateZakuZombie(ZAKU_ZOMBIE_CONFIGS[i])
    end, math.random() * 2)
  end
end

local THROW_WORKER_DELAY = 1
local THROW_WORKER_INTERVAL = 0.5

function LWOpeningStageDirtyWorks:ThrowAllWorkers()
  local birthPos = DataCenter.LWOpeningStageManager.squadProxy.cells[1].position
  for i, workerData in ipairs(DataCenter.GainWorkerManager:GetAllWorkers()) do
    TimerManager:GetInstance():DelayInvoke(function()
      local workerUid = workerData.uid
      local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(workerData.modelId)
      local modelPath = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "city_model_path")
      local targetBuilding, workingSlot = DataCenter.GainWorkerManager.GetWorkerExistBuild(workerData, birthPos)
      if targetBuilding ~= nil and workingSlot ~= nil then
        local targetPos = targetBuilding:GetCenterVec()
        DataCenter.LWOpeningStageManager.utils.FireHumanCannon(workerData.cfgId, modelPath, birthPos, targetPos, function()
          if targetBuilding.level == 0 then
            local param = {}
            param.uuid = tostring(targetBuilding.uuid)
            param.gold = BuildUpgradeUseGoldType.No
            param.upLevel = 1
            param.clientParam = ""
            param.truckId = 0
            param.pathTime = 0
            param.robotUuid = 0
            param.workerId = workerUid
            SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew, param)
          else
            SFSNetwork.SendMessage(MsgDefines.BuildAssignHeroMessage, targetBuilding.uuid, workingSlot, workerUid)
          end
          SFSNetwork.SendMessage(MsgDefines.WorkerChangeStateMessgae, workerUid, 1)
          DataCenter.GainWorkerManager:ReduceTempBuilding(targetBuilding.uuid)
          local vfxHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/_Art_LastWar/Effect/Prefab/xinshou/Eff_xinshou_gongzuo.prefab")
          vfxHandle:completed("+", function(handle)
            handle.gameObject.transform.position = targetPos + Vector3(0, 0, 0)
            TimerManager:GetInstance():DelayInvoke(function()
              if not IsNull(handle) then
                handle:Destroy()
              end
            end, 2)
          end)
        end)
        DataCenter.GainWorkerManager:AddTempBuilding(targetBuilding.uuid)
      end
      DataCenter.GainWorkerManager.tipUtil:RemoveTipByUid(workerUid)
    end, (i - 1) * THROW_WORKER_INTERVAL + THROW_WORKER_DELAY)
  end
end

function LWOpeningStageDirtyWorks:FakeGetGump()
  local one = HeroInfo.New()
  one.heroId = 30005
  EventManager:GetInstance():Broadcast(EventId.GF_get_new_hero, one)
end

function LWOpeningStageDirtyWorks:CheckFakeNewHero(levelId)
end

function LWOpeningStageDirtyWorks:ShowFakeHero(nextLevel, index, newHero)
end

function LWOpeningStageDirtyWorks.LoadFingerBubble(pos, stageId)
  local utils = DataCenter.LWOpeningStageManager.utils
  local currStageId = DataCenter.LWOpeningStageManager:GetCurStageId()
  if currStageId and currStageId == stageId then
    utils.ShowFingerClick(pos, nil, 2)
  end
end

local function LoadHammerBuildingBubble()
  local obj = DataCenter.BuildBubbleManager:GetBubbleObjByBubbleTypeAndBuildId(BuildBubbleType.BuildHammer, BuildingTypes.LW_BUILD_GATE)
  if obj then
    local worldPointPos = obj.transform.position
    DataCenter.LWOpeningStageManager.dirtyWorks.LoadFingerBubble(worldPointPos, 4)
  end
end

function LWOpeningStageDirtyWorks.OnUIWindowClose(windowName)
  local self = DataCenter.LWOpeningStageManager.dirtyWorks
  local currStageId = DataCenter.LWOpeningStageManager:GetCurStageId()
  if windowName == UIWindowNames.UIHeroExhibitPanel and currStageId == 4 then
    DataCenter.BuildBubbleManager:ShowBubbleNode()
    LoadHammerBuildingBubble()
  end
end

function LWOpeningStageDirtyWorks.LoadFingerBubbleByBuildingBubble(buildingParam)
  local currStageId = DataCenter.LWOpeningStageManager:GetCurStageId()
  local self = DataCenter.LWOpeningStageManager.dirtyWorks
  self:CreateDelayTimer(function()
    local plotWindowOpen = UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWPlot)
    local exhibitWindowOpen = UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIHeroExhibitPanel)
    if not plotWindowOpen and not exhibitWindowOpen and currStageId == 4 then
      LoadHammerBuildingBubble()
    end
  end, 1)
end

function LWOpeningStageDirtyWorks.OnWelcomeNewFellowFinish()
  if CS.SceneManager:IsInCity() and #DataCenter.LWOpeningStageManager.closeStages > 0 and DataCenter.LWOpeningStageManager.closeStages[1].id == 6 then
    DataCenter.LWOpeningStageManager.utils.ClearAllFingers()
    local pos = Vector3.New(98, 11, 112.3)
    LWOpeningStageDirtyWorks.LoadFingerBubble(pos, 7)
  end
end

function LWOpeningStageDirtyWorks:TryOnBuildTimeEnd(buildData)
  if buildData and buildData.pointId then
    self:CheckShowStage4Finger(buildData.pointId)
    self:CheckShowStage5Finger(buildData.pointId)
  end
end

function LWOpeningStageDirtyWorks:TryOnBuildUpgradeFinish(buildPointId)
  if buildPointId then
    self:CheckShowStage4Finger(buildPointId)
    self:CheckShowStage5Finger(buildPointId)
  end
end

function LWOpeningStageDirtyWorks:CheckShowStage4Finger(targetPointId)
  local mgr = DataCenter.LWOpeningStageManager
  if mgr.closeStages == nil then
    return
  end
  local currStageId = mgr.closeStages[1] and mgr.closeStages[1].id or 0
  if currStageId ~= 4 then
    return
  end
  for _, pointId in ipairs(stage4BuildPointIds) do
    local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(pointId)
    if buildData then
      if buildData.level == 0 then
        if buildData.state == BuildingStateType.Normal then
          return
        end
        if buildData.state == BuildingStateType.Upgrading then
          if buildData:IsUpgradeFinish() then
            if targetPointId ~= nil and targetPointId ~= pointId then
              return
            end
            local pos = SceneUtils.TileIndexToWorld(buildData.pointId, ForceChangeScene.City)
            pos.y = pos.y + 2
            pos.x = pos.x - 1
            DataCenter.LWOpeningStageManager.utils.ClearAllFingers()
            LWOpeningStageDirtyWorks.LoadFingerBubble(pos, 5)
            return
          end
          return
        end
      elseif buildData.level == 1 then
        targetPointId = nil
      end
    end
  end
  DataCenter.LWOpeningStageManager.utils.ClearAllFingers()
  local pos = Vector3.New(98, 8, 96)
  LWOpeningStageDirtyWorks.LoadFingerBubble(pos, 5)
end

function LWOpeningStageDirtyWorks:CheckShowStage5Finger(targetPointId)
  local mgr = DataCenter.LWOpeningStageManager
  if mgr.closeStages == nil then
    return
  end
  local currStageId = mgr.closeStages[1] and mgr.closeStages[1].id or 0
  if currStageId ~= 5 then
    return
  end
  for _, pointId in ipairs(stage5BuildPointIds) do
    local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(pointId)
    if buildData then
      if buildData.level == 0 then
        if buildData.state == BuildingStateType.Normal then
          return
        end
        if buildData.state == BuildingStateType.Upgrading then
          if buildData:IsUpgradeFinish() then
            if targetPointId ~= nil and targetPointId ~= pointId then
              return
            end
            local pos = SceneUtils.TileIndexToWorld(buildData.pointId, ForceChangeScene.City)
            pos.y = pos.y + 2
            pos.x = pos.x - 1
            DataCenter.LWOpeningStageManager.utils.ClearAllFingers()
            LWOpeningStageDirtyWorks.LoadFingerBubble(pos, 6)
            return
          end
          return
        end
      elseif buildData.level == 1 then
        targetPointId = nil
      end
    end
  end
  DataCenter.LWOpeningStageManager.utils.ClearAllFingers()
  local pos = Vector3.New(98, 8, 104)
  LWOpeningStageDirtyWorks.LoadFingerBubble(pos, 6)
end

function LWOpeningStageDirtyWorks:CreateDelayTimer(callback, delay, timerName)
  if self.delayTimers == nil then
    self.delayTimers = {}
  end
  timerName = timerName or "timer_" .. tostring(#self.delayTimers + 1)
  local timer = TimerManager:GetInstance():DelayInvoke(function()
    if self.delayTimers[timerName] then
      self.delayTimers[timerName] = nil
    end
    callback()
  end, delay)
  self.delayTimers[timerName] = timer
  return timer
end

function LWOpeningStageDirtyWorks:ClearAllDelayTimers()
  if self.delayTimers then
    for name, timer in pairs(self.delayTimers) do
      if timer then
        timer:Stop()
      end
    end
    self.delayTimers = {}
  end
end

return LWOpeningStageDirtyWorks
