local BattleObj = BaseClass("BattleObj")
local DOTween = CS.DG.Tweening.DOTween
local typeofPS = typeof(CS.UnityEngine.ParticleSystem)
local Resource = CS.GameEntry.Resource
local MyStrNull = string.IsNullOrEmpty
local WS_FireEff = "WS_FireEff_"

function BattleObj:OnCreate(pointIndex, bfType)
  self.pointIndex = pointIndex
  self.bfType = bfType
  self:UpdateDetail()
  self:UpdateGo()
  if self.config ~= nil then
    if self.bfType == BattleFieldType.EpidemicZone then
      self.isBuild = true
    else
      self.isBuild = self.config:IsBuild()
    end
  end
  self.animStr = ""
  self.fireDelay = 0
  self.bullets = {}
end

function BattleObj:OnCreateSkill(ownerUid, skillId, pointIndex, go)
  self.ownerUid = ownerUid
  self.bfType = BattleFieldType.EpidemicZone
  self:UpdateSkillInfo(skillId, pointIndex, go)
  self.isBuild = true
  self.animStr = ""
  self.fireDelay = 0
  self.bullets = {}
end

function BattleObj:OnDestroy()
  if self.seqFireDelay ~= nil then
    self.seqFireDelay:Pause()
    self.seqFireDelay:Kill()
    self.seqFireDelay = nil
  end
  if self.fireReq ~= nil then
    self.fireReq:Destroy()
    self.fireReq = nil
  end
  if self.animDelay ~= nil then
    self.animDelay:Pause()
    self.animDelay:Kill()
    self.animDelay = nil
  end
  if self.bullets then
    for _, v in pairs(self.bullets) do
      v:OnDestroy()
      v:Delete()
    end
    self.bullets = {}
  end
end

function BattleObj:UpdateGo(go)
  if IsNull(go) then
    local obj = CS.SceneManager.World:GetObjectByPoint(self.pointIndex)
    self.gameObject = obj ~= nil and obj:GetGameObject() or nil
  else
    self.gameObject = go
  end
  self.transform = self.gameObject ~= nil and self.gameObject.transform or nil
  local bfObj = self.transform ~= nil and self.transform:GetComponent(typeof(CS.BattleFieldObj)) or nil
  if bfObj == nil then
    bfObj = self.transform ~= nil and self.transform:GetComponent(typeof(CS.BattleFieldObjNew)) or nil
  end
  self.animation = bfObj ~= nil and bfObj.SimpleAnimation or nil
  self.firePoint = bfObj ~= nil and bfObj.FirePoint or nil
  self.upPoint = bfObj ~= nil and bfObj.UpPoint or nil
end

function BattleObj:UpdateBaseRotation()
  if self:BaseCheck() or IsNull(self.transform) then
    return
  end
  self.baseRotation = self.config.rotation or 0
  if self.skillId ~= nil then
    return
  end
  self.transform.rotation = Quaternion.Euler(0, self.baseRotation, 0)
end

function BattleObj:UpdateDetail()
  local info = CS.SceneManager.World:GetPointInfo(self.pointIndex)
  self.detailInfo = info ~= nil and info.detail or nil
  self.targetEnemyUUID = info ~= nil and info.targetEnemyUUID or nil
  if self.detailInfo ~= nil then
    if self.bfType == BattleFieldType.WinterStorm then
      self.config = DataCenter.WinterStormTemplateManager:GetTemplate(self.detailInfo.BuildId)
    elseif self.bfType == BattleFieldType.EpidemicZone then
      self.config = DataCenter.EpidemicBuildTemplateMgr:GetTemplate(self.detailInfo.BuildId)
    end
  end
end

function BattleObj:UpdateSkillInfo(skillId, pointIndex, go)
  self.skillId = skillId
  self.pointIndex = pointIndex
  self:UpdateGo(go)
  self.config = {type = skillId}
  if skillId == EpidemicSkillId.Turret then
    local skillConfig = DataCenter.ActEpidemicZoneManager:GetTemplateSkillById(skillId)
    self.config.aim_effect = "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_wurenji_hongzha_winter.prefab"
    self.config.aim_line_effect = "Assets/Main/Prefabs/March/TroopLineWinter.prefab"
    self.config.attack_effect = "Assets/_Art_LastWar/Effect/Prefab/Arms/Murphy/Eff_Murphy_qiangkou.prefab"
    self.config.bullet_effect = "Assets/_Art_LastWar/Effect/Prefab/Arms/Murphy/Eff_Murphy_daodan_trail.prefab"
    self.config.boom_effect = "Assets/_Art_LastWar/Effect/Prefab/Arms/yanwu/Eff_zhadan_skill_lvup.prefab"
    self.config.attack_duration = skillConfig.attack_duration or 1
  end
  self:UpdateSkillDetail()
end

