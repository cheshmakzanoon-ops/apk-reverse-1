local TorchRelayScenePropsBase = require("DataCenter.LWBattle.Logic.TorchRelayBattle.Props.TorchRelayScenePropsBase")
local base = TorchRelayScenePropsBase
local TorchRelayScenePropsTreasureBox = BaseClass("TorchRelayScenePropsTreasureBox", TorchRelayScenePropsBase)

function TorchRelayScenePropsTreasureBox:OnCollisionPlayer(playerCollider, cpt)
  base.OnCollisionPlayer(self, playerCollider, cpt)
  self:SetHide()
  self.logic:OnTreasureBoxTrigger(self.bornData.props.config)
end

return TorchRelayScenePropsTreasureBox
