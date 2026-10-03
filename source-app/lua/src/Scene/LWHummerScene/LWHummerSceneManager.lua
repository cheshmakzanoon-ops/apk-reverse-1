local MobileTouchCamera = CS.BitBenderGames.MobileTouchCamera
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local LWHummerSceneManager = BaseClass("LWHummerSceneManager", CEventable)

function LWHummerSceneManager:__init()
  self:AddListener()
end

function LWHummerSceneManager:__delete()
  self:Destroy()
end

function LWHummerSceneManager:AddListener()
  self:RegisterEvent(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  self:RegisterEvent(EventId.HangRewardRefreshed, self.RefreshTruckGoods)
end

function LWHummerSceneManager:RemoveListener()
  self:UnregisterEvent(EventId.OnKeyCodeEscape)
  self:UnregisterEvent(EventId.HangRewardRefreshed)
end

function LWHummerSceneManager:OnKeyCodeEscape()
  if self.inHummerScene then
    self:Exit()
  end
end

function LWHummerSceneManager:Destroy()
  self.inHummerScene = false
  if self.logic then
    self.logic:OnDestroy()
    self.logic = nil
  end
  self:RemoveUpdateTimer()
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

function LWHummerSceneManager:Enter(param)
  if self.logic ~= nil then
    return
  end
  self.inHummerScene = true
  self.param = param
  ExitOldScene()
  self.sceneLoadTime = Time.realtimeSinceStartup
  self.inLoading = true
  self.logic = self:CreateLogic(param)
  self.logic:Enter(param)
  self.enterTime = UITimeManager:GetInstance():GetServerTime()
end

function LWHummerSceneManager:ExitBeforeBattle()
  self:Destroy()
  DataCenter.LWSoundManager:StopAllSounds()
  collectgarbage("collect")
  local endTime = UITimeManager:GetInstance():GetServerTime()
  PostEventLog.Track(PostEventLog.Defines.HummerScenePlayTime, {
    battle_time = math.floor((endTime - self.enterTime) / 1000)
  })
end

function LWHummerSceneManager:Exit(exitAction)
  self:Destroy()
  local action = exitAction
  DataCenter.LWSoundManager:StopAllSounds()
  if not CS.SceneManager.IsInCity() and not CS.SceneManager.IsInWorld() then
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
    local mainUIView = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain).View
    if mainUIView then
      mainUIView:SetActive(true)
    end
  end
  local endTime = UITimeManager:GetInstance():GetServerTime()
  PostEventLog.Track(PostEventLog.Defines.HummerScenePlayTime, {
    battle_time = math.floor((endTime - self.enterTime) / 1000)
  })
end

function LWHummerSceneManager:CreateLogic(param)
  local hummerSceneLogic = require("Scene.LWHummerScene.LWHummerSceneLogic")
  return hummerSceneLogic.New()
end

function LWHummerSceneManager:CheckLoadingState()
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

function LWHummerSceneManager:EnterGame()
  local mainUIView = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain).View
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
  self.logic:EnterGame()
end

function LWHummerSceneManager:AddUpdateTimer()
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

function LWHummerSceneManager:RemoveUpdateTimer()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function LWHummerSceneManager:OnUpdate()
  local dt = Time.deltaTime
  if self.logic then
    self.logic:OnUpdate(dt)
  end
end

function LWHummerSceneManager:OnLoadDone()
  ProtectCall(function()
    CS.SceneManager.CurrSceneID = SceneManagerSceneID.Custom
    CS.SceneManager.CurrentSceneSubType = GetEnumKey(CustomSceneSubType, CustomSceneSubType.Hummer)
  end)
  DataCenter.LWSceneStateManager:ChangeScene(SceneType.Custom)
end

function LWHummerSceneManager:RefreshTruckGoods()
  if self.logic then
    self.logic:RefreshTruckGoods()
  end
end

return LWHummerSceneManager
