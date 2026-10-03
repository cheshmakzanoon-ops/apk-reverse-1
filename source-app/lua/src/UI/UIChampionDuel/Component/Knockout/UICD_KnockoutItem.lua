local UICD_KnockoutItem = BaseClass("UICD_KnockoutItem", UIBaseContainer)
local base = UIBaseContainer
local UIDecorationHeadFrame = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationHeadFrame")
local bg_path = "Bg"
local di_path = "Di"
local btn_search_path = "Di/SearchBtn"
local text_left_path = "Di/ScoreGroup/LeftText"
local text_right_path = "Di/ScoreGroup/RightText"
local group_path = "Group"
local img_rank_path = "Group/RankImg"
local text_rank_path = "Group/RankText"
local text_group1_path = "Group/GroupText1"
local text_group2_path = "Group/GroupText2"
local img_result_path = "Group/Result"
local player_path = "Player"
local head_frame_path = "Player/Head"
local btn_head_path = "Player/Head/Btn"
local text_name_path = "Player/NameText"
local text_name2_path = "Player/NameText2"
local empty_path = "Empty"
local text_wait_tip_path = "Empty/TipText"
local text_rank_sp_path = "RankSpText"
local BG_WIN_IMG_PATH = "Assets/Main/Sprites/UI/UIChampionDuel/Texture/lrb_guanjunduijue_xiaozusai_xinxiban01.png"
local BG_LOSE_IMG_PATH = "Assets/Main/Sprites/UI/UIChampionDuel/Texture/lrb_guanjunduijue_xiaozusai_xinxiban02.png"
local BG_FIRST_IMG_PATH = "Assets/Main/Sprites/UI/UIChampionDuel/Texture/lrb_guanjunduijue_xiaozusai_xinxiban_guanjun.png"
local BG_THIRD_IMG_PATH = "Assets/Main/Sprites/UI/UIChampionDuel/Texture/lrb_guanjunduijue_xiaozusai_xinxiban_jijun.png"
local WIN_IMG_PATH = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_victory.png"
local LOSE_IMG_PATH = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_defeat.png"
local BASE_BG_DI_IMG_PATH = "Assets/Main/Sprites/UI/UIChampionDuel/Sprites/lrb_guanjunduijue_xiaozisai_bifen_bg0%d.png"

function UICD_KnockoutItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.di = self:AddComponent(UIRawImage, di_path)
  self.btn_search = self:AddComponent(UIButton, btn_search_path)
  self.btn_search:SetOnClick(BindCallback(self, self.OnClickSearch))
  self.text_left = self:AddComponent(UIText, text_left_path)
  self.text_right = self:AddComponent(UIText, text_right_path)
  self.group = self:AddComponent(UIBaseContainer, group_path)
  self.img_rank = self:AddComponent(UIImage, img_rank_path)
  self.text_rank = self:AddComponent(UIText, text_rank_path)
  self.text_group1 = self:AddComponent(UIText, text_group1_path)
  self.text_group2 = self:AddComponent(UIText, text_group2_path)
  self.img_result = self:AddComponent(UIImage, img_result_path)
  self.player = self:AddComponent(UIBaseContainer, player_path)
  self.head_frame = self:AddComponent(UIDecorationHeadFrame, head_frame_path)
  self.btn_head = self:AddComponent(UIButton, btn_head_path)
  self.btn_head:SetOnClick(BindCallback(self, self.OnClickInfoBtn))
  self.text_name = self:AddComponent(UIText, text_name_path)
  self.text_name2 = self:AddComponent(UIText, text_name2_path)
  self.empty = self:AddComponent(UIBaseContainer, empty_path)
  self.text_wait_tip = self:AddComponent(UIText, text_wait_tip_path)
  self.text_wait_tip:SetLocalText("champion_duel_tips1145")
  self.text_rank_sp = self:AddComponent(UIText, text_rank_sp_path)
end

