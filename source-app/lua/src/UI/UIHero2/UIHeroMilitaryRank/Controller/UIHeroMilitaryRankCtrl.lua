local UIHeroMilitaryRankCtrl = BaseClass("UIHeroMilitaryRankCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroMilitaryRank)
end

local function ToggleBlurFeature(self, t)
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
      print(scriptableRendererData.rendererFeatures.Count)
      for i = 0, scriptableRendererData.rendererFeatures.Count - 1 do
        if scriptableRendererData.rendererFeatures[i].name == "GaussianBlurRenderPassFeature" then
          scriptableRendererData.rendererFeatures[i]:SetActive(t)
        end
      end
    end
  end
end

UIHeroMilitaryRankCtrl.CloseSelf = CloseSelf
UIHeroMilitaryRankCtrl.ToggleBlurFeature = ToggleBlurFeature
return UIHeroMilitaryRankCtrl
