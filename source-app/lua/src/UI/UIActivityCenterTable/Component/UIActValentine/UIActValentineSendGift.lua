local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local ResourceManager = CS.GameEntry.Resource
local UIActValentineSendGift = BaseClass("UIActValentineSendGift", base)
local UIActValentineSendGiftRankShowItem = require("UI.UIActivityCenterTable.Component.UIActValentine.Component.UIActValentineSendGiftRankShowItem")
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local txt_act_name_path = "Root/rect/TopArea/BaseInfo/Txt_ActName"
local remain_time_text_path = "Root/rect/TopArea/BaseInfo/RemainTimeContent/RemainTimeText"
local intro_btn_path = "Root/rect/TopArea/BaseInfo/IntroBtn"
local make_gift_btn_path = "Root/Scene/Viewport/Content/MakeGiftBtn"
local send_gift_btn_path = "Root/Scene/Viewport/Content/SendGiftBtn"
local u_i_common_res_item_path = "Root/rect/BottomArea/MakeGiftArea/UICommonResItem"
local mat_num_text_path = "Root/rect/BottomArea/MakeGiftArea/MatNumText"
local make_gift_confirm_btn_path = "Root/rect/BottomArea/MakeGiftArea/MakeGiftConfirmBtn"
local back_btn_path = "Root/rect/BottomArea/MakeGiftArea/BackBtn"
local no1_path = "Root/Scene/Viewport/node_head/No1"
local no2_path = "Root/Scene/Viewport/node_head/No2"
local no3_path = "Root/Scene/Viewport/node_head/No3"
local reward_btn_path = "Root/rect/TopArea/RewardBtn"
local record_btn_path = "Root/rect/TopArea/RecordBtn"
local select_btn_path = "Root/rect/BottomArea/SendGiftWhenLike/SelectBtn"
local auto_btn_be_select_path = "Root/rect/BottomArea/SendGiftWhenLike/SelectBtn/autoBtnBeSelect"
local show_res_item_path = "Root/rect/TopArea/RewardBtn/TipInfo/ShowResItem"
local remain_drop_text_path = "Root/rect/BottomArea/MakeGiftArea/RemainDropText"
local remain_drop_text_tip_btn_path = "Root/rect/BottomArea/MakeGiftArea/RemainDropText/RemainDropTextTipBtn"
local make_gift_red1_path = "Root/Scene/Viewport/Content/MakeGiftBtn/LW_Btn_Common_New_Base/MakeGiftRed1"
local make_gift_red2_path = "Root/rect/BottomArea/MakeGiftArea/MakeGiftConfirmBtn/MakeGiftRed2"
local no_receive_chocolate_select_btn_path = "Root/rect/BottomArea/NoReceiveChocolate/NoReceiveChocolateSelectBtn"
local no_receive_chocolate_check_path = "Root/rect/BottomArea/NoReceiveChocolate/NoReceiveChocolateSelectBtn/NoReceiveChocolateCheck"
local follow_btn_path = "Root/rect/TopArea/FollowBtn"
local follow_node_path = "Root/rect/TopArea/FollowBtn/FollowNode"
local follow_btn_red_dot_path = "Root/rect/TopArea/FollowBtn/FollowBtnRedDot"
local not_new_follow_image_path = "Root/rect/TopArea/FollowBtn/NotNewFollowImage"
local ViewState = {
  EnterAni = 1,
  TableView = 2,
  TableToMachineAni = 3,
  MachineView = 4,
  MachineMakeAni = 5,
  MachineToTableViewAni = 6,
  WaitingMakeMsgBack = 7
}
local EnterAniName = "V_ui_UIActValentineSendGiftMain_in"
local TableToMachineAniName = "V_ui_UIActValentineSendGiftMain_to_machine"
local MachineMakeAniName = "V_ui_UIActValentineSendGiftMain_make"
local MachineToTableViewAniName = "V_ui_UIActValentineSendGiftMain_to_table"
local WaitingMakeMsgBackTime = 5000

function UIActValentineSendGift:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIActValentineSendGift:OnDestroy()
  self:TryForcePlaySaveMsgReward()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActValentineSendGift:OnEnable()
  base.OnEnable(self)
