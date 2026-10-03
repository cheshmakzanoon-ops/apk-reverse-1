local FarmManager = BaseClass("FarmManager", Singleton)
local FarmArea = require("Scene.CityPioneer.WastelandFarm.Wasteland_FarmArea")

function FarmManager:__init()
  self.m_areaList = {}
  self.m_tileList = {}
  self.m_cacheData = {}
  self.arrowDetection = false
  self.arrowVisible = false
end

function FarmManager:__delete()
  self:DeleteObj()
  self:RemoveAll()
end

function FarmManager:AddToCache(pointList, resType)
  local insert = true
  for _, v in pairs(self.m_cacheData) do
    if resType == v.restype and pointList == v.pos then
      insert = false
      break
    end
  end
  if not insert then
    return false
  end
  local tbl = {}
  tbl.pos = pointList
  tbl.restype = resType
  self.m_cacheData[#self.m_cacheData + 1] = tbl
  return true
end

function FarmManager:AddFarm(pointList, resType)
  resType = resType == "" and "1" or resType
  if string.IsNullOrEmpty(pointList) then
    return
  end
  local result = self:AddToCache(pointList, resType)
  if not result then
    return
  end
  local _farmArea = FarmArea.New(pointList, resType)
  self.m_areaList[#self.m_areaList + 1] = _farmArea
end

function FarmManager:AddTileToList(objId, farmTile)
  self.m_tileList[objId] = farmTile
end

function FarmManager:GetTileByObjId(objId)
  return self.m_tileList[objId]
end

function FarmManager:DeleteObj()
  for _, v in pairs(self.m_areaList) do
    v:Destroy()
  end
  self.m_areaList = {}
  for _, v in pairs(self.m_tileList) do
    v:Delete()
  end
  self.m_tileList = {}
end

function FarmManager:IsInFarmArea(worldPos)
  for _, v in pairs(self.m_areaList) do
    if v:IsInFarmArea(worldPos) then
      return v
    end
  end
  return nil
end

function FarmManager:BindArrow()
  local target = CS.SceneManager.World.gameObject.transform:Find("Scene_City2(Clone)/FarmYellowArrow")
  if target ~= nil then
    self.arrowObject = target.gameObject
    self.arrowObject:SetActive(false)
    self.arrowVisible = false
  end
end

function FarmManager:ToggleArrowDetection(t)
  self.arrowDetection = t
end

function FarmManager:ToggleArrow(t)
  local visible = self.arrowDetection and t
  if visible == self.arrowVisible then
    return
  end
  self.arrowVisible = visible
  if self.arrowObject ~= nil then
    self.arrowObject:SetActive(visible)
  end
end

function FarmManager:SaveArchive()
  local archive = CityPioneerArchive:GetInstance()
  for _, v in pairs(self.m_cacheData) do
    archive:SetFarmList(v.pos, v.restype)
  end
end

function FarmManager:Load()
  local archive = CityPioneerArchive:GetInstance()
  local farmlist = archive:GetFarmList()
  for _, v in pairs(farmlist) do
    local pos = v.pos
    local restype = v.restype
    self:AddFarm(pos, restype)
  end
  self:BindArrow()
end

function FarmManager:RemoveAll()
  if self.m_cacheData then
    self.m_cacheData = {}
  end
end

function FarmManager:StopAllWaterSoundEffect()
  for _, v in pairs(self.m_tileList) do
    if v ~= nil then
      v:StopWaterSoundEffect()
    end
  end
end

return FarmManager
