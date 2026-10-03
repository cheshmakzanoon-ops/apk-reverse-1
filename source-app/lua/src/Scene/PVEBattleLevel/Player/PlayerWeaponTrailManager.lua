local PlayerWeaponTrailManager = BaseClass("PlayerWeaponTrailManager")
local PlayerWeaponTrail = require("Scene.PVEBattleLevel.Player.PlayerWeaponTrail")
local TrailName = {
  LeftToRightTrail = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/WeaponLeftToRightTrail.prefab",
  RightToLeftTrail = "Assets/PackageRes/Solider/ShiHuangXiaoRen/prefab/WeaponRightToLeftTrail.prefab"
}

function PlayerWeaponTrailManager:__init(player)
  self.particleList = {}
  self.player = player
  self:Create()
end

function PlayerWeaponTrailManager:__delete()
  self.particleList = {}
  self.player = nil
end

function PlayerWeaponTrailManager:Create()
  self.particleList = {}
  for k, v in pairs(TrailName) do
    local param = {}
    param.trailName = v
    self.particleList[v] = PlayerWeaponTrail.New(param)
  end
end

function PlayerWeaponTrailManager:Destroy()
  for k, v in pairs(self.particleList) do
    v:Destroy()
  end
end

function PlayerWeaponTrailManager:ComponentDefine()
end

function PlayerWeaponTrailManager:ComponentDestroy()
end

function PlayerWeaponTrailManager:PlayTrail(param)
  local trailName = self:GetTrainName(param.attackDirection)
  if self.particleList[trailName] ~= nil then
    self.particleList[trailName]:PlayTrail(param)
  end
end

function PlayerWeaponTrailManager:GetTrainName(attackDirection)
  if attackDirection == AttackAnimDirection.LeftToRight then
    return TrailName.LeftToRightTrail
  end
  return TrailName.RightToLeftTrail
end

return PlayerWeaponTrailManager
