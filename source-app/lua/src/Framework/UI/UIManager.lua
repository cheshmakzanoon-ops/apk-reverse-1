local UIManager = BaseClass("UIManager", Singleton)
local UIRootPath = "GameFramework/UI"
local ResourceManager = CS.GameEntry.Resource
local GameObject = CS.UnityEngine.GameObject
local LayerOrder = {
  "Scene",
  "HpBar",
  "Background",
  "UIResource",
  "Normal",
  "Info",
  "Dialog",
  "Guide",
  "TopMost",
  "TimelineInteraction"
}
if Config.IsPC() then
  LayerOrder = {
    "Scene",
    "HpBar",
    "Background",
    "UIResource",
    "NormalBg",
    "Normal",
    "Info",
    "Dialog",
    "Guide",
    "TopMost",
    "TimelineInteraction"
  }
end
local RectTransform = typeof(CS.UnityEngine.RectTransform)
local Canvas = typeof(CS.UnityEngine.Canvas)
local Input = CS.UnityEngine.Input
local Localization = CS.GameEntry.Localization
local KeyCode_Escape = CS.UnityEngine.KeyCode.Escape
local DynamicFPSConfig = CS.DynamicFPSConfig
local MobileTouchCamera = CS.BitBenderGames.MobileTouchCamera
local WindowState = {
  Create = 0,
  Loading = 1,
  Open = 2,
  Close = 3,
  Destroying = 4,
  HideBack = 5
}
local DISABLE_LUAADDCOMPONENT_ASSERT = CS.ClientSwitch.DISABLE_LUAADDCOMPONENT_ASSERT

local function __init(self)
  self.windows = {}
  self.windowsConfig = {}
  self.layers = {}
  self.transform = GameObject.Find(UIRootPath).transform
  local container = self.transform:Find("UIContainer")
  self.uiContainer = container
  self.canvas = container:GetComponent(Canvas)
  self.windowStack = list:new()
  self.otherWindowStack = list:new()
  self.UIMainAnim = nil
  local bottomBlock = container:Find("BottomInterationBlocker")
  if not IsNull(bottomBlock) then
    self.bottomBlockGo = bottomBlock.gameObject
    self.bottomInterationBlocker = self.bottomBlockGo:GetComponent(typeof(CS.UnityEngine.RectTransform))
  else
    self.bottomBlockGo = GameObject("BottomInterationBlocker")
    self.bottomInterationBlocker = self.bottomBlockGo:AddComponent(typeof(CS.UnityEngine.RectTransform))
    self.bottomInterationBlocker:SetParent(container, false)
    self.bottomInterationBlocker.gameObject:AddComponent(typeof(CS.UnityEngine.UI.Empty4Raycast))
  end
  self.bottomInterationBlocker:Set_anchorMin(0, 0)
  self.bottomInterationBlocker:Set_anchorMax(1, 1)
  self.bottomInterationBlocker:Set_offsetMin(0, 0)
  self.bottomInterationBlocker:Set_offsetMax(0, 0)
  self.bottomInterationBlocker.gameObject:SetActive(false)
  self.layers = {}
  for _, layerName in ipairs(LayerOrder) do
    local layerPath = "UIContainer/" .. layerName
    local layerObj
    local trans = self.transform:Find(layerPath)
    if trans ~= nil then
      layerObj = trans.gameObject
    end
    if layerObj == nil then
      layerObj = GameObject(layerName, RectTransform)
      layerObj.transform:SetParent(container, false)
    end
    layerObj.transform:SetAsLastSibling()
    local layerConf = UILayer[layerName]
    local layer = UILayerComponent.New(self, layerConf.Name)
    layer:OnCreate()
    self.layers[layerConf.Name] = layer
    if layerConf.OrderNew ~= nil then
      local canvas = layerObj.gameObject:GetOrAddComponent(typeof(CS.UnityEngine.Canvas))
      if canvas ~= nil then
        canvas.overrideSorting = true
        canvas.sortingOrder = layerConf.OrderNew
      end
    end
  end
  if Config.IsPC() then
    local bgLayer = self:GetLayer(UILayer.NormalBg.Name)
    local bg = bgLayer.gameObject:AddComponent(typeof(CS.UnityEngine.UI.Image))
    if bg then
      bg.color = CS.UnityEngine.Color(0, 0, 0, 0.5)
    end
    self:SetLayerActive(UILayer.NormalBg.Name, false)
  end
  local topBlock = container:Find("TopInterationBlocker")
  if not IsNull(topBlock) then
    self.topBlockGo = topBlock.gameObject
    self.topInterationBlocker = self.topBlockGo:GetComponent(typeof(CS.UnityEngine.RectTransform))
    self.topBlockGo.transform:SetAsLastSibling()
  else
    self.topBlockGo = GameObject("TopInterationBlocker")
    self.topInterationBlocker = self.topBlockGo:AddComponent(typeof(CS.UnityEngine.RectTransform))
    self.topInterationBlocker:SetParent(container, false)
    self.topInterationBlocker.gameObject:AddComponent(typeof(CS.UnityEngine.UI.Empty4Raycast))
  end
  self.topInterationBlocker:Set_anchorMin(0, 0)
  self.topInterationBlocker:Set_anchorMax(1, 1)
  self.topInterationBlocker:Set_offsetMin(0, 0)
  self.topInterationBlocker:Set_offsetMax(0, 0)
  self.topInterationBlocker.gameObject:SetActive(false)
  self.interationBlockers = {
    self.bottomInterationBlocker,
    self.topInterationBlocker
  }
  self.interationBlockersHandles = {
    {},
    {}
  }
  self.interationBlockers_AUTO_INCREASE_HANDLE_ID = 7000
  local timelineInteractionLayer = self:GetLayer(UILayer.TimelineInteraction.Name)
  local timelineInteractionGo = timelineInteractionLayer.gameObject
  if IsNotNull(timelineInteractionGo) then
    timelineInteractionGo.transform:SetAsLastSibling()
  end
  local layerConf = UILayer.World
  local layerObj = self.transform:Find("WorldUIContainer").gameObject
  local layer = UILayerComponent.New(self, layerObj)
  layer:OnCreate()
  self.layers[layerConf.Name] = layer
  layerObj.layer = LayerMask.NameToLayer("Hud3D")
  self:AddListener()
  self.sceneCameraDisable = false
  self.materialMap = {}
  self.materialReqMap = {}
end

local function IsDisableLuaAddComponentAssert(self)
  if self.disableLuaAddComponentAssert == nil and DISABLE_LUAADDCOMPONENT_ASSERT and CS.ClientSwitch.HasSwitchData(DISABLE_LUAADDCOMPONENT_ASSERT) then
    self.disableLuaAddComponentAssert = CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_LUAADDCOMPONENT_ASSERT)
  end
  return self.disableLuaAddComponentAssert
