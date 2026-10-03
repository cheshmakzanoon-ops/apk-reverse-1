local Settings = {}
Settings.Levels = {
  VeryLow = 0,
  Low = 1,
  Mid = 2,
  High = 3,
  VeryHigh = 4
}
Settings.LevelLimit = Settings.Levels.High

function Settings.SetLevelLimit(limit)
  if Settings.LevelLimit == limit then
    return
  end
  Settings.LevelLimit = limit
  EventManager:GetInstance():Broadcast(EventId.WorldMarchUpdateDisplayMode)
end

Settings.WorldZoomThreshold = 170

function Settings.SetWorldZoom(zoom)
  if not zoom then
    return
  end
  if zoom >= Settings.WorldZoomThreshold then
    Settings.SetLevelLimit(Settings.Levels.Mid)
  else
    Settings.SetLevelLimit(Settings.Levels.High)
  end
end

Settings.LevelAdjustment = 0
Settings.LevelAdjustmentMax = 0
Settings.LevelAdjustmentMin = -4
Settings.LevelAdjustDelayTimer = nil
Settings.LevelAdjustDelayValue = nil
Settings.GraphicLevelLimit = nil
local DelayTimes = {}
DelayTimes[-1] = 5
DelayTimes[-2] = 5
DelayTimes[-3] = 5
DelayTimes[-4] = 5

function Settings.ClearDelayTimer()
  if Settings.LevelAdjustDelayTimer then
    Settings.LevelAdjustDelayTimer:Stop()
    Settings.LevelAdjustDelayTimer = nil
  end
end

function Settings.SetLevelAdjustment(adjustment, immediately)
  if adjustment > Settings.currentFpsLevel then
    adjustment = Settings.currentFpsLevel
  end
  adjustment = adjustment > Settings.LevelAdjustmentMax and Settings.LevelAdjustmentMax or adjustment
  adjustment = adjustment < Settings.LevelAdjustmentMin and Settings.LevelAdjustmentMin or adjustment
  local isEqual = Settings.LevelAdjustment == adjustment
  local isDown = adjustment < Settings.LevelAdjustment
  if Settings.LevelAdjustDelayTimer and (isDown or isEqual) then
    Settings.ClearDelayTimer()
  end
  if isEqual then
    return
  end
  if isDown then
    local stamp = CommonUtil.PlayerPrefsGetLong("March_Downgrade_Tip_Stamp", 0)
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    if 86400 < curTime - stamp then
      UIUtil.ShowTipsId("jianhuamoshi_tips_10001")
      CommonUtil.PlayerPrefsSetLong("March_Downgrade_Tip_Stamp", curTime)
    end
    PostEventLog.Track(PostEventLog.Defines.WorldMarchDisplayDowngrade, {
      from = Settings.LevelAdjustment,
      to = adjustment
    })
  elseif immediately then
    PostEventLog.Track(PostEventLog.Defines.WorldMarchDisplayUpgrade, {
      from = Settings.LevelAdjustment,
      to = adjustment
    })
  else
    if Settings.LevelAdjustDelayValue and adjustment < Settings.LevelAdjustDelayValue then
      Settings.ClearDelayTimer()
    end
    Settings.LevelAdjustDelayValue = adjustment
    if not Settings.LevelAdjustDelayTimer then
      local delaySec = DelayTimes[Settings.LevelAdjustment] or 5
      Settings.LevelAdjustDelayTimer = TimerManager:GetInstance():DelayInvoke(Settings.DelaySetLevelAdjustment, delaySec)
    end
    return
  end
  if adjustment <= -1 and not Settings.GraphicLevelLimit then
    if CS.CommonUtils.IsDebug() then
      UIUtil.ShowTips("[Debug]\232\135\170\229\138\168\232\167\166\229\143\145\228\189\142\231\148\187\232\180\168\239\188\129\239\188\136\232\181\182\231\180\167\230\141\162\230\137\139\230\156\186\229\144\167\228\189\160\239\188\137")
    end
    Settings.GraphicLevelLimit = true
    EventManager:GetInstance():Broadcast(EventId.Settings_Graphic_Lv_Changed)
  elseif Settings.GraphicLevelLimit and 0 <= adjustment then
    if CS.CommonUtils.IsDebug() then
      UIUtil.ShowTips("[Debug]\233\128\128\229\135\186\232\182\133\231\186\167\230\158\129\231\174\128\239\188\140\231\148\187\232\180\168\232\191\152\229\142\159\239\188\129\239\188\136\230\137\139\230\156\186\229\143\175\228\187\165\229\134\141\231\148\168\231\148\168\239\188\137")
    end
    Settings.GraphicLevelLimit = nil
    EventManager:GetInstance():Broadcast(EventId.Settings_Graphic_Lv_Changed)
  end
  Settings.LevelAdjustment = adjustment
  Settings.PostEvent()
  if adjustment and CS.GameEntry.Data.Player.SetData ~= nil then
    local SimpleModeOn = adjustment < 0 or Settings.LevelLimit == Settings.Levels.Low
    CS.GameEntry.Data.Player:SetData("SimpleModeOn", SimpleModeOn and "YES" or "NO")
  end
  EventManager:GetInstance():Broadcast(EventId.WorldMarchUpdateDisplayMode)
  Settings.SetLittleSmartEnable(Settings.LevelAdjustment == -4)
