local BuildEffectObj = BaseClass("BuildEffectObj")
local ResourceManager = CS.GameEntry.Resource
local effectPath = "Assets/Main/Prefabs/BuildEffect/MainBuild/%s.prefab"
local nodePath = "ModelGo/Normal"

function BuildEffectObj:__init()
  self.effectRes = nil
end

function BuildEffectObj:__delete()
  self:DestroyEffect()
  self.bUuid = nil
  self.model = nil
  self.worldPoint = nil
  self.effectParent = nil
  self.info = nil
end

function BuildEffectObj:SetData(bUuid, info, model, worldPoint)
  self.bUuid = bUuid
  if info then
    if self.info and info.effectId == self.info.effectId and self.model == model then
      return
    end
    self.info = info
    if self.bUuid and self.info then
      self:InitEffect(model, worldPoint)
    end
  end
end

function BuildEffectObj:InitEffect(model, worldPoint)
  if not self.info and not self.info.effectId then
    return
  end
  if self.info.effectId == 0 then
    self:DestroyEffect()
  end
  local cityModel = model
  if IsNull(cityModel) then
    return
  end
  self.effectParent = cityModel.transform:Find(nodePath)
  if IsNull(self.effectParent) then
    return
  end
  self.model = model
  self.worldPoint = worldPoint
  self.effectParent.gameObject:SetActive(true)
  local template = DataCenter.DecorationTemplateManager:GetTemplate(self.info.effectId)
  if template then
    local path = SceneUtils.GetIsInWorld() and template.model_world or template.model
    if string.IsNullOrEmpty(path) then
      if self.effectRes then
        self:DestroyEffect()
      end
      return
    end
    path = string.format(effectPath, path)
    self:LoadEffect(path)
  end
end

function BuildEffectObj:LoadEffect(path)
  self:DestroyEffect()
  local res = ResourceManager:InstantiateAsync(path)
  self.effectRes = res
  res:completed("+", function(req)
    if res.isError then
      return
    end
    if res.gameObject then
      res.gameObject.transform:SetParent(self.effectParent)
      res.gameObject.transform:Set_localPosition(0, 0, 0)
      res.gameObject.transform:Set_localScale(1, 1, 1)
      if self.worldPoint and self.worldPoint.AutoAdjustLod then
        self.worldPoint.AutoAdjustLod:AppendLod(res.gameObject, "1-2")
        self.dynamicAppended = self.worldPoint.AutoAdjustLod
      end
    end
  end)
end

function BuildEffectObj:DestroyEffect()
  if not IsNull(self.dynamicAppended) then
    self.dynamicAppended:ClearAllAppend()
  end
  if not IsNull(self.effectRes) then
    self.effectRes:Destroy()
  end
  self.dynamicAppended = nil
  self.effectRes = nil
end

return BuildEffectObj
