local MeteoriteHitPlaneEffect = BaseClass("MeteoriteHitPlaneEffect")
local meteorite_path = "MeteoriteGo"
local effect_path = "EffectGo"
local HitAnimName = {
  "MeteoriteHitPath1",
  "MeteoriteHitPath2",
  "MeteoriteHitPath3"
}

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
  self.anim = self.transform:Find(meteorite_path):GetComponent(typeof(CS.UnityEngine.Animator))
  self.effect = self.transform:Find(effect_path).gameObject
end

local function ComponentDestroy(self)
  self.effect = nil
  self.anim = nil
  self.transform = nil
  self.gameObject = nil
end

local function DataDefine(self)
  self.param = nil
  self.index = nil
end

local function DataDestroy(self)
  if self.showTimer ~= nil then
    self.showTimer:Stop()
    self.showTimer = nil
  end
  self.param = nil
  self.index = nil
end

local function ReInit(self, param)
  self.param = param
  local randomScale = math.random(7, 10) / 10
  self.transform:Set_localScale(randomScale, randomScale, randomScale)
  self.anim.gameObject:SetActive(true)
  self.effect.gameObject:SetActive(false)
  local random = math.random(1, #HitAnimName)
  local ret, time = UIUtil.PlayAnimationReturnTime(self.anim, HitAnimName[random])
  if ret then
    self.showTimer = TimerManager:GetInstance():GetTimer(time, function()
      if self.showTimer ~= nil then
        self.showTimer:Stop()
        self.showTimer = nil
      end
      self.anim.gameObject:SetActive(false)
      self.effect.gameObject:SetActive(true)
    end, self, true, false, false)
    self.showTimer:Start()
  end
end

MeteoriteHitPlaneEffect.OnCreate = OnCreate
MeteoriteHitPlaneEffect.OnDestroy = OnDestroy
MeteoriteHitPlaneEffect.ComponentDefine = ComponentDefine
MeteoriteHitPlaneEffect.ComponentDestroy = ComponentDestroy
MeteoriteHitPlaneEffect.DataDefine = DataDefine
MeteoriteHitPlaneEffect.DataDestroy = DataDestroy
MeteoriteHitPlaneEffect.ReInit = ReInit
return MeteoriteHitPlaneEffect
