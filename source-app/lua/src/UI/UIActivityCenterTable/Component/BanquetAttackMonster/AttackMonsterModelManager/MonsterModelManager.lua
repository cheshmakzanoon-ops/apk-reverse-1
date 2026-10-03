local MonsterModelManager = BaseClass("MonsterModelManager")
local Resource = CS.GameEntry.Resource

function MonsterModelManager:__init()
  self:DataDefine()
end

function MonsterModelManager:__delete()
  self:OnDestroy()
end

function MonsterModelManager:DataDefine()
  self.modelShowManager = nil
  self.modelLoadCache = {}
  self.monsterLoadRequest = nil
  self.monsterRoot = nil
  self.monster = nil
  self.monsterAni = nil
  self.monsterRenders = nil
  self.flashCountdown = 0
  self.monsterShowData = nil
  self.monsterCurData = nil
  self.showDataMonsterIdelTime = 0
  self.modelHideTime = 0
  self.SetMonsterPlayEnterAtCallBack = false
  self.deadAniFadeTweens = {}
end

function MonsterModelManager:OnDestroy()
  self.modelShowManager = nil
  self.modelLoadCache = nil
  self.monsterLoadRequest = nil
  self.monsterRoot = nil
  self.monster = nil
  self.monsterAni = nil
  self.monsterRenders = nil
  self.flashCountdown = nil
  self.monsterShowData = nil
  self.monsterCurData = nil
  self:ClearMonsterDeadAniTimer()
end

function MonsterModelManager:TryMonsterPlayIdleAni()
  if self.monsterAni then
    local loadId = self.monsterCurData.curMonsterId
    local monsterTemp = self.monsterShowData[loadId].monsterTemp
    local aniName = monsterTemp.act_1
    self.monsterAni:Stop()
    self.monsterAni:SetStateSpeed(aniName, 1)
    self.monsterAni:Play(aniName)
    self.showDataMonsterIdelTime = 0
    self.modelHideTime = 0
  end
end

function MonsterModelManager:TryMonsterPlayAttackedAni(isHit)
  if self.monsterAni then
    local loadId = self.monsterCurData.curMonsterId
    local monsterTemp = self.monsterShowData[loadId].monsterTemp
    local aniName = isHit and monsterTemp.act_3 or monsterTemp.act_2
    local atkTime = self.monsterAni:GetClipLength(aniName)
    if self.monsterAni:IsPlaying(aniName) then
      return
    end
    self.monsterAni:Stop()
    self.monsterAni:SetStateSpeed(aniName, 1)
    self.monsterAni:Play(aniName)
    self.showDataMonsterIdelTime = atkTime
    self.modelHideTime = 0
    self:TryMonsterFlash()
  end
end

function MonsterModelManager:TryMonsterPlayDeadAni()
  if self.monsterAni then
    local loadId = self.monsterCurData.curMonsterId
    local monsterTemp = self.monsterShowData[loadId].monsterTemp
    local aniName = monsterTemp.act_4
    local deadEffectDelay = 1.5
    local time = self.monsterAni:GetClipLength(aniName) + deadEffectDelay
    self.monsterAni:Stop()
    self.monsterAni:SetStateSpeed(aniName, 1)
    self.monsterAni:Play(aniName)
    self.showDataMonsterIdelTime = 0
    self.modelHideTime = time
    self:ClearDeadAniFadeTweens()
    self:ClearMonsterDeadAniTimer()
    local targetFrame = 60
    local allFrames = 85
    local delayTime = targetFrame / allFrames * time
    self.deadAniFadeTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:StartDeadAniFade()
      self:ClearMonsterDeadAniTimer()
    end, delayTime)
    if self.deadNode then
      self.deadNode.gameObject:SetActive(false)
      self.deadNode.gameObject:SetActive(true)
    end
    self:TryEndMonsterFlash()
  end
end

function MonsterModelManager:ClearMonsterDeadAniTimer()
  if self.deadAniFadeTimer then
    self.deadAniFadeTimer:Stop()
    self.deadAniFadeTimer = nil
  end