end

function Settings.DelaySetLevelAdjustment()
  if Settings.LevelAdjustDelayValue then
    Settings.SetLevelAdjustment(Settings.LevelAdjustDelayValue, true)
    Settings.LevelAdjustDelayValue = nil
  end
end

Settings.LevelAdjustmentSquadCountThreshold = 9
Settings.LevelAdjustmentThresholdsList = nil
Settings.LittleSmartTroopLineThreshold = 100
Settings.SupportGPUInstancing = false
Settings.deviceLevel = 1
Settings.SwitchOn = nil
Settings.LineSwitchOn = nil
Settings.FpsSwitchOn = nil

function Settings.InitLevelAdjustmentSquadCountThresholds(deviceLevel)
  Settings.deviceLevel = deviceLevel
  if deviceLevel == 1 then
    Settings.LevelAdjustmentSquadCountThreshold = 9
    Settings.LittleSmartTroopLineThreshold = 100
  elseif deviceLevel == 2 then
    Settings.LevelAdjustmentSquadCountThreshold = 24
    Settings.LittleSmartTroopLineThreshold = 200
  else
    Settings.LevelAdjustmentSquadCountThreshold = 36
    Settings.LittleSmartTroopLineThreshold = 300
  end
  Settings.Init()
end

function Settings.ConfigureAdjustmentThresholds(thresholds, smartTroopLine)
  Settings.LevelAdjustmentThresholdsList = thresholds
  Settings.LittleSmartTroopLineThreshold = smartTroopLine
end

function Settings.Init()
  Settings.SupportGPUInstancing = CS.UnityEngine.SystemInfo.supportsInstancing
  if not Settings.SupportGPUInstancing then
    Logger.LogError("\232\174\190\229\164\135\228\184\141\230\148\175\230\140\129\229\174\158\228\190\139\229\140\150\230\184\178\230\159\147\239\188\129")
    Logger.LogInfo("[WorldTroopLine]Device doesn't support GPU instancing a fuck!")
  end
  Settings.currentFpsLevel = 0
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, Settings.OnWorldLodChanged)
  EventManager:GetInstance():AddListener(EventId.LowFps, Settings.OnLowFps)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, Settings.OnEnterCity)
  Settings.StartPostEventTimer()
end

function Settings.UnInit()
  Settings.currentFpsLevel = 0
  Settings.DestroyFpsTimer()
  Settings.DestroyPostEventTimer()
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, Settings.OnWorldLodChanged)
  EventManager:GetInstance():RemoveListener(EventId.LowFps, Settings.OnLowFps)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, Settings.OnEnterCity)
