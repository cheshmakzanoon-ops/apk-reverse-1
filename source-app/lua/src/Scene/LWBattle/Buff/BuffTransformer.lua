local base = require("Scene.LWBattle.Buff.BuffBase")
local BuffTransformer = BaseClass("BuffTransformer", base)

function BuffTransformer:__init(logic, mgr, unit, meta, id)
  self.logic = logic
  self.unit = unit
  self.subType = self.meta.sub_type
end

function BuffTransformer:__delete()
  self:Destroy()
end

function BuffTransformer:Destroy()
  base.Destroy(self)
  self.unit = nil
end

function BuffTransformer:OnStart()
  self.unit:SetIsTransforming(true)
  self.unit:SetIdleAnimName(self.meta.para)
end

function BuffTransformer:OnEnd()
  self.unit:SetIsTransforming(false)
  self.unit:SetIdleAnimName()
end

return BuffTransformer
