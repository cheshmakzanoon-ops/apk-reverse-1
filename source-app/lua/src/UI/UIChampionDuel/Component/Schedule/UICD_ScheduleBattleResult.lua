local UICD_ScheduleBattleResult = BaseClass("UICD_ScheduleBattleResult", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIChampionDuelMainCity = require("UI.UIChampionDuel.Component.UIChampionDuelMainCity")
local UIChampionDuelTime = require("UI.UIChampionDuel.Component.UIChampionDuelTime")
local time_path = "Time"
local btn_log_path = "BtnLog"
local text_btn_log_path = "BtnLog/BtnLogIcon/BtnLogText"
local red_log_path = "BtnLog/BtnLogIcon/RedLog"
local mainCity_path = "Mid/MainCity"
local top_img_path = "Mid/ImgTop"
local text_upgrade_path = "Mid/ImgTop/UpgradeText"
local img_evolution_path = "Mid/ImgTop/Infos/ImgEvolution"
local text_rank_path = "Mid/ImgTop/Infos/Rank/RankText"
local img_rank_path = "Mid/ImgTop/Infos/Rank/RankImg"
local text_rank_num_path = "Mid/ImgTop/Infos/Rank/RankImg/RankNumText"
local text_score_path = "Mid/ImgTop/Infos/Score/ScoreText"
local text_score_num_path = "Mid/ImgTop/Infos/Score/ScoreNumText"
local text_keep_win_path = "Mid/ImgTop/Infos/KeepWin/KeepWinText"
local text_keep_win_num_path = "Mid/ImgTop/Infos/KeepWin/KeepWinNumText"
local text_win_path = "Mid/ImgTop/Infos/Win/WinText"
local text_win_num_path = "Mid/ImgTop/Infos/Win/WinNumText"
local text_tip_group_path = "TipGroupText"
local text_tip_path = "TipText"
local EVOLUTION_BASE = "Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_dongjifengbao_%s.png"
local EVOLUTIONS = {
  "sss",
  "s",
  "a",
  "b",
  "c"
}
local TOP_WIN = "Assets/Main/Sprites/UI/UIChampionDuel/Texture/lrb_guanjunduijue_haixuangongshi_jinjibg.png"
local TOP_LOSE = "Assets/Main/Sprites/UI/UIChampionDuel/Texture/lrb_guanjunduijue_haixuangongshi_taotaibg.png"
local COLOR_WIN = "005F10"
local COLOR_LOSE = "752B12"

function UICD_ScheduleBattleResult:OnCreate()
  base.OnCreate(self)
  self.time_group = self:AddComponent(UIChampionDuelTime, time_path)
  self.btn_log = self:AddComponent(UIButton, btn_log_path)
  self.btn_log:SetOnClick(BindCallback(self, self.OnBtnLogClick))
  self.text_btn_log = self:AddComponent(UIText, text_btn_log_path)
  self.text_btn_log:SetLocalText("champion_duel_tips1065")
  self.red_log = self:AddComponent(UIBaseComponent, red_log_path)
  self.mainCity = self:AddComponent(UIChampionDuelMainCity, mainCity_path)
  self.mainCity:SetActive(false)
  self.top_img = self:AddComponent(UIRawImage, top_img_path)
  self.top_img:SetActive(false)
  self.text_upgrade = self:AddComponent(UIText, text_upgrade_path)
  self.img_evolution = self:AddComponent(UIImage, img_evolution_path)
  self.img_evolution:SetActive(false)
  self.text_rank = self:AddComponent(UIText, text_rank_path)
  self.img_rank = self:AddComponent(UIImage, img_rank_path)
  self.text_rank_num = self:AddComponent(UIText, text_rank_num_path)
  self.text_score = self:AddComponent(UIText, text_score_path)
  self.text_score:SetLocalText("champion_duel_tips1061", "")
  self.text_score_num = self:AddComponent(UIText, text_score_num_path)
  self.text_keep_win = self:AddComponent(UIText, text_keep_win_path)
  self.text_keep_win:SetLocalText("champion_duel_tips1071")
  self.text_keep_win_num = self:AddComponent(UIText, text_keep_win_num_path)
  self.text_win = self:AddComponent(UIText, text_win_path)
  self.text_win:SetLocalText("champion_duel_tips1073")
  self.text_win_num = self:AddComponent(UIText, text_win_num_path)
  self.text_tip_group = self:AddComponent(UIText, text_tip_group_path)
  self.text_tip = self:AddComponent(UIText, text_tip_path)
end

function UICD_ScheduleBattleResult:OnDestroy()
  self.time_group = nil
  self.btn_log = nil
  self.text_btn_log = nil
  self.red_log = nil
  self.mainCity = nil
  self.top_img = nil
  self.text_upgrade = nil
  self.img_evolution = nil
  self.text_rank = nil
  self.img_rank = nil
  self.text_rank_num = nil
  self.text_score = nil
  self.text_score_num = nil
  self.text_keep_win = nil
  self.text_keep_win_num = nil
  self.text_win = nil
  self.text_win_num = nil
  self.text_tip_group = nil
  self.text_tip = nil
  base.OnDestroy(self)
end

function UICD_ScheduleBattleResult:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChampionDuelAuditionShowInfoRefresh, self.UpdateData)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.UpdateRed)
end