end

function Settings.RefreshSquadCount(count)
  Settings.SetSquadCount(count)
end

function Settings.RefreshNormalTroopLineCount(count)
  Settings.TroopLineCount = count
end

function Settings.RefreshPointCounts(objCount, dataCount)
end

Settings.SquadCount = 0
Settings.TroopLineCount = 0

function Settings.SetSquadCount(count)
  Settings.SquadCount = count
  if Settings.SetSquadCountByThresholds(count) then
    return
  end
  if Settings.SquadCount <= Settings.LevelAdjustmentSquadCountThreshold then
    Settings.SetLevelAdjustment(0)
  elseif Settings.SquadCount <= Settings.LevelAdjustmentSquadCountThreshold * 2 then
    Settings.SetLevelAdjustment(-1)
  elseif Settings.SquadCount <= Settings.LevelAdjustmentSquadCountThreshold * 6 then
    Settings.SetLevelAdjustment(-2)
  elseif Settings.SquadCount <= Settings.LevelAdjustmentSquadCountThreshold * 10 then
    Settings.SetLevelAdjustment(-3)
  else
    Settings.SetLevelAdjustment(-4)
  end
end

function Settings.SetSquadCountByThresholds(count)
  if Settings.LevelAdjustmentThresholdsList == nil then
    return false
  end
  for i, threshold in ipairs(Settings.LevelAdjustmentThresholdsList) do
    if count < threshold then
      Settings.SetLevelAdjustment(-i + 1)
      return true
    end
  end
  Settings.SetLevelAdjustment(-4)
  return true
end

function Settings.Reset()
  Settings.SquadCount = 0
  Settings.LevelAdjustment = 0
  Settings.LevelLimit = Settings.Levels.High
  Settings.ClearDelayTimer()
  Settings.LevelAdjustDelayValue = nil
  EventManager:GetInstance():Broadcast(EventId.WorldMarchUpdateDisplayMode)
end

function Settings.RealSquadLevel(level)
  return math.min(level + Settings.LevelAdjustment, Settings.LevelLimit)
end

function Settings.OnlyDisplayLeader(level)
  return Settings.RealSquadLevel(level) <= Settings.Levels.Mid
end

function Settings.DisplayHeroAsIcon(level)
  return Settings.RealSquadLevel(level) <= Settings.Levels.Low
end

function Settings.HasBattleProcess(level)
  return Settings.RealSquadLevel(level) >= Settings.Levels.High
end

function Settings.PlayBattleSkills(level)
  return Settings.HasBattleProcess(level)
end

function Settings.ShowTroopPin(level)
  level = level or Settings.Levels.High
  return Settings.RealSquadLevel(level) <= Settings.Levels.Low
end

function Settings.GetShowTroopLineMask()
  return 7
end

function Settings.HideTroopLineMiddleSprite()
  return Settings.RealSquadLevel(Settings.Levels.High) <= Settings.Levels.Low
end

function Settings.ShowMummyMarchEffect()
  return Settings.RealSquadLevel(Settings.Levels.VeryHigh) > Settings.Levels.VeryLow
end

function Settings.TroopCanClicked()
  return Settings.RealSquadLevel(Settings.Levels.High) > Settings.Levels.VeryLow
end

function Settings.ShowPlayerDogHead()
  return Settings.RealSquadLevel(Settings.Levels.High) > Settings.Levels.VeryLow
end

function Settings:ShowWorldPlotBubble()
  return Settings.RealSquadLevel(Settings.Levels.High) > Settings.Levels.VeryLow
end

function Settings:ShowWorldSticker()
  return Settings.LevelAdjustment == 0
end

function Settings.ShowDynamicWorldSticker()
  return Settings.RealSquadLevel(Settings.Levels.VeryHigh) > Settings.Levels.Mid
end

