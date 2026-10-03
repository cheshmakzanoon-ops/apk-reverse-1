local TCEffectObjManager = BaseClass("TCEffectObjManager")
local Resource = CS.GameEntry.Resource
local EffectObj = require("DataCenter.TacticalCardWorld.TCEffectObj")
local MAX_INSTANCE_PERFRAME = 20
local MAX_ALIVE_EFFECT = 100
local MAX_DELETE_PERFRAME = 10

function TCEffectObjManager:__init()
  self.allEffects = {}
  self.nextObjId = 0
  self.tasks = {}
  self.curFrameTaskCount = 0
  self.effectsList = list:new()
  self.deleteTasks = list:new()
end

function TCEffectObjManager:__delete()
  self:Destroy()
end

function TCEffectObjManager:Destroy()
  self.tasks = {}
  self:ResetData()
end

function TCEffectObjManager:ResetData()
  for _, effect in pairs(self.allEffects) do
    effect:Destroy()
  end
  self.allEffects = {}
  self.effectsList:clear()
  self.curFrameTaskCount = 0
  self.deleteTasks:clear()
end

function TCEffectObjManager:AddEffect(id, effect)
  self.allEffects[id] = effect
  effect.node = self.effectsList:push(effect)
  if self.deleteTasks.length > 0 then
    return
  end
  if self.effectsList.length > MAX_ALIVE_EFFECT then
    local needToDeleteCount = self.effectsList.length - MAX_ALIVE_EFFECT
    local index = 0
    if self.effectsList.length <= 0 then
      return
    end
    for k, v in ilist(self.effectsList) do
      if needToDeleteCount < index then
        break
      end
      self.deleteTasks:push(v.id)
      index = index + 1
    end
  end
end

function TCEffectObjManager:RemoveEffect(id)
  local effect = self.allEffects[id]
  self.allEffects[id] = nil
  if effect and effect.node then
    self.effectsList:remove(effect.node)
  end
end

local SET_PREFAB_MAP = {}
local BATTLE_PARTICLE_CLEAR_TIME = 5

function TCEffectObjManager:ShowEffectObj(path, pos, rot, time, parent, isImportant, callback)
  if string.IsNullOrEmpty(path) then
    return
  end
  if not isImportant and self.curFrameTaskCount > MAX_INSTANCE_PERFRAME then
    return
  end
  self.curFrameTaskCount = self.curFrameTaskCount + 1
  self.nextObjId = self.nextObjId + 1
  local id = self.nextObjId
  local effectReq = Resource:InstantiateAsync(path, ObjectPoolTag.Battle)
  self.tasks[id] = effectReq
  effectReq:completed("+", function(req)
    if req.isError then
      self.tasks[id] = nil
      return
    end
    if self.tasks[id] then
      self.tasks[id] = nil
      local effect = ObjectPool:GetInstance():Load(EffectObj)
      effect:Init(self, req, id, path)
      effect:Show(pos, rot, time, parent)
      self:AddEffect(id, effect)
      if not SET_PREFAB_MAP[path] then
        SET_PREFAB_MAP[path] = true
      end
      if callback then
        callback(effect.req.gameObject)
      end
    else
      req:Destroy()
    end
  end)
  return id
end

function TCEffectObjManager:RemoveEffectObj(id)
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

function TCEffectObjManager:OnUpdate()
  self.curFrameTaskCount = 0
  for _, v in pairs(self.allEffects) do
    v:OnUpdate()
  end
  for i = 1, MAX_DELETE_PERFRAME do
    if 0 >= self.deleteTasks.length then
      break
    end
    local id = self.deleteTasks:shift()
    if id then
      self:RemoveEffectObj(id)
    else
      break
    end
  end
end

function TCEffectObjManager:InnerRemove(effect)
  self:RemoveEffect(effect.id)
  effect:Destroy()
  ObjectPool:GetInstance():Save(effect)
end

function TCEffectObjManager:IsEffectValid(id)
  if self.tasks[id] then
    return true
  end
  if self.allEffects[id] then
    return true
  end
  return false
end

function TCEffectObjManager:ReplayEffect(id, time)
  local effect = self.allEffects[id]
  if effect then
    effect:Replay(time)
  end
end

return TCEffectObjManager
