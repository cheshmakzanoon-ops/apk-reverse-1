local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local ActLotteryMain = BaseClass("ActLotteryMain", base)
local Localization = CS.GameEntry.Localization
local btn_info_path = "rect/topContent/BtnInfo"
local txt_act_name_path = "rect/topContent/Txt_ActName"
local txt_times_path = "rect/topContent/TimeContent/txtContent/Txt_Times"
local rank_reward_show_content_path = "rect/topContent/rankRewardShow/rankRewardShowContent"
local u_i_common_res_item_path = "rect/topContent/rankRewardShow/UICommonResItem"
local btn_reward_path = "rect/topContent/rankRewardShow/BtnReward"
local big_reward_player_path = "rect/topContent/rankRewardShow/BigRewardPlayer"
local u_i_player_head_path = "rect/topContent/rankRewardShow/BigRewardPlayer/UIPlayerHead"
local player_name_path = "rect/topContent/rankRewardShow/BigRewardPlayer/playerName"
local btn_record_path = "rect/topContent/BtnRecord"
local btn_gift_giving_path = "rect/topContent/BtnGiftGiving"
local item_rawimg_path = "rect/CenterContent/itemRawimg"
local empty_tip_content_path = "rect/CenterContent/emptyTipContent"
local use_item_icon_path = "rect/CenterContent/haveContent/useItemIcon"
local item_cur_num_path = "rect/CenterContent/haveContent/itemCurNum"
local skip_btn_path = "rect/bottomContent/skipBtn"
local skip_btn_be_select_path = "rect/bottomContent/skipBtn/skipBtnBeSelect"
local btn_get_path = "rect/bottomContent/BtnGet"
local lottery_btn_content_path = "rect/bottomContent/LotteryBtnContent"
local btn_recruit_one_path = "rect/bottomContent/LotteryBtnContent/LotteryBtns/BtnRecruitOne"
local btn_recruit_ten_path = "rect/bottomContent/LotteryBtnContent/LotteryBtns/BtnRecruitTen"
local lottery_change_btn_path = "rect/bottomContent/LotteryBtnContent/LotteryChangeBtn"
local img_cost_item1_path = "rect/bottomContent/LotteryBtnContent/LotteryBtns/BtnRecruitOne/ImgCostItem1"
local text_cost1_path = "rect/bottomContent/LotteryBtnContent/LotteryBtns/BtnRecruitOne/ImgCostItem1/TextCost1"
local text_btn1_path = "rect/bottomContent/LotteryBtnContent/LotteryBtns/BtnRecruitOne/TextBtn1"
local img_cost_item2_path = "rect/bottomContent/LotteryBtnContent/LotteryBtns/BtnRecruitTen/ImgCostItem2"
local text_cost2_path = "rect/bottomContent/LotteryBtnContent/LotteryBtns/BtnRecruitTen/ImgCostItem2/TextCost2"
local text_btn2_path = "rect/bottomContent/LotteryBtnContent/LotteryBtns/BtnRecruitTen/TextBtn2"
local show_reward_item_path = "rect/topContent/rankRewardShow/rankRewardShowContent/ShowRewardItem"
local btn_reward_txt_path = "rect/topContent/rankRewardShow/BtnReward/BtnRewardTxt"
local btn_gift_giving_red_point_path = "rect/topContent/BtnGiftGiving/BtnGiftGivingRedPoint"
local next_open_content_path = "rect/CenterContent/nextOpenContent"
local machine_img_path = "rect/CenterContent/nextOpenContent/machineImg"
local next_open_content_time_path = "rect/CenterContent/nextOpenContent/NextOpenContentTime"
local bottom_content_path = "rect/bottomContent"
local center_content_path = "rect/CenterContent"
local act_end_tip_path = "rect/ActEndTip"
local OneTimes = 1
local TenTimes = 10
local OneHundredTimes = 100

