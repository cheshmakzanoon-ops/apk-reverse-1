local EffectManager = BaseClass("EffectManager")
local EffectObj = require("Scene.Monopoly.Effect.EffectObject")
local Resource = CS.GameEntry.Resource

function EffectManager:__init()
  self.allEffects = {}
  self.nextObjId = 0
  self.tasks = {}
end

function EffectManager:__delete()
  self:Destroy()
end

function EffectManager:Destroy()
  for _, effect in pairs(self.allEffects) do
    effect:Destroy()
  end
  self.allEffects = {}
  self.tasks = {}
end

function EffectManager:ShowEffectObj(path, pos, scale, parent, time, callback)
  if string.IsNullOrEmpty(path) then
    return
  end
  self.nextObjId = self.nextObjId + 1
  local id = self.nextObjId
  self.tasks[id] = true
  local effectReq = Resource:InstantiateAsync(path)
  effectReq:completed("+", function(req)
    if req.isError then
      self.tasks[id] = nil
      return
    end
    if self.tasks[id] then
      self.tasks[id] = nil
    else
      req:Destroy()
    end
    local effect = EffectObj.New(self, path, req, id)
    effect:Show(pos, scale, parent, time, callback)
    self.allEffects[id] = effect
  end)
  return id
end

function EffectManager:DestroyEffectById(id)
  if self.allEffects[id] then
    self.allEffects[id]:Destroy()
    self.allEffects[id] = nil
  end
end

function EffectManager:InnerRemove(effect)
  self.allEffects[effect.id] = nil
  effect:Destroy()
end

return EffectManager
