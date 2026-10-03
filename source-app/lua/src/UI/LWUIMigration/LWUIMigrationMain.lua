local base = require("UI.UIRaceEntrance.Component.ActDownloadContentAsyncBase")
local LWUIMigrationMain = BaseClass("LWUIMigrationMain", base)
local PREFAB = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigrationRoot.prefab"
local CLS = "UI.LWUIMigration.Component.LWUIMigrationRoot"

function LWUIMigrationMain:OnCreate()
  base.OnCreate(self)
  self:SetRootCP(CLS, PREFAB)
end

return LWUIMigrationMain