function ActLotteryMain:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function ActLotteryMain:OnDestroy()
  self:StopAnim()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActLotteryMain:ComponentDefine()
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.txt_act_name = self:AddComponent(UITextMeshProUGUIEx, txt_act_name_path)
  self.txt_times = self:AddComponent(UITextMeshProUGUIEx, txt_times_path)
  self.btn_info:SetOnClick(function()
    self:OnClickBtnInfo()
  end)
  self.rank_reward_show_content = self:AddComponent(UIBaseContainer, rank_reward_show_content_path)
  self.u_i_common_res_item = self:AddComponent(UICanvasGroup, u_i_common_res_item_path)
  self.btn_reward = self:AddComponent(UIButton, btn_reward_path)
  self.big_reward_player = self:AddComponent(UIBaseContainer, big_reward_player_path)
  self.u_i_player_head = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.player_name = self:AddComponent(UITextMeshProUGUIEx, player_name_path)
  self.btn_reward:SetOnClick(function()
    self:OnClickBtnReward()
  end)
  self.btn_reward_canvas = self:AddComponent(UICanvasGroup, btn_reward_path)
  self.big_reward_player_canvas = self:AddComponent(UICanvasGroup, big_reward_player_path)
  self.btn_record = self:AddComponent(UIButton, btn_record_path)
  self.btn_gift_giving = self:AddComponent(UIButton, btn_gift_giving_path)
  self.btn_record:SetOnClick(function()
    self:OnClickBtnRecord()
  end)
  self.btn_gift_giving:SetOnClick(function()
    self:OnClickBtnGiftGiving()
  end)
  self.item_rawimg = self:AddComponent(UIRawImage, item_rawimg_path)
  self.empty_tip_content = self:AddComponent(UIBaseContainer, empty_tip_content_path)
  self.use_item_icon = self:AddComponent(UIImage, use_item_icon_path)
  self.item_cur_num = self:AddComponent(UITextMeshProUGUIEx, item_cur_num_path)
  self.skip_btn = self:AddComponent(UIButton, skip_btn_path)
  self.skip_btn_be_select = self:AddComponent(UIImage, skip_btn_be_select_path)
  self.btn_get = self:AddComponent(UIButton, btn_get_path)
  self.lottery_btn_content = self:AddComponent(UIBaseContainer, lottery_btn_content_path)
  self.btn_recruit_one = self:AddComponent(UIButton, btn_recruit_one_path)
  self.btn_recruit_ten = self:AddComponent(UIButton, btn_recruit_ten_path)
  self.lottery_change_btn = self:AddComponent(UIButton, lottery_change_btn_path)
  self.img_cost_item1 = self:AddComponent(UIImage, img_cost_item1_path)
  self.text_cost1 = self:AddComponent(UITextMeshProUGUIEx, text_cost1_path)
  self.text_btn1 = self:AddComponent(UITextMeshProUGUIEx, text_btn1_path)
  self.img_cost_item2 = self:AddComponent(UIImage, img_cost_item2_path)
  self.text_cost2 = self:AddComponent(UITextMeshProUGUIEx, text_cost2_path)
  self.text_btn2 = self:AddComponent(UITextMeshProUGUIEx, text_btn2_path)
  self.skip_btn:SetOnClick(function()
    self:OnClickBtnSkip()
  end)
  self.btn_get:SetOnClick(function()
    self:OnClickBtnGet()
  end)
  self.btn_recruit_one:SetOnClick(function()
    self:OnClickBtnRecruitOne()
  end)
  self.btn_recruit_ten:SetOnClick(function()
    self:OnClickBtnRecruitTen()
  end)
  self.lottery_change_btn:SetOnClick(function()
    self:OnClickLotteryChangeBtn()
  end)
  self.show_reward_item = self:AddComponent(UICommonResItem, show_reward_item_path)
  self.btn_reward_txt = self:AddComponent(UITextMeshProUGUIEx, btn_reward_txt_path)
  self.btn_gift_giving_red_point = self:AddComponent(UIImage, btn_gift_giving_red_point_path)
  self.next_open_content = self:AddComponent(UIButton, next_open_content_path)
  self.machine_img = self:AddComponent(UIRawImage, machine_img_path)
  self.next_open_content_time = self:AddComponent(UITextMeshProUGUIEx, next_open_content_time_path)
  self.next_open_content:SetOnClick(function()
    self:OnClickNextOpenContent()
  end)
  self.bottom_content = self:AddComponent(UIBaseContainer, bottom_content_path)
  self.center_content = self:AddComponent(UIBaseContainer, center_content_path)
  self.act_end_tip = self:AddComponent(UITextMeshProUGUIEx, act_end_tip_path)
end