end

local function Startup(self)
  UpdateManager:GetInstance():AddUpdate(self.OnUpdate)
end

local function __delete(self)
  UpdateManager:GetInstance():RemoveUpdate(self.OnUpdate)
  self:RemoveListener()
  self:DeleteAllLayer()
  self.materialMap = {}
  if IsNotNull(self.bottomBlockGo) then
    GameObject.Destroy(self.bottomBlockGo)
    self.bottomBlockGo = nil
  end
  if IsNotNull(self.topBlockGo) then
    GameObject.Destroy(self.topBlockGo)
    self.topBlockGo = nil
  end
  for k, v in pairs(self.materialReqMap) do
    if not IsNull(v) then
      v:Release()
    end
  end
  self.materialReqMap = nil
  self.disableLuaAddComponentAssert = nil
end

local function DeleteAllLayer(self)
  for k, v in pairs(self.layers) do
    GameObject.Destroy(v)
  end
  self.layers = nil
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  EventManager:GetInstance():AddListener(EventId.OnAndroidNavigationGestureEscape, self.OnAndroidNavigationGestureEscape)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  EventManager:GetInstance():RemoveListener(EventId.OnAndroidNavigationGestureEscape, self.OnAndroidNavigationGestureEscape)
end

local function EnableInteractionBlocker(self, blockerIdx, expireTime)
  if self.interationBlockers[blockerIdx] == nil or self.interationBlockersHandles[blockerIdx] == nil then
    Logger.LogError("EnableInteractionBlocker blockerIdx is invalid:" .. tostring(blockerIdx))
    return nil
  end
  self.interationBlockers_AUTO_INCREASE_HANDLE_ID = self.interationBlockers_AUTO_INCREASE_HANDLE_ID + 1
  local newHandle = {
    id = self.interationBlockers_AUTO_INCREASE_HANDLE_ID,
    time = expireTime
  }
  table.insert(self.interationBlockersHandles[blockerIdx], newHandle)
  self.interationBlockers[blockerIdx].gameObject:SetActive(true)
  return newHandle.id
end

local function DisableInteractionBlocker(self, handleID)
  if handleID == nil then
    return
  end
  local blockerIdx, handleIdx
  for i, handles in ipairs(self.interationBlockersHandles) do
    for j, handle in ipairs(handles) do
      if handle.id == handleID then
        blockerIdx = i
        handleIdx = j
        break
      end
    end
    if blockerIdx ~= nil and handleIdx ~= nil then
      break
    end
  end
  if blockerIdx == nil or handleIdx == nil then
    return
  end
  table.remove(self.interationBlockersHandles[blockerIdx], handleIdx)
  if #self.interationBlockersHandles[blockerIdx] <= 0 then
    self.interationBlockers[blockerIdx].gameObject:SetActive(false)
  end
end

local function OnUpdate()
  local self = UIManager:GetInstance()
  local expiredBlockerHandleIDs
  for i, handles in ipairs(self.interationBlockersHandles) do
    for _, handle in ipairs(handles) do
      handle.time = handle.time - Time.deltaTime
      if handle.time <= 0 then
        if expiredBlockerHandleIDs == nil then
          expiredBlockerHandleIDs = {}
        end
        table.insert(expiredBlockerHandleIDs, handle.id)
      end
    end
  end
  if expiredBlockerHandleIDs ~= nil then
    for _, handleID in ipairs(expiredBlockerHandleIDs) do
      self:DisableInteractionBlocker(handleID)
    end
  end
end

local function GetWindow(self, ui_name)
  return self.windows[ui_name]
end

local function GetLayer(self, layerName)
  return self.layers[layerName]
end

local function GetScaleFactor(self)
  return self.canvas.scaleFactor
end

local function GetUIContainerRect(self)
  return self.uiContainer:GetComponent(typeof(CS.UnityEngine.RectTransform))
end

local function GetWindowConfig(self, ui_name)
  local configPath = UIConfig[ui_name]
  assert(configPath, "No window named : " .. ui_name .. ".You should add it to UIConfig first!")
  local config = self.windowsConfig[ui_name]
  if config == nil then
    local loaded = require(configPath)
    if type(loaded) ~= "table" then
      CS.GameEntry.DebugLuaFile(configPath)
    end
    _, config = next(loaded)
    self.windowsConfig[ui_name] = config
  end
  return config
end

local function ProtectCall(fun)
  local ok, msg = xpcall(fun, debug.traceback)
  if not ok then
    Logger.LogError(msg)
  end
  return ok
end

local function PlayAnimation(go, animName)
  if IsNull(go) or not go.activeSelf then
    return
  end
  local ani = go:GetComponent(typeof(CS.UnityEngine.Animator))
  if IsNull(ani) or IsNull(ani.runtimeAnimatorController) then
    return
  end
  if not animName then
    return
  end
  local duration = 0.01
  local clips = ani.runtimeAnimatorController.animationClips
  for i = 0, clips.Length - 1 do
    local clip = clips[i]
    if clip ~= nil then
      if string.endswith(clip.name, animName) then
        duration = clips[i].length
        ani:Play(animName, 0, 0)
        return true, duration
      end
    else
      Logger.LogError("UIManager.PlayAnimation clip is nil. index : " .. i)
    end
  end
  return false
end

local function GetFileNameWithoutExtension(filepath)
  local filename
  local i = filepath:findlast("[/\\]")
  if i then
    filename = filepath:sub(i + 1)
  else
    filename = filepath
  end
  i = filename:findlast(".", true)
  if i then
    return filename:sub(1, i - 1)
  else
    return filename
  end
end

local function PlayMoveInAnim(self, window)
  if not window.OpenOptions.anim then
    return
  end
  local go = window.View.gameObject
  local prefabName = GetFileNameWithoutExtension(window.PrefabPath)
  local ok = PlayAnimation(go, prefabName .. "_movein")
  if not ok then
    local openAniName = window.HideBack and "CommonPopup_movein_4_HideBack" or "CommonPopup_movein"
    PlayAnimation(go, openAniName)
  end
end

local function PlayMoveOutAnim(self, window)
  local go = window.View.gameObject
  local prefabName = GetFileNameWithoutExtension(window.PrefabPath)
  local ok, duration = PlayAnimation(go, prefabName .. "_moveout")
  if not ok then
    local closeAniName = window.HideBack and "CommonPopup_moveout_4_HideBack" or "CommonPopup_moveout"
    ok, duration = PlayAnimation(go, closeAniName)
  end
  return ok, duration
end

