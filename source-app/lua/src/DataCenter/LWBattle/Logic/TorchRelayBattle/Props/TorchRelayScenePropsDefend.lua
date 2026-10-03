local TorchRelaySceneBuffPropsBase = require("DataCenter.LWBattle.Logic.TorchRelayBattle.Props.TorchRelaySceneBuffPropsBase")
local base = TorchRelaySceneBuffPropsBase
local TorchConstant = require("DataCenter/LWBattle/Logic/TorchRelayBattle/TorchRelayBattleConstant")
local TorchRelayScenePropsDefend = BaseClass("TorchRelayScenePropsDefend", TorchRelaySceneBuffPropsBase)

function TorchRelayScenePropsDefend:OnCollisionPlayer(playerCollider, cpt)
  base.OnCollisionPlayer(self, playerCollider, cpt)
  self:SetHide()
  local config = self.bornData.props.config
  local propsData = {}
  propsData.instanceId = self.id
  propsData.configId = config.id
  propsData.config = config
  propsData.duration = TorchConstant.PROPS_MAX_DURATION
  self.logic:OnDefendTrigger(propsData)
end

return TorchRelayScenePropsDefend