function ActLotteryMain:ComponentDestroy()
  self.btn_info = nil
  self.txt_act_name = nil
  self.txt_times = nil
  self.rank_reward_show_content = nil
  self.u_i_common_res_item = nil
  self.btn_reward = nil
  self.big_reward_player = nil
  self.u_i_player_head = nil
  self.player_name = nil
  self.btn_record = nil
  self.btn_gift_giving = nil
  self.item_rawimg = nil
  self.empty_tip_content = nil
  self.use_item_icon = nil
  self.item_cur_num = nil
  self.skip_btn = nil
  self.skip_btn_be_select = nil
  self.btn_get = nil
  self.lottery_btn_content = nil
  self.btn_recruit_one = nil
  self.btn_recruit_ten = nil
  self.lottery_change_btn = nil
  self.img_cost_item1 = nil
  self.text_cost1 = nil
  self.text_btn1 = nil
  self.img_cost_item2 = nil
  self.text_cost2 = nil
  self.text_btn2 = nil
  self.show_reward_item = nil
  self.btn_gift_giving_red_point = nil
  self.next_open_content = nil
  self.machine_img = nil
  self.next_open_content_time = nil
  self.bottom_content = nil
  self.center_content = nil
  self.act_end_tip = nil
end

function ActLotteryMain:DataDefine()
end

function ActLotteryMain:DataDestroy()
  self.curDayNumReal = nil
  self.nextOpenTimeReal = nil
end

function ActLotteryMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActLotteryDetailDataGet, self.GetActDetailDataMsg)
  self:AddUIListener(EventId.ActLotteryGetBeSendReward, self.GetBeSendRewardMsg)
  self:AddUIListener(EventId.ActLotteryDrawResultMsg, self.GetDwarResultMsg)
  self:AddUIListener(EventId.ActLotteryOpenViewClose, self.GetOpenRewardViewCloseMsg)
  self:AddUIListener(EventId.ActLotteryTicketHistoryMsg, self.GetActLotteryTicketHistoryMsg)
  self:AddUIListener(EventId.ActGiftGivingGive, self.GetActDetailDataMsg)
end

function ActLotteryMain:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActLotteryDetailDataGet, self.GetActDetailDataMsg)
  self:RemoveUIListener(EventId.ActLotteryGetBeSendReward, self.GetBeSendRewardMsg)
  self:RemoveUIListener(EventId.ActLotteryDrawResultMsg, self.GetDwarResultMsg)
  self:RemoveUIListener(EventId.ActLotteryOpenViewClose, self.GetOpenRewardViewCloseMsg)
  self:RemoveUIListener(EventId.ActLotteryTicketHistoryMsg, self.GetActLotteryTicketHistoryMsg)
  self:RemoveUIListener(EventId.ActGiftGivingGive, self.GetActDetailDataMsg)
end

function ActLotteryMain:OnEnable()
  base.OnEnable(self)
end

function ActLotteryMain:OnDisable()
  base.OnDisable(self)
end

function ActLotteryMain:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = tonumber(activityId)
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.activityDetailData = DataCenter.ActLotteryDataManager:GetActData(self.activityId)
  if self.activityDetailData == nil then
    return
  end
  self.activityTemp = DataCenter.ActLotteryDataManager:GetTempByActInfo(self.activityInfo)
  self.targetActId = self.activityTemp.thanksgiving_activity_id
  self.chooseHundredTimes = false
  self.isSkip = DataCenter.ActLotteryDataManager:GetIsSkip()
  self.canDrawClick = true
  self.canDrawClickTime = 0
  self.nextOpenTime = 0
  self.nextOpenDay = 0
  self.nextOpenTime, self.nextOpenDay = DataCenter.ActLotteryDataManager:GetNextOpenRewardTimeAndDayNum(self.activityId)
  self:RefreshView()
  self:TryRefreshBigRewardBtnAndWinner()
  self:CheckLotteryEndTime()
  SFSNetwork.SendMessage(MsgDefines.LottoInfo, self.activityId)
end

function ActLotteryMain:RefreshView()
  self.txt_act_name:SetLocalText(self.activityInfo.name)
  self:RefreshCenterContent()
  self:RefreshBottomBtnContent()
  self:RefreshSkipBtnContent()
  self:RefreshBeSendRewardContent()
  self:Update1000MS()
end

