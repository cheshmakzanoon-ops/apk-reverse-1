local base = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.ColliderMonsterBase")
local TyreMonster = BaseClass("TyreMonster", base)
local TriggerEnum = require("Scene.LWBattle.ParkourBattle.TriggerEvent.TriggerEnum")
local MonsterEnergyBarCell = require("DataCenter.ZombieBattle.HpBar.MonsterEnergyBarCell")
local Resource = CS.GameEntry.Resource
local BattleColliderUtils = CS.BattleColliderUtils
local dropInterval = 0.1

function TyreMonster:Init(logic, mgr, guid, x, y, monsterMeta)
  base.Init(self, logic, mgr, guid, x, y, monsterMeta)
  self.triggerMeta = DataCenter.LWTriggerItemTemplateManager:GetTemplate(self.deathEvent)
  self:PreSelectHeroUuid()
  self.lastBlood = self.curBlood
  self.effectByBuff = true
end

function TyreMonster:DestroyData()
  if self.delayRemoveAnim then
    self.delayRemoveAnim:Stop()
    self.delayRemoveAnim = nil
  end
  self.deathPlaying = nil
  self.preSelectHeroUuid = nil
  self.triggerMeta = nil
  self.mainChildList = nil
  self.mainChildPosList = nil
  self.mainChildAnimList = nil
  self.mainChildRenderList = nil
  self.childCount = nil
  self.hideChildIndex = 0
  self.hitAnimIndex = 0
  self.effectAnimIndex = 0
  self.MPB = nil
  base.DestroyData(self)
end

function TyreMonster:DestroyView()
  self:ClearDynamicRes()
  if self.hitAnimDelay then
    self.hitAnimDelay:Stop()
    self.hitAnimDelay = nil
  end
  if self.deathAnimDelay then
    self.deathAnimDelay:Stop()
    self.deathAnimDelay = nil
  end
  if self.mainChildRenderList then
    local count = #self.mainChildRenderList
    for i = 1, count do
      self:ClearHitEffect(i)
    end
    self.mainChildRenderList = nil
  end
  if not IsNull(self.hpGo) then
    self.hpGo:SetActive(true)
    if self.hpPosX then
      self.hpTrans:Set_localPosition(self.hpPosX, self.hpPosY, self.hpPosZ)
    end
  end
  self.hpGo = nil
  self.hpTrans = nil
  self.hpPosX = nil
  self.hpPosY = nil
  self.hpPosZ = nil
  if not IsNull(self.nodeGo) then
    self.nodeGo:SetActive(true)
    if self.nodePosX then
      self.nodeTrans:Set_localPosition(self.nodePosX, self.nodePosY, self.nodePosZ)
    end
  end
  self.nodeGo = nil
  self.nodeTrans = nil
  self.nodePosX = nil
  self.nodePosY = nil
  self.nodePosZ = nil
  if self.childCount and self.mainChildList and self.mainChildPosList then
    for i = 1, self.childCount do
      local child = self.mainChildList[i]
      child.gameObject:SetActive(true)
      local pos = self.mainChildPosList[i]
      child:Set_localPosition(pos.x, pos.y, pos.z)
    end
  end
  self.dropMap = nil
  self.dropTimer = nil
  base.DestroyView(self)
end