end

function MonsterModelManager:TryMonsterPlayEnterAni()
  if self.monsterAni then
    local loadId = self.monsterCurData.curMonsterId
    local monsterTemp = self.monsterShowData[loadId].monsterTemp
    local aniName = monsterTemp.act_5
    local atkTime = self.monsterAni:GetClipLength(aniName)
    self.monsterAni:Stop()
    self.monsterAni:SetStateSpeed(aniName, 1)
    self.monsterAni:Play(aniName)
    self.showDataMonsterIdelTime = atkTime
    self.modelHideTime = 0
    self:TryMonsterFlash()
    if self.attackManager then
      self.attackManager:PlayShowMonsterCameraAni()
    end
    if self.bornNode and not IsNull(self.bornNode) then
      self.bornNode.gameObject:SetActive(false)
      self.bornNode.gameObject:SetActive(true)
    end
  end
end

function MonsterModelManager:TryMonsterPlayTouchAttackedAni()
  if self.monsterAni then
    local loadId = self.monsterCurData.curMonsterId
    local monsterTemp = self.monsterShowData[loadId].monsterTemp
    local random = math.random()
    local aniName = 0.5 < random and monsterTemp.act_3 or monsterTemp.act_2
    local atkTime = self.monsterAni:GetClipLength(aniName)
    self.monsterAni:Stop()
    self.monsterAni:SetStateSpeed(aniName, 1)
    self.monsterAni:Play(aniName)
    self.showDataMonsterIdelTime = atkTime
    self.modelHideTime = 0
    self:TryMonsterFlash()
  end
end

function MonsterModelManager:TryMonsterFlash()
  if self.monsterRenders ~= nil then
    for k, v in pairs(self.monsterRenders) do
      v.renderer.sharedMaterial:SetFloat("_RimPow", 1)
    end
  end
  self.flashCountdown = 0.2
end

function MonsterModelManager:TryEndMonsterFlash()
  if self.monsterRenders ~= nil then
    for k, v in pairs(self.monsterRenders) do
      v.renderer.sharedMaterial:SetFloat("_RimPow", 0)
    end
  end
  self.flashCountdown = 0
end

function MonsterModelManager:StartDeadAniFade()
  if not self.monsterRenders then
    return
  end
  local fadeDuration = 0.3
  for k, v in pairs(self.monsterRenders) do
    local renderer = v.renderer
    if renderer and not IsNull(renderer) then
      local materials = renderer.materials
      if materials and materials.Length > 0 then
        for i = 0, materials.Length - 1 do
          local material = materials[i]
          if material and not IsNull(material) then
            do
              local startColor, colorPropertyName
              if material:HasProperty("_BaseColor") then
                startColor = material:GetColor("_BaseColor")
                colorPropertyName = "_BaseColor"
              elseif material:HasProperty("_Color") then
                startColor = material:GetColor("_Color")
                colorPropertyName = "_Color"
              end
              if startColor and colorPropertyName then
                do
                  local startAlpha = startColor.a
                  local tween = CS.DG.Tweening.DOTween.To(function(value)
                    if not IsNull(material) then
                      local newColor = CS.UnityEngine.Color.New(startColor.r, startColor.g, startColor.b, value)
                      material:SetColor(colorPropertyName, newColor)
                    end
                  end, startAlpha, 0, fadeDuration):SetEase(CS.DG.Tweening.Ease.Linear)
                  table.insert(self.deadAniFadeTweens, tween)
                end
              end
            end
          end
        end
      end
    end
  end
end

function MonsterModelManager:ClearDeadAniFadeTweens()
  if self.deadAniFadeTweens then
    for _, tween in ipairs(self.deadAniFadeTweens) do
      if tween and not IsNull(tween) then
        tween:Kill()
      end
    end
    self.deadAniFadeTweens = {}
  end
end

