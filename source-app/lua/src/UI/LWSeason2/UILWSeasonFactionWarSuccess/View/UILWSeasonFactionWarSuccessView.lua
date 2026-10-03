local UILWSeasonFactionWarSuccessView = BaseClass("UILWSeasonFactionWarSuccessView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local SeasonFactionWarAliList = require("UI.LWSeason2.Activity.Component.SeasonFactionWar.SeasonFactionWarAliList")
local UILWSeasonFactionWarSuccessItem = require("UI.LWSeason2.UILWSeasonFactionWarSuccess.Component.UILWSeasonFactionWarSuccessItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local score1_path = "PopUpTitle/Content/VsRoot/icon1/score1"
local win_lost1_path = "PopUpTitle/Content/VsRoot/icon1/winLost1"
local score2_path = "PopUpTitle/Content/VsRoot/icon2/score2"
local win_lost2_path = "PopUpTitle/Content/VsRoot/icon2/winLost2"
local title_path = "PopUpTitle/Content/VsRoot/Title"
local faction_war_ali_list_path = "PopUpTitle/Content/FactionWarAliList"
local btn_close_path = "PopUpTitle/BtnClose"
local player_path = "PopUpTitle/Content/Rank1/Player"
local name_path = "PopUpTitle/Content/Rank1/Name"
local score_path = "PopUpTitle/Content/Rank1/Score"
local btn_like_path = "PopUpTitle/Content/Rank1/bg/btnLike"
local content_path = "PopUpTitle/Content"
local icon1_path = "PopUpTitle/Content/VsRoot/icon1"
local icon2_path = "PopUpTitle/Content/VsRoot/icon2"
local rank1_path = "PopUpTitle/Content/Rank1"
local rank_index_path = "PopUpTitle/Content/Rank1/RankIndex"
local num_add_red_path = "PopUpTitle/Content/Rank1/bg/num_add_red"
local bg_path = "PopUpTitle/Content/Rank1/bg"
local btn_close_text_path = "PopUpTitle/BtnClose/BtnCloseText"

function UILWSeasonFactionWarSuccessView:OnCreate()
  base.OnCreate(self)
  self.param = self:GetUserData()
  self:ComponentDefine()
  self:UpdateData()
end

function UILWSeasonFactionWarSuccessView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonFactionWarSuccessView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.icon1 = self:AddComponent(UIImage, icon1_path)
  self.icon2 = self:AddComponent(UIImage, icon2_path)
  self.score1 = self:AddComponent(UIImage, score1_path)
  self.win_lost1 = self:AddComponent(UIImage, win_lost1_path)
  self.score2 = self:AddComponent(UIImage, score2_path)
  self.win_lost2 = self:AddComponent(UIImage, win_lost2_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.faction_war_ali_list = self:AddComponent(SeasonFactionWarAliList, faction_war_ali_list_path)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.btn_close:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.playerUI = self:AddComponent(UICommonHead, player_path)
  self.name = self:AddComponent(UIText, name_path)
  self.score = self:AddComponent(UIText, score_path)
  self.btn_like = self:AddComponent(UIButton, btn_like_path)
  self.rankRoot = self:AddComponent(UIBaseContainer, rank1_path)
  self.rank_index = self:AddComponent(UITextMeshProUGUIEx, rank_index_path)
  self.playerUI:SetEnableClickShowInfo(true, true)
  self.btn_like:SetOnClick(function()
    self:OnThumbsUpClick()
  end)
  self.theRedItem = self.transform:Find(num_add_red_path).gameObject
  self.theRedItem:GameObjectCreatePool()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.btn_close_text = self:AddComponent(UITextMeshProUGUIEx, btn_close_text_path)
end

function UILWSeasonFactionWarSuccessView:ComponentDestroy()
  self.theRedItem:GameObjectRecycleAll()
  self.bg = nil
  self.btn_close_text = nil
  self.btn_back = nil
  self.score1 = nil
  self.icon1 = nil
  self.icon2 = nil
  self.win_lost1 = nil
  self.score2 = nil
  self.win_lost2 = nil
  self.title = nil
  self.faction_war_ali_list = nil
  self.btn_close = nil
  self.player = nil
  self.name = nil
  self.score = nil
  self.content = nil
  self.btn_like = nil
  self.rankRoot = nil
  self.rank_index = nil
end

function UILWSeasonFactionWarSuccessView:UpdateData()
  local mgr = DataCenter.SeasonFactionWarDataManager
  local warInfo = self.param
  if warInfo and (warInfo.result == 1 or warInfo.result == 2) then
    local warServerId = 0
    local warPointId = 0
    local warAllianceId = 0
    if warInfo.result == 1 then
      self.win_lost1:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/mjc_xituzhengdui_jiesuan_shengli.png")
      self.win_lost2:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/mjc_xituzhengdui_jiesuan_shibai.png")
    else
      self.win_lost1:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/mjc_xituzhengdui_jiesuan_shibai.png")
      self.win_lost2:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/mjc_xituzhengdui_jiesuan_shengli.png")
    end
    if mgr:CampIsAttacker(1) then
      self.icon1:LoadSprite(mgr:GetCampIcon(2))
      self.icon2:LoadSprite(mgr:GetCampIcon(1))
      if warInfo.result == 1 then
        self.dialog_title_text:SetLocalText("season_s2_win_popui002")
      else
        self.dialog_title_text:SetLocalText("season_s2_win_popui001")
      end
    else
      self.icon1:LoadSprite(mgr:GetCampIcon(1))
      self.icon2:LoadSprite(mgr:GetCampIcon(2))
      if warInfo.result == 1 then
        self.dialog_title_text:SetLocalText("season_s2_win_popui001")
      else
        self.dialog_title_text:SetLocalText("season_s2_win_popui002")
      end
    end
    self.faction_war_ali_list:SetAutoSizeEnable(true)
    self.faction_war_ali_list:CanShowInviteWhenEmpty(false)
    self.faction_war_ali_list:ReInit(warInfo.vsInfo.defence, warInfo.vsInfo.attack, warServerId, warAllianceId)
    self.faction_war_ali_list:UpdateResChangeInfo(warInfo.alResChangeInfo)
    local rankMVP = warInfo.rank1
    if rankMVP == nil or rankMVP.score == nil or rankMVP.score == 0 then
      self.rankRoot:SetActive(false)
      self.thePlayerUidMVP = nil
    else
      self.thePlayerUidMVP = rankMVP.uid
      self.rankRoot:SetActive(true)
      self.playerUI:ParseHeadInfo(rankMVP)
      self.name:SetText(UIUtil.FormatServerAllianceName(rankMVP.serverId, rankMVP.abbr, rankMVP.name))
      self.score:SetText("+" .. string.GetFormattedSeparatorNum(rankMVP.score or 0) .. "pt")
      if rankMVP.rank == -1 then
        self.rank_index:SetLocalText(361054)
      else
        self.rank_index:SetLocalText(800323, rankMVP.rank or "1")
      end
      if not string.IsNullOrEmpty(rankMVP.country) then
        self.playerUI:SetFlag(rankMVP.country)
      end
    end
    local msg = ""
    local vsInfo = warInfo.vsInfo
    local startTime = warInfo.startTime
    local endTime = warInfo.endTime
    local myCampId = DataCenter.SeasonFactionWarDataManager.myCampId
    local attackCampId = DataCenter.SeasonFactionWarDataManager.attackCampId
    local theDefenceAli = vsInfo.defence[1]
    if startTime then
      local curTime = endTime or UITimeManager:GetInstance():GetServerTime()
      if startTime < curTime then
        local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(curTime - startTime)
        msg = "<color=#C9FF4C>" .. Localization:GetString("season_s2_win_popui003", showTime) .. "</color>\n"
      end
    end
    if warInfo.result == 1 then
      if myCampId == attackCampId then
        msg = msg .. Localization:GetString("season_s2_win_popui007")
        self.btn_close_text:SetLocalText("season_s2_win_popui004")
      else
        local full_name = UIUtil.FormatServerAllianceName(theDefenceAli.serverId, theDefenceAli.abbr, theDefenceAli.name)
        msg = msg .. Localization:GetString("season_s2_win_popui006", full_name)
        self.btn_close_text:SetLocalText("season_s2_win_popui004")
      end
    else
      if myCampId == attackCampId then
        self.btn_close_text:SetLocalText("season_s2_win_popui004")
      else
        self.btn_close_text:SetLocalText("season_s2_win_popui004")
      end
      local full_name = UIUtil.FormatServerAllianceName(theDefenceAli.serverId, theDefenceAli.abbr, theDefenceAli.name)
      local alResChangeInfo = warInfo.alResChangeInfo
      local res_count = 0
      if alResChangeInfo then
        for k, v in pairs(alResChangeInfo) do
          if v and v < 0 then
            res_count = res_count - v
          end
        end
      end
      msg = msg .. Localization:GetString("season_s2_win_popui005", full_name, string.GetFormattedStr2(res_count))
    end
    self.title:SetText(msg)
    self.btn_close_text:SetLocalText("season_s2_win_popui004")
  else
    self.rankRoot:SetActive(false)
  end
end

function UILWSeasonFactionWarSuccessView:OnThumbsUpClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  InteractiveUtil.TryThumbsUp(self.thePlayerUidMVP, InteractiveUtil.ThumbsUpType.PlayerInfo, "FactionWarMVP", function()
    local goItem = self.theRedItem:GameObjectSpawn(self.bg.transform)
    if goItem then
      NameCount = NameCount + 1
      goItem.name = "ThumbsUp" .. NameCount
      local theItem = self.bg:AddComponent(UITextMeshProUGUIEx, goItem.name)
      if theItem then
        theItem:SetText("+1")
        theItem:SetActive(true)
        theItem:SetLocalPositionXYZ(0, 0, 0)
        theItem:SetAlpha(1)
        theItem.transform:DOLocalMoveY(100, 1.5)
        theItem.unity_tmpro:DOFade(0, 1.5)
        local sequence = DOTween.Sequence()
        sequence:AppendInterval(1.6)
        sequence:AppendCallback(function()
          if self.bg ~= nil and not IsNull(self.bg.gameObject) then
            self.bg:RemoveComponent(goItem.name, UITextMeshProUGUIEx)
            goItem:GameObjectRecycle()
          end
        end)
      else
        goItem:GameObjectRecycle()
      end
    end
  end)
end

return UILWSeasonFactionWarSuccessView
