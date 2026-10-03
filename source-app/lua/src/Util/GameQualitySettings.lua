local DisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
local QualitySettingUtil = require("Util.QualitySettingUtil")
local GameSetting = CS.GameEntry.Setting
local GameLODManager = CS.GameEntry.LOD
local QualitySettings = CS.UnityEngine.QualitySettings
GameQualitySettings = {}
local _inited = false
local _quality_level = EGameQuality.Unknown
local _EGameQualityConfig = EGameQualityConfig
local _EGameDeviceQualityConfig = EGameDeviceQualityConfig
local _debug_lod_effect_strategy

function GameQualitySettings.Init()
  if _inited then
    return
  end
  _inited = true
  DisplaySettings.Init()
  GameQualitySettings.SetQualityByConfigLevel(GameQualitySettings.GetDefaultConfigLevel())
  local saving_power = GameQualitySettings.IsPowerSavingMode()
  GameQualitySettings.EnablePowerSavingMode(saving_power)
  Logger.Log("GameQualitySettings.Init: " .. GameQualitySettings.GetQuality())
end

function GameQualitySettings.Uninit()
  if not _inited then
    return
  end
  _inited = false
  DisplaySettings.UnInit()
end

function GameQualitySettings.ForceUseNewQualitySettings()
  if _inited then
    GameQualitySettings.Uninit()
  end
  _EGameQualityConfig = EGameQualityConfig
  _EGameDeviceQualityConfig = EGameDeviceQualityConfig
  GameSetting:SetInt(SettingKeys.SCENE_GRAPHIC_LEVEL, -1)
  GameSetting:SetInt(SettingKeys.GAME_QUALITY_CONFIG_LEVEL_KEY, -1)
  GameQualitySettings.Init()
end

function GameQualitySettings.GetDefaultConfigLevel()
  local quality_config_level = GameQualitySettings.Old_TranslateFromGraphicLevel()
  if quality_config_level ~= nil then
    return GameQualitySettings.ValidateConfigLevel(quality_config_level)
  end
  quality_config_level = GameSetting:GetInt(SettingKeys.GAME_QUALITY_CONFIG_LEVEL_KEY, -1)
  return GameQualitySettings.ValidateConfigLevel(quality_config_level)
end

function GameQualitySettings.ValidateConfigLevel(quality_config_level)
  local device_config = GameQualitySettings.GetDeviceConfig()
  if quality_config_level ~= nil and quality_config_level ~= -1 then
    local level = GameQualitySettings.GetQuality(quality_config_level)
    if level == nil then
      if quality_config_level > device_config[EGameQuality.Mid] then
        quality_config_level = device_config[EGameQuality.High]
      elseif quality_config_level > device_config[EGameQuality.Low] then
        quality_config_level = device_config[EGameQuality.Mid]
      else
        quality_config_level = device_config[EGameQuality.Low]
      end
    end
    return quality_config_level
  end
  return device_config[EGameQuality.Default]
end

function GameQualitySettings.GetDeviceLevel()
  return CS.GameEntry.Sdk.runtimeInfo:GetDeviceLevel():ToInt()
end

function GameQualitySettings.GetDeviceConfig()
  local device_level = GameQualitySettings.GetDeviceLevel()
  local device_config = _EGameDeviceQualityConfig[device_level]
  if device_config == nil then
    return _EGameDeviceQualityConfig[EDeviceLevel.Mid]
  end
  return device_config
end

function GameQualitySettings.GetQuality(level)
  local ori_level = level
  level = level or _quality_level
  local device_config = GameQualitySettings.GetDeviceConfig()
  if level == device_config[EGameQuality.Low] then
    return EGameQuality.Low
  elseif level == device_config[EGameQuality.High] then
    return EGameQuality.High
  elseif level == device_config[EGameQuality.Mid] then
    return EGameQuality.Mid
  elseif ori_level == nil then
    Logger.LogError("GameQualitySettings.GetQuality: level not match. level:" .. tostring(level))
    return EGameQuality.Mid
  else
    return nil
  end
