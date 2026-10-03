local SceneVfx = BaseClass("SceneVfx")
local ResourceManager = CS.GameEntry.Resource
local DEFAULT_TIME_DURATION = 1
local VFX_NAME_PRE = "vfxNode_"

function SceneVfx:__delete()
  self:ClearAll()
end

function SceneVfx:ClearRes()
  self.vfxObj = nil
  self.vfxCpts = nil
  if self.vfxReq then
    self.vfxReq:Destroy()
    self.vfxReq = nil
  end
  if self.playTimer then
    self.playTimer:Stop()
    self.playTimer = nil
  end
end

function SceneVfx:ClearAll()
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

function SceneVfx:PreLoad(path, customParam)
  if string.IsNullOrEmpty(path) then
    Logger.LogError(" path is null !!!!  ")
    return
  end
  self:OnInit(path, customParam)
  self:Load(path)
  self.initActive = false
end

function SceneVfx:Replay()
  if self.path == nil then
    Logger.LogError(" self.path is null !!!!  ")
    return
  end
  self:InnerPlay()
end

function SceneVfx:Play(path, customParam)
  if string.IsNullOrEmpty(path) then
    Logger.LogError(" path is null !!!!  ")
    return
  end
  self:OnInit(path, customParam)
  self:InnerPlay()
end

function SceneVfx:PlayByOnce(path, customParam)
  if string.IsNullOrEmpty(path) then
    Logger.LogError(" path is null !!!!  ")
    return
  end
  self:OnInit(path, customParam)
  self.param.lifeType = UIVfxLifeType.DestroyAfterOnce
  self:InnerPlay()
end

function SceneVfx:PlayByStay(path, customParam)
  if string.IsNullOrEmpty(path) then
    Logger.LogError(" path is null !!!!  ")
    return
  end
  self:OnInit(path, customParam)
  self.param.lifeType = UIVfxLifeType.Stay
  self:InnerPlay()
end

function SceneVfx:Stop()
  self:InnerResetStatus()
end

function SceneVfx:Remove()
  self:ClearAll()
end

function SceneVfx:OnInit(path, customParam)
  if self.path ~= nil and self.path ~= path then
    self:ClearAll()
  end
  if self.path ~= path or customParam ~= nil then
    self:InitParam(customParam)
  end
  self.path = path
end

function SceneVfx:InnerPlay()
  self.needPlay = true
  if self.vfxReq == nil then
    self:Load()
    self.initActive = true
    return
  end
  if self.isPlaying then
    return
  end
  if not IsNull(self.vfxObj) then
    self:RealPlay()
  end
end

function SceneVfx:InitParam(customParam)
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

function SceneVfx:Load()
  if not self.vfxReq then
    local vfxReq = ResourceManager:InstantiateAsync(self.path)
    vfxReq:completed("+", function()
      local vfxObj = vfxReq.gameObject
      if IsNull(vfxObj) then
        return
      end
      self.vfxObj = vfxObj
      local transform = vfxObj.transform
      transform:SetParent(self.param.parent)
      transform:Set_localPosition(self.param.pos.x, self.param.pos.y, self.param.pos.z)
      transform:Set_localEulerAngles(self.param.angles.x, self.param.angles.y, self.param.angles.z)
      transform:Set_localScale(self.param.scale.x, self.param.scale.y, self.param.scale.z)
      self.vfxCpts = self.vfxObj:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
      if IsNull(self.vfxCpts) then
        Logger.LogError(" ParticleSystem is Not Find!!!!   asset:" .. self.path)
        return
      end
      if self.param.onLoadComplete then
        self.param.onLoadComplete()
      end
      if self.initActive == nil then
        self.initActive = true
      end
      if self.initActive == false then
        self.vfxObj:SetActive(false)
        self.needPlay = false
      else
        self.vfxObj:SetActive(true)
        if self.needPlay then
          self:RealPlay()
        end
      end
      self.active = self.initActive
    end)
    self.vfxReq = vfxReq
  end
end

function SceneVfx:RealPlay()
  self.needPlay = false
  self:SetActive(true)
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

function SceneVfx:OnPlayEndHandler()
  self:InnerResetStatus()
  if self.param.lifeType == UIVfxLifeType.DestroyAfterOnce then
    if self.param.onRemove then
      self.param.onRemove()
    end
    self:ClearRes()
  end
end

function SceneVfx:InnerResetStatus()
  self.needPlay = false
  self:SetActive(false)
  self.isPlaying = false
  if self.param.onPlayEnd then
    self.param.onPlayEnd()
  end
end

function SceneVfx:SetActive(active)
  if IsNull(self.vfxObj) then
    self.initActive = active
    return
  end
  if self.active == active then
    return
  end
  self.vfxObj:SetActive(active)
  self.active = active
end

function SceneVfx:IsLoaded()
  return not IsNull(self.vfxObj)
end

return SceneVfx
