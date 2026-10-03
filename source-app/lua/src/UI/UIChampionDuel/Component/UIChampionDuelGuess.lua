local UIChampionDuelGuess = BaseClass("UIChampionDuelGuess", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIChampionDuelStateInfo = require("UI.UIChampionDuel.Component.UIChampionDuelStateInfo")
local UIChampionDuelTime = require("UI.UIChampionDuel.Component.UIChampionDuelTime")
local UIChampionDuelGuessPlayerItem = require("UI.UIChampionDuel.Component.UIChampionDuelGuessPlayerItem")
local state_info_path = "State"
local time_path = "Time"
local text_cd_path = "Time/CountDownText"
local score_group_path = "Time/ScoreGroup"
local left_score_left_path = "Time/ScoreGroup/ScoreLeft/LeftText"
local right_score_left_path = "Time/ScoreGroup/ScoreRight/RightText"
local btn_more_path = "BtnMore"
local text_btn_more_path = "BtnMore/BtnMoreIcon/BtnMoreText"
local red_more_path = "BtnMore/BtnMoreIcon/RedMore"
local text_red_more_path = "BtnMore/BtnMoreIcon/RedMore/RedMoreText"
local mid_blue_path = "Mid/BgLeft"
local mid_red_path = "Mid/BgRight"
local vs_path = "Mid/ImgVs"
local eff_path = "Mid/EffFight"
local bottom_path = "Bottom"
local text_empty_path = "EmptyText"
local text_title_path = "Bottom/Title/TitleText"
local btn_title_path = "Bottom/Title/BtnTitle"
local text_bet_blue_path = "Bottom/Progress/BetBlueText"
local text_bet_red_path = "Bottom/Progress/BetRedText"
local slider_blue_path = "Bottom/Progress/mask/BlueSlider"
local slider_red_path = "Bottom/Progress/mask/RedSlider"
local text_rat_blue_path = "Bottom/Progress/mask/BlueRatTxt"
local text_rat_red_path = "Bottom/Progress/mask/RedRatTxt"
local btn_bet_blue_path = "Bottom/BtnBetBlue"
local img_bet_blue_path = "Bottom/BtnBetBlue/IconBlue"
local text_btn_bet_blue_path = "Bottom/BtnBetBlue/TextBtnBetBlue"
local bet_tip_blue_path = "Bottom/BtnBetBlue/TipBlue"
local img_bet_tip_blue_path = "Bottom/BtnBetBlue/TipBlue/BetGetIconBlue"
local text_bet_tip_blue_path = "Bottom/BtnBetBlue/TipBlue/BetCostTextBlue"
local btn_bet_red_path = "Bottom/BtnBetRed"
local img_bet_red_path = "Bottom/BtnBetRed/IconRed"
local text_btn_bet_red_path = "Bottom/BtnBetRed/TextBtnBetRed"
local bet_tip_red_path = "Bottom/BtnBetRed/TipRed"
local img_bet_tip_red_path = "Bottom/BtnBetRed/TipRed/BetGetIconRed"
local text_bet_tip_red_path = "Bottom/BtnBetRed/TipRed/BetCostTextRed"
local btn_refresh_path = "Di/RefreshBtn"
local text_have_tip_path = "Di/HaveGroup/HaveTipText"
local img_have_icon_path = "Di/HaveGroup/HaveIcon"
local text_have_num_path = "Di/HaveGroup/HaveNumText"
local text_remain_path = "Di/RemainText"
local BTN_GREEN_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_2.png"
local BTN_BLUE_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png"

function UIChampionDuelGuess:OnCreate()
  base.OnCreate(self)
  local times = string.split(LuaEntry.DataConfig:TryGetStr("lw_champion_duel", "k6", "10,5"), ",")
  local idx = DataCenter.ChampionDuelManager:GetCurStageId() <= ChampionDuelState.RematchAnnouncement and 1 or 2
  self.maxGuessTime = tonumber(times[idx]) or 0
  self:ComponentDefine()
end

function UIChampionDuelGuess:OnDestroy()
  if self.timer ~= nil then
    self.timer:Stop()
  end
  self.timer = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChampionDuelGuess:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChampionDuelBetInfoRefresh, self.OnInfoRefresh)
  self:AddUIListener(EventId.ChampionDuelBetListRefresh, self.UpdateRed)
end