local function InnerCloseWindow(self, window)
  if window and window.View:GetActive() then
    window.View:SetActive(false)
    window.State = WindowState.Close
    if Config.IsPC() and window.HideSceneCamera and window.Layer:GetName() == UILayer.Normal.Name then
      CS.RectTransformUtils.ResetAdjustWidth(window.Layer.rectTransform)
    end
  end
end

local function OnKeyCodeEscape(ignoreQuit)
  UIManager:GetInstance():KeyCodeEscape(ignoreQuit)
end

local function KeyCodeEscape(self, ignoreQuit)
  if self.frameCount ~= nil and self.frameCount == Time.frameCount then
    Logger.Log("KeyCodeEscape Trigger Twice")
  end
  self.frameCount = Time.frameCount
  if DataCenter.GuideManager:InGuide() or CS.ApplicationLaunch.Instance.Loading.IsLoading or CS.SceneManager.IsInPVE() or DataCenter.LWHummerSceneManager.inHummerScene then
    return
  end
  local stack = self:GetWindowStack()
  if stack == nil then
    if not ignoreQuit then
      UIUtil.ShowMessage(Localization:GetString("dialog_message_exit_confirm"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        CS.ApplicationLaunch.Instance:Quit()
      end)
    end
  else
    self:CloseOneWindowFromStack(stack)
  end
end

local function OnAndroidNavigationGestureEscape(data)
  UIManager:GetInstance():AndroidNavigationGestureEscape()
end

local function AndroidNavigationGestureEscape(self)
  EventManager:GetInstance():Broadcast(EventId.OnKeyCodeEscape, true)
end

function UIManager:CloseOneWindowFromStack(stack)
  local topWin = stack:tail()
  if topWin.CustomKeyCodeEscape and topWin.Ctrl.OnCustomKeyCodeEscape ~= nil then
    topWin.Ctrl:OnCustomKeyCodeEscape()
  else
    self:DestroyWindow(topWin.Name, {anim = true})
  end
end

function UIManager:GetWindowStack()
  local stack
  if self.otherWindowStack.length > 0 then
    stack = self.otherWindowStack
  elseif 0 < self.windowStack.length then
    stack = self.windowStack
  end
  return stack
end

local function OnWindowFinish(window)
  if window and window.OpenOptions and window.OpenOptions.onFinish then
    window.OpenOptions.onFinish()
    window.OpenOptions.onFinish = nil
  end
end

local function OnWindowReopenWithoutCreate(window)
  if window and window.View and window.View.ReopenWithoutCreate then
    window.View:ReopenWithoutCreate()
  end
end

local BlockList = {}
BlockList[UIWindowNames.LWResDoFlyUI] = true
BlockList[UIWindowNames.UICommonMessageBar] = true
BlockList[UIWindowNames.UINpcTalkLayer] = true
BlockList[UIWindowNames.TouchScreenEffect] = true
BlockList[UIWindowNames.UINoticeTips] = true
BlockList[UIWindowNames.UIWorldZoneChangeTip] = true
BlockList[UIWindowNames.UIPowerChangeTip] = true
BlockList[UIWindowNames.UICommonMessageBarOld] = true
BlockList[UIWindowNames.UIWorldBlackTile] = true
BlockList[UIWindowNames.UIArrow] = true
BlockList[UIWindowNames.UICommonMessageTip] = true
BlockList[UIWindowNames.UIGMBar] = true
BlockList[UIWindowNames.UIGMPanel] = true
BlockList[UIWindowNames.UIGMLogPanel] = true
BlockList[UIWindowNames.UIDebugChooseServer] = true
BlockList[UIWindowNames.UIBattleMessageBar] = true
local windowOpenTime = {}
local windowCloseTime = {}
local uid = 0

local function GetWindowUid()
  if not uid then
    uid = 0
  end
  uid = uid + 1
  return uid
end

local function EditorLog(str)
  if CS.CommonUtils.IsDebug() then
    Logger.Log(str)
  end
end

local function OpenWindow(self, ui_name, ...)
  local uid = GetWindowUid()
  if not BlockList[ui_name] then
    local curTime = UITimeManager:GetInstance():GetSocketTime()
    windowOpenTime[uid] = curTime
    Logger.LogInfo(string.format("OpenWindow windowName:%s", ui_name))
  end
  if not ChatInterface.GetMobilSupportMultiple() and KeyboardView[ui_name] then
    for name, v in pairs(KeyboardView) do
      if self:IsWindowOpen(name) then
        self:DestroyWindow(name)
      end
    end
  end
  local config = GetWindowConfig(self, ui_name)
  if config.Layer == UILayer.Background or config.Layer == UILayer.Normal then
    if not DataCenter.GuideManager:IsCanOpenUI(ui_name) then
      UIUtil.ClickUICloseWorldUI()
      local guideId = DataCenter.GuideManager:GetGuideId() or 0
      Logger.LogError("OpenWindow, GuideManager can not open : " .. ui_name .. " . guideId : " .. guideId)
      return
    end
    if not table.hasvalue(TipsUI, ui_name) then
      UIUtil.ClickUICloseWorldUI()
    end
  end
  if config.HideInBattle and CS.SceneManager.IsInPVE() then
    local hidePveType = config.HidePveType
    if hidePveType then
      local curPveType = DataCenter.LWBattleManager:GetCurBattleType()
      if curPveType and hidePveType[curPveType] then
        Logger.LogInfo("is in pve, cannot open window : " .. ui_name)
        return
      end
    else
      Logger.LogInfo("is in pve, cannot open window : " .. ui_name)
      return
    end
  end
  local window = self.windows[ui_name]
  if window ~= nil and window.State == WindowState.Loading then
    Logger.Log("OpenWindow, not done ", ui_name)
    return
  end
  if window ~= nil and window.State == WindowState.Destroying and window.CloseTimer ~= nil then
    window.CloseTimer:Stop()
    window.CloseTimer = nil
    self:OnDestroyWindow(window)
    window = nil
  end
  if not window then
    window = UIWindow.New()
    self.windows[ui_name] = window
    local layer = self.layers[config.Layer.Name]
    assert(layer, "No layer named : " .. config.Layer.Name .. ".You should create it first!")
    if config.Ctrl then
      window.Ctrl = config.Ctrl.New()
    end
    if config.View then
      window.View = config.View.New(layer, ui_name, window.Ctrl)
    end
    window.Name = ui_name
    window.Layer = layer
    window.PrefabPath = config.PrefabPath
    window.State = WindowState.Create
    window.CustomKeyCodeEscape = config.CustomKeyCodeEscape or false
    window.HideSceneCamera = config.HideBack or false
    window.HideBack = config.HideBack or false
    window.DontPushWindowStack = config.DontPushWindowStack or false
    window.HideInBattle = config.HideInBattle or false
    window.HidePveType = config.HidePveType
  end
  local arg1 = select(1, ...)
  if type(arg1) == "table" then
    window.OpenOptions = arg1
    window.View:SetUserData(SafePack(select(2, ...)))
  else
    window.OpenOptions = {
      anim = true,
      UIMainAnim = UIMainAnimType.LeftRightBottomHide
    }
    window.View:SetUserData(SafePack(...))
  end
  if window.OpenOptions.UIMainAnim ~= nil and self.UIMainAnim == nil then
    if config.Layer == UILayer.Background or config.Layer == UILayer.Normal or config.Layer == UILayer.Guide then
      local UIMain = self.windows[UIWindowNames.UIMain]
      if UIMain and UIMain.InstanceRequest and UIMain.InstanceRequest.isDone then
        self.UIMainAnim = window.OpenOptions.UIMainAnim
        UIMain.View:PlayAnim(window.OpenOptions.UIMainAnim)
        EventManager:GetInstance():Broadcast(EventId.SetGoldStoreBtnVisible, window.OpenOptions.UIMainAnim)
      end
    end
    if 0 < self:GetStackWindowCount() then
      local index = 0
      for i, v in ilist(self.windowStack) do
        index = index + 1
      end
    end
  end
  if Config.IsPC() and window.HideSceneCamera and window.Layer:GetName() == UILayer.Normal.Name then
    CS.RectTransformUtils.AdjustWidthForCanvasScaler(window.Layer.rectTransform)
  end
  self:PushStackWindow(window, window.OpenOptions.hideTop)
  if not window.View.gameObject then
    if window.OpenOptions.immediately then
      window.InstanceRequest = ResourceManager:InstantiateAsyncImmediately(window.PrefabPath)
    elseif window.OpenOptions.ultraHigh then
      window.InstanceRequest = ResourceManager:InstantiateAsync(window.PrefabPath, ObjectPoolTag.Normal, 3)
    else
      window.InstanceRequest = ResourceManager:InstantiateAsync(window.PrefabPath)
    end
    window.State = WindowState.Loading
    if window.InstanceRequest ~= nil then
      local useCache = ResourceManager:PrefabHasCache(window.PrefabPath)
      if not CS.GameEntry.Resource:HasAsset(window.PrefabPath) then
        self:DestroyWindow(ui_name)
        Logger.LogError("Not Find Asset" .. window.PrefabPath)
        return
      end
      window.InstanceRequest:completed("+", function(request)
        ProfilerUtil.BeginRuntimeSample("UpdateTransform")
        if request.isError then
          windowOpenTime[uid] = nil
          return
        end
        if window == nil then
          windowOpenTime[uid] = nil
          Logger.LogError(string.format("prefab\239\188\154%s window\228\184\186\231\169\186", request.gameObject))
          ProfilerUtil.EndRuntimeSample()
          return
        end
        local go = request.gameObject
        local trans = go.transform
        trans:SetParent(window.Layer.transform, false)
        trans.name = window.Name
        if CommonUtil and CommonUtil.IsArabicAutoMirrorOpen() and not useCache then
          CS.ArabicMirror.MirrorEntry(false, true, go)
        end
        local windowBeforeCreateTime = 0
        if not BlockList[ui_name] then
          windowBeforeCreateTime = UITimeManager:GetInstance():GetSocketTime()
        end
        ProfilerUtil.EndRuntimeSample()
        ProfilerUtil.BeginRuntimeSample("OnCreate")
        local isOK = ProtectCall(function()
          window.View:OnCreate()
        end)
        ProfilerUtil.EndRuntimeSample()
        if not isOK then
          ProfilerUtil.BeginRuntimeSample("OnDestroy")
          self:DestroyWindow(ui_name)
          ProfilerUtil.EndRuntimeSample()
          Logger.LogError("Open window failed " .. ui_name)
          return
        end
        if self:IsNeedReorder(window) then
          self:ReorderWindow(window)
        end
        if windowOpenTime[uid] then
          local curTime = UITimeManager:GetInstance():GetSocketTime()
          local startTime = windowOpenTime[uid]
          local useTime = curTime - windowOpenTime[uid]
          windowOpenTime[uid] = nil
          if 200 < useTime and useTime < 500 then
            EditorLog(string.format("<color=#AA1111>OpenWindow     uiwindowName:%s     useTime:%s      useCache:%s</color>", ui_name, useTime, useCache))
          elseif 500 <= useTime then
            EditorLog(string.format("<color=#FF0000>OpenWindow     uiwindowName:%s     useTime:%s      useCache:%s</color>", ui_name, useTime, useCache))
          end
          if not BlockList[ui_name] and not useCache then
            local logCurTime = curTime
            local startOpenTime = startTime
            local loadAssetTime = windowBeforeCreateTime - startOpenTime
            local createFuncTime = logCurTime - windowBeforeCreateTime
            local allTime = logCurTime - startOpenTime
            DataCenter.OpenUITimeRecordManager:AddRecord(ui_name, allTime, loadAssetTime, createFuncTime)
          end
        end
        if window.State ~= WindowState.Close and window.State ~= WindowState.Destroying then
          ProfilerUtil.BeginRuntimeSample("Active")
          self:ChangeFPSToHighFPS(window, config)
          window.View.activeSelf = true
          window.View.gameObject:SetActive(true)
          ProfilerUtil.EndRuntimeSample()
          ProfilerUtil.BeginRuntimeSample("OnEnable")
          ProtectCall(function()
            window.View:OnEnable()
          end)
          ProfilerUtil.EndRuntimeSample()
          ProfilerUtil.BeginRuntimeSample("PlayAnim")
          window.State = WindowState.Open
          self:PlayMoveInAnim(window)
          self:CheckNeedHideSceneCamera(window)
          if self:IsInWindowStack(window) then
            self:UpdateHideBack(self.windowStack)
          end
          ProfilerUtil.EndRuntimeSample()
          EventManager:GetInstance():Broadcast(EventId.OpenUI, window.Name)
          EventManager:GetInstance():Broadcast(EventId.GF_window_opened, window.Name)
        end
        ProfilerUtil.BeginRuntimeSample("Finish")
        OnWindowFinish(window)
        if CS.CommonUtils.IsDebug() and CS.UnityEngine.Application.isEditor then
          CS.FibMatrix.PerfTools.Editor.EditorGamePerformanceBIRecorder.RecordPerfStatsNow(ui_name)
        end
        ProfilerUtil.EndRuntimeSample()
      end)
    end
  else
    self:ChangeFPSToHighFPS(window, config)
    OnWindowReopenWithoutCreate(window)
    window.View:SetActive(true)
    window.State = WindowState.Open
    self:PlayMoveInAnim(window)
    self:CheckNeedHideSceneCamera(window)
    if self:IsInWindowStack(window) then
      self:UpdateHideBack(self.windowStack)
    end
    EventManager:GetInstance():Broadcast(EventId.OpenUI, window.Name)
    EventManager:GetInstance():Broadcast(EventId.GF_window_opened, window.Name)
    OnWindowFinish(window)
  end
  if DataCenter.LWSoundManager:NewCommonSoundTest() then
    if window.OpenOptions.playEffect and type(window.OpenOptions.playEffect) == "number" then
      DataCenter.LWSoundManager:PlaySound(window.OpenOptions.playEffect, false)
    end
  elseif window.OpenOptions.playEffect == nil or window.OpenOptions.playEffect == true then
    DataCenter.LWSoundManager:PlaySoundByCache(SoundAssetId.Music_Popup_Appears)
  elseif type(window.OpenOptions.playEffect) == "number" then
    DataCenter.LWSoundManager:PlaySound(window.OpenOptions.playEffect, false)
  end
  self:StopWorldCameraMove(window)
end

local function ChangeFPSToHighFPS(self, window, config)
  if not LuaEntry then
    return
  end
  local delay1 = LuaEntry.DataConfig:TryGetNum("dynamic_high_fps_on", "k2") or 0
  local delay2 = config.AcquireHighFPSLockerForSeconds or 0
  local delay = delay1 > delay2 and delay1 or delay2
  delay = 1 < delay and delay or 1
  CS.DynamicFPSConfig.AcquireHighFPSLockerForSeconds(delay)
  CS.DynamicFPSConfig.AcquireHighFPSLockerForChildrenScrollComponents(window.View.gameObject)
  local fpsLockInfo = window.HighFPSLockInfo
  if config.AcquireHighFPSLocker and fpsLockInfo.Id == -1 then
    fpsLockInfo.Id = DynamicFPSConfig.AcquireHighFPSLocker()
  end
end

local function ClearFPSLockInfo(self, window)
  CS.DynamicFPSConfig.AcquireHighFPSLockerForSeconds(1)
  CS.DynamicFPSConfig.FreeHighFPSLockerForChildrenScrollComponents(window.View.gameObject)
  local fpsLockInfo = window.HighFPSLockInfo
  if fpsLockInfo.Id ~= -1 then
    fpsLockInfo.Id = DynamicFPSConfig.FreeHighFPSLocker(fpsLockInfo.Id)
  end
end

local function CheckNeedHideSceneCamera(self, window)
  if self:GetStackWindowCount() > 0 and not self.sceneCameraDisable then
    local sceneCameraAlreadyHide = false
    for i, v in ilist(self.windowStack) do
      if v ~= window and v.HideSceneCamera then
        sceneCameraAlreadyHide = true
        break
      end
    end
    if not sceneCameraAlreadyHide and window.HideSceneCamera then
      local mainCamera = CS.UnityEngine.Camera.main
      if mainCamera then
        local touchCamera = mainCamera:GetComponent(typeof(MobileTouchCamera))
        if touchCamera then
          if Config.IsPC() then
            if window.Layer:GetName() == UILayer.Normal.Name then
              self:SetLayerActive(UILayer.NormalBg.Name, true)
            else
              touchCamera:HideCamera()
            end
          else
            touchCamera:HideCamera()
          end
          self.sceneCameraDisable = true
        end
      end
    end
  end
end

local function CheckNeedShowSceneCamera(self, window)
  if not self.sceneCameraDisable then
    return
  end
  local hasOtherWindowNeedHideSceneCamera = false
  if self:GetStackWindowCount() > 0 then
    for i, v in ilist(self.windowStack) do
      if v.HideSceneCamera and v.State ~= WindowState.Close then
        hasOtherWindowNeedHideSceneCamera = true
        break
      end
    end
  end
  if not hasOtherWindowNeedHideSceneCamera and window.HideSceneCamera then
    local mainCamera = CS.UnityEngine.Camera.main
    if mainCamera then
      local touchCamera = mainCamera:GetComponent(typeof(MobileTouchCamera))
      if touchCamera then
        if Config.IsPC() then
          if window.Layer:GetName() == UILayer.Normal.Name then
            self:SetLayerActive(UILayer.NormalBg.Name, false)
          else
            touchCamera:ShowCamera()
          end
        else
          touchCamera:ShowCamera()
        end
        self.sceneCameraDisable = false
      end
    end
  end
end

local function ShowSceneCameraIfAnyHideCameraWindow(self)
  local hasHideSceneCameraWindow = false
  if self:GetStackWindowCount() > 0 then
    for i, v in ilist(self.windowStack) do
      if v.HideSceneCamera then
        hasHideSceneCameraWindow = true
        break
      end
    end
  end
  if hasHideSceneCameraWindow then
    local mainCamera = CS.UnityEngine.Camera.main
    if mainCamera then
      local touchCamera = mainCamera:GetComponent(typeof(MobileTouchCamera))
      if touchCamera then
        if Config.IsPC() then
          self:SetLayerActive(UILayer.NormalBg.Name, false)
        end
        touchCamera:ShowCamera()
      end
    end
  end
end

local function StopWorldCameraMove(self, window)
  if window.Name == UIWindowNames.UIMain or window.Name == UIWindowNames.UIMainMiniMap or window.Name == UIWindowNames.UIWorldZoneChangeTip or window.Layer:GetName() == UILayer.Guide.Name or window.Layer:GetName() == UILayer.TopMost.Name or window.Layer:GetName() == UILayer.Info.Name or window.Layer:GetName() == UILayer.Scene.Name or window.Layer:GetName() == UILayer.World.Name then
    return
  end
  local world = CS.SceneManager.World
  if world ~= nil then
    ProtectCall(function()
      world:StopCameraMove()
    end)
  end
end

local function InnerDestroyWindow(self, window)
  ProtectCall(function()
    window.Ctrl:Delete()
    window.View:Delete()
  end)
  if window.InstanceRequest ~= nil then
    window.InstanceRequest:Destroy()
    window.InstanceRequest = nil
  end
  OnWindowFinish(window)
  self.windows[window.Name] = nil
end

local function OnStartCloseWindow(self, name, windowUid)
  if not BlockList[name] then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    windowCloseTime[windowUid] = curTime
  end
end

local function OnFinishCloseWindow(self, name, windowUid)
  if windowCloseTime[windowUid] then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local useTime = curTime - windowCloseTime[windowUid]
    windowCloseTime[windowUid] = nil
    if 200 < useTime and useTime < 500 then
      EditorLog(string.format("<color=#AA1111>OpenWindow     uiwindowName:%s     useTime:%s</color>", name, useTime))
    elseif 500 <= useTime then
      PostEventLog.Track(PostEventLog.Defines.close_window, {windowName = name, useTime = useTime})
      EditorLog(string.format("<color=#FF0000>OpenWindow     uiwindowName:%s     useTime:%s</color>", name, useTime))
    end
  end
end

local function OnDestroyWindow(self, win)
  local winUid = GetWindowUid()
  OnStartCloseWindow(self, win.Name, winUid)
  InnerCloseWindow(self, win)
  ClearFPSLockInfo(self, win)
  InnerDestroyWindow(self, win)
  OnFinishCloseWindow(self, win.Name, winUid)
  EventManager:GetInstance():Broadcast(EventId.CloseUI, win.Name)
end

local function GetUIMainShowAnim(animType)
  if animType == UIMainAnimType.AllHide then
    return UIMainAnimType.AllShow
  elseif animType == UIMainAnimType.LeftRightBottomHide then
    return UIMainAnimType.LeftRightBottomShow
  end
end

local function PlayUIMainShowAnimation(self, animName, window)
  if (window == nil or self:GetStackWindowCount() == 1 and self:GetStackTopWindow() == window) and animName then
    local UIMain = self.windows[UIWindowNames.UIMain]
    if UIMain and UIMain.InstanceRequest and UIMain.InstanceRequest.isDone then
      self.UIMainAnim = animName
      UIMain.View:PlayAnim(animName)
      EventManager:GetInstance():Broadcast(EventId.SetGoldStoreBtnVisible, animName)
      self.UIMainAnim = nil
    end
  end
end

local function OnAfterWindowDestroy(ui_name)
  if ui_name == UIWindowNames.UIFarm or ui_name == UIWindowNames.UIFarmGather or ui_name == UIWindowNames.UIPasture or ui_name == UIWindowNames.UIFormationSelectListNew or ui_name == UIWindowNames.UIFormationSelectListV2 or ui_name == UIWindowNames.UICapacityFull then
    if CS.SceneManager.World then
      CS.SceneManager.World:QuitFocus(LookAtFocusTime)
    end
    EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildHideEffect)
  end
  EventManager:GetInstance():Broadcast(EventId.OnAfterWindowDestroy, ui_name)