function UICD_KnockoutItem:OnDestroy()
  self.bg = nil
  self.di = nil
  self.btn_search = nil
  self.text_left = nil
  self.text_right = nil
  self.group = nil
  self.img_rank = nil
  self.text_rank = nil
  self.text_group1 = nil
  self.text_group2 = nil
  self.img_result = nil
  self.player = nil
  self.head_frame = nil
  self.btn_head = nil
  self.text_name = nil
  self.text_name2 = nil
  self.empty = nil
  self.text_wait_tip = nil
  self.text_rank_sp = nil
  base.OnDestroy(self)
end

function UICD_KnockoutItem:OnClickInfoBtn()
  if self.info == nil then
    return
  end
  self.info:OnHeadClick()
end

function UICD_KnockoutItem:OnClickSearch()
  if self.info == nil then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelBattleLog, {anim = true}, self.info.uid, self.info.name)
end

function UICD_KnockoutItem:ReInit(teamInfo, winner, spIndex)
  local emptyFlag = teamInfo == nil
  local spShow = spIndex ~= nil and 0 < spIndex
  local bgPath
  if spShow then
    bgPath = spIndex == 1 and BG_FIRST_IMG_PATH or BG_THIRD_IMG_PATH
  else
    bgPath = BG_WIN_IMG_PATH
  end
  self.di:SetActive(false)
  if emptyFlag then
    self.info = nil
    self.bg:LoadSpriteAsyncWithCallback(bgPath, function()
      if self.bg then
        self.bg:SetNativeSize()
      end
    end)
    self.group:SetActive(false)
    self.player:SetActive(false)
    self.empty:SetActive(true)
    self.text_rank_sp:SetActive(false)
    return
  end
  self.info = teamInfo
  local myGroup = teamInfo.group5
  self.group:SetActive(not spShow)
  self.player:SetActive(true)
  self.empty:SetActive(false)
  self.text_rank_sp:SetActive(spShow)
  if spShow then
    self.text_rank_sp:SetText(spIndex == 1 and 1 or 3)
  else
    local rank = teamInfo.rank
    local tmpRank = 3 < rank and 3 or rank
    self.img_rank:LoadSpriteAuto(string.format("Assets/Main/Sprites/UI/UIChampionDuel/Sprites/lrb_zhengduosai_paiming0%s.png", tmpRank))
    self.text_rank:SetText(rank)
    local bWinnerNull = string.IsNullOrEmpty(winner)
    local bWinner = bWinnerNull or teamInfo.uid == winner
    bgPath = bWinner and BG_WIN_IMG_PATH or BG_LOSE_IMG_PATH
    self.text_group1:SetActive(bWinner)
    self.text_group2:SetActive(not bWinner)
    local groupChar = DataCenter.ChampionDuelManager:GetGroupLetter(myGroup)
    local tmpText = bWinner and self.text_group1 or self.text_group2
    tmpText:SetLocalText("champion_duel_tips1022", groupChar)
    self.img_result:SetActive(not bWinnerNull)
    if not bWinnerNull then
      local path = bWinner and WIN_IMG_PATH or LOSE_IMG_PATH
      self.img_result:LoadSpriteAuto(path)
    end
  end
  self.bg:LoadSpriteAsyncWithCallback(bgPath, function()
    if self.bg then
      self.bg:SetNativeSize()
    end
  end)
  teamInfo:SetFrameShow(self.head_frame)
  local bSelf = teamInfo.uid == LuaEntry.Player:GetUid()
  if bSelf then
    teamInfo:SetNameShow2(self.text_name2)
  else
    teamInfo:SetNameShow2(self.text_name)
  end
  self.text_name:SetActive(not bSelf)
  self.text_name2:SetActive(bSelf)
end

function UICD_KnockoutItem:SetScore(point, targetPoint, spIndex)
  local hasPoint = 0 < point or 0 < targetPoint
  self.di:SetActive(spIndex ~= nil and hasPoint)
  if spIndex == nil and not hasPoint then
    return
  end
  local idx = 2
  if spIndex == 1 then
    idx = 1
  elseif spIndex == 0 then
    idx = 3
  end
  self.di:LoadSpriteAuto(string.format(BASE_BG_DI_IMG_PATH, idx))
  self.text_left:SetText(point)
  self.text_right:SetText(targetPoint)
end

return UICD_KnockoutItem
