local Resource = CS.GameEntry.Resource
local DisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
local base = require("Scene.LWWorldMarch.WorldUnit")
local WorldDrone = BaseClass("WorldDrone", base)

function WorldDrone:Init(battleManager, squad, guid, req, weaponData, appearanceMeta)
  base.Init(self, battleManager, guid)
  self.battleMgr = battleManager
  self.squad = squad
  self.m_req = req
  self.guid = guid
  self.unitType = UnitType.Member
  self.searchType = BattleSearchType.Member
  self.gameObject = nil
  self.weaponData = weaponData
  self:InitWeaponData()
  self.timeCount = 0
  self.maxBlood = 1
  self.curBlood = 1
  if weaponData and appearanceMeta == nil then
    self.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(weaponData:GetAppearance())
  else
    self.appearanceMeta = appearanceMeta
  end
  self.modelPath = self.appearanceMeta and self.appearanceMeta.world_model_path
  local offset = self.squad.formation.GetWeaponOffsetByIndex(self.squad:GetMemberTotalCount())
  local csVec = self.squad.transform:TransformVector(offset)
  self.curWorldPos.x, self.curWorldPos.y, self.curWorldPos.z = csVec.x, csVec.y, csVec.z
  self.bullets = {}
  self.delayEvents = {}
end

function WorldDrone:DestroyView()
  base.DestroyView(self)
  if self.transform then
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.transform:Set_eulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  end
  self.gameObject = nil
  self.transform = nil
  if self.m_req ~= nil then
    self.m_req:Destroy()
    self.m_req = nil
  end
  self.firePoint = nil
  self.animNameCache = nil
  self.targetPosCache = nil
  for _, v in pairs(self.delayEvents) do
    v:Stop()
  end
  self.delayEvents = {}
  self.anim = nil
end

function WorldDrone:DestroyData()
  base.DestroyData(self)
  self.squad = nil
  self.weaponData = nil
  self.bulletMotionEditor = nil
  self.isActive = nil
end

function WorldDrone:OnCreate()
  if self.m_req ~= nil then
    self.gameObject = self.m_req.gameObject
    self.transform = self.gameObject.transform
    if self.appearanceMeta then
      local fire_paths = self.appearanceMeta.fire_paths
      self.firePoints = {}
      for i, v in ipairs(fire_paths) do
        local firePoint = self.transform:Find(v)
        if not firePoint then
          Logger.LogError("\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\232\183\175\229\190\132\228\184\141\229\186\148\229\140\133\229\144\171\233\162\132\229\136\182\228\189\147\229\144\141\239\188\140\229\164\150\232\167\130id\239\188\154" .. self.hero.modelId .. "\239\188\140\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\239\188\154" .. v)
        end
        table.insert(self.firePoints, firePoint)
      end
      self.firePoint = self.firePoints[1]
    end
  end
  self.transform:SetParent(self.squad.transform)
  local offset = self.squad.formation.GetWeaponOffsetByIndex(self.squad:GetMemberTotalCount())
  self:SetLocalPosition(offset)
  self.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  self:ComponentDefine()
  self:UpdateDisplayMode()
  if self.animNameCache then
    self:PlayAnim(self.animNameCache, self.rewindCache)
  end
  if self.targetPosCache then
    self:Attack(self.targetPosCache, self.attackIndexCache)
  end
end

function WorldDrone:UpdateDisplayMode()
  local displayLevel = self.squad.displayLevel
  self.isActive = not DisplaySettings.DisplayHeroAsIcon(displayLevel) and not DisplaySettings.OnlyDisplayLeader(displayLevel)
  if self.gameObject then
    local preState = self.gameObject.activeSelf
    local curAnim = self.curAnimName
    self.gameObject:SetActive(self.isActive)
    if not preState and self.isActive then
      self:PlaySimpleAnim(curAnim)
    end
  elseif self.isActive then
    if self.m_req == nil and self.modelPath then
      self.m_req = Resource:InstantiateAsync(self.modelPath, ObjectPoolTag.Normal, LoadPriority.Low)
      self.m_req:completed("+", function(request)
        if self.m_req.isError then
          return
        end
        self:OnCreate()
      end)
    end
  elseif self.m_req then
    self.m_req:Destroy()
    self.m_req = nil
  end
end

function WorldDrone:InitWeaponData()
  if not self.weaponData then
    Logger.LogError("\232\142\183\229\143\150\230\136\152\230\156\175\230\173\166\229\153\168\230\149\176\230\141\174\229\164\177\232\180\165\239\188\140heroUuid\239\188\154")
    return
  end
  self.levelTemplate = self.weaponData.levelTemplate
  local skillInfos = self.weaponData:GetSkillInfos()
  for _, skillInfo in pairs(skillInfos) do
    self.skillManager:AddSkill(skillInfo.skillTemplateData, skillInfo, false, true)
    break
  end