end

local function DestroyWindow(self, ui_name, closeOptions)
  local window = self.windows[ui_name]
  if not window or window.State == WindowState.Destroying then
    return
  end
  closeOptions = closeOptions or {anim = true}
  if closeOptions.UIMainAnim == nil then
    closeOptions.UIMainAnim = GetUIMainShowAnim(self.UIMainAnim)
  end
  local playEffectWhenOpen = closeOptions.playEffect
  self:PlayUIMainShowAnimation(closeOptions.UIMainAnim, window)
  local ok, duration
  if closeOptions.anim then
    ok, duration = self:PlayMoveOutAnim(window)
  end
  self:PopStackWindow(window)
  self:CheckNeedShowSceneCamera(window)
  if closeOptions.anim and ok then
    local closeTimer = TimerManager:GetInstance():GetTimer(duration or 0.2, function()
      window.CloseTimer = nil
      if not IsNull(window.View.gameObject) then
        self:OnDestroyWindow(window)
      end
    end, nil, true, false, true)
    closeTimer:Start()
    window.CloseTimer = closeTimer
    window.State = WindowState.Destroying
  else
    self:OnDestroyWindow(window)
  end
  OnAfterWindowDestroy(ui_name)
  if not DataCenter.LWSoundManager:NewCommonSoundTest() and (playEffectWhenOpen == nil or playEffectWhenOpen == true) then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Close, false)
  end
  EventManager:GetInstance():Broadcast(EventId.GF_window_closed, ui_name)