function UIChampionDuelGuess:OnRemoveListener()
  self:RemoveUIListener(EventId.ChampionDuelBetInfoRefresh, self.OnInfoRefresh)
  self:RemoveUIListener(EventId.ChampionDuelBetListRefresh, self.UpdateRed)
  base.OnRemoveListener(self)
end

function UIChampionDuelGuess:ComponentDefine()
  local iconPath = DataCenter.ChampionDuelManager:GetGuessItemIcon()
  self.anim = self:AddComponent(UIAnimator, "")
  self.anim:Enable(false)
  self.stateInfo = self:AddComponent(UIChampionDuelStateInfo, state_info_path)
  self.time_group = self:AddComponent(UIChampionDuelTime, time_path)
  self.text_cd = self:AddComponent(UIText, text_cd_path)
  self.score_group = self:AddComponent(UIBaseContainer, score_group_path)
  self.text_score_left = self:AddComponent(UIText, left_score_left_path)
  self.text_score_right = self:AddComponent(UIText, right_score_left_path)
  self.btn_more = self:AddComponent(UIButton, btn_more_path)
  self.btn_more:SetOnClick(BindCallback(self, self.OnClickBtnLog))
  self.text_btn_more = self:AddComponent(UIText, text_btn_more_path)
  self.text_btn_more:SetLocalText("champion_duel_tips1105")
  self.red_more = self:AddComponent(UIBaseComponent, red_more_path)
  self.text_red_more = self:AddComponent(UIText, text_red_more_path)
  self.mid_blue = self:AddComponent(UIChampionDuelGuessPlayerItem, mid_blue_path)
  self.mid_red = self:AddComponent(UIChampionDuelGuessPlayerItem, mid_red_path)
  self.vs = self:AddComponent(UIBaseContainer, vs_path)
  self.eff = self:AddComponent(UIBaseContainer, eff_path)
  self.bottom = self:AddComponent(UIBaseContainer, bottom_path)
  self.text_empty = self:AddComponent(UIText, text_empty_path)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.btn_title = self:AddComponent(UIButton, btn_title_path)
  self.btn_title:SetOnClick(BindCallback(self, self.OnClickBtnTitle))
  self.text_bet_blue = self:AddComponent(UIText, text_bet_blue_path)
  self.text_bet_red = self:AddComponent(UIText, text_bet_red_path)
  self.slider_blue = self:AddComponent(UISlider, slider_blue_path)
  self.slider_red = self:AddComponent(UISlider, slider_red_path)
  self.text_rat_blue = self:AddComponent(UIText, text_rat_blue_path)
  self.text_rat_red = self:AddComponent(UIText, text_rat_red_path)
  self.btn_bet_blue = self:AddComponent(UIButton, btn_bet_blue_path)
  self.btn_bet_blue:SetOnClick(BindCallback(self, self.OnClickBtnBetBlue))
  self.img_btn_bet_blue = self:AddComponent(UIImage, img_bet_blue_path)
  self.text_btn_bet_blue = self:AddComponent(UIText, text_btn_bet_blue_path)
  self.bet_tip_blue = self:AddComponent(UIBaseContainer, bet_tip_blue_path)
  self.img_bet_tip_blue = self:AddComponent(UIImage, img_bet_tip_blue_path)
  if iconPath then
    self.img_bet_tip_blue:LoadSpriteAsyncWithCallback(iconPath, function()
      if self.img_bet_tip_blue then
        self.img_bet_tip_blue:SetNativeSize()
      end
    end)
  end
  self.text_bet_tip_blue = self:AddComponent(UIText, text_bet_tip_blue_path)
  self.btn_bet_red = self:AddComponent(UIButton, btn_bet_red_path)
  self.btn_bet_red:SetOnClick(BindCallback(self, self.OnClickBtnBetRed))
  self.img_btn_bet_red = self:AddComponent(UIImage, img_bet_red_path)
  self.text_btn_bet_red = self:AddComponent(UIText, text_btn_bet_red_path)
  self.bet_tip_red = self:AddComponent(UIBaseContainer, bet_tip_red_path)
  self.img_bet_tip_red = self:AddComponent(UIImage, img_bet_tip_red_path)
  if iconPath then
    self.img_bet_tip_red:LoadSpriteAsyncWithCallback(iconPath, function()
      if self.img_bet_tip_red then
        self.img_bet_tip_red:SetNativeSize()
      end
    end)
  end
  self.text_bet_tip_red = self:AddComponent(UIText, text_bet_tip_red_path)
  self.btn_refresh = self:AddComponent(UIButton, btn_refresh_path)
  self.btn_refresh:SetOnClick(BindCallback(self, self.OnClickBtnRefresh))
  self.text_have_tip = self:AddComponent(UIText, text_have_tip_path)
  self.text_have_tip:SetLocalText("champion_duel_tips1110")
  self.img_have_icon = self:AddComponent(UIImage, img_have_icon_path)
  if iconPath then
    self.img_have_icon:LoadSpriteAsyncWithCallback(iconPath, function()
      if self.img_have_icon then
        self.img_have_icon:SetNativeSize()
      end
    end)
  end
  self.text_have_num = self:AddComponent(UIText, text_have_num_path)
  self.text_remain = self:AddComponent(UIText, text_remain_path)
