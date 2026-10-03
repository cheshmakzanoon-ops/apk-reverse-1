local CityPrologueBuildManager = BaseClass("CityPrologueBuildManager")
local Resource = CS.GameEntry.Resource
local CityPrologueBuild = require("Scene.CityPrologueBuild.CityPrologueBuild")
local CityPrologueBuildSandMonster = require("Scene.CityPrologueBuild.CityPrologueBuildSandMonster")
local CityPrologueBuildWithAni = require("Scene.CityPrologueBuild.CityPrologueBuildWithAni")
local CityPrologueBuildFinal = require("Scene.CityPrologueBuild.CityPrologueBuildFinal")

local function GetNodeActiveNames(obj, parentName, tbl)
  local fullName
  if string.IsNullOrEmpty(parentName) then
    fullName = ""
  else
    fullName = parentName .. "/" .. obj.name
  end
  if obj.activeSelf then
    tbl[#tbl + 1] = fullName
  end
  local nodeRoot = obj.transform
  local childCount = nodeRoot.childCount
  for i = 0, childCount - 1 do
    local child = nodeRoot:GetChild(i).gameObject
    GetNodeActiveNames(child, fullName, tbl)
  end
end

local function SetNodeActive(obj, tbl)
  for k, v in ipairs(tbl) do
    local t = obj.transform:Find(v)
    if t then
      t:SetActive(true)
    end
  end
end

function CityPrologueBuildManager:Load()
end

function CityPrologueBuildManager:__init()
  self.build = {}
end

function CityPrologueBuildManager:__delete()
  self:RemoveAll()
  self.build = nil
end

function CityPrologueBuildManager:AddOneBuild(pointId, modelName, aniName)
  if self.build == nil then
    self.build = {}
  end
  pointId = tonumber(pointId)
  self:AddToCache(pointId, modelName, aniName)
  if self.build[pointId] == nil then
    if modelName == nil then
      return
    end
    self.build[pointId] = {}
    self.build[pointId].pointId = pointId
    self.build[pointId].modelName = modelName
    self.build[pointId].aniName = aniName
    self.build[pointId].inst = Resource:InstantiateAsync(string.format(LoadPath.CityScene, modelName))
    print(">>>modelname: " .. tostring(modelName))
    self.build[pointId].inst:completed("+", function(req)
      req.gameObject.transform.position = SceneUtils.TileIndexToWorld(pointId)
      local effect
      if modelName == "CityPrologueBuildSandMonster" then
        effect = CityPrologueBuildSandMonster.New()
      elseif modelName == "CityPrologueBuildFinal" then
        effect = CityPrologueBuildFinal.New()
      elseif not string.IsNullOrEmpty(aniName) or table.count(aniName) > 0 then
        effect = CityPrologueBuildWithAni.New()
      else
        effect = CityPrologueBuild.New()
      end
      effect:OnCreate(req)
      local param = {}
      param.modelName = modelName
      param.pointId = pointId
      param.aniName = aniName
      effect:ReInit(param)
      self.build[pointId].model = effect
      self.build[pointId].go = req.gameObject
    end)
  else
    self.build[pointId].pointId = pointId
    self.build[pointId].modelName = modelName
    self.build[pointId].aniName = aniName
    if self.build[pointId].model ~= nil and self.build[pointId].model.param ~= nil then
      self.build[pointId].model.param.aniName = aniName
      if not string.IsNullOrEmpty(aniName) then
        self.build[pointId].model:PlayAnimation()
      end
    end
  end
  return self.build
end

function CityPrologueBuildManager:RemoveOneBuild(pointId)
  if self.build[pointId] ~= nil then
    if self.build[pointId].model ~= nil then
      self.build[pointId].model:OnDestroy()
    end
    if self.build[pointId].inst then
      self.build[pointId].inst:Destroy()
    end
    self.build[pointId] = nil
  end
end

function CityPrologueBuildManager:GetBuild(pointId)
  return self.build[pointId]
end

function CityPrologueBuildManager:AddToCache(pointId, modelName, aniName)
  if self.m_cache == nil then
    self.m_cache = {}
  end
  pointId = tostring(pointId)
  if self.m_cache[pointId] == nil then
    self.m_cache[pointId] = {}
  end
  self.m_cache[pointId].modelname = modelName
  if self.m_cache[pointId].aniname == nil then
    self.m_cache[pointId].aniname = {}
  end
  local tbl = self.m_cache[pointId].aniname
  if type(aniName) == "string" then
    self.m_cache[pointId].aniname[#self.m_cache[pointId].aniname + 1] = aniName
  else
    self.m_cache[pointId].aniname = aniName
  end
end

function CityPrologueBuildManager:SaveArchive()
  local archive = CityPioneerArchive:GetInstance()
  archive:SetPrologueBuild(self.m_cache)
end

function CityPrologueBuildManager:InitBuild()
  local archive = CityPioneerArchive:GetInstance()
  local build = archive:GetPrologueBuild()
  if build == nil then
    return
  end
  for pt, info in pairs(build) do
    local modelname = info.modelname
    local aniname = info.aniname
    if modelname == "CityPrologueBuildSandMonster" then
      local _tmp_aniname = ""
      if table.count(aniname) > 0 then
        _tmp_aniname = aniname[#aniname]
        self:AddOneBuild(pt, modelname, _tmp_aniname)
      end
    else
      self:AddOneBuild(pt, modelname, aniname)
    end
  end
end

function CityPrologueBuildManager:RemoveAll()
  if self.build then
    for t, n in pairs(self.build) do
      self:RemoveOneBuild(t)
    end
    self.build = {}
    self.m_cache = {}
  end
end

return CityPrologueBuildManager