end

function UIActValentineSendGift:OnDisable()
  self:TryForcePlaySaveMsgReward()
  base.OnDisable(self)
  if self.showMachineSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.showMachineSoundHandle)
    self.showMachineSoundHandle = nil
  end
  if self.makeGiftSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.makeGiftSoundHandle)
    self.makeGiftSoundHandle = nil
  end
end

function UIActValentineSendGift:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ValentineSendGiftMakeGift, self.GetMakeGiftMsg)
  self:AddUIListener(EventId.ValentineSendGiftRankData, self.RefreshRankContent)
  self:AddUIListener(EventId.OnThumbUpSuccess, self.OnLikeSuccess)
  self:AddUIListener(EventId.RefreshItems, self.RefreshMakeGiftRedState)
  self:AddUIListener(EventId.ActLimitedTimeFeastDataUpdate, self.RefreshMakGiftContent)
  self:AddUIListener(EventId.ValentineSendActRecInfo, self.RefreshFollowBtnContent)
  self:AddUIListener(EventId.END_SEARCH, self.FindMonsterEnd)
  self:AddUIListener(EventId.SearchMonsterFailed, self.OnSearchFailed)
end

function UIActValentineSendGift:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ValentineSendGiftMakeGift, self.GetMakeGiftMsg)
  self:RemoveUIListener(EventId.ValentineSendGiftRankData, self.RefreshRankContent)
  self:RemoveUIListener(EventId.OnThumbUpSuccess, self.OnLikeSuccess)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshMakeGiftRedState)
  self:RemoveUIListener(EventId.ActLimitedTimeFeastDataUpdate, self.RefreshMakGiftContent)
  self:RemoveUIListener(EventId.ValentineSendActRecInfo, self.RefreshFollowBtnContent)
  self:RemoveUIListener(EventId.END_SEARCH, self.FindMonsterEnd)
  self:RemoveUIListener(EventId.SearchMonsterFailed, self.OnSearchFailed)
end

function UIActValentineSendGift:FindMonsterEnd(param)
  local worldPosition = SceneUtils.TileIndexToWorld(param.pointId)
  WorldArrowManager:GetInstance():ShowArrowEffect(param.uuid, worldPosition, ArrowType.Monster)
  GoToUtil.GotoWorldPos(worldPosition, CS.SceneManager.World.InitZoom)
  GoToUtil.CloseAllWindows()
end

function UIActValentineSendGift:OnSearchFailed()
  UIUtil.ShowTipsId("target_not_found_tips")
end

