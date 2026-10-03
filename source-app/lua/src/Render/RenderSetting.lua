local RenderSetting = {}
local _scriptableRendererData, _gameQulity
local unitySHParamNames = {
  "_Boyan_SHAr",
  "_Boyan_SHAg",
  "_Boyan_SHAb",
  "_Boyan_SHBr",
  "_Boyan_SHBg",
  "_Boyan_SHBb",
  "_Boyan_SHC"
}

local function ToggleBlur(isToggle)
end

local function InitRender()
  RenderSetting.DumpSphericalHarmonicsL2()
  RenderSetting.SettingFur()
  RenderSetting.ToggleFurRenderFeature(false)
end

local function GetShadowDistance()
  local pipeline = CS.UnityEngine.QualitySettings.renderPipeline
  cast(pipeline, typeof(CS.UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset))
  return pipeline.shadowDistance
end

local function SetShadowDistance(distance)
  local pipeline = CS.UnityEngine.QualitySettings.renderPipeline
  cast(pipeline, typeof(CS.UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset))
  pipeline.shadowDistance = distance
end

local function SettingFur()
  local pipeline = CS.UnityEngine.QualitySettings.renderPipeline
  cast(pipeline, typeof(CS.UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset))
  if pipeline == nil then
    return
  end
  local propertyInfo = pipeline:GetType():GetField("m_RendererDataList", 36)
  if propertyInfo == nil then
    return
  end
  local objs = propertyInfo:GetValue(pipeline)
  if objs == nil then
    return
  end
  for i = 1, objs.Length do
    local scriptableRendererData = objs[i - 1]
    if scriptableRendererData ~= nil then
      cast(scriptableRendererData, typeof(CS.UnityEngine.Rendering.Universal.ScriptableRendererData))
      for i = 0, scriptableRendererData.rendererFeatures.Count - 1 do
        if scriptableRendererData.rendererFeatures[i].name == "NewFurRenderFeature" then
          local featureData = scriptableRendererData.rendererFeatures[i]
          cast(featureData, typeof(CS.FurRenderFeature))
          if _gameQulity < 2 then
            featureData.settings.PassLayerNum = 1
          end
        end
      end
    end
  end
end

local function SettingHeightFog(fogHeight, fogY, color1, color2, fogIntensity)
end

local function ToggleFurRenderFeature(visible)
  local pipeline = CS.UnityEngine.QualitySettings.renderPipeline
  cast(pipeline, typeof(CS.UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset))
  if pipeline == nil then
    return
  end
  local propertyInfo = pipeline:GetType():GetField("m_RendererDataList", 36)
  if propertyInfo == nil then
    return
  end
  local objs = propertyInfo:GetValue(pipeline)
  if objs == nil then
    return
  end
  for i = 1, objs.Length do
    local scriptableRendererData = objs[i - 1]
    if scriptableRendererData ~= nil then
      cast(scriptableRendererData, typeof(CS.UnityEngine.Rendering.Universal.ScriptableRendererData))
      for i = 0, scriptableRendererData.rendererFeatures.Count - 1 do
        if scriptableRendererData.rendererFeatures[i].name == "NewFurRenderFeature" then
          local featureData = scriptableRendererData.rendererFeatures[i]
          featureData:SetActive(visible)
        end
      end
    end
  end
end

