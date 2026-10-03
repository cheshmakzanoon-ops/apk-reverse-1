local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local HummerConstant = require("Scene.LWHummerScene.LWHummerSceneConstant")

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:Init()
  self.syncCamera = false
  self.canInput = false
end

function State:OnEnter()
  if self.owner then
    for k, v in pairs(self.owner.units) do
      if v.unitType == HummerSceneUnitType.Zombie then
        v:OnChangeBattle()
      elseif v.unitType == HummerSceneUnitType.JumpZombie then
        v:OnChangeBattle()
      end
    end
    self.owner.player:ChangeState(self.owner.player.State.PreBattle)
    if self.owner.dominator and self.owner.dominator.active then
      self.owner.dominator:ChangeState(self.owner.dominator.State.Stay)
    end
    self.owner:CreateBattle()
    self.battleMgr = self.owner.battleMgr
    self.battleMgr:OnAfterEnter()
    self.deltaTime = HummerConstant.BATTLE_AFTERENTER_TIME
  end
end

function State:OnExit()
end

function State:Dispose()
end

function State:OnUpdate(deltaTime)
  if self.owner and self.deltaTime then
    if self.deltaTime <= 0 then
      self.deltaTime = nil
      self.owner:ChangeState(self.owner.State.Battle)
    else
      self.deltaTime = self.deltaTime - deltaTime
    end
  end
end

return State