function TyreMonster:PreSelectHeroUuid()
  if self.preSelectHeroUuid then
    return
  end
  if not self.triggerMeta then
    return
  end
  local triggerType = self.triggerMeta.type
  self.triggerType = triggerType
  if triggerType == TriggerEnum.EventType.AddSingleHeroSkill or triggerType == TriggerEnum.EventType.AddSingleHeroBuff or triggerType == TriggerEnum.EventType.ReplaceSingleHeroNormalAttack then
    if DataCenter.LWBattleManager.logic.GetRandomInitUuid then
      self.preSelectHeroUuid = DataCenter.LWBattleManager.logic:GetRandomInitUuid()
    end
  elseif triggerType == TriggerEnum.EventType.ReplaceHeroIdNormalAttack or triggerType == TriggerEnum.EventType.ReplaceHeroIdNormalAttackWithoutInterrupt or triggerType == TriggerEnum.EventType.ReplaceHeroIdActiveAttackWithoutInterrupt then
    local para = self.triggerMeta.para
    if not string.IsNullOrEmpty(para) then
      local paraList = string.split(para, "|")
      if #paraList == 2 then
        self.preSelectHeroUuid = tonumber(paraList[1]) or 0
      end
    end
  elseif triggerType == TriggerEnum.EventType.ReplaceHeroIdAppearance or triggerType == TriggerEnum.EventType.ReplaceHeroIdAppearanceSaveLv then
    local para = self.triggerMeta.para
    if not string.IsNullOrEmpty(para) then
      local paraList = string.split(para, "|")
      if #paraList == 2 then
        self.preSelectHeroUuid = tonumber(paraList[1]) or 0
      end
    end
  elseif triggerType == TriggerEnum.EventType.AddEnergy then
    local para = self.triggerMeta.para
    local index = tonumber(para) or 0
    if 0 < index and DataCenter.LWBattleManager.logic.GetInitUuidAuto then
      self.preSelectHeroUuid = DataCenter.LWBattleManager.logic:GetInitUuidAuto(index)
    end
  elseif triggerType == TriggerEnum.EventType.ThreeChoices then
    local triggerCount = self.triggerMeta.paraArray and #self.triggerMeta.paraArray or 0
    if 0 < triggerCount and DataCenter.LWBattleManager.logic.GetRandomInitUuid then
      self.preSelectHeroUuid = {}
      for i = 1, triggerCount do
        table.insert(self.preSelectHeroUuid, DataCenter.LWBattleManager.logic:GetRandomInitUuid())
      end
    end
  elseif triggerType == TriggerEnum.EventType.AddHero then
    self.preSelectHeroUuid = tonumber(self.monsterMeta.trigger_para) or 1
  elseif triggerType == TriggerEnum.EventType.AddHeroIdEnergy then
    local para = self.triggerMeta.para
    local heroId, index
    if not string.IsNullOrEmpty(para) then
      local paraList = string.split(para, "|")
      heroId = tonumber(paraList[1])
      index = tonumber(paraList[2])
      if heroId and index == nil then
        index = 1
      end
    end
    if heroId and index and DataCenter.LWBattleManager.logic.GetInitUuidByHeroIdOrIndex then
      self.preSelectHeroUuid = DataCenter.LWBattleManager.logic:GetInitUuidByHeroIdOrIndex(heroId, index)
    end
  end
end

