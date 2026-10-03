local FogCanUnlockEffect = BaseClass("FogCanUnlockEffect")
local Data = CS.GameEntry.Data
local right_top_path = "RightTop"
local right_down_path = "RightDown"
local left_top_path = "LeftTop"
local left_down_path = "LeftDown"

local function OnCreate(self, go)
  if go ~= nil then
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
  self.effect = {}
  self.effect[CanUnlockFogSmallDirection.RightTop] = self.transform:Find(right_top_path):GetComponent(typeof(CS.SimpleAnimation))
  self.effect[CanUnlockFogSmallDirection.RightDown] = self.transform:Find(right_down_path):GetComponent(typeof(CS.SimpleAnimation))
  self.effect[CanUnlockFogSmallDirection.LeftTop] = self.transform:Find(left_top_path):GetComponent(typeof(CS.SimpleAnimation))
  self.effect[CanUnlockFogSmallDirection.LeftDown] = self.transform:Find(left_down_path):GetComponent(typeof(CS.SimpleAnimation))
end

local function ComponentDestroy(self)
  self.effect = nil
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.param = nil
  self.perState = {}
end

local function DataDestroy(self)
  self.param = nil
  self.perState = nil
  if self.inactiveTimer then
    self.inactiveTimer:Stop()
    self.inactiveTimer = nil
  end
end

local function ReInit(self, param)
  self.param = param
  local originalPos = self:GetOriginalPos()
  self.transform.position = originalPos
  self:InitEffect()
  self.gameObject:SetActive(false)
end

local function GetOriginalPos(self)
  return Data.Fog:GetFogPositionByFogId(self.param.fogId)
end

local function InitEffect(self)
  for k, v in pairs(self.effect) do
    if self.param.perSmallState ~= nil and self.param.perSmallState[k] ~= nil then
      if self.param.perSmallState[k] == CanUnlockFogSmallState.WeakColor then
        self:PlayAnim(k, FogCanUnlockEffectAnimName.CanUnlockIdle)
      elseif self.param.perSmallState[k] == CanUnlockFogSmallState.DeepColor then
        self:PlayAnim(k, FogCanUnlockEffectAnimName.LockIdle)
      end
    else
      self:PlayAnim(k, FogCanUnlockEffectAnimName.LockIdle)
    end
  end
end

local function PlayAnim(self, effectDirection, animName)
  if self.gameObject.activeInHierarchy and self.effect[effectDirection] ~= nil then
    self.perState[effectDirection] = animName
    self.effect[effectDirection]:Play(animName)
  end
end

local function CheckDoAnim(self, effectDirection, animName)
  if self.gameObject.activeInHierarchy and FogCanUnlockEffectAnimSort[self.perState[effectDirection]] > FogCanUnlockEffectAnimSort[animName] then
    self:PlayAnim(effectDirection, animName)
    if self.inactiveTimer then
      self.inactiveTimer:Stop()
    end
    self.inactiveTimer = TimerManager:GetInstance():GetTimer(3, function()
      self.gameObject:SetActive(false)
    end, nil, true, false, false)
    self.inactiveTimer:Start()
  end
end

FogCanUnlockEffect.OnCreate = OnCreate
FogCanUnlockEffect.OnDestroy = OnDestroy
FogCanUnlockEffect.ComponentDefine = ComponentDefine
FogCanUnlockEffect.ComponentDestroy = ComponentDestroy
FogCanUnlockEffect.DataDefine = DataDefine
FogCanUnlockEffect.DataDestroy = DataDestroy
FogCanUnlockEffect.ReInit = ReInit
FogCanUnlockEffect.GetOriginalPos = GetOriginalPos
FogCanUnlockEffect.InitEffect = InitEffect
FogCanUnlockEffect.PlayAnim = PlayAnim
FogCanUnlockEffect.CheckDoAnim = CheckDoAnim
return FogCanUnlockEffect