function Settings:ShowWarFlagSimple()
  return Settings.LevelAdjustment < -2
end

function Settings.ShowFireworkEffect()
  return Settings.LevelAdjustment > -2
end

local troopLineScale = {}
troopLineScale[-1] = 0.7
troopLineScale[-2] = 0.5
troopLineScale[-3] = 0.4
troopLineScale[-4] = 0.4

function Settings:GetTroopLineWidthScale()
  return troopLineScale[Settings.LevelAdjustment] or 1
end

local troopCircleScale = {}
troopCircleScale[-1] = 0.8
troopCircleScale[-2] = 0.35
troopCircleScale[-3] = 0.35
troopCircleScale[-4] = 0.35

function Settings:GetTroopCircleScale()
  return troopCircleScale[Settings.LevelAdjustment] or 1
end

function Settings.IsSwitchOn()
  if Settings.SwitchOn == nil then
    Settings.SwitchOn = LuaEntry.DataConfig:CheckSwitch("troops_simplify_hardmodel")
  end
  return Settings.SwitchOn
end

function Settings.IsLineSwitchOn()
  return WorldBattleUtil.EnableNewTroopLine()
end

function Settings.IsLowFpsSwitchOn()
  if Settings.FpsSwitchOn == nil then
    Settings.FpsSwitchOn = LuaEntry.DataConfig:CheckSwitch("fps_simplify")
  end
  return Settings.FpsSwitchOn
end

local enableLittleSmartTroop = false

function Settings.SetLittleSmartEnable(enable)
  if not Settings.SupportGPUInstancing or not Settings.IsSwitchOn() then
    return
  end
  if enableLittleSmartTroop == enable then
    return
  end
  enableLittleSmartTroop = enable
  EventManager:GetInstance():Broadcast(EventId.ChangeLittleSmartTroopMode, enableLittleSmartTroop)
end

function Settings.IsLittleSmartTroopEnable()
  if not Settings.SupportGPUInstancing or not Settings.IsSwitchOn() then
    return false
  end
  return enableLittleSmartTroop
end

function Settings.IsLittleSmartTroopLineEnable()
  return Settings.SupportGPUInstancing and Settings.IsLineSwitchOn()
end

function Settings.GetCurrentDisplayLevel()
  return Settings.LevelAdjustment
end

local lastPostTime = 0
local postGap = 30

function Settings.PostEvent()
  local currentTime = SafeLocalOsTime()
  if currentTime - lastPostTime <= postGap then
    return
  end
  lastPostTime = currentTime
  local fps = CS.SceneLowFpsMonitor.Instance and CS.SceneLowFpsMonitor.Instance.NewAvgFps or -1
  fps = math.ceil(fps * 10) / 10
  local enableNewTroopLine = WorldBattleUtil.EnableNewTroopLine()
  PostEventLog.Track(PostEventLog.Defines.LittleSmartActive, {
    pDeviceLevel = Settings.deviceLevel,
    pDisplayLevel = Settings.LevelAdjustment,
    pSupportInstancing = Settings.SupportGPUInstancing,
    pEnableLittleSmartTroop = enableLittleSmartTroop,
    pEnableLittleSmartTroopLine = enableNewTroopLine,
    pCurFPS = fps,
    pLod = Settings.currentLod,
    pSwitch = Settings.IsSwitchOn()
  })
end

Settings.currentLod = 1

function Settings.OnWorldLodChanged(lod)
  Settings.currentLod = toInt(lod) or 1
  EventManager:GetInstance():Broadcast(EventId.AfterWorldCameraLodChanged, Settings.currentLod)
end

Settings.LowFpsConfig = nil
Settings.DefaultLowFpsConfig = {
  fpsCount = 50,
  lowCount = 25,
  fps30Threshold = 20,
  fps45Threshold = 20,
  fps60Threshold = 20,
  countdown = 5
}