function TyreMonster:OnLoadComplete()
  base.OnLoadComplete(self)
  local hpTrans = self.transform:Find("HpText")
  if hpTrans then
    self.hpTrans = hpTrans
    self.hpGo = hpTrans.gameObject
    self.hpPosX, self.hpPosY, self.hpPosZ = hpTrans:Get_localPosition()
    self.hpText = hpTrans:GetComponent(typeof(CS.SuperTextMesh))
    self.hpText.text = math.ceil(self.curBlood)
  end
  local nodeTrans = self.transform:Find("Node")
  if nodeTrans then
    self.nodeTrans = nodeTrans
    self.nodeGo = nodeTrans.gameObject
    self.nodePosX, self.nodePosY, self.nodePosZ = nodeTrans:Get_localPosition()
    self:LoadDynamicRes()
  else
    local res = self.monsterMeta.asset or ""
    Logger.LogError("DynamicTableMonster:OnLoadComplete no Node  res : " .. res)
  end
  self.perBlood = self.curBlood
  local mainTrans = self.transform:Find("Main")
  if mainTrans then
    local childCount = mainTrans.childCount
    self.mainChildList = {}
    self.mainChildPosList = {}
    self.mainChildAnimList = {}
    self.mainChildRenderList = {}
    for i = 0, childCount - 1 do
      local child = mainTrans:GetChild(i)
      local x, y, z = child:Get_localPosition()
      local go = child.gameObject
      local anim = go:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
      table.insert(self.mainChildList, child)
      table.insert(self.mainChildPosList, {
        x = x,
        y = y,
        z = z
      })
      table.insert(self.mainChildAnimList, anim)
      local renders = {}
      local skinnedMeshRenderer = go:GetComponentsInChildren(typeof(CS.UnityEngine.SkinnedMeshRenderer))
      local meshRenderer = go:GetComponentsInChildren(typeof(CS.UnityEngine.MeshRenderer))
      if skinnedMeshRenderer then
        local length = skinnedMeshRenderer.Length
        for j = 0, length - 1 do
          table.insert(renders, skinnedMeshRenderer[j])
        end
      end
      if meshRenderer then
        local length = meshRenderer.Length
        for j = 0, length - 1 do
          table.insert(renders, meshRenderer[j])
        end
      end
      table.insert(self.mainChildRenderList, renders)
      if anim then
        anim:Rewind("Default")
        anim:Play("Default")
      end
    end
    self.childCount = childCount
    self.hideChildIndex = 0
    if 0 < childCount then
      self.perBlood = math.ceil(self.curBlood / childCount)
    end
  else
    local res = self.monsterMeta.asset or ""
    Logger.LogError("DynamicTableMonster:OnLoadComplete no Main  res : " .. res)
  end
end

function TyreMonster:ComponentDefine()
  base.ComponentDefine(self)
end

function TyreMonster:UpdateReversePos(deltaTime)
  if self.deathPlaying then
    return
  end
  base.UpdateReversePos(self, deltaTime)
end

function TyreMonster:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
  base.BeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
  if hurt ~= 0 and self.hpText then
    self.hpText.text = math.ceil(self.curBlood)
  end
  local index = math.ceil(self.curBlood / self.perBlood)
  index = Mathf.Clamp(self.childCount - index, 0, self.childCount)
  if index ~= self.hideChildIndex then
    if self.dropMap == nil then
      self.dropMap = {}
    end
    if self.childCount and self.mainChildList and self.mainChildPosList then
      local subY = 0
      for i = 1, self.childCount do
        local child = self.mainChildList[i]
        local pos = self.mainChildPosList[i]
        if i <= index then
          if i ~= self.childCount then
            child.gameObject:SetActive(false)
          end
          self.dropMap[child] = nil
        elseif i == index + 1 then
          self:SetDropData(child, pos.x, pos.z, pos.y, 0)
          subY = subY + pos.y
        else
          local newY = pos.y - subY
          self:SetDropData(child, pos.x, pos.z, pos.y, newY)
        end
      end
      if self.hpPosY then
        local newHpY = self.hpPosY - subY
        newHpY = math.max(newHpY, 0.02)
        self:SetDropData(self.hpTrans, self.hpPosX, self.hpPosZ, self.hpPosY, newHpY)
      end
      if self.nodePosY then
        local newNodeY = self.nodePosY - subY
        self:SetDropData(self.nodeTrans, self.nodePosX, self.nodePosZ, self.nodePosY, newNodeY)
      end
      self.dropTimer = dropInterval
    end
    self.hideChildIndex = index
  end
end

function TyreMonster:SetDropData(trans, x, z, fromY, toY)
  local data = self.dropMap[trans]
  if data == nil then
    data = {}
    data.x = x
    data.z = z
    data.fromY = fromY
    data.curY = fromY
    data.toY = toY
    self.dropMap[trans] = data
  else
    data.fromY = data.curY
    data.toY = toY
  end
end

