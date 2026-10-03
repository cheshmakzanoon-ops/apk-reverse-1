local MonsterModelManager = BaseClass("MonsterModelManager")
local Resource = CS.GameEntry.Resource
local monsterIdle = "idle"
local monsterWeakIdle = "stun"
local monsterHurt = "hit_putong"
local monsterHurt2 = "hit"
local weakEffectPath = "A_Monster_nianshou_beida/A_Monster@nianshou_skin/DeformationSystem/Root_M/Spine1_M/Chest_M/Neck_M/Head_M/HeadEnd_M/Eff_nianshou_xuanyun"
local MonsterAttackedTime = 0.6
local MonsterAttackedTime2 = 0.9
local white_time = 0.5

function MonsterModelManager:__init()
  self:DataDefine()
end

function MonsterModelManager:__delete()
  self:OnDestroy()
end

function MonsterModelManager:DataDefine()
  self.modelShowManager = nil
  self.monsterPath = "Assets/Main/Prefabs/UIChristmasPerfab/A_Monster_nianshou.prefab"
  self.monsterLoadRequest = nil
  self.monsterRoot = nil
  self.monster = nil
  self.monsterAni = nil
  self.monsterRenders = nil
  self.weakEffect = nil
  self.flashCountdown = 0
  self.isMonsterWeak = false
  self.showDataMonsterIdelTime = 0
end

function MonsterModelManager:OnDestroy()
  self.modelShowManager = nil
  self.monsterPath = nil
  self.monsterLoadRequest = nil
  self.monsterRoot = nil
  self.monster = nil
  self.monsterAni = nil
  self.monsterRenders = nil
  self.weakEffect = nil
  self.flashCountdown = nil
  self.showDataMonsterIdelTime = nil
  self.isMonsterWeak = nil
end

function MonsterModelManager:TryMonsterPlayAttackedAni(isHit)
  if self.monsterAni then
    local aniName = monsterHurt
    local atkTime = MonsterAttackedTime
    if isHit then
      aniName = monsterHurt2
      atkTime = MonsterAttackedTime2
    end
    self.monsterAni:Stop()
    self.monsterAni:SetStateSpeed(aniName, 1)
    self.monsterAni:Play(aniName)
    self.showDataMonsterIdelTime = atkTime
    self.weakEffect:SetActive(false)
    self:TryMonsterFlash()
  end
end

function MonsterModelManager:TryMonsterPlayTouchAttackedAni()
  if self.monsterAni then
    local random = math.random()
    local aniName = monsterHurt
    local atkTime = MonsterAttackedTime
    if 0.5 < random then
      aniName = monsterHurt2
      atkTime = MonsterAttackedTime2
    end
    self.monsterAni:Stop()
    self.monsterAni:SetStateSpeed(aniName, 1)
    self.monsterAni:Play(aniName)
    self.showDataMonsterIdelTime = atkTime
  end
end

function MonsterModelManager:TryMonsterPlayIdleAni()
  if self.monsterAni then
    local aniName = monsterIdle
    if self.isMonsterWeak then
      aniName = monsterWeakIdle
    end
    self.monsterAni:Stop()
    self.monsterAni:SetStateSpeed(aniName, 1)
    self.monsterAni:Play(aniName)
    self.weakEffect:SetActive(self.isMonsterWeak)
    self:TryEndMonsterFlash()
  end
end

function MonsterModelManager:SetMonsterIsWeak(isWeak)
  self.isMonsterWeak = isWeak
  self:TryMonsterPlayIdleAni()
end

function MonsterModelManager:TryMonsterFlash()
  if self.monsterRenders ~= nil then
    for k, v in pairs(self.monsterRenders) do
      v.renderer.sharedMaterial:SetFloat("_RimPow", 1)
    end
  end
  self.flashCountdown = white_time
end

function MonsterModelManager:TryEndMonsterFlash()
  if self.monsterRenders ~= nil then
    for k, v in pairs(self.monsterRenders) do
      v.renderer.sharedMaterial:SetFloat("_RimPow", 0)
    end
  end
  self.flashCountdown = 0
end

function MonsterModelManager:StartShow(modelShowManager)
  self.modelShowManager = modelShowManager
  self.monsterRoot = self.modelShowManager.scene.transform:Find("MonsterPos")
  self:CreateMonster()
end

function MonsterModelManager:CreateMonster()
  self.monsterLoadRequest = nil
  local req = Resource:InstantiateAsync(self.monsterPath)
  req:completed("+", function()
    local monsterRoot = req.gameObject.transform
    req.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("timeline"))
    monsterRoot:Set_localPosition(0, 0, 0)
    self.monster = req.gameObject
    self.monster.transform.position = self.monsterRoot.transform.position
    self.monster.transform.localScale = Vector3.one * 0.17
    self.monster.transform.eulerAngles = Vector3.New(0, 180, 0)
    self.monsterAni = self.monster.transform:GetComponentInChildren(typeof(CS.SimpleAnimation))
    self.weakEffect = self.monster.transform:Find(weakEffectPath).gameObject
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
    self:TryMonsterPlayIdleAni()
  end)
  self.monsterLoadRequest = req
end

function MonsterModelManager:EndShow()
  if self.monsterLoadRequest then
    self.monsterLoadRequest:RealDestroy()
    self.monsterLoadRequest = nil
    self.monster = nil
    self.monsterAni = nil
    self.monsterRenders = nil
  end
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
end

return MonsterModelManager