function MonsterModelManager:ResetMonsterAlpha()
  if not self.monsterRenders then
    return
  end
  self:ClearDeadAniFadeTweens()
  if self.deadAniFadeTimer then
    self.deadAniFadeTimer:Stop()
    self.deadAniFadeTimer = nil
  end
  for k, v in pairs(self.monsterRenders) do
    local renderer = v.renderer
    if renderer and not IsNull(renderer) then
      local materials = renderer.materials
      if materials and materials.Length > 0 then
        for i = 0, materials.Length - 1 do
          local material = materials[i]
          if material and not IsNull(material) then
            local startColor, colorPropertyName
            if material:HasProperty("_BaseColor") then
              startColor = material:GetColor("_BaseColor")
              colorPropertyName = "_BaseColor"
            elseif material:HasProperty("_Color") then
              startColor = material:GetColor("_Color")
              colorPropertyName = "_Color"
            end
            if startColor and colorPropertyName then
              local newColor = CS.UnityEngine.Color.New(startColor.r, startColor.g, startColor.b, 1.0)
              material:SetColor(colorPropertyName, newColor)
            end
          end
        end
      end
    end
  end
end

function MonsterModelManager:StartShow(modelShowManager)
  self.modelShowManager = modelShowManager
  self.monsterRoot = self.modelShowManager.scene.transform:Find("MonsterPos")
  self:TryCreateMonster()
end

function MonsterModelManager:TryCreateMonster()
  if self.modelShowManager == nil then
    return
  end
  if self.monsterShowData == nil then
    return
  end
  if self.monsterCurData == nil then
    return
  end
  self:CreateMonster()
end

function MonsterModelManager:CreateMonster()
  self.monsterLoadRequest = nil
  local loadId = self.monsterCurData.curMonsterId
  if self.modelLoadCache[loadId] then
    self.monsterLoadRequest = self.modelLoadCache[loadId]
    if not IsNull(self.monsterLoadRequest.gameObject) then
      self:CreateMonsterCallBack(self.monsterLoadRequest, loadId)
    end
  else
    self.monsterPath = self.monsterShowData[loadId].monsterTemp.model_name
    local req = Resource:InstantiateAsync(self.monsterPath)
    req:completed("+", function()
      self:CreateMonsterCallBack(req, loadId)
    end)
    self.monsterLoadRequest = req
    self.modelLoadCache[loadId] = req
  end
end

function MonsterModelManager:CreateMonsterCallBack(req, loadId)
  local curId = self.monsterCurData.curMonsterId
  if curId == loadId and self.monsterCurData.curMonsterState == BanquetAttackMonsterState.Normal then
    req.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("timeline"))
    self.monster = req.gameObject
    self.monster:SetActive(true)
    self.monster.transform.localScale = self.monsterRoot.transform.localScale * self.monsterShowData[loadId].monsterTemp.scale
    self.monster.transform.eulerAngles = self.monsterRoot.transform.eulerAngles
    self.monster.transform.position = self.monsterRoot.transform.position
    self.monsterAni = self.monster.transform:GetComponentInChildren(typeof(CS.SimpleAnimation))
    if IsNotNull(self.monsterAni) then
      self.monsterAni.cullingMode = CS.UnityEngine.AnimatorCullingMode.AlwaysAnimate
    end
    self.monsterRenders = {}
    local skinnedMeshRenderer = self.monster:GetComponentsInChildren(typeof(CS.UnityEngine.SkinnedMeshRenderer))
    local meshRenderer = self.monster:GetComponentsInChildren(typeof(CS.UnityEngine.MeshRenderer))
    for i = 0, skinnedMeshRenderer.Length - 1 do
      self.monsterRenders[i + 1] = {
        renderer = skinnedMeshRenderer[i],
        defaultMat = skinnedMeshRenderer[i].sharedMaterial
      }
    end
    local count = #self.monsterRenders
    for i = 0, meshRenderer.Length - 1 do
      if not string.find(meshRenderer[i].gameObject.name, "shadow", 1, true) and not string.find(meshRenderer[i].gameObject.name, "platform", 1, true) and meshRenderer[i].gameObject.name ~= "HpText" then
        self.monsterRenders[i + 1 + count] = {
          renderer = meshRenderer[i],
          defaultMat = meshRenderer[i].sharedMaterial
        }
      end
    end
    self.deadNode = self.monster.transform:Find("deadNode")
    local born_node_path = "A_Monster@Boss_ganlanqiu02_caidanTuer_skin/To_unity/DeformationSystem/Root/Root_M/bornNode"
    self.bornNode = self.monster.transform:Find(born_node_path)
    self.hitPos = self.monster.transform:Find("hitPos")
    if self.deadNode then
      self.deadNode.gameObject:SetActive(false)
    end
    if self.bornNode then
      self.bornNode.gameObject:SetActive(false)
    end
    if self.SetMonsterPlayEnterAtCallBack == true then
      self.SetMonsterPlayEnterAtCallBack = false
      self:TryMonsterPlayEnterAni()
      self:ResetMonsterAlpha()
    else
      self:TryMonsterPlayIdleAni()
    end
    self:TryEndMonsterFlash()
  else
    req.gameObject.transform.position = self.monsterRoot.transform.position
    req.gameObject:SetActive(false)
  end
  EventManager:GetInstance():Broadcast(EventId.ActBanquetAttackMonsterCreateMonsterFin)