function TyreMonster:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) and self.afterBeAttackDone then
    return
  end
  base.AfterBeAttack(self, hurt, hitPoint, hitDir, 0, stiffTime, hitBackDistance, hitEff, skill, deathEff)
  if self.heroEffectMeta and 0 < self.curBlood then
    local hit_action = self.heroEffectMeta.hit_action
    if not string.IsNullOrEmpty(hit_action) then
      if self.hitLength == nil then
        self.hitLength = self:GetChildAnimLength(hit_action, 1)
      end
      if 0 < self.hitLength and (self.hitAnimDelay == nil or self.hitAnimIndex ~= self.hideChildIndex) then
        self.hitAnimIndex = self.hideChildIndex
        local animIndex = self.hitAnimIndex + 1
        self:RewindAndPlayChildAnim(hit_action, nil, animIndex)
        self:ShowHitEffect(animIndex)
        if self.hitAnimDelay then
          self.hitAnimDelay:Stop()
        end
        self.hitAnimDelay = TimerManager:GetInstance():DelayInvoke(function()
          self.hitAnimDelay = nil
          local index = animIndex
          if not self.deathPlaying then
            self:PlayChildAnim("Default", nil, index)
          end
          self:ClearHitEffect(index)
        end, self.hitLength)
      end
    end
    local effect = self.heroEffectMeta.death_effect_nomal
    if not string.IsNullOrEmpty(effect) and self.effectAnimIndex ~= self.hideChildIndex then
      self.effectAnimIndex = self.hideChildIndex
      self.logic:ShowEffectObj(effect, hitPoint, nil, nil)
      local death_action = self.heroEffectMeta.death_action
      if not string.IsNullOrEmpty(death_action) then
        if self.deathLength == nil then
          self.deathLength = self:GetChildAnimLength(death_action, 1)
        end
        if 0 < self.deathLength then
          if self.deathAnimDelay == nil then
            self.deathAnimDelay = TimerManager:GetInstance():DelayInvoke(function()
              self.deathAnimDelay = nil
              if self.hideChildIndex ~= self.childCount then
                local child = self.mainChildList[self.hideChildIndex]
                if child then
                  child.gameObject:SetActive(false)
                end
              end
            end, self.deathLength)
          else
            self.deathAnimDelay:Reset()
          end
          local child = self.mainChildList[self.hideChildIndex]
          if child then
            child.gameObject:SetActive(true)
            self:ClearHitEffect(self.hideChildIndex)
            self:RewindAndPlayChildAnim(death_action, nil, self.hideChildIndex)
          end
        end
      end
    end
  end
  self.afterBeAttackDone = true
end

function TyreMonster:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  if self.dropMap and self.dropTimer and self.dropTimer > 0 then
    self.dropTimer = self.dropTimer - deltaTime
    local lerp = (dropInterval - self.dropTimer) / dropInterval
    lerp = Mathf.Clamp(lerp, 0, 1)
    for trans, data in pairs(self.dropMap) do
      data.curY = Mathf.Lerp(data.fromY, data.toY, lerp)
      trans:Set_localPosition(data.x, data.curY, data.z)
    end
  end
end

function TyreMonster:Death()
  self.delayRemoveAnim = TimerManager:GetInstance():DelayInvoke(function()
    self.delayRemoveAnim = nil
    if self.mgr then
      self.mgr:RemoveMonster(self.guid)
    end
  end, 1.3)
  if not IsNull(self.hpGo) then
    self.hpGo:SetActive(false)
  end
  if not IsNull(self.nodeGo) then
    self.nodeGo:SetActive(false)
  end
  self:FlyNode()
  self.deathPlaying = true
  local death_action = self.heroEffectMeta.death_action
  if not string.IsNullOrEmpty(death_action) then
    if self.deathLength == nil then
      self.deathLength = self:GetChildAnimLength(death_action, 1)
    end
    if self.deathLength > 0 then
      local child = self.mainChildList[self.childCount]
      if child then
        child.gameObject:SetActive(true)
        self:ClearHitEffect(self.childCount)
        self:RewindAndPlayChildAnim(death_action, nil, self.childCount)
      end
    end
  end
end

function TyreMonster:TriggerEvent(eventId, extra)
end

