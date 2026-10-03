local base = require("UI.UIRaceEntrance.Component.ActDownloadContentAsyncBase")
local WinterStormActivityMain = BaseClass("WinterStormActivityMain", base)
local PREFAB = "Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/WinterStormMainRoot.prefab"
local CLS = "UI.UIActivityCenterTable.Component.ActWinterStorm.WinterStormActivityMainRoot"

function WinterStormActivityMain:OnCreate()
  base.OnCreate(self)
  self:SetRootCP(CLS, PREFAB)
end

return WinterStormActivityMain
