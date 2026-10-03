local UIChampionDuelGroupCell = BaseClass("UIChampionDuelGroupCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIDecorationHeadFrame = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationHeadFrame")
local img_bg1_path = "Bg1"
local img_bg2_path = "Bg2"
local img_rank_path = "RankImg"
local text_rank1_path = "RankImg/RankText1"
local text_rank2_path = "RankText2"
local img_up_path = "UpImg"
local headFrame_path = "Head"
local btn_path = "Head/Btn"
local text_name_path = "NameText"
local text_server_path = "ServerText"
local text_power_path = "PowerText"
local img_sign_path = "Sign"

function UIChampionDuelGroupCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIChampionDuelGroupCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChampionDuelGroupCell:ComponentDefine()
  self.img_bg1 = self:AddComponent(UIImage, img_bg1_path)
  self.img_bg2 = self:AddComponent(UIImage, img_bg2_path)
  self.img_rank = self:AddComponent(UIImage, img_rank_path)
  self.text_rank1 = self:AddComponent(UIText, text_rank1_path)
  self.text_rank2 = self:AddComponent(UIText, text_rank2_path)
  self.img_up = self:AddComponent(UIImage, img_up_path)
  self.headFrame = self:AddComponent(UIDecorationHeadFrame, headFrame_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(BindCallback(self, self.OnClickInfoBtn))
  self.text_name = self:AddComponent(UIText, text_name_path)
  self.text_server = self:AddComponent(UIText, text_server_path)
  self.text_power = self:AddComponent(UIText, text_power_path)
  self.img_sign = self:AddComponent(UIImage, img_sign_path)
end

function UIChampionDuelGroupCell:ComponentDestroy()
  self.img_bg1 = nil
  self.img_bg2 = nil
  self.img_rank = nil
  self.text_rank1 = nil
  self.text_rank2 = nil
  self.img_up = nil
  self.headFrame = nil
  self.btn = nil
  self.text_name = nil
  self.text_server = nil
  self.text_power = nil
  self.img_sign = nil
end

function UIChampionDuelGroupCell:OnClickInfoBtn()
  if self.uid ~= nil and self.uid ~= 0 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = false}, self.uid)
  end
end

function UIChampionDuelGroupCell:ReInit(groupItem, bSelf, signStageId)
  self.uid = groupItem.uid
  local rank = groupItem.rank
  local actInfo = DataCenter.ChampionDuelManager:GetActInfo()
  local stageId = signStageId == nil and DataCenter.ChampionDuelManager:GetCurStageId() or signStageId
  if stageId >= ChampionDuelState.RematchAnnouncement then
    self.img_up:SetActive(false)
    self.img_sign:SetActive(false)
  else
    local upNum = 0
    if stageId < ChampionDuelState.PreStageAnnouncement then
      upNum = actInfo ~= nil and actInfo.auditionUpperNums or 8
    elseif stageId < ChampionDuelState.RematchAnnouncement then
      upNum = actInfo ~= nil and actInfo.semiFinalUpperNums or 2
    end
    self.img_up:SetActive(rank <= upNum)
    self.img_sign:SetActive(groupItem.bSeed)
  end
  self:UpdateRankShow(rank)
  local nameColor = ""
  local BG_BASE_PATH = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_list_bg_%d.png"
  if not bSelf and 0 < rank and rank <= 3 then
    if rank == 1 then
      nameColor = "#915000"
    elseif rank == 2 then
      nameColor = "#4B5AA4"
    else
      nameColor = "#8C5A40"
    end
    self.img_bg1:SetActive(true)
    self.img_bg2:SetActive(false)
    self.img_bg1:LoadSpriteAuto(string.format(BG_BASE_PATH, rank))
  else
    nameColor = bSelf and "#466E31" or "#413C47"
    self.img_bg1:SetActive(false)
    self.img_bg2:SetActive(true)
    self.img_bg2:LoadSpriteAuto(string.format(BG_BASE_PATH, bSelf and 5 or 4))
  end
  groupItem:SetFrameShow(self.headFrame)
  local nameStr = string.format("<color=%s>%s</color>", nameColor, UIUtil.FormatAllianceAndName(groupItem.abbr, groupItem.name))
  self.text_name:SetText(nameStr)
  local serverStr = Localization:GetString("champion_duel_tips1051", groupItem.server)
  self.text_server:SetText(string.format("<color=%s>%s</color>", nameColor, serverStr))
  self.text_power:SetText(string.GetFormattedSeperatorNum(groupItem.score))
end

function UIChampionDuelGroupCell:UpdateRankShow(rank)
  if 0 < rank and rank <= 3 then
    self.text_rank1:SetText(rank)
    self.img_rank:LoadSpriteAsyncWithCallback(string.format("Assets/Main/Sprites/UI/UIChampionDuel/Sprites/lrb_zhengduosai_paiming0%d.png", rank), function()
      if self.img_rank then
        self.img_rank:SetNativeSize()
      end
    end)
    self.img_rank:SetActive(true)
    self.text_rank2:SetActive(false)
  else
    self.img_rank:SetActive(false)
    self.text_rank2:SetText(rank)
    self.text_rank2:SetActive(true)
  end
end

return UIChampionDuelGroupCell