function UIActValentineSendGift:ComponentDefine()
  self.rootAnim = self:AddComponent(UIAnimator, "")
  self.txt_act_name = self:AddComponent(UIText, txt_act_name_path)
  self.txt_times = self:AddComponent(UIText, remain_time_text_path)
  self.infoBtn = self:AddComponent(UIButton, intro_btn_path)
  self.infoBtn:SetOnClick(function()
    self:OnIntroClick()
  end)
  self.makeGiftBtn = self:AddComponent(UIButton, make_gift_btn_path)
  self.makeGiftBtn:SetOnClick(function()
    self:OnClickMakeGiftBtn()
  end)
  self.sendGiftBtn = self:AddComponent(UIButton, send_gift_btn_path)
  self.sendGiftBtn:SetOnClick(function()
    self:OnClickSendGiftBtn()
  end)
  self.u_i_common_res_item = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.mat_num_text = self:AddComponent(UITextMeshProUGUIEx, mat_num_text_path)
  self.make_gift_confirm_btn = self:AddComponent(UIButton, make_gift_confirm_btn_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.make_gift_confirm_btn:SetOnClick(function()
    self:OnClickMakeGiftConfirmBtn()
  end)
  self.show_res_item = self:AddComponent(UICommonResItem, show_res_item_path)
  self.back_btn:SetOnClick(function()
    self:OnClickBackBtn()
  end)
  self.no1 = self:AddComponent(UIActValentineSendGiftRankShowItem, no1_path)
  self.no2 = self:AddComponent(UIActValentineSendGiftRankShowItem, no2_path)
  self.no3 = self:AddComponent(UIActValentineSendGiftRankShowItem, no3_path)
  self.rankNoList = {
    self.no1,
    self.no2,
    self.no3
  }
  self.reward_btn = self:AddComponent(UIButton, reward_btn_path)
  self.record_btn = self:AddComponent(UIButton, record_btn_path)
  self.reward_btn:SetOnClick(function()
    self:OnClickRewardBtn()
  end)
  self.record_btn:SetOnClick(function()
    self:OnClickRecordBtn()
  end)
  self.select_btn = self:AddComponent(UIButton, select_btn_path)
  self.auto_btn_be_select = self:AddComponent(UIImage, auto_btn_be_select_path)
  self.select_btn:SetOnClick(function()
    self:OnClickSelectBtn()
  end)
  self.dropInfoText = self:AddComponent(UIText, remain_drop_text_path)
  self.dropInfoTipBtn = self:AddComponent(UIButton, remain_drop_text_tip_btn_path)
  self.dropInfoTipBtn:SetOnClick(function()
    self:DropInfoTipBtnClick()
  end)
  self.makeGiftRed1 = self:AddComponent(UIBaseContainer, make_gift_red1_path)
  self.makeGiftRed2 = self:AddComponent(UIBaseContainer, make_gift_red2_path)
  self.noChocolateMessageBtn = self:AddComponent(UIButton, no_receive_chocolate_select_btn_path)
  self.noChocolateMessageCheck = self:AddComponent(UIImage, no_receive_chocolate_check_path)
  self.noChocolateMessageBtn:SetOnClick(function()
    self:OnClickNoGiftMessageBtn()
  end)
  self.follow_btn = self:AddComponent(UIButton, follow_btn_path)
  self.followNode = self:AddComponent(UIImage, follow_node_path)
  self.not_new_follow_image = self:AddComponent(UIImage, not_new_follow_image_path)
  self.follow_btn_red_dot = self:AddComponent(UIBaseContainer, follow_btn_red_dot_path)
  self.follow_btn:SetOnClick(function()
    self:OnClickFollowBtn()
  end)
  self.follow_btn:SetActive(false)
end

function UIActValentineSendGift:ComponentDestroy()
  self.rootAnim = nil
  self.u_i_common_res_item = nil
  self.mat_num_text = nil
  self.make_gift_confirm_btn = nil
  self.back_btn = nil
  self.no1 = nil
  self.no2 = nil
  self.no3 = nil
  self.rankNoList = nil
  self.reward_btn = nil
  self.record_btn = nil
  self.select_btn = nil
  self.auto_btn_be_select = nil
  self.show_res_item = nil
  self.noChocolateMessageBtn = nil
  self.noChocolateMessageCheck = nil
  self.follow_btn = nil
  self.followNode = nil
  self.not_new_follow_image = nil
end

function UIActValentineSendGift:SetData(activityId)
  base.SetData(self, activityId)
  self.viewState = ViewState.EnterAni
  self.viewStateExpiredTime = 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local success, aniTime = self.rootAnim:PlayAnimationReturnTime(EnterAniName)
  if success then
    self.viewStateExpiredTime = curTime + aniTime * 1000
  end
  self.activityId = tonumber(activityId)
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.actTemp = DataCenter.ValentineDataManager:GetActSendTempByActId(self.activityId)
  if self.actTemp == nil then
    return
  end
  self:ParseData()
  self:RefreshView()
  self.txt_act_name:SetLocalText(self.activityInfo.name)
  self:TrySendRankMsg()
  self:TrySendActInfo()
  self:RefreshRankContent()
  self:Update1000MS()
  local packingParams = {
    activityId = self.activityId,
    isShowItemTopBar = false
  }
  EventManager:GetInstance():Broadcast(EventId.ActivityCommonGroupView_FestivalPackagingModify, packingParams)
end

function UIActValentineSendGift:ParseData()
  self.costId = self.actTemp.res_good[1] or 0
  self.costNum = self.actTemp.res_good[2] or 1
  self.getId = self.actTemp.gift_good[1] or 0
  self.getNum = self.actTemp.gift_good[2] or 1
end

function UIActValentineSendGift:RefreshView()
  self:RefreshTopContent()
  self:RefreshMakGiftContent()
  self:RefreshAutoSendContent()
  self:RefreshMakeGiftRedState()
  self:RefreshNoGiftMessageContent()
end

function UIActValentineSendGift:RefreshMakGiftContent()
  local curNum = DataCenter.ItemData:GetItemCount(self.costId)
  local param = {
    rewardType = RewardType.GOODS,
    itemId = self.costId
  }
  self.u_i_common_res_item:ReInit(param)
  local showStr = "%s/%s"
  if curNum < self.costNum then
    showStr = "<color=#F97077>%s</color>/%s"
  end
  self.mat_num_text:SetText(string.format(showStr, curNum, self.costNum))
  self.activityDropId = 0
  local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.LimitedTimeFeast.Type)
  for i, v in ipairs(dataList) do
    local para_2 = v.para_2
    local para_2_num = tonumber(para_2) or 0
    if para_2_num == self.costId then
      self.activityDropId = tonumber(v.id) or 0
      break
    end
  end
  if self.activityDropId > 0 then
    local cur, max = DataCenter.ActLimitedTimeFeastData:GetCurAndMax(tonumber(self.activityDropId))
    self.dropInfoText:SetLocalText("activity_99136_28_desc_new", cur, max)
  end
