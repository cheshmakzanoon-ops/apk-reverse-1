local SeasonCallbackEffectObj = BaseClass("SeasonCallbackEffectObj")
local ResourceManager = CS.GameEntry.Resource
local nodePath = "ModelGo/Normal"

function SeasonCallbackEffectObj:__init()
  self.effectRes = nil
end

function SeasonCallbackEffectObj:__delete()
  self:DestroyEffect()
  self.bUuid = nil
  self.model = nil
  self.effectParent = nil
  self.effectPath = nil
end

function SeasonCallbackEffectObj:Destroy()
  self:Delete()
end

function SeasonCallbackEffectObj:SetData(bUuid, model, path, offset)
  self.bUuid = bUuid
  if self.effectPath and path == self.effectPath and self.model == model then
    return
  end
  self.effectPath = path
  if self.bUuid then
    self:InitEffect(model, path, offset)
  end
end

function SeasonCallbackEffectObj:InitEffect(model, path, offset)
  if string.IsNullOrEmpty(path) then
    self:DestroyEffect()
    return
  end
  local cityModel = model
  if not cityModel then
    return
  end
  self.effectParent = cityModel.transform:Find(nodePath)
  if IsNull(self.effectParent) then
    return
  end
  local effectParentRoot = self.effectParent:FindChildByName("root")
  if not IsNull(effectParentRoot) then
    self.effectParent = effectParentRoot
  end
  self.model = model
  self.effectParent.gameObject:SetActive(true)
  self:LoadEffect(path, offset)
end

function SeasonCallbackEffectObj:LoadEffect(path, offset)
  self:DestroyEffect()
  local res = ResourceManager:InstantiateAsync(path)
  self.effectRes = res
  res:completed("+", function(req)
    if res.isError then
      return
    end
    if res.gameObject then
      res.gameObject.transform:SetParent(self.effectParent)
      res.gameObject.transform:Reset()
      res.gameObject.transform:Set_localPosition(offset.x, offset.y, offset.z)
    end
  end)
end

function SeasonCallbackEffectObj:DestroyEffect()
  if self.effectRes then
    self.effectRes:Destroy()
    self.effectRes = nil
  end
end

return SeasonCallbackEffectObj
