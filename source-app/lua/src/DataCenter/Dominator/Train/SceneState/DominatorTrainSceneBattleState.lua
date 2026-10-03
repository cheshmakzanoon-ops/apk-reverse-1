local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local Const = require("DataCenter/Dominator/Train/DominatorTrainSceneConstant")

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:Init()
end

function State:OnUpdate(dt)
  local owner = self.owner
  if owner then
    owner.unitMgr:OnUpdate()
    owner.effectObjMgr:OnUpdate()
    owner.bulletManager:OnUpdate()
  end
  if self.passedTime then
    self.passedTime = self.passedTime + dt
    if self.passedTime >= Const.BattleDuration then
      if owner then
        owner:ReleaseMonster()
        owner:ReloadMonster()
      end
      self.passedTime = 0
    end
  end
end

function State:OnExit()
  local owner = self.owner
  if owner then
    if owner.unitMgr then
      local allZombie = owner.unitMgr:GetAllZombie()
      if not table.IsNullOrEmpty(allZombie) then
        for i, v in pairs(allZombie) do
          owner.unitMgr:RemoveUnit(v)
        end
      end
      local allMember = owner.unitMgr:GetAllMember()
      if not table.IsNullOrEmpty(allMember) then
        for i, v in pairs(allMember) do
          owner.unitMgr:RemoveUnit(v)
        end
      end
    end
    if owner.effectObjMgr then
      owner.effectObjMgr:ResetData()
    end
    if owner.bulletManager then
      owner.bulletManager:ResetData()
    end
  end
end

function State:OnEnter(startAngle, endAngle)
  local owner = self.owner
  if owner then
    owner:SetToTopAngle()
    owner:ReloadDominatorBattle()
    owner:ReloadMonster()
  end
  self.passedTime = 0
end

function State:Dispose()
end

return State
