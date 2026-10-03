local UIVfx = BaseClass("UIVfx", UIBaseComponent)
local base = UIBaseComponent
local Localization = CS.GameEntry.Localization
local DEFAULT_TIME_DURATION = 1
local VFX_NAME_PRE = "vfxNode_"

function UIVfx:OnCreate(path, customParam)
  base.OnCreate(self)
  self:OnInit(path, customParam)
end

function UIVfx:OnDestroy()
  self:ClearAll()
  base.OnDestroy(self)
end

function UIVfx:OnEnable()
  base.OnEnable(self)
end

function UIVfx:OnDisable()
  base.OnDisable(self)
end

function UIVfx:ClearRes()
  self.vfxObj = nil
  self.vfxCpts = nil
  self.vfxSimpleAnim = nil
  if self.vfxReq then
    self.vfxReq:Destroy()
    self.vfxReq = nil
  end
  if self.playTimer then
    self.playTimer:Stop()
    self.playTimer = nil
  end
end

function UIVfx:ClearAll()
  self:ClearRes()
  self.isPlaying = false
  self.needPlay = false
  if self.param then
    for k, v in pairs(self.param) do
      self.param[k] = nil
    end
    self.param = nil
  end
  self.path = nil
end

function UIVfx:PreLoad(path, customParam)
  if string.IsNullOrEmpty(path) then
    Logger.LogError(" path is null !!!!  ")
    return
  end
  self:OnInit(path, customParam)
  self:Load(path)
end

function UIVfx:Replay()
  if self.path == nil then
    Logger.LogError(" self.path is null !!!!  ")
    return
  end
  self:InnerPlay()
end

function UIVfx:Play(path, customParam)
  if string.IsNullOrEmpty(path) then
    Logger.LogError(" path is null !!!!  ")
    return
  end
  self:OnInit(path, customParam)
  self:InnerPlay()
end

function UIVfx:PlayByOnce(path, customParam)
  if string.IsNullOrEmpty(path) then
    Logger.LogError(" path is null !!!!  ")
    return
  end
  self:OnInit(path, customParam)
  self.param.lifeType = UIVfxLifeType.DestroyAfterOnce
  self:InnerPlay()
end

function UIVfx:PlayByStay(path, customParam)
  if string.IsNullOrEmpty(path) then
    Logger.LogError(" path is null !!!!  ")
    return
  end
  self:OnInit(path, customParam)
  self.param.lifeType = UIVfxLifeType.Stay
  self:InnerPlay()
end

function UIVfx:Stop()
  self:InnerResetStatus()
end

function UIVfx:Remove()
  self:ClearAll()
end

function UIVfx:OnInit(path, customParam)
  if self.path ~= nil and self.path ~= path then
    self:ClearAll()
  end
  if self.path ~= path or customParam ~= nil then
    self:InitParam(customParam)
  end
  self.path = path
end

function UIVfx:InnerPlay()
  self.needPlay = true
  if self.vfxReq == nil then
    self:Load()
    return
  end
  if self.isPlaying and not self.param.isBreak then
    return
  end
  if self.vfxReq.isDone then
    self:RealPlay()
  end
end

function UIVfx:InitParam(customParam)
  self.param = customParam or {}
  if self.param.lifeType == nil then
    self.param.lifeType = UIVfxLifeType.HideAfterOnce
  end
  if self.param.duration == nil or self.param.duration <= 0 then
    self.param.duration = DEFAULT_TIME_DURATION
  end
  if self.param.pos == nil then
    self.param.pos = ResetPosition
  end
  if self.param.angles == nil then
    self.param.angles = Vector3.New(0, 0, 0)
  end
  if self.param.scale == nil then
    self.param.scale = ResetScale
  end
  if self.param.isBreak == nil then
    self.param.isBreak = true
  end
end

function UIVfx:Load()
  if not self.vfxReq then
    self.vfxReq = self:GameObjectInstantiateAsync(self.path, function()
      local buffEffectObj = self.vfxReq.gameObject
      if buffEffectObj == nil then
        return
      end
      buffEffectObj:SetActive(false)
      buffEffectObj.transform:SetParent(self.transform)
      buffEffectObj.transform:Set_localPosition(self.param.pos.x, self.param.pos.y, self.param.pos.z)
      buffEffectObj.transform:Set_localEulerAngles(self.param.angles.x, self.param.angles.y, self.param.angles.z)
      buffEffectObj.transform:Set_localScale(self.param.scale.x, self.param.scale.y, self.param.scale.z)
      self.vfxObj = buffEffectObj
      self.vfxCpts = self.vfxObj:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
      if IsNull(self.vfxCpts) then
        Logger.LogError(" ParticleSystem is Not Find!!!!   asset:" .. self.path)
        return
      end
      self.vfxSimpleAnim = self.vfxObj:GetComponent(typeof(CS.SimpleAnimation))
      if self.param.onLoadComplete then
        self.param.onLoadComplete()
      end
      if self.needPlay then
        self:InnerPlay()
        self.needPlay = false
      end
    end)
  end
end

function UIVfx:RealPlay()
  self.vfxObj:SetActive(true)
  for i = 0, self.vfxCpts.Length - 1 do
    self.vfxCpts[i]:Play()
  end
  self.isPlaying = true
  if self.param.lifeType == UIVfxLifeType.HideAfterOnce or self.param.lifeType == UIVfxLifeType.DestroyAfterOnce then
    if self.playTimer then
      self.playTimer:Stop()
    end
    self.playTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.param == nil then
        return
      end
      self:OnPlayEndHandler()
    end, self.param.duration)
  end
end

function UIVfx:OnPlayEndHandler()
  self:InnerResetStatus()
  if self.param.lifeType == UIVfxLifeType.DestroyAfterOnce then
    if self.param.onRemove then
      self.param.onRemove()
    end
    self:ClearRes()
  end
end

function UIVfx:InnerResetStatus()
  if self.vfxObj then
    self.vfxObj:SetActive(false)
  end
  self.isPlaying = false
  if self.param and self.param.onPlayEnd then
    self.param.onPlayEnd()
  end
end

function UIVfx:HasAnimState(stateName)
  if not IsNull(self.vfxSimpleAnim) then
    local state = self.vfxSimpleAnim:GetState(stateName)
    return not IsNull(state)
  end
  return false
end

function UIVfx:PlayAnimState(stateName)
  if not IsNull(self.vfxSimpleAnim) then
    local anim = self.vfxSimpleAnim:GetState(stateName)
    if IsNull(anim) then
      return
    end
    self.vfxSimpleAnim:Play(stateName)
  end
end

return UIVfx
