local base = require("Scene.CityPioneer.SpaceMan.CitySpaceManAnimation.CitySpaceManAniBase")
local CitySpaceManAniStopAttack = BaseClass("CitySpaceManAniStopAttack", base)

function CitySpaceManAniStopAttack:__init(spaceman)
  base.__init(self, spaceman)
end

function CitySpaceManAniStopAttack:OnEnter()
  base.OnEnter(self)
end

function CitySpaceManAniStopAttack:OnExit()
end

function CitySpaceManAniStopAttack:OnUpdate()
end

return CitySpaceManAniStopAttack
