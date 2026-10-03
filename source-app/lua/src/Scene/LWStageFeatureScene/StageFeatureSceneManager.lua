local Resource = CS.GameEntry.Resource
local StageFeatureSceneManager = BaseClass("StageFeatureSceneManager", CEventable)
local ScenePrefabPath = "Assets/Main/Prefabs/StageFeature/StageFeatureScene.prefab"
local LOAD_TIMEOUT = 10
local SceneX = -1000
local SceneY = 0
local SceneZ = -1000

function StageFeatureSceneManager:__init()
  self.inScene = false
  self.sceneLoaded = false
  self.sceneLoadTime = nil
  self.sceneLoadRequest = nil
  self.sceneRoot = nil
  self.controlCameraTrans = nil
  self.controlCamera = nil
  self.targetTabType = nil
  self:AddListener()
end

function StageFeatureSceneManager:__delete()
  self:Destroy()
  self:RemoveListener()
end

function StageFeatureSceneManager:AddListener()
end

function StageFeatureSceneManager:RemoveListener()
end

function StageFeatureSceneManager:IsUseSceneMode()
  return LuaEntry.DataConfig:CheckSwitch("frontline_single_scene")
end

function StageFeatureSceneManager:IsInScene()
  return self.inScene
end

function StageFeatureSceneManager:IsSceneTab(tabType)
  return tabType ~= TrailTowerTabType.TrailTower
end

local function ProtectCall(fun)
  local ok, msg = xpcall(fun, debug.traceback)
  if not ok then
    Logger.LogError(msg)
  end
end

local function ExitOldScene()
  ProtectCall(function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIItemTips)
  end)
  ProtectCall(function()
    GoToUtil.CloseAllWindows()
  end)
  ProtectCall(function()
    UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldTileUI)
  end)
  ProtectCall(function()
    UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint)
  end)
  if CS.SceneManager.IsInCity() then
    EventManager:GetInstance():Broadcast(EventId.BeforeReleaseCity)
  elseif CS.SceneManager.IsInWorld() then
    EventManager:GetInstance():Broadcast(EventId.BeforeLeaveWorld)
  end
  DataCenter.BuildBubbleManager:ClearAll()
  DataCenter.WorldBuildBubbleManager:ClearAll()
  DataCenter.RoadBubbleManager:ClearAll()
  DataCenter.AllianceCityTipManager:RemoveAllAllianceCityTip()
  DataCenter.SurpriseBuildingTipManager:RemoveAllSurpriseBuildingTip()
  DataCenter.WarningBallManager:DeleteTimer()
  DataCenter.WorldFavoDataManager:ClearAll()
  CS.SceneManager.DestroyCurScene()
  DataCenter.LWSceneStateManager:ChangeScene(SceneType.None)
end

function StageFeatureSceneManager:Enter(tabType, showGuide)
  if self.inScene then
    return
  end
  self.inScene = true
  self.sceneLoaded = false
  self.targetTabType = tabType
  self.showGuide = showGuide
  ExitOldScene()
  self.sceneLoadTime = Time.realtimeSinceStartup
  self:LoadScene(ScenePrefabPath)
  self.loadTimeoutTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.loadTimeoutTimer = nil
    if self.inScene and not self.sceneLoaded then
      Logger.LogError("StageFeatureSceneManager: scene load timeout, force exit!")
      self:Exit()
    end
  end, LOAD_TIMEOUT)
end

function StageFeatureSceneManager:Exit()
  self:Destroy()
  DataCenter.LWSoundManager:StopAllSounds()
  GoToUtil.CloseAllWindows()
  if not CS.SceneManager.IsInCity() and not CS.SceneManager.IsInWorld() then
    local function onSceneCreated()
      Resource:ClearPoolByTagGroup(ObjectPoolTagGroup.Battle)
      
      collectgarbage("collect")
      DataCenter.WarningBallManager:AddTimer()
      EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
      EventManager:GetInstance():Broadcast(EventId.OnEnterCity)
      DataCenter.CityNpcManager:SetNpcVisible(true)
      DataCenter.GuideManager:DoWaitTriggerAfterBack()
    end
    
    SceneUtils.CreateCity()
    CS.SceneManager.World:CreateScene(onSceneCreated)
  end
  local uiStr = BattleFieldUtil.GetMainUIName()
  if not string.IsNullOrEmpty(uiStr) then
    local desertUI = UIManager:GetInstance():GetWindow(uiStr)
    if desertUI and desertUI.View then
      desertUI.View:SetActive(true)
    end
  else
    local mainUI = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
    if mainUI and mainUI.View then
      mainUI.View:SetActive(true)
    end
  end
end

function StageFeatureSceneManager:ExitBeforeBattle()
  self:Destroy()
  DataCenter.LWSoundManager:StopAllSounds()
  collectgarbage("collect")
end

function StageFeatureSceneManager:TryExit()
  if self.inScene and not CS.SceneManager.IsInCity() and not CS.SceneManager.IsInWorld() then
    self:Exit()
  end
end

function StageFeatureSceneManager:Destroy()
  self.inScene = false
  self.sceneLoaded = false
  self.sceneLoadTime = nil
  self.sceneRoot = nil
  if self.loadTimeoutTimer then
    self.loadTimeoutTimer:Stop()
    self.loadTimeoutTimer = nil
  end
  self:UnloadScene()
end

function StageFeatureSceneManager:LoadScene(prefabPath)
  if self.sceneLoadRequest then
    return
  end
  self.sceneLoaded = false
  local req = Resource:InstantiateAsync(prefabPath)
  req:completed("+", function()
    if not self.inScene then
      req:Destroy()
      return
    end
    local sceneRoot = req.gameObject.transform
    sceneRoot:Set_localPosition(SceneX, SceneY, SceneZ)
    self:OnSceneLoadFinish(sceneRoot)
  end)
  self.sceneLoadRequest = req
end

function StageFeatureSceneManager:OnSceneLoadFinish(sceneRoot)
  self.sceneLoaded = true
  self.sceneRoot = sceneRoot
  ProtectCall(function()
    CS.SceneManager.CurrSceneID = SceneManagerSceneID.Custom
    CS.SceneManager.CurrentSceneSubType = GetEnumKey(CustomSceneSubType, CustomSceneSubType.StageFeature)
  end)
  DataCenter.LWSceneStateManager:ChangeScene(SceneType.Custom)
  CommonUtil.PlayGameBgMusic()
end

function StageFeatureSceneManager:CheckLoadingState()
  local ret = false
  local diffTime = Time.realtimeSinceStartup - self.sceneLoadTime
  if diffTime > LOAD_TIMEOUT then
    Logger.LogError("StageFeatureSceneManager:CheckLoadingState load timeout, force exit!")
    self:Exit()
    ret = true
  elseif self.sceneLoaded then
    self:EnterGame()
    ret = true
  end
  return ret
end

function StageFeatureSceneManager:EnterGame()
  local mainUI = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
  if mainUI and mainUI.View then
    mainUI.View:SetActive(false)
  end
  local uiStr = BattleFieldUtil.GetMainUIName()
  if not string.IsNullOrEmpty(uiStr) then
    local desertUI = UIManager:GetInstance():GetWindow(uiStr)
    if desertUI and desertUI.View then
      desertUI.View:SetActive(false)
    end
  end
  DataCenter.LWTrailTowerManager:OpenTrailTowerMainPanel(self.targetTabType, self.showGuide)
end

function StageFeatureSceneManager:UnloadScene()
  if self.sceneLoadRequest then
    self.sceneLoadRequest:Destroy()
    self.sceneLoadRequest = nil
  end
end

return StageFeatureSceneManager
