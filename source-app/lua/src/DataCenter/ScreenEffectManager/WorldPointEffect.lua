local base = require("DataCenter.ScreenEffectManager.ScreenEffectDataBase")
local WorldPointEffect = BaseClass("WorldPointEffect", base)
local ResourceManager = CS.GameEntry.Resource

function WorldPointEffect:__init()
  self.showSceneFilter = ScreenEffectSceneFilter.World
  self.parentType = ScreenEffectParentType.WorldCameraPoint
  self.lodMin = 2
  self.lodMax = 7
  self:OnLodChanged(DataCenter.ScreenEffectManager.curLod or -1)
end

function WorldPointEffect:__delete()
end

function WorldPointEffect:ShowEffect(assetPath, position)
  self.position = position
  if self.prefabPath ~= assetPath then
    self.prefabPath = assetPath
    self:RelaseEffect()
  end
  self:OnSceneChange(self:GetCurScene())
  if self.effectObj then
    local trans = self.effectObj.transform
    local pos = self.position or CS.SceneManager.World.CurTarget
    trans:Set_position(pos.x, pos.y, pos.z)
  end
end

function WorldPointEffect:HideEffect()
  self.prefabPath = nil
  self:RelaseEffect()
end

function WorldPointEffect:LoadEffect()
  self:RelaseEffect()
  if not string.IsNullOrEmpty(self.prefabPath) then
    self.request = ResourceManager:InstantiateAsync(self.prefabPath)
    self.request:completed("+", function()
      if self.request.isError or CS.SceneManager.World == nil then
        return
      end
      self.request.gameObject:SetActive(true)
      local trans = self.request.gameObject.transform
      if self.active then
        if SceneUtils.GetIsInWorld() then
          trans:SetParent(CS.SceneManager.World.DynamicObjNode)
          trans:Set_localScale(1, 1, 1)
          trans:Set_rotation(Quaternion.Euler(0, 0, 0))
          local pos = self.position or CS.SceneManager.World.CurTarget
          trans:Set_position(pos.x, pos.y, pos.z)
          self.effectObj = self.request.gameObject
          self.effectObj:SetActive(true)
        else
          self:RelaseEffect()
        end
      else
        self:RelaseEffect()
      end
      self:LoadEffectFinish()
    end)
  end
end

return WorldPointEffect
