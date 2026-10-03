local base = require("Scene.CityPioneer.SpaceMan.CitySpaceManAnimation.CitySpaceManAniBase")
local CitySpaceManAniAdjustRun = BaseClass("CitySpaceManAniAdjustRun", base)
local Rigidbody = typeof(CS.UnityEngine.Rigidbody)
local leftprintEffect = "Assets/_Art/Effect/prefab/Arms/Taikongbing/VFX_taikongbing_movesmoke_left.prefab"
local rightprintEffect = "Assets/_Art/Effect/prefab/Arms/Taikongbing/VFX_taikongbing_movesmoke_right.prefab"
local eventPath = "A_soldie_ben/A_soldie@ben_skin"
local leftPointPath = "A_soldie_ben/LeftStepPoint"
local rightPointPath = "A_soldie_ben/RightStepPoint"
local m_timer
local stepDic = {}
local Resource = CS.GameEntry.Resource
local AutoMoveDelta = 6
local ExitDis = 0.5

function CitySpaceManAniAdjustRun:__init(spaceman)
  base.__init(self, spaceman)
  self.m_tmpV = Vector3.New(0, 0, 0)
  self.m_tmpOldV = Vector3.New(0, 0, 0)
  local obj = self.m_citySpaceMan:GetInstantiateObj()
  if obj ~= nil then
    self.m_rigidbody = obj:GetComponent(Rigidbody)
  end
  self.leftPoint = obj.transform:Find(leftPointPath)
  self.rightPoint = obj.transform:Find(rightPointPath)
  self.triggerEvent = obj.transform:Find(eventPath):GetComponent(typeof(CS.CitySpaceManAnimationListener))
  if self.triggerEvent ~= nil then
    function self.triggerEvent.animation_walkLeft()
      self:OnWalkLeft()
    end
    
    function self.triggerEvent.animation_walkRight()
      self:OnWalkRight()
    end
  end
  self.m_ratio = 0.0
  self.m_isExit = false
  self.m_isFirstIn = false
  self.m_SlowDownTimer = nil
end

function CitySpaceManAniAdjustRun:OnWalkLeft()
  table.insert(stepDic, "walkLeft")
end

function CitySpaceManAniAdjustRun:OnWalkRight()
  table.insert(stepDic, "walkRight")
end

function CitySpaceManAniAdjustRun:CloneEffect(path, root, euler)
  local Inst = Resource:InstantiateAsync(path)
  Inst:completed("+", function(req)
    req.gameObject.transform:SetParent(root)
    req.gameObject.transform.localPosition = Vector3.New(0, 0, 0)
    req.gameObject.transform.localRotation = euler
    req.gameObject.transform:SetParent(self.sceneRootTransfrom)
    req.gameObject.transform.localScale = Vector3.New(1, 1, 1)
    local destroyTimer = TimerManager:GetInstance():GetTimer(3, function()
      Inst:Destroy()
    end, nil, true, false, false)
    destroyTimer:Start()
  end)
end

function CitySpaceManAniAdjustRun:OnPlayEffect()
  if self.leftPoint == nil or self.rightPoint == nil then
    return
  end
  for k, v in pairs(stepDic) do
    if v ~= nil then
      if v == "walkLeft" then
        local euler = Quaternion.Euler(-90, 0, -90)
        self:CloneEffect(leftprintEffect, self.leftPoint, euler)
      else
        local euler = Quaternion.Euler(-90, 0, 0)
        self:CloneEffect(rightprintEffect, self.rightPoint, euler)
      end
    end
    stepDic[k] = nil
  end
end

function CitySpaceManAniAdjustRun:ClearTriggerEvent()
  if self.triggerEvent then
    self.triggerEvent.animation_walkLeft = nil
    self.triggerEvent.animation_walkRight = nil
    self.triggerEvent = nil
  end
end

function CitySpaceManAniAdjustRun:OnEnter()
  base.OnEnter(self)
  self.m_ratio = 0.0
  self.m_isFirstIn = true
  self.m_isExit = false
  self:SetData()
  self:CheckEnd()
end

function CitySpaceManAniAdjustRun:OnExit()
  self:ClearTriggerEvent()
  self.m_isExit = true
  self.m_isFirstIn = true
  if not self.m_citySpaceMan:IsSlowMode() then
    self:AddSlowDownTimer()
  end
end

function CitySpaceManAniAdjustRun:GetSpeedRatio()
  if self.m_isExit then
    self.m_ratio = 0
    if self.m_ratio < 0 then
      self.m_ratio = 0
    end
  else
    self.m_ratio = 1
    if self.m_ratio > 1 then
      self.m_ratio = 1
    end
  end
  return self.m_ratio
