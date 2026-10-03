local LWOpeningStageZakuZombie = BaseClass("LWOpeningStageZakuZombie")
local FSMachine = require("Common.FSMachine")

function LWOpeningStageZakuZombie:__init(config)
  self.config = config
  self.handle = CS.GameEntry.Resource:InstantiateAsync(config.model)
  self.handle:completed("+", function(handle)
    if handle.isError then
      Logger.LogError("load res failed:" .. config.model)
    end
    self.gameObject = handle.gameObject
    self.transform = self.gameObject.transform
    self.transform.position = config.pos
    self.transform.rotation = config.rot
    self.animator = self.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Animator))
    self.fsm = FSMachine.Create(self)
    self.fsm:Add("Born", require("DataCenter.LWOpeningStageManager.ZakuZombieStates.ZakuZombieStateBorn").Create())
    self.fsm:Add("Walk", require("DataCenter.LWOpeningStageManager.ZakuZombieStates.ZakuZombieStateWalk").Create())
    self.fsm:Add("Attack", require("DataCenter.LWOpeningStageManager.ZakuZombieStates.ZakuZombieStateAttack").Create())
    self.fsm:Switch("Born")
    EventManager:GetInstance():Broadcast(EventId.OpeningStageZakuZombieInited, self)
  end)
end

function LWOpeningStageZakuZombie:__delete()
  if self.fsm ~= nil then
    self.fsm:Dispose()
    self.fsm = nil
  end
  self.config = nil
  if not IsNull(self.handle) then
    self.handle:Destroy()
    self.handle = nil
    self.gameObject = nil
    self.transform = nil
    self.animator = nil
  end
end

function LWOpeningStageZakuZombie:Update(dt)
  if self.fsm ~= nil then
    self.fsm:Update(dt)
  end
end

function LWOpeningStageZakuZombie:DestroySelf()
  EventManager:GetInstance():Broadcast(EventId.OpeningStageZakuZombieDestroyed, self)
  self:Delete()
end

return LWOpeningStageZakuZombie
