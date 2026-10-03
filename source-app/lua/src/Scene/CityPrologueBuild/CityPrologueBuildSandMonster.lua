local CityPrologueBuildSandMonster = BaseClass("CityPrologueBuildSandMonster")
local this_path = ""
local effect_anim_path = "NormalModel/A_animal_shachong_gpuskin"
local gpu_anim_path = "NormalModel/A_animal_shachong_gpuskin/A_animal_shachong_new_prefab"
local AnimName = {
  HuXi = "shachong_huxi",
  Out = "shachong_zuanchu",
  In = "shachong_zuanjin",
  Hit = "hit",
  Death = "death"
}

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
  self.animTimer = nil
end

local function DeleteAniTimer(self)
  if self.animTimer ~= nil then
    self.animTimer:Stop()
    self.animTimer = nil
  end
end

local function OnDestroy(self)
  self:DeleteAniTimer()
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  self.anim = self.transform:Find(this_path):GetComponent(typeof(CS.SimpleAnimation))
  self.effect_anim = self.transform:Find(effect_anim_path):GetComponent(typeof(CS.SimpleAnimation))
  self.gpu_anim = self.transform:Find(gpu_anim_path):GetComponent(typeof(CS.GPUSkinningAnimator))
  
  function self.gpu_anim.PlayEndCallBack(aniName)
    self:onPlayEnd(aniName)
  end
end

local function ComponentDestroy(self)
  self.anim = nil
  self.effect_anim = nil
  self.gpu_anim = nil
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.param = nil
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self:ShowPanel()
end

local function ShowPanel(self)
  self:RefreshState()
  if self.param.state == CityPrologueBuildType.Normal then
    self:PlayAnim(AnimName.HuXi)
  end
end

local function DoDeath(self)
  self:PlayAnim(AnimName.Death)
end

local function PlayHit(self)
  self:PlayAnim(AnimName.Hit)
end

local function ChangeState(self, state)
  local oriState = state
  if state == "Destory" then
    self.wait_destory = true
    self:DoDeath()
    return
  end
  if self.param.state ~= state then
    self.param.state = state
    self:RefreshState()
    if self.param.state == CityPrologueBuildType.Normal then
      self:PlayAnim(AnimName.Out)
    end
  end
end

local function RefreshState(self)
  if self.anim ~= nil then
    local time = self.anim:GetClipLength(self.param.state)
    if time ~= nil and 0 < time then
      self.anim:Play(self.param.state)
    end
  end
end

local function PlayAnim(self, name)
  local time = self.gpu_anim:GetClipLength(name)
  if time ~= nil and 0 < time then
    self.gpu_anim:Play(name)
    return
  end
  local effectName = name .. "_effect"
  if self.effect_anim:GetState(effectName) ~= nil then
    self.effect_anim:Play(effectName)
    return
  end
end

local function onPlayEnd(self, aniName)
  print("aniName " .. aniName)
  if not self.gameObject then
    return
  end
  if aniName == AnimName.Death then
    self.gameObject:SetActive(false)
  else
    self:PlayAnim(AnimName.HuXi)
  end
end

function CityPrologueBuildSandMonster:PlayParticle(ani_name)
end

local function PlayAnimation(self)
end

CityPrologueBuildSandMonster.OnCreate = OnCreate
CityPrologueBuildSandMonster.OnDestroy = OnDestroy
CityPrologueBuildSandMonster.ComponentDefine = ComponentDefine
CityPrologueBuildSandMonster.ComponentDestroy = ComponentDestroy
CityPrologueBuildSandMonster.DataDefine = DataDefine
CityPrologueBuildSandMonster.DataDestroy = DataDestroy
CityPrologueBuildSandMonster.ReInit = ReInit
CityPrologueBuildSandMonster.ShowPanel = ShowPanel
CityPrologueBuildSandMonster.ChangeState = ChangeState
CityPrologueBuildSandMonster.RefreshState = RefreshState
CityPrologueBuildSandMonster.AnimCallBack = AnimCallBack
CityPrologueBuildSandMonster.PlayAnim = PlayAnim
CityPrologueBuildSandMonster.PlayHit = PlayHit
CityPrologueBuildSandMonster.DoDeath = DoDeath
CityPrologueBuildSandMonster.onPlayEnd = onPlayEnd
CityPrologueBuildSandMonster.DeleteAniTimer = DeleteAniTimer
CityPrologueBuildSandMonster.PlayAnimation = PlayAnimation
return CityPrologueBuildSandMonster
