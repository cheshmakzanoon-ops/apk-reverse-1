local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)

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
    self.battleMgr = self.owner.battleMgr
    self.battleMgr:OnBattle()
    self.owner.player:ChangeState(self.owner.player.State.Stay)
  end
end

function State:OnExit()
end

function State:Dispose()
end

function State:OnUpdate(deltaTime)
  if self.battleMgr then
    self.battleMgr:OnUpdate(deltaTime)
    if self.battleMgr.gameOver then
      self.owner:ChangeState(self.owner.State.ExitBattle)
    end
  end
end

return State