end

local function IsWindowOpen(self, ui_name)
  local window = self.windows[ui_name]
  if not window then
    return false
  end
  return window.State == WindowState.Create or window.State == WindowState.Loading or window.State == WindowState.Open
end

local function DestroyWindowByLayer(self, layer)
  local windows = {}
  for k, v in pairs(self.windows) do
    windows[k] = v
  end
  for k, v in pairs(windows) do
    if v.Layer and v.Layer:GetName() == layer.Name then
      local ui_name = v.Name
      local config = GetWindowConfig(self, ui_name)
      if not config or not config.IgnoreDestroyWindowByLayer then
        self:PlayUIMainShowAnimation(GetUIMainShowAnim(self.UIMainAnim), v)
        self:PopStackWindow(v)
        self:CheckNeedShowSceneCamera(v)
        self:OnDestroyWindow(v)
        OnAfterWindowDestroy(ui_name)
      end
    end
  end
end

local function DestroyAllWindow(self)
  self:ShowSceneCameraIfAnyHideCameraWindow()
  
  local function CloseWindow(k, v)
    if not v then
      return
    end
    if not self.windows[k] then
      return
    end
    local ui_name = v.Name
    local winUid = GetWindowUid()
    OnStartCloseWindow(self, v.Name, winUid)
    InnerCloseWindow(self, v)
    ClearFPSLockInfo(self, v)
    InnerDestroyWindow(self, v)
    OnFinishCloseWindow(self, v.Name, winUid)
    OnAfterWindowDestroy(self, ui_name)
  end
  
  if self.windows then
    local _windows = DeepCopy(self.windows)
    for k, v in pairs(_windows) do
      CloseWindow(k, v)
    end
    if not table.IsNullOrEmpty(self.windows) then
      _windows = DeepCopy(self.windows)
      for k, v in pairs(_windows) do
        CloseWindow(k, v)
      end
    end
  end
  if self.windowStack then
    self.windowStack:clear()
  end
  if self.otherWindowStack then
    self.otherWindowStack:clear()
  end
  self.disableLuaAddComponentAssert = nil
