local WorldFakeBattleZombie = BaseClass("WorldFakeBattleZombie")
local DisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
local ZOMBIE_PREFAB_POOL
local increaseId = 1
local __Inst_Pool = {}

function WorldFakeBattleZombie.Create(startPos, endPos, buuid)
  local inst
  if 0 < #__Inst_Pool then
    inst = table.remove(__Inst_Pool)
  else
    inst = WorldFakeBattleZombie.New()
  end
  inst:Initialize(startPos, endPos, buuid)
  return inst
end

function WorldFakeBattleZombie.Return(inst)
  if inst == nil then
    return
  end
  inst:Clear()
  table.insert(__Inst_Pool, inst)
end

function WorldFakeBattleZombie.ReleaseAll()
  for i = 1, #__Inst_Pool do
    __Inst_Pool[i]:Delete()
  end
  __Inst_Pool = {}
end

function WorldFakeBattleZombie:__init()
  if ZOMBIE_PREFAB_POOL == nil then
    ZOMBIE_PREFAB_POOL = {
      "Assets/Main/Prefabs/Monsters/WorldMonster03_secret.prefab",
      "Assets/Main/Prefabs/Monsters/WorldMonster02_secret.prefab",
      "Assets/Main/Prefabs/Monsters/WorldMonster01_secret.prefab"
    }
  end
end

function WorldFakeBattleZombie:__delete()
  self:Clear()
end

function WorldFakeBattleZombie:Initialize(startPos, endPos, buuid)
  self.id = increaseId
  increaseId = increaseId + 1
  self.hp = 1
  self.startPos = startPos
  self.endPos = endPos
  self.pos = startPos
  self.buuid = buuid
  self.isActive = true
  self.transformValid = false
  self.modelPath = ZOMBIE_PREFAB_POOL[math.random(#ZOMBIE_PREFAB_POOL)]
  self.resHandle = CS.GameEntry.Resource:InstantiateAsync(self.modelPath, ObjectPoolTag.Normal, LoadPriority.Low)
  self.resHandle:completed("+", function(handle)
    if IsNull(handle.gameObject) then
      Logger.LogError("load res failed:" .. self.modelPath)
      DataCenter.WorldFakeBattleManager:DestroyZombie(self.id, self.buuid)
      return
    end
    self.gameObject = handle.gameObject
    self.gameObject:SetActive(self.isActive)
    self.transform = self.gameObject.transform
    self.transformValid = true
    self.transform.position = startPos
    self.transform.localScale = Vector3(1, 1, 1)
    self.hurtVfxDummy = self.transform:Find("Skin/To_unity/DeformationSystem/Root/guadian_R")
    self.animator = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
    local direction = self.endPos - self.startPos
    self.transform.rotation = Quaternion.LookRotation(Vector3(direction.x, 0, direction.z), Vector3.up)
    self.animator:CrossFade("run", 0)
  end)
end

function WorldFakeBattleZombie:UpdateDisplayMode()
  local displayLevel = DisplaySettings.Levels.High
  self.isActive = DisplaySettings.PlayBattleSkills(displayLevel)
  if self.gameObject then
    self.gameObject:SetActive(self.isActive)
    self.animator:CrossFade("run", 0)
  end
end

function WorldFakeBattleZombie:Clear()
  self.id = nil
  self.hp = nil
  self.bUUId = nil
  self.modelPath = nil
  self.isActive = false
  if self.DestoryTimer then
    self.DestoryTimer:Stop()
    self.DestoryTimer = nil
  end
  if self.DelayDeadPerfTimer then
    self.DelayDeadPerfTimer:Stop()
    self.DelayDeadPerfTimer = nil
  end
  if not IsNull(self.resHandle) then
    self.resHandle:Destroy()
    self.resHandle = nil
  end
  self.gameObject = nil
  self.transform = nil
  self.transformValid = nil
  self.animator = nil
end

function WorldFakeBattleZombie:Update(dt)
  if not self.transformValid then
    return
  end
  if self.hp <= 0 then
    return
  end
  if Vector3.Distance(self.endPos, self.pos) > 0.01 then
    local vx, vz = self.endPos.x - self.pos.x, self.endPos.z - self.pos.z
    local vnum = math.sqrt(vx * vx + vz * vz)
    local nx, nz = vx / vnum, vz / vnum
    local distance = vnum
    local deltaDist = 1 * dt
    if distance < deltaDist then
      self.transform:Set_position(self.endPos.x, 0, self.endPos.z)
      self.pos:Set(self.endPos.x, 0, self.endPos.z)
    else
      local px, pz = self.pos.x + nx * deltaDist, self.pos.z + nz * deltaDist
      self.transform:Set_position(px, 0, pz)
      self.pos:Set(px, 0, pz)
    end
  elseif self.attackTime and 0 < self.attackTime then
    self.attackTime = self.attackTime - dt
  else
    self.attackTime = 1
    self.animator:CrossFade("attack", 0.5)
  end
end

function WorldFakeBattleZombie:OnHurt()
  if not self.transformValid then
    return
  end
  if self.hp <= 0 then
    return
  end
  self.hp = self.hp - 1
  if self.hp <= 0 then
    self:DelayDeadPerformance()
    self:DelayDestroy()
  end
end

function WorldFakeBattleZombie:DelayDestroy()
  if self.DestoryTimer then
    self.DestoryTimer:Stop()
  end
  self.DestoryTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.DestoryTimer = nil
    DataCenter.WorldFakeBattleManager:DestroyZombie(self.id, self.buuid)
  end, 3)
end

function WorldFakeBattleZombie:DelayDeadPerformance()
  if self.DelayDeadPerfTimer then
    self.DelayDeadPerfTimer:Stop()
  end
  local random = math.random(5, 10) * 0.1
  self.DelayDeadPerfTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.DelayDeadPerfTimer = nil
    self.animator:CrossFade("dead", 0.1)
  end, random)
end

return WorldFakeBattleZombie
