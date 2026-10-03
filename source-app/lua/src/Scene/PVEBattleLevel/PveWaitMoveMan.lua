local PveWaitMoveMan = BaseClass("PveWaitMoveMan")
local Resource = CS.GameEntry.Resource
local Const = require("Scene.PVEBattleLevel.Const")
local carry_go_path = "CarryGo"
local anim_path = "A_soldie_ben/A_soldie@ben_skin"
local AutoMoveDelta = 6
local ExitDis = 0.2
local Speed = 0.08

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  self.carry_go = self.transform:Find(carry_go_path)
  self.m_animator = self.transform:GetComponentInChildren(typeof(CS.UnityEngine.Animator))
end

local function ComponentDestroy(self)
  self.m_animator = nil
  self.carry_go = nil
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.visible = true
  self.param = nil
  self.carryObj = {}
  self.m_tmpV = Vector3.New(0, 0, 0)
  self.finalPos = nil
  self.nowPos = nil
  self.vx = nil
  self.vz = nil
  self.forward = nil
  self.isBack = nil
end

local function DataDestroy(self)
  for k, v in pairs(self.carryObj) do
    if v.inst then
      v.inst:Destroy()
    end
  end
  self.param = nil
  self.visible = nil
  self.carryObj = nil
  self.m_tmpV = nil
  self.finalPos = nil
  self.nowPos = nil
  self.vx = nil
  self.vz = nil
  self.forward = nil
  self.isBack = nil
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

local function ReInit(self, param)
  self.param = param
  self.transform.position = self.param.originalPos
  self.isBack = false
  self:LoadCarrObject()
  self:RefreshVisible()
end

local function OnUpdate(self)
  if self.visible and self.vx ~= nil and self.vz ~= nil then
    self:SetVelocity(self.vx, self.vz)
  end
end

local function LoadCarrObject(self)
  for i = 1, self.param.num do
    self.carryObj[i] = {}
    self.carryObj[i].inst = Resource:InstantiateAsync(Const.GarbageRewardPath[Const.UnlockToResType[self.param.resType]])
    self.carryObj[i].inst:completed("+", function(req)
      local effect = req.gameObject
      effect.transform:SetParent(self.carry_go.transform)
      effect.transform.localScale = ResetScale
      effect.transform.localPosition = Vector3.New(0, i * 0.19, 0)
      effect.transform.localRotation = Quaternion.Euler(0, 0, 0)
      self.carryObj[i].model = effect
    end)
  end
end

local function RefreshVisible(self)
  if self.param.targetPos == nil then
    if self.visible then
      self.visible = false
      self.gameObject:SetActive(false)
    end
  elseif not self.visible then
    self.visible = true
    self.gameObject:SetActive(true)
  end
end

local function ChangeTargetPos(self, pos)
  self.param.targetPos = pos
  self:RefreshVisible()
  if self.visible then
    self.finalPos = pos
    self.nowPos = self.transform.position
    local velocity = Vector3.Normalize(self.finalPos - self.nowPos)
    self.vx = velocity.x * AutoMoveDelta
    self.vz = velocity.z * AutoMoveDelta
    self.isBack = false
    self:SetCarryObjVisible(true)
    self.m_animator:SetTrigger("run")
  end
end

local function SetVelocity(self, vx, vz)
  if self.m_tmpV.x ~= vx or self.m_tmpV.z ~= vz then
    self.m_tmpV:Set(vx, 0, vz)
    local _targetQuaternion = Quaternion.LookRotation(self.m_tmpV, Vector3.up)
    self.transform.rotation = _targetQuaternion
    self.forward = self.transform.forward * Speed
  end
  self.nowPos = self.nowPos + self.forward
  self.transform.position = self.nowPos
  self:CheckEnd()
end

local function CheckEnd(self)
  local dis = Vector3.Distance(self.nowPos, self.finalPos)
  if dis <= ExitDis then
    if self.isBack then
      self.param.parent:ChangeTargetPos(self.param.id)
    else
      self.isBack = true
      self.finalPos = self.param.originalPos
      local velocity = Vector3.Normalize(self.finalPos - self.nowPos)
      self.vx = velocity.x * AutoMoveDelta
      self.vz = velocity.z * AutoMoveDelta
      self:SetCarryObjVisible(false)
      self:SubmitRes()
    end
  end
end

local function SetCarryObjVisible(self, visible)
  for k, v in pairs(self.carryObj) do
    if v.model ~= nil then
      v.model:SetActive(visible)
    end
  end
end

local function SubmitRes(self)
  local triggerList = DataCenter.BattleLevel:GetTriggersByTilePos(SceneUtils.WorldToTile(self.param.targetPos))
  if triggerList ~= nil then
    for k, v in pairs(triggerList) do
      local triggerPoint = v
      if triggerPoint and not triggerPoint:IsTriggerOK() and triggerPoint:IsPreTriggerOK() and triggerPoint:IsTypeAdvancedBuild() then
        triggerPoint:GiveRes(self.param.resType, self.param.num)
        triggerPoint:RefreshText()
        if triggerPoint:GetCurrentBuildState() < triggerPoint:GetBuildStateCount() then
          if triggerPoint:GetCurrentBuildState() + 1 == triggerPoint:GetBuildStateCount() then
            if triggerPoint:IsCurrentStateFull() then
              triggerPoint:ChangeBuildState(triggerPoint:GetCurrentBuildState() + 1)
              local battleLevel = DataCenter.BattleLevel
              battleLevel:GetPlayer():PauseCameraFollow()
              battleLevel:AutoLookat(SceneUtils.TileToWorld(triggerPoint:GetTilePos() + Vector2.New(0, 3)), Const.LevelCameraHeight + 40, 1)
              self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
                self.delayTimer = nil
                battleLevel:GetPlayer():ResumeCameraFollow()
                DataCenter.BattleLevel:DoTrigger(triggerPoint)
              end, 5)
            end
          elseif triggerPoint:IsCurrentStateFull() then
            triggerPoint:ChangeBuildState(triggerPoint:GetCurrentBuildState() + 1)
          end
        end
      end
    end
  end
end

PveWaitMoveMan.OnCreate = OnCreate
PveWaitMoveMan.OnDestroy = OnDestroy
PveWaitMoveMan.ComponentDefine = ComponentDefine
PveWaitMoveMan.ComponentDestroy = ComponentDestroy
PveWaitMoveMan.DataDefine = DataDefine
PveWaitMoveMan.DataDestroy = DataDestroy
PveWaitMoveMan.ReInit = ReInit
PveWaitMoveMan.LoadCarrObject = LoadCarrObject
PveWaitMoveMan.RefreshVisible = RefreshVisible
PveWaitMoveMan.ChangeTargetPos = ChangeTargetPos
PveWaitMoveMan.OnUpdate = OnUpdate
PveWaitMoveMan.SetCarryObjVisible = SetCarryObjVisible
PveWaitMoveMan.SetVelocity = SetVelocity
PveWaitMoveMan.CheckEnd = CheckEnd
PveWaitMoveMan.SubmitRes = SubmitRes
return PveWaitMoveMan