end

local function HasWindow(self)
  for k, v in pairs(self.windows) do
    local layerName = v.Layer:GetName()
    if layerName == UILayer.Normal.Name or layerName == UILayer.Background.Name or layerName == UILayer.Guide.Name then
      return true
    end
  end
  return false
end

local function HasWindowByLayer(self, layer)
  for k, v in pairs(self.windows) do
    local layerName = v.Layer:GetName()
    if layerName == layer.Name then
      return true
    end
  end
  return false
end

local function CheckIfIsMainUIOpenOnly(self, ignoreGuide)
  for _, v in pairs(self.windows) do
    if not v.DontPushWindowStack and v.Name ~= UIWindowNames.TouchScreenEffect and v.Name ~= UIWindowNames.UICommonMessageTip and v.Name ~= UIWindowNames.UINpcTalkLayer and v.Name ~= UIWindowNames.UIArrow and v.Name ~= UIWindowNames.UIMain and v.Name ~= UIWindowNames.UINoticeHeroTips and v.Name ~= UIWindowNames.UINoticeTips and v.Name ~= UIWindowNames.UIGMBar and v.Name ~= UIWindowNames.UIGMPanel and v.Name ~= UIWindowNames.UIGMLogPanel and v.Name ~= UIWindowNames.UIFingerArrow and self:IsWindowOpen(v.Name) then
      return false
    end
  end
  if not ignoreGuide and DataCenter.GuideManager:InGuide() then
    return false
  end
  return true
