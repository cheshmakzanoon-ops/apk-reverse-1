local base = require("UI.UIRaceEntrance.Component.ActDownloadContentAsyncBase")
local DesertBattleActivityMain = BaseClass("DesertBattleActivityMain", base)
local PREFAB = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/Main/DesertBattleMainRoot.prefab"
local CLS = "UI.UIActivityCenterTable.Component.DesertBattle.Component.DesertBattleActivityMainRoot"

function DesertBattleActivityMain:OnCreate()
  base.OnCreate(self)
  self:SetRootCP(CLS, PREFAB)
end

return DesertBattleActivityMain
