local base = require("Scene.CityPioneer.SpaceMan.CitySpaceManAnimation.CitySpaceManAniBase")
local CitySpaceManAniReap = BaseClass("CitySpaceManAniReap", base)
local Rigidbody = typeof(CS.UnityEngine.Rigidbody)

function CitySpaceManAniReap:__init(spaceman)
  base.__init(self, spaceman)
  local obj = self.m_citySpaceMan:GetInstantiateObj()
  if obj ~= nil then
    self.m_rigidbody = obj:GetComponent(Rigidbody)
  end
end

function CitySpaceManAniReap:OnEnter()
  base.OnEnter(self)
  if self.m_rigidbody then
    self.m_rigidbody.velocity = Vector3.New(0, 0, 0)
  end
end

function CitySpaceManAniReap:OnExit()
end

function CitySpaceManAniReap:OnUpdate()
end

return CitySpaceManAniReap
