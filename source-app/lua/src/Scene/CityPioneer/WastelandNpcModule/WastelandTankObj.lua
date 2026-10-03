local base = require("Scene.CityPioneer.WastelandNpcModule.WastelandModelBase")
local TroopHeadUI = require("Scene.TroopHeadUI.TroopHeadUI")
local Resource = CS.GameEntry.Resource
local WastelandTankObj = BaseClass("WastelandTankObj", base)
local typeGPUSkinningAnimator = typeof(CS.GPUSkinningAnimator)
local ActionState = {Atk = 1, Run = 2}

function WastelandTankObj:__init(pos)
  base.__init(self, pos)
  self.m_curActionState = nil
  self.m_targetWorldPos = nil
  self.tmpVec = Vector3.New(0, 0, 0)
  self.m_targetPos = nil
  self:InstantiateObj()
end

function WastelandTankObj:OnDestroy()
  if self.m_req ~= nil then
    self.m_req:Destroy()
    self.m_req = nil
  end
  self:DestroyBlood()
end

function WastelandTankObj:SetActionState(actionState)
  if self.m_curActionState == actionState then
    return
  end
  self.m_curActionState = actionState
  if actionState == ActionState.Run then
    self:DoStateRun()
  elseif actionState == ActionState.Atk then
    self:DoStateAtk()
  end
end

function WastelandTankObj:IsAtkReady()
  return self.m_curActionState == ActionState.Atk
end

function WastelandTankObj:DoStateRun()
  if self.m_animator ~= nil then
    self.m_animator:Play("run")
  end
  self:DestroyBlood()
end

function WastelandTankObj:DoStateAtk()
  if self.m_animator ~= nil then
    self.m_animator:Play("idle")
  end
  self:ShowBloodBar()
end

function WastelandTankObj:SetTargetPos(pos, triggerId)
  self.m_targetPos = pos
  self.m_targetWorldPos = SceneUtils.TileToWorld(self.m_targetPos)
  self.m_targetTriggerId = triggerId
end

function WastelandTankObj:SetRotation()
  if self.m_curActionState == ActionState.Atk then
    local monsterObj = WastelandModelMgr:GetInstance():GetMonsterObj()
    if monsterObj == nil then
      return
    end
    local dis = monsterObj.transform.position - self:GetTransform().position
    self.tmpVec.x = dis.x
    self.tmpVec.z = dis.z
    local rotation = Quaternion.LookRotation(self.tmpVec, Vector3.up)
    self.m_gameObject.transform.rotation = rotation
  elseif self.m_curActionState == ActionState.Run then
    local _tmp1 = self.m_targetWorldPos - self.m_gameObject.transform.position
    local _disPos = Vector3.New(_tmp1.x, 0, _tmp1.z)
    local _targetQuaternion = Quaternion.LookRotation(_disPos, Vector3.up)
    local objTransform = self.m_gameObject.transform
    if _targetQuaternion ~= objTransform.rotation then
      objTransform.rotation = _targetQuaternion
    end
  end
end

function WastelandTankObj:GetRandomTarget()
  local tabMonster = WastelandModelMgr:GetInstance():GetAliveMonster()
  local tabCnt = table.count(tabMonster)
  if tabCnt == 0 then
    return nil
  end
  return table.randomArrayValue(tabMonster)
end

function WastelandTankObj:ShowBullet(damageValue)
  self:ShowAtkTalkBubble()
  local _prefabPath = "Assets/_Art/Effect/prefab/scene/VFX_putonggongji_forward.prefab"
  local _req = Resource:InstantiateAsync(_prefabPath)
  _req:completed("+", function(req)
    local _go = req.gameObject
    if _go == nil then
      return
    end
    _go.transform:SetParent(self.m_gameObject.transform)
    _go.transform.localPosition = Vector3.New(0, 0, 0)
    local target = self:GetRandomTarget()
    if target ~= nil then
      _go.transform:LookAt(target:GetTransform())
      target:RecvHit(damageValue)
    end
    TimerManager:GetInstance():DelayInvoke(function()
      if _req ~= nil then
        _req:Destroy()
      end
    end, 2.0)
  end)
end

function WastelandTankObj:ShowAtkTalkBubble()
  local dialogList = {
    335031,
    335032,
    335033
  }
  local dialogId = dialogList[math.random(3)]
  local talkParam = {}
  talkParam.talkType = NpcTalkType.Left
  talkParam.target = self.m_gameObject.transform
  talkParam.dialogId = dialogId
  talkParam.offset = Vector3.New(0, 2, 0)
  talkParam.force = false
  talkParam.duration = 3
  EventManager:GetInstance():Broadcast(EventId.ShowTalkBubble, talkParam)
