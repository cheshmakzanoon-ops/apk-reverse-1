local Resource = CS.GameEntry.Resource
local Physics = CS.UnityEngine.Physics
local Const = require("Scene.PVEBattleLevel.Const")
local TriggerPointTurret = BaseClass("TriggerPointTurret")
local TurretGun = BaseClass("TurretGun")
local State = {
  Idle = 1,
  Attack = 2,
  Dead = 3
}
local GunCount = 5

function TriggerPointTurret:__init()
  self.currState = State.Idle
  self.attackTargets = {}
  self.currBlood = 10
  self.colliderArray = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Collider), 100)
  self.freeGuns = {}
  self.fireGuns = {}
  self.isVisible = true
  self.stateObj = {}
end

function TriggerPointTurret:__delete()
end

function TriggerPointTurret:Create(triggerPoint, parentObj, attack, maxBlood, attackRadius)
  self.currBlood = maxBlood
  self.attackRadius = attackRadius
  self.triggerPoint = triggerPoint
  self.parentObj = parentObj
  self.requestObj = Resource:InstantiateAsync("Assets/Main/Prefabs/PVELevel/TriggerTurretHouse.prefab")
  self.requestObj:completed("+", function()
    local gameObject = self.requestObj.gameObject
    local transform = gameObject.transform
    transform.position = self.triggerPoint:GetPosition()
    self.gameObject = gameObject
    self.transform = transform
    self.gameObject:SetActive(self.isVisible)
    self.stateObj[1] = transform:Find("state01").gameObject
    self.stateObj[2] = transform:Find("state02").gameObject
    self.stateObj[3] = transform:Find("state03").gameObject
    self:ShowState(1)
    for i = 1, 5 do
      local gun = TurretGun.New(self, attack)
      gun:Create(transform:Find("state02/Player0" .. i).gameObject)
      self.freeGuns[i] = gun
    end
  end)
end

function TriggerPointTurret:Destroy()
  if self.requestObj then
    self.requestObj:Destroy()
    self.requestObj = nil
  end
end

function TriggerPointTurret:SetVisible(visible)
  self.isVisible = visible
  if self.gameObject then
    self.gameObject:SetActive(visible)
  end
end

function TriggerPointTurret:OnPreTriggerOK()
  self:ShowState(2)
  self.currState = State.Attack
end

function TriggerPointTurret:OnUpdate()
  if self.currState == State.Attack then
    self:DoSearchTarget()
    self:DoAttackTarget()
  end
end

function TriggerPointTurret:DoSearchTarget()
  local pos = self.triggerPoint:GetPosition()
  local layerMask = LayerMask.GetMask("Default")
  local radius = self.attackRadius
  local cnt = Physics.OverlapSphereNonAlloc(pos, radius, self.colliderArray, layerMask)
  if cnt <= 0 then
    self.attackTargets = nil
    return
  end
  self.attackTargets = self.attackTargets or {}
  for i = 1, cnt do
    local _collider = self.colliderArray[i - 1]
    local trigger = _collider:GetComponentInParent(typeof(CS.CitySpaceManTrigger))
    if trigger ~= nil and trigger.ObjectId ~= 0 and trigger.ObjectId >= Const.ZombieIdMin and trigger.ObjectId <= Const.ZombieIdMax then
      local obj = self.triggerPoint.battleLevel:GetObj(trigger.ObjectId)
      if obj ~= nil and 0 < obj:GetCurBlood() and self.attackTargets[trigger.ObjectId] == nil then
        self.attackTargets[trigger.ObjectId] = false
      end
    end
  end
end

function TriggerPointTurret:DoAttackTarget()
  if #self.freeGuns > 0 then
    for objId, v in pairs(self.attackTargets) do
      if v == false then
        local gun = table.remove(self.freeGuns)
        self.attackTargets[objId] = gun
        gun:SetTarget(objId)
        self.fireGuns[#self.fireGuns + 1] = gun
        if #self.freeGuns <= 0 then
          break
        end
      end
    end
  end
  while #self.freeGuns > 0 and next(self.attackTargets) ~= nil do
    for objId, v in pairs(self.attackTargets) do
      local gun = table.remove(self.freeGuns)
      self.attackTargets[objId] = gun
      gun:SetTarget(objId)
      self.fireGuns[#self.fireGuns + 1] = gun
      if #self.freeGuns <= 0 then
        break
      end
    end
  end
  for _, gun in ipairs(self.fireGuns) do
    gun:Fire()
  end
  for i = #self.fireGuns, 1, -1 do
    local gun = self.fireGuns[i]
    if gun:IsTargetDead() then
      self.freeGuns[#self.freeGuns + 1] = table.remove(self.fireGuns, i)
      gun:StopFire()
    end
  end
end

function TriggerPointTurret:BeAttack(hurt)
  self.currBlood = math.max(self.currBlood - hurt, 0)
  if self.currBlood <= 0 then
    self:Die()
  end
end

function TriggerPointTurret:Die()
  self.currState = State.Dead
  self:ShowState(3)
end

function TriggerPointTurret:ShowState(index)
  for i, v in ipairs(self.stateObj) do
    if i == index then
      self.stateObj[i]:SetActive(true)
    else
      self.stateObj[i]:SetActive(false)
    end
  end
end

local AnimTriggerList = {
  Stand_Attack = "Stand_Attack",
  Stand_StopAttack = "Stand_StopAttack"
}

function TurretGun:__init(turret, attack)
  self.turret = turret
  self.targetId = 0
  self.nextFireTime = 0
  self.attack = attack
end

function TurretGun:__delete()
end

function TurretGun:Create(gameObject)
  self.transform = gameObject.transform
  self.gameObject = gameObject
  self.animator = self.transform:Find("A_soldie_ben/A_soldie@ben_skin"):GetComponent(typeof(CS.UnityEngine.Animator))
  self.position = Vector3.New(self.transform:Get_position())
end

function TurretGun:SetNextFireTime()
  self.nextFireTime = Time.time + math.random() * 0.3
end

function TurretGun:Fire()
  self:PlayAnim("Stand_Attack")
  if self.nextFireTime > Time.time then
    local targetObj = self.turret.triggerPoint.battleLevel:GetObj(self.targetId)
    if targetObj ~= nil and targetObj:GetCurBlood() > 0 then
      targetObj:BeAttack(self.attack)
    end
    self:SetNextFireTime()
  end
end

function TurretGun:StopFire()
  self:PlayAnim("Stand_StopAttack")
end

function TurretGun:PlayAnim(anim)
  for i, v in ipairs(AnimTriggerList) do
    self.animator:ResetTrigger(v)
  end
  self.animator:SetTrigger(anim)
end

function TurretGun:SetTarget(targetId)
  self.targetId = targetId
  local targetObj = self.turret.triggerPoint.battleLevel:GetObj(self.targetId)
  if targetObj ~= nil and targetObj:GetCurBlood() > 0 then
    local dir = targetObj:GetPosition() - self.position
    dir.y = 0
    self.transform.forward = dir
    self:SetNextFireTime()
  end
end

function TurretGun:IsTargetDead()
  local targetObj = self.turret.triggerPoint.battleLevel:GetObj(self.targetId)
  if targetObj == nil or targetObj:GetCurBlood() <= 0 then
    return true
  end
  return false
end

return TriggerPointTurret
