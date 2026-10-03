local RTUtils = {}

local function FormatListToString(list)
  if list == nil then
    return "nil"
  end
  local parts = {}
  for i = 1, #list do
    parts[#parts + 1] = tostring(list[i])
  end
  return table.concat(parts, ",")
end

function RTUtils.GetDefaultRenderTextureParam()
  local param = {}
  local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
  local Screen = CS.UnityEngine.Screen
  param.rtWidth = DefaultScreenWidth
  param.rtHeight = math.floor(DefaultScreenWidth * (Screen.height / Screen.width))
  param.rtFormat = RenderTextureFormat.ARGB32
  param.rtDepthBuffer = 24
  return param
end

function RTUtils.GetTemporaryWithFallback(rtWidth, rtHeight, rtDepthBuffer, formats)
  local RenderTexture = CS.UnityEngine.RenderTexture
  local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
  local depth = rtDepthBuffer or 24
  local tryFormats = formats
  if tryFormats == nil then
    if GameQualitySettings ~= nil and GameQualitySettings.GetTemporaryRTFormats ~= nil then
      tryFormats = GameQualitySettings.GetTemporaryRTFormats()
    else
      tryFormats = {
        RenderTextureFormat.ARGB32
      }
    end
  end
  
  local function TryGet(fmt)
    local rt = RenderTexture.GetTemporary(rtWidth, rtHeight, depth, fmt)
    if IsNull(rt) then
      return nil
    end
    if not rt:IsCreated() and not rt:Create() then
      RenderTexture.ReleaseTemporary(rt)
      return nil
    end
    return rt
  end
  
  for i = 1, #tryFormats do
    local fmt = tryFormats[i]
    local rt = TryGet(fmt)
    if rt ~= nil then
      return rt, fmt
    end
  end
  return nil, nil
end

return RTUtils
