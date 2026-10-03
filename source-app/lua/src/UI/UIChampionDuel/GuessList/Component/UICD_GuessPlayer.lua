local UICD_GuessPlayer = BaseClass("UICD_GuessPlayer", UIBaseContainer)
local base = UIBaseContainer
local UIDecorationHeadFrame = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationHeadFrame")
local headFrame_path = "Head"
local btn_path = "Head/Btn"
local img_result_path = "Result"
local text_server_path = "Di/ServerText"
local text_name_path = "NameText"
local text_bet_tip_path = "BetGroup/BetTipText"
local img_cost_path = "BetGroup/CostIcon"
local text_bet_num_path = "BetGroup/BetNumText"
local btn_bet_path = "BtnBet"
local img_btn_path = "BtnBet/Icon"
local text_btn_bet_path = "BtnBet/TextBtnBet"
local img_sign_path = "Sign"
local tip_path = "BtnBet/Tip"
local img_tip_icon_path = "BtnBet/Tip/BetGetIcon"
local text_bet_cost_path = "BtnBet/Tip/BetCostText"
local text_add_num_path = "BtnBet/Tip/AddNumText"
local btn_search_path = "SearchBtn"
local WIN_IMG_PATH = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_victory.png"
local LOSE_IMG_PATH = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_defeat.png"
local BTN_GREEN_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_2.png"
local BTN_BLUE_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png"
local SIGN_WRONG_PATH = "Assets/Main/Sprites/UI/UIChampionDuel/Sprites/lrb_guanjunduijue_jingcai_gengguoxiazhu_caicuo.png"
local SIGN_RIGHT_PATH = "Assets/Main/Sprites/UI/UIChampionDuel/Sprites/lrb_guanjunduijue_jingcai_gengguoxiazhu_caidui.png"

function UICD_GuessPlayer:OnCreate()
  base.OnCreate(self)
  self.myPoint = 0
  self.otherPoint = 0
  self.headFrame = self:AddComponent(UIDecorationHeadFrame, headFrame_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(BindCallback(self, self.OnClickInfoBtn))
  self.img_result = self:AddComponent(UIImage, img_result_path)
  self.text_server = self:AddComponent(UIText, text_server_path)
  self.text_name = self:AddComponent(UIText, text_name_path)
  self.text_bet_tip = self:AddComponent(UIText, text_bet_tip_path)
  self.text_bet_tip:SetLocalText("champion_duel_tips1107", "")
  self.img_cost = self:AddComponent(UIImage, img_cost_path)
  local iconPath = DataCenter.ChampionDuelManager:GetGuessItemIcon()
  if iconPath then
    self.img_cost:LoadSpriteAsyncWithCallback(iconPath, function()
      if self.img_cost then
        self.img_cost:SetNativeSize()
      end
    end)
  end
  self.text_bet_num = self:AddComponent(UIText, text_bet_num_path)
  self.btn_bet = self:AddComponent(UIButton, btn_bet_path)
  self.btn_bet:SetOnClick(BindCallback(self, self.OnClickBtn))
  self.img_btn = self:AddComponent(UIImage, img_btn_path)
  self.text_btn_bet = self:AddComponent(UIText, text_btn_bet_path)
  self.img_sign = self:AddComponent(UIImage, img_sign_path)
  self.tip = self:AddComponent(UIBaseContainer, tip_path)
  self.img_tip_icon = self:AddComponent(UIImage, img_tip_icon_path)
  if iconPath then
    self.img_tip_icon:LoadSpriteAsyncWithCallback(iconPath, function()
      if self.img_tip_icon then
        self.img_tip_icon:SetNativeSize()
      end
    end)
  end
  self.text_bet_cost = self:AddComponent(UIText, text_bet_cost_path)
  self.text_add_num = self:AddComponent(UIText, text_add_num_path)
  self.text_add_num:SetActive(false)
  self.btn_search = self:AddComponent(UIButton, btn_search_path)
  self.btn_search:SetOnClick(BindCallback(self, self.OnClickSearch))
end

function UICD_GuessPlayer:OnDestroy()
  self.myPoint = 0
  self.otherPoint = 0
  self.headFrame = nil
  self.btn = nil
  self.img_result = nil
  self.text_server = nil
  self.text_name = nil
  self.text_bet_tip = nil
  self.img_cost = nil
  self.text_bet_num = nil
  self.btn_bet = nil
  self.img_btn = nil
  self.text_btn_bet = nil
  self.img_sign = nil
  self.tip = nil
  self.img_tip_icon = nil
  self.text_bet_cost = nil
  self.text_add_num = nil
  self.btn_search = nil
  base.OnDestroy(self)
end

function UICD_GuessPlayer:OnClickInfoBtn()
  if self.info == nil then
    return
  end
  self.info:OnHeadClick()
end

function UICD_GuessPlayer:OnClickSearch()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.uid == nil then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelBattleLog, {anim = true}, self.uid, self.name)
end

function UICD_GuessPlayer:OnClickBtn()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.matchRival == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.btnState == 3 then
    if self.lastBtnClickTime ~= nil and curTime - self.lastBtnClickTime <= 1000 then
      return
    end
    DataCenter.ChampionDuelManager:ReqDrawAward(self.matchRival.betMatchId)
    self.lastBtnClickTime = curTime
  else
    local betMatchBattleTime = self.matchRival.betMatchBattleTime or 0
    local remainTime = betMatchBattleTime - curTime / 1000
    local scoreFlag = self.myPoint == 0 and self.otherPoint == 0
    if scoreFlag and 0 < remainTime then
      if self.btnState == 1 then
        local betInfo = DataCenter.ChampionDuelManager:GetBetInfo()
        local dayRemainingBets = betInfo ~= nil and betInfo.dayRemainingBets or 0
        if 0 < dayRemainingBets then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelGuessBet, {anim = true}, self.matchRival, self.bBlue)
        else
          UIUtil.ShowTipsId("champion_duel_tips1129")
        end
      elseif self.btnState == 2 then
        if self.lastBtnClickTime ~= nil and curTime - self.lastBtnClickTime <= 1000 then
          return
        end
        DataCenter.ChampionDuelManager:ReqBetCancel(self.matchRival.betMatchId)
        self.lastBtnClickTime = curTime
      end
    else
      UIUtil.ShowTipsId("champion_duel_tips1126")
      if self.changeCb then
        self:changeCb()
        self.changeCb = nil
      end
    end
  end