end

function MonsterModelManager:EndShow()
  if self.modelLoadCache then
    for k, v in pairs(self.modelLoadCache) do
      v:Destroy()
    end
    self.modelLoadCache = {}
    self.monsterLoadRequest = nil
    self.monster = nil
    self.monsterAni = nil
    self.monsterRenders = nil
  end
  self:ClearDeadAniFadeTweens()
  self.modelShowManager = nil
  self.monsterRoot = nil
end

function MonsterModelManager:OnUpdate(deltaTime)
  if self.showDataMonsterIdelTime > 0 then
    self.showDataMonsterIdelTime = self.showDataMonsterIdelTime - deltaTime
    if self.showDataMonsterIdelTime <= 0 then
      self:TryMonsterPlayIdleAni()
    end
  end
  if 0 < self.flashCountdown then
    self.flashCountdown = self.flashCountdown - deltaTime
    if 0 >= self.flashCountdown then
      self:TryEndMonsterFlash()
    end
  end
  if 0 < self.modelHideTime then
    self.modelHideTime = self.modelHideTime - deltaTime
    if 0 >= self.modelHideTime then
      if self.monsterLoadRequest and not IsNull(self.monsterLoadRequest.gameObject) then
        self.monsterLoadRequest.gameObject:SetActive(false)
      end
      self:ClearDeadAniFadeTweens()
    end
  end
end

function MonsterModelManager:SetModelShowData(monsterShowData)
  self.monsterShowData = monsterShowData
end

function MonsterModelManager:SetCurData(monsterCurData)
  self.monsterCurData = monsterCurData
  if self.monsterLoadRequest and not IsNull(self.monsterLoadRequest.gameObject) then
    self.monsterLoadRequest.gameObject:SetActive(false)
  end
  self:TryCreateMonster()
end

function MonsterModelManager:SetAttackModelShowManager(attackManager)
  self.attackManager = attackManager
end

function MonsterModelManager:GetCurMonsterEnterAniTime()
  if self.monsterAni == nil or self.monsterCurData == nil or self.monsterShowData == nil then
    return 0
  end
  local loadId = self.monsterCurData.curMonsterId
  local showData = self.monsterShowData[loadId]
  if showData == nil or showData.monsterTemp == nil then
    return 0
  end
  local aniName = showData.monsterTemp.act_5
  if aniName == nil or aniName == "" then
    return 0
  end
  return self.monsterAni:GetClipLength(aniName)
end

function MonsterModelManager:GetHitPos()
  if self.hitPos then
    return self.hitPos.transform.position
  end
  return nil
end

return MonsterModelManager
