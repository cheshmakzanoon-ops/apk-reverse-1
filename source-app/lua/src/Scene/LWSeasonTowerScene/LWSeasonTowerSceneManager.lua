local Resource = CS.GameEntry.Resource
local LWSeasonTowerSceneManager = BaseClass("LWSeasonTowerSceneManager", CEventable)
local LWSeasonTowerUtil = require("DataCenter.LWSeasonTowerManager.LWSeasonTowerUtil")

function LWSeasonTowerSceneManager:__init()
  self.sceneLoadTime = 0
  self:AddListener()
end

function LWSeasonTowerSceneManager:__delete()
  self.sceneLoadTime = 0
  self:Destroy()
end

function LWSeasonTowerSceneManager:AddListener()
  self:RegisterEvent(EventId.SeasonTowerFormationUpdate, self.OnSelfFormationUpdate)
  self:RegisterEvent(EventId.SeasonTowerStageChanged, self.OnStageUpdate)
end

function LWSeasonTowerSceneManager:OnKeyCodeEscape()
  if not self.inSeasonTowerScene then
    return
  end
  if UIManager.Instance:HasWindowByLayer(UILayer.Dialog) or UIManager.Instance:HasWindowByLayer(UILayer.Info) or UIManager.Instance:HasWindowByLayer(UILayer.Normal) then
    local stack = UIManager.Instance:GetWindowStack()
    if stack ~= nil then
      UIManager.Instance:CloseOneWindowFromStack(stack)
      return
    end
  end
  self:Exit()
end

function LWSeasonTowerSceneManager:OnSelfFormationUpdate()
  if self.logic then
    self.logic:CreateSquad()
  end
end

function LWSeasonTowerSceneManager:ChangeStage()
  local stageData = DataCenter.LWSeasonTowerManager:GetSelectStage()
  if stageData == nil then
    return
  end
  local army = stageData:GetArmy()
  if army == nil then
    return
  end
  local difficultyTemplate = LWSeasonTowerUtil.GetDifficulty(stageData.stageId, stageData.floor)
  if difficultyTemplate == nil then
    return
  end
  local param = {}
  param.type = PVEType.FakePVP
  param.enterType = PVEEnterType.SeasonTower
  param.levelId = army.armyId
  param.sceneId = difficultyTemplate.show
  param.extraData = {
    stageId = stageData.stageId
  }
  self.param = param or {}
  if self.logic then
    self.logic:Delete()
    self.logic = nil
  end
  self.sceneLoadTime = Time.realtimeSinceStartup
  self.inLoading = true
  self.logic = self:CreateLogic(self.param)
  self.logic:Enter(self.param)
  self.logic:EnterGame()
end

function LWSeasonTowerSceneManager:OnStageUpdate()
  UIUtil.PlayCutSceneAnim(function()
    self:ChangeStage()
  end, function()
    return self:CheckChangeLoadingState()
  end)
end

function LWSeasonTowerSceneManager:Destroy()
  self.inSeasonTowerScene = false
  CommonUtil.PlayGameBgMusic()
  if self.logic then
    self.logic:Delete()
    self.logic = nil
  end
  self:RemoveUpdateTimer()
  self:RemoveLateUpdateTimer()
end

local function ProtectCall(fun)
  local ok, msg = xpcall(fun, debug.traceback)
  if not ok then
    Logger.LogError(msg)
  end
end

local function ExitOldScene()
  if CS.SceneManager.World then
    CS.SceneManager.World:SetTouchInputControllerEnable(false)
  end
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

function LWSeasonTowerSceneManager:Enter(action)
  if self.logic ~= nil then
    return
  end
  local stageData = DataCenter.LWSeasonTowerManager:GetSelectStage()
  if stageData == nil then
    return
  end
  local army = stageData:GetArmy()
  if army == nil then
    return
  end
  local difficultyTemplate = LWSeasonTowerUtil.GetDifficulty(stageData.stageId, stageData.floor)
  if difficultyTemplate == nil then
    return
  end
  local param = {}
  param.type = PVEType.FakePVP
  param.enterType = PVEEnterType.SeasonTower
  param.levelId = army.armyId
  param.sceneId = difficultyTemplate.show
  param.extraData = {
    stageId = stageData.stageId
  }
  self.param = param or {}
  ExitOldScene()
  self.sceneLoadTime = Time.realtimeSinceStartup
  self.inLoading = true
  self.logic = self:CreateLogic(self.param)
  self.logic:Enter(self.param)
  self.logic:EnterGame()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonTowerMain, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, {action = action})
  self.inSeasonTowerScene = true
  CommonUtil.PlayGameBgMusic()
end

