local LWOpeningStageLingerZombie = BaseClass("LWOpeningStageLingerZombie")
local FSMachine = require("Common.FSMachine")

function LWOpeningStageLingerZombie:__init(data)
  self.state = data.state
  self.stage = data.stage
  self.boss = data.boss
  self.gameObject = data.gameObject
  self.transform = self.gameObject.transform
  self.animator = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
  if self.animator == nil then
    return
  end
  self.fsm = FSMachine.Create(self)
  self.fsm:Add("init", require("DataCenter.LWOpeningStageManager.LingerZombieStates.LingerZombieStateInit").Create())
  self.fsm:Add("idle", require("DataCenter.LWOpeningStageManager.LingerZombieStates.LingerZombieStateIdle").Create())
  self.fsm:Add("walk", require("DataCenter.LWOpeningStageManager.LingerZombieStates.LingerZombieStateLinger").Create())
  self.fsm:Add("attack", require("DataCenter.LWOpeningStageManager.LingerZombieStates.LingerZombieStateAttack").Create())
  self.fsm:Add("notice", require("DataCenter.LWOpeningStageManager.LingerZombieStates.LingerZombieStateNotice").Create())
  self.fsm:Switch("init")
end

function LWOpeningStageLingerZombie:__delete()
  if self.fsm then
    self.fsm:Dispose()
    self.fsm = nil
  end
  self.state = nil
  self.stage = nil
  self.gameObject = nil
  self.transform = nil
  self.animator = nil
end

function LWOpeningStageLingerZombie:Update(dt)
  if self.fsm ~= nil then
    self.fsm:Update(dt)
  end
end

return LWOpeningStageLingerZombie