end

function UIActValentineSendGift:RefreshTopContent()
  local showItemId = self.actTemp.bubble_good
  if 0 < showItemId then
    local param = {
      rewardType = RewardType.GOODS,
      itemId = showItemId
    }
    self.show_res_item:ReInit(param)
  end
end

function UIActValentineSendGift:GetMakeGiftMsg(t)
  self:RefreshMakGiftContent()
  if self.viewState == ViewState.WaitingMakeMsgBack or self.viewState == ViewState.MachineView then
    self.curMakingMsg = t
    self.viewState = ViewState.MachineMakeAni
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local success, aniTime = self.rootAnim:PlayAnimationReturnTime(MachineMakeAniName)
    if success then
      self.viewStateExpiredTime = curTime + aniTime * 1000
      if self.makeGiftSoundHandle then
        DataCenter.LWSoundManager:StopSound(self.makeGiftSoundHandle)
        self.makeGiftSoundHandle = nil
      end
      self.makeGiftSoundHandle = DataCenter.LWSoundManager:PlaySound(202638, false)
    end
  else
    DataCenter.RewardManager:ShowCommonReward(t)
  end
end

function UIActValentineSendGift:Update1000MS()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.activityInfo.endTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.txt_times:SetText(countDownTimeStr)
end

function UIActValentineSendGift:Update100MS()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if self.actTemp == nil then
    return
  end
  if self.viewStateExpiredTime <= 0 then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.viewStateExpiredTime then
    self:TryUpdateViewState()
  end
end

function UIActValentineSendGift:TryUpdateViewState()
  if self.viewState == ViewState.EnterAni then
    self.viewState = ViewState.TableView
    self.viewStateExpiredTime = 0
  elseif self.viewState == ViewState.TableToMachineAni then
    self.viewState = ViewState.MachineView
    self.viewStateExpiredTime = 0
  elseif self.viewState == ViewState.MachineMakeAni then
    self.viewState = ViewState.MachineView
    self.viewStateExpiredTime = 0
    self:TryForcePlaySaveMsgReward()
  elseif self.viewState == ViewState.MachineToTableViewAni then
    self.viewState = ViewState.TableView
    self.viewStateExpiredTime = 0
  elseif self.viewState == ViewState.WaitingMakeMsgBack then
    self.viewState = ViewState.MachineView
    self.viewStateExpiredTime = 0
  end
end

function UIActValentineSendGift:OnIntroClick()
  if self.activityInfo and not string.IsNullOrEmpty(self.activityInfo.story) then
    UIUtil.ShowIntro(Localization:GetString("302027"), Localization:GetString("2800015"), Localization:GetString(self.activityInfo.story))
  end
end

