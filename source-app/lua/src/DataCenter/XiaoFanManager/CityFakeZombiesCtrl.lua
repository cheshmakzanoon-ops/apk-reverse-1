local CityFakeZombiesCtrl = {}
local zombieRes
local battleTopEffectPath = "Assets/Main/Prefabs/Monopoly/Effect/battleEffect.prefab"
local triggerFlow = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k9")
local finishFlow = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k10")
local killZombieFlow = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k14")
local triggerProtectFlow = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k16")
local killZombiePlotId = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k19")
local featureStageId = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k11")
CityFakeZombiesCtrl.timelineSyncHandle = nil
CityFakeZombiesCtrl.timelines = {}
CityFakeZombiesCtrl.zombiesState = 0
CityFakeZombiesCtrl.countStageFinish = false
CityFakeZombiesCtrl.__blockerHandleID = nil
CityFakeZombiesCtrl.__plotBlockerHandleID = nil
CityFakeZombiesCtrl.fogRevealer = nil
CityFakeZombiesCtrl.fenceGo = nil
CityFakeZombiesCtrl.isHideBuildBubbleNode = nil

function CityFakeZombiesCtrl.OnEnterCity()
  if zombieRes == nil then
    if LuaEntry.Player.abTest == "" then
      return
    end
    zombieRes = {
      resPath = "Assets/Main/Prefabs/LWOpeningStage/dagouruchang_timeline.prefab"
    }
  end
  triggerFlow = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k9")
  finishFlow = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k24")
  killZombieFlow = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k14")
  triggerProtectFlow = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k16")
  killZombiePlotId = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k19")
  featureStageId = LuaEntry.DataConfig:TryGetNum("guide_save_girl", "k11")
  if triggerFlow <= 0 or finishFlow <= 0 then
    return
  end
  if (DataCenter.LWGuideFlowManager:ReadDone(triggerFlow) or 0 < triggerProtectFlow and DataCenter.LWGuideFlowManager:ReadDone(triggerProtectFlow)) and DataCenter.LWGuideFlowManager.Runner.runningFlowId ~= triggerProtectFlow and not DataCenter.LWGuideFlowManager:ReadDone(finishFlow) then
    CityFakeZombiesCtrl.zombiesState = 0
    if CityFakeZombiesCtrl.countStageFinish then
      CityFakeZombiesCtrl.countStageFinish = false
      DataCenter.LWGuideFlowManager.Runner:Run(finishFlow)
      CityFakeZombiesCtrl.zombiesState = 2
      CityFakeZombiesCtrl.ShowBuildBubbleNode()
    else
      DataCenter.LWGuideFlowManager.Runner:Run(killZombieFlow)
      CityFakeZombiesCtrl.LoadZombies()
      CityFakeZombiesCtrl.HideBuildBubbleNode()
    end
  else
    local playTimelineGuideDone = DataCenter.LWGuideFlowManager:ReadDone(DataCenter.LWArmedUpgradeManager.playTimelineGuideId)
    local clickCityMonicaGuideDone = DataCenter.LWGuideFlowManager:ReadDone(DataCenter.LWArmedUpgradeManager.clickCityMonicaGuideId)
    if playTimelineGuideDone and not clickCityMonicaGuideDone then
      DataCenter.LWGuideFlowManager:TryTriggerFlexibly(DataCenter.LWArmedUpgradeManager.clickCityMonicaProtectGuidId)
    end
  end
end