end

function UIChampionDuelGuess:ComponentDestroy()
  self.anim = nil
  self.stateInfo = nil
  self.time_group = nil
  self.text_cd = nil
  self.score_group = nil
  self.text_score_left = nil
  self.text_score_right = nil
  self.btn_more = nil
  self.text_btn_more = nil
  self.red_more = nil
  self.text_red_more = nil
  self.mid_blue = nil
  self.mid_red = nil
  self.vs = nil
  self.eff = nil
  self.bottom = nil
  self.text_empty = nil
  self.text_title = nil
  self.btn_title = nil
  self.text_bet_blue = nil
  self.text_bet_red = nil
  self.slider_blue = nil
  self.slider_red = nil
  self.text_rat_blue = nil
  self.text_rat_red = nil
  self.btn_bet_blue = nil
  self.img_btn_bet_blue = nil
  self.text_btn_bet_blue = nil
  self.bet_tip_blue = nil
  self.img_bet_tip_blue = nil
  self.text_bet_tip_blue = nil
  self.btn_bet_red = nil
  self.img_btn_bet_red = nil
  self.text_btn_bet_red = nil
  self.bet_tip_red = nil
  self.img_bet_tip_red = nil
  self.text_bet_tip_red = nil
  self.btn_refresh = nil
  self.text_have_tip = nil
  self.img_have_icon = nil
  self.text_have_num = nil
  self.text_remain = nil
end

function UIChampionDuelGuess:OnClickBtnLog()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelGuessList, {anim = true}, BindCallback(self, self.RefreshDi))
end

function UIChampionDuelGuess:OnClickBtnTitle()
  local strTip = Localization:GetString("champion_duel_tips1112")
  UIUtil.ShowBubbleTips(strTip, self.btn_title.transform.position, 0, 30, 0, nil, nil, {reversal = true})
end

function UIChampionDuelGuess:TryClickBet(bBlue)
  local betInfo = DataCenter.ChampionDuelManager:GetBetInfo()
  if betInfo == nil then
    return
  end
  local rival = bBlue and betInfo.betMatchRivalA or betInfo.betMatchRivalB
  if rival == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local betMatchBattleTime = betInfo ~= nil and betInfo.betMatchBattleTime or 0
  local remainTime = betMatchBattleTime - curTime / 1000
  local scoreFlag = self.text_score_left:GetText() == "0" and self.text_score_right:GetText() == "0"
  if scoreFlag and 0 < remainTime then
    if rival.isChooseBet then
      if self.lastBtnBetClickTime ~= nil and 1000 >= curTime - self.lastBtnBetClickTime then
        return
      end
      DataCenter.ChampionDuelManager:ReqBetCancel(betInfo.betMatchId)
      self.lastBtnBetClickTime = curTime
    else
      local dayRemainingBets = betInfo ~= nil and betInfo.dayRemainingBets or 0
      if 0 < dayRemainingBets then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelGuessBet, {anim = true}, betInfo, bBlue)
      else
        UIUtil.ShowTipsId("champion_duel_tips1129")
      end
    end
  else
    UIUtil.ShowTipsId("champion_duel_tips1126")
  end
end

function UIChampionDuelGuess:OnClickBtnBetBlue()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self:TryClickBet(true)
end

function UIChampionDuelGuess:OnClickBtnBetRed()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self:TryClickBet(false)
end

function UIChampionDuelGuess:OnClickBtnRefresh()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.lastBtnRefreshClickTime == nil or curTime - self.lastBtnRefreshClickTime > 3000 then
    DataCenter.ChampionDuelManager:ReqBetRefresh()
    self.lastBtnRefreshClickTime = curTime
  else
    UIUtil.ShowTipsId("champion_duel_tips1135")
  end