function UICD_ScheduleBattleResult:OnRemoveListener()
  self:RemoveUIListener(EventId.ChampionDuelAuditionShowInfoRefresh, self.UpdateData)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.UpdateRed)
  base.OnRemoveListener(self)
end

function UICD_ScheduleBattleResult:OnBtnLogClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelBattleLog)
  DataCenter.ChampionDuelManager:UpdateLogPopSign(false)
end

function UICD_ScheduleBattleResult:UpdateData(info)
  local upgrade = info ~= nil and info.upgrade or false
  self.top_img:LoadSpriteAsyncWithCallback(upgrade and TOP_WIN or TOP_LOSE, function()
    if self.top_img then
      self.top_img:SetNativeSize()
    end
  end)
  self.top_img:SetActive(true)
  local upgradeStr = Localization:GetString(upgrade and "champion_duel_tips1078" or "champion_duel_tips1079")
  local color = upgrade and COLOR_WIN or COLOR_LOSE
  self.text_upgrade:SetText(string.format("<color=#%s>%s</color>", color, upgradeStr))
  local evolution = info ~= nil and info.evolution or 0
  if 0 < evolution then
    local evoPath = string.format(EVOLUTION_BASE, EVOLUTIONS[evolution])
    self.img_evolution:LoadSpriteAsyncWithCallback(evoPath, function()
      if self.img_evolution then
        self.img_evolution:SetNativeSize()
      end
    end)
    self.img_evolution:SetActive(true)
  else
    self.img_evolution:SetActive(false)
  end
  local rank = info ~= nil and info.rank or 0
  DataCenter.ChampionDuelManager:RefreshRankShow(self.text_rank, "champion_duel_tips1062", self.img_rank, self.text_rank_num, rank)
  local score = info ~= nil and info.score or 0
  self.text_score_num:SetText(string.GetFormattedStr(math.floor(score)))
  self.text_keep_win_num:SetText(info ~= nil and info.keepWinCount or 0)
  local fightCount = info ~= nil and info.fightCount or 1
  if fightCount <= 0 then
    fightCount = 1
  end
  local winCount = info ~= nil and info.winCount or 0
  self.text_win_num:SetText(math.floor(winCount * 100 / fightCount) .. "%")
end

function UICD_ScheduleBattleResult:ReInit()
  DataCenter.ChampionDuelManager:ReqStageInfo()
  self.time_group:ReInit()
  self.mainCity:SetActive(true)
  self.mainCity:ReInit(nil, true)
  local actInfo = DataCenter.ChampionDuelManager:GetActInfo()
  local group = actInfo ~= nil and actInfo.group or 0
  local GetCurStageId = DataCenter.ChampionDuelManager:GetCurStageId()
  if GetCurStageId < ChampionDuelState.Rematch and 0 < group then
    local letter = DataCenter.ChampionDuelManager:GetGroupLetter(group)
    self.text_tip_group:SetLocalText("champion_duel_tips1087", letter)
    self.text_tip_group:SetActive(true)
  else
    self.text_tip_group:SetActive(false)
  end
  if GetCurStageId < ChampionDuelState.Rematch then
    self.text_tip:SetLocalText("champion_duel_tips1088")
  else
    self.text_tip:SetLocalText("champion_duel_tips1130")
  end
  self:UpdateRed()
end

function UICD_ScheduleBattleResult:UpdateRed()
  local cnt = DataCenter.ChampionDuelManager:CheckLogPopRed()
  self.red_log:SetActive(0 < cnt)
end

return UICD_ScheduleBattleResult
