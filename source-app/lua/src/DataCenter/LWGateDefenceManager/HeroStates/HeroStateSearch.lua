local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local utils = require("DataCenter.LWGateDefenceManager.LWGateDefenceUtils")

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:OnEnter()
  self.owner.standAlready = true
  self.owner.fireCoverArea = utils.GetHeroFireCoverArea(self.owner)
  self.owner.animator:Play("idle")
end

function State:OnUpdate(deltaTime)
  local forceTarget = DataCenter.LWGateDefenceManager.forceTarget
  if self:CheckTarget(forceTarget, true) then
    return
  end
  local zombieInsts = DataCenter.LWGateDefenceManager.zombieInsts
  if zombieInsts then
    for _, zombieInst in pairs(zombieInsts) do
      if self:CheckTarget(zombieInst, false) then
        break
      end
    end
  end
end

function State:CheckTarget(zombieInst, ignoreRange)
  if zombieInst and zombieInst.transformValid and zombieInst.fsm and zombieInst.hp > 0 and zombieInst.fsm.currStateName ~= "Born" then
    if ignoreRange then
      self.owner.fsm:Switch("Fire", zombieInst)
      return true
    end
    local x, z = utils.Grid_2_World_XZ(zombieInst.grid.row, zombieInst.grid.col)
    if x >= self.owner.fireCoverArea[1] and x <= self.owner.fireCoverArea[2] and z >= self.owner.fireCoverArea[3] and z <= self.owner.fireCoverArea[4] then
      self.owner.fsm:Switch("Fire", zombieInst)
      return true
    end
  end
  return false
end

return State
