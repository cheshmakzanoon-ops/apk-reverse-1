local WorkerStateMove = BaseClass("WorkerStateMove")
local Const = require("Scene.BuildDispatchingHero.Const")
local workerPos

function WorkerStateMove:__init(worker)
  self.worker = worker
  self.pathList = {}
end

function WorkerStateMove:OnEnter(moveState, isWork)
  self.pathList = {}
  local pos = self.worker:GetPosition()
  self.startPos = pos
  if moveState == Const.WorkerMoveEndState.startPos then
    self.playerEndPos = self.worker.startPos.entry
    self.endPos = self.worker.startPos.entry
  else
    self.playerEndPos = self.worker.endPos.entry
    self.endPos = self.worker.endPos.entry
  end
  if Vector3.Distance(self.worker:GetPosition(), self.endPos) > 0.05 then
    self.pathList = DataCenter.InnerCityMapManager:FindPath(self.startPos, self.endPos)
    if self.pathList then
      if #self.pathList >= 2 then
        table.remove(self.pathList, 1)
        table.remove(self.pathList, #self.pathList)
      end
      if self.pathList and #self.pathList > 0 then
        self.endPos = self.pathList[1]
      end
    end
  end
  local distance = Vector3.Distance(self.startPos, self.endPos)
  local anim = isWork and Const.WorkerAnim.Run or Const.WorkerAnim.Walk
  self.speed = isWork and self.worker.data.runSpeed or self.worker.data.walkSpeed
  if 0.05 < distance then
    self.worker:PlayAnim(anim)
  end
  if self.endPos ~= self.startPos then
    local lookRot = Quaternion.LookRotation(Vector3.Normalize(self.endPos - self.startPos), Vector3.up)
    self.worker:SetRotation(lookRot)
  end
  self.speed = self.speed and self.speed or Const.moveSpeed
end

function WorkerStateMove:OnExit()
end

function WorkerStateMove:OnUpdate()
  workerPos = self.worker:GetPosition()
  if IsNull(self.endPos) or self.speed == nil or IsNull(workerPos) or IsNull(self.playerEndPos) then
    return
  end
  if Vector3.Distance(workerPos, self.endPos) > 0.05 then
    self.worker:SetPosition(Vector3.MoveTowards(workerPos, Vector3.New(self.endPos.x, self.endPos.y, self.endPos.z), Time.deltaTime * self.speed))
  elseif self.pathList and #self.pathList > 1 then
    table.remove(self.pathList, 1)
    self.endPos = self.pathList[1]
    local lookRot = Quaternion.LookRotation(Vector3.Normalize(self.endPos - workerPos), Vector3.up)
    self.worker:SetRotation(lookRot)
  elseif Vector3.Distance(workerPos, self.playerEndPos) > 0.05 then
    self.endPos = self.playerEndPos
    local lookRot = Quaternion.LookRotation(Vector3.Normalize(self.endPos - workerPos), Vector3.up)
    self.worker:SetRotation(lookRot)
  else
    self.worker:OnArriveWayPoint()
  end
end

return WorkerStateMove
