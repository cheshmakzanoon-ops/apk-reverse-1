local UIBuildQueueFirstContract = {
  Name = UIWindowNames.UIBuildQueueFirstContract,
  Layer = UILayer.Guide,
  Ctrl = require("UI/UIBuildQueueFirstContract/Controller/UIBuildQueueFirstContractCtrl"),
  View = require("UI/UIBuildQueueFirstContract/View/UIBuildQueueFirstContractView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Build/LWUIBuildeQueueFirstContract.prefab"
}
return {UIBuildQueueFirstContract = UIBuildQueueFirstContract}
