local ShaderEffectManager = BaseClass("ShaderEffectManager")

function ShaderEffectManager:__init()
  self.material = {}
end

function ShaderEffectManager:__delete()
  self.material = {}
end

function ShaderEffectManager:Startup()
end

function ShaderEffectManager:AddOneWhiteEffect(meshList)
  if meshList ~= nil then
    local param = self:GetMaterialByShaderType(ShaderEffectType.ShakeWhite)
    if param ~= nil then
      for k, v in ipairs(meshList) do
        v:SetPropertyBlock(param.materialOpen)
      end
      TimerManager:GetInstance():DelayInvoke(function()
        for k, v in ipairs(meshList) do
          if v ~= nil then
            v:SetPropertyBlock(param.materialClose)
          end
        end
      end, 0.15)
    end
  end
end

function ShaderEffectManager:GetMaterialByShaderType(shaderType)
  if self.material[shaderType] == nil then
    local param = {}
    if shaderType == ShaderEffectType.ShakeWhite then
      local toggleFlashId = CS.UnityEngine.Shader.PropertyToID("_ToggleFlash")
      param.materialOpen = CS.UnityEngine.MaterialPropertyBlock()
      param.materialOpen:SetFloat(toggleFlashId, 1)
      param.materialClose = CS.UnityEngine.MaterialPropertyBlock()
      param.materialClose:SetFloat(toggleFlashId, 0)
    end
    self.material[shaderType] = param
  end
  return self.material[shaderType]
end

return ShaderEffectManager
