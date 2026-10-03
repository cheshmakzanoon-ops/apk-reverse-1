local CarriageStatePullIn = BaseClass("CarriageStatePullIn")
local SHADOW_ZERO = {
  [1] = -31,
  [2] = -23,
  [3] = -14.5,
  [4] = 22
}
local SHADOW_RATIO = {
  [1] = 8,
  [2] = 8.5,
  [3] = 9.5,
  [4] = 10
}

function CarriageStatePullIn:__init(carriage)
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

function CarriageStatePullIn:__delete()
  self.carriage = nil
  self.trainData = nil
  self.fsm = nil
  self.mpb = nil
  self.mpbShadow = nil
end

function CarriageStatePullIn:OnEnter(pos, dir, rot, percent)
  if self.carriage.index == 1 then
    self.carriage.train:OnPullInStart(pos, dir, rot, percent)
  end
  if self.type == TrainType.Train then
    if self.carriage.transparentMat == nil then
      return
    end
    self.carriage.renderer.sharedMaterial = self.carriage.transparentMat
    self.mpb:SetFloat("_Opposite", -1 * self.carriage.opposite)
    self.mpbShadow:SetFloat("_Opposite", -1)
    self.mpbShadow:SetInt("_FadeOn", 1)
    self:SetTransParent(percent)
  else
    self.carriage:SetActive(false)
  end
end

function CarriageStatePullIn:OnExit()
  if self.type == TrainType.Train then
    self.carriage.renderer.sharedMaterial = self.carriage.defaultMat
  else
    self.carriage:SetActive(true)
  end
end

function CarriageStatePullIn:OnUpdate(ts)
  local pos, dir, rot, state, percent = self.trainData:CalculateTransform(ts)
  if state == CarriageState.PullIn then
    if self.carriage.index == 1 then
      self.carriage.train:OnPullInUpdate()
    end
    self:SetTransParent(percent)
  else
    self.fsm:ChangeState(state, pos, dir, rot, percent)
  end
end

function CarriageStatePullIn:SetTransParent(percent)
  if self.type == TrainType.Train then
    self.mpb:SetFloat("_Distance", percent * self.transparentDistanceBase)
    self.carriage.renderer:SetPropertyBlock(self.mpb)
  end
end

return CarriageStatePullIn
