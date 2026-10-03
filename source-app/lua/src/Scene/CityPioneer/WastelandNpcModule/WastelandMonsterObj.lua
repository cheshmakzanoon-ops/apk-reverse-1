local base = require("Scene.CityPioneer.WastelandNpcModule.WastelandModelBase")
local Resource = CS.GameEntry.Resource
local WastelandMonster = BaseClass("WastelandMonster", base)
local MonsterHeadUI = require("Scene.TroopHeadUI.MonsterHeadUI")
local SimpleAnimationType = typeof(CS.SimpleAnimation)
local ActionState = {
  Idle = 1,
  Atk = 2,
  Dead = 3,
  Damage = 4,
  Birth = 5
}
local Const_MaxHp = 100

function WastelandMonster:__init(pos)
  base.__init(self, pos)
  self.m_initPos = pos
  self.m_objBloodBar = nil
  self.m_waitBirth = false
  self.m_curHp = Const_MaxHp
  self:InstantiateObj()
end

function WastelandMonster:GetPos()
  return self.m_initPos
end

function WastelandMonster:GetMaxHp()
  return Const_MaxHp
end

function WastelandMonster:RecvHit(damageValue)
  self.m_curHp = self.m_curHp - damageValue
  TimerManager:GetInstance():DelayInvoke(function()
    if self.tileUI ~= nil then
      self.tileUI:SetHP(self.m_curHp, Const_MaxHp)
    end
    if self.m_curHp <= 0 then
      self:SetActionState(ActionState.Dead)
    else
      self:SetActionState(ActionState.Damage)
    end
  end, 0.2)
end

function WastelandMonster:IsAlive()
  return self.m_curHp > 0
end

function WastelandMonster:SetActionState(actionState)
  if actionState == ActionState.Idle then
    self:DoStateIdle()
  elseif actionState == ActionState.Atk then
    self:DoStateAtk()
  elseif actionState == ActionState.Dead then
    self:DoStateDead()
  elseif actionState == ActionState.Damage then
    self:DoStateDamage()
  elseif actionState == ActionState.Birth then
    self:DoStateBirth()
  end
end

function WastelandMonster:PlayAnimationByName(tabname)
  local tabCnt = table.count(tabname)
  if self.m_animator == nil or tabCnt == 0 then
    return
  end
  for i = 1, tabCnt do
    if i == 1 then
      self.m_animator:Play(tabname[i])
    else
      self.m_animator:PlayQueued(tabname[i])
    end
  end
end

function WastelandMonster:DoStateBirth()
  self._delayBirth = TimerManager:GetInstance():DelayInvoke(function()
    self._delayBirth = nil
    local oldPos = self:GetTransform().position
    self:GetTransform().position = Vector3.New(oldPos.x, oldPos.y - 20, oldPos.z)
    self:ShowObject()
    self:GetTransform():DOMoveY(oldPos.y, 1.0)
    local tab = {
      "hxr02_birth",
      "hxr02_idle_02"
    }
    self:PlayAnimationByName(tab)
  end, 2.0)
end

function WastelandMonster:DoStateIdle()
  local tab = {
    "hxr02_idle_02"
  }
  self:PlayAnimationByName(tab)
end

function WastelandMonster:DoStateAtk()
  local tab = {
    "hxr02_attack_01",
    "hxr02_idle_02"
  }
  self:PlayAnimationByName(tab)
end

function WastelandMonster:HideObject()
  if self.m_gameObject ~= nil then
    self.m_gameObject:SetActive(false)
  end
  if self.m_objBloodBar ~= nil then
    self.m_objBloodBar:SetActive(false)
  end
end

function WastelandMonster:ShowObject()
  if self.m_gameObject ~= nil then
    self.m_gameObject:SetActive(true)
  end
  if self.m_objBloodBar ~= nil then
    self.m_objBloodBar:SetActive(true)
  end
end

function WastelandMonster:DoStateDead()
  local tab = {
    "hxr02_death"
  }
  self:PlayAnimationByName(tab)
  self.delayTimer_hide = TimerManager:GetInstance():DelayInvoke(function()
    self.delayTimer_hide = nil
    self:HideObject()
  end, 2.0)
  if self.m_objBloodBar ~= nil then
    self.m_objBloodBar:SetActive(false)
  end
end

