local LWBeginnerArmyNpc = BaseClass("LWBeginnerArmyNpc")
local battleTopEffectPath = "Assets/Main/Prefabs/Monopoly/Effect/battleEffect.prefab"

function LWBeginnerArmyNpc:__init()
end

function LWBeginnerArmyNpc:__delete()
  self:Clear()
end

function LWBeginnerArmyNpc:Initialize(index, npcData, state)
  self.index = index
  self.state = state
  self.armyId = npcData.armyId
  self.modelPath = npcData.model
  self.posX = npcData.pos.x
  self.posZ = npcData.pos.y
  self.fightParam = npcData.fightParam
  self.OnFightEnter = npcData.OnFightEnter
  self.OnDefeat = npcData.OnDefeat
  self.resHandle = CS.GameEntry.Resource:InstantiateAsync(self.modelPath, ObjectPoolTag.Normal, LoadPriority.Low)
  self.resHandle:completed("+", function(handle)
    if IsNull(handle.gameObject) then
      Logger.LogError("load res failed:" .. self.modelPath)
      return
    end
    self.gameObject = handle.gameObject
    self.transform = self.gameObject.transform
    self.transformValid = true
    self.transform.position = Vector3(self.posX, 0, self.posZ)
    self.transform.forward = Vector3(0, 0, 1)
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.animation = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
    self.deadAniLength = self.animation:GetClipLength("dead")
    self.attackAniLength = self.animation:GetClipLength("attack")
    self:LoadBattleEffect()
    if self.state == 1 then
      self:PlayDead()
      if self.OnDefeat then
        self.OnDefeat(self.index, Vector3(self.posX, 0, self.posZ), Vector3(0, 0, 0))
      end
    else
      self:PlayAttack()
    end
  end)
end

function LWBeginnerArmyNpc:GetPositionXZ()
  return self.posX, self.posZ
end

function LWBeginnerArmyNpc:LoadBattleEffect()
  self.battleEffectHandle = CS.GameEntry.Resource:InstantiateAsync(battleTopEffectPath)
  self.battleEffectHandle:completed("+", function(req)
    if IsNull(req.gameObject) then
      Logger.LogError("load res failed:" .. battleTopEffectPath)
      return
    end
    local battleEffectGo = req.gameObject
    battleEffectGo.transform.position = self.transform.position + Vector3.New(0, 8, 0)
    self.battleEffectGo = battleEffectGo
    self.touchTrigger = battleEffectGo:GetComponent(typeof(CS.TouchObjectEventTrigger))
    if not IsNull(self.touchTrigger) then
      function self.touchTrigger.onPointerClick()
        if self.state == 0 and self.fightParam then
          DataCenter.LWBattleManager:Enter(self.fightParam)
          
          if self.OnFightEnter then
            self.OnFightEnter(self.index, Vector3(self.posX, 0, self.posZ), Vector3(0, 0, 0))
          end
        end
      end
    end
    self.battleEffectGo:SetActive(self.state == 0)
  end)
end

function LWBeginnerArmyNpc:UpdateState(state)
  if self.state ~= state then
    self.state = state
    if self.battleEffectGo then
      self.battleEffectGo:SetActive(self.state == 0)
    end
    if state == 1 then
      self:PlayDead()
    else
      self:PlayAttack()
    end
  end
end

function LWBeginnerArmyNpc:Clear()
  self.index = nil
  self.armyId = nil
  self.modelPath = nil
  self.fightParam = nil
  self.OnFightEnter = nil
  self.OnDefeat = nil
  self:ClearDeadDisapearTimer()
  self:ClearAttackTimer()
  if not IsNull(self.touchTrigger) then
    self.touchTrigger.onPointerClick = nil
    self.touchTrigger = nil
  end
  if not IsNull(self.resHandle) then
    self.resHandle:Destroy()
    self.resHandle = nil
  end
  if not IsNull(self.battleEffectHandle) then
    self.battleEffectHandle:Destroy()
    self.battleEffectHandle = nil
  end
  self.battleEffectGo = nil
  self.deadAniLength = nil
  self.gameObject = nil
  self.transform = nil
  self.transformValid = nil
  self.animation = nil
  self.state = nil
end

function LWBeginnerArmyNpc:PlayAttack()
  self:ClearAttackTimer()
  if not self.animation then
    return
  end
  self.animation:Play("attack")
  self.delayPlayAttack = TimerManager:GetInstance():DelayInvoke(function()
    self.animation:Rewind()
    self:PlayAttack()
  end, self.attackAniLength)
end

function LWBeginnerArmyNpc:PlayIdle()
  if not self.animation then
    return
  end
  self.animation:Play("idle")
end

function LWBeginnerArmyNpc:PlayDead()
  if not self.animation then
    return
  end
  self:ClearDeadDisapearTimer()
  self.deadDisTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:DisAppear()
  end, self.deadAniLength)
  self.animation:Play("dead")
end

function LWBeginnerArmyNpc:DisAppear()
  self.gameObject:SetActive(false)
end

function LWBeginnerArmyNpc:ClearDeadDisapearTimer()
  if self.deadDisTimer then
    self.deadDisTimer:Stop()
    self.deadDisTimer = nil
  end
end

function LWBeginnerArmyNpc:ClearAttackTimer()
  if self.delayPlayAttack then
    self.delayPlayAttack:Stop()
    self.delayPlayAttack = nil
  end
end

return LWBeginnerArmyNpc
