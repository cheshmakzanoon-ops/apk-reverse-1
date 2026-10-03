local SurfingMiddleSceneInfo = BaseClass("SurfingMiddleSceneInfo")

function SurfingMiddleSceneInfo:__init()
  self.index = 0
  self.num = 0
  self.stageScenes = nil
  self.markIndex = nil
end

function SurfingMiddleSceneInfo:__delete()
  self.index = nil
  self.num = nil
  self.stageScenes = nil
  self.markIndex = nil
end

function SurfingMiddleSceneInfo:InitConfig(index, data)
  if data then
    local arr = string.split(data, ";")
    if arr and 2 <= #arr then
      self.num = tonumber(arr[1])
      local sceneArr = string.split(arr[2], ",")
      local stageScenes = {}
      for _, v in ipairs(sceneArr) do
        table.insert(stageScenes, tonumber(v))
      end
      self.stageScenes = stageScenes
    end
  end
  self.index = index
  self.markIndex = 0
end

function SurfingMiddleSceneInfo:GetMarkIndex()
  return self.markIndex
end

function SurfingMiddleSceneInfo:UpdateMarkIndex()
  if self.markIndex >= self.num then
    self.markIndex = 0
    return false
  end
  self.markIndex = self.markIndex + 1
  return true
end

function SurfingMiddleSceneInfo:CheckIsEnd()
  return self.markIndex >= self.num
end

return SurfingMiddleSceneInfo
