local base = require("Scene.CityPioneer.SpaceMan.CitySpaceManAnimation.CitySpaceManAniBase")
local CitySpaceManAniRun = BaseClass("CitySpaceManAniRun", base)
local Rigidbody = typeof(CS.UnityEngine.Rigidbody)
local leftprintEffect = "Assets/_Art/Effect/prefab/Arms/Taikongbing/VFX_taikongbing_movesmoke_left.prefab"
local rightprintEffect = "Assets/_Art/Effect/prefab/Arms/Taikongbing/VFX_taikongbing_movesmoke_right.prefab"
local eventPath = "A_soldie_ben/A_soldie@ben_skin"
local leftPointPath = "A_soldie_ben/LeftStepPoint"
local rightPointPath = "A_soldie_ben/RightStepPoint"
local stepDic = {}
local Resource = CS.GameEntry.Resource
local speed = 0.004
local InitMoveDeltaTime = 20
local CollectSize = 0.54

function CitySpaceManAniRun:__init(spaceman)
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

function CitySpaceManAniRun:OnWalkLeft()
  table.insert(stepDic, "walkLeft")
end

function CitySpaceManAniRun:OnWalkRight()
  table.insert(stepDic, "walkRight")
end

function CitySpaceManAniRun:CloneEffect(path, root, euler)
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

function CitySpaceManAniRun:OnPlayEffect()
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

function CitySpaceManAniRun:ClearTriggerEvent()
  if self.triggerEvent then
    self.triggerEvent.animation_walkLeft = nil
    self.triggerEvent.animation_walkRight = nil
    self.triggerEvent = nil
  end
end

function CitySpaceManAniRun:OnEnter()
  base.OnEnter(self)
  self.lastMoveTime = UITimeManager:GetInstance():GetServerTime() - InitMoveDeltaTime
  self.m_ratio = 0.0
  self.m_isFirstIn = true
  self.m_isExit = false
end

function CitySpaceManAniRun:OnExit()
  self:ClearTriggerEvent()
  self.m_isExit = true
  self.m_isFirstIn = true
  if not self.m_citySpaceMan:IsSlowMode() then
    self:AddSlowDownTimer()
  end
end

function CitySpaceManAniRun:GetSpeedRatio()
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

function CitySpaceManAniRun:ResetSpeedRatio()
  self.m_ratio = 0
end

function CitySpaceManAniRun:AddSlowDownTimer()
  self:RemoveTimer()
  if self.m_SlowDownTimer == nil then
    function self.m_SlowDownTimer()
      self:OnSlowDown()
    end
  end
  self.lastMoveTime = UITimeManager:GetInstance():GetServerTime() - InitMoveDeltaTime
  UpdateManager:GetInstance():AddUpdate(self.m_SlowDownTimer)
end

function CitySpaceManAniRun:RemoveTimer()
  if self.m_SlowDownTimer == nil then
    return
  end
  UpdateManager:GetInstance():RemoveUpdate(self.m_SlowDownTimer)
  self.m_SlowDownTimer = nil
end

function CitySpaceManAniRun:OnSlowDown()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local tmpSpeed = speed
  if self.m_citySpaceMan:IsSlowMode() then
    tmpSpeed = tmpSpeed * 0.3
  end
  tmpSpeed = tmpSpeed * self:GetSpeedRatio()
  if tmpSpeed < 0.003 then
    self.lastMoveTime = curTime
    self:RemoveTimer()
    return
  end
  local objTransform = self.m_citySpaceMan:GetTransform()
  if objTransform == nil then
    self.lastMoveTime = curTime
    self:RemoveTimer()
    return
  end
  tmpSpeed = (curTime - self.lastMoveTime) * tmpSpeed
  self.lastMoveTime = curTime
  local newForward
  local canChange = true
  local pos = self.m_citySpaceMan:GetPosition()
  local newPos
  local ret, hitInfo = CS.CSUtils.Hit(objTransform, CollectSize, tmpSpeed)
  if ret == true then
    canChange = false
    newForward = hitInfo
  else
    newForward = objTransform.forward
  end
  canChange, newForward = CityPioneerFog:GetInstance():CheckWalkPos(pos, newForward, tmpSpeed, canChange)
  if newForward == nil then
    newPos = pos
  else
    newPos = pos + newForward * tmpSpeed
  end
  newPos.y = 0
  self.m_citySpaceMan:SetPosition(newPos)
end

function CitySpaceManAniRun:DoTurnTo()
  local objTransform = self.m_citySpaceMan:GetTransform()
  local _targetQuaternion = Quaternion.LookRotation(self.m_tmpV, Vector3.up)
  if _targetQuaternion ~= objTransform.rotation then
    objTransform.rotation = Quaternion.Lerp(objTransform.rotation, _targetQuaternion, Time.deltaTime * 10)
  end
end

function CitySpaceManAniRun:OnUpdate()
  self:OnPlayEffect()
  if not self.m_citySpaceMan:IsFarmMode() then
    self:DoTurnTo()
  end
end

function CitySpaceManAniRun:SetVelocity(vx, vz)
  local curTime = UITimeManager:GetInstance():GetServerTime()
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
    self.lastMoveTime = curTime
    return
  end
  local tmpSpeed = speed
  if self.m_citySpaceMan:IsSlowMode() then
    tmpSpeed = tmpSpeed * 0.3
  else
    tmpSpeed = tmpSpeed * self:GetSpeedRatio()
  end
  local deltaTime = curTime - self.lastMoveTime
  tmpSpeed = deltaTime * tmpSpeed
  self.lastMoveTime = curTime
  local _targetQuaternion = Quaternion.LookRotation(self.m_tmpV, Vector3.up)
  local objTransform = self.m_citySpaceMan:GetTransform()
  if self.m_citySpaceMan:IsFarmMode() and _targetQuaternion ~= objTransform.rotation then
    objTransform.rotation = _targetQuaternion
  end
  local newForward
  local canChange = true
  local pos = self.m_citySpaceMan:GetPosition()
  local ret, hitInfo = CS.CSUtils.Hit(objTransform, CollectSize, tmpSpeed)
  if ret == true then
    canChange = false
    newForward = hitInfo
  else
    newForward = objTransform.forward
  end
  canChange, newForward = CityPioneerFog:GetInstance():CheckWalkPos(pos, newForward, tmpSpeed, canChange)
  if newForward == nil then
  else
    ret, hitInfo = CS.CSUtils.Hit2(pos, newForward, CollectSize, tmpSpeed)
    if ret == true then
      newForward = nil
    end
  end
  if newForward ~= nil then
    local newPos = pos + newForward * tmpSpeed
    newPos.y = 0
    self.m_citySpaceMan:SetPosition(newPos)
  end
end

return CitySpaceManAniRun
