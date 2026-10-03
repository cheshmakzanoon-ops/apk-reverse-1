local SurfingObjectMoveState = BaseClass("SurfingObjectMoveState")

function SurfingObjectMoveState:Init(unit)
  self.unit = unit
  self.move_speed = 0
  self.metaZ = 0
  self.stageSceneIndex = -1
  self.triggerLine = 0
  self.triggerLineOffset = 0
  self.speedChangeTime = 0
  if unit then
    self.move_speed = unit.move_speed
    self.metaZ = unit.metaZ
    self.stageSceneIndex = unit.stageSceneIndex
    self.triggerLine = unit.triggerLine
    self.triggerLineOffset = unit.triggerLineOffset
    self.speedChangeTime = self.unit.logic.speedChangeTime
  end
  self.cachePos = Vector3.New(0, 0, 0)
  self.offsetZ = 0
end

function SurfingObjectMoveState:__delete()
  self.unit = nil
  self.move_speed = nil
  self.offsetZ = nil
end

function SurfingObjectMoveState:OnEnter()
  if self.unit then
    self.unit:PlaySimpleAnim(AnimName.Walk, 1)
  end
end

function SurfingObjectMoveState:OnExit()
end

function SurfingObjectMoveState:OnUpdate(deltaTime)
  if self.unit and self.unit.logic then
    if self.unit.isMoving then
      return
    end
    local logic = self.unit.logic
    local curScene = logic.curScene
    if curScene and curScene.sceneData.config.groupId == self.stageSceneIndex then
      local sceneInfo = curScene.sceneData.config
      local sceneStartSpeed = sceneInfo.startSpeed
      local sceneEndSpeed = sceneInfo.endSpeed
      local triggerTime = 0
      if sceneStartSpeed == sceneEndSpeed then
        triggerTime = self.triggerLineOffset / sceneStartSpeed
      else
        local changeZ = (sceneStartSpeed + sceneEndSpeed) * 0.5 * self.speedChangeTime
        if changeZ >= self.triggerLineOffset then
          triggerTime = self.triggerLineOffset * 2 / (sceneStartSpeed + sceneEndSpeed)
        else
          triggerTime = self.speedChangeTime + (self.triggerLineOffset - changeZ) / sceneEndSpeed
        end
      end
      local runTime = logic.totalRunTime - curScene.sceneData.config.baseTime - triggerTime
      if 0 <= runTime then
        local runZ = runTime * self.move_speed
        self.cachePos.x = self.unit.x
        self.cachePos.y = self.unit.y
        self.cachePos.z = self.metaZ - runZ + logic.renderOffsetZ
        self.offsetZ = runZ
        self.unit:SetLocalPosition(self.cachePos)
        return
      end
    end
    local deltaPosZ = self.move_speed * deltaTime
    self.offsetZ = self.offsetZ + deltaPosZ
    local curPos = self.unit:GetPosition()
    self.cachePos.x = curPos.x
    self.cachePos.y = curPos.y
    self.cachePos.z = self.metaZ + logic.renderOffsetZ - self.offsetZ
    self.unit:SetLocalPosition(self.cachePos)
  end
end

return SurfingObjectMoveState