function LWSeasonTowerSceneManager:Exit(exitAction)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonTowerMain)
  self:Destroy()
  DataCenter.LWSoundManager:StopAllSounds()
  if not CS.SceneManager.IsInCity() and not CS.SceneManager.IsInWorld() then
    local action = exitAction
    
    local function onSceneCreated()
      Resource:ClearPoolByTagGroup(ObjectPoolTagGroup.Battle)
      collectgarbage("collect")
      DataCenter.WarningBallManager:AddTimer()
      EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
      EventManager:GetInstance():Broadcast(EventId.OnEnterCity)
      DataCenter.CityNpcManager:SetNpcVisible(true)
      if action ~= nil then
        action()
      end
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
    local mainUIView = mainUI and mainUI.View
    if mainUIView then
      mainUIView:SetActive(true)
    end
  end
end

function LWSeasonTowerSceneManager:ExitBeforeBattle()
  self:Destroy()
  DataCenter.LWSoundManager:StopAllSounds()
  collectgarbage("collect")
end

function LWSeasonTowerSceneManager:CreateLogic(param)
  local seasonTowerSceneLogic = require("Scene.LWSeasonTowerScene.LWSeasonTowerSceneLogic")
  return seasonTowerSceneLogic.New()
end

function LWSeasonTowerSceneManager:CheckLoadingState()
  local ret = false
  local diffTime = Time.realtimeSinceStartup - self.sceneLoadTime
  if diffTime <= 1 then
    ret = false
  elseif 10 < diffTime then
    self:Exit()
    ret = true
  elseif self.logic then
    ret = self.logic:CheckLoadingState()
    if ret then
      self:EnterGame()
    end
  end
  self.inLoading = not ret
  return ret
end

function LWSeasonTowerSceneManager:CheckChangeLoadingState()
  local ret = false
  local diffTime = Time.realtimeSinceStartup - self.sceneLoadTime
  if 10 < diffTime then
    self:Exit()
    ret = true
  elseif self.logic then
    ret = self.logic:CheckLoadingState()
    if ret then
      self:EnterGame()
    end
  end
  self.inLoading = not ret
  return ret
end

function LWSeasonTowerSceneManager:EnterGame()
  local mainUI = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
  local mainUIView = mainUI and mainUI.View
  if mainUIView then
    mainUIView:SetActive(false)
  end
  local uiStr = BattleFieldUtil.GetMainUIName()
  if not string.IsNullOrEmpty(uiStr) then
    local desertUI = UIManager:GetInstance():GetWindow(uiStr)
    if desertUI and desertUI.View then
      desertUI.View:SetActive(false)
    end
  end
  self:AddUpdateTimer()
  self:AddLateUpdateTimer()
  self.logic:EnterGame()
end

function LWSeasonTowerSceneManager:AddUpdateTimer()
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

function LWSeasonTowerSceneManager:RemoveUpdateTimer()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function LWSeasonTowerSceneManager:AddLateUpdateTimer()
  if self.lateUpdateTimer == nil then
    function self.lateUpdateTimer()
      self:OnLateUpdate()
    end
    
    UpdateManager:GetInstance():AddLateUpdate(self.lateUpdateTimer)
  end
end

function LWSeasonTowerSceneManager:RemoveLateUpdateTimer()
  if self.lateUpdateTimer then
    UpdateManager:GetInstance():RemoveLateUpdate(self.lateUpdateTimer)
    self.lateUpdateTimer = nil
  end
end

function LWSeasonTowerSceneManager:OnUpdate()
  local dt = Time.deltaTime
  if self.logic then
    self.logic:OnUpdate(dt)
  end
end

function LWSeasonTowerSceneManager:OnLateUpdate()
  local dt = Time.deltaTime
  if self.logic then
    self.logic:OnLateUpdate(dt)
  end
end

function LWSeasonTowerSceneManager:OnLoadDone()
  ProtectCall(function()
    CS.SceneManager.CurrSceneID = SceneManagerSceneID.Custom
    CS.SceneManager.CurrentSceneSubType = GetEnumKey(CustomSceneSubType, CustomSceneSubType.SeasonTower)
  end)
  DataCenter.LWSceneStateManager:ChangeScene(SceneType.Custom)
end

function LWSeasonTowerSceneManager:PlayEffect(levelList, resultFloors)
  if not self.inSeasonTowerScene then
    return
  end
  if self.logic then
    self.logic:TryPlayEffect(levelList, resultFloors)
  end
end

function LWSeasonTowerSceneManager:ShowReadyEffect()
  if self.logic then
    self.logic:ShowReadyEffect()
  end
end

function LWSeasonTowerSceneManager:ClearReadyEffect()
  if self.logic then
    self.logic:ClearReadyEffect()
  end
end

return LWSeasonTowerSceneManager
