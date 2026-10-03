local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local utils = require("DataCenter.LWGateDefenceManager.LWGateDefenceUtils")
local MNs = require("DataCenter.LWGateDefenceManager.LWGateDefenceMagicNumbers")

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:Reset()
  self.pathNodes = nil
  self.precalc = nil
  self.dstPosX = nil
  self.dstPosZ = nil
end

function State:OnEnter()
  if not self.pathNodes then
    self.pathIndex = 1
    self.pathNodes, self.precalc = utils.FindPath(self.owner.grid, self.owner.dstGrid, true)
    if not self.pathNodes then
      DataCenter.LWGateDefenceManager:DestroyHero(self.owner.heroUuid)
      return
    end
    self:MoveToNextNode()
  end
  self.owner.standAlready = false
  self:RandomSpeed()
end

function State:RandomSpeed()
  self.isRunning = true
  self.owner.animator:CrossFade("run", 0.5)
  self.moveSpeed = math.random() * (MNs.RunSpeedMax - MNs.RunSpeedMin) + MNs.RunSpeedMin
  self.rotateSpeed = 16
  self.lastTimer = math.random() * (MNs.RunLastTimeMax - MNs.RunLastTimeMin) + MNs.RunLastTimeMin
end

function State:MoveToNextNode()
  if not self.pathNodes then
    return
  end
  self.pathIndex = self.pathIndex + 1
  if self.precalc then
    local pathNodeKey = self.pathNodes[self.pathIndex]
    if pathNodeKey then
      local nextR = pathNodeKey // 1000
      local nextC = pathNodeKey - nextR * 1000
      self.dstPosX, self.dstPosZ = utils.Grid_2_World_XZ(nextR, nextC)
      local faceX, faceZ = nextC - self.owner.grid.col, nextR - self.owner.grid.row
      if self.owner.faceZ ~= faceZ or self.owner.faceX ~= faceX then
        self.owner.faceX, self.owner.faceZ = faceX, faceZ
        self.owner.transform:DOLookAt(Vector3(self.dstPosX, 0, self.dstPosZ), self.isRunning and 0.25 or 0.5)
      end
    else
      self.owner.fsm:Switch("Search")
    end
  else
    local nextNodeKey = self.pathNodes[self.pathIndex]
    if not nextNodeKey then
      self.owner.fsm:Switch("Search")
    else
      local nextR = nextNodeKey // 1000
      local nextC = nextNodeKey - nextR * 1000
      self.dstPosX, self.dstPosZ = utils.Grid_2_World_XZ(nextR, nextC)
      local faceX, faceZ = nextC - self.owner.grid.col, nextR - self.owner.grid.row
      if self.owner.faceZ ~= faceZ or self.owner.faceX ~= faceX then
        self.owner.faceX, self.owner.faceZ = faceX, faceZ
        self.owner.transform:DOLookAt(Vector3(self.dstPosX, 0, self.dstPosZ), self.isRunning and 0.25 or 0.5)
      end
    end
  end
end

function State:OnUpdate(deltaTime)
  if self.dstPosX and self.dstPosZ then
    local transform = self.owner.transform
    local x, _, z = transform:Get_position()
    local vx, vz = self.dstPosX - x, self.dstPosZ - z
    local vnum = math.sqrt(vx * vx + vz * vz)
    local nx, nz = vx / vnum, vz / vnum
    local distance = vnum
    local deltaDist = self.moveSpeed * deltaTime
    if distance < deltaDist then
      self.owner:SetPosition(self.dstPosX, 0, self.dstPosZ)
      self:MoveToNextNode()
    else
      local px, pz = x + nx * deltaDist, z + nz * deltaDist
      self.owner:SetPosition(px, 0, pz)
      self.lastTimer = self.lastTimer - deltaTime
      if 0 >= self.lastTimer then
        self:RandomSpeed()
      end
    end
  end
end

return State