function UIActValentineSendGift:OnClickMakeGiftBtn()
  if self.activityId == nil then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if self.actTemp == nil then
    return
  end
  if self.viewState ~= ViewState.TableView then
    return
  end
  self.viewState = ViewState.TableToMachineAni
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local success, aniTime = self.rootAnim:PlayAnimationReturnTime(TableToMachineAniName)
  if success then
    self.viewStateExpiredTime = curTime + aniTime * 1000
    if self.showMachineSoundHandle then
      DataCenter.LWSoundManager:StopSound(self.showMachineSoundHandle)
      self.showMachineSoundHandle = nil
    end
    self.showMachineSoundHandle = DataCenter.LWSoundManager:PlaySound(202639, false)
  end
end

function UIActValentineSendGift:OnClickMakeGiftConfirmBtn()
  if self.activityId == nil then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if self.actTemp == nil then
    return
  end
  if self.viewState ~= ViewState.MachineView then
    return
  end
  local curNum = DataCenter.ItemData:GetItemCount(self.costId)
  local needNum = self.costNum
  if curNum < needNum then
    if self.activityDropId > 0 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActDropPopupPanel, {anim = true}, self.activityDropId)
    end
  else
    local productNum = math.floor(curNum / needNum)
    SFSNetwork.SendMessage(MsgDefines.ValentineSendMerge, self.activityId, productNum)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self.viewState = ViewState.WaitingMakeMsgBack
    self.viewStateExpiredTime = curTime + WaitingMakeMsgBackTime
  end
end

function UIActValentineSendGift:OnClickBackBtn()
  if self.activityId == nil then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if self.actTemp == nil then
    return
  end
  if self.viewState ~= ViewState.MachineView then
    return
  end
  self.viewState = ViewState.MachineToTableViewAni
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local success, aniTime = self.rootAnim:PlayAnimationReturnTime(MachineToTableViewAniName)
  if success then
    self.viewStateExpiredTime = curTime + aniTime * 1000
  end
end

function UIActValentineSendGift:OnClickSendGiftBtn()
  if CoppaUtil.IsCoppaLimitWithTips() then
    return
  end
  local param = {}
  param.activityId = self.activityId
  UIManager:GetInstance():OpenWindow(UIWindowNames.ValentineSendGiftList, {anim = true}, param)
end

function UIActValentineSendGift:TryForcePlaySaveMsgReward()
  if self.curMakingMsg then
    DataCenter.RewardManager:ShowCommonReward(self.curMakingMsg)
    self.curMakingMsg = nil
  end
end

function UIActValentineSendGift:TrySendRankMsg()
  if self.activityId == nil then
    return
  end
  local isNeed = DataCenter.ValentineDataManager:CheckActSendRankDataNeedRefresh(self.activityId)
  if isNeed then
    SFSNetwork.SendMessage(MsgDefines.ValentineSendGiftRank, self.activityId)
  end
end

function UIActValentineSendGift:RefreshRankContent()
  if self.activityId == nil then
    return
  end
  local rankData = DataCenter.ValentineDataManager:GetActSendRankData(self.activityId)
  if rankData == nil or rankData.rankArr == nil then
    for i, v in ipairs(self.rankNoList) do
      v:SetActive(false)
    end
  else
    for i, v in ipairs(self.rankNoList) do
      local rankData = rankData.rankArr[i]
      if rankData then
        v:SetActive(true)
        v:SetData(rankData)
      else
        v:SetActive(false)
      end
    end
  end
end

function UIActValentineSendGift:OnClickRewardBtn()
  if self.activityId == nil then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if self.actTemp == nil then
    return
  end
  if self.viewState ~= ViewState.TableView and self.viewState ~= ViewState.MachineView then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.ValentineSendGiftRank, {anim = true}, self.activityId)
end

function UIActValentineSendGift:OnClickRecordBtn()
  if self.activityId == nil then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if self.actTemp == nil then
    return
  end
  if self.viewState ~= ViewState.TableView and self.viewState ~= ViewState.MachineView then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.ValentineSendGiftRecord, {anim = true}, self.activityId)
end

function UIActValentineSendGift:RefreshAutoSendContent()
  local isAutoSend = DataCenter.ValentineDataManager:GetIsAutoSend(self.activityId)
  self.auto_btn_be_select:SetActive(isAutoSend)
end

