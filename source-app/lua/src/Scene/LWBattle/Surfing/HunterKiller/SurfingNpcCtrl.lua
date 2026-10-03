local SurfingHunterUnit = require("Scene.LWBattle.Surfing.HunterKiller.SurfingHunterUnit")
local SurfingNpcCtrl = BaseClass("SurfingNpcCtrl")

function SurfingNpcCtrl:__init(unit, logic, gravity)
  self.unit = unit
  self.logic = logic
  self.gravity = gravity
  self.moveSpeed = nil
  self.npc = {}
  self.traceSpeed = 0
end

function SurfingNpcCtrl:__delete()
  self.unit = nil
  self.gravity = nil
  self.moveSpeed = nil
  if self.npc then
    for i, _ in pairs(self.npc) do
      self.logic:RemoveUnit(i)
    end
  end
  self.npc = nil
  self.logic = nil
  self.traceSpeed = nil
end

function SurfingNpcCtrl:Start(moveSpeed)
  self.moveSpeed = moveSpeed
  local npc1 = SurfingHunterUnit.New()
  npc1:Init(self.logic, Vector3.New(36, 0, 6), 0, nil)
  self.npc[npc1.guid] = npc1
  self.logic:AddUnit(npc1)
end

function SurfingNpcCtrl:OnUpdate(deltaTime)
  if self.npc == nil then
    return
  end
  for _, v in pairs(self.npc) do
    if v then
      v:OnUpdate(deltaTime)
    end
  end
end

function SurfingNpcCtrl:ChangeSpeed(newSpeed)
end

return SurfingNpcCtrl
