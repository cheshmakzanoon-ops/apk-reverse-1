local UIChampionDuelGroupListView = BaseClass("UIChampionDuelGroupListView", UIBaseView)
local base = UIBaseView
local UIChampionDuelGroup = require("UI.UIChampionDuel.Component.UIChampionDuelGroup")
local title_path = "Common_bg_orange/Common_img_title/titleText"
local closeBtn_path = "Common_bg_orange/CloseBtn"
local closeBg_path = "panel"
local group_path = "Common_bg_orange/Common_bg_orange2"

function UIChampionDuelGroupListView:OnCreate()
  base.OnCreate(self)
  local stageId = self:GetUserData()
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText("champion_duel_tips1128")
  if stageId == ChampionDuelState.PreStage then
    self.title:SetLocalText("champion_duel_tips1089")
    self.title:SetActive(true)
  elseif stageId == ChampionDuelState.Rematch then
    self.title:SetLocalText("champion_duel_tips1090")
    self.title:SetActive(true)
  else
    self.title:SetActive(false)
  end
  self.close_btn = self:AddComponent(UIButton, closeBtn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBg = self:AddComponent(UIButton, closeBg_path)
  self.closeBg:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.group = self:AddComponent(UIChampionDuelGroup, group_path)
  self.group:InitWithStageId(stageId)
end

return UIChampionDuelGroupListView