end

function CitySpaceManAniAdjustRun:ResetSpeedRatio()
  self.m_ratio = 0
end

function CitySpaceManAniAdjustRun:AddSlowDownTimer()
  self:RemoveTimer()
  if self.m_SlowDownTimer == nil then
    function self.m_SlowDownTimer()
      self:OnSlowDown()
    end
  end
  UpdateManager:GetInstance():AddUpdate(self.m_SlowDownTimer)
end

function CitySpaceManAniAdjustRun:RemoveTimer()
  if self.m_SlowDownTimer == nil then
    return
  end
  UpdateManager:GetInstance():RemoveUpdate(self.m_SlowDownTimer)
  self.m_SlowDownTimer = nil
end

local speed = 0.08

function CitySpaceManAniAdjustRun:OnSlowDown()
  local tmpSpeed = speed
  if self.m_citySpaceMan:IsSlowMode() then
    tmpSpeed = tmpSpeed * 0.3
  end
  tmpSpeed = tmpSpeed * self:GetSpeedRatio()
  if tmpSpeed < 0.06 then
    self:RemoveTimer()
    return
  end
  local objTransform = self.m_citySpaceMan:GetTransform()
  if objTransform == nil then
    self:RemoveTimer()
    return
  end
  local ret, hitInfo = CS.CSUtils.Hit(objTransform, 0.4, tmpSpeed)
  if ret == true then
    objTransform.position = objTransform.position + hitInfo * tmpSpeed
  else
    objTransform.position = objTransform.position + objTransform.forward * tmpSpeed
  end
end

function CitySpaceManAniAdjustRun:DoTurnTo()
  local objTransform = self.m_citySpaceMan:GetTransform()
  local _targetQuaternion = Quaternion.LookRotation(self.m_tmpV, Vector3.up)
  if _targetQuaternion ~= objTransform.rotation then
    objTransform.rotation = Quaternion.Lerp(objTransform.rotation, _targetQuaternion, Time.deltaTime * 10)
  end
end

function CitySpaceManAniAdjustRun:OnUpdate()
  self:SetVelocity(self.vx, self.vz)
  self:OnPlayEffect()
  if not self.m_citySpaceMan:IsFarmMode() then
    self:DoTurnTo()
  end
end

function CitySpaceManAniAdjustRun:SetVelocity(vx, vz)
  self.m_tmpV:Set(vx, 0, vz)
  if self.m_isFirstIn == true then
    self.m_isFirstIn = false
    self.m_tmpOldV:Set(vx, 0, vz)
  end
  if 0 > Vector3.Dot(self.m_tmpV, self.m_tmpOldV) then
    self:ResetSpeedRatio()
  end
  self.m_tmpOldV:Set(vx, 0, vz)
  if self.m_tmpV.x == 0 and self.m_tmpV.z == 0 then
    return
  end
  local tmpSpeed = speed
  if self.m_citySpaceMan:IsSlowMode() then
    tmpSpeed = tmpSpeed * 0.3
  else
    tmpSpeed = tmpSpeed * self:GetSpeedRatio()
  end
  local _targetQuaternion = Quaternion.LookRotation(self.m_tmpV, Vector3.up)
  local objTransform = self.m_citySpaceMan:GetTransform()
  if self.m_citySpaceMan:IsFarmMode() and _targetQuaternion ~= objTransform.rotation then
    objTransform.rotation = _targetQuaternion
  end
  local ret, hitInfo = CS.CSUtils.Hit(objTransform, 0.4, tmpSpeed)
  if ret == true then
    self.nowPos = objTransform.position + hitInfo * tmpSpeed
  else
    self.nowPos = objTransform.position + objTransform.forward * tmpSpeed
  end
  objTransform.position = self.nowPos
  self:CheckEnd()
end

function CitySpaceManAniAdjustRun:SetData()
  self.finalPos = self.m_citySpaceMan:GetPosWithExtra()
  self.nowPos = self.m_citySpaceMan:GetPosition()
  local velocity = Vector3.Normalize(self.finalPos - self.nowPos)
  self.vx = velocity.x * AutoMoveDelta
  self.vz = velocity.z * AutoMoveDelta
  self.m_tmpV:Set(self.vx, 0, self.vz)
  self.dis = Vector3.Distance(self.nowPos, self.finalPos)
end

function CitySpaceManAniAdjustRun:CheckEnd()
  local dis = Vector3.Distance(self.nowPos, self.finalPos)
  if dis > self.dis then
    self:SetData()
  elseif dis <= ExitDis then
    self.dis = dis
    self.m_citySpaceMan:LeaveAdjustRun()
  end
end

return CitySpaceManAniAdjustRun
