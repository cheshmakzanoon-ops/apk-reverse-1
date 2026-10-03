local base = require("Scene.LWBattle.Buff.BuffBase")
local BuffNewHot = BaseClass("BuffNewHot", base)
local HealType = {Value = 1}

function BuffNewHot:__init(logic, mgr, unit, meta, id, param)
  self.logic = logic
  self.meta = meta
  self.source = unit
end

function BuffNewHot:__delete()
  self:Destroy()
end

function BuffNewHot:Destroy()
  base.Destroy(self)
end

function BuffNewHot:OnStart()
  self.mgr:RegisterNewHotBuff(self.meta.para[1], self)
end

function BuffNewHot:OnEnd()
  self.mgr:UnregisterNewHotBuff(self.meta.para[1], self)
end

function BuffNewHot:GetHp()
  if self.meta.para[3] and self.meta.para[3] == HealType.Value then
    return self.meta.para[2]
  end
  return self.meta.para[2]
end

return BuffNewHot
