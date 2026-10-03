local EffectObjWithPoolManager = BaseClass("EffectObjWithPoolManager")
local Resource = CS.GameEntry.Resource
local EffectObj = require("Scene.LWBattle.EffectObj.EffectObjWithPool")
local EffectSprite = require("Scene.LWBattle.EffectObj.EffectSpriteWithPool")
local MAX_INSTANCE_PERFRAME = 20

function EffectObjWithPoolManager:__init()
  self.allEffects = {}
  self.nextObjId = 0
  self.tasks = {}
  self.curFrameTaskCount = 0
  self.effectGoPool = {}
  self.effectReqList = {}
  self.go2ReqDict = {}
  self.totalInPoolCount = 0
end

function EffectObjWithPoolManager:__delete()
  self:Destroy()
end

function EffectObjWithPoolManager:Destroy()
  self:ResetData()
  self.tasks = {}
  self.effectGoPool = nil
  self.go2ReqDict = nil
  for _, v in ipairs(self.effectReqList) do
    v:Destroy()
  end
  self.effectReqList = nil
  self.totalInPoolCount = 0
end

function EffectObjWithPoolManager:ResetData()
  table.clear(self.tasks)
  for _, effect in pairs(self.allEffects) do
    self:InnerRemove(effect)
  end
  self.allEffects = {}
  self.curFrameTaskCount = 0
end

function EffectObjWithPoolManager:ShowEffectObj(path, pos, rot, time, parent, type)
  if string.IsNullOrEmpty(path) then
    return
  end
  self.curFrameTaskCount = self.curFrameTaskCount + 1
  if self.curFrameTaskCount > MAX_INSTANCE_PERFRAME then
    return
  end
  self.nextObjId = self.nextObjId + 1
  local id = self.nextObjId
  local effectGo = self:GetEffectGoFromPool(path)
  if effectGo then
    local effect
    if type == EffectObjType.Sprite then
      effect = ObjectPool:GetInstance():Load(EffectSprite)
    else
      effect = ObjectPool:GetInstance():Load(EffectObj)
    end
    effect:Init(self, effectGo, id)
    effect:Show(pos, rot, time, parent)
    effect.path = path
    self.allEffects[id] = effect
    return id
  end
  local effectReq = Resource:InstantiateAsync(path, ObjectPoolTag.Battle)
  self.tasks[id] = effectReq
  table.insert(self.effectReqList, effectReq)
  effectReq:completed("+", function(req)
    if req.isError then
      req:Destroy()
      self.tasks[id] = nil
      return
    end
    local go = req.gameObject
    self.go2ReqDict[go] = req
    if self.tasks[id] then
      self.tasks[id] = nil
      local effect
      if type == EffectObjType.Sprite then
        effect = ObjectPool:GetInstance():Load(EffectSprite)
      else
        effect = ObjectPool:GetInstance():Load(EffectObj)
      end
      effect:Init(self, go, id)
      effect:Show(pos, rot, time, parent)
      effect.path = path
      self.allEffects[id] = effect
    else
      self:EffectGoInPool(path, go)
    end
  end)
  return id
end

function EffectObjWithPoolManager:RemoveEffectObj(id)
  if not id then
    return
  end
  local effectObj = self.allEffects[id]
  if effectObj then
    self:InnerRemove(effectObj)
  elseif self.tasks[id] then
    self.tasks[id]:Destroy()
    self.tasks[id] = nil
  end
end

function EffectObjWithPoolManager:OnUpdate()
  self.curFrameTaskCount = 0
  for _, v in pairs(self.allEffects) do
    v:OnUpdate()
  end
end

function EffectObjWithPoolManager:InnerRemove(effect)
  self.allEffects[effect.id] = nil
  local path = effect.path
  local go = effect.gameObject
  self:EffectGoInPool(path, go)
  effect:Destroy()
  ObjectPool:GetInstance():Save(effect)
end

function EffectObjWithPoolManager:GetEffectGoFromPool(path)
  local pool = self.effectGoPool[path]
  if pool == nil then
    self.effectGoPool[path] = {}
    return nil
  end
  local count = #pool
  if 0 < count then
    local go = table.remove(pool, count)
    self.totalInPoolCount = self.totalInPoolCount - 1
    return go
  end
  return nil
end

local MAXOBJECTS_IN_PERPOOL = 6
local MAXOBJECTS_IN_TOTALPOOL = 500

function EffectObjWithPoolManager:EffectGoInPool(path, go)
  if IsNull(go) or IsNull(go.transform) then
    return
  end
  if not string.IsNullOrEmpty(path) then
    local pool = self.effectGoPool[path]
    if pool and #pool >= MAXOBJECTS_IN_PERPOOL or self.totalInPoolCount >= MAXOBJECTS_IN_TOTALPOOL then
      if self.go2ReqDict[go] then
        self.go2ReqDict[go]:Destroy()
        self.go2ReqDict[go] = nil
        return
      else
        Logger.LogError("EffectObjWithPoolManager:EffectGoInPool go2ReqDict is nil")
      end
    end
    if pool == nil then
      pool = {}
      self.effectGoPool[path] = pool
    end
    go:SetActive(false)
    go.transform:SetParent(nil)
    table.insert(pool, go)
    self.totalInPoolCount = self.totalInPoolCount + 1
  end
end

return EffectObjWithPoolManager
