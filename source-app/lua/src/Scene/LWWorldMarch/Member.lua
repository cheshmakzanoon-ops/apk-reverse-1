local Resource = CS.GameEntry.Resource
local Const = require("Scene.LWBattle.Const")
local DisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
local base = require("Scene.LWBattle.BarrageBattle.Unit.BarrageUnit")
local Member = BaseClass("Member", base)

function Member:Init(battleManager, squad, guid, req, index, heroData)
  base.Init(self, battleManager, guid, heroData.meta)
  self.battleMgr = battleManager
  self.squad = squad
  self.m_req = req
  self.guid = guid
  self.unitType = UnitType.Member
  self.searchType = BattleSearchType.Member
  self.gameObject = nil
  self.index = index
  self.hero = heroData
  self.appearanceMeta = heroData and heroData.appearanceMeta
  self.modelPath = self.appearanceMeta and self.appearanceMeta.world_model_path
  self:InitHeroData()
  self.timeCount = 0
  self.maxBlood = 1
  self.curBlood = 1
  local offset = self.squad.formation.GetOffsetByIndex(self.index, self.squad:GetMemberTotalCount())
  local csVec = self.squad.transform:TransformVector(offset)
  self.curWorldPos.x, self.curWorldPos.y, self.curWorldPos.z = csVec.x, csVec.y, csVec.z
  self.bullets = {}
  self.delayEvents = {}
end

function Member:DestroyView()
  base.DestroyView(self)
  if self.fireHandle then
    self.fireHandle:Destroy()
    self.fireHandle = nil
    self.fireGO = nil
    self.fireTrans = nil
  end
  if self.gameObject then
    local skinnedMeshRenderer = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.SkinnedMeshRenderer), true)
    local meshRenderer = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.MeshRenderer), true)
    if skinnedMeshRenderer then
      for i = 0, skinnedMeshRenderer.Length - 1 do
        skinnedMeshRenderer[i].enabled = true
      end
    end
    if meshRenderer then
      for i = 0, meshRenderer.Length - 1 do
        meshRenderer[i].enabled = true
      end
    end
  end
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

function Member:DestroyData()
  base.DestroyData(self)
  self.squad = nil
  self.hero = nil
  self.bulletMotionEditor = nil
  self.isLeader = nil
  self.isActive = nil
end

function Member:OnCreate()
  if self.m_req ~= nil then
    self.gameObject = self.m_req.gameObject
    self.transform = self.gameObject.transform
    local fire_paths = self.hero.appearanceMeta.fire_paths
    self.firePoints = {}
    for i, v in ipairs(fire_paths) do
      local firePoint = self.transform:Find(v)
      if not firePoint then
        Logger.LogError("\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\232\183\175\229\190\132\228\184\141\229\186\148\229\140\133\229\144\171\233\162\132\229\136\182\228\189\147\229\144\141\239\188\140\229\164\150\232\167\130id\239\188\154" .. self.hero.appearanceMeta.id .. "\239\188\140\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\239\188\154" .. v)
      end
      table.insert(self.firePoints, firePoint)
    end
    self.firePoint = self.firePoints[1]
  end
  self.transform:SetParent(self.squad.transform)
  local offset = self.squad.formation.GetOffsetByIndex(self.index)
  self.transform:Set_localPosition(offset.x, offset.y, offset.z)
  self.transform:Set_localEulerAngles(0, 0, 0)
  self:ComponentDefine()
  self:UpdateDisplayMode()
  if self.animNameCache then
    self:PlayAnim(self.animNameCache, self.rewindCache)
  end
  if self.targetPosCache then
    self:Attack(self.targetPosCache, self.attackIndexCache)
  end
end

function Member:UpdateDisplayMode()
  local displayLevel = self.squad.displayLevel
  self.isActive = not DisplaySettings.DisplayHeroAsIcon(displayLevel) and (self.isLeader or not DisplaySettings.OnlyDisplayLeader(displayLevel))
  if self.gameObject then
    self.gameObject:SetActive(self.isActive)
    if self.isActive and self.isLeader then
      local offset = DisplaySettings.OnlyDisplayLeader(displayLevel) and Vector3.zero or self.squad.formation.GetOffsetByIndex(self.index)
      self.transform.localPosition = offset
    end
    self:UpdateFireEff()
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