end

function GameQualitySettings.Old_TranslateFromGraphicLevel()
  local graphic_level = GameSetting:GetInt(SettingKeys.SCENE_GRAPHIC_LEVEL, -1)
  if graphic_level < 0 then
    return nil
  end
  _EGameQualityConfig = EGameQualityConfig_V1
  _EGameDeviceQualityConfig = EGameDeviceQualityConfig_V1
  local new_level = _EGameQualityConfig.DefaultLevel
  if graphic_level == EnumQualityLevel.Low then
    new_level = _EGameQualityConfig.Low
  elseif graphic_level == EnumQualityLevel.Middle then
    new_level = _EGameQualityConfig.Mid
  elseif graphic_level == EnumQualityLevel.High then
    new_level = _EGameQualityConfig.High
  end
  return new_level
end

function GameQualitySettings.HasOldGraphicLevel()
  local graphic_level = GameSetting:GetInt(SettingKeys.SCENE_GRAPHIC_LEVEL, -1)
  return 0 <= graphic_level
end

function GameQualitySettings.SetBasicQuality(quality)
  if Config.IsPC() then
    GameLODManager:ConfigureLODRange(0, 1)
    if quality == EGameFeatureQuality.UltraLow then
      QualitySettings.SetQualityLevel(0)
    elseif quality == EGameFeatureQuality.Low then
      QualitySettings.SetQualityLevel(1)
    elseif quality == EGameFeatureQuality.Mid then
      QualitySettings.SetQualityLevel(1)
    elseif quality == EGameFeatureQuality.High then
      QualitySettings.SetQualityLevel(2)
    elseif quality == EGameFeatureQuality.UltraHigh then
      QualitySettings.SetQualityLevel(2)
    end
  elseif quality == EGameFeatureQuality.UltraLow then
    QualitySettings.SetQualityLevel(0)
    QualitySettings.renderPipeline.minRenderResolution = 560
    QualitySettings.renderPipeline.maxRenderResolution = 560
    GameLODManager:ConfigureLODRange(0, 3)
  elseif quality == EGameFeatureQuality.Low then
    QualitySettings.SetQualityLevel(0)
    QualitySettings.renderPipeline.minRenderResolution = 640
    QualitySettings.renderPipeline.maxRenderResolution = 640
    GameLODManager:ConfigureLODRange(0, 3)
  elseif quality == EGameFeatureQuality.Mid then
    QualitySettings.SetQualityLevel(1)
    QualitySettings.renderPipeline.minRenderResolution = 720
    QualitySettings.renderPipeline.maxRenderResolution = 720
    GameLODManager:ConfigureLODRange(0, 3)
  elseif quality == EGameFeatureQuality.High then
    QualitySettings.SetQualityLevel(2)
    QualitySettings.renderPipeline.minRenderResolution = 800
    QualitySettings.renderPipeline.maxRenderResolution = 800
    GameLODManager:ConfigureLODRange(0, 2)
  elseif quality == EGameFeatureQuality.UltraHigh then
    QualitySettings.SetQualityLevel(2)
    QualitySettings.renderPipeline.minRenderResolution = 1080
    QualitySettings.renderPipeline.maxRenderResolution = 1080
    GameLODManager:ConfigureLODRange(0, 2)
  end
  QualitySettings.renderPipeline.supportsDynamicBatching = true
end

