local UIChampionDuelGuessPlayerItem = BaseClass("UIChampionDuelGuessPlayerItem", UIBaseContainer)
local base = UIBaseContainer
local UIChampionDuelMainCity = require("UI.UIChampionDuel.Component.UIChampionDuelMainCity")
local UIChampionDuelWorldBg = require("UI.UIChampionDuel.Component.UIChampionDuelWorldBg")
local mainCity_path = "MainCity"
local wordBg_path = "WordBg"
local tips_path = "Tips"
local text_rank_tip_path = "Tips/RankTip/RankTipText"
local img_rank_path = "Tips/RankTip/RankImg"
local text_rank_num_path = "Tips/RankTip/RankImg/RankText"
local btn_path = "Tips/SearchBtn"

function UIChampionDuelGuessPlayerItem:OnCreate()
  base.OnCreate(self)
  self.mainCity = self:AddComponent(UIChampionDuelMainCity, mainCity_path)
  self.mainCity:SetActive(false)
  self.wordBg = self:AddComponent(UIChampionDuelWorldBg, wordBg_path)
  self.tips = self:AddComponent(UIBaseContainer, tips_path)
  self.text_rank_tip = self:AddComponent(UIText, text_rank_tip_path)
  self.img_rank = self:AddComponent(UIImage, img_rank_path)
  self.text_rank_num = self:AddComponent(UIText, text_rank_num_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(BindCallback(self, self.OnBtnClick))
end

function UIChampionDuelGuessPlayerItem:OnDestroy()
  self.mainCity = nil
  self.wordBg = nil
  self.tips = nil
  self.text_rank_tip = nil
  self.img_rank = nil
  self.text_rank_num = nil
  self.btn = nil
  self.text_btn = nil
  base.OnDestroy(self)
end

function UIChampionDuelGuessPlayerItem:OnBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.uid ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelBattleLog, {anim = true}, self.uid, self.name)
  end
end

function UIChampionDuelGuessPlayerItem:ReInit(info, side)
  self.info = info
  if info == nil then
    self.uid = nil
    self.mainCity:SetActive(false)
    self.wordBg:SetActive(false)
    self.tips:SetActive(false)
    self.btn:SetActive(false)
    return
  end
  self.uid = info.uid
  self.name = info.name
  self.mainCity:SetActive(true)
  self.mainCity:SetSide(side)
  self.mainCity:ReInitWithInfo(info, nil, true)
  self.mainCity:EnableClickInfo(info.uid ~= LuaEntry.Player:GetUid())
  self.wordBg:SetData(self.info)
  self.tips:SetActive(true)
  local rank = info.rank
  DataCenter.ChampionDuelManager:RefreshRankShow(self.text_rank_tip, "champion_duel_tips1062", self.img_rank, self.text_rank_num, rank)
  self.btn:SetActive(true)
end

return UIChampionDuelGuessPlayerItem
