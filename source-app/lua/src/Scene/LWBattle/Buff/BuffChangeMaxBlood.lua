local base = require("Scene.LWBattle.Buff.BuffBase")
local BuffChangeMaxBlood = BaseClass("BuffChangeMaxBlood", base)

function BuffChangeMaxBlood:__init(logic, mgr, unit, meta, id, param)
  self.logic = logic
  self.meta = meta
  self.source = unit
end

function BuffChangeMaxBlood:__delete()
  self:Destroy()
end

function BuffChangeMaxBlood:Destroy()
  base.Destroy(self)
end

function BuffChangeMaxBlood:OnStart()
  self.mgr:RegisterChangeMaxBloodBuff(self)
end

function BuffChangeMaxBlood:OnEnd()
  self.mgr:UnregisterChangeMaxBloodBuff(self)
end

function BuffChangeMaxBlood:GetChangeMaxBloodValue()
  if self.meta.para[1] then
    return self.meta.para[1]
  end
  return 0
end

return BuffChangeMaxBlood
