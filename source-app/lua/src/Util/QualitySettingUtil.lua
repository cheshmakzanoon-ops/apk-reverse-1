require("Util.DeviceModelSpec")
require("Util.SocModelSpec")
local tolower = string.lower
local Setting = CS.GameEntry.Setting
local Application = CS.UnityEngine.Application
local SceneQualitySetting = CS.SceneQualitySetting
local SystemInfo = CS.UnityEngine.SystemInfo
local QualitySettings = CS.UnityEngine.QualitySettings
local DynamicFPSConfig = CS.DynamicFPSConfig
local DisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
local _isEnableUpdateTargetFrameRate = false
local _kMiddleQualityTargetFrameRate = 30
local _kLowTargetFrameRate = 45
local _kHighTargetFrameRate = 60
local _kCompareTargetFrameRate = 53
local _curTargetFrameRate = 60
local _combatUnitsThreshhold = 255
local _kPixelHeightMax = 1920
local _kPixelHeightMaxLow = 1440
local _kRenderScaleLow = 1
local Screen = CS.UnityEngine.Screen
local MainCamera

local function SetTargetFrameRate(targetFrameRate)
  Application.targetFrameRate = targetFrameRate
end

local QualitySettingUtil = {
  Low = {
    [EnumQualitySetting.PostProcess_Bloom] = EnumQualityLevel.Off,
    [EnumQualitySetting.PostProcess_ColorAdjustments] = EnumQualityLevel.Off,
    [EnumQualitySetting.PostProcess_Vignette] = EnumQualityLevel.Off,
    [EnumQualitySetting.PostProcess_Tonemapping] = EnumQualityLevel.Off,
    [EnumQualitySetting.PostProcess_LiftGammaGain] = EnumQualityLevel.Off,
    [EnumQualitySetting.PostProcess_DepthOfField] = EnumQualityLevel.Off,
    [EnumQualitySetting.Resolution] = EnumQualityLevel.Low,
    [EnumQualitySetting.Terrain] = EnumQualityLevel.Low,
    [EnumQualitySetting.ShaderLOD] = EnumQualityLevel.Low
  },
  Middle = {
    [EnumQualitySetting.PostProcess_Bloom] = EnumQualityLevel.Off,
    [EnumQualitySetting.PostProcess_ColorAdjustments] = EnumQualityLevel.High,
    [EnumQualitySetting.PostProcess_Vignette] = EnumQualityLevel.Off,
    [EnumQualitySetting.PostProcess_Tonemapping] = EnumQualityLevel.Off,
    [EnumQualitySetting.PostProcess_LiftGammaGain] = EnumQualityLevel.Off,
    [EnumQualitySetting.PostProcess_DepthOfField] = EnumQualityLevel.Off,
    [EnumQualitySetting.Resolution] = EnumQualityLevel.High,
    [EnumQualitySetting.Terrain] = EnumQualityLevel.Low,
    [EnumQualitySetting.ShaderLOD] = EnumQualityLevel.Middle
  },
  High = {
    [EnumQualitySetting.PostProcess_Bloom] = EnumQualityLevel.High,
    [EnumQualitySetting.PostProcess_ColorAdjustments] = EnumQualityLevel.High,
    [EnumQualitySetting.PostProcess_Vignette] = EnumQualityLevel.High,
    [EnumQualitySetting.PostProcess_Tonemapping] = EnumQualityLevel.High,
    [EnumQualitySetting.PostProcess_LiftGammaGain] = EnumQualityLevel.High,
    [EnumQualitySetting.PostProcess_DepthOfField] = EnumQualityLevel.High,
    [EnumQualitySetting.Resolution] = EnumQualityLevel.High,
    [EnumQualitySetting.Terrain] = EnumQualityLevel.High,
    [EnumQualitySetting.ShaderLOD] = EnumQualityLevel.High
  },
  LowGflops = 250.0,
  HighGflops = 450.0,
  LowPassMark = 5300.0,
  HighPassMark = 12000.0,
  LowBenchmark = 1000.0,
  HighBenchmark = 2000.0,
  CurrentGraphicLv = EnumQualityLevel.High
}

