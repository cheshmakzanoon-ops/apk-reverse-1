local UIWorldLLCanonPoint = {
  Name = UIWindowNames.UIWorldLLCanonPoint,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWWorld.UIWorldLLCanonPoint.Controller.UIWorldLLCanonPointCtrl"),
  View = require("UI.LWWorld.UIWorldLLCanonPoint.View.UIWorldLLCanonPointView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Landlord/World/LLWorldCanonPointView.prefab"
}
return {UIWorldLLCanonPoint = UIWorldLLCanonPoint}
