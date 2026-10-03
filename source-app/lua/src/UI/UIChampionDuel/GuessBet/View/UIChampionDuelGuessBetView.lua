local UIChampionDuelGuessBetView = BaseClass("UIChampionDuelGuessBetView", UIBaseView)
local base = UIBaseView
local UIDecorationHeadFrame = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationHeadFrame")
local title_path = "Common_bg_orange/Common_img_title/titleText"
local closeBtn_path = "Common_bg_orange/CloseBtn"
local closeBg_path = "panel"
local text_top_path = "Common_bg_orange/Common_bg_orange2/content/Top/TopText"
local headFrame_path = "Common_bg_orange/Common_bg_orange2/content/Top/Info/Head"
local btn_path = "Common_bg_orange/Common_bg_orange2/content/Top/Info/Head/Btn"
local text_name_path = "Common_bg_orange/Common_bg_orange2/content/Top/Info/NameText"
local text_power_path = "Common_bg_orange/Common_bg_orange2/content/Top/Info/PowerText"
local text_score_path = "Common_bg_orange/Common_bg_orange2/content/Top/Info/ScoreText"
local text_odds_tip_path = "Common_bg_orange/Common_bg_orange2/content/Top/OddsBg/OddsText"
local toggle_base_path = "Common_bg_orange/Common_bg_orange2/content/Top/BetGroup/Toggle"
local text_win_tip_path = "Common_bg_orange/Common_bg_orange2/content/Top/Win/WinTipText"
local img_win_icon_path = "Common_bg_orange/Common_bg_orange2/content/Top/Win/Icon"
local text_win_num_path = "Common_bg_orange/Common_bg_orange2/content/Top/Win/WinNumText"
local text_mid_desc_text = "Common_bg_orange/Common_bg_orange2/content/Mid/ScrollView/Viewport/content/MidDescText"
local btn_bet_path = "Common_bg_orange/Common_bg_orange2/content/Bottom/BtnBet"
local text_btn_bet_path = "Common_bg_orange/Common_bg_orange2/content/Bottom/BtnBet/TextBtnBet"
local btn_cancel_path = "Common_bg_orange/Common_bg_orange2/content/Bottom/BtnCancel"
local text_btn_cancel_path = "Common_bg_orange/Common_bg_orange2/content/Bottom/BtnCancel/TextBtnCancel"
local text_cd_path = "Common_bg_orange/Common_bg_orange2/CDText"

function UIChampionDuelGuessBetView:OnCreate()
  base.OnCreate(self)
  local costStr = LuaEntry.DataConfig:TryGetStr("lw_champion_duel", "k7", "100,150,200")
  self.betCosts = string.string2array_i_oneSep(costStr, ",")
  self:ComponentDefine()
  self:RefreshView()
end