end

function WastelandTankObj:InstantiateObj()
  local _prefabPath = "Assets/Main/Prefabs/CityScene/Wasteland/WastelandTank.prefab"
  self.m_req = Resource:InstantiateAsync(_prefabPath)
  self.m_req:completed("+", function(req)
    local _go = req.gameObject
    if _go == nil then
      return
    end
    self.m_gameObject = _go
    self.m_gameObject.transform.position = self.m_targetWorldPos
    self.m_gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("WorldArmy"))
    self.m_gameObject.tag = "Tank"
    local talkTrigger = self.m_gameObject:GetComponent(typeof(CS.UnityEngine.BoxCollider))
    if talkTrigger ~= nil then
      talkTrigger.enabled = true
    end
    self:InitComponent()
  end)
end

function WastelandTankObj:InitComponent()
  self.m_animator = self.m_gameObject:GetComponentInChildren(typeGPUSkinningAnimator)
  self:ShowBloodBar()
end

function WastelandTankObj:CheckActionState()
  if self.m_targetPos then
    local objPos = self.m_gameObject.transform.position
    local x, y = SceneUtils.WorldToTileXZ(objPos.x, objPos.z)
    print("[state] curx " .. tostring(x) .. " curY: " .. tostring(y) .. " tX: " .. tostring(self.m_targetPos.x) .. "  ty: " .. tostring(self.m_targetPos.y))
    if x == self.m_targetPos.x and y == self.m_targetPos.y then
      self:OnMoveEnd(self.m_targetPos)
      self.m_targetPos = nil
      self:SetActionState(ActionState.Atk)
    else
      self:SetActionState(ActionState.Run)
    end
  else
    self:SetActionState(ActionState.Atk)
  end
end

function WastelandTankObj:UpdateActionState()
  if self.m_curActionState == ActionState.Run then
    self:UpdateMove()
  elseif self.m_curActionState == ActionState.Atk then
  end
end

local speed = 0.1

function WastelandTankObj:UpdateMove()
  local objTransform = self:GetTransform()
  objTransform.position = objTransform.position + objTransform.forward * speed
end

function WastelandTankObj:OnUpdate()
  if self.m_gameObject == nil then
    return
  end
  self:CheckActionState()
  self:SetRotation()
  self:UpdateActionState()
end

function WastelandTankObj:ShowBloodBar()
  if self.m_reqBlood ~= nil then
    return
  end
  self.m_reqBlood = Resource:InstantiateAsync(UIAssets.WorldTroopHeadUI)
  self.m_reqBlood:completed("+", function(req)
    local _go = req.gameObject
    if _go == nil then
      return
    end
    req.gameObject.transform:SetParent(self:GetTransform())
    req.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    req.gameObject.transform:Set_localPosition(ResetPosition.x, ResetPosition.y + 2, ResetPosition.z + 1)
    local tileUI = TroopHeadUI.New()
    tileUI:OnCreate(req)
    tileUI:SetForWasteland()
  end)
end

function WastelandTankObj:DestroyBlood()
  if self.m_reqBlood ~= nil then
    self.m_reqBlood:Destroy()
    self.m_reqBlood = nil
  end
end

local troopHangPointPath = "rotationRoot/PvpHeadPoint"

function WastelandTankObj:ShowBattleGuideLine(transform, gameObject, firstShow)
  gameObject.transform:Set_localPosition(0, 0, 0)
  local targetFlow = gameObject.transform:Find("Transform"):GetComponent(typeof(CS.TargetFlow))
  local zOffset = -4.29
  local xOffset = 0
  local minY = 2
  local maxY = 6
  local target = transform:Find(troopHangPointPath)
  if target == nil then
    return
  end
  local color = CS.UnityEngine.Color.green
  targetFlow.target = target
  targetFlow.zOffset = zOffset
  targetFlow.xOffset = xOffset
  targetFlow.minYoffset = minY
  targetFlow.maxYoffset = maxY
  targetFlow.lineColor = color
  if firstShow then
    targetFlow:DoFlowAnim(0.5)
  end
  gameObject:SetActive(true)
end

function WastelandTankObj:OnMoveEnd(pos)
  print("OnMoveEnd: (" .. tostring(pos.x) .. "," .. tostring(pos.y) .. ")" .. "---trigger id: " .. tostring(self.m_targetTriggerId))
  if not string.IsNullOrEmpty(self.m_targetTriggerId) then
    DataCenter.CityTriggerPointDataManager:AddOneTrigger(self.m_targetTriggerId)
    self.m_targetTriggerId = nil
  end
end

return WastelandTankObj