function ActLotteryMain:Update1000MS()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if self.activityDetailData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.activityInfo.endTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.txt_times:SetText(countDownTimeStr)
  if 0 < self.nextOpenTime and 0 < self.nextOpenDay and curTime > self.nextOpenTime * 1000 and DataCenter.ActLotteryDataManager:CanCheckOpenBigReward() then
    DataCenter.ActLotteryDataManager:SendOpenBigRewardMsg()
    SFSNetwork.SendMessage(MsgDefines.LottoOpen, self.activityId, self.nextOpenDay)
  end
  if self.curDayNumReal then
    if 0 >= self.curDayNumReal then
      self.btn_reward_txt:SetLocalText("thxgiv_Lottery_waiting")
    elseif self.nextOpenTimeReal == 0 then
      self.btn_reward_txt:SetText("")
    else
      local leftTime = self.nextOpenTimeReal - curTime
      if leftTime < 0 then
        leftTime = 0
      end
      local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
      self.btn_reward_txt:SetLocalText("thxgiv_Lottery_pre", countDownTimeStr)
    end
    if self.nextOpenTimeReal == 0 then
      self.next_open_content_time:SetLocalText("thxgiv_Lottery_LastEnd1")
    else
      local leftTime = self.nextOpenTimeReal - curTime
      if leftTime < 0 then
        leftTime = 0
      end
      local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
      self.next_open_content_time:SetLocalText("thxgiv_Lottery_nextRound", countDownTimeStr)
    end
  else
    self.btn_reward_txt:SetText("")
    self.next_open_content_time:SetText("")
  end
end

function ActLotteryMain:RefreshCenterContent()
  if not self.activityDetailData then
    return
  end
  if self.activityTemp == nil then
    return
  end
  local itemId = self.activityTemp.ticket
  local curNum = DataCenter.ItemData:GetItemCount(itemId)
  local iconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, itemId)
  self.empty_tip_content:SetActive(curNum <= 0)
  self.use_item_icon:LoadSprite(iconPath)
  if curNum <= 0 then
    self.item_cur_num:SetColorRGBA255(245, 109, 86, 255)
  else
    self.item_cur_num:SetColorRGBA255(253, 200, 57, 255)
  end
  self.item_cur_num:SetText("x" .. curNum)
  local iconName = self.activityTemp:GetIconNameByNum(curNum)
  self.item_rawimg:LoadSprite("Assets/Main/TextureEx/ActLottery/ThanksGiving/" .. iconName .. ".png")
  self.item_rawimg:SetNativeSize()
end

function ActLotteryMain:RefreshBottomBtnContent()
  if not self.activityDetailData then
    return
  end
  if self.activityTemp == nil then
    return
  end
  local itemId = self.activityTemp.ticket
  local curNum = DataCenter.ItemData:GetItemCount(itemId)
  local iconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, itemId)
  if curNum <= 0 then
    self.btn_get:SetActive(true)
    self.lottery_btn_content:SetActive(false)
  else
    self.btn_get:SetActive(false)
    self.lottery_btn_content:SetActive(true)
    self.lottery_change_btn:SetActive(curNum >= OneHundredTimes)
    self.text_cost1:SetText("x" .. OneTimes)
    self.text_cost2:SetText("x" .. (self.chooseHundredTimes and OneHundredTimes or TenTimes))
    self.img_cost_item1:LoadSprite(iconPath)
    self.img_cost_item2:LoadSprite(iconPath)
    self.text_btn1:SetText(Localization:GetString("thxgiv_Lottery_Open"))
    self.text_btn2:SetText(Localization:GetString(self.chooseHundredTimes and "thxgiv_Lottery_Open100" or "thxgiv_Lottery_Open10"))
  end
end

function ActLotteryMain:RefreshSkipBtnContent()
  if not self.activityDetailData then
    return
  end
  if self.activityTemp == nil then
    return
  end
  self.skip_btn_be_select:SetActive(self.isSkip > 0)
end

function ActLotteryMain:RefreshBeSendRewardContent()
  if not self.activityDetailData then
    return
  end
  if self.activityTemp == nil then
    return
  end
  self.btn_gift_giving_red_point:SetActive(#self.activityDetailData.reward > 0)
end

function ActLotteryMain:OnClickBtnInfo()
  if not self.activityDetailData then
    return
  end
  local param = {}
  param.activityRulesStr = Localization:GetString(self.activityInfo.story)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetail, {anim = true}, param)
