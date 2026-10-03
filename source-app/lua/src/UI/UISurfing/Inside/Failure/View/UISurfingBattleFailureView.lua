local UISurfingBattleFailureView = BaseClass("UISurfingBattleFailureView", UIBaseView)
local base = UIBaseView
local title_text_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local content_text_path = "SafeArea/ContentRoot/Bg/ContentText"
local tag_text_path = "SafeArea/ContentRoot/Bg/TagBg/TagText"
local score_tip_text_path = "SafeArea/ScoreBg/ScoreTipText"
local icon1_path = "SafeArea/ScoreBg/ScoreRoot/Icon1"
local score_text_path = "SafeArea/ScoreBg/ScoreRoot/ScoreText"
local return_btn_path = "SafeArea/ReturnBtn"
local return_btn_text_path = "SafeArea/ReturnBtn/LW_Btn_Common_New_Base/ReturnBtnText"
local resurgence_btn_path = "SafeArea/ResurgenceBtn"
local resurgence_btn_text_path = "SafeArea/ResurgenceBtn/Bg/ResurgenceBtnText"
local times_text_path = "SafeArea/TimesText"
local icon2_path = "SafeArea/ResurgenceBtn/Bg/CostRoot/Icon2"
local cost_num_text_path = "SafeArea/ResurgenceBtn/Bg/CostRoot/CostNumText"
local tag_bg_path = "SafeArea/ContentRoot/Bg/TagBg"