function CityFakeZombiesCtrl.LoadZombies()
  DataCenter.LWGuideFlowManager:Log("@@ CityFakeZombiesCtrl.LoadZombies: " .. tostring(IsNull(CityFakeZombiesCtrl.timelineSyncHandle)))
  CityFakeZombiesCtrl.ClearTimeHandle()
  if IsNull(CityFakeZombiesCtrl.timelineSyncHandle) then
    if CityFakeZombiesCtrl.__blockerHandleID then
      UIManager:GetInstance():DisableInteractionBlocker(CityFakeZombiesCtrl.__blockerHandleID)
      CityFakeZombiesCtrl.__blockerHandleID = nil
    end
    CityFakeZombiesCtrl.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, 11)
    CityFakeZombiesCtrl.timelineSyncHandle = CS.GameEntry.Resource:InstantiateAsync(zombieRes.resPath)
    CityFakeZombiesCtrl.timelineSyncHandle:completed("+", function(handle)
      DataCenter.LWGuideFlowManager:Log("@@ CityFakeZombiesCtrl.LoadZombies: " .. "load completed !")
      UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldTileUI)
      UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint)
      local go = CityFakeZombiesCtrl.timelineSyncHandle.gameObject
      local touchRoot = go.transform:Find("clickGo")
      CityFakeZombiesCtrl.timelines.go = go
      CityFakeZombiesCtrl.timelines.touchRoot = touchRoot.gameObject
      touchRoot.gameObject:SetActive(false)
      if not IsNull(touchRoot) then
        local touchTrigger = touchRoot.gameObject:GetComponent(typeof(CS.TouchObjectEventTrigger))
        if not IsNull(touchTrigger) then
          CityFakeZombiesCtrl.idleTouchTrigger = touchTrigger
          touchTrigger.onPointerClick = CityFakeZombiesCtrl.EnterBattle
        end
      end
      if CityFakeZombiesCtrl.zombiesState == 1 then
        local director = go:GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
        CityFakeZombiesCtrl.inDirector = director
        CityFakeZombiesCtrl.inTimeHandle = TimerManager:GetInstance():DelayInvoke(function()
          EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
          if CityFakeZombiesCtrl.__blockerHandleID then
            UIManager:GetInstance():DisableInteractionBlocker(CityFakeZombiesCtrl.__blockerHandleID)
            CityFakeZombiesCtrl.__blockerHandleID = nil
          end
          CityFakeZombiesCtrl.inTimeHandle = nil
          CityFakeZombiesCtrl.inLoopTimeHandle = TimerManager:GetInstance():GetTimer(3, function()
            if not IsNull(CityFakeZombiesCtrl.inDirector) then
              if IsNull(CityFakeZombiesCtrl.timelineSyncHandle) then
                return
              end
              CityFakeZombiesCtrl.inDirector.time = 10
            end
          end, nil, false, false, false)
          CityFakeZombiesCtrl.inLoopTimeHandle:Start()
          CityFakeZombiesCtrl.ClearFog()
          if 0 < killZombiePlotId then
            CityFakeZombiesCtrl.__plotBlockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, 2)
            EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = killZombiePlotId, hideMainUI = true})
          else
            CityFakeZombiesCtrl.OnZombieEnterFinish()
          end
        end, 10, nil)
        if not IsNull(director) then
          director:Play()
          EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, false)
        end
        local cityPos = DataCenter.BuildManager.main_city_pos
        local tilePos = Vector2.New(5 + cityPos.x - 3, 12 + cityPos.y + 2)
        local fogPos = SceneUtils.TileToWorld(tilePos)
        local inCity = SceneUtils.GetIsInCity()
        if inCity and DataCenter.CityZoneMgr.cityZoneFog.loadComplete then
          CityFakeZombiesCtrl.fogRevealer = CS.FOWRevealer()
          CityFakeZombiesCtrl.fogRevealer:Init(fogPos, Vector2.New(10.0, 10.0))
        end
        local cityZone = DataCenter.CityZoneMgr:GetCityZone(9)
        if cityZone and cityZone.GetWallGo then
          local wallGo = cityZone:GetWallGo()
          if not IsNull(wallGo) then
            local fence = wallGo.transform:Find("O_env_wall_weilan_t_04")
            if not IsNull(fence) then
              CityFakeZombiesCtrl.fenceGo = fence.gameObject
              CityFakeZombiesCtrl.fenceGo:SetActive(false)
            end
          end
        end
      elseif CityFakeZombiesCtrl.zombiesState == 2 then
      else
        if CityFakeZombiesCtrl.__blockerHandleID then
          UIManager:GetInstance():DisableInteractionBlocker(CityFakeZombiesCtrl.__blockerHandleID)
          CityFakeZombiesCtrl.__blockerHandleID = nil
        end
        if CityFakeZombiesCtrl.__plotBlockerHandleID then
          UIManager:GetInstance():DisableInteractionBlocker(CityFakeZombiesCtrl.__plotBlockerHandleID)
          CityFakeZombiesCtrl.__plotBlockerHandleID = nil
        end
        CityFakeZombiesCtrl.timelines.touchRoot:SetActive(true)
        local director = go:GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
        CityFakeZombiesCtrl.inDirector = director
        CityFakeZombiesCtrl.inLoopTimeHandle = TimerManager:GetInstance():GetTimer(3, function()
          if not IsNull(CityFakeZombiesCtrl.inDirector) then
            if IsNull(CityFakeZombiesCtrl.timelineSyncHandle) then
              return
            end
            CityFakeZombiesCtrl.inDirector.time = 10
          end
        end, nil, false, false, false)
        CityFakeZombiesCtrl.inDirector.time = 10
        CityFakeZombiesCtrl.inLoopTimeHandle:Start()
        if not IsNull(director) then
          director:Play()
        end
        CityFakeZombiesCtrl.ClearBattleEffect()
        CityFakeZombiesCtrl.LoadBattleEffect()
      end
    end)
  elseif not IsNull(CityFakeZombiesCtrl.timelines.touchRoot) then
    CityFakeZombiesCtrl.timelines.touchRoot:SetActive(true)
  end