end

function UICD_GuessPlayer:ReInit(matchRival, curTab, bBlue, changeCb)
  self.matchRival = matchRival
  self.bBlue = bBlue
  self.uid = nil
  self.name = nil
  self.changeCb = changeCb
  if self.matchRival == nil then
    return
  end
  local myInfo = bBlue and matchRival.betMatchRivalA or matchRival.betMatchRivalB
  self.info = myInfo
  self.uid = myInfo ~= nil and myInfo.uid or nil
  self.name = myInfo ~= nil and myInfo.name or nil
  local myPoint = myInfo ~= nil and myInfo.point or 0
  self.myPoint = myPoint
  if myInfo ~= nil then
    myInfo:SetFrameShow(self.headFrame)
    self.text_server:SetText("#" .. myInfo.server)
    myInfo:SetNameShow(self.text_name)
    if myInfo.uid == LuaEntry.Player:GetUid() then
      self.text_name:SetColorRGBA255(95, 239, 135, 255)
    else
      self.text_name:SetColorRGBA255(255, 255, 255, 255)
    end
  end
  local totalBets = myInfo ~= nil and myInfo.totalBets or 0
  self.text_bet_num:SetText(string.GetFormattedStr(math.floor(totalBets)))
  local otherInfo = bBlue and matchRival.betMatchRivalB or matchRival.betMatchRivalA
  local otherPoint = otherInfo ~= nil and otherInfo.point or 0
  self.otherPoint = otherPoint
  if myPoint == 0 and myPoint == otherPoint then
    self.img_result:SetActive(false)
  else
    local curNum = myPoint + otherPoint
    local checkNum = curNum
    if curTab == 1 then
      local stageId = matchRival.stageId
      if stageId == ChampionDuelState.Rematch then
        checkNum = 3
      elseif stageId == ChampionDuelState.KnockOut then
        local groupId = matchRival.groupId
        checkNum = 5 <= groupId and 5 or 3
      else
        checkNum = 1
      end
    end
    if checkNum ~= curNum then
      self.img_result:SetActive(false)
    else
      local bWin = myPoint > otherPoint
      self.img_result:LoadSpriteAsyncWithCallback(bWin and WIN_IMG_PATH or LOSE_IMG_PATH, function()
        if self.img_result then
          self.img_result:SetNativeSize()
        end
      end)
      self.img_result:SetActive(true)
    end
  end
  self.btnState = 0
  if curTab == 1 then
    self.img_sign:SetActive(false)
    CS.UIGray.SetGray(self.btn_bet.transform, false, true)
    if matchRival.hasBet then
      local myChoose = myInfo ~= nil and myInfo.isChooseBet or false
      if myChoose then
        self.text_btn_bet:SetLocalText("champion_duel_tips1108")
        self.img_btn:LoadSpriteAuto(BTN_BLUE_PATH)
        self.btnState = 2
      end
      self.btn_bet:SetActive(myChoose)
    else
      self.img_btn:LoadSpriteAuto(BTN_GREEN_PATH)
      self.text_btn_bet:SetLocalText("champion_duel_tips1109")
      self.btn_bet:SetActive(true)
      self.btnState = 1
    end
    if self.btnState == 2 then
      self.tip:SetActive(true)
      local cost = DataCenter.ChampionDuelManager:GetBetCost(matchRival.betCountId)
      self.text_bet_cost:SetText("\195\151" .. cost)
      self.text_add_num:SetActive(false)
    else
      self.tip:SetActive(false)
    end
  elseif matchRival.hasBet then
    local myChoose = myInfo ~= nil and myInfo.isChooseBet or false
    self.btn_bet:SetActive(myChoose)
    if myChoose then
      local hasReward = matchRival.hasReward
      CS.UIGray.SetGray(self.btn_bet.transform, hasReward, not hasReward)
      self.img_btn:LoadSpriteAuto(BTN_GREEN_PATH)
      self.text_btn_bet:SetLocalText(hasReward and "170003" or "129054")
      self.btnState = 3
      self.tip:SetActive(true)
      local cost = DataCenter.ChampionDuelManager:GetBetCost(matchRival.betCountId)
      self.text_bet_cost:SetText("\195\151" .. cost)
      if myPoint > otherPoint then
        local addNum = cost * matchRival.odds - cost
        self.text_add_num:SetText(string.format("+%d", addNum))
        self.text_add_num:SetActive(true)
      else
        self.text_add_num:SetActive(false)
      end
      self.img_sign:SetActive(false)
    else
      local bWin = myPoint > otherPoint
      self.img_sign:LoadSpriteAsyncWithCallback(bWin and SIGN_WRONG_PATH or SIGN_RIGHT_PATH, function()
        if self.img_sign then
          self.img_sign:SetNativeSize()
        end
      end)
      self.img_sign:SetActive(true)
    end
  else
    self.btn_bet:SetActive(false)
    self.img_sign:SetActive(false)
  end
end

return UICD_GuessPlayer