end

function WorldDrone:GetRawProperty(theType)
  if self.weaponData == nil then
    return 0
  end
  return self.weaponData:GetProperty(theType)
end

function WorldDrone:ComponentDefine()
  base.ComponentDefine(self)
  self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  if not self.anim then
    Logger.LogError("\232\175\165\229\141\149\228\189\141\228\184\139\233\157\162\230\178\161\230\140\130SimpleAnimation\232\132\154\230\156\172\239\188\140gameObject:" .. self.gameObject.name)
  end
  if self.appearanceMeta then
    self.transform:Set_localScale(self.appearanceMeta.model_size, self.appearanceMeta.model_size, self.appearanceMeta.model_size)
  end
end

function WorldDrone:SetLocalPosition(pos)
  self.transform.localPosition = pos
end

function WorldDrone:GetTransform()
  return self.transform
end

function WorldDrone:GetGameObject()
  return self.gameObject
end

function WorldDrone:GetFirePoint()
  if self.firePoint ~= nil then
    return self.firePoint, false
  end
  if self.transform ~= nil then
    return self.transform, false
  end
  return Vector3.New(0, 0, 0), false
end

function WorldDrone:GetFirePointById(id)
  if self.firePoints and self.firePoints[id] then
    return self.firePoints[id], false
  end
  return self:GetFirePoint()
end

function WorldDrone:CreateBullet(targetPos)
  local firePointTransform = self:GetFirePoint()
  local srcPos = firePointTransform.position
  local dstPos = targetPos
  local vec = dstPos - srcPos
  local handle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/LWGateDefence/Bullet.prefab")
  handle:completed("+", function(handle)
    local trans = handle.gameObject.transform
    trans.position = srcPos
    trans.localScale = Vector3(1, 1, 0.01)
    trans.forward = vec
    trans:DOScale(Vector3(1, 1, 3), 0.1)
    table.insert(self.bullets, {
      handle = handle,
      trans = trans,
      dstPos = dstPos,
      dir = vec.normalized,
      hit = false
    })
  end)
end

function WorldDrone:OnBulletHit(bullet)
  if bullet.handle ~= nil and not IsNull(bullet.handle) then
    bullet.handle:Destroy()
    bullet.handle = nil
  end
end

function WorldDrone:DestroyBullets()
  for _, v in pairs(self.bullets) do
    self:OnBulletHit(v)
  end
  self.bullets = {}
end

local BULLET_SPEED = 50

function WorldDrone:OnUpdate()
  local dt = Time.deltaTime
  for i = #self.bullets, 1, -1 do
    local bullet = self.bullets[i]
    local dstPos = bullet.dstPos
    local trans = bullet.trans
    local deltaMove = BULLET_SPEED * dt
    if (trans.position - dstPos).sqrMagnitude <= deltaMove * deltaMove then
      table.remove(self.bullets, i)
      self:OnBulletHit(bullet)
    else
      trans.position = trans.position + bullet.dir * deltaMove
    end
  end
end

function WorldDrone:AddDelayEvent(event, delay)
  local timer = TimerManager:GetInstance():DelayInvoke(event, delay)
  table.insert(self.delayEvents, timer)
end

function WorldDrone:PlayAnim(anim, rewind)
  if not self.gameObject then
    self.animNameCache = anim
    self.rewindCache = rewind
    return
  end
  if anim ~= "attack" or not self.tacWeaponMembersAttack then
    if rewind == true then
      self:AddDelayEvent(function()
        self:RewindAndPlaySimpleAnim(anim)
      end, math.random() * 0.2)
    else
      self:PlaySimpleAnim(anim)
    end
  end
  if anim ~= "attack" then
    self:DestroyBullets()
    self.tacWeaponMembersAttack = false
  else
    self.tacWeaponMembersAttack = true
  end
  self.animNameCache = nil
  self.rewindCache = nil
end

function WorldDrone:Attack(targetPos, index)
  if not self.isActive then
    return
  end
  if index == nil or index == 0 or index == self.index then
    if not self.gameObject then
      self.targetPosCache = targetPos
      self.attackIndexCache = index
      return
    end
    local skill = self.skillManager:GetFirstActiveSkill()
    if skill then
      self:AddDelayEvent(function()
        skill:SetTarget(targetPos)
        skill:RealFire()
      end, math.random() * 0.4)
    end
    self.targetPosCache = nil
    self.attackIndexCache = nil
  end
end

return WorldDrone