end

function CityFakeZombiesCtrl.OnUpdate()
end

function CityFakeZombiesCtrl.OnZombieEnterFinish()
  EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
  CityFakeZombiesCtrl.timelines.touchRoot:SetActive(true)
  if DataCenter.LWGuideFlowManager.Runner.runningFlowId ~= killZombieFlow then
    DataCenter.LWGuideFlowManager.Runner:Run(killZombieFlow)
  end
  CityFakeZombiesCtrl.ClearBattleEffect()
  CityFakeZombiesCtrl.LoadBattleEffect()
end

function CityFakeZombiesCtrl.OnGuideFlowCanceled(flowId)
  if killZombieFlow <= 0 then
    return
  end
  if flowId == killZombieFlow then
    CityFakeZombiesCtrl.countStageFinish = false
    DataCenter.LWGuideFlowManager.Runner:Run(finishFlow)
    CityFakeZombiesCtrl.ZombiesOut()
  end
end

function CityFakeZombiesCtrl.OnGuideFlowDone(flowId)
  DataCenter.LWGuideFlowManager:Log("@@ CityFakeZombiesCtrl.OnGuideFlowDone: " .. flowId .. " /1")
  if triggerFlow <= 0 or finishFlow <= 0 then
    return
  end
  DataCenter.LWGuideFlowManager:Log("@@ CityFakeZombiesCtrl.OnGuideFlowDone: " .. flowId .. " /2")
  if flowId == triggerFlow or 0 < triggerProtectFlow and flowId == triggerProtectFlow then
    DataCenter.LWGuideFlowManager:Log("@@ CityFakeZombiesCtrl.OnGuideFlowDone: " .. flowId .. " /3")
    CityFakeZombiesCtrl.zombiesState = 1
    CityFakeZombiesCtrl.LoadZombies()
    CityFakeZombiesCtrl.HideBuildBubbleNode()
  end
  if flowId == finishFlow then
    local build = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
    if build ~= nil then
      DataCenter.BuildBubbleManager:CheckShowBubble(build.uuid)
    end
  end
end

function CityFakeZombiesCtrl.ZombiesOut()
  CityFakeZombiesCtrl.ClearBattleEffect()
  CityFakeZombiesCtrl.Clear()
end

function CityFakeZombiesCtrl.OnCountStageWin(stageId)
end

function CityFakeZombiesCtrl.OnParkourStageWin(stageId)
  if featureStageId <= 0 or finishFlow <= 0 then
    return
  end
  if stageId == featureStageId and not DataCenter.LWGuideFlowManager:ReadDone(finishFlow) then
    CityFakeZombiesCtrl.countStageFinish = true
  end
end

function CityFakeZombiesCtrl.OnPlotGroupStart(plotId)
  if IsNull(CityFakeZombiesCtrl.timelineSyncHandle) then
    return
  end
  if plotId == killZombiePlotId and CityFakeZombiesCtrl.__plotBlockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(CityFakeZombiesCtrl.__plotBlockerHandleID)
    CityFakeZombiesCtrl.__plotBlockerHandleID = nil
  end
end

function CityFakeZombiesCtrl.OnPlotGroupDone(plotId)
  if IsNull(CityFakeZombiesCtrl.timelineSyncHandle) then
    return
  end
  if plotId == killZombiePlotId then
    CityFakeZombiesCtrl.OnZombieEnterFinish()
  end
end

