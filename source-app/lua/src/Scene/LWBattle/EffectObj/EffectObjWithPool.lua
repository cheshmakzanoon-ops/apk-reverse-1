local EffectObjWithPool = BaseClass("EffectObjWithPool")

function EffectObjWithPool:__delete()
  self:Destroy()
end

function EffectObjWithPool:Destroy()
  self.gameObject = nil
  self.mgr = nil
  self.id = nil
  self.countDown = nil
end

function EffectObjWithPool:Init(mgr, effectGo, id)
  self.mgr = mgr
  self.id = id
  self.gameObject = effectGo
end

function EffectObjWithPool:Show(pos, rot, time, parent)
  local transform = self.gameObject.transform
  if parent then
    transform:SetParent(parent)
    if pos then
      transform:Set_localPosition(pos.x, pos.y, pos.z)
    else
      transform:Set_localPosition(0, 0, 0)
    end
    if rot then
      transform:Set_localRotation(rot.x, rot.y, rot.z, rot.w)
    end
  else
    if pos then
      transform:Set_localPosition(pos.x, pos.y, pos.z)
    end
    if rot then
      transform:Set_localRotation(rot.x, rot.y, rot.z, rot.w)
    end
  end
  self.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  self.gameObject:SetActive(true)
  self.countDown = time or 1
end

function EffectObjWithPool:OnUpdate()
  if self.countDown <= 0 then
    return
  end
  self.countDown = self.countDown - Time.deltaTime
  if self.countDown <= 0 then
    self.mgr:InnerRemove(self)
  end
end

return EffectObjWithPool
