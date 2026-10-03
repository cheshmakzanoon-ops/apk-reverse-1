local UICD_VSCell = BaseClass("UICD_VSCell", UIBaseContainer)
local base = UIBaseContainer
local UIChampionDuelMainCity = require("UI.UIChampionDuel.Component.UIChampionDuelMainCity")
local UIChampionDuelWorldBg = require("UI.UIChampionDuel.Component.UIChampionDuelWorldBg")
local mainCity_path = "MainCity"
local wordBg_path = "WordBg"
local tips_path = "Tips"
local text_score_path = "Tips/ScoreText"
local text_rank_tip_path = "Tips/RankTip/RankTipText"
local img_rank_path = "Tips/RankTip/RankImg"
local text_rank_num_path = "Tips/RankTip/RankImg/RankText"
local btn_path = "Tips/Btn"
local text_btn_path = "Tips/Btn/TextBtn"

function UICD_VSCell:OnCreate()
  base.OnCreate(self)
  self.mainCity = self:AddComponent(UIChampionDuelMainCity, mainCity_path)
  self.mainCity:SetActive(false)
  self.wordBg = self:AddComponent(UIChampionDuelWorldBg, wordBg_path)
  self.tips = self:AddComponent(UIBaseContainer, tips_path)
  self.text_rank_tip = self:AddComponent(UIText, text_rank_tip_path)
  self.img_rank = self:AddComponent(UIImage, img_rank_path)
  self.text_rank_num = self:AddComponent(UIText, text_rank_num_path)
  self.text_score = self:AddComponent(UIText, text_score_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(BindCallback(self, self.OnBtnClick))
  self.text_btn = self:AddComponent(UIText, text_btn_path)
end

function UICD_VSCell:OnDestroy()
  self.mainCity = nil
  self.wordBg = nil
  self.tips = nil
  self.text_rank_tip = nil
  self.img_rank = nil
  self.text_rank_num = nil
  self.text_score = nil
  self.btn = nil
  self.text_btn = nil
  base.OnDestroy(self)
end

function UICD_VSCell:OnBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if LuaEntry.Player:GetUid() == self.uid then
    EventManager:GetInstance():Broadcast(EventId.ChampionDuelMainTabSel, 3)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelBattleLog, {anim = true}, self.uid, self.name)
  end
end

function UICD_VSCell:ReInit(info)
  self.info = info
  if info == nil then
    self.uid = nil
    self.mainCity:SetActive(false)
    self.wordBg:SetActive(false)
    self.tips:SetActive(false)
    return
  end
  self.uid = info.uid
  self.name = info.name
  self.mainCity:SetActive(true)
  self.mainCity:ReInitWithInfo(info, nil, true)
  self.mainCity:EnableClickInfo(self.uid ~= LuaEntry.Player:GetUid())
  self.wordBg:SetData(self.info)
  self.tips:SetActive(true)
  local rank = info.rank
  DataCenter.ChampionDuelManager:RefreshRankShow(self.text_rank_tip, "champion_duel_tips1062", self.img_rank, self.text_rank_num, rank)
  local stageId = DataCenter.ChampionDuelManager:GetCurStageId()
  if stageId == ChampionDuelState.KnockOut then
    local groupChar = DataCenter.ChampionDuelManager:GetGroupLetter(info.group5)
    self.text_score:SetLocalText("champion_duel_tips1022", groupChar)
  else
    self.text_score:SetLocalText("champion_duel_tips1061", string.GetFormattedStr(math.floor(info.score)))
  end
  local langKey = LuaEntry.Player:GetUid() == self.uid and "champion_duel_tips1064" or "champion_duel_tips1063"
  self.text_btn:SetLocalText(langKey)
end

return UICD_VSCell
