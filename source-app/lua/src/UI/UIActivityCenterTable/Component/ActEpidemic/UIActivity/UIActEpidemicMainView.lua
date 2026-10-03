local base = require("UI.UIRaceEntrance.Component.ActDownloadContentAsyncBase")
local UIActEpidemicMainView = BaseClass("UIActEpidemicMainView", base)
local PREFAB = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicMainRoot.prefab"
local CLS = "UI.UIActivityCenterTable.Component.ActEpidemic.UIActivity.UIActEpidemicMainRoot"

function UIActEpidemicMainView:OnCreate()
  base.OnCreate(self)
  self:SetRootCP(CLS, PREFAB)
end

function UIActEpidemicMainView:LoadActFinish()
  local compAct = self.compAct
  if compAct ~= nil then
    compAct:SetOffsetMaxXY(0, 165)
  end
end

return UIActEpidemicMainView
