local CarriageStateHide = BaseClass("CarriageStateHide")

function CarriageStateHide:__init(carriage)
  self.carriage = carriage
  self.trainData = self.carriage.train.trainData
  self.fsm = self.carriage.fsm
end

function CarriageStateHide:__delete()
  self.carriage = nil
  self.trainData = nil
  self.fsm = nil
end

function CarriageStateHide:OnEnter(pos, dir, rot)
  self.carriage:SetActive(false)
  if self.carriage.index == 1 then
  end
end

function CarriageStateHide:OnExit()
  self.carriage:SetActive(true)
end

function CarriageStateHide:OnUpdate(ts)
  local pos, dir, rot, state, percent = self.trainData:CalculateTransform(ts)
  if state == CarriageState.Hide then
    if self.carriage.index == 1 then
      self.carriage.train:OnPullInUpdate()
    end
  else
    self.fsm:ChangeState(state, pos, dir, rot, percent)
  end
end

return CarriageStateHide