function Member:InitHeroData()
  if not self.hero then
    Logger.LogError("\232\142\183\229\143\150\232\139\177\233\155\132\230\149\176\230\141\174\229\164\177\232\180\165\239\188\140heroUuid\239\188\154")
    return
  end
  self.meta = self.hero.meta
  for _, skillId in pairs(self.meta.skills) do
    local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
    if skillMeta and skillMeta:IsNormalAttack() then
      self.skillManager:AddSkill(skillMeta, nil, false, true)
      break
    end
  end
end

function Member:GetRawProperty(theType)
  if self.hero == nil or type(self.hero.GetHeroProperty) ~= "function" then
    return 0
  end
  return self.hero:GetHeroProperty(theType)
end

function Member:ComponentDefine()
  base.ComponentDefine(self)
  self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  if not self.anim then
    Logger.LogError("\232\175\165\229\141\149\228\189\141\228\184\139\233\157\162\230\178\161\230\140\130SimpleAnimation\232\132\154\230\156\172\239\188\140gameObject:" .. self.gameObject.name)
  end
  local appearanceMeta = self.hero.appearanceMeta
  local scaleFactor = self.squad.formation.GetScaleByIndex(self.index)
  self.transform:Set_localScale(appearanceMeta.model_size * scaleFactor, appearanceMeta.model_size * scaleFactor, appearanceMeta.model_size * scaleFactor)
end

function Member:GetTransform()
  return self.transform
end

function Member:GetGameObject()
  return self.gameObject
end

function Member:GetFirePoint()
  if self.firePoint ~= nil then
    return self.firePoint, false
  end
  if self.transform ~= nil then
    return self.transform, false
  end
  return Vector3.New(0, 0, 0), false
end

function Member:GetFirePointById(id)
  if self.firePoints and self.firePoints[id] then
    return self.firePoints[id], false
  end
  return self:GetFirePoint()
end

function Member:CreateBullet(targetPos)
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

function Member:OnBulletHit(bullet)
  if bullet.handle ~= nil and not IsNull(bullet.handle) then
    bullet.handle:Destroy()
    bullet.handle = nil
  end
end

function Member:DestroyBullets()
  for _, v in pairs(self.bullets) do
    self:OnBulletHit(v)
  end
  self.bullets = {}
end

local BULLET_SPEED = 50

function Member:OnUpdate(deltaTime)
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

function Member:SetOnFire(value)
  self.isOnFire = value
  self:UpdateFireEff()
end

function Member:UpdateFireEff()
  local displayOnFire = self.isOnFire and self.isActive
  if self.fireGO and self.fireTrans then
    self.fireGO:SetActive(displayOnFire)
    if displayOnFire then
      self:SyncFirePos()
    end
  elseif displayOnFire then
    self:LoadFireEff()
  end
end

function Member:LoadFireEff()
  if self.fireHandle then
    return
  end
  self.fireHandle = Resource:InstantiateAsync("Assets/Main/Prefabs/World/Eff_squad_member_fire.prefab")
  self.fireHandle:completed("+", function(request)
    if request.isError then
      return
    end
    if not self.squad or not self.squad.transform then
      self.fireHandle:Destroy()
      self.fireHandle = nil
    else
      self.fireGO = request.gameObject
      self.fireTrans = self.fireGO.transform
      self.fireTrans:SetParent(self.squad.transform)
      self.fireTrans:Set_localScale(0.75, 0.75, 0.75)
      self:UpdateFireEff()
    end
  end)
end

function Member:SyncFirePos()
  if self.fireTrans and self.transform then
    local x, y, z = self.transform:Get_localPosition()
    self.fireTrans:Set_localPosition(x, y, z)
  end
end

function Member:AddDelayEvent(event, delay)
  local timer = TimerManager:GetInstance():DelayInvoke(event, delay)
  table.insert(self.delayEvents, timer)
end

function Member:PlayAnim(anim, rewind)
  if not self.gameObject then
    self.animNameCache = anim
    self.rewindCache = rewind
    return
  end
  if anim == "death" then
    rewind = true
  end
  self.animNameCache = anim
  if rewind == true then
    self:AddDelayEvent(function()
      self:RewindAndPlaySimpleAnim(anim)
    end, math.random() * 0.2)
  else
    self:PlaySimpleAnim(anim)
  end
  if anim ~= "attack" then
    self:DestroyBullets()
  end
  self.animNameCache = nil
  self.rewindCache = nil
end

function Member:Attack(targetPos, index)
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

return Member
