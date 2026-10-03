local ParkourBattleExtendState = BaseClass("ParkourBattleExtendState")

function ParkourBattleExtendState:__init(logic)
  self.__event_handlers = {}
end

function ParkourBattleExtendState:__delete()
  self.__event_handlers = nil
end

function ParkourBattleExtendState:OnEnter(state)
end

function ParkourBattleExtendState:OnExit()
end

function ParkourBattleExtendState:OnUpdate()
end

function ParkourBattleExtendState:OnFingerDown(pos)
end

function ParkourBattleExtendState:OnFingerHold(deltaTime)
end

function ParkourBattleExtendState:OnMonsterDeath(monster)
end

function ParkourBattleExtendState:AddListener(msg_name, callback)
  local function bindFunc(...)
    callback(self, ...)
  end
  
  self.__event_handlers[msg_name] = bindFunc
  EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function ParkourBattleExtendState:RemoveListener(msg_name, callback)
  local bindFunc = self.__event_handlers[msg_name]
  if not bindFunc then
    return
  end
  self.__event_handlers[msg_name] = nil
  EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

return ParkourBattleExtendState
