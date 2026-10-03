local LWDevConsoleManager = BaseClass("LWDevConsoleManager")
local TouchWrapper = CS.BitBenderGames.TouchWrapper
local EventSystem = CS.UnityEngine.EventSystems.EventSystem
local PrefsHistyoryCapacity = 10

function LWDevConsoleManager:__init()
  EventManager:GetInstance():AddListener(EventId.OnClickEmpty, self.OnClickEmpty)
  EventManager:GetInstance():AddListener(EventId.SCREEN_TOUCH_DOWN_IGNORE_UI, self.OnTouchDown)
  UpdateManager:GetInstance():AddUpdate(self.OnUpdate)
  self.historyBuffer = {}
  for i = PrefsHistyoryCapacity, 1, -1 do
    local key = "LWDevConsoleHistory" .. i
    local value = CS.UnityEngine.PlayerPrefs.GetString(key, "")
    if not string.IsNullOrEmpty(value) then
      table.insert(self.historyBuffer, 1, value)
    end
  end
end

function LWDevConsoleManager:__delete()
  EventManager:GetInstance():RemoveListener(EventId.SCREEN_TOUCH_DOWN_IGNORE_UI, self.OnTouchDown)
  EventManager:GetInstance():RemoveListener(EventId.OnClickEmpty, self.OnClickEmpty)
  UpdateManager:GetInstance():RemoveUpdate(self.OnUpdate)
  self.historyBuffer = nil
end

function LWDevConsoleManager:Startup()
end

local clickEmptyCounter = 0
local clickEmptyTimer = 0

function LWDevConsoleManager.OnClickEmpty()
  if not GMUtils.GetBool(GMConst.DebugClickEmptyRunCmd, false) then
    return
  end
  if CS.SceneManager.IsInPVE() then
    local screenPos = CS.UnityEngine.Input.mousePosition
    if screenPos.y < CS.UnityEngine.Screen.height / 2 then
      return
    end
  end
  if TouchWrapper.TouchCount > 0 then
    local touches = TouchWrapper.Touches
    local touchCount = touches.Count
    for i = 0, touchCount - 1 do
      local t = touches[i]
      if EventSystem.current:IsPointerOverGameObject(t.FingerId) then
        return
      end
    end
  end
  local self = DataCenter.LWDevConsoleManager
  clickEmptyCounter = clickEmptyCounter + 1
  if 5 <= clickEmptyCounter then
    self:OpenWindow()
  else
    clickEmptyTimer = 0.5
  end
end

function LWDevConsoleManager.OnTouchDown(touchInfo)
  local self = DataCenter.LWDevConsoleManager
  if touchInfo.pointerId == 3 then
    self:OpenWindow()
  end
end

function LWDevConsoleManager.OnUpdate()
  local self = DataCenter.LWDevConsoleManager
  if CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.F5) then
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UILWDevConsole)
    if window ~= nil and window.State == 2 then
      window.Ctrl:CloseSelf()
    else
      self:OpenWindow()
    end
  elseif CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.F6) then
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIGMPanel)
    if window ~= nil and window.State == 2 then
      window.Ctrl:CloseSelf()
    else
      self:OpenWindow()
    end
  elseif CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.F7) then
    if SceneUtils.GetIsInWorld() then
      local trackMarchUuid = CS.SceneManager.World.TrackMarchId
      if 0 < trackMarchUuid then
        MarchUtil.ShareOneMarch(trackMarchUuid)
      else
        UIUtil.ShowTips("\231\142\176\229\156\168\231\155\184\230\156\186\230\178\161\230\156\137\233\148\129\229\174\154\228\187\187\228\189\149\232\161\140\229\134\155")
      end
    else
      UIUtil.ShowTips("\231\142\176\229\156\168\231\155\184\230\156\186\230\178\161\230\156\137\233\148\129\229\174\154\228\187\187\228\189\149\232\161\140\229\134\155")
    end
  elseif CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.F10) then
  elseif CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.Return) then
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UILWDevConsole)
    if window ~= nil and window.State == 2 then
      window.View:TryExecute()
    end
  elseif CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.UpArrow) then
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UILWDevConsole)
    if window ~= nil and window.State == 2 then
      window.View:HistoryUp()
    end
  elseif CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.DownArrow) then
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UILWDevConsole)
    if window ~= nil and window.State == 2 then
      window.View:HistoryDown()
    end
  end
  if CS.UnityEngine.Input.GetKey(CS.UnityEngine.KeyCode.BackQuote) then
    local temp
    local tip = ""
    if CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.Alpha1) then
      temp = Language.ChineseSimplified
      tip = "\231\174\128\228\184\173"
    elseif CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.Alpha2) then
      temp = Language.ChineseTraditional
      tip = "\231\185\129\228\184\173"
    elseif CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.Alpha3) then
      temp = Language.Arabic
      CommonUtil.SetAutoArabicMirrorSwitch(false)
      tip = "\233\152\191\230\173\163"
    elseif CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.Alpha4) then
      temp = Language.Arabic
      CommonUtil.SetAutoArabicMirrorSwitch(true)
      tip = "\233\152\191\229\143\141"
    elseif CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.Alpha5) then
      temp = Language.Korean
      tip = "\233\159\169\232\175\173"
    elseif CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.Alpha6) then
      temp = Language.German
      tip = "\229\190\183\232\175\173"
    end
    if temp then
      Logger.Log("\229\136\135\230\141\162\228\184\186\239\188\154" .. tip)
      ChatInterface.getTranslateMgr():SetChatTranslateLanguage(temp)
      CS.GameEntry.Localization:SetLanguage(temp)
      CS.ApplicationLaunch.Instance:ReloadGame()
    end
  end
  if 0 < clickEmptyTimer then
    clickEmptyTimer = clickEmptyTimer - Time.deltaTime
    if clickEmptyTimer <= 0 then
      clickEmptyCounter = 0
    end
  end
end

function LWDevConsoleManager:OpenWindow(initPrint)
  clickEmptyCounter = 0
  clickEmptyTimer = 0
  if CS.CommonUtils.IsDebug() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDevConsole, {anim = false}, self.historyBuffer, initPrint)
  end
end

function LWDevConsoleManager:SaveHistory(historyBuffer)
  self.historyBuffer = historyBuffer
  for i = 1, math.min(#self.historyBuffer, PrefsHistyoryCapacity) do
    local key = "LWDevConsoleHistory" .. i
    CS.UnityEngine.PlayerPrefs.SetString(key, self.historyBuffer[i])
  end
end

return LWDevConsoleManager
