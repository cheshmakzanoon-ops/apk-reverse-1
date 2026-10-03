local base = require("Scene.LWBattle.Buff.BuffBase")
local BuffModelScale = BaseClass("BuffModelScale", base)

function BuffModelScale:__init(logic, mgr, unit, meta, id)
  self.logic = logic
  self.scaleValue = 1
end

function BuffModelScale:__delete()
  self:Destroy()
end

function BuffModelScale:Destroy()
  base.Destroy(self)
  self.scaleValue = 1
end

function BuffModelScale:OnStart()
  self.scaleValue = tonumber(self.meta.para)
  if self.scaleValue <= 0 then
    self.scaleValue = 1
  end
  self.mgr:RegisterModelScaleBuff(self)
end

function BuffModelScale:OnEnd()
  self.scaleValue = 1
  self.mgr:UnregisterModelScaleBuff(self)
end

function BuffModelScale:GetBuffValue()
  return self.scaleValue
end

return BuffModelScale
