local LWDominatorCityBuilding = BaseClass("LWDominatorCityBuilding")
local ResourceManager = CS.GameEntry.Resource
local nodePath = "ModelGo/point/p_drone"
local SimpleAnimation = typeof(CS.SimpleAnimation)

function LWDominatorCityBuilding:__init()
  self.modelObj = nil
end

function LWDominatorCityBuilding:__delete()
  self:DestroyEffect()
  self.bUuid = nil
  self.model = nil
  self.effectParent = nil
  self.appearanceId = nil
end

function LWDominatorCityBuilding:SetData(bUuid, buildingModel)
  self.bUuid = bUuid
  local appearanceId = DataCenter.DominatorManager:GetCityBuildingShowAppearanceId()
  if appearanceId then
    if self.appearanceId and appearanceId == self.appearanceId and self.buildingModel == buildingModel then
      return
    end
    self.appearanceId = appearanceId
    if self.bUuid and self.appearanceId then
      self:InitEffect(buildingModel)
    end
  end
end

function LWDominatorCityBuilding:InitEffect(buildingModel)
  if not self.appearanceId then
    return
  end
  self:DestroyEffect()
  local cityModel = buildingModel
  if IsNull(cityModel) then
    return
  end
  self.effectParent = cityModel.transform:Find(nodePath)
  if IsNull(self.effectParent) then
    return
  end
  self.model = buildingModel
  self.effectParent.gameObject:SetActive(true)
  local isShowModel = DataCenter.DominatorManager:IsShowCityBuildingDominator()
  if not isShowModel then
  else
    local weaponModelPath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), self.appearanceId, "city_model_path")
    if not string.IsNullOrEmpty(weaponModelPath) then
      self:LoadEffect(weaponModelPath)
    else
    end
  end
end

function LWDominatorCityBuilding:LoadEffect(path)
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
      transform:Set_localRotation(0, 0, 0, 1)
      local simpleAnimation = transform:GetComponentInChildren(SimpleAnimation)
      if not IsNull(simpleAnimation) then
        simpleAnimation:Play("idle")
      end
    end
  end)
end

function LWDominatorCityBuilding:DestroyEffect()
  if self.modelObj then
    self.modelObj:Destroy()
    self.modelObj = nil
  end
end

return LWDominatorCityBuilding
