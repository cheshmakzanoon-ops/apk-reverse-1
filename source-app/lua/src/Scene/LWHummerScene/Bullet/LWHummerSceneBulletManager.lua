local LWHummerSceneBulletManager = BaseClass("LWHummerSceneBulletManager")
local CSBulletMotionEditor = CS.BulletMotionEditor
local BulletCreator = require("Scene.LWHummerScene.Bullet.LWHummerSceneBulletCreator")
local BattleColliderUtils = CS.BattleColliderUtils

function LWHummerSceneBulletManager:__init(logic)
  self.logic = logic
  self.nextObjId = 1000000
  self.bullets = {}
  self.creators = {}
  self.curves = {}
  self.colliderMap = {}
  self.colliderResultList = nil
  self.colliderResultCount = 0
  self.colliderResultTmpList = nil
end

function LWHummerSceneBulletManager:__delete()
  self:Destory()
end

function LWHummerSceneBulletManager:Destory()
  self.curves = nil
  if self.bullets then
    for _, v in pairs(self.bullets) do
      v:Delete()
    end
    self.bullets = nil
  end
  if self.creators then
    for _, v in pairs(self.creators) do
      v:Delete()
    end
    self.creators = nil
  end
  BattleColliderUtils.ClearBulletData()
  self.colliderMap = nil
  self.colliderResultList = nil
  self.colliderResultCount = nil
  self.colliderResultTmpList = nil
end

function LWHummerSceneBulletManager:GetNextObjId()
  self.nextObjId = self.nextObjId + 1
  return self.nextObjId
end

function LWHummerSceneBulletManager:StringToCurve(str)
  if string.IsNullOrEmpty(str) then
    str = DEFAULT_BULLET_MOTION_STRING
  end
  local curve = self.curves[str]
  if not curve then
    curve = CSBulletMotionEditor.StringToCurve(str)
    self.curves[str] = curve
  end
  return curve
end

function LWHummerSceneBulletManager:TryGetCollideList(bulletObjId)
  if self.colliderResultCount > 0 then
    local countIndex = self.colliderMap[bulletObjId]
    if countIndex and 0 < countIndex then
      local count = self.colliderResultList[countIndex]
      if count == 1 then
        local value = self.colliderResultList[countIndex + 1]
        return count, value
      end
      if self.colliderResultTmpList == nil then
        self.colliderResultTmpList = {}
      end
      for i = 1, count do
        local value = self.colliderResultList[countIndex + i]
        self.colliderResultTmpList[i] = value
      end
      return count, self.colliderResultTmpList
    end
  end
  return nil, nil
end

function LWHummerSceneBulletManager:GetUnit(objectId)
  return self.logic:GetUnit(objectId)
end

function LWHummerSceneBulletManager:HitUnit(unit, meta, hitPoint, hitDir)
  unit:OnBulletHit(meta.hit_effect, hitPoint, hitDir)
end

function LWHummerSceneBulletManager:CreateBulletCreator(metaId, fireTrans, target)
  local meta = self.logic.data:GetBulletTemplate(metaId)
  local objId = self:GetNextObjId()
  local bulletCreator = ObjectPool:GetInstance():Load(BulletCreator)
  local success = bulletCreator:Init(self, objId, meta, fireTrans, target)
  if success then
    self.creators[bulletCreator.objId] = bulletCreator
  end
end

function LWHummerSceneBulletManager:CreateBullet(class, bulletMgr, objId, params)
  local bullet = ObjectPool:GetInstance():Load(class)
  bullet:Init(bulletMgr, objId, params)
  bullet:Create()
  self.bullets[objId] = bullet
end

function LWHummerSceneBulletManager:RemoveBullet(bullet)
  self.bullets[bullet.objId] = nil
  bullet:Delete()
  ObjectPool:GetInstance():Save(bullet)
end

function LWHummerSceneBulletManager:RemoveCreator(creator)
  self.creators[creator.objId] = nil
  creator:Delete()
  ObjectPool:GetInstance():Save(creator)
end

function LWHummerSceneBulletManager:GetClassExtend(mvtType)
  if mvtType == 0 then
    return "Static"
  elseif mvtType == 2 then
    return "Curve"
  end
end

function LWHummerSceneBulletManager:OnUpdate(dt)
  local resultList = BattleColliderUtils.BulletCollider()
  self.colliderResultList = resultList
  self.colliderResultCount = 0
  if resultList then
    local length = #resultList
    local idPos = false
    local cacheId = 0
    local countPos = false
    local indexPos = 0
    if 0 < length and 0 < resultList[1] then
      table.clear(self.colliderMap)
      self.colliderResultCount = length
      idPos = true
      for i = 1, length do
        local data = resultList[i]
        if data < 0 then
          break
        end
        if idPos then
          cacheId = data
          idPos = false
          countPos = true
          indexPos = 0
        elseif countPos then
          idPos = false
          countPos = false
          indexPos = data
          self.colliderMap[cacheId] = i
        elseif 0 < indexPos then
          indexPos = indexPos - 1
          if indexPos == 0 then
            idPos = true
            countPos = false
            indexPos = 0
          end
        end
      end
    end
  end
  for _, v in pairs(self.bullets) do
    if v.objId then
      local collide = self.colliderMap[v.objId] ~= nil
      v:OnUpdate(collide)
    end
  end
  for _, v in pairs(self.creators) do
    if v.objId then
      v:OnUpdate(dt)
    end
  end
end

return LWHummerSceneBulletManager
