local UIChatSearchPerson = {
  Name = UIWindowNames.UIChatSearchPerson,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChatSearchPerson.Controller.UIChatSearchPersonCtrl"),
  View = require("UI.UIChatSearchPerson.View.UIChatSearchPersonView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/SearchPerson/UIChatSearchPerson.prefab"
}
return {UIChatSearchPerson = UIChatSearchPerson}
