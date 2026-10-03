local UICD_ScheduleSigned = BaseClass("UICD_ScheduleSigned", UIBaseContainer)
local base = UIBaseContainer
local UIChampionDuelMainCity = require("UI.UIChampionDuel.Component.UIChampionDuelMainCity")
local UIChampionDuelTime = require("UI.UIChampionDuel.Component.UIChampionDuelTime")
local time_path = "Time"
local mainCity_path = "MainCity"
local wordBg_path = "WordBg"
local text_wordBg_path = "WordBg/DescText"
local img_go_path = "WordBg/BtnGo"
local text_btn_go_path = "WordBg/BtnGo/TextBtnGo"
local text_group_idx_path = "Tips/GroupIdxText"
local img_error_path = "Tips/RankTip/RankTipText/ErrorImg"
local text_rank_tip_path = "Tips/RankTip/RankTipText"
local img_rank_path = "Tips/RankTip/RankTipText/RankImg"
local text_rank_num_path = "Tips/RankTip/RankTipText/RankImg/RankText"
local btn_sign_path = "BtnSign"
local text_btn_sign_path = "BtnSign/TextBtnSign"

function UICD_ScheduleSigned:OnCreate()
  base.OnCreate(self)
  self.anim = self:AddComponent(UIAnimator, "")
  self.anim:Enable(false)
  self.time_group = self:AddComponent(UIChampionDuelTime, time_path)
  self.mainCity = self:AddComponent(UIChampionDuelMainCity, mainCity_path)
  self.mainCity:SetActive(false)
  self.wordBg = self:AddComponent(UIButton, wordBg_path)
  self.wordBg:SetOnClick(BindCallback(self, self.OnClickGoFormation))
  self.text_wordBg = self:AddComponent(UIText, text_wordBg_path)
  self.img_go = self:AddComponent(UIImage, img_go_path)
  self.text_btn_go = self:AddComponent(UIText, text_btn_go_path)
  self.text_btn_go:SetLocalText("110003")
  self.text_group_idx = self:AddComponent(UIText, text_group_idx_path)
  self.img_error = self:AddComponent(UIImage, img_error_path)
  self.text_rank_tip = self:AddComponent(UIText, text_rank_tip_path)
  self.img_rank = self:AddComponent(UIImage, img_rank_path)
  self.text_rank_num = self:AddComponent(UIText, text_rank_num_path)
  self.btn_sign = self:AddComponent(UIButton, btn_sign_path)
  self.text_btn_sign = self:AddComponent(UIText, text_btn_sign_path)
end

function UICD_ScheduleSigned:OnDestroy()
  self.anim = nil
  self.time_group = nil
  self.mainCity = nil
  self.wordBg = nil
  self.text_wordBg = nil
  self.img_go = nil
  self.text_btn_go = nil
  self.text_group_idx = nil
  self.img_error = nil
  self.text_rank_tip = nil
  self.img_rank = nil
  self.text_rank_num = nil
  self.btn_sign = nil
  self.text_btn_sign = nil
  base.OnDestroy(self)
end

function UICD_ScheduleSigned:OnClickGoFormation()
  EventManager:GetInstance():Broadcast(EventId.ChampionDuelMainTabSel, 3)
end

function UICD_ScheduleSigned:ReInit(bSign)
  self.time_group:ReInit()
  self.mainCity:ReInit()
  self.mainCity:SetActive(not bSign)
  local actInfo = DataCenter.ChampionDuelManager:GetActInfo()
  local sign = actInfo ~= nil and actInfo.sign or false
  local stageId = DataCenter.ChampionDuelManager:GetCurStageId()
  self.stageId = stageId
  if sign and stageId == ChampionDuelState.SignIn or stageId == ChampionDuelState.SignInAnnouncement then
    self.wordBg:SetActive(not bSign)
    local interactable = true
    local cnt = DataCenter.ChampionDuelManager:CheckFormationRed()
    if cnt == 0 then
      local battleWord = actInfo ~= nil and actInfo.battleWord or nil
      if string.IsNullOrEmpty(battleWord) then
        self.text_wordBg:SetLocalText("champion_duel_tips1032")
      else
        interactable = false
        self.text_wordBg:SetText(battleWord)
      end
    else
      self.text_wordBg:SetLocalText("champion_duel_tips1043")
    end
    local _, top = self.text_wordBg:GetOffsetMaxXY()
    self.text_wordBg:SetOffsetMaxXY(interactable and -100 or -15, top)
    self.img_go:SetActive(interactable)
    self.wordBg:SetInteractable(interactable)
  else
    self.wordBg:SetActive(false)
  end
  CS.UIGray.SetGray(self.btn_sign.transform, true, false)
  if stageId == ChampionDuelState.SignIn then
    self.text_btn_sign:SetLocalText(sign and "champion_duel_tips1007" or "champion_duel_tips1006")
  else
    self.text_btn_sign:SetLocalText(sign and "champion_duel_tips1050" or "champion_duel_tips1008")
  end
  local bSignInState = self.stageId == ChampionDuelState.SignIn
  self.text_group_idx:SetActive(not bSignInState and sign)
  self.img_error:SetActive(not bSignInState and not sign)
  if bSignInState or not sign then
    if self.stageId == ChampionDuelState.SignIn then
      self.text_rank_tip:SetLocalText("champion_duel_tips1027")
    else
      self.text_rank_tip:SetLocalText("champion_duel_tips1030")
    end
    self.img_rank:SetActive(false)
  else
    local groupIdx = actInfo ~= nil and actInfo.group or 0
    self.text_group_idx:SetLocalText("champion_duel_tips1029", groupIdx == 0 and "" or DataCenter.ChampionDuelManager:GetGroupLetter(groupIdx))
    local rank = actInfo ~= nil and actInfo.rank or 0
    DataCenter.ChampionDuelManager:RefreshRankShow(self.text_rank_tip, "champion_duel_tips1046", self.img_rank, self.text_rank_num, rank)
  end
  if not bSign then
    self.anim:Enable(true)
    self.anim:Play("Eff_ui_scheduleSignedLoop", 0, 0)
  end
end

function UICD_ScheduleSigned:PlaySignAnim()
  if self.timer then
    self.timer:Stop()
  end
  self.timer = nil
  self.anim:Enable(true)
  self.mainCity:SetActive(true)
  local ret, time = self.anim:PlayAnimationReturnTime("Eff_ui_scheduleSigned")
  if ret then
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      if self.timer then
        self.timer:Stop()
      end
      self.timer = nil
      if self.time_group then
        self:ReInit()
      end
    end, time)
  end
end

return UICD_ScheduleSigned
