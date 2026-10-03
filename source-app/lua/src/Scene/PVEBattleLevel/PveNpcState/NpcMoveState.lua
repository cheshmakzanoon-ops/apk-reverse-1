local NpcMoveState = BaseClass("NpcMoveState")
local RotationAnimTime = 0.2
local MovePerGridSpeed = 4
local RotationDeltaX = 0.8
local RotationDeltaY = 0.45

function NpcMoveState:__init(npc)
  self.npc = npc
  self.walkIndex = 1
  self.isRotation = false
  self.startRotation = nil
  self.endRotation = nil
  self.rotationTime = 0
  self.moveArr = {}
end

function NpcMoveState:__delete()
end

function NpcMoveState:OnEnter(param)
  self.param = param
  local count = table.count(self.param.posArr)
  self.moveArr = {}
  if count == 2 then
    local startPos = SceneUtils.TileToWorld(self.param.posArr[1])
    local endPos = SceneUtils.TileToWorld(self.param.posArr[2])
    local rotation, startNearPos, endNearPos = self:GetPathVec(startPos, endPos)
    local posVec = {}
    posVec.startPos = startPos
    posVec.endPos = endPos
    posVec.startRotation = rotation
    posVec.endRotation = rotation
    posVec.time = Vector3.Distance(posVec.startPos, posVec.endPos) / MovePerGridSpeed
    table.insert(self.moveArr, posVec)
  else
    local lastVec, lastPos
    for k, v in ipairs(self.param.posArr) do
      local curPos = SceneUtils.TileToWorld(v)
      local posVec = {}
      if k == 1 then
        posVec.startPos = curPos
        table.insert(self.moveArr, posVec)
      elseif k == count then
        local rotation, startNearPos, endNearPos = self:GetPathVec(lastPos, curPos)
        lastVec.endPos = startNearPos
        lastVec.endRotation = rotation
        posVec.startPos = startNearPos
        posVec.endPos = endNearPos
        posVec.startRotation = rotation
        posVec.endRotation = rotation
        posVec.time = Vector3.Distance(posVec.startPos, posVec.endPos) / MovePerGridSpeed
        table.insert(self.moveArr, posVec)
      elseif k == 2 then
        local rotation, startNearPos, endNearPos = self:GetPathVec(lastPos, curPos)
        lastVec.endPos = endNearPos
        lastVec.startRotation = rotation
        lastVec.endRotation = rotation
        lastVec.time = Vector3.Distance(lastVec.startPos, lastVec.endPos) / MovePerGridSpeed
        posVec.startPos = endNearPos
        posVec.startRotation = rotation
        posVec.time = RotationAnimTime
        table.insert(self.moveArr, posVec)
      else
        local rotation, startNearPos, endNearPos = self:GetPathVec(lastPos, curPos)
        lastVec.endPos = startNearPos
        lastVec.endRotation = rotation
        local movePosVec = {}
        movePosVec.startPos = startNearPos
        movePosVec.endPos = endNearPos
        movePosVec.startRotation = rotation
        movePosVec.endRotation = rotation
        movePosVec.time = Vector3.Distance(movePosVec.startPos, movePosVec.endPos) / MovePerGridSpeed
        table.insert(self.moveArr, movePosVec)
        posVec.startPos = endNearPos
        posVec.startRotation = rotation
        posVec.time = RotationAnimTime
        table.insert(self.moveArr, posVec)
      end
      lastVec = posVec
      lastPos = curPos
    end
  end
  self.curTime = 0
  self.walkIndex = 1
  self.npc:SetRotation(self.moveArr[self.walkIndex].endRotation)
  self.npc:SetPosition(SceneUtils.TileToWorld(self.param.posArr[1]))
end

function NpcMoveState:OnExit()
end

function NpcMoveState:OnUpdate(deltaTime)
  self.curTime = self.curTime + deltaTime
  local percent = self.curTime / self.moveArr[self.walkIndex].time
  if 1 <= percent then
    self.curTime = 0
    self.npc:SetPosition(self.moveArr[self.walkIndex].endPos)
    self.npc:SetRotation(self.moveArr[self.walkIndex].endRotation)
    if self.walkIndex + 1 > table.count(self.moveArr) then
      if self.param.angle ~= nil then
        self.npc:ChangeState(self.npc.State.Rotation, self.param)
      else
        self.npc:CheckNext()
        self.npc:ChangeState(self.npc.State.Idle)
      end
    else
      self.walkIndex = self.walkIndex + 1
    end
  else
    self.npc:SetPosition(Vector3.Lerp(self.moveArr[self.walkIndex].startPos, self.moveArr[self.walkIndex].endPos, percent))
    if self.moveArr[self.walkIndex].startRotation ~= self.moveArr[self.walkIndex].endRotation then
      self.npc:SetRotation(Quaternion.Lerp(self.moveArr[self.walkIndex].startRotation, self.moveArr[self.walkIndex].endRotation, percent))
    end
  end
end

function NpcMoveState:GetPathVec(startPos, endPos)
  if endPos.x == startPos.x then
    if endPos.z > startPos.z then
      return Quaternion.Euler(0, 180, 0), {
        x = startPos.x,
        y = 0,
        z = startPos.z + RotationDeltaX
      }, {
        x = startPos.x,
        y = 0,
        z = endPos.z - RotationDeltaY
      }
    else
      return Quaternion.Euler(0, 0, 0), {
        x = startPos.x,
        y = 0,
        z = startPos.z - RotationDeltaX
      }, {
        x = startPos.x,
        y = 0,
        z = endPos.z + RotationDeltaY
      }
    end
  elseif endPos.x > startPos.x then
    return Quaternion.Euler(0, -90, 0), {
      x = startPos.x + RotationDeltaX,
      y = 0,
      z = startPos.z
    }, {
      x = endPos.x - RotationDeltaY,
      y = 0,
      z = startPos.z
    }
  else
    return Quaternion.Euler(0, 90, 0), {
      x = startPos.x - RotationDeltaX,
      y = 0,
      z = startPos.z
    }, {
      x = endPos.x + RotationDeltaY,
      y = 0,
      z = startPos.z
    }
  end
end

return NpcMoveState