function GameQualitySettings.SetAAQuality(quality)
  if quality == EGameFeatureQuality.UltraLow then
    QualitySettings.renderPipeline.msaaSampleCount = 1
    QualitySettings.renderPipeline.antialiasingMode = CS.UnityEngine.Rendering.Universal.AntialiasingMode.None
  elseif quality == EGameFeatureQuality.Low then
    QualitySettings.renderPipeline.msaaSampleCount = 1
    QualitySettings.renderPipeline.antialiasingMode = CS.UnityEngine.Rendering.Universal.AntialiasingMode.FastApproximateAntialiasing
  elseif quality == EGameFeatureQuality.Mid then
    QualitySettings.renderPipeline.msaaSampleCount = 1
    QualitySettings.renderPipeline.antialiasingMode = CS.UnityEngine.Rendering.Universal.AntialiasingMode.FastApproximateAntialiasing
  elseif quality == EGameFeatureQuality.High then
    QualitySettings.renderPipeline.msaaSampleCount = 2
    QualitySettings.renderPipeline.antialiasingMode = CS.UnityEngine.Rendering.Universal.AntialiasingMode.FastApproximateAntialiasing
  elseif quality == EGameFeatureQuality.UltraHigh then
    QualitySettings.renderPipeline.msaaSampleCount = 4
    QualitySettings.renderPipeline.antialiasingMode = CS.UnityEngine.Rendering.Universal.AntialiasingMode.FastApproximateAntialiasing
  end
end

function GameQualitySettings.SetShadowAndOutlineQuality(quality)
  local enable_shadow = false
  local enable_outline = false
  if quality == EGameFeatureQuality.UltraLow then
    enable_shadow = false
    enable_outline = false
  elseif quality == EGameFeatureQuality.Low then
    enable_shadow = false
    enable_outline = false
  elseif quality == EGameFeatureQuality.Mid then
    enable_shadow = true
    enable_outline = false
  elseif quality == EGameFeatureQuality.High then
    enable_shadow = true
    enable_outline = true
  elseif quality == EGameFeatureQuality.UltraHigh then
    enable_shadow = true
    enable_outline = true
  end
  local renderer_features = QualitySettings.renderPipeline.scriptableRenderer.rendererFeatures
  for _, feature in pairs(renderer_features) do
    local lower_name = string.lower(feature.name)
    if not string.endswith(lower_name, "deprecated") then
      if string.contains(lower_name, "shadow") then
        feature:SetActive(enable_shadow)
      elseif string.contains(lower_name, "outline") then
        feature:SetActive(enable_outline)
      end
    end
  end
  CS.ShadowLODComponent.EnableShadow(enable_shadow)
end

function GameQualitySettings.SetMaterialQuality(quality)
  if quality == EGameFeatureQuality.UltraLow then
    if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
      CS.UnityEngine.Shader.DisableKeyword(CS.GameDefines.ShaderLODHigh)
    else
      CS.UnityEngine.Shader.EnableKeyword(CS.GameDefines.ShaderLODHigh)
    end
  elseif quality == EGameFeatureQuality.Low then
    CS.UnityEngine.Shader.EnableKeyword(CS.GameDefines.ShaderLODHigh)
  elseif quality == EGameFeatureQuality.Mid then
    CS.UnityEngine.Shader.EnableKeyword(CS.GameDefines.ShaderLODHigh)
  elseif quality == EGameFeatureQuality.High then
    CS.UnityEngine.Shader.EnableKeyword(CS.GameDefines.ShaderLODHigh)
  elseif quality == EGameFeatureQuality.UltraHigh then
    CS.UnityEngine.Shader.EnableKeyword(CS.GameDefines.ShaderLODHigh)
  end
end