function Settings.GetLowFpsConfig()
  if not Settings.LowFpsConfig then
    Settings.LowFpsConfig = {}
    Settings.LowFpsConfig.fpsCount = LuaEntry.DataConfig:TryGetNum("fps_simplify_config", "k1", Settings.DefaultLowFpsConfig.fpsCount)
    Settings.LowFpsConfig.lowCount = LuaEntry.DataConfig:TryGetNum("fps_simplify_config", "k2", Settings.DefaultLowFpsConfig.lowCount)
    Settings.LowFpsConfig.fps30Threshold = LuaEntry.DataConfig:TryGetNum("fps_simplify_config", "k3", Settings.DefaultLowFpsConfig.fps30Threshold)
    Settings.LowFpsConfig.fps45Threshold = LuaEntry.DataConfig:TryGetNum("fps_simplify_config", "k4", Settings.DefaultLowFpsConfig.fps45Threshold)
    Settings.LowFpsConfig.fps60Threshold = LuaEntry.DataConfig:TryGetNum("fps_simplify_config", "k5", Settings.DefaultLowFpsConfig.fps60Threshold)
    Settings.LowFpsConfig.countdown = LuaEntry.DataConfig:TryGetNum("fps_simplify_config", "k6", Settings.DefaultLowFpsConfig.countdown)
  end
  return Settings.LowFpsConfig
end

Settings.fpsTimer = nil
Settings.currentFpsLevel = 0

function Settings.StartFpsTimer()
  Settings.DestroyFpsTimer()
  Settings.fpsTimer = TimerManager:GetInstance():GetTimer(Settings.GetLowFpsConfig().countdown + 0.5, Settings.TryRecoverDisplayLv, Settings, true, false, true)
  Settings.fpsTimer:Start()
end

function Settings.DestroyFpsTimer()
  if Settings.fpsTimer then
    Settings.fpsTimer:Stop()
    Settings.fpsTimer = nil
  end
end

function Settings.TryRecoverDisplayLv()
  Settings.currentFpsLevel = 0
  Settings.SetSquadCount(Settings.SquadCount)
end

Settings.LowFpsTriggerCount = 0

function Settings.OnLowFps()
  if not Settings.IsLowFpsSwitchOn() then
    return
  end
  if not SceneUtils.GetIsInWorld() then
    return
  end
  local cur = Settings.currentFpsLevel
  Settings.currentFpsLevel = Settings.LevelAdjustment - 1
  if Settings.currentFpsLevel < Settings.LevelAdjustmentMin then
    Settings.currentFpsLevel = Settings.LevelAdjustmentMin
  end
  Logger.LogInfo(string.format("[xLowFps] Trigger adjust: %s -> %s", cur, Settings.currentFpsLevel))
  Settings.SetLevelAdjustment(Settings.currentFpsLevel)
  Settings.StartFpsTimer()
  Settings.LowFpsTriggerCount = Settings.LowFpsTriggerCount + 1
end

Settings.postEventTimer = nil

function Settings.StartPostEventTimer()
  Settings.DestroyPostEventTimer()
  Settings.postEventTimer = TimerManager:GetInstance():GetTimer(60, Settings.TryPostFpsLowEvent, Settings, false, false, true)
  Settings.postEventTimer:Start()
end

function Settings.DestroyPostEventTimer()
  if Settings.postEventTimer then
    Settings.postEventTimer:Stop()
    Settings.postEventTimer = nil
  end
end

function Settings.TryPostFpsLowEvent()
  if CommonUtil.IsDebug() then
  end
  if Settings.LowFpsTriggerCount > 0 then
    PostEventLog.Track(PostEventLog.Defines.WorldDisplaySettingsFpsLow, {
      pDeviceLevel = Settings.deviceLevel,
      pSupportInstancing = Settings.SupportGPUInstancing,
      i_common_num = Settings.LowFpsTriggerCount
    })
    Settings.LowFpsTriggerCount = 0
  end
end

function Settings.OnEnterCity()
  Settings.Reset()
end

return Settings
