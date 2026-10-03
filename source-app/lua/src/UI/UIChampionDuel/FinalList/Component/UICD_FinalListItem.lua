local UICD_FinalListItem = BaseClass("UICD_FinalListItem", UIAsyncContainer)
local base = UIAsyncContainer
local UIDecorationHeadFrame = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationHeadFrame")
local head_path = "Head"
local btn_path = "Head/Btn"
local text_name_path = "NameText"
local btn_praise_path = "PraiseBtn"
local rank_content_path = "rankContent"
local rank_txt_path = "rankContent/rankTxt"
local ranking_bg_path = "rankContent/RankingBg"
local ranking_text_path = "rankContent/RankingBg/RankingText"
local IMG_DI_PATH = "Assets/Main/Sprites/UI/UIChampionDuel/Sprites/lrb_guanjunduijue_quanminkuanghuan_paihang0%d.png"
local IMG_RANK_PATH = "Assets/Main/Sprites/UI/UIChampionDuel/Sprites/lrb_zhengduosai_paiming0%d.png"

function UICD_FinalListItem:OnCreate()
  base.OnCreate(self)
  self.head = self:AddComponent(UIDecorationHeadFrame, head_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(BindCallback(self, self.OnHeadBtnClick))
  self.text_name = self:AddComponent(UIText, text_name_path)
  self.btn_praise = self:AddComponent(UIButton, btn_praise_path)
  self.btn_praise:SetOnClick(BindCallback(self, self.OnPraiseBtnClick))
  self.rank_content = self:AddComponent(UIImage, rank_content_path)
  self.rank_txt = self:AddComponent(UIText, rank_txt_path)
  self.ranking_bg = self:AddComponent(UIImage, ranking_bg_path)
  self.ranking_text = self:AddComponent(UIText, ranking_text_path)
end

function UICD_FinalListItem:OnDestroy()
  self.info = nil
  self.head = nil
  self.btn = nil
  self.text_name = nil
  self.btn_praise = nil
  self.rank_content = nil
  self.rank_txt = nil
  self.ranking_bg = nil
  self.ranking_text = nil
  base.OnDestroy(self)
end

function UICD_FinalListItem:OnHeadBtnClick()
  if self.info == nil then
    return
  end
  self.info:OnHeadClick()
end

function UICD_FinalListItem:OnPraiseBtnClick()
  if self.info == nil then
    return
  end
  self.info:OnPraiseClick()
end

function UICD_FinalListItem:SetData(info)
  self.info = info
  self:RefreshView()
end

function UICD_FinalListItem:UpdateData()
  if self.info == nil then
    return
  end
  local info = self.info
  info:SetFrameShow(self.head)
  info:SetNameShow2(self.text_name)
  local rank5 = info.rank5 or 1
  rank5 = rank5 < 1 and 1 or rank5
  self.ranking_text:SetText(rank5)
  rank5 = 3 < rank5 and 3 or rank5
  self.rank_content:LoadSpriteAuto(string.format(IMG_DI_PATH, rank5))
  self.ranking_bg:LoadSpriteAuto(string.format(IMG_RANK_PATH, rank5))
  self.rank_txt:SetLocalText("champion_duel_tips1051", info.server)
end

return UICD_FinalListItem
