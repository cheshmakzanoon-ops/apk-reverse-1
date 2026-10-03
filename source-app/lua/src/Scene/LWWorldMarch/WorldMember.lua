local Resource = CS.GameEntry.Resource
local DisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
local base = require("Scene.LWWorldMarch.WorldUnit")
local WorldMember = BaseClass("WorldMember", base)

function WorldMember:Init(battleManager, squad, guid, req, index, heroData)
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
  self.appearanceMeta = nil
  self.modelPath = nil
  if heroData then
    local useHeroModelData = false
    if heroData.GetHeroModelData then
      local customPath, appearanceId = heroData:GetHeroModelData(HeroModelType.World)
      if not string.IsNullOrEmpty(customPath) then
        self.modelPath = customPath
        self.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
        useHeroModelData = true
      end
    end
    if not useHeroModelData then
      self.appearanceMeta = heroData.appearanceMeta
      if not string.IsNullOrEmpty(heroData.modelAssetPath) then
        self.modelPath = heroData.modelAssetPath
      else
        self.modelPath = self.appearanceMeta and self.appearanceMeta.world_model_path
      end
    end
  end
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

function WorldMember:DestroyView()
  base.DestroyView(self)
  self:RemoveIronCurtainListener()
  if self.fireHandle then
    self.fireHandle:Destroy()
    self.fireHandle = nil
    self.fireGO = nil
    self.fireTrans = nil
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
  if self.m_reqDefault ~= nil then
    self.m_reqDefault:Destroy()
    self.m_reqDefault = nil
  end
  self.firePoint = nil
  self.animNameCache = nil
  self.targetPosCache = nil
  for _, v in pairs(self.delayEvents) do
    v:Stop()
  end
  self.delayEvents = {}
  self.anim = nil
  self.curAnimName = nil
  self:RestoreInitMaterials()
  self.lastIronCurtainStatus = nil
end

function WorldMember:DestroyData()
  base.DestroyData(self)
  self.squad = nil
  self.hero = nil
  self.bulletMotionEditor = nil
  self.isLeader = nil
  self.isActive = nil
end

function WorldMember:OnCreate()
  if self.m_req ~= nil then
    self.gameObject = self.m_req.gameObject
    self.transform = self.gameObject.transform
    self.firePoints = {}
    if self.appearanceMeta == nil then
      Logger.LogError("WorldMember appearanceMeta\231\169\186\228\186\134\239\188\140\230\137\190\228\184\141\229\136\176\229\188\128\231\129\171\231\130\185, model\231\148\168\231\154\132:" .. self.modelPath)
    end
    local fire_paths = self.appearanceMeta.fire_paths
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
  self:AddIronCurtainListener()
  self:UpdateIronCurtainMaterials()
  if self.animNameCache then
    self:PlayAnim(self.animNameCache, self.rewindCache)
  end
  if self.targetPosCache then
    self:Attack(self.targetPosCache, self.attackIndexCache)
  end
end

function WorldMember:OnDefaultCreate()
  if self.m_reqDefault ~= nil then
    self.gameObject = self.m_reqDefault.gameObject
    self.transform = self.gameObject.transform
    local fire_paths = self.hero.appearanceMeta.fire_paths
    self.firePoints = {}
    for i, v in ipairs(fire_paths) do
      table.insert(self.firePoints, self.transform)
    end
    self.firePoint = self.firePoints[1]
  end
  self.transform:SetParent(self.squad.transform)
  local offset = self.squad.formation.GetOffsetByIndex(self.index)
  self.transform:Set_localPosition(offset.x, offset.y, offset.z)
  self.transform:Set_localEulerAngles(0, 0, 0)
  self:ComponentDefine()
  self:UpdateDisplayMode()
  self:AddIronCurtainListener()
  self:UpdateIronCurtainMaterials()
  if self.animNameCache then
    self:PlayAnim(self.animNameCache, self.rewindCache)
  end
  if self.targetPosCache then
    self:Attack(self.targetPosCache, self.attackIndexCache)
  end
end

