local TWModelObj = BaseClass("TWModelObj")
local ResourceManager = CS.GameEntry.Resource
local nodePath = "ModelGo/point/p_drone"
local SimpleAnimation = typeof(CS.SimpleAnimation)

function TWModelObj:__init()
  self.modelObj = nil
end

function TWModelObj:__delete()
  self:DestroyEffect()
  self.bUuid = nil
  self.model = nil
  self.effectParent = nil
  self.appearanceId = nil
end

function TWModelObj:SetData(bUuid, appearanceId, model)
  self.bUuid = bUuid
  if appearanceId then
    if self.appearanceId and appearanceId == self.appearanceId and self.model == model then
      return
    end
    self.appearanceId = appearanceId
    if self.bUuid and self.appearanceId then
      self:InitEffect(model)
    end
  end
end

function TWModelObj:InitEffect(model)
  if not self.appearanceId then
    return
  end
  self:DestroyEffect()
  local cityModel = model
  if IsNull(cityModel) then
    return
  end
  self.effectParent = cityModel.transform:Find(nodePath)
  if IsNull(self.effectParent) then
    return
  end
  self.model = model
  self.effectParent.gameObject:SetActive(true)
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(self.appearanceId)
  local weaponModelPath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "city_model_path")
  if not string.IsNullOrEmpty(weaponModelPath) then
    self:LoadEffect(weaponModelPath)
  else
    self:DestroyEffect()
  end
end

function TWModelObj:LoadEffect(path)
  local res = ResourceManager:InstantiateAsync(path)
  self.modelObj = res
  res:completed("+", function(req)
    if res.isError then
      return
    end
    if res.gameObject then
      local transform = res.gameObject.transform
      transform:SetParent(self.effectParent)
      transform:Set_localPosition(0, 0, 0)
      local simpleAnimation = transform:GetComponentInChildren(SimpleAnimation)
      if not IsNull(simpleAnimation) then
        simpleAnimation:Play("idle")
      end
    end
  end)
end

function TWModelObj:DestroyEffect()
  if self.modelObj then
    self.modelObj:Destroy()
    self.modelObj = nil
  end
end

return TWModelObj
