local base = require("Scene.LWBattle.Buff.BuffBase")
local BuffBeTaunt = BaseClass("BuffBeTaunt", base)

function BuffBeTaunt:__init(logic, mgr, unit, meta, id, param)
  self.logic = logic
  self.target = param
end

function BuffBeTaunt:__delete()
  self:Destroy()
end

function BuffBeTaunt:Destroy()
  base.Destroy(self)
  self.target = nil
end

function BuffBeTaunt:OnUpdate()
  if not self.target or self.target:GetCurBlood() <= 0 then
    self:End()
  end
end

function BuffBeTaunt:OnStart()
  self.unit:SetTauntTarget(self.target)
end

function BuffBeTaunt:OnEnd()
  self.unit:SetTauntTarget(nil)
end

return BuffBeTaunt
