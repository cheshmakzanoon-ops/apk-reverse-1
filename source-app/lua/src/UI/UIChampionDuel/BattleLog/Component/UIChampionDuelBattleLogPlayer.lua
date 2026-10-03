local UIChampionDuelBattleLogPlayer = BaseClass("UIChampionDuelBattleLogPlayer", UIBaseContainer)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIDecorationHeadFrame = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationHeadFrame")
local headFrame_path = "Head"
local btn_path = "Head/Btn"
local img_result_path = "Result"
local text_server_path = "Di/ServerText"
local text_name_path = "NameText"
local text_rank_tip_path = "RankTip/RankTipText"
local img_rank_path = "RankTip/RankImg"
local text_rank_num_path = "RankTip/RankImg/RankText"
local text_score_path = "ScoreTip/ScoreText"
local text_score_add_path = "ScoreAddText"
local WIN_IMG_PATH = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_victory.png"
local LOSE_IMG_PATH = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_defeat.png"

function UIChampionDuelBattleLogPlayer:OnCreate()
  base.OnCreate(self)
  self.headFrame = self:AddComponent(UIDecorationHeadFrame, headFrame_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(BindCallback(self, self.OnClickInfoBtn))
  self.img_result = self:AddComponent(UIImage, img_result_path)
  self.text_server = self:AddComponent(UIText, text_server_path)
  self.text_name = self:AddComponent(UIText, text_name_path)
  self.text_rank_tip = self:AddComponent(UIText, text_rank_tip_path)
  self.img_rank = self:AddComponent(UIImage, img_rank_path)
  self.text_rank_num = self:AddComponent(UIText, text_rank_num_path)
  self.text_score = self:AddComponent(UIText, text_score_path)
  self.text_score_add = self:AddComponent(UIText, text_score_add_path)
end

function UIChampionDuelBattleLogPlayer:OnDestroy()
  self.headFrame = nil
  self.img_result = nil
  self.text_server = nil
  self.text_name = nil
  self.text_rank_tip = nil
  self.img_rank = nil
  self.text_rank_num = nil
  self.text_score = nil
  self.text_score_add = nil
  base.OnDestroy(self)
end

function UIChampionDuelBattleLogPlayer:OnClickInfoBtn()
  if self.info == nil then
    return
  end
  self.info:OnHeadClick()
end

function UIChampionDuelBattleLogPlayer:ReInit(teamInfo, isWin, stageId, targetUid)
  self.info = teamInfo
  teamInfo:SetFrameShow(self.headFrame)
  self.img_result:LoadSpriteAsyncWithCallback(isWin and WIN_IMG_PATH or LOSE_IMG_PATH, function()
    if self.img_result then
      self.img_result:SetNativeSize()
    end
  end)
  self.text_server:SetText("#" .. teamInfo.server)
  teamInfo:SetNameShow(self.text_name)
  if teamInfo.uid == LuaEntry.Player:GetUid() then
    self.text_name:SetColorRGBA255(95, 239, 135, 255)
  elseif teamInfo.uid == targetUid then
    self.text_name:SetColorRGBA255(255, 219, 107, 255)
  else
    self.text_name:SetColorRGBA255(255, 255, 255, 255)
  end
  local rank = teamInfo.rank
  DataCenter.ChampionDuelManager:RefreshRankShow(self.text_rank_tip, "champion_duel_tips1062", self.img_rank, self.text_rank_num, rank)
  if stageId == ChampionDuelState.KnockOut then
    local groupChar = DataCenter.ChampionDuelManager:GetGroupLetter(teamInfo.group5)
    self.text_score:SetLocalText("champion_duel_tips1022", groupChar)
  else
    local scoreNum = string.GetFormattedStr(math.floor(teamInfo.score))
    self.text_score:SetLocalText("champion_duel_tips1061", scoreNum)
  end
  if teamInfo.addScore == 0 then
    self.text_score_add:SetActive(false)
  else
    local sign = teamInfo.addScore > 0 and "+" or "-"
    self.text_score_add:SetText(sign .. string.GetFormattedStr(math.floor(teamInfo.addScore)))
    self.text_score_add:SetActive(true)
  end
end

return UIChampionDuelBattleLogPlayer