function WorldMember:UpdateDisplayMode()
  local displayLevel = self.squad.displayLevel
  self.isActive = not DisplaySettings.DisplayHeroAsIcon(displayLevel) and (self.isLeader or not DisplaySettings.OnlyDisplayLeader(displayLevel))
  if self.gameObject then
    self.gameObject:SetActive(self.isActive)
    if self.isActive then
      if self.curAnimName then
        self:PlayAnim(self.curAnimName)
      end
      if self.isLeader then
        local offset = DisplaySettings.OnlyDisplayLeader(displayLevel) and Vector3.zero or self.squad.formation.GetOffsetByIndex(self.index)
        self.transform.localPosition = offset
      end
    end
    self:UpdateFireEff()
  elseif self.isActive then
    if self.m_req == nil and self.modelPath then
      if self:IsUseRemoteUniqueWeapon() then
        local defaultAppearanceId = self.hero.meta.appearance
        local path = LocalController:instance():getValue("lw_hero_appearance", defaultAppearanceId, "world_model_path")
        self.m_reqDefault = Resource:InstantiateAsync(path, ObjectPoolTag.Normal, LoadPriority.Low)
        self.m_reqDefault:completed("+", function(request)
          if self.m_reqDefault.isError then
            return
          end
          if self.m_req and self.m_req.isDone then
            self.m_reqDefault:Destroy()
            self.m_reqDefault = nil
          else
            self:OnDefaultCreate()
          end
        end)
      end
      self.m_req = Resource:InstantiateAsync(self.modelPath, ObjectPoolTag.Normal, LoadPriority.Low)
      self.m_req:completed("+", function(request)
        if self.m_req.isError then
          return
        end
        if self.m_reqDefault then
          self.m_reqDefault:Destroy()
          self.m_reqDefault = nil
        end
        self:OnCreate()
      end)
    end
  else
    if self.m_req then
      self.m_req:Destroy()
      self.m_req = nil
    end
    if self.m_reqDefault then
      self.m_reqDefault:Destroy()
      self.m_reqDefault = nil
    end
  end
end

function WorldMember:IsUseRemoteUniqueWeapon()
  local defaultAppearanceId = self.hero.meta.appearance
  if defaultAppearanceId == self.appearanceMeta.id then
    return false
  end
  local packConfigId = LocalController:instance():getValue("lw_hero", self.hero.meta.id, "download_packs_id")
  if not packConfigId or packConfigId <= 0 then
    return false
  end
  local isLoaded = UIUtil.CheckAssetDownloaded(self.modelPath)
  if isLoaded then
    return false
  end
  return true
end

function WorldMember:InitHeroData()
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

function WorldMember:GetRawProperty(theType)
  if self.hero == nil or type(self.hero.GetHeroProperty) ~= "function" then
    return 0
  end
  return self.hero:GetHeroProperty(theType)
end

function WorldMember:ComponentDefine()
  base.ComponentDefine(self)
  self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  if not self.anim then
    Logger.LogError("\232\175\165\229\141\149\228\189\141\228\184\139\233\157\162\230\178\161\230\140\130SimpleAnimation\232\132\154\230\156\172\239\188\140gameObject:" .. self.gameObject.name)
  end
  local appearanceMeta = self.hero.appearanceMeta
  local scaleFactor = self.squad.formation.GetScaleByIndex(self.index)
  self.transform:Set_localScale(appearanceMeta.model_size * scaleFactor, appearanceMeta.model_size * scaleFactor, appearanceMeta.model_size * scaleFactor)
end

function WorldMember:GetTransform()
  return self.transform
end

function WorldMember:GetGameObject()
  return self.gameObject
end

function WorldMember:GetFirePoint()
  if self.firePoint ~= nil then
    return self.firePoint, false
  end
  if self.transform ~= nil then
    return self.transform, false
  end
  return Vector3.New(0, 0, 0), false
end

function WorldMember:GetFirePointById(id)
  if self.firePoints and self.firePoints[id] then
    return self.firePoints[id], false
  end
  return self:GetFirePoint()
end

function WorldMember:CreateBullet(targetPos)
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

function WorldMember:OnBulletHit(bullet)
  if bullet.handle ~= nil and not IsNull(bullet.handle) then
    bullet.handle:Destroy()
    bullet.handle = nil
  end
end

function WorldMember:DestroyBullets()
  for _, v in pairs(self.bullets) do
    self:OnBulletHit(v)
  end
  self.bullets = {}
end

local BULLET_SPEED = 50

function WorldMember:OnUpdate()
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

function WorldMember:SetOnFire(value)
  self.isOnFire = value
  self:UpdateFireEff()
end

function WorldMember:UpdateFireEff()
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

