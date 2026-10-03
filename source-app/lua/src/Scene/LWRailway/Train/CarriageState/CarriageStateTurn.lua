local CarriageStateTurn = BaseClass("CarriageStateTurn")

function CarriageStateTurn:__init(carriage)
  self.carriage = carriage
  self.trainData = self.carriage.trainData
  self.fsm = self.carriage.fsm
end

function CarriageStateTurn:__delete()
  self.carriage = nil
  self.trainData = nil
  self.fsm = nil
end

function CarriageStateTurn:OnEnter(pos, dir, rot)
end

function CarriageStateTurn:OnExit()
end

function CarriageStateTurn:OnUpdate(ts)
  local pos, dir, rot, state = self.trainData:CalculateTransform(ts)
  if state == CarriageState.Turn then
  elseif state == CarriageState.PullIn then
    self.fsm:ChangeState(CarriageState.PullIn)
  elseif state == CarriageState.Straight then
    self.fsm:ChangeState(CarriageState.Straight, pos, dir, rot)
  end
end

function CarriageStateTurn:HandleInput(input, param)
end

return CarriageStateTurn
