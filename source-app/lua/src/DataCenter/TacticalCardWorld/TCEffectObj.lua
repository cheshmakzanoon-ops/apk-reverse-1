local TCEffectObj = BaseClass("TCEffectObj")
local typeofPS = typeof(CS.UnityEngine.ParticleSystem)

function TCEffectObj:__delete()
  self:Destroy()
end

function TCEffectObj:Destroy()
  self.csParticle = nil
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  self.mgr = nil
  self.id = nil
  self.countDown = nil
end

function TCEffectObj:Init(mgr, req, id)
  self.mgr = mgr
  self.req = req
  self.id = id
end

function TCEffectObj:Show(pos, rot, time, parent)
  if parent then
    self.req.gameObject.transform:SetParent(parent)
    if pos then
      self.req.gameObject.transform.localPosition = pos
    else
      self.req.gameObject.transform:Set_localPosition(0, 0, 0)
    end
    if rot then
      self.req.gameObject.transform.localRotation = rot
    end
  else
    if pos then
      self.req.gameObject.transform.position = pos
    end
    if rot then
      self.req.gameObject.transform.rotation = rot
    end
  end
  self.req.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  self.req.gameObject:SetActive(true)
  self.countDown = time or 1
end

function TCEffectObj:OnUpdate()
  if self.countDown <= 0 then
    return
  end
  self.countDown = self.countDown - Time.deltaTime
  if self.countDown <= 0 then
    self.mgr:InnerRemove(self)
  end
end

function TCEffectObj:Replay(time)
  self.countDown = time or 1
  if not IsNull(self.csParticle) then
    self.csParticle:Play()
  elseif self.req and not IsNull(self.req.gameObject) then
    self.csParticle = self.req.gameObject:GetComponent(typeofPS)
    if not IsNull(self.csParticle) then
      self.csParticle:Play()
    end
  end
end

return TCEffectObj
