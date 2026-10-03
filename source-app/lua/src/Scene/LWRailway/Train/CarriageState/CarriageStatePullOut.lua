local CarriageStatePullOut = BaseClass("CarriageStatePullOut")
local SHADOW_ZERO = {
  [1] = 30.5,
  [2] = 22,
  [3] = 13.3,
  [4] = -23
}
local SHADOW_RATIO = {
  [1] = -8.5,
  [2] = -8.5,
  [3] = -9.5,
  [4] = -10
}

function CarriageStatePullOut:__init(carriage)
  self.carriage = carriage
  self.trainData = self.carriage.train.trainData
  self.fsm = self.carriage.fsm
  self.mpb = self.carriage.mpb
  self.mpbShadow = self.carriage.mpbShadow
  self.type = self.trainData.type
  self.shadowZero = SHADOW_ZERO[self.carriage.prefabIndex]
  self.shadowRatio = SHADOW_RATIO[self.carriage.prefabIndex]
  self.transparentDistanceBase = carriage.ur and 6 or 4
end

function CarriageStatePullOut:__delete()
  self.carriage = nil
  self.trainData = nil
  self.fsm = nil
  self.mpb = nil
  self.mpbShadow = nil
end

function CarriageStatePullOut:OnEnter(pos, dir, rot, percent)
  if self.carriage.index == 1 then
    self.carriage.train:OnPullOutStart(pos, dir, rot, percent)
  end
  if self.type == TrainType.Train then
    if self.carriage.transparentMat == nil then
      return
    end
    self.carriage.renderer.sharedMaterial = self.carriage.transparentMat
    self.mpb:SetFloat("_Opposite", self.carriage.opposite)
    self.mpbShadow:SetFloat("_Opposite", 1)
    self.mpbShadow:SetInt("_FadeOn", 1)
    self:SetTransParent(percent)
  end
end

function CarriageStatePullOut:OnExit()
  if self.type == TrainType.Train then
    self.carriage.renderer.sharedMaterial = self.carriage.defaultMat
  end
end

function CarriageStatePullOut:OnUpdate(ts)
  local pos, dir, rot, state, percent = self.trainData:CalculateTransform(ts)
  if state == CarriageState.PullOut then
    self:SetTransParent(percent)
  else
    self.fsm:ChangeState(state, pos, dir, rot, percent)
  end
end

function CarriageStatePullOut:SetTransParent(percent)
  if self.type == TrainType.Train then
    self.mpb:SetFloat("_Distance", (1 - percent) * self.transparentDistanceBase)
    self.carriage.renderer:SetPropertyBlock(self.mpb)
  end
end

return CarriageStatePullOut