function UIActValentineSendGift:OnClickSelectBtn()
  if self.activityId == nil then
    return
  end
  local isAutoSend = DataCenter.ValentineDataManager:GetIsAutoSend(self.activityId)
  DataCenter.ValentineDataManager:SetIsAutoSend(self.activityId, not isAutoSend)
  self:RefreshAutoSendContent()
end

function UIActValentineSendGift:OnLikeSuccess()
  UIUtil.ShowTipsId("multiply_door_tips_012")
end

function UIActValentineSendGift:DropInfoTipBtnClick()
  if not self.activityDropId or self.activityDropId <= 0 then
    return
  end
  local dayNum = 0
  local getParaTab = DataCenter.ActLimitedTimeFeastData:GetActDropLimitData(tonumber(self.activityDropId))
  local getPara1 = 0
  local getPara2 = 0
  for k, v in pairs(getParaTab) do
    getPara1 = k
    getPara2 = v
    break
  end
  if 0 < getPara1 then
    dayNum = getPara2
  end
  UIUtil.ShowBubbleTips(Localization:GetString("activity_99136_29", dayNum), self.dropInfoTipBtn.transform.position, 0, -20, 0)
end

function UIActValentineSendGift:RefreshMakeGiftRedState()
  local isShowRed = DataCenter.ValentineDataManager:GetSendGiftActRed(self.activityId)
  self.makeGiftRed1:SetActive(0 < isShowRed)
  self.makeGiftRed2:SetActive(0 < isShowRed)
end

function UIActValentineSendGift:OnClickNoGiftMessageBtn()
  if self.activityId == nil then
    return
  end
  local isNoGiftMessage = DataCenter.ValentineDataManager:GetIsNoGiftMessage(self.activityId)
  DataCenter.ValentineDataManager:SetIsNoGiftMessage(self.activityId, not isNoGiftMessage)
  self:RefreshNoGiftMessageContent()
end

function UIActValentineSendGift:RefreshNoGiftMessageContent()
  local isNoGiftMessage = DataCenter.ValentineDataManager:GetIsNoGiftMessage(self.activityId)
  self.noChocolateMessageCheck:SetActive(isNoGiftMessage)
end

function UIActValentineSendGift:TrySendActInfo()
  if self.activityId == nil then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ValentineSendActivityInfo, self.activityId, ValentineRequestNewFollowType.SendGiftMain)
end

function UIActValentineSendGift:OnClickFollowBtn()
  local showTips = DataCenter.ValentineDataManager:GetIfShowMatchTips(self.activityId)
  if not showTips then
    UIUtil.ShowMessage(Localization:GetString("Valentine_send_bp_rule_13"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      DataCenter.ValentineDataManager:SetShowMatchTips(self.activityId, true)
      self:OpenMatchAndFollowView()
    end, nil, nil, nil, nil, nil, nil, nil, nil, nil, CS.UnityEngine.TextAnchor.MiddleLeft)
  else
    self:OpenMatchAndFollowView()
  end
end

function UIActValentineSendGift:OpenMatchAndFollowView()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActValentineMatchSuccessList, {anim = true}, self.activityId)
  local newMutualFollow = DataCenter.ValentineDataManager:GetNewMutualFollow(self.activityId)
  if newMutualFollow and 0 < newMutualFollow then
    local param = {}
    param.activityId = self.activityId
    param.needRequest = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActValentineMatch, {anim = true}, param)
  end
end

function UIActValentineSendGift:RefreshFollowBtnContent()
  if not self.activityId then
    return
  end
  local showFollowBtn = DataCenter.ValentineDataManager:GetIfOpenMatch()
  self.follow_btn:SetActive(showFollowBtn)
  if not showFollowBtn then
    return
  end
  local newMutualFollow = DataCenter.ValentineDataManager:GetNewMutualFollow(self.activityId)
  if newMutualFollow and 0 < newMutualFollow then
    self:ShowNewFollowBtn()
  else
    self:HideNewFollowBtn()
  end
end

function UIActValentineSendGift:ShowNewFollowBtn()
  self.follow_btn_red_dot:SetActive(true)
  self.followNode:SetActive(true)
end

function UIActValentineSendGift:HideNewFollowBtn()
  self.follow_btn_red_dot:SetActive(false)
  self.followNode:SetActive(false)
end

return UIActValentineSendGift