function BattleObj:UpdateSkillDetail(targetPId, findAimTime)
  self.detailInfo = {
    BuildId = self.skillId,
    Role = EpidemicZoneRole.Default,
    State = EpidemicBuildState.Occupied
  }
  self.detailInfo.FindAimTime = findAimTime and findAimTime or 0
  self.skillTargetPId = targetPId or nil
  local theWorld = CS.SceneManager.World
  if self.ownerUid == ActEpidemicUtils.DEV_TEST_SKILL_UID then
    self.detailInfo.Role = 1
    return
  end
  local info = theWorld:GetPointInfo(self.pointIndex)
  if info ~= nil then
    cast(info, typeof(CS.BuildPointInfo))
    local bEnemy = DataCenter.ActEpidemicZoneManager:GetWorldCampInEpidemic(info.allianceId) == WorldCamp.Enemy
    local role = DataCenter.ActEpidemicZoneManager:GetCurRole()
    if bEnemy then
      role = role == EpidemicZoneRole.Farmer and EpidemicZoneRole.Lord or EpidemicZoneRole.Farmer
    end
    self.detailInfo.Role = role
  else
    self.detailInfo.Role = EpidemicZoneRole.Default
  end
end

function BattleObj:BaseCheck()
  if self.detailInfo == nil or self.config == nil then
    return true
  end
  return false
end

function BattleObj:PlayAnim(animStr, bRewind)
  local animation = self.animation
  if not MyStrNull(animStr) and IsNotNull(animation) then
    local anim = animation:GetState(animStr)
    if anim == nil then
      return
    end
    self.animStr = animStr
    local isPlaying = animation:IsPlaying(animStr)
    if isPlaying then
      if animStr == BattleFieldObjActType.AIM or bRewind then
        animation:Rewind(animStr)
      end
      if not bRewind then
        return
      end
    end
    if not isPlaying then
      animation:Play(animStr)
    end
    if self.animDelay ~= nil then
      self.animDelay:Kill()
      self.animDelay = nil
    end
    if self.skillId ~= nil and animStr ~= BattleFieldObjActType.IDLE then
      local time = animation:GetClipLength(animStr)
      local seq = DOTween.Sequence()
      seq:AppendInterval(time)
      
      function seq.onComplete()
        self:PlayAnim(BattleFieldObjActType.IDLE)
        self.animDelay = nil
      end
      
      self.animDelay = seq
    end
  end
  if animStr == BattleFieldObjActType.ATK then
    self:PlayFireEff()
  end
end

function BattleObj:GetFirePointTF()
  if IsNotNull(self.firePoint) then
    return self.firePoint.transform
  end
  local theWorld = CS.SceneManager.World
  if IsNotNull(theWorld) then
    return theWorld.DynamicObjNode, true
  end
  return nil
end

function BattleObj:PlayFireEff()
  if self:BaseCheck() then
    return
  end
  if self.fireReq ~= nil and self.fireReq.isDone and IsNotNull(self.fireReq.gameObject) then
    self:PlayAttack(self.fireReq.gameObject)
    return
  end
  local fireEffect = self.config.attack_effect
  if MyStrNull(fireEffect) or self.fireReq ~= nil then
    return
  end
  local pointObj, bWorld = self:GetFirePointTF()
  if IsNull(pointObj) then
    return
  end
  local request = Resource:InstantiateAsync(fireEffect)
  self.fireReq = request
  local buildId = self.detailInfo.BuildId
  request:completed("+", function(req)
    local _go = req.gameObject
    if req.isError or IsNull(_go) then
      self.fireReq = nil
      return
    end
    _go.name = WS_FireEff .. buildId
    local pTF = _go.transform
    pTF:SetParent(pointObj)
    if bWorld then
      local pos = SceneUtils.TileIndexToWorld(self.pointIndex, ForceChangeScene.World, LuaEntry.Player:GetCurServerId())
      pTF:Set_position(pos.x, pos.y, pos.z)
    else
      pTF:Set_localPosition(0, 0, 0)
    end
    self:PlayAttack(_go)
  end)
end

function BattleObj:PlayEff(go, bLoop)
  if IsNull(go) then
    return
  end
  local eff = go:GetComponent(typeofPS)
  if eff == nil then
    eff = go:GetComponentInChildren(typeofPS)
  end
  if eff == nil then
    return
  end
  eff.gameObject:SetActive(true)
  eff:Simulate(0)
  eff:Play()
  if eff.main ~= nil and not bLoop then
    local seq = DOTween.Sequence()
    seq:AppendInterval(eff.main.duration)
    
    function seq.onComplete()
      self:StopEff(go)
    end
  end
end

function BattleObj:StopEff(go)
  if IsNull(go) then
    return
  end
  local eff = go:GetComponent(typeofPS)
  if eff == nil then
    eff = go:GetComponentInChildren(typeofPS)
  end
  if eff == nil then
    return
  end
  eff.gameObject:SetActive(false)
  eff:Stop()
end

function BattleObj:PlayAttack(go)
  if self:BaseCheck() then
    return
  end
  if self.fireDelay and self.fireDelay > 0 then
    local seq = DOTween.Sequence()
    seq:AppendInterval(self.fireDelay)
    
    function seq.onComplete()
      self.seqFireDelay = nil
      self:PlayEff(go)
      self:PlayBullet()
    end
    
    self.seqFireDelay = seq
  else
    self:PlayEff(go)
    self:PlayBullet()
  end
end

function BattleObj:ReInit()
end

function BattleObj:Update(curTime)
end

function BattleObj:PlayBullet()
end

return BattleObj