function CityFakeZombiesCtrl.Clear()
  if CityFakeZombiesCtrl.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(CityFakeZombiesCtrl.__blockerHandleID)
    CityFakeZombiesCtrl.__blockerHandleID = nil
  end
  if CityFakeZombiesCtrl.__plotBlockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(CityFakeZombiesCtrl.__plotBlockerHandleID)
    CityFakeZombiesCtrl.__plotBlockerHandleID = nil
  end
  CityFakeZombiesCtrl.ClearBattleEffect()
  CityFakeZombiesCtrl.ClearTimeHandle()
  CityFakeZombiesCtrl.ClearFog()
  CityFakeZombiesCtrl.ClearFence()
  if IsNull(CityFakeZombiesCtrl.timelineSyncHandle) then
    return
  end
  CityFakeZombiesCtrl.timelineSyncHandle:RealDestroy()
  CityFakeZombiesCtrl.timelineSyncHandle = nil
  CityFakeZombiesCtrl.inDirector = nil
  if not IsNull(CityFakeZombiesCtrl.idleTouchTrigger) then
    CityFakeZombiesCtrl.idleTouchTrigger.onPointerClick = nil
    CityFakeZombiesCtrl.idleTouchTrigger = nil
  end
  CityFakeZombiesCtrl.timelines = {}
  CityFakeZombiesCtrl.ShowBuildBubbleNode()
end

function CityFakeZombiesCtrl.LoadBattleEffect()
  CityFakeZombiesCtrl.battleEffectHandle = CS.GameEntry.Resource:InstantiateAsync(battleTopEffectPath)
  CityFakeZombiesCtrl.battleEffectHandle:completed("+", function(req)
    local battleEffectGo = CityFakeZombiesCtrl.battleEffectHandle.gameObject
    battleEffectGo.transform.position = CityFakeZombiesCtrl.timelines.touchRoot.transform.position + Vector3.New(0, 8, 0)
    local battleEffectTrigger = battleEffectGo:GetComponent(typeof(CS.TouchObjectEventTrigger))
    if not IsNull(battleEffectTrigger) then
      CityFakeZombiesCtrl.battleEffectTouchTrigger = battleEffectTrigger
      battleEffectTrigger.onPointerClick = CityFakeZombiesCtrl.EnterBattle
    end
  end)
end

function CityFakeZombiesCtrl.EnterBattle()
  local param = {}
  param.type = PVEType.Parkour
  param.enterType = PVEEnterType.CityFakeZombie
  param.levelId = featureStageId
  param.absoluteBtn = true
  DataCenter.LWBattleManager:Enter(param)
end

function CityFakeZombiesCtrl.ClearBattleEffect()
  if not IsNull(CityFakeZombiesCtrl.battleEffectTouchTrigger) then
    CityFakeZombiesCtrl.battleEffectTouchTrigger.onPointerClick = nil
    CityFakeZombiesCtrl.battleEffectTouchTrigger = nil
  end
  if not IsNull(CityFakeZombiesCtrl.battleEffectHandle) then
    CityFakeZombiesCtrl.battleEffectHandle:Destroy()
    CityFakeZombiesCtrl.battleEffectHandle = nil
  end
end

function CityFakeZombiesCtrl.ClearTimeHandle()
  if CityFakeZombiesCtrl.inTimeHandle ~= nil then
    CityFakeZombiesCtrl.inTimeHandle:Stop()
    CityFakeZombiesCtrl.inTimeHandle = nil
  end
  if CityFakeZombiesCtrl.inLoopTimeHandle ~= nil then
    CityFakeZombiesCtrl.inLoopTimeHandle:Stop()
    CityFakeZombiesCtrl.inLoopTimeHandle = nil
  end
end

function CityFakeZombiesCtrl.ClearFog()
  if not IsNull(CityFakeZombiesCtrl.fogRevealer) then
    CityFakeZombiesCtrl.fogRevealer:OnDestroy()
    CityFakeZombiesCtrl.fogRevealer = nil
  end
end

function CityFakeZombiesCtrl.ClearFence()
  if not IsNull(CityFakeZombiesCtrl.fenceGo) then
    CityFakeZombiesCtrl.fenceGo:SetActive(true)
    CityFakeZombiesCtrl.fenceGo = nil
  end
end

function CityFakeZombiesCtrl.ShowBuildBubbleNode()
  if not CityFakeZombiesCtrl.isHideBuildBubbleNode then
    return
  end
  CityFakeZombiesCtrl.isHideBuildBubbleNode = nil
  DataCenter.BuildBubbleManager:ShowBubbleNode()
end

function CityFakeZombiesCtrl.HideBuildBubbleNode()
  if CityFakeZombiesCtrl.isHideBuildBubbleNode then
    return
  end
  CityFakeZombiesCtrl.isHideBuildBubbleNode = true
  DataCenter.BuildBubbleManager:HideBubbleNode()
end

return CityFakeZombiesCtrl
