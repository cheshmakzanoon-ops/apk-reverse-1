local LWHummerSceneUnitManager = BaseClass("LWHummerSceneUnitManager")
local UnitClassTitle = "Scene.LWHummerScene.Unit.LWHummerSceneUnit%s"

function LWHummerSceneUnitManager:__init()
  self.units = {}
  self.nextObjId = 1000000
  self.root = CS.UnityEngine.GameObject("LWHummerSceneUnitRoot")
  self.poolRoot = CS.UnityEngine.GameObject("LWHummerSceneUnitPoolRoot")
end

function LWHummerSceneUnitManager:__delete()
  self:OnDestroy()
end

function LWHummerSceneUnitManager:OnDestroy()
  for _, group in pairs(self.units) do
    for _, list in pairs(group) do
      for i, v in ipairs(list) do
        v:OnDestroy()
      end
    end
  end
  self.units = nil
  if self.root then
    CS.UnityEngine.GameObject.Destroy(self.root)
    self.root = nil
  end
  if self.poolRoot then
    CS.UnityEngine.GameObject.Destroy(self.poolRoot)
    self.poolRoot = nil
  end
end

function LWHummerSceneUnitManager:GetNextObjId()
  local nextObjId = self.nextObjId
  self.nextObjId = nextObjId + 1
  return nextObjId
end

function LWHummerSceneUnitManager:Get(param, resLoadCallback)
  local unitType = param.unitType
  param.sceneRoot = param.sceneRoot or self.root.transform
  param.guid = self:GetNextObjId()
  local res
  local poolName = unitType .. param.bornData.prefabPath
  if not (self.units[unitType] and self.units[unitType][poolName]) or #self.units[unitType][poolName] == 0 then
    if self:GetUnitClassExtend(unitType) == nil then
      Logger.LogError("[LWHummerScene] unitType not find.  unitType:.." .. tostring(unitType))
      return nil
    end
    local class = require(string.format(UnitClassTitle, self:GetUnitClassExtend(unitType)))
    res = class.New(param, resLoadCallback)
  else
    local item = table.remove(self.units[unitType][poolName])
    item:ReInit(param, resLoadCallback)
    res = item
  end
  return res
end

function LWHummerSceneUnitManager:Recycle(item)
  local unitType = item.unitType
  if not self.units[unitType] then
    self.units[unitType] = {}
  end
  local poolName = item:GetPoolName()
  if self.units[unitType][poolName] == nil then
    self.units[unitType][poolName] = {}
  end
  item:Recycle()
  if item.isLoaded then
    item.transform:SetParent(self.poolRoot.transform)
  end
  table.insert(self.units[unitType][poolName], item)
end

function LWHummerSceneUnitManager:GetUnitClassExtend(unitType)
  if unitType == HummerSceneUnitType.Player then
    return "Player"
  elseif unitType == HummerSceneUnitType.Zombie then
    return "Zombie"
  elseif unitType == HummerSceneUnitType.Trigger then
    return "Trigger"
  elseif unitType == HummerSceneUnitType.Drop then
    return "Drop"
  elseif unitType == HummerSceneUnitType.Air then
    return "Air"
  elseif unitType == HummerSceneUnitType.JumpZombie then
    return "JumpZombie"
  elseif unitType == HummerSceneUnitType.Dominator then
    return "Dominator"
  end
end

return LWHummerSceneUnitManager