function QualitySettingUtil.Init()
  if not QualitySettingUtil.isInit then
    QualitySettingUtil.isInit = true
    SceneQualitySetting.SetPixelHeightMax(_kPixelHeightMax)
    UpdateManager:GetInstance():AddUpdate(QualitySettingUtil.Update)
    QualitySettingUtil.CheckSetting()
    Logger.Log("QualitySettingUtil.Init: " .. QualitySettingUtil.GetCurrentGraphicLevel())
  end
end

function QualitySettingUtil.Uninit()
  if QualitySettingUtil.isInit then
    QualitySettingUtil.isInit = false
    UpdateManager:GetInstance():RemoveUpdate(QualitySettingUtil.Update)
  end
  DisplaySettings.UnInit()
end

function QualitySettingUtil.OnLowFps()
  QualitySettingUtil.SetSettingGroup(EnumQualityLevel.Middle)
end

function QualitySettingUtil.CheckSetting()
  QualitySettingUtil.powerSaveMode = Setting:GetInt(SettingKeys.POWER_SAVING_MODE, 0)
  local recommendLevel = QualitySettingUtil.GetRecommendLevel()
  DisplaySettings.InitLevelAdjustmentSquadCountThresholds(recommendLevel)
  local frameLevel = Setting:GetInt(SettingKeys.SCENE_FPS_LEVEL, recommendLevel)
  QualitySettingUtil.SetSetting(SettingKeys.SCENE_FPS_LEVEL, frameLevel)
  local graphicLevel = Setting:GetInt(SettingKeys.SCENE_GRAPHIC_LEVEL, recommendLevel)
  QualitySettingUtil.SetSettingGroup(graphicLevel)
  Logger.Log(string.format("CheckSetting frameLevel:%d graphicLevel:%d", frameLevel, graphicLevel))
end

function QualitySettingUtil.GetRecommendLevel()
  local dev_model = tolower(Setting:GetString("DEVICE_MODEL", SystemInfo.deviceModel))
  local soc_model = tolower(Setting:GetString("SOC_MODEL", ""))
  local cpu_freq = Setting:GetInt("CPU_FREQ", SystemInfo.processorFrequency)
  local spec = DeviceModelSpecConfigs[dev_model]
  local passmark = 0.0
  if spec == nil then
    spec = SocModelSpecConfigs[soc_model]
  else
    passmark = spec.bm_passmark
  end
  local lv = EnumQualityLevel.High
  if spec ~= nil then
    if 100.0 < passmark then
      if passmark < QualitySettingUtil.LowPassMark then
        lv = EnumQualityLevel.Low
      elseif passmark < QualitySettingUtil.HighPassMark then
        lv = EnumQualityLevel.Middle
      end
    else
      local gflops = spec.gpu_gflops
      if gflops < QualitySettingUtil.LowGflops then
        lv = EnumQualityLevel.Low
      elseif gflops < QualitySettingUtil.HighGflops then
        lv = EnumQualityLevel.Middle
      end
    end
  elseif cpu_freq ~= nil and 100 < cpu_freq and cpu_freq <= 2400 then
    lv = EnumQualityLevel.Low
  end
  if SystemInfo.systemMemorySize <= 5000 then
    lv = EnumQualityLevel.Low
  end
  if IS_UNITY_EDITOR then
    lv = EnumQualityLevel.High
  end
  Logger.Log(string.format("Device Model: %s Board: %s CPU freq: %d RecommendQuality: %d", dev_model, soc_model, cpu_freq, lv))
  return lv
end

function QualitySettingUtil.GetSetting(inType)
  local setting = QualitySettingUtil.GetSettingGroup(QualitySettingUtil.CurrentGraphicLv)
  return setting[inType]
end

function QualitySettingUtil.SetSetting(inType, inLevel)
  Setting:SetInt(inType, inLevel)
  if inType == EnumQualitySetting.FPS then
  end
end

function QualitySettingUtil.GetSettingGroup(inLevel)
  local setting = QualitySettingUtil.High
  if inLevel == EnumQualityLevel.Low then
    setting = QualitySettingUtil.Low
  elseif inLevel == EnumQualityLevel.Middle then
    setting = QualitySettingUtil.Middle
  elseif inLevel == EnumQualityLevel.High then
    setting = QualitySettingUtil.High
  end
  return setting