local _PostProcess = {}
_PostProcess.Low = {
  [EnumQualitySetting.PostProcess_Bloom] = EnumQualityLevel.Off,
  [EnumQualitySetting.PostProcess_ColorAdjustments] = EnumQualityLevel.Off,
  [EnumQualitySetting.PostProcess_Vignette] = EnumQualityLevel.Off,
  [EnumQualitySetting.PostProcess_Tonemapping] = EnumQualityLevel.Off,
  [EnumQualitySetting.PostProcess_LiftGammaGain] = EnumQualityLevel.Off,
  [EnumQualitySetting.PostProcess_DepthOfField] = EnumQualityLevel.Off
}
_PostProcess.Middle = {
  [EnumQualitySetting.PostProcess_Bloom] = EnumQualityLevel.Off,
  [EnumQualitySetting.PostProcess_ColorAdjustments] = EnumQualityLevel.High,
  [EnumQualitySetting.PostProcess_Vignette] = EnumQualityLevel.Off,
  [EnumQualitySetting.PostProcess_Tonemapping] = EnumQualityLevel.Off,
  [EnumQualitySetting.PostProcess_LiftGammaGain] = EnumQualityLevel.Off,
  [EnumQualitySetting.PostProcess_DepthOfField] = EnumQualityLevel.Off
}
_PostProcess.High = {
  [EnumQualitySetting.PostProcess_Bloom] = EnumQualityLevel.High,
  [EnumQualitySetting.PostProcess_ColorAdjustments] = EnumQualityLevel.High,
  [EnumQualitySetting.PostProcess_Vignette] = EnumQualityLevel.High,
  [EnumQualitySetting.PostProcess_Tonemapping] = EnumQualityLevel.High,
  [EnumQualitySetting.PostProcess_LiftGammaGain] = EnumQualityLevel.High,
  [EnumQualitySetting.PostProcess_DepthOfField] = EnumQualityLevel.High
}

function GameQualitySettings.SetPostProcessQuality(quality)
  local setting_group
  if quality == EGameFeatureQuality.UltraLow then
    setting_group = _PostProcess.Low
  elseif quality == EGameFeatureQuality.Low then
    setting_group = _PostProcess.Low
  elseif quality == EGameFeatureQuality.Mid then
    setting_group = _PostProcess.Middle
  elseif quality == EGameFeatureQuality.High then
    setting_group = _PostProcess.High
  elseif quality == EGameFeatureQuality.UltraHigh then
    setting_group = _PostProcess.High
  end
  for k, v in pairs(setting_group) do
    GameSetting:SetInt(k, v)
  end
end

function GameQualitySettings.SetTerrainQuality(quality)
  if Config.IsPC() then
    quality = EGameFeatureQuality.UltraHigh
  end
  if quality == EGameFeatureQuality.UltraLow then
    GameSetting:SetInt(EnumQualitySetting.Terrain, EnumQualityLevel.Low)
  elseif quality == EGameFeatureQuality.Low then
    GameSetting:SetInt(EnumQualitySetting.Terrain, EnumQualityLevel.Low)
  elseif quality == EGameFeatureQuality.Mid then
    GameSetting:SetInt(EnumQualitySetting.Terrain, EnumQualityLevel.Middle)
  elseif quality == EGameFeatureQuality.High then
    GameSetting:SetInt(EnumQualitySetting.Terrain, EnumQualityLevel.High)
  elseif quality == EGameFeatureQuality.UltraHigh then
    GameSetting:SetInt(EnumQualitySetting.Terrain, EnumQualityLevel.High)
  end
end

function GameQualitySettings.SetLogicQuality(quality)
  if Config.IsPC() then
    quality = EGameFeatureQuality.UltraHigh
  end
  local smart_troop_line_threshold = 10
  local troop_thresholds = {
    10,
    40,
    60,
    100
  }
  if quality == EGameFeatureQuality.UltraLow then
    smart_troop_line_threshold = 100
    troop_thresholds = {
      6,
      20,
      50,
      100
    }
  elseif quality == EGameFeatureQuality.Low then
    smart_troop_line_threshold = 100
    troop_thresholds = {
      8,
      25,
      50,
      100
    }
  elseif quality == EGameFeatureQuality.Mid then
    smart_troop_line_threshold = 200
    troop_thresholds = {
      10,
      40,
      60,
      100
    }
  elseif quality == EGameFeatureQuality.High then
    smart_troop_line_threshold = 300
    troop_thresholds = {
      15,
      50,
      80,
      120
    }
  elseif quality == EGameFeatureQuality.UltraHigh then
    smart_troop_line_threshold = 300
    troop_thresholds = {
      20,
      50,
      100,
      150
    }
  end
  DisplaySettings.ConfigureAdjustmentThresholds(troop_thresholds, smart_troop_line_threshold)
