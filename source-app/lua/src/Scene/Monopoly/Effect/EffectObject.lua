local EffectObject = BaseClass("EffectObject")

function EffectObject:__init(mgr, path, req, id)
  self.mgr = mgr
  self.path = path
  self.req = req
  self.id = id
end

function EffectObject:__delete()
  self:Destroy()
end

function EffectObject:Destroy()
  if not IsNull(self.req) then
    if not IsNull(self.req.gameObject) then
      self.req.gameObject.transform.localScale = Vector3.one
    end
    self.req:Destroy()
    self.req = nil
  end
  if self.destroyTimer then
    self.destroyTimer:Stop()
    self.destroyTimer = nil
  end
end

function EffectObject:Show(pos, scale, parent, time, callBack)
  if not IsNull(self.req) and not IsNull(self.req.gameObject) then
    if parent then
      self.req.gameObject.transform:SetParent(parent)
      if pos then
        self.req.gameObject.transform.localPosition = pos
      else
        self.req.gameObject.transform.localPosition = Vector3.zero
      end
    elseif pos then
      self.req.gameObject.transform.position = pos
    end
    if scale then
      self.req.gameObject.transform.localScale = scale
    else
      self.req.gameObject.transform:Set_localScale(1, 1, 1)
    end
    self.req.gameObject:SetActive(true)
    self.destroyTimer = TimerManager:GetInstance():DelayInvoke(function()
      if callBack then
        callBack()
      end
      self.mgr:InnerRemove(self)
    end, time and time or 1)
  end
end

return EffectObject
