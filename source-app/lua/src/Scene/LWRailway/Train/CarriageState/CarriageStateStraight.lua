local CarriageStateStraight = BaseClass("CarriageStateStraight")

function CarriageStateStraight:__init(carriage)
  self.carriage = carriage
  self.trainData = self.carriage.train.trainData
  self.fsm = self.carriage.fsm
end

function CarriageStateStraight:__delete()
  self.carriage = nil
  self.trainData = nil
  self.fsm = nil
end

function CarriageStateStraight:OnEnter(pos, dir, rot)
  if self.carriage.index == 1 then
    self.carriage.train:OnStraightStart()
  end
end

function CarriageStateStraight:OnExit()
end

function CarriageStateStraight:OnUpdate(ts)
  local pos, dir, rot, state, percent = self.trainData:CalculateTransform(ts)
  if state ~= CarriageState.Straight then
    self.fsm:ChangeState(state, pos, dir, rot, percent)
  end
end

return CarriageStateStraight