end

function GameQualitySettings.SetParticleQuality(quality)
  local buildThresholds = {
    30,
    50,
    70
  }
  local commonCostThresholds = {}
  local commonCountThresholds = {}
  local troopCostThresholds = {}
  local troopCountThresholds = {}
  if quality == EGameFeatureQuality.UltraLow then
    buildThresholds = {
      20,
      35,
      50
    }
    commonCostThresholds = {
      100,
      200,
      300
    }
    commonCountThresholds = {
      10,
      20,
      30
    }
    troopCostThresholds = {
      50,
      100,
      150,
      200
    }
    troopCountThresholds = {
      5,
      10,
      15,
      20
    }
  elseif quality == EGameFeatureQuality.Low then
    buildThresholds = {
      25,
      43,
      60
    }
    commonCostThresholds = {
      150,
      250,
      400
    }
    commonCountThresholds = {
      15,
      25,
      40
    }
    troopCostThresholds = {
      80,
      120,
      200,
      250
    }
    troopCountThresholds = {
      8,
      12,
      20,
      25
    }
  elseif quality == EGameFeatureQuality.Mid then
    buildThresholds = {
      30,
      50,
      70
    }
    commonCostThresholds = {
      200,
      350,
      500
    }
    commonCountThresholds = {
      20,
      35,
      50
    }
    troopCostThresholds = {
      100,
      150,
      250,
      300
    }
    troopCountThresholds = {
      10,
      15,
      25,
      30
    }
  elseif quality == EGameFeatureQuality.High then
    buildThresholds = {
      35,
      57,
      80
    }
    commonCostThresholds = {
      250,
      400,
      550
    }
    commonCountThresholds = {
      25,
      40,
      55
    }
    troopCostThresholds = {
      150,
      250,
      400
    }
    troopCountThresholds = {
      15,
      25,
      40
    }
  elseif quality == EGameFeatureQuality.UltraHigh then
    buildThresholds = {
      40,
      65,
      90
    }
    commonCostThresholds = {
      300,
      450,
      600
    }
    commonCountThresholds = {
      30,
      45,
      60
    }
    troopCostThresholds = {
      200,
      300,
      500
    }
    troopCountThresholds = {
      20,
      30,
      50
    }
  end
  GameLODManager:ConfigureEffectLOD(buildThresholds)
  GameLODManager:ConfigureEffectWorldCommonLOD(commonCostThresholds, commonCountThresholds)
  GameLODManager:ConfigureEffectWorldTroopLOD(troopCostThresholds, troopCountThresholds)
end

function GameQualitySettings.SetAnimationQuality(quality)
  local deviceLevel = GameQualitySettings.GetDeviceLevel()
  if deviceLevel and 3 <= deviceLevel then
    CS.GPUSkinnedMeshRenderer.crossFadeEnabled = true
    CS.GPUSkinnedMeshRenderer.crossFadeInterruptEnabled = true
  else
    CS.GPUSkinnedMeshRenderer.crossFadeEnabled = true
    CS.GPUSkinnedMeshRenderer.crossFadeInterruptEnabled = false
  end
end

function GameQualitySettings.SetQuality(quality)
  local device_config = GameQualitySettings.GetDeviceConfig()
  local quality_level = device_config[quality]
  GameQualitySettings.SetQualityByConfigLevel(quality_level)
end

function GameQualitySettings.GetQualityByConfigLevel()
  return _quality_level
end

