local UISurfingBattleResultView = BaseClass("UISurfingBattleResultView", UIBaseView)
local base = UIBaseView
local result_text_root_path = "SafeArea/ResultTextRoot"
local result_text_path = "SafeArea/ResultTextRoot/ResultText"
local score_text_path = "SafeArea/ScoreRoot/ScoreText"
local scroll_view_path = "SafeArea/RewardRoot/Scroll View"
local again_btn_path = "SafeArea/BottomGroup/AgainBtnRoot/AgainBtn"
local again_btn_text_path = "SafeArea/BottomGroup/AgainBtnRoot/AgainBtn/LW_Btn_Common_New_Base/AgainBtnText"
local back_btn_path = "SafeArea/BottomGroup/BackBtnRoot/BackBtn"
local back_btn_text_path = "SafeArea/BottomGroup/BackBtnRoot/BackBtn/LW_Btn_Common_New_Base/BackBtnText"
local tag_bg_path = "SafeArea/ScoreRoot/ScoreText/TagBg"
local tag_text_path = "SafeArea/ScoreRoot/ScoreText/TagBg/TagText"
local share_btn_path = "SafeArea/ShareBtn"
local tip_text_path = "SafeArea/BottomGroup/TipText"
local remain_times_path = "SafeArea/BottomGroup/AgainBtnRoot/RemainTimes"

