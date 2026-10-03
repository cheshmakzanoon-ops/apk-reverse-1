local base = require("Scene.PVEBattleLevel.Player.PlayerAnimation.PlayerAniBase")
local PlayerAniStopAttack = BaseClass("PlayerAniStopAttack", base)

function PlayerAniStopAttack:__init(spaceman)
end

function PlayerAniStopAttack:OnEnter()
  base.OnEnter(self)
end

function PlayerAniStopAttack:OnExit()
end

function PlayerAniStopAttack:OnUpdate()
end

function PlayerAniStopAttack:RefreshBuff()
end

return PlayerAniStopAttack
