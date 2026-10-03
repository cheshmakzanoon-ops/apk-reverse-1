local TorchRelaySceneBuffPropsBase = require("DataCenter.LWBattle.Logic.TorchRelayBattle.Props.TorchRelaySceneBuffPropsBase")
local base = TorchRelaySceneBuffPropsBase
local TorchConstant = require("DataCenter/LWBattle/Logic/TorchRelayBattle/TorchRelayBattleConstant")
local TorchRelayScenePropsSpeedAdd = BaseClass("TorchRelayScenePropsSpeedAdd", TorchRelaySceneBuffPropsBase)

function TorchRelayScenePropsSpeedAdd:OnCollisionPlayer(playerCollider, cpt)
  base.OnCollisionPlayer(self, playerCollider, cpt)
  self:SetHide()
  local config = self.bornData.props.config
  local propsData = {}
  propsData.instanceId = self.id
  propsData.configId = config.id
  propsData.config = config
  propsData.addSpeedPower = config.para1
  self.logic:OnSpeedAddTrigger(propsData)
end

return TorchRelayScenePropsSpeedAdd
