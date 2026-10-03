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
  self.syncCamera = true
  self.canInput = false
end

function State:OnEnter()
  if self.owner then
    self.battleMgr = self.owner.battleMgr
    self.battleMgr:OnBeforExit()
    self.owner.player:ChangeState(self.owner.player.State.ExitBattle)
    if self.owner.dominator and self.owner.dominator.active then
      self.owner.dominator:ChangeState(self.owner.dominator.State.Run)
    end
    self.deltaTime = HummerConstant.BATTLE_BEFOREEXIT_TIME
  end
end

function State:OnExit()
  if self.owner then
    self.owner:ExitBattle()
  end
end

function State:Dispose()
end

function State:OnUpdate(deltaTime)
  if self.owner and self.deltaTime then
    if self.deltaTime <= 0 then
      self.deltaTime = nil
      self.owner:ChangeState(self.owner.State.Play)
    else
      self.deltaTime = self.deltaTime - deltaTime
    end
  end
end

return State