function WorldMember:LoadFireEff()
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

function WorldMember:SyncFirePos()
  if self.fireTrans and self.transform then
    local x, y, z = self.transform:Get_localPosition()
    self.fireTrans:Set_localPosition(x, y, z)
  end
end

function WorldMember:AddDelayEvent(event, delay)
  local timer = TimerManager:GetInstance():DelayInvoke(event, delay)
  table.insert(self.delayEvents, timer)
end

function WorldMember:PlayAnim(anim, rewind)
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
  self.curAnimName = anim
end

function WorldMember:Attack(targetPos, index)
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

function WorldMember:AddIronCurtainListener()
  if self.ironCurtainListenerAdded then
    return
  end
  if not self.squad or self.squad.ownerUid ~= LuaEntry.Player:GetUid() then
    return
  end
  if not DataCenter.ActivityListDataManager:IsActivityOpen(EnumActivity.ActLandlord.Type) then
    return
  end
  if not DataCenter.LandlordMgr:IsInBattle() then
    return
  end
  self.ironCurtainListenerAdded = true
  
  function self.ironCurtainListener(stateId)
    self:OnIronCurtainStatusChange(stateId)
  end
  
  EventManager:GetInstance():AddListener(EventId.LuaEntryEffectRefreshStatus, self.ironCurtainListener)
end

function WorldMember:RemoveIronCurtainListener()
  if not self.ironCurtainListenerAdded then
    return
  end
  self.ironCurtainListenerAdded = nil
  EventManager:GetInstance():RemoveListener(EventId.LuaEntryEffectRefreshStatus, self.ironCurtainListener)
  self.ironCurtainListener = nil
end

function WorldMember:OnIronCurtainStatusChange(stateId)
  if stateId ~= nil and stateId ~= LLConst.IronCurtainStatusId then
    return
  end
  self:UpdateIronCurtainMaterials()
end

function WorldMember:RecordInitMaterial()
  if not self.gameObject then
    return
  end
  if self.initMaterials and #self.initMaterials > 0 then
    return
  end
  self.initMaterials = {}
  local renderers = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.Renderer), true)
  if renderers and 0 < renderers.Length then
    for i = 0, renderers.Length - 1 do
      local renderer = renderers[i]
      if renderer and not IsNull(renderer) then
        table.insert(self.initMaterials, {
          renderer = renderer,
          materials = renderer.sharedMaterials
        })
      end
    end
  end
end

function WorldMember:UpdateIronCurtainMaterials()
  if not self.gameObject then
    return
  end
  if not self.squad or self.squad.ownerUid ~= LuaEntry.Player:GetUid() then
    return
  end
  local hasIronCurtain = LuaEntry.Effect:HasStatus(LLConst.IronCurtainStatusId)
  if self.lastIronCurtainStatus == hasIronCurtain then
    return
  end
  self.lastIronCurtainStatus = hasIronCurtain
  if not hasIronCurtain then
    self:RestoreInitMaterials()
    return
  end
  self:RecordInitMaterial()
  DataCenter.LandlordMgr:GetIronCurtainMaterial(BindCallback(self, self.UpdateIronCurtainCallback))
end

function WorldMember:UpdateIronCurtainCallback(mat)
  if IsNull(self.gameObject) or IsNull(mat) then
    return
  end
  local renderers = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.Renderer), true)
  if not renderers or renderers.Length == 0 then
    return
  end
  for i = 0, renderers.Length - 1 do
    local renderer = renderers[i]
    if renderer and not IsNull(renderer) then
      local mats = renderer.sharedMaterials
      if mats then
        local hasIronCurtainMat = false
        for j = 0, mats.Length - 1 do
          if mats[j] == mat then
            hasIronCurtainMat = true
            break
          end
        end
        if not hasIronCurtainMat then
          local newMats = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Material), mats.Length + 1)
          for j = 0, mats.Length - 1 do
            newMats[j] = mats[j]
          end
          newMats[mats.Length] = mat
          renderer.sharedMaterials = newMats
        end
      end
    end
  end
end

function WorldMember:RestoreInitMaterials()
  if not self.initMaterials then
    return
  end
  for _, matData in ipairs(self.initMaterials) do
    if not IsNull(matData.renderer) and matData.materials then
      matData.renderer.sharedMaterials = matData.materials
    end
  end
  self.initMaterials = nil
end

return WorldMember