local function ToggleCustomDepthRenderFeature(visible)
  local pipeline = CS.UnityEngine.QualitySettings.renderPipeline
  cast(pipeline, typeof(CS.UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset))
  if pipeline == nil then
    return
  end
  local propertyInfo = pipeline:GetType():GetField("m_RendererDataList", 36)
  if propertyInfo == nil then
    return
  end
  local objs = propertyInfo:GetValue(pipeline)
  if objs == nil then
    return
  end
  local isFind = false
  for i = 1, objs.Length do
    local scriptableRendererData = objs[i - 1]
    if scriptableRendererData ~= nil then
      cast(scriptableRendererData, typeof(CS.UnityEngine.Rendering.Universal.ScriptableRendererData))
      for i = 0, scriptableRendererData.rendererFeatures.Count - 1 do
        if scriptableRendererData.rendererFeatures[i].name == "CustomDepthRenderFeature" then
          local featureData = scriptableRendererData.rendererFeatures[i]
          featureData:SetActive(visible)
          isFind = true
        end
      end
    end
  end
  local features = objs[0]
  if not features then
    return
  end
  if not isFind then
    local newFeature = CS.UnityEngine.ScriptableObject.CreateInstance(typeof(CS.CustomDepthRenderFeature))
    newFeature.name = "CustomDepthRenderFeature"
    newFeature:SetActive(visible)
    features = objs[0]
    if features then
      features.rendererFeatures:Add(newFeature)
    end
    newFeature:SetActive(visible)
  end
  features:SetDirty()
end

local function SetHeightFogVisible(visible)
end

local function DumpSphericalHarmonicsL2()
  Logger.Log("SH9 Init")
  local _Boyan_SHAb = CS.UnityEngine.Vector4.New(-0.002500065, 0.1566966, 0.2403159, 0.2535352)
  local _Boyan_SHAg = CS.UnityEngine.Vector4.New(-7.448478E-4, 0.1495781, 0.2342949, 0.259032)
  local _Boyan_SHAr = CS.UnityEngine.Vector4.New(-6.305838E-4, 0.1381056, 0.2189651, 0.2619695)
  local _Boyan_SHBb = CS.UnityEngine.Vector4.New(9.808665E-4, 0.1244143, 0.1215409, 0.007772579)
  local _Boyan_SHBg = CS.UnityEngine.Vector4.New(0.002275236, 0.1206006, 0.1166272, 0.01075001)
  local _Boyan_SHBr = CS.UnityEngine.Vector4.New(0.003193089, 0.1160733, 0.1080668, 0.01155533)
  local _Boyan_SHC = CS.UnityEngine.Vector4.New(0.0118142, 0.01242505, 0.01204208, 1)
  CS.UnityEngine.Shader.SetGlobalVector(unitySHParamNames[1], _Boyan_SHAr)
  CS.UnityEngine.Shader.SetGlobalVector(unitySHParamNames[2], _Boyan_SHAg)
  CS.UnityEngine.Shader.SetGlobalVector(unitySHParamNames[3], _Boyan_SHAb)
  CS.UnityEngine.Shader.SetGlobalVector(unitySHParamNames[4], _Boyan_SHBr)
  CS.UnityEngine.Shader.SetGlobalVector(unitySHParamNames[5], _Boyan_SHBg)
  CS.UnityEngine.Shader.SetGlobalVector(unitySHParamNames[6], _Boyan_SHBb)
  CS.UnityEngine.Shader.SetGlobalVector(unitySHParamNames[7], _Boyan_SHC)
  Logger.Log("SH9 Init Finish")
end

local function SetHDR(enable)
  local pipeline = CS.UnityEngine.QualitySettings.renderPipeline
  cast(pipeline, typeof(CS.UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset))
  pipeline.supportsHDR = enable
end

RenderSetting.InitRender = InitRender
RenderSetting.ToggleBlur = ToggleBlur
RenderSetting.SetShadowDistance = SetShadowDistance
RenderSetting.GetShadowDistance = GetShadowDistance
RenderSetting.DumpSphericalHarmonicsL2 = DumpSphericalHarmonicsL2
RenderSetting.SetHDR = SetHDR
RenderSetting.SettingHeightFog = SettingHeightFog
RenderSetting.SetHeightFogVisible = SetHeightFogVisible
RenderSetting.SettingFur = SettingFur
RenderSetting.ToggleFurRenderFeature = ToggleFurRenderFeature
RenderSetting.ToggleCustomDepthRenderFeature = ToggleCustomDepthRenderFeature
return RenderSetting
