local Resource = CS.GameEntry.Resource
local PlayerShow = BaseClass("PlayerShow")

function PlayerShow:__init()
  self.isLoaded = false
end

function PlayerShow:__delete()
  self.isLoaded = false
  if self.skinReq then
    self.skinReq:Destroy()
    self.skinReq = nil
  end
  self.loadResCallback = nil
  self.gameObject = nil
  self.transform = nil
  self.anim = nil
end

function PlayerShow:Init(skinParam)
  if skinParam.gameObject then
    self.gameObject = skinParam.gameObject
    self.transform = skinParam.gameObject.transform
    self.loadResCallback = skinParam.loadResCallback
    self:OnResLoaded()
  else
    if self.skinReq then
      self.skinReq:Destroy()
      self.skinReq = nil
    end
    self.skinReq = Resource:InstantiateAsync(skinParam.prefabPath)
    self.skinReq:completed("+", function(request)
      self.gameObject = request.gameObject
      self.transform = request.gameObject.transform
      if skinParam.parent then
        self.transform.parent = skinParam.parent
      end
      self.transform:Set_localScale(1, 1, 1)
      self.transform:Set_localRotation(0, 0, 0, 1)
      self.transform:Set_localPosition(0, 0, 0)
      if skinParam.pos then
        self:SetPosition(skinParam.pos)
      end
      self.loadResCallback = skinParam.loadResCallback
      self:OnResLoaded()
    end)
  end
end

function PlayerShow:OnResLoaded()
  self.isLoaded = true
  if self.gameObject then
    self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  end
  if self.loadResCallback then
    self.loadResCallback(self)
    self.loadResCallback = nil
  end
end

function PlayerShow:SetPosition(pos)
  if self.transform then
    self.transform:Set_position(pos)
  end
end

function PlayerShow:GetPosition()
  if self.transform then
    return Vector3(self.transform:Get_position())
  end
end

function PlayerShow:PlaySimpleAnim(name, speed)
  if self.anim then
    self.anim:Play(name)
    if speed then
      self.anim:SetStateSpeed(name, speed)
    end
  end
end

function PlayerShow:GetAnimLength(name)
  if self.anim then
    self.anim:SetStateSpeed(name, 1)
    return self.anim:GetClipLength(name)
  else
    return 0
  end
end

function PlayerShow:SampleAnimationAtTime(name, time)
  local anim = self.anim:GetState(name)
  if anim == nil then
    return false
  end
  return self.anim:SampleAnimationAtTime(name, time)
end

function PlayerShow:PlaySampleAnimationAtTime(name, normalizedTime, speed)
  if self.anim == nil then
    return
  end
  self:SampleAnimationAtTime(name, normalizedTime)
  self:PlaySimpleAnim(name, speed)
end

function PlayerShow:PlayQueued(name)
  if self.anim == nil then
    return
  end
  self.anim:PlayQueued(name)
end

function PlayerShow:StopAnim()
  if self.anim == nil then
    return
  end
  self.anim:Stop()
end

function PlayerShow:CrossFadeQueued(name, time, queueMode)
  if self.anim == nil then
    return
  end
  self.anim:CrossFadeQueued(name, time, queueMode)
end

return PlayerShow
