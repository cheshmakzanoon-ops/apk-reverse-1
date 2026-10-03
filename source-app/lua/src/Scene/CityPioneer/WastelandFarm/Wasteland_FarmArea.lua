local Wasteland_FarmArea = BaseClass("Wasteland_FarmArea")
local Resource = CS.GameEntry.Resource
local Wasteland_FarmTile = require("Scene.CityPioneer.WastelandFarm.Wasteland_FarmTile")
local FarmTilePath = {
  "A_build_nt_gan_LT",
  "A_build_nt_gan_LD",
  "A_build_nt_gan_RT",
  "A_build_nt_gan_RD"
}

function Wasteland_FarmArea:__init(pointList, resType)
  self.m_minWorldPosX = 0
  self.m_minWorldPosY = 0
  self.m_maxWorldPosX = 0
  self.m_maxWorldPosY = 0
  self.m_resType = resType
  self.m_curPlantState = Wasteland_PlantState.ToPlant
  self.m_reqList = {}
  self.m_farmTileList = {}
  self.m_pointIdList = {}
  self:InstantiateObjByPointList(pointList, resType)
end

function Wasteland_FarmArea:InstantiateObjByPointList(pointList, resType)
  local strList = string.split(pointList, "|")
  if table.count(strList) ~= 0 then
    for k, v in pairs(strList) do
      self:DelayInstantiate(v, resType, (k - 1) * 0.5)
    end
  end
end

function Wasteland_FarmArea:GetResType()
  return self.m_resType
end

function Wasteland_FarmArea:DelayInstantiate(pointList, resType, time)
  TimerManager:GetInstance():DelayInvoke(function()
    self:InstantiateObj(pointList, resType)
  end, time)
end

function Wasteland_FarmArea:InstantiateObj(pointList, resType)
  local strList = string.split(pointList, ";")
  for _, v in pairs(strList) do
    local tab1 = string.split(v, ",")
    if table.count(tab1) == 2 then
      local vec = {}
      vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(tab1[1])
      vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(tab1[2])
      self:SetEdge(vec)
      local pointId = SceneUtils.TilePosToIndex(vec)
      self.m_pointIdList[#self.m_pointIdList + 1] = pointId
      self:AddFarmItem(pointId, resType)
    end
  end
  local posLD = SceneUtils.TileToWorld(Vector2.New(self.m_minX, self.m_minY))
  local posRT = SceneUtils.TileToWorld(Vector2.New(self.m_maxX, self.m_maxY))
  self.m_minWorldPosX = posLD.x
  self.m_minWorldPosZ = posLD.z
  self.m_maxWorldPosX = posRT.x
  self.m_maxWorldPosZ = posRT.z
end

function Wasteland_FarmArea:SetEdge(vec)
  if self.m_maxY == nil or self.m_maxX == nil or self.m_minX == nil or self.m_minY == nil then
    self.m_minX = vec.x
    self.m_maxX = vec.x
    self.m_maxY = vec.y
    self.m_minY = vec.y
  else
    self.m_maxX = vec.x > self.m_maxX and vec.x or self.m_maxX
    self.m_minX = vec.x < self.m_minX and vec.x or self.m_minX
    self.m_maxY = vec.y > self.m_maxY and vec.y or self.m_maxY
    self.m_minY = vec.y < self.m_minY and vec.y or self.m_minY
  end
end

function Wasteland_FarmArea:AddFarmItem(pointId, resType)
  local resPath = "Assets/_Art/Models/Environment/Build/NongTian/prefab/Wasteland_FarmLand.prefab"
  local boxInst = Resource:InstantiateAsync(resPath)
  self.m_reqList[#self.m_reqList + 1] = boxInst
  boxInst:completed("+", function(req)
    local _go = req.gameObject
    if _go == nil then
      return
    end
    req.gameObject.transform.position = SceneUtils.TileIndexToWorld(pointId)
    self:SetTiles(req.gameObject)
  end)
end

function Wasteland_FarmArea:SetTiles(gameObject)
  for _, v in pairs(FarmTilePath) do
    local obj = gameObject.transform:Find(v)
    local farmTile = Wasteland_FarmTile.New(self, obj, self.m_resType)
    local objId = farmTile:GetObjectId()
    WastelandFarmManager:GetInstance():AddTileToList(objId, farmTile)
    self.m_farmTileList[#self.m_farmTileList + 1] = farmTile
  end
end

function Wasteland_FarmArea:IsInFarmArea(worldPos)
  if worldPos.x >= self.m_minWorldPosX - 2 and worldPos.x <= self.m_maxWorldPosX + 2 and worldPos.z >= self.m_minWorldPosZ - 2 and worldPos.z <= self.m_maxWorldPosZ + 2 then
    return self
  end
  return nil
end

function Wasteland_FarmArea:GetAreaPlantState()
  return self.m_curPlantState
end

function Wasteland_FarmArea:SetAreaPlantState()
  local function GetNextState()
    if self.m_curPlantState == Wasteland_PlantState.ToPlant then
      return Wasteland_PlantState.ToWater
    elseif self.m_curPlantState == Wasteland_PlantState.ToWater then
      return Wasteland_PlantState.ToReap
    elseif self.m_curPlantState == Wasteland_PlantState.ToReap then
      return Wasteland_PlantState.ToPlant
    end
  end
  
  local nextState = GetNextState()
  local cnt = 0
  for _, v in pairs(self.m_farmTileList) do
    if v:GetTilePlantState() ~= nextState then
      cnt = cnt + 1
    end
  end
  if self.m_curPlantState == Wasteland_PlantState.ToReap then
    if 0 < cnt then
      return
    end
  elseif cnt < table.count(self.m_farmTileList) * 0.1 then
    self:SetTileState(nextState)
  else
    return
  end
  self.m_curPlantState = nextState
end

function Wasteland_FarmArea:SetTileState(plantState)
  for _, v in pairs(self.m_farmTileList) do
    if plantState == Wasteland_PlantState.ToWater then
      v:RecvPlant(true)
    elseif plantState == Wasteland_PlantState.ToReap then
      v:RecvWater(true)
    end
  end
end

function Wasteland_FarmArea:Destroy()
  for _, v in pairs(self.m_reqList) do
    v:Destroy()
  end
  self.m_reqList = {}
end

return Wasteland_FarmArea
