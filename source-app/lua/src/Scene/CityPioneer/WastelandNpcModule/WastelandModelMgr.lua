local WastelandModelMgr = BaseClass("WastelandModelMgr", Singleton)
local ModelTank = require("Scene.CityPioneer.WastelandNpcModule.WastelandTankObj")
local ModelMonster = require("Scene.CityPioneer.WastelandNpcModule.WastelandMonsterObj")
local ModelType = {TANK = 1, MONSTER = 2}

function WastelandModelMgr:__init()
  self.m_modelList = {}
  self.m_roundIdx = 0
  self:AddTimer()
end

function WastelandModelMgr:Destroy()
  self:RemoveAllModel()
  self:RemoveTimer()
end

function WastelandModelMgr:GetRoundIdx()
  return self.m_roundIdx
end

function WastelandModelMgr:AddToCache(modelType, pos)
  if self.m_cacheData == nil then
    self.m_cacheData = {}
  end
  if modelType == ModelType.TANK then
    self.m_cacheData[tostring(modelType)] = pos
  elseif modelType == ModelType.MONSTER then
    self.m_cacheData[tostring(modelType)] = pos
  end
end

function WastelandModelMgr:AddTimer()
  if self.m_updateTimer == nil then
    function self.m_updateTimer()
      self:OnUpdate()
    end
  end
  UpdateManager:GetInstance():AddUpdate(self.m_updateTimer)
end

function WastelandModelMgr:RemoveTimer()
  UpdateManager:GetInstance():RemoveUpdate(self.m_updateTimer)
end

function WastelandModelMgr:CreateTank(strPos, triggerId)
  if string.IsNullOrEmpty(strPos) then
    return
  end
  self:AddToCache(ModelType.TANK, strPos)
  local tabPos = string.split(strPos, ",")
  if table.count(tabPos) ~= 2 then
    return
  end
  local center = DataCenter.BuildManager.main_city_pos
  local pos = Vector2.New(tabPos[1] + center.x, tabPos[2] + center.y)
  local tank = self:GetTankHandler()
  if tank == nil then
    tank = self:CreateModel(ModelType.TANK)
  end
  if tank then
    tank:SetTargetPos(pos, triggerId)
  end
  return tank
end

function WastelandModelMgr:CreateMonster(strPos, aniname)
  if string.IsNullOrEmpty(strPos) then
    return
  end
  self:AddToCache(ModelType.MONSTER, strPos)
  local tabPos = string.split(strPos, ";")
  self.m_roundIdx = self.m_roundIdx + 1
  for _, v in pairs(tabPos) do
    local tabPos1 = string.split(v, ",")
    if table.count(tabPos1) == 2 then
      local center = DataCenter.BuildManager.main_city_pos
      local pos = Vector2.New(tabPos1[1] + center.x, tabPos1[2] + center.y)
      local obj = self:GetMonsterHandler(pos)
      if obj ~= nil then
        local tabName
        if string.IsNullOrEmpty(aniname) then
          tabName = {}
        else
          tabName = string.split(aniname, ",")
        end
        obj:PlayAnimationByName(tabName)
      else
        self:CreateModel(ModelType.MONSTER, pos)
      end
    end
  end
end

function WastelandModelMgr:DestroyAllMonster()
  self:RemoveModelByType(ModelType.MONSTER)
end

function WastelandModelMgr:CreateModel(modelType, pos)
  local modelInst
  if modelType == ModelType.TANK then
    modelInst = ModelTank.New(pos)
  elseif modelType == ModelType.MONSTER then
    modelInst = ModelMonster.New(pos)
  end
  if modelInst ~= nil then
    self:AddModelToList(modelType, modelInst)
  end
  return modelInst
end

function WastelandModelMgr:AddModelToList(modelType, model)
  if self.m_modelList[modelType] == nil then
    self.m_modelList[modelType] = {}
  end
  self.m_modelList[modelType][#self.m_modelList[modelType] + 1] = model
end

function WastelandModelMgr:RemoveModelByType(modelType)
  if self.m_modelList[modelType] == nil then
    return
  end
  for _, v in pairs(self.m_modelList[modelType]) do
    v:OnDestroy()
  end
  self.m_modelList[modelType] = nil
end

function WastelandModelMgr:RemoveAllModel()
  for _, v in pairs(self.m_modelList) do
    for _, v1 in pairs(v) do
      v1:OnDestroy()
    end
  end
  self.m_modelList = {}
end

function WastelandModelMgr:GetTankObj()
  local tankHandler = self:GetTankHandler()
  if tankHandler == nil then
    return nil
  end
  return tankHandler:GetGameObject()
end

function WastelandModelMgr:GetTankHandler()
  if self.m_modelList[ModelType.TANK] == nil then
    return nil
  end
  return self.m_modelList[ModelType.TANK][1]
end

function WastelandModelMgr:GetMonsterHandler(pos)
  if self.m_modelList[ModelType.MONSTER] == nil then
    return nil
  end
  for _, v in pairs(self.m_modelList[ModelType.MONSTER]) do
    if v:GetPos() == pos then
      return v
    end
  end
  return nil
end

function WastelandModelMgr:GetMonsterObj()
  if self.m_modelList[ModelType.MONSTER] == nil then
    return nil
  end
  return self.m_modelList[ModelType.MONSTER][1]:GetGameObject()
end

function WastelandModelMgr:OnUpdate()
  for _, v in pairs(self.m_modelList) do
    for _, v1 in pairs(v) do
      v1:OnUpdate()
    end
  end
end

function WastelandModelMgr:AttackFinishCurRound()
  self:DestroyAllMonster()
end

function WastelandModelMgr:GetTotalMonsterHP()
  local totalHp = 0
  if self.m_modelList[ModelType.MONSTER] == nil then
    return totalHp
  end
  for _, v in pairs(self.m_modelList[ModelType.MONSTER]) do
    totalHp = totalHp + v:GetMaxHp()
  end
  return totalHp
end

function WastelandModelMgr:GetAliveMonster()
  local tab = {}
  if self.m_modelList[ModelType.MONSTER] == nil then
    return tab
  end
  for _, v in pairs(self.m_modelList[ModelType.MONSTER]) do
    if v:IsAlive() then
      tab[#tab + 1] = v
    end
  end
  return tab
end

function WastelandModelMgr:ShowBullet(damageValue)
  local tank = self:GetTankHandler()
  tank:ShowBullet(damageValue)
end

function WastelandModelMgr:SaveArchive()
  local archive = CityPioneerArchive:GetInstance()
  if self.m_cacheData == nil then
    return
  end
  for mtype, pos in pairs(self.m_cacheData) do
    archive:SetAtkModel(pos, mtype)
  end
end

function WastelandModelMgr:Load()
  local archive = CityPioneerArchive:GetInstance()
  local atkModelList = archive:GetAtkModelList()
  for _, v in pairs(atkModelList) do
    local pos = v.pos
    local mtype = tonumber(v.restype)
    if mtype == ModelType.TANK then
      self:CreateTank(pos)
    elseif mtype == ModelType.MONSTER then
      self:CreateMonster(pos)
    end
  end
end

return WastelandModelMgr
