local LWActivityArenaChallengeList = {
  Name = UIWindowNames.LWActivityArenaChallengeList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWActivityArenaChallengeList.LWActivityArenaChallengeListCtrl"),
  View = require("UI.LWActivityArenaChallengeList.LWActivityArenaChallengeListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPVPArena/LWUIArenaNewbieV2ChallengeList.prefab"
}
return {LWActivityArenaChallengeList = LWActivityArenaChallengeList}
