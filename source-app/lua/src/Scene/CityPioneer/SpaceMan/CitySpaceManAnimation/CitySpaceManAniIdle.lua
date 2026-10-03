local base = require("Scene.CityPioneer.SpaceMan.CitySpaceManAnimation.CitySpaceManAniBase")
local CitySpaceManAniIdle = BaseClass("CitySpaceManAniIdle", base)
local Rigidbody = typeof(CS.UnityEngine.Rigidbody)

function CitySpaceManAniIdle:__init(spaceman)
  base.__init(self, spaceman)
  local obj = self.m_citySpaceMan:GetInstantiateObj()
  if obj ~= nil then
    self.m_rigidbody = obj:GetComponent(Rigidbody)
  end
end

function CitySpaceManAniIdle:OnEnter()
  base.OnEnter(self)
  if self.m_rigidbody then
    self.m_rigidbody.velocity = Vector3.New(0, 0, 0)
  end
end

function CitySpaceManAniIdle:OnExit()
end

function CitySpaceManAniIdle:OnUpdate()
end

return CitySpaceManAniIdle