end

function QualitySettingUtil.GetCurrentGraphicLevel()
  local raw = QualitySettingUtil.CurrentGraphicLv or Setting:GetInt(SettingKeys.SCENE_GRAPHIC_LEVEL, EnumQualityLevel.High)
  local displayLimit = DisplaySettings.GraphicLevelLimit
  if not displayLimit then
    return raw
  end
  return 1
end

function QualitySettingUtil.SetSettingGroup(inLevel)
  local setting = QualitySettingUtil.GetSettingGroup(inLevel)
  for k, v in pairs(setting) do
    QualitySettingUtil.SetSetting(k, v)
  end
  if inLevel ~= nil and 0 <= inLevel then
    QualitySettingUtil.CurrentGraphicLv = inLevel
  end
  Setting:SetInt(SettingKeys.SCENE_GRAPHIC_LEVEL, inLevel)
  QualitySettingUtil.SetDynamicFPSConfig(inLevel)
  QualitySettingUtil.SaveSetting()
  DisplaySettings.GraphicLevelLimit = nil
end

function QualitySettingUtil.SetDynamicFPSConfig(inLevel)
  local powerSaveOn = QualitySettingUtil.powerSaveMode > 0
  local normalFPS = powerSaveOn and 30 or 60
  local highFPS = normalFPS
  local dynamicHighFpsOn = LuaEntry.DataConfig:TryGetNum("dynamic_high_fps_on", "k1")
  normalFPS = dynamicHighFpsOn == 1 and 30 or normalFPS
  DynamicFPSConfig.Initialize(normalFPS, highFPS, true)
end

function QualitySettingUtil.SetSavePowerSavingMode(isOn)
  QualitySettingUtil.powerSaveMode = isOn and 1 or 0
  Setting:SetInt(SettingKeys.POWER_SAVING_MODE, QualitySettingUtil.powerSaveMode)
  local inLevel = QualitySettingUtil.CurrentGraphicLv
  QualitySettingUtil.SetDynamicFPSConfig(inLevel)
end

function QualitySettingUtil.GetQulity()
  return QualitySettingUtil.CurrentGraphicLv - 1
end

function QualitySettingUtil.TogglePostProcess(toggle)
  if MainCamera == nil then
    MainCamera = CS.UnityEngine.Camera.main
  end
  local cameraStack = MainCamera:GetComponent(typeof(CS.UnityEngine.Rendering.Universal.UniversalAdditionalCameraData))
  cameraStack.renderPostProcessing = toggle
end

function QualitySettingUtil.SaveSetting()
  Setting:Save()
  CS.SceneQualitySetting.ApplySavedGraphicsLevel()
  if CS.SceneManager.World then
    CS.SceneManager.World:ChangeQualitySetting()
  end
  QualitySettingUtil.SetResolutionQuality()
  QualitySettingUtil.SetHDR()
end

function QualitySettingUtil.SetResolutionQuality()
  local renderScale = 1
  if Screen.height > _kPixelHeightMax then
    renderScale = _kPixelHeightMax / Screen.height
  end
end

function QualitySettingUtil.SetHDR()
end

function QualitySettingUtil.SetEnableUpdateTargetFrameRate(isEnable)
  _isEnableUpdateTargetFrameRate = isEnable
  if not isEnable then
    _curTargetFrameRate = _kMiddleQualityTargetFrameRate
    SetTargetFrameRate(_kMiddleQualityTargetFrameRate)
  end
end

function QualitySettingUtil.Update()
  if not _isEnableUpdateTargetFrameRate then
    return
  end
  local combatUnitsCount = 0
  if combatUnitsCount > _combatUnitsThreshhold then
    if _curTargetFrameRate > _kCompareTargetFrameRate then
      _curTargetFrameRate = _kLowTargetFrameRate
      SetTargetFrameRate(_curTargetFrameRate)
    end
  elseif _curTargetFrameRate < _kCompareTargetFrameRate then
    _curTargetFrameRate = _kHighTargetFrameRate
    SetTargetFrameRate(_curTargetFrameRate)
  end
end

return QualitySettingUtil