function UISurfingBattleResultView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UISurfingBattleResultView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UISurfingBattleResultView:ComponentDefine()
  self.result_text_root = self:AddComponent(UIBaseContainer, result_text_root_path)
  self.result_text = self:AddComponent(UITextMeshProUGUIEx, result_text_path)
  self.score_text = self:AddComponent(UITextMeshProUGUIEx, score_text_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
  self.again_btn = self:AddComponent(UIButton, again_btn_path)
  self.again_btn:SetOnClick(function()
    self:OnAgainBtnClick()
  end)
  self.again_btn_text = self:AddComponent(UITextMeshProUGUIEx, again_btn_text_path)
  self.again_btn_text:SetLocalText("parkour_settlement_start_btn")
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.back_btn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.back_btn_text = self:AddComponent(UITextMeshProUGUIEx, back_btn_text_path)
  self.back_btn_text:SetLocalText("parkour_settlement_close_btn")
  self.tag_bg = self:AddComponent(UIImage, tag_bg_path)
  self.tag_text = self:AddComponent(UITextMeshProUGUIEx, tag_text_path)
  self.share_btn = self:AddComponent(UIButton, share_btn_path)
  self.share_btn:SetOnClick(BindCallback(self, self.OnShareBtnClick))
  self.tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
  local tipKey = DataCenter.LWSurfingDataManager:GetResultTipKey()
  if not string.IsNullOrEmpty(tipKey) then
    self.tip_text:SetLocalText(tipKey)
  end
  self.remain_times = self:AddComponent(UITextMeshProUGUIEx, remain_times_path)
end

function UISurfingBattleResultView:ComponentDestroy()
  self.result_text_root = nil
  self.result_text = nil
  self.score_text = nil
  self:ClearScroll()
  self.scroll_view = nil
  self.again_btn = nil
  self.again_btn_text = nil
  self.back_btn = nil
  self.back_btn_text = nil
  self.tag_bg = nil
  self.tag_text = nil
  self.share_btn = nil
  self.tip_text = nil
end

function UISurfingBattleResultView:DataDefine()
  self.logic = nil
  self.dataList = nil
  self.message = nil
end

function UISurfingBattleResultView:DataDestroy()
  self.logic = nil
  self.dataList = nil
  self.message = nil
end

function UISurfingBattleResultView:OnAddListener()
  base.OnAddListener(self)
end

function UISurfingBattleResultView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UISurfingBattleResultView:InitView()
  local message = self:GetUserData()
  if message == nil or message.errorCode ~= nil then
    return
  end
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if logic == nil or message.uuid ~= logic:GetUuid() then
    return
  end
  self.message = message
  local dataList = message.reward
  self.dataList = dataList
  if dataList and 0 < #dataList then
    self.scroll_view:SetTotalCount(#dataList)
    self.scroll_view:RefillCells()
  end
  local rankType = message.rankType
  local type = message.type or 0
  local myScore = message.myScore or 0
  if rankType == nil then
    self.result_text_root:SetActive(false)
  else
    self.result_text_root:SetActive(true)
    if type == 1 then
      local tipsId
      local tScore = message.tScore or 0
      local aheadNum = message.aheadNum or 0
      local rankNum = message.rankNum or 0
      if rankType == 1 then
        tipsId = "parkour_settlement_desc_1"
      elseif rankType == 2 then
        tipsId = "parkour_settlement_desc_1_round"
      end
      if not string.IsNullOrEmpty(tipsId) then
        local per = aheadNum / rankNum * 100
        local str = string.format("%.0f", per)
        self.result_text:SetLocalText(tipsId, str, tScore + 1 - myScore, message.tName)
      end
    elseif type == 2 then
      local tipsId
      local myOldScore = message.myOldScore or 0
      if rankType == 1 then
        tipsId = "parkour_failed_record_desc_2"
      elseif rankType == 2 then
        tipsId = "parkour_failed_record_desc_2_round"
      end
      if not string.IsNullOrEmpty(tipsId) then
        self.result_text:SetLocalText(tipsId, myScore, myOldScore + 1 - myScore)
      end
    elseif type == 3 then
      local tipsId
      if rankType == 1 then
        tipsId = "parkour_failed_record_desc_3"
      elseif rankType == 2 then
        tipsId = "parkour_failed_record_desc_3_round"
      end
      if not string.IsNullOrEmpty(tipsId) then
        self.result_text:SetLocalText(tipsId, myScore)
      end
    elseif type == 4 then
      local tipsId
      local rank = message.rank
      if rankType == 1 then
        tipsId = "parkour_settlement_scrolling_2_round"
      elseif rankType == 2 then
        tipsId = "parkour_settlement_scrolling_2"
      end
      if not string.IsNullOrEmpty(tipsId) and rank then
        self.result_text:SetLocalText(tipsId, myScore, rank)
      end
    end
  end
  local scoreContId
  local value = 0
  if rankType == 1 then
    scoreContId = "parkour_settlement_score"
    value = message.distance
  else
    scoreContId = "parkour_settlement_score_round"
    value = message.coin
  end
  self.score_text:SetLocalText(scoreContId, value)
  local bestType = message.best or 0
  if bestType == 0 then
    self.tag_bg:SetActive(false)
    self.share_btn:SetActive(false)
  else
    self.tag_bg:SetActive(true)
    if bestType == 1 then
      self.tag_text:SetLocalText("parkour_today_damage_title")
    elseif bestType == 2 then
      self.tag_text:SetLocalText("parkour_total_damage_title")
    end
    self.share_btn:SetActive(true)
  end
  local remainTimes = DataCenter.LWSurfingDataManager:GetRemainTimes()
  self.remain_times:SetLocalText("parkour_challenge_num", remainTimes)
end

function UISurfingBattleResultView:OnRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(UICommonResItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(self.dataList[index])
  end
end

function UISurfingBattleResultView:OnRewardItemMoveOut(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UICommonResItem)
end

function UISurfingBattleResultView:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UICommonResItem)
end

function UISurfingBattleResultView:OnAgainBtnClick()
  local remainTimes = DataCenter.LWSurfingDataManager:GetRemainTimes()
  if remainTimes and 0 < remainTimes then
    DataCenter.LWSurfingDataManager:ReqFightStartCheck(true)
    DataCenter.LWSurfingDataManager:SendGetAllParkourInfosMessage()
  else
    DataCenter.LWBattleManager:ShowTipsId("parkour_challenge_finish")
  end
end

function UISurfingBattleResultView:OnBackBtnClick()
  self.ctrl:CloseSelf()
  DataCenter.LWSurfingDataManager:GoBackToActivityPanel()
end

function UISurfingBattleResultView:OnShareBtnClick()
  self.share_btn:SetActive(false)
  if self.message == nil then
    return
  end
  local rankType = self.message.rankType or 0
  local bestType = self.message.best or 0
  local myScore = self.message.myScore or 0
  local contextId
  if bestType == 1 then
    contextId = rankType == 1 and "parkour_today_meters_record" or "parkour_today_score_record"
  elseif bestType == 2 then
    contextId = rankType == 1 and "parkour_max_meters_record" or "parkour_max_score_record"
  end
  local activityId = DataCenter.LWSurfingDataManager:GetActId()
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  local endTs = activityInfo and activityInfo.endTime
  local shareParam = {}
  shareParam.post = PostType.SurfingBattleResultShare
  shareParam.param = {}
  shareParam.param.endTs = endTs
  shareParam.param.contextId = contextId
  shareParam.param.para = myScore .. ""
  shareParam.param.activityId = activityId
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, shareParam)
end

return UISurfingBattleResultView