end

function UIChampionDuelGuess:ReInit()
  DataCenter.ChampionDuelManager:SaveGuessTime()
  self.stateInfo:ReInit()
  self.time_group:ReInit()
  DataCenter.ChampionDuelManager:ReqBetMain()
  self:UpdateRed()
end

function UIChampionDuelGuess:OnInfoRefresh(betMatchId)
  if betMatchId ~= nil then
    local betInfo = DataCenter.ChampionDuelManager:GetBetInfo()
    local myBetMatchId = betInfo ~= nil and betInfo.betMatchId or nil
    if myBetMatchId ~= betMatchId then
      return
    end
  end
  self.retryTime = 0
  self:RefreshMid()
  self:RefreshBottom()
  self:RefreshDi()
  if self.timer then
    self.timer:Stop()
  end
  self.timer = nil
  self:PlayHeadAnim(true)
  self:Update1000MS()
end

function UIChampionDuelGuess:RefreshMid()
  local betInfo = DataCenter.ChampionDuelManager:GetBetInfo()
  local rA = betInfo ~= nil and betInfo.betMatchRivalA or nil
  self.mid_blue:ReInit(rA, -1)
  local rB = betInfo ~= nil and betInfo.betMatchRivalB or nil
  self.mid_red:ReInit(rB, 1)
  local scoreA = rA ~= nil and rA.point or 0
  local scoreB = rB ~= nil and rB.point or 0
  self.text_score_left:SetText(scoreA)
  self.text_score_right:SetText(scoreB)
end

function UIChampionDuelGuess:RefreshBottom()
  local betInfo = DataCenter.ChampionDuelManager:GetBetInfo()
  local isStageBattleEnd = betInfo ~= nil and betInfo.isStageBattleEnd or false
  local stageId = DataCenter.ChampionDuelManager:GetCurStageId()
  local normalShow = stageId ~= ChampionDuelState.RematchAnnouncement and stageId ~= ChampionDuelState.FinalShow
  normalShow = normalShow and betInfo ~= nil and not isStageBattleEnd
  self.bottom:SetActive(normalShow)
  self.btn_refresh:SetActive(normalShow)
  self.text_remain:SetActive(normalShow)
  self.text_empty:SetActive(not normalShow)
  if stageId == ChampionDuelState.RematchAnnouncement then
    self.text_empty:SetLocalText("champion_duel_tips1130")
    return
  end
  if isStageBattleEnd then
    if stageId == ChampionDuelState.Rematch then
      self.text_empty:SetLocalText("champion_duel_tips1121")
    elseif stageId == ChampionDuelState.KnockOut or stageId == ChampionDuelState.FinalShow then
      self.text_empty:SetLocalText("champion_duel_tips1147")
    end
    return
  end
  local rA = betInfo.betMatchRivalA or nil
  local rB = betInfo.betMatchRivalB or nil
  local odds = betInfo.odds or 1
  self.text_title:SetLocalText("champion_duel_tips1106", odds)
  local blueTotalBet = rA ~= nil and rA.totalBets or 0
  self.text_bet_blue:SetLocalText("champion_duel_tips1107", string.GetFormattedStr(math.floor(blueTotalBet)))
  local redTotalBet = rB ~= nil and rB.totalBets or 0
  self.text_bet_red:SetLocalText("champion_duel_tips1107", string.GetFormattedStr(math.floor(redTotalBet)))
  local totalBet = redTotalBet + blueTotalBet
  local blueRat = totalBet == 0 and 0.5 or blueTotalBet / totalBet
  local showNum = math.modf(blueRat * 100)
  self.text_rat_blue:SetText(showNum .. "%")
  self.slider_blue:SetValue(blueRat)
  local redRat = totalBet == 0 and 0.5 or 1 - blueRat
  showNum = 100 - showNum
  self.text_rat_red:SetText(showNum .. "%")
  self.slider_red:SetValue(redRat)
  local hasBet = betInfo.hasBet or false
  if hasBet then
    local blueChoose = rA ~= nil and rA.isChooseBet or false
    if blueChoose then
      self.bet_tip_blue:SetActive(true)
      local cost = DataCenter.ChampionDuelManager:GetBetCost(betInfo.betCountId)
      self.text_bet_tip_blue:SetText("\195\151" .. cost)
      self:SetBetBtn(self.btn_bet_blue, "champion_duel_tips1108", self.text_btn_bet_blue, self.img_btn_bet_blue, false)
    else
      self:SetBetBtn(self.btn_bet_blue)
    end
    local redChoose = rB ~= nil and rB.isChooseBet or false
    if redChoose then
      self.bet_tip_red:SetActive(true)
      local cost = DataCenter.ChampionDuelManager:GetBetCost(betInfo.betCountId)
      self.text_bet_tip_red:SetText("\195\151" .. cost)
      self:SetBetBtn(self.btn_bet_red, "champion_duel_tips1108", self.text_btn_bet_red, self.img_btn_bet_red, false)
    else
      self:SetBetBtn(self.btn_bet_red)
    end
  else
    self.bet_tip_blue:SetActive(false)
    self.bet_tip_red:SetActive(false)
    self:SetBetBtn(self.btn_bet_blue, "champion_duel_tips1109", self.text_btn_bet_blue, self.img_btn_bet_blue, true)
    self:SetBetBtn(self.btn_bet_red, "champion_duel_tips1109", self.text_btn_bet_red, self.img_btn_bet_red, true)
  end
