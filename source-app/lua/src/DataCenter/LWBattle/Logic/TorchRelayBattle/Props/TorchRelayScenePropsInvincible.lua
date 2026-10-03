local TorchRelaySceneBuffPropsBase = require("DataCenter.LWBattle.Logic.TorchRelayBattle.Props.TorchRelaySceneBuffPropsBase")
local base = TorchRelaySceneBuffPropsBase
local TorchConstant = require("DataCenter/LWBattle/Logic/TorchRelayBattle/TorchRelayBattleConstant")
local TorchRelayScenePropsInvincible = BaseClass("TorchRelayScenePropsInvincible", TorchRelaySceneBuffPropsBase)

function TorchRelayScenePropsInvincible:OnCollisionPlayer(playerCollider, cpt)
  base.OnCollisionPlayer(self, playerCollider, cpt)
  self:SetHide()
  local config = self.bornData.props.config
  local propsData = {}
  propsData.instanceId = self.id
  propsData.configId = config.id
  propsData.config = config
  propsData.duration = config.para1
  propsData.addSpeedPercent = config.para2 * 1.0E-4
  self.logic:OnInvincibleTrigger(propsData)
end

return TorchRelayScenePropsInvincible
