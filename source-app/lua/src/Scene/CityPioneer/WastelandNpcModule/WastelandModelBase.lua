local WastelandModelBase = BaseClass("WastelandModelBase")

function WastelandModelBase:__init(pos)
  self.m_gameObject = nil
  self.m_objTransform = nil
end

function WastelandModelBase:GetPos()
  return Vector2.New(0, 0)
end

function WastelandModelBase:OnUpdate()
end

function WastelandModelBase:OnDestroy()
end

function WastelandModelBase:InstantiateObj()
end

function WastelandModelBase:GetGameObject()
  return self.m_gameObject
end

function WastelandModelBase:GetTransform()
  if self.m_gameObject ~= nil then
    if self.m_objTransform == nil then
      self.m_objTransform = self.m_gameObject.transform
    end
    return self.m_objTransform
  else
    return nil
  end
end

return WastelandModelBase
