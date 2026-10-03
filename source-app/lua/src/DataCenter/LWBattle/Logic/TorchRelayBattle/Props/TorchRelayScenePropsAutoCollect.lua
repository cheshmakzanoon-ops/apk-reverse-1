local TorchRelaySceneBuffPropsBase = require("DataCenter.LWBattle.Logic.TorchRelayBattle.Props.TorchRelaySceneBuffPropsBase")
local base = TorchRelaySceneBuffPropsBase
local TorchConstant = require("DataCenter/LWBattle/Logic/TorchRelayBattle/TorchRelayBattleConstant")
local TorchRelayScenePropsAutoCollect = BaseClass("TorchRelayScenePropsAutoCollect", TorchRelaySceneBuffPropsBase)

function TorchRelayScenePropsAutoCollect:OnCollisionPlayer(playerCollider, cpt)
  base.OnCollisionPlayer(self, playerCollider, cpt)
  self:SetHide()
  local config = self.bornData.props.config
  local propsData = {}
  propsData.instanceId = self.id
  propsData.configId = config.id
  propsData.config = config
  propsData.duration = config.para1
  propsData.bound = {
    minX = TorchConstant.PROPS_AUTO_COLLECT_BOUND_MIN_X,
    maxX = TorchConstant.PROPS_AUTO_COLLECT_BOUND_MAX_X,
    minZ = TorchConstant.PROPS_AUTO_COLLECT_BOUND_MIN_Z,
    maxY = TorchConstant.PROPS_AUTO_COLLECT_BOUND_MAX_Y,
    maxZ = config.para2
  }
  self.logic:OnAutoCollectTrigger(propsData)
end

return TorchRelayScenePropsAutoCollect
