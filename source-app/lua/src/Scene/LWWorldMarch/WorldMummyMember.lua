local Resource = CS.GameEntry.Resource
local DisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
local base = require("Scene.LWWorldMarch.WorldUnit")
local WorldMummyMember = BaseClass("WorldMummyMember", base)

function WorldMummyMember:Init(battleManager, squad, guid, tran, index)
  base.Init(self, battleManager, guid, nil)
  self.battleMgr = battleManager
  self.squad = squad
  self.guid = guid
  self.unitType = UnitType.Member
  self.searchType = BattleSearchType.Member
  self.gameObject = tran.gameObject
  self.transform = tran
  self.index = index
  self.animNameCache = nil
  self.targetPosCache = nil
  self.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(310001)
  self:InitHeroData()
  self.timeCount = 0
  self.maxBlood = 1
  self.curBlood = 1
  self.bullets = {}
  self.delayEvents = {}
  self:OnCreate()
end

function WorldMummyMember:DestroyView()
  base.DestroyView(self)
  if self.fireHandle then
    self.fireHandle:Destroy()
    self.fireHandle = nil
    self.fireGO = nil
    self.fireTrans = nil
  end
  self.gameObject = nil
  self.transform = nil
  self.firePoint = nil
  self.animNameCache = nil
  self.targetPosCache = nil
  for _, v in pairs(self.delayEvents) do
    v:Stop()
  end
  self.delayEvents = {}
  self.anim = nil
  self.curAnimName = nil
end

function WorldMummyMember:DestroyData()
  base.DestroyData(self)
  self.squad = nil
  self.bulletMotionEditor = nil
  self.isActive = nil
end

function WorldMummyMember:OnCreate()
  local fire_paths = self.appearanceMeta.fire_paths
  self.firePoints = {}
  for i, v in ipairs(fire_paths) do
    local firePoint = self.transform:Find(v)
    if not firePoint then
      Logger.LogError("\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\232\183\175\229\190\132\228\184\141\229\186\148\229\140\133\229\144\171\233\162\132\229\136\182\228\189\147\229\144\141\239\188\140\229\164\150\232\167\130id\239\188\154" .. self.appearanceMeta.id .. "\239\188\140\229\188\128\231\129\171\231\130\185\232\183\175\229\190\132\239\188\154" .. v)
    end
    table.insert(self.firePoints, firePoint)
  end
  self.firePoint = self.firePoints[1]
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

function WorldMummyMember:UpdateDisplayMode()
  local displayLevel = self.squad.displayLevel
  local showIcon = DisplaySettings.DisplayHeroAsIcon(displayLevel)
  local showOnlyLeader = DisplaySettings.OnlyDisplayLeader(displayLevel)
  if showIcon then
    self.isActive = false
  elseif showOnlyLeader then
    self.isActive = self.isLeader
  else
    self.isActive = not self.isLeader
  end
  if self.gameObject then
    self.gameObject:SetActive(self.isActive)
    if self.isActive and self.curAnimName then
      self:PlayAnim(self.curAnimName)
    end
    self:UpdateFireEff()
  end
end

function WorldMummyMember:InitHeroData()
  self.meta = DataCenter.HeroTemplateManager:GetTemplate(3100001)
  for _, skillId in pairs(self.meta.skills) do
    local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
    if skillMeta and skillMeta:IsNormalAttack() then
      self.skillManager:AddSkill(skillMeta, nil, false, true)
      break
    end
  end
end

function WorldMummyMember:GetRawProperty(theType)
  return 0
end

function WorldMummyMember:ComponentDefine()
  base.ComponentDefine(self)
  self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  if not self.anim then
    Logger.LogError("\232\175\165\229\141\149\228\189\141\228\184\139\233\157\162\230\178\161\230\140\130SimpleAnimation\232\132\154\230\156\172\239\188\140gameObject:" .. self.gameObject.name)
  end
end

function WorldMummyMember:GetTransform()
  return self.transform
end

function WorldMummyMember:GetGameObject()
  return self.gameObject
end

function WorldMummyMember:GetFirePoint()
  if self.firePoint ~= nil then
    return self.firePoint
  end
  if self.transform ~= nil then
    return self.transform
  end
  return Vector3.New(0, 0, 0)
end

function WorldMummyMember:GetFirePointById(id)
  if self.firePoints and self.firePoints[id] then
    return self.firePoints[id]
  end
  return self:GetFirePoint()
end

function WorldMummyMember:CreateBullet(targetPos)
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

function WorldMummyMember:OnBulletHit(bullet)
  if bullet.handle ~= nil and not IsNull(bullet.handle) then
    bullet.handle:Destroy()
    bullet.handle = nil
  end
end

function WorldMummyMember:DestroyBullets()
  for _, v in pairs(self.bullets) do
    self:OnBulletHit(v)
  end
  self.bullets = {}
end

local BULLET_SPEED = 50

function WorldMummyMember:OnUpdate()
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

function WorldMummyMember:SetOnFire(value)
  self.isOnFire = value
  self:UpdateFireEff()
end

function WorldMummyMember:UpdateFireEff()
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

function WorldMummyMember:LoadFireEff()
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

function WorldMummyMember:SyncFirePos()
  if self.fireTrans and self.transform then
    local x, y, z = self.transform:Get_localPosition()
    self.fireTrans:Set_localPosition(x, y, z)
  end
end

function WorldMummyMember:AddDelayEvent(event, delay)
  local timer = TimerManager:GetInstance():DelayInvoke(event, delay)
  table.insert(self.delayEvents, timer)
end

function WorldMummyMember:PlayAnim(anim, rewind)
  if not self.gameObject then
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
  self.curAnimName = anim
end

function WorldMummyMember:Attack(targetPos, index)
  if not self.isActive or not self.gameObject then
    return
  end
  if index == nil or index == 0 or index == self.index then
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

return WorldMummyMember