function WastelandMonster:DoStateDamage()
  local tab = {
    "hxr02_hit_02",
    "hxr02_idle_02"
  }
  self:PlayAnimationByName(tab)
  self:RandomHurtTalk()
end

function WastelandMonster:RandomHurtTalk()
  local t = math.random(20)
  if 2 < t then
    return
  end
  local dialogId = t == 1 and 335034 or 335035
  local talkParam = {}
  talkParam.talkType = NpcTalkType.Right
  talkParam.target = self.m_gameObject.transform
  talkParam.dialogId = dialogId
  talkParam.offset = Vector3.New(0, 2, 0)
  talkParam.force = false
  talkParam.duration = 1.5
  EventManager:GetInstance():Broadcast(EventId.ShowTalkBubble, talkParam)
end

function WastelandMonster:ToAttack()
  self:SetActionState(ActionState.Atk)
end

function WastelandMonster:ToDead()
  self:SetActionState(ActionState.Dead)
end

function WastelandMonster:OnDestroy()
  if self.delayTimer_hide ~= nil then
    self.delayTimer_hide:Stop()
    self.delayTimer_hide = nil
  end
  if self.m_req ~= nil then
    self.m_req:Destroy()
    self.m_req = nil
  end
  if self._delayBirth ~= nil then
    self._delayBirth:Stop()
    self._delayBirth = nil
  end
  self:DestroyBlood()
end

function WastelandMonster:SetRotation()
  local tankObj = WastelandModelMgr:GetInstance():GetTankObj()
  if tankObj == nil then
    return
  end
  self.m_gameObject.transform:LookAt(tankObj.transform)
  local rotation = self.m_gameObject.transform.rotation
  if self.m_objBloodBar ~= nil then
    self.m_objBloodBar.transform.rotation = Quaternion.Euler(0, -rotation.y, 0)
  end
end

function WastelandMonster:InstantiateObj()
  local _prefabPath = "Assets/_Art/Models/Monster/HuoXinRen/prefab/A_Monster_hxr.prefab"
  self.m_req = Resource:InstantiateAsync(_prefabPath)
  self.m_req:completed("+", function(req)
    local _go = req.gameObject
    if _go == nil then
      return
    end
    self.m_gameObject = _go
    local worldPos = SceneUtils.TileToWorld(self.m_initPos)
    self.m_gameObject.transform.position = worldPos
    self.m_gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("WorldArmy"))
    self.m_gameObject.tag = "Monster"
    local talkTrigger = self.m_gameObject:GetComponent(typeof(CS.UnityEngine.BoxCollider))
    if talkTrigger ~= nil then
      talkTrigger.enabled = true
    end
    self:ShowBloodBar()
    self:InitComponent()
  end)
end

function WastelandMonster:InitComponent()
  local _cp_skin = "A_Monster@hxr02_skin"
  local _objSkin = self.m_gameObject.transform:Find(_cp_skin)
  if _objSkin ~= nil then
    self.m_animator = _objSkin:GetComponent(SimpleAnimationType)
  end
  if WastelandModelMgr:GetInstance():GetRoundIdx() < 2 then
    self:ShowObject()
    self:SetActionState(ActionState.Idle)
  else
    self:HideObject()
    self.m_waitBirth = true
  end
end

function WastelandMonster:OnUpdate()
  if self.m_gameObject == nil then
    return
  end
  self:SetRotation()
  if self.m_waitBirth == true then
    self.m_waitBirth = false
    self:SetActionState(ActionState.Birth)
  end
end

function WastelandMonster:ShowBloodBar()
  if self.m_reqBlood ~= nil then
    return
  end
  self.m_reqBlood = Resource:InstantiateAsync(UIAssets.WorldTroopMonsterPro)
  self.m_reqBlood:completed("+", function(req)
    local _go = req.gameObject
    if _go == nil then
      return
    end
    req.gameObject.transform:SetParent(self:GetTransform())
    req.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    req.gameObject.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.m_objBloodBar = req.gameObject
    self.tileUI = MonsterHeadUI.New()
    self.tileUI:OnCreate(req)
    self.tileUI:SetForWasteland()
  end)
end

function WastelandMonster:DestroyBlood()
  if self.m_reqBlood ~= nil then
    self.m_reqBlood:Destroy()
    self.m_reqBlood = nil
  end
end

return WastelandMonster
