local base = require("UI.UIRaceEntrance.View.ActDownloadViewBase")
local UIChampionDuelMainView = BaseClass("UIChampionDuelMainView", base)
local PREFAB = "Assets/Main/Prefabs/UI/UIChampionDuel/UIChampionDuelMainRoot.prefab"
local CLS = "UI.UIChampionDuel.Component.UIChampionDuelMainRoot"

function UIChampionDuelMainView:OnCreate()
  base.OnCreate(self)
  self:SetRootCP(CLS, PREFAB)
  local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.ChampionDuelMain.Type)
  if actData then
    self.text_title:SetLocalText(actData.name or "champion_duel_tips1001")
    self:SetData(actData.id)
  end
end

function UIChampionDuelMainView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UIChampionDuelMainView:LoadActFinish()
end

return UIChampionDuelMainView