function TyreMonster:LoadDynamicRes()
  self:ClearDynamicRes()
  local dynamic_resource = self.monsterMeta.dynamic_resource
  if not string.IsNullOrEmpty(dynamic_resource) then
    self.dynamicResReq = Resource:InstantiateAsync(dynamic_resource)
    self.dynamicResReq:completed("+", function(req)
      self.dynamicResGameObject = req.gameObject
      local targetLayer = CS.UnityEngine.LayerMask.NameToLayer("OutLineGolden")
      if targetLayer < 0 or 31 < targetLayer then
        targetLayer = CS.UnityEngine.LayerMask.NameToLayer("Default")
      end
      self.dynamicResGameObject:SetLayerRecursively(targetLayer)
      self.dynamicResTransform = req.gameObject.transform
      self.dynamicResTransform:SetParent(self.nodeGo.transform)
      self.dynamicResTransform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      self.dynamicResTransform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      self.dynamicResTransform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    end)
  else
    Logger.LogError("DynamicTableMonster:LoadDynamicRes error : " .. (tonumber(self.monsterMeta.id) or 0))
  end
end

function TyreMonster:ClearDynamicRes()
  if self.dynamicResReq then
    self.dynamicResReq:Destroy()
    self.dynamicResReq = nil
  end
  self.dynamicResGameObject = nil
  self.dynamicResTransform = nil
end

function TyreMonster:FlyNode()
  BattleColliderUtils.RemoveMonsterCollider(self.guid)
  if self.dynamicResReq and not IsNull(self.dynamicResGameObject) and self.battleMgr and self.battleMgr.FlyNodeToTeam then
    local req = self.dynamicResReq
    self.dynamicResReq = nil
    self:ClearDynamicRes()
    self.battleMgr:FlyNodeToTeam(req, self.deathEvent, self.preSelectHeroUuid, self.monsterMetaId)
    return
  end
  self:ClearDynamicRes()
  local eventId = self.deathEvent
  local extra = self.preSelectHeroUuid
  if eventId then
    local meta = DataCenter.LWTriggerItemTemplateManager:GetTemplate(eventId)
    if meta and meta.isUnAddEnergyType then
      DataCenter.LWBattleManager.logic.triggerEventMgr:Trigger(meta.type, meta, extra, self.monsterMetaId)
    end
  end
end

function TyreMonster:GetChildAnimLength(name, index)
  if self.mainChildAnimList == nil then
    return 0
  end
  local anim = self.mainChildAnimList[index]
  if anim then
    anim:SetStateSpeed(name, 1)
    return anim:GetClipLength(name)
  else
    return 0
  end
end

function TyreMonster:ShowHitEffect(index)
  if self.mainChildRenderList == nil then
    return
  end
  local renders = self.mainChildRenderList[index]
  if IsNull(self.MPB) then
    local mpb = CS.UnityEngine.MaterialPropertyBlock()
    mpb:SetFloat("_OnHit", 1)
    self.MPB = mpb
  end
  if renders then
    for _, v in ipairs(renders) do
      v:SetPropertyBlock(self.MPB)
    end
  end
end

function TyreMonster:ClearHitEffect(index)
  if self.mainChildRenderList == nil then
    return
  end
  local renders = self.mainChildRenderList[index]
  if renders then
    for _, v in ipairs(renders) do
      v:SetPropertyBlock(nil)
    end
  end
end

function TyreMonster:RewindAndPlayChildAnim(name, speed, index)
  if self.mainChildAnimList == nil then
    return
  end
  local anim = self.mainChildAnimList[index]
  if anim then
    anim:Rewind(name)
    anim:Play(name)
    if speed then
      anim:SetStateSpeed(name, speed)
    end
  end
end

function TyreMonster:PlayChildAnim(name, speed, index)
  if self.mainChildAnimList == nil then
    return
  end
  local anim = self.mainChildAnimList[index]
  if anim then
    anim:Play(name)
    if speed then
      anim:SetStateSpeed(name, speed)
    end
  end
end

return TyreMonster