end

local function PushStackWindow(self, window, hideTop)
  if window.Name == UIWindowNames.UIMain or window.Name == UIWindowNames.LWLLBattleMainUIView or window.Name == UIWindowNames.UIPVELoading or window.Name == UIWindowNames.UIGuideArrow or window.Name == UIWindowNames.UIArrow or window.Name == UIWindowNames.UIGuideHeadTalk or window.Layer:GetName() == UILayer.TopMost.Name or window.Layer:GetName() == UILayer.Scene.Name or window.Layer:GetName() == UILayer.World.Name then
    return
  elseif BattlefieldConfig and BattlefieldConfig.IsBattlefieldMainUI(window.Name) then
    return
  elseif window.DontPushWindowStack then
    return
  elseif window.Layer:GetName() == UILayer.Info.Name or window.Layer:GetName() == UILayer.Dialog.Name then
    self.otherWindowStack:erase(window)
    self.otherWindowStack:push(window)
  else
    local windowStack = self.windowStack
    windowStack:erase(window)
    if hideTop then
      local topWin = windowStack:tail()
      if topWin then
        topWin.View:SetActive(false)
        topWin.State = WindowState.Close
        self:CheckNeedShowSceneCamera(topWin)
      end
    end
    windowStack:push(window)
  end
end

local function UpdateHideBack(self, windowStack)
  local hideBack = false
  if windowStack.length == 0 then
    return
  end
  for i, f in rilist(windowStack) do
    if f then
      if hideBack and f.State == WindowState.Open then
        f.View:SetActive(false)
        f.State = WindowState.HideBack
      end
      if not hideBack and f.State == WindowState.HideBack then
        f.View:SetActive(true)
        f.State = WindowState.Open
      end
      if not hideBack and f.HideBack and f.State == WindowState.Open then
        hideBack = true
      end
    end
  end
end

local function PopStackWindow(self, window)
  if window.Name == UIWindowNames.UIMain or window.Name == UIWindowNames.UIPVELoading or window.Name == UIWindowNames.UIGuideArrow or window.Name == UIWindowNames.UIArrow or window.Layer:GetName() == UILayer.TopMost.Name or window.Layer:GetName() == UILayer.Scene.Name or window.Layer:GetName() == UILayer.World.Name then
    return
  elseif window.Layer:GetName() == UILayer.Info.Name or window.Layer:GetName() == UILayer.Dialog.Name then
    self.otherWindowStack:erase(window)
  else
    local windowStack = self.windowStack
    if windowStack:tail() == window then
      windowStack:pop()
      local topWin = windowStack:tail()
      if topWin and topWin.State ~= WindowState.Loading and topWin.State ~= WindowState.Destroying then
        if not topWin.View:GetActive() then
          topWin.View:SetActive(true)
          topWin.State = WindowState.Open
          EventManager:GetInstance():Broadcast(ChatEventEnum.UIHideViewShown, topWin.Name)
        end
        if type(topWin.View.SetOnTop) == "function" then
          topWin.View:SetOnTop()
          if windowStack:find(window) then
            Logger.LogError("\229\156\168\233\157\162\230\157\191\229\133\179\233\151\173\232\191\135\231\168\139\228\184\173\233\135\141\230\150\176\230\137\147\229\188\128\232\135\170\229\183\177\230\152\175\233\148\153\232\175\175\232\161\140\228\184\186")
            windowStack:erase(window)
          end
        end
      end
    else
      windowStack:erase(window)
    end
    self:UpdateHideBack(windowStack)
  end
end

local function IsInWindowStack(self, window)
  local windowStack = self.windowStack:find(window)
  return windowStack ~= nil and windowStack.value == window
end

local function GetStackWindowCount(self)
  local windowStack = self.windowStack
  return windowStack.length
end

local function GetStackTopWindow(self)
  local windowStack = self.windowStack
  return windowStack:tail()
end

local function IsNeedReorder(self, window)
  if not CS.CommonUtils.IsDebug() and not CS.GrayUtils.isGM then
    return false
  end
  local windowStack = self.windowStack
  if windowStack:find(window) and window ~= self:GetStackTopWindow() then
    Logger.LogInfo("[UIManager] need check:" .. window.Name)
    return true
  end
  return false
end

local function ReorderWindow(self, window)
  local windowStack = self.windowStack
  local offset = 0
  for node, value in rilist(windowStack) do
    if not (window ~= value and value and value.View) then
      break
    end
    if window.Layer == value.Layer and IsNotNull(value.View.gameObject) then
      offset = offset + 1
      Logger.LogInfo("[UIManager]" .. window.Name .. " Has Top window:" .. value.Name)
    end
  end
  if 0 < offset then
    local index = window.View.transform:GetSiblingIndex()
    local newindex = index - offset
    if newindex < 0 then
      newindex = 0
    end
    window.View.transform:SetSiblingIndex(newindex)
    Logger.LogInfo("[UIManager]Set SiblingIndex:" .. window.Name .. " " .. index .. "->" .. newindex)
  end
end

local function DestroyViewList(self, needCloseList, needPlayCloseEffect)
  for k, v in ipairs(needCloseList) do
    if DataCenter.GuideManager:IsCanCloseUI(v) then
      local window = self.windows[v]
      if window ~= nil then
        if needPlayCloseEffect then
          self:DestroyWindow(v)
        else
          self:DestroyWindow(v, {anim = true, playEffect = false})
        end
      end
    end
  end
end

local function GetUIMainAnim(self)
  return self.UIMainAnim
end

local function SetLayerActive(self, layerName, active)
  local layer = self:GetLayer(layerName)
  if layer ~= nil then
    layer.gameObject:SetActive(active)
  end
end

local function IsPanelLoadingComplete(self, ui_name)
  local window = self:GetWindow(ui_name)
  if window ~= nil and window.State == WindowState.Open then
    return true
  end
  return false
end

local function SetUIMainEnable(self, value)
  local window = self:GetWindow(UIWindowNames.UIMain)
  if window ~= nil and window.View ~= nil then
    window.View:SetActive(value)
  end
end