end

function ActLotteryMain:OnClickNextOpenContent()
  if not self.activityDetailData then
    return
  end
  if self.nextOpenTimeReal == 0 then
    UIUtil.ShowTipsId("thxgiv_Lottery_LastEnd2")
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActLotteryWaitOpenRewardInfo, {anim = true}, self.activityId)
  end
end

function ActLotteryMain:OnClickBtnRecord()
  if not self.activityDetailData then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActLotterySelfInfo, {anim = true}, self.activityId)
end

function ActLotteryMain:OnClickBtnGiftGiving()
  if not self.activityDetailData then
    return
  end
  if #self.activityDetailData.reward > 0 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActLotteryBeSendRewardGet, {anim = true}, self.activityId)
  else
    UIUtil.ShowTipsId("thxgiv_Lottery_GiftEmpty")
  end
end

function ActLotteryMain:OnClickBtnReward()
  if not self.activityDetailData then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActLotteryBigRewardInfo, {anim = true}, self.activityId)
end

function ActLotteryMain:OnClickBtnSkip()
  if not self.activityDetailData then
    return
  end
  if self.isSkip <= 0 then
    self.isSkip = 1
  else
    self.isSkip = 0
  end
  DataCenter.ActLotteryDataManager:SetIsSkip(self.isSkip)
  self:RefreshSkipBtnContent()
end

function ActLotteryMain:OnClickBtnGet()
  if not self.activityDetailData then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActLotteryItemGetManual, {anim = true}, self.activityId)
end

function ActLotteryMain:OnClickBtnRecruitOne()
  if not self.activityDetailData then
    return
  end
  if not self.activityTemp then
    return
  end
  if not self.canDrawClick then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.canDrawClickTime then
    return
  end
  local itemId = self.activityTemp.ticket
  local curNum = DataCenter.ItemData:GetItemCount(itemId)
  if curNum >= OneTimes then
    self.canDrawClick = false
    self.canDrawClickTime = curTime + 2000
    SFSNetwork.SendMessage(MsgDefines.LottoDraw, self.activityId, ActLotteryDrawType.One)
  else
    self:TryOpenActGiftGivingRecommandView()
  end
end

function ActLotteryMain:OnClickBtnRecruitTen()
  if not self.activityDetailData then
    return
  end
  if not self.activityTemp then
    return
  end
  if not self.canDrawClick then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.canDrawClickTime then
    return
  end
  local itemId = self.activityTemp.ticket
  local curNum = DataCenter.ItemData:GetItemCount(itemId)
  local targetNum = self.chooseHundredTimes and OneHundredTimes or TenTimes
  local targetType = self.chooseHundredTimes and ActLotteryDrawType.Hundred or ActLotteryDrawType.Ten
  if curNum >= targetNum then
    self.canDrawClick = false
    self.canDrawClickTime = curTime + 2000
    SFSNetwork.SendMessage(MsgDefines.LottoDraw, self.activityId, targetType)
  else
    self:TryOpenActGiftGivingRecommandView()
  end
end

function ActLotteryMain:OnClickLotteryChangeBtn()
  if not self.activityDetailData then
    return
  end
  if not self.activityTemp then
    return
  end
  local itemId = self.activityTemp.ticket
  local curNum = DataCenter.ItemData:GetItemCount(itemId)
  if curNum < OneHundredTimes then
    return
  end
  if self.chooseHundredTimes then
    self.chooseHundredTimes = false
  else
    self.chooseHundredTimes = true
  end
  self:RefreshBottomBtnContent()
end

function ActLotteryMain:GetActDetailDataMsg()
  if not self.activityId then
    return
  end
  self:RefreshView()
end

function ActLotteryMain:GetBeSendRewardMsg()
  if not self.activityId then
    return
  end
  self:RefreshView()
end

function ActLotteryMain:GetDwarResultMsg(message)
  if not self.activityId then
    return
  end
  self.canDrawClick = true
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.canDrawClickTime = curTime + 1000
  self:RefreshView()
  local drawType = message.type
  if drawType == ActLotteryDrawType.One or drawType == ActLotteryDrawType.Ten then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.ActLotteryDrawResult) == false then
      UIManager:GetInstance():OpenWindow(UIWindowNames.ActLotteryDrawResult, {anim = false}, message)
    end
  elseif drawType == ActLotteryDrawType.Hundred and UIManager:GetInstance():IsWindowOpen(UIWindowNames.ActLotteryDraw100Result) == false then
    UIManager:GetInstance():OpenWindow(UIWindowNames.ActLotteryDraw100Result, {anim = false}, message)
  end