function GameQualitySettings.SetQualityByConfigLevel(quality_level)
  if _quality_level == quality_level then
    return
  end
  local quality_config = _EGameQualityConfig[quality_level]
  if quality_config == nil then
    Logger.LogError("GameQualitySettings.SetQualityByConfigLevel: quality_config is nil. quality_level:" .. quality_level)
    quality_config = _EGameQualityConfig.Default
  end
  GameQualitySettings.SetBasicQuality(quality_config.Basic)
  GameQualitySettings.SetAAQuality(quality_config.AA)
  GameQualitySettings.SetShadowAndOutlineQuality(quality_config.Shadow)
  GameQualitySettings.SetMaterialQuality(quality_config.Material)
  GameQualitySettings.SetPostProcessQuality(quality_config.PostProcess)
  GameQualitySettings.SetTerrainQuality(quality_config.Terrain)
  GameQualitySettings.SetParticleQuality(quality_config.Particle)
  GameQualitySettings.SetAnimationQuality(quality_config.Animation)
  GameQualitySettings.SetLogicQuality(quality_config.Logic)
  GameQualitySettings.ApplyQuality(quality_level)
end

function GameQualitySettings.IsPowerSavingMode()
  return GameQualitySettings.EnablePowerSavingMode()
end

function GameQualitySettings.IsHighGearQuality()
  return _quality_level >= _EGameQualityConfig.High
end

function GameQualitySettings.IsMidGearQuality()
  return _quality_level < _EGameQualityConfig.High and _quality_level > _EGameQualityConfig.Low
end

function GameQualitySettings.IsLowGearQuality()
  return _quality_level <= _EGameQualityConfig.Low
end

function GameQualitySettings.EnablePowerSavingMode(enable)
  if enable == nil then
    enable = GameSetting:GetInt(SettingKeys.GAME_QUALITY_CONFIG_POWER_SAVING_KEY, 0)
    return enable == 1
  end
  if Config.IsPC() then
    QualitySettings.vSyncCount = 1
    CS.UnityEngine.Application.targetFrameRate = 60
  else
    local normal_fps = enable and 30 or 60
    local high_fps = normal_fps
    local dynamic_high_fps_on = LuaEntry.DataConfig:TryGetNum("dynamic_high_fps_on", "k1")
    normal_fps = dynamic_high_fps_on == 1 and 30 or normal_fps
    CS.DynamicFPSConfig.Initialize(normal_fps, high_fps, true)
  end
  GameSetting:SetInt(SettingKeys.GAME_QUALITY_CONFIG_POWER_SAVING_KEY, enable and 1 or 0)
  GameSetting:Save()
end

function GameQualitySettings.ApplyQuality(level)
  CS.SceneQualitySetting.TryChangeFeatureToGpuSkinCompatable()
  _quality_level = level
  GameSetting:SetInt(SettingKeys.GAME_QUALITY_CONFIG_LEVEL_KEY, _quality_level)
  GameSetting:Save()
  EventManager:GetInstance():Broadcast(EventId.GameQualityLevelChanged, level)
  GameQualitySettings.Old_ApplyLogic()
end

function GameQualitySettings.TogglePostProcess(toggle)
  local main_camera = CS.UnityEngine.Camera.main
  local cameraStack = main_camera:GetComponent(typeof(CS.UnityEngine.Rendering.Universal.UniversalAdditionalCameraData))
  cameraStack.renderPostProcessing = toggle
end

function GameQualitySettings.Old_ApplyLogic()
  if CS.SceneManager.World then
    CS.SceneManager.World:ChangeQualitySetting()
  end
  if _quality_level >= _EGameQualityConfig.High then
    QualitySettingUtil.CurrentGraphicLv = EnumQualityLevel.High
  elseif _quality_level <= _EGameQualityConfig.Low then
    QualitySettingUtil.CurrentGraphicLv = EnumQualityLevel.Low
  else
    QualitySettingUtil.CurrentGraphicLv = EnumQualityLevel.Middle
  end
  local old_quality = GameSetting:GetInt(SettingKeys.SCENE_GRAPHIC_LEVEL, -1)
  if old_quality ~= -1 then
    GameSetting:SetInt(SettingKeys.SCENE_GRAPHIC_LEVEL, QualitySettingUtil.CurrentGraphicLv)
  end
  DisplaySettings.GraphicLevelLimit = nil
end