local function SetNewTMProFontMaterial(self, path, callback)
  if self.materialMap[path] then
    if callback then
      callback(self.materialMap[path])
    end
  elseif CS.GameEntry.Resource:HasAsset(path) then
    local asset = CS.GameEntry.Resource:LoadAssetAsync(path, typeof(CS.UnityEngine.Material))
    
    local function onLoaded(_)
      if asset == nil then
        return
      end
      self.materialMap[path] = asset.asset
      if callback then
        callback(asset.asset)
      end
    end
    
    if asset.completed then
      asset.completed = asset.completed + onLoaded
    else
      asset.completed = onLoaded
    end
    self.materialReqMap[path] = asset
  end
end

function UIManager:EditorProfile()
  local rst = {}
  if not self.windows then
    return rst
  end
  local windows = {}
  for k, v in pairs(self.windows) do
    local _ = {
      name = v.Name,
      gameObject = v.View and v.View.gameObject,
      state = v.State
    }
    table.insert(windows, _)
  end
  if 0 < #windows then
    rst.windows = windows
  end
  return rst
end

function UIManager:Description()
  local sb = StringBuilder.New()
  sb:AppendLine(string.format("\231\149\140\233\157\162\230\149\176\233\135\143:%s", self.windows and table.count(self.windows) or 0))
  sb:AppendLine(string.format("GetStackWindowCount:%s", self:GetStackWindowCount() or 0))
  sb:AppendLine()
  local time = UITimeManager:GetInstance()
  sb:AppendLine("---\229\159\186\231\161\128\228\191\161\230\129\175---")
  sb:AppendLine(string.format("\231\142\169\229\174\182id:%s", LuaEntry.Player:GetUid()))
  sb:AppendLine(string.format("\229\142\159\230\156\141id:%s", LuaEntry.Player:GetSourceServerId()))
  sb:AppendLine(string.format("\231\153\187\229\189\149\230\156\141id:%s", LuaEntry.Player:GetSelfServerId()))
  sb:AppendLine(string.format("\229\189\147\229\137\141\230\151\182\233\151\180:%s", time:TimeStampToTimeForServer(time:GetServerTime())))
  sb:AppendLine()
  local views = {}
  local state2Name = {
    [0] = "Create",
    [1] = "Loading",
    [2] = "Open",
    [3] = "Close",
    [4] = "Destroying",
    [5] = "HideBack"
  }
  local index = 0
  if table.count(self.windows) > 0 then
    sb:AppendLine("---\231\149\140\233\157\162---")
    for k, v in pairs(self.windows) do
      local windowName = v.Name
      local layer = v.Layer:GetName()
      local prefabName = v.PrefabPath
      local state = v.State
      local view = v.View
      local buttons = view and view.DevToolsButtons and view:DevToolsButtons()
      local funDesc
      if view and view.Description then
        function funDesc()
          return view:Description()
        end
      end
      sb:AppendLine(string.format("%s.[%s](view:%s)%s,  layer:%s", index, state2Name[state] or string.format("???%s", state), view and "\226\136\154" or "\195\151", windowName, layer))
      table.insert(views, {
        index = index,
        windowName = windowName,
        prefabName = prefabName,
        funDesc = funDesc,
        buttons = buttons,
        gameObject = view.gameObject
      })
      index = index + 1
    end
  end
  return {
    description = sb:ToString(),
    views = views
  }
end

local function IsSceneCameraDisable(self)
  return self.sceneCameraDisable or false
end

UIManager.__init = __init
UIManager.__delete = __delete
UIManager.Startup = Startup
UIManager.GetWindow = GetWindow
UIManager.OpenWindow = OpenWindow
UIManager.DestroyWindow = DestroyWindow
UIManager.IsWindowOpen = IsWindowOpen
UIManager.DestroyWindowByLayer = DestroyWindowByLayer
UIManager.DestroyAllWindow = DestroyAllWindow
UIManager.GetLayer = GetLayer
UIManager.HasWindow = HasWindow
UIManager.CheckIfIsMainUIOpenOnly = CheckIfIsMainUIOpenOnly
UIManager.GetScaleFactor = GetScaleFactor
UIManager.GetUIContainerRect = GetUIContainerRect
UIManager.PushStackWindow = PushStackWindow
UIManager.PopStackWindow = PopStackWindow
UIManager.GetStackTopWindow = GetStackTopWindow
UIManager.GetStackWindowCount = GetStackWindowCount
UIManager.PlayMoveInAnim = PlayMoveInAnim
UIManager.PlayMoveOutAnim = PlayMoveOutAnim
UIManager.OnDestroyWindow = OnDestroyWindow
UIManager.PlayUIMainShowAnimation = PlayUIMainShowAnimation
UIManager.DestroyViewList = DestroyViewList
UIManager.GetUIMainAnim = GetUIMainAnim
UIManager.StopWorldCameraMove = StopWorldCameraMove
UIManager.SetLayerActive = SetLayerActive
UIManager.IsPanelLoadingComplete = IsPanelLoadingComplete
UIManager.AddListener = AddListener
UIManager.RemoveListener = RemoveListener
UIManager.OnKeyCodeEscape = OnKeyCodeEscape
UIManager.KeyCodeEscape = KeyCodeEscape
UIManager.OnAndroidNavigationGestureEscape = OnAndroidNavigationGestureEscape
UIManager.AndroidNavigationGestureEscape = AndroidNavigationGestureEscape
UIManager.DeleteAllLayer = DeleteAllLayer
UIManager.SetUIMainEnable = SetUIMainEnable
UIManager.EnableInteractionBlocker = EnableInteractionBlocker
UIManager.DisableInteractionBlocker = DisableInteractionBlocker
UIManager.UpdateHideBack = UpdateHideBack
UIManager.IsInWindowStack = IsInWindowStack
UIManager.OnUpdate = OnUpdate
UIManager.ChangeFPSToHighFPS = ChangeFPSToHighFPS
UIManager.ClearFPSLockInfo = ClearFPSLockInfo
UIManager.CheckNeedHideSceneCamera = CheckNeedHideSceneCamera
UIManager.CheckNeedShowSceneCamera = CheckNeedShowSceneCamera
UIManager.ShowSceneCameraIfAnyHideCameraWindow = ShowSceneCameraIfAnyHideCameraWindow
UIManager.SetNewTMProFontMaterial = SetNewTMProFontMaterial
UIManager.GetWindowConfig = GetWindowConfig
UIManager.HasWindowByLayer = HasWindowByLayer
UIManager.IsNeedReorder = IsNeedReorder
UIManager.ReorderWindow = ReorderWindow
UIManager.IsSceneCameraDisable = IsSceneCameraDisable
UIManager.IsDisableLuaAddComponentAssert = IsDisableLuaAddComponentAssert
return UIManager
