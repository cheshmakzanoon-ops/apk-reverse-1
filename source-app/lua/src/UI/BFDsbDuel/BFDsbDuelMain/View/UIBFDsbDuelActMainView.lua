local base = require("UI.UIRaceEntrance.View.ActDownloadViewBase")
local UIBFDsbDuelActMainView = BaseClass("UIBFDsbDuelActMainView", base)
local PREFAB = "Assets/Main/Prefabs/UI/BF_Dsb_Duel/Act/UIBFDsbDuelActRoot.prefab"
local CLS = "UI.BFDsbDuel.BFDsbDuelMain.Component.UIBFDsbDuelActMainRoot"

function UIBFDsbDuelActMainView:OnCreate()
  base.OnCreate(self)
  self:SetRootCP(CLS, PREFAB)
  local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.ActDsbDuel.Type)
  if actData then
    self.text_title:SetLocalText(actData.name or "dsb_duel_activitiy_name_1001")
    self:SetData(actData.id)
  end
end

function UIBFDsbDuelActMainView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UIBFDsbDuelActMainView:LoadActFinish()
  local compAct = self.compAct
  if compAct then
    compAct:EnterToggle(self:GetUserData())
  end
end

return UIBFDsbDuelActMainView