end

function UIChampionDuelGuess:SetBetBtn(btn, keyStr, text, img, bBet)
  if keyStr == nil then
    btn:SetActive(false)
    return
  end
  img:LoadSpriteAuto(bBet and BTN_GREEN_PATH or BTN_BLUE_PATH)
  text:SetLocalText(keyStr)
  btn:SetActive(true)
end

function UIChampionDuelGuess:RefreshDi()
  local curHave = DataCenter.ChampionDuelManager:GetGuessItemHave()
  self.text_have_num:SetText(string.GetFormattedStr(math.floor(curHave)))
  local betInfo = DataCenter.ChampionDuelManager:GetBetInfo()
  local dayRemainingBets = betInfo ~= nil and betInfo.dayRemainingBets or 0
  self.text_remain:SetLocalText("champion_duel_tips1111", dayRemainingBets, self.maxGuessTime)
  self:UpdateRed()
end

function UIChampionDuelGuess:Update1000MS()
  local betInfo = DataCenter.ChampionDuelManager:GetBetInfo()
  local betMatchBattleTime = betInfo ~= nil and betInfo.betMatchBattleTime or nil
  if betMatchBattleTime == nil or betMatchBattleTime == 0 then
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local remainTime = betMatchBattleTime - curSec
  if 0 < remainTime then
    local timeStr = UITimeManager:GetInstance():SecondToFmtStringWithoutDay(remainTime)
    self.text_cd:SetLocalText("champion_duel_tips1104", timeStr)
    self.text_cd:SetActive(true)
    self.vs:SetActive(true)
    self.eff:SetActive(false)
  else
    local battleEnd = betInfo ~= nil and betInfo.isBattleEnd or false
    if battleEnd then
      self.text_cd:SetActive(false)
      self.vs:SetActive(true)
      self.eff:SetActive(false)
    else
      self.text_cd:SetLocalText("champion_duel_tips1086")
      self.text_cd:SetActive(true)
      self.vs:SetActive(false)
      self.eff:SetActive(true)
      local stageId = DataCenter.ChampionDuelManager:GetCurStageId()
      if stageId == ChampionDuelState.RematchAnnouncement or stageId == ChampionDuelState.FinalShow then
        return
      end
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if self.retryTime < 60 and self.lastGetInfoTime == nil or curTime - self.lastGetInfoTime > 3000 then
        self.retryTime = self.retryTime + 1
        DataCenter.ChampionDuelManager:ReqBetMain()
        self.lastGetInfoTime = curTime
      end
    end
  end
end

function UIChampionDuelGuess:PlayHeadAnim(bOpen)
  if self.timer ~= nil then
    return
  end
  self.anim:Enable(true)
  local animName = bOpen and "start" or "end"
  local ret, time = self.anim:PlayAnimationReturnTime(animName)
  if ret then
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      if self.timer then
        self.timer:Stop()
      end
      self.timer = nil
      self:PlayHeadAnim(not bOpen)
    end, time + 5)
  end
end

function UIChampionDuelGuess:UpdateRed()
  local cnt = DataCenter.ChampionDuelManager:CheckGuessRewardRed()
  self.red_more:SetActive(0 < cnt)
  if 0 < cnt then
    self.text_red_more:SetText(cnt)
  end
end

return UIChampionDuelGuess