function GameQualitySettings.GMToggleLod(lv)
  if type(lv) ~= "number" then
    lv = nil
  end
  GameLODManager:ConfigureLODRange(0, 3)
  if _debug_lod_effect_strategy == nil or lv ~= nil then
    CS.SceneLODManager.Instance:ClearStrategies(CS.LODType.Effect)
    _debug_lod_effect_strategy = CS.DebugLODStrategy()
    CS.SceneLODManager.Instance:AddStrategy(CS.LODType.Effect, _debug_lod_effect_strategy)
    _debug_lod_effect_strategy.lod = lv or 0
  elseif _debug_lod_effect_strategy.lod == 0 then
    _debug_lod_effect_strategy.lod = 1
  elseif _debug_lod_effect_strategy.lod == 1 then
    _debug_lod_effect_strategy.lod = 2
  elseif _debug_lod_effect_strategy.lod == 2 then
    _debug_lod_effect_strategy.lod = 3
  elseif _debug_lod_effect_strategy.lod == 3 then
    _debug_lod_effect_strategy = nil
    CS.SceneLODManager.Instance:ClearStrategies(CS.LODType.Effect)
    CS.GameEntry.LOD:InitializeEffectLOD()
  end
  if _debug_lod_effect_strategy == nil then
    return -1, "LA"
  else
    return _debug_lod_effect_strategy.lod, "L" .. _debug_lod_effect_strategy.lod
  end
end

function GameQualitySettings.IsShowShadow()
  local quality_config = _EGameQualityConfig[_quality_level]
  if quality_config ~= nil then
    local shadowCfg = quality_config.Shadow
    return shadowCfg >= EGameFeatureQuality.Mid
  end
  return false
end

function GameQualitySettings.GetTemporaryRTFormats()
  local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
  local ql = GameQualitySettings.GetDeviceLevel() or 0
  local heroRtEnabled = LuaEntry.DataConfig:CheckSwitch("hero_rt")
  if 3 <= ql and heroRtEnabled then
    return {
      RenderTextureFormat.ARGBHalf,
      RenderTextureFormat.ARGB32
    }
  end
  return {
    RenderTextureFormat.ARGB32
  }
end

if not CS.GrayUtils.isGM and not CS.CommonUtils.IsDebug() and not CS.ClientSwitch.IsCacheOn(CS.ClientSwitch.ENABLE_NEW_GRAPHIC_LEVEL) then
  function GameQualitySettings.Init()
    QualitySettingUtil.Init()
  end
  
  function GameQualitySettings.Uninit()
    QualitySettingUtil.Uninit()
  end
  
  function GameQualitySettings.GetQuality()
    return QualitySettingUtil.GetCurrentGraphicLevel()
  end
  
  function GameQualitySettings.SetQuality(quality)
    QualitySettingUtil.SetSettingGroup(quality)
  end
  
  function GameQualitySettings.GetDeviceLevel()
    return QualitySettingUtil.GetRecommendLevel()
  end
  
  function GameQualitySettings.GetQualityByConfigLevel()
    return QualitySettingUtil.GetCurrentGraphicLevel()
  end
  
  function GameQualitySettings.EnablePowerSavingMode(enable)
    if enable == nil then
      return QualitySettingUtil.IsSavePowerSavingMode()
    end
    QualitySettingUtil.SetSavePowerSavingMode(enable)
  end
  
  function GameQualitySettings.IsPowerSavingMode()
    QualitySettingUtil.powerSaveMode = Setting:GetInt(SettingKeys.POWER_SAVING_MODE, 0)
    return QualitySettingUtil.powerSaveMode > 0
  end
  
  function GameQualitySettings.IsHighGearQuality()
    return QualitySettingUtil.CurrentGraphicLv == EnumQualityLevel.High
  end
  
  function GameQualitySettings.IsMidGearQuality()
    return QualitySettingUtil.CurrentGraphicLv == EnumQualityLevel.Middle
  end
  
  function GameQualitySettings.IsLowGearQuality()
    return QualitySettingUtil.CurrentGraphicLv == EnumQualityLevel.Low
  end
end
return GameQualitySettings
