local UICD_ScheduleFinalShow = BaseClass("UICD_ScheduleFinalShow", UIBaseContainer)
local base = UIBaseContainer
local UIChampionDuelTime = require("UI.UIChampionDuel.Component.UIChampionDuelTime")
local UICD_FinalBg = require("UI.UIChampionDuel.FinalList.Component.UICD_FinalBg")
local MyTbNull = table.IsNullOrEmpty
local UICD_FinalTopThree_Cls = "UI.UIChampionDuel.FinalList.Component.UICD_FinalTopThree"
local UICD_FinalTopThree_Prefab = "Assets/Main/Prefabs/UI/UIChampionDuel/Final/UICD_FinalTopThree.prefab"
local bg_path = "Bg"
local time_path = "Time"
local btn_go_path = "GoBtn"
local text_go_path = "GoBtn/TextGoBtn"
local btn_more_path = "BtnMore"
local text_btn_more_path = "BtnMore/BtnMoreIcon/BtnMoreText"
local red_more_path = "BtnMore/BtnMoreIcon/RedMore"
local text_red_more_path = "BtnMore/BtnMoreIcon/RedMore/RedMoreText"

function UICD_ScheduleFinalShow:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UICD_FinalBg, bg_path)
  self.top_three = self:LoadComponentAsync(UICD_FinalTopThree_Cls, UICD_FinalTopThree_Prefab, self)
  self.top_three:SetSiblingIndex(2)
  self.top_three:SetName("TopThree")
  self.top_three:SetLocalPositionXYZ(0, -20, 0)
  self.time_group = self:AddComponent(UIChampionDuelTime, time_path)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.btn_go:SetOnClick(BindCallback(self, self.OnBtnClick))
  self.text_go = self:AddComponent(UIText, text_go_path)
  self.text_go:SetLocalText("champion_duel_tips1138")
  self.btn_more = self:AddComponent(UIButton, btn_more_path)
  self.btn_more:SetOnClick(BindCallback(self, self.OnClickBtnLog))
  self.text_btn_more = self:AddComponent(UIText, text_btn_more_path)
  self.text_btn_more:SetLocalText("champion_duel_tips1105")
  self.red_more = self:AddComponent(UIBaseComponent, red_more_path)
  self.text_red_more = self:AddComponent(UIText, text_red_more_path)
end

function UICD_ScheduleFinalShow:OnDestroy()
  self.bg = nil
  self.time_group = nil
  self.btn_go = nil
  self.text_go = nil
  self.btn_more = nil
  self.text_btn_more = nil
  self.red_more = nil
  self.text_red_more = nil
  base.OnDestroy(self)
end

function UICD_ScheduleFinalShow:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChampionDuelFinalRankListRefresh, self.RefreshUI)
end

function UICD_ScheduleFinalShow:OnRemoveListener()
  self:RemoveUIListener(EventId.ChampionDuelFinalRankListRefresh, self.RefreshUI)
  base.OnRemoveListener(self)
end

function UICD_ScheduleFinalShow:OnBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelFinalList, {anim = false})
end

function UICD_ScheduleFinalShow:OnClickBtnLog()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelGuessList, {anim = true}, BindCallback(self, self.UpdateRed))
end

function UICD_ScheduleFinalShow:UpdateRed()
  local cnt = DataCenter.ChampionDuelManager:CheckGuessRewardRed()
  self.red_more:SetActive(0 < cnt)
  if 0 < cnt then
    self.text_red_more:SetText(cnt)
  end
end

function UICD_ScheduleFinalShow:ReInit()
  local size = self:GetSizeDelta()
  self.bg:SetFixSize(size.x)
  self.time_group:ReInit()
  local list = DataCenter.ChampionDuelManager:GetFinalRankList()
  if MyTbNull(list) then
    self.top_three:SetActive(false)
    DataCenter.ChampionDuelManager:ReqBattleFinalRank()
  else
    self:RefreshUI()
  end
  self:UpdateRed()
end

function UICD_ScheduleFinalShow:RefreshUI()
  local list = DataCenter.ChampionDuelManager:GetFinalRankList()
  if MyTbNull(list) then
    return
  end
  self.top_three:SetActive(true)
  self.top_three:SetData("UICD_ScheduleFinalShow")
end

return UICD_ScheduleFinalShow
