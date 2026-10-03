local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local Resource = CS.GameEntry.Resource
local MobileTouchCamera = CS.BitBenderGames.MobileTouchCamera
local Constant = require("Scene.LWHummerScene.LWHummerSceneConstant")

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:Init()
  self.syncCamera = true
  self.canInput = true
end

function State:OnEnter()
  if self.owner and self.owner.player then
    self.owner.player:ChangeState(self.owner.player.State.Run)
    self.owner:RefreshNextRewardTime()
  end
  self.zombieSpawnDelta = 0
  self.zombieNum = 0
  self.triggerSpawnDelta = 0
  self.jumpZombieSpawnDelta = 0
  self.jumpZombieNum = 0
end

function State:OnExit()
end

function State:Dispose()
end

function State:OnUpdate(deltaTime)
  local owner = self.owner
  if owner.player then
    local type = owner.fingerDown and owner.data.ZombiePoolType.Special or owner.data.ZombiePoolType.Normal
    if owner.player.curState == owner.player.State.Run then
      if not self.zombieSpawnDelta then
        self.zombieSpawnDelta, self.zombieNum = owner.data:GetRandomZombieSpawnData(type)
      else
        self.zombieSpawnDelta = self.zombieSpawnDelta - deltaTime
        if self.zombieSpawnDelta <= 0 then
          for i = 1, self.zombieNum do
            owner:AddZombie(type)
          end
          self.zombieSpawnDelta = nil
          self.zombieNum = 0
        end
      end
      if not self.triggerSpawnDelta then
        self.triggerSpawnDelta = owner.data:GetRandomTriggerSpawnDelta()
      else
        self.triggerSpawnDelta = self.triggerSpawnDelta - deltaTime
        if 0 >= self.triggerSpawnDelta then
          self.triggerSpawnDelta = nil
          owner:AddTrigger()
        end
      end
      if not self.jumpZombieSpawnDelta then
        self.jumpZombieSpawnDelta, self.jumpZombieNum = owner.data:GetRandomZombieSpawnData(owner.data.ZombiePoolType.Drop)
      else
        self.jumpZombieSpawnDelta = self.jumpZombieSpawnDelta - deltaTime
        if 0 >= self.jumpZombieSpawnDelta then
          for i = 1, self.jumpZombieNum do
            owner:AddJumpZombie()
          end
          self.jumpZombieSpawnDelta = nil
          self.jumpZombieNum = 0
        end
      end
    end
    if owner.rvoMgr then
      local playerPos = owner.player:GetPosition()
      owner.rvoMgr:Update(playerPos.x, playerPos.z)
    end
  end
  if owner.nextRewardTime then
    if 0 > owner.nextRewardTime then
      for i = 1, owner.data:GetRewardZombieNum() do
        owner:AddZombie(owner.data.ZombiePoolType.Normal)
      end
      owner:RefreshNextRewardTime()
    else
      owner.nextRewardTime = owner.nextRewardTime - deltaTime
    end
  end
end

return State