function UISurfingBattleFailureView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UISurfingBattleFailureView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UISurfingBattleFailureView:ComponentDefine()
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.title_text:SetLocalText("parkour_failed_title")
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self, self.OnReturnClick))
  self.content_text = self:AddComponent(UITextMeshProUGUIEx, content_text_path)
  self.tag_text = self:AddComponent(UITextMeshProUGUIEx, tag_text_path)
  self.tag_text:SetLocalText("parkour_failed_new_record")
  self.score_tip_text = self:AddComponent(UITextMeshProUGUIEx, score_tip_text_path)
  self.score_tip_text:SetLocalText("parkour_failed_balance")
  self.icon1 = self:AddComponent(UIImage, icon1_path)
  self.score_text = self:AddComponent(UITextMeshProUGUIEx, score_text_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(BindCallback(self, self.OnReturnClick))
  self.return_btn_text = self:AddComponent(UITextMeshProUGUIEx, return_btn_text_path)
  self.return_btn_text:SetLocalText("parkour_failed_close_btn")
  self.resurgence_btn = self:AddComponent(UIButton, resurgence_btn_path)
  self.resurgence_btn:SetOnClick(BindCallback(self, self.OnResurgenceClick))
  self.resurgence_btn_text = self:AddComponent(UITextMeshProUGUIEx, resurgence_btn_text_path)
  self.resurgence_btn_text:SetLocalText("parkour_failed_start_btn")
  self.times_text = self:AddComponent(UITextMeshProUGUIEx, times_text_path)
  self.icon2 = self:AddComponent(UIImage, icon2_path)
  self.cost_num_text = self:AddComponent(UITextMeshProUGUIEx, cost_num_text_path)
  self.tag_bg = self:AddComponent(UIImage, tag_bg_path)
end

function UISurfingBattleFailureView:ComponentDestroy()
  self.title_text = nil
  self.close_btn = nil
  self.content_text = nil
  self.tag_text = nil
  self.score_tip_text = nil
  self.icon1 = nil
  self.score_text = nil
  self.return_btn = nil
  self.return_btn_text = nil
  self.resurgence_btn = nil
  self.resurgence_btn_text = nil
  self.times_text = nil
  self.icon2 = nil
  self.cost_num_text = nil
  self.tag_bg = nil
end

function UISurfingBattleFailureView:DataDefine()
  self.data = nil
  self.costNum = nil
  self.goodId = nil
  self.sendMsgTs = nil
  self.have = nil
end

function UISurfingBattleFailureView:DataDestroy()
  self.data = nil
  self.costNum = nil
  self.goodId = nil
  self.sendMsgTs = nil
  self.have = nil
end

function UISurfingBattleFailureView:InitView()
  local message = self:GetUserData()
  self.data = message
  if message == nil or message.errorCode ~= nil then
    return
  end
  local rankType = message.rankType
  local type = message.type or 0
  local addCoin = message.coin
  local distance = message.distance
  local myScore = message.myScore or 0
  if rankType == nil then
    self.content_text:SetLocalText("parkour_failed_record_error")
    self.tag_bg:SetActive(false)
  else
    if type == 1 then
      local tipsId
      local tScore = message.tScore or 0
      local value = 0
      if rankType == 1 then
        tipsId = "parkour_failed_record_desc_1"
        value = distance
      elseif rankType == 2 then
        tipsId = "parkour_failed_record_desc_1_round"
        value = addCoin
      end
      if not string.IsNullOrEmpty(tipsId) then
        self.content_text:SetLocalText(tipsId, value, tScore + 1 - myScore, message.tName)
      end
    elseif type == 2 then
      local tipsId
      local myOldScore = message.myOldScore or 0
      local value = 0
      if rankType == 1 then
        tipsId = "parkour_failed_record_desc_2"
        value = distance
      elseif rankType == 2 then
        tipsId = "parkour_failed_record_desc_2_round"
        value = addCoin
      end
      if not string.IsNullOrEmpty(tipsId) then
        self.content_text:SetLocalText(tipsId, value, myOldScore + 1 - myScore)
      end
    elseif type == 3 then
      local tipsId
      local value = 0
      if rankType == 1 then
        tipsId = "parkour_failed_record_desc_3"
        value = distance
      elseif rankType == 2 then
        tipsId = "parkour_failed_record_desc_3_round"
        value = addCoin
      end
      if not string.IsNullOrEmpty(tipsId) then
        self.content_text:SetLocalText(tipsId, value)
      end
    end
    local best = message.best
    self.tag_bg:SetActive(best)
  end
  local goodId = DataCenter.LWSurfingDataManager:GetCoinId()
  self.goodId = goodId
  local iconPath = DataCenter.ItemTemplateManager:GetIconPath(goodId)
  self.icon1:LoadSpriteAsync(iconPath)
  self.icon2:LoadSpriteAsync(iconPath)
  local have = message.user_coin or 0
  self.have = have
  self.score_text:SetText(tostring(have))
  local resurgenceTimes = message.rebirthTimes
  local resurgenceLimit = DataCenter.LWSurfingDataManager:GetResurgenceLimit()
  self.times_text:SetLocalText("parkour_failed_start_count", resurgenceLimit - resurgenceTimes, resurgenceLimit)
  self.costNum = DataCenter.LWSurfingDataManager:GetResurgenceCost(resurgenceTimes + 1)
  local costText
  if have < self.costNum then
    costText = CS.GameEntry.Localization:GetString("parkour_not_enough_score_color", self.costNum)
  else
    costText = self.costNum
  end
  self.cost_num_text:SetLocalText("390902", costText)
end

function UISurfingBattleFailureView:OnReturnClick()
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if logic then
    logic:EndGame()
  end
  self.ctrl:CloseSelf()
end

function UISurfingBattleFailureView:OnResurgenceClick()
  local have = self.have or 0
  if have < self.costNum then
    DataCenter.LWBattleManager:ShowTipsId("parkour_not_enough_score")
  else
    local curTs = UITimeManager:GetInstance():GetServerTime()
    if self.sendMsgTs == nil then
      self.sendMsgTs = curTs
    elseif curTs - self.sendMsgTs < 500 then
      return
    end
    self.sendMsgTs = curTs
    local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
    if logic then
      logic:RebirthGame()
    end
    self.ctrl:CloseSelf()
  end
end

return UISurfingBattleFailureView