end

function ActLotteryMain:GetOpenRewardViewCloseMsg()
  if not self.activityId then
    return
  end
  self.nextOpenTime, self.nextOpenDay = DataCenter.ActLotteryDataManager:GetNextOpenRewardTimeAndDayNum(self.activityId)
  self:RefreshCenterContent()
  self:RefreshBottomBtnContent()
  self:RefreshSkipBtnContent()
  self:RefreshBeSendRewardContent()
  self:TryRefreshBigRewardBtnAndWinner()
  self:CheckLotteryEndTime()
end

function ActLotteryMain:CheckLotteryEndTime()
  local isInEndTime = self.nextOpenTimeReal == 0
  self.center_content:SetActive(not isInEndTime)
  self.bottom_content:SetActive(not isInEndTime)
  self.act_end_tip:SetActive(isInEndTime)
end

function ActLotteryMain:GetActLotteryTicketHistoryMsg()
  self:TryRefreshBigRewardBtnAndWinner(true)
end

function ActLotteryMain:TryRefreshBigRewardBtnAndWinner(notSendMsg)
  self:StopAnim()
  local rewardData = {
    rewardType = RewardType.GOODS,
    itemId = self.activityTemp.show_reward[1],
    itemNum = self.activityTemp.show_reward[2]
  }
  self.show_reward_item:ReInit(rewardData)
  self:RefreshRealNextOpenTime()
  local TicketHistory = self.activityDetailData:GetTicketHistory()
  local targetPlayerData
  for k, v in ipairs(TicketHistory) do
    if v.dayNum == self.curDayNumReal then
      targetPlayerData = v
      break
    end
  end
  if targetPlayerData then
    local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(targetPlayerData.headSkinId, targetPlayerData.headSkinET)
    self.u_i_player_head:SetHead(targetPlayerData.uid, targetPlayerData.pic, targetPlayerData.picver, nil, headBgImg)
    self.player_name:SetLocalText("thxgiv_Lottery_bigWinner")
    self.big_reward_player_canvas:SetAlpha(0)
    self.btn_reward_canvas:SetAlpha(1)
    self.seq = DOTween.Sequence()
    self.seq:AppendInterval(2)
    self.seq:Append(self.btn_reward_canvas.unity_canvas_group:DOFade(0, 0.35))
    self.seq:Append(self.big_reward_player_canvas.unity_canvas_group:DOFade(1, 0.15))
    self.seq:AppendInterval(2)
    self.seq:Append(self.big_reward_player_canvas.unity_canvas_group:DOFade(0, 0.35))
    self.seq:Append(self.btn_reward_canvas.unity_canvas_group:DOFade(1, 0.15))
    self.seq:SetLoops(-1)
    self.seq:Play()
  else
    self.big_reward_player_canvas:SetAlpha(0)
    self.btn_reward_canvas:SetAlpha(1)
  end
  if targetPlayerData == nil and self.curDayNumReal > 0 and notSendMsg ~= true and self.activityDetailData:CheckNeedReqTicketHistory() then
    SFSNetwork.SendMessage(MsgDefines.LottoTicketHistory, self.activityId)
  end
end

function ActLotteryMain:StopAnim()
  if self.seq then
    self.seq:Kill()
    self.seq = nil
  end
end

function ActLotteryMain:RefreshRealNextOpenTime()
  self.curDayNumReal, self.nextOpenTimeReal = DataCenter.ActLotteryDataManager:GetRealBigRewardTimeData(self.activityId)
end

function ActLotteryMain:TryOpenActGiftGivingRecommandView()
  local targetActId = self.targetActId
  if targetActId == nil or targetActId == 0 then
    return
  end
  local activityDetailData = DataCenter.ActGiftGivingDataManager:GetActData(targetActId)
  if activityDetailData == nil then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActGiftGivingSelectMember, {anim = true}, targetActId)
  if activityDetailData:CheckIsGivePlayersDataExpired() then
    SFSNetwork.SendMessage(MsgDefines.ThanksgivingRecommend, targetActId)
  end
end

return ActLotteryMain