function UIChampionDuelGuessBetView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChampionDuelGuessBetView:ComponentDefine()
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText("champion_duel_tips1109")
  self.close_btn = self:AddComponent(UIButton, closeBtn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBg = self:AddComponent(UIButton, closeBg_path)
  self.closeBg:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.text_top = self:AddComponent(UIText, text_top_path)
  self.text_top:SetLocalText("champion_duel_tips1118")
  self.headFrame = self:AddComponent(UIDecorationHeadFrame, headFrame_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(BindCallback(self, self.OnClickInfoBtn))
  self.text_name = self:AddComponent(UIText, text_name_path)
  self.text_power = self:AddComponent(UIText, text_power_path)
  self.text_score = self:AddComponent(UIText, text_score_path)
  self.text_odds_tip = self:AddComponent(UIText, text_odds_tip_path)
  self.toggles = {}
  local iconPath = DataCenter.ChampionDuelManager:GetGuessItemIcon()
  local bcL = #self.betCosts
  for i = 1, 3 do
    local path = toggle_base_path .. i
    local toggle = self:AddComponent(UIToggle, path)
    if i <= bcL then
      toggle:SetOnValueChanged(function(tf)
        if tf then
          self:UpdateCurSel(i)
        end
      end)
      self.toggles[i] = toggle
      local textPath = path .. "/TextToggle" .. i
      local text = self:AddComponent(UIText, textPath)
      text:SetText("\195\151" .. self.betCosts[i])
      if iconPath then
        local imgPath = path .. "/Icon" .. i
        local img = self:AddComponent(UIImage, imgPath)
        img:LoadSpriteAsyncWithCallback(iconPath, function()
          if img then
            img:SetNativeSize()
          end
        end)
      end
    else
      toggle:SetActive(false)
    end
  end
  self.text_win_tip = self:AddComponent(UIText, text_win_tip_path)
  self.text_win_tip:SetLocalText("champion_duel_tips1119")
  self.img_win_icon = self:AddComponent(UIImage, img_win_icon_path)
  if iconPath then
    self.img_win_icon:LoadSpriteAuto(iconPath)
  end
  self.text_win_num = self:AddComponent(UIText, text_win_num_path)
  self.text_mid_desc = self:AddComponent(UIText, text_mid_desc_text)
  self.btn_bet = self:AddComponent(UIButton, btn_bet_path)
  self.btn_bet:SetOnClick(BindCallback(self, self.OnBetClick))
  self.text_btn_bet = self:AddComponent(UIText, text_btn_bet_path)
  self.text_btn_bet:SetLocalText("champion_duel_tips1109")
  self.btn_cancel = self:AddComponent(UIButton, btn_cancel_path)
  self.btn_cancel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.text_btn_cancel = self:AddComponent(UIText, text_btn_cancel_path)
  self.text_btn_cancel:SetLocalText("champion_duel_tips1108")
  self.text_cd = self:AddComponent(UIText, text_cd_path)
end

function UIChampionDuelGuessBetView:ComponentDestroy()
  self.title = nil
  self.close_btn = nil
  self.closeBg = nil
  self.text_top = nil
  self.headFrame = nil
  self.btn = nil
  self.text_name = nil
  self.text_power = nil
  self.text_score = nil
  self.text_odds_tip = nil
  self.toggles = {}
  self.text_win_tip = nil
  self.img_win_icon = nil
  self.text_win_num = nil
  self.text_mid_desc = nil
  self.btn_bet = nil
  self.text_btn_bet = nil
  self.btn_cancel = nil
  self.text_btn_cancel = nil
end

function UIChampionDuelGuessBetView:OnClickInfoBtn()
  if self.matchRival == nil then
    return
  end
  self.matchRival:OnHeadClick()
end

function UIChampionDuelGuessBetView:OnBetClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local curCost = self.betCosts[self.curSel] or 0
  local curHave = DataCenter.ChampionDuelManager:GetGuessItemHave()
  if curCost > curHave then
    UIUtil.ShowTipsId("champion_duel_tips1127")
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.lastBtnBetClickTime == nil or curTime - self.lastBtnBetClickTime > 1000 then
    DataCenter.ChampionDuelManager:ReqBetStart(self.betMatchId, self.uid, self.curSel)
    self.lastBtnBetClickTime = curTime
  end
end

function UIChampionDuelGuessBetView:RefreshView()
  local betInfo, bBlue = self:GetUserData()
  self.betMatchId = betInfo.betMatchId
  self.battleTime = betInfo.betMatchBattleTime
  local rival = bBlue and betInfo.betMatchRivalA or betInfo.betMatchRivalB
  self.info = rival
  if rival ~= nil then
    self.uid = rival.uid
    rival:SetFrameShow(self.headFrame)
    local nameStr = UIUtil.FormatServerAllianceName(rival.server, rival.abbr, rival.name)
    self.text_name:SetText(nameStr)
    self.text_power:SetLocalText("151115", string.GetFormattedStr(math.floor(rival:GetPower())))
    if DataCenter.ChampionDuelManager:GetCurStageId() == ChampionDuelState.KnockOut then
      self.text_score:SetActive(false)
    else
      self.text_score:SetLocalText("champion_duel_tips1061", string.GetFormattedStr(math.floor(rival.score)))
      self.text_score:SetActive(true)
    end
  end
  self.odds = betInfo.odds
  self.text_mid_desc:SetLocalText("champion_duel_tips1120", self.odds)
  self.text_odds_tip:SetLocalText("champion_duel_tips1106", self.odds)
  if self.toggles[1] then
    self.toggles[1]:SetIsOn(true)
  end
  self:UpdateCurSel(1)
  self:Update1000MS()
end

function UIChampionDuelGuessBetView:UpdateCurSel(idx)
  self.curSel = idx
  local curCost = self.betCosts[idx] or 0
  self.text_win_num:SetText(string.format("\195\151%d", self.odds * curCost))
end

function UIChampionDuelGuessBetView:Update1000MS()
  if self.battleTime == nil or self.battleTime == 0 then
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local remainTime = self.battleTime - curSec
  if 0 < remainTime then
    local timeStr = UITimeManager:GetInstance():SecondToFmtStringWithoutDay(remainTime)
    self.text_cd:SetLocalText("champion_duel_tips1104", timeStr)
  else
    self.ctrl:CloseSelf()
  end
end

return UIChampionDuelGuessBetView
