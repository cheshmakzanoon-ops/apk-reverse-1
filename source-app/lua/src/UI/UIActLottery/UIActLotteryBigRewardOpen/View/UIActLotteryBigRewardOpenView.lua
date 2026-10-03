local UIActLotteryBigRewardOpenView = BaseClass("UIActLotteryBigRewardOpenView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local ViewState = {
  None = 0,
  PreAni1 = 1,
  PreAniWaitBtn = 2,
  PreAni2 = 3,
  Result = 4,
  ResultAni = 5
}
local big_reward_num_path = "resultContent/UIActLotteryBigRewardOpen/resultContent/ManualContent/Common_bg/ManualScroll/Viewport/ManualLayout/bigRewardContent/bigRewardNum"
local get_first_reward_content_path = "resultContent/UIActLotteryBigRewardOpen/resultContent/ManualContent/Common_bg/ManualScroll/Viewport/ManualLayout/GetFirstRewardContent"
local get_res_item_path = "resultContent/UIActLotteryBigRewardOpen/resultContent/ManualContent/Common_bg/ManualScroll/Viewport/ManualLayout/GetFirstRewardContent/GetFirstRewardExchange/GetResItem"
local use_item_num_path = "resultContent/UIActLotteryBigRewardOpen/resultContent/ManualContent/Common_bg/ManualScroll/Viewport/ManualLayout/GetFirstRewardContent/GetFirstRewardExchange/useItemImg/useItemNum"
local get_other_reward_content_path = "resultContent/UIActLotteryBigRewardOpen/resultContent/ManualContent/Common_bg/ManualScroll/Viewport/ManualLayout/GetOtherRewardContent"
local get_other_reward_exchange_path = "resultContent/UIActLotteryBigRewardOpen/resultContent/ManualContent/Common_bg/ManualScroll/Viewport/ManualLayout/GetOtherRewardContent/GetOtherRewardExchange"
local use_item1_img_path = "resultContent/UIActLotteryBigRewardOpen/resultContent/ManualContent/Common_bg/ManualScroll/Viewport/ManualLayout/GetOtherRewardContent/GetOtherRewardExchange/OtherUseItemContent/useItem1Img"
local use_item1_num_path = "resultContent/UIActLotteryBigRewardOpen/resultContent/ManualContent/Common_bg/ManualScroll/Viewport/ManualLayout/GetOtherRewardContent/GetOtherRewardExchange/OtherUseItemContent/useItem1Img/useItem1Num"
local use_item2_img_path = "resultContent/UIActLotteryBigRewardOpen/resultContent/ManualContent/Common_bg/ManualScroll/Viewport/ManualLayout/GetOtherRewardContent/GetOtherRewardExchange/OtherUseItemContent/useItem2Img"
local use_item2_num_path = "resultContent/UIActLotteryBigRewardOpen/resultContent/ManualContent/Common_bg/ManualScroll/Viewport/ManualLayout/GetOtherRewardContent/GetOtherRewardExchange/OtherUseItemContent/useItem2Img/useItem2Num"
local pre_open_content_path = "preOpenContent"
local use_item0_img_path = "resultContent/UIActLotteryBigRewardOpen/resultContent/ManualContent/Common_bg/ManualScroll/Viewport/ManualLayout/GetOtherRewardContent/GetOtherRewardExchange/OtherUseItemContent/useItem0Img"
local use_item0_num_path = "resultContent/UIActLotteryBigRewardOpen/resultContent/ManualContent/Common_bg/ManualScroll/Viewport/ManualLayout/GetOtherRewardContent/GetOtherRewardExchange/OtherUseItemContent/useItem0Img/useItem0Num"
local open_btn_path = "preOpenContent/Root/MachineContent/openBtn"
local result_content_path = "resultContent"
local u_i_common_res_item_path = "resultContent/UIActLotteryBigRewardOpen/resultContent/ManualContent/Common_bg/ManualScroll/Viewport/ManualLayout/GetOtherRewardContent/GetOtherRewardExchange/UICommonResItem"
local reward_content_path = "resultContent/UIActLotteryBigRewardOpen/resultContent/ManualContent/Common_bg/ManualScroll/Viewport/ManualLayout/GetOtherRewardContent/GetOtherRewardExchange/rewardContent"
local big_reward_title_path = "resultContent/UIActLotteryBigRewardOpen/resultContent/ManualContent/Common_bg/ManualScroll/Viewport/ManualLayout/bigRewardContent/bigRewardTitle"
local get_first_reward_tip_path = "resultContent/UIActLotteryBigRewardOpen/resultContent/ManualContent/Common_bg/ManualScroll/Viewport/ManualLayout/GetFirstRewardContent/GetFirstRewardTip"
local get_first_reward_exchange_path = "resultContent/UIActLotteryBigRewardOpen/resultContent/ManualContent/Common_bg/ManualScroll/Viewport/ManualLayout/GetFirstRewardContent/GetFirstRewardExchange"
local get_reward_tip2_path = "resultContent/UIActLotteryBigRewardOpen/resultContent/ManualContent/Common_bg/ManualScroll/Viewport/ManualLayout/GetOtherRewardContent/GetOtherRewardExchange/GetRewardTip2"
local empty_trick_content_path = "resultContent/UIActLotteryBigRewardOpen/resultContent/ManualContent/Common_bg/ManualScroll/Viewport/ManualLayout/EmptyTrickContent"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self.curState = ViewState.None
  self.nextStateTime = 0
  self:RefreshView()
end

local function OnDestroy(self)
  self:ClearAllItem()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.textTitle = self:AddComponent(UIText, "resultContent/UIActLotteryBigRewardOpen/resultContent/Common_bg_orange/Common_img_title/titleText")
  self.btnClose = self:AddComponent(UIButton, "resultContent/UIActLotteryBigRewardOpen/resultContent/Common_bg_orange/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:CloseBtnClick()
  end)
  self.btnMask = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnMask:SetOnClick(function()
    self:CloseBtnClick()
  end)
  self.big_reward_num = self:AddComponent(UITextMeshProUGUIEx, big_reward_num_path)
  self.get_first_reward_content = self:AddComponent(UIBaseContainer, get_first_reward_content_path)
  self.get_res_item = self:AddComponent(UICommonResItem, get_res_item_path)
  self.use_item_num = self:AddComponent(UITextMeshProUGUIEx, use_item_num_path)
  self.get_other_reward_content = self:AddComponent(UIBaseContainer, get_other_reward_content_path)
  self.get_other_reward_exchange = self:AddComponent(UIBaseContainer, get_other_reward_exchange_path)
  self.use_item1_img = self:AddComponent(UIRawImage, use_item1_img_path)
  self.use_item1_num = self:AddComponent(UITextMeshProUGUIEx, use_item1_num_path)
  self.use_item2_img = self:AddComponent(UIRawImage, use_item2_img_path)
  self.use_item2_num = self:AddComponent(UITextMeshProUGUIEx, use_item2_num_path)
  self.pre_open_content = self:AddComponent(UIAnimator, pre_open_content_path)
  self.open_btn = self:AddComponent(UIButton, open_btn_path)
  self.result_content = self:AddComponent(UIAnimator, result_content_path)
  self.open_btn:SetOnClick(function()
    self:OpenBtnClick()
  end)
  self.u_i_common_res_item = self:AddComponent(UICanvasGroup, u_i_common_res_item_path)
  self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.u_i_common_res_item:SetActive(false)
  self.u_i_common_res_item.gameObject:GameObjectCreatePool()
  self.u_i_common_res_item_list = {}
  self.big_reward_title = self:AddComponent(UITextMeshProUGUIEx, big_reward_title_path)
  self.get_first_reward_tip = self:AddComponent(UITextMeshProUGUIEx, get_first_reward_tip_path)
  self.get_first_reward_exchange = self:AddComponent(UIBaseContainer, get_first_reward_exchange_path)
  self.get_reward_tip2 = self:AddComponent(UITextMeshProUGUIEx, get_reward_tip2_path)
  self.empty_trick_content = self:AddComponent(UIBaseContainer, empty_trick_content_path)
  self.use_item0_img = self:AddComponent(UIRawImage, use_item0_img_path)
  self.use_item0_num = self:AddComponent(UITextMeshProUGUIEx, use_item0_num_path)
end

local function ComponentDestroy(self)
  self.big_reward_num = nil
  self.get_first_reward_content = nil
  self.get_res_item = nil
  self.use_item_num = nil
  self.get_other_reward_content = nil
  self.get_other_reward_exchange = nil
  self.use_item1_img = nil
  self.use_item1_num = nil
  self.use_item2_img = nil
  self.use_item2_num = nil
  self.reward_content = nil
  self.pre_open_content = nil
  self.open_btn = nil
  self.result_content = nil
  self.u_i_common_res_item = nil
  self.reward_content = nil
  self.big_reward_title = nil
  self.get_first_reward_tip = nil
  self.get_reward_tip2 = nil
  self.empty_trick_content = nil
  self.use_item0_img = nil
  self.use_item0_num = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function RefreshView(self)
  self.message = self:GetUserData()
  self.activityId = self.message.activityId
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
  self.targetActivityTemp = DataCenter.ActGiftGivingDataManager:GetTempByActId(self.targetActId)
  if self.targetActivityTemp == nil then
    return
  end
  self.targetItemId = self.targetActivityTemp.give_item
  local firstTickerNum = self.message.firstTickerNum
  local secondNum = self.message.secondNum
  local commonNum = self.message.commonNum
  if firstTickerNum and 0 < firstTickerNum then
    self.get_first_reward_exchange:SetActive(true)
    self.get_first_reward_tip:SetLocalText("thxgiv_Lottery_text_7")
    self.use_item_num:SetText("x" .. firstTickerNum)
    local param = {
      rewardType = RewardType.GOODS,
      itemId = self.targetItemId,
      count = firstTickerNum
    }
    self.get_res_item:ReInit(param)
  else
    self.get_first_reward_tip:SetLocalText("thxgiv_Lottery_text_9")
    self.get_first_reward_exchange:SetActive(false)
  end
  if firstTickerNum and 0 < firstTickerNum then
    self.use_item0_img:SetActive(true)
    self.use_item0_num:SetText("x" .. firstTickerNum)
  else
    self.use_item0_img:SetActive(false)
  end
  if secondNum and 0 < secondNum then
    self.use_item1_img:SetActive(true)
    self.use_item1_num:SetText("x" .. secondNum)
  else
    self.use_item1_img:SetActive(false)
  end
  if commonNum and 0 < commonNum then
    self.use_item2_img:SetActive(true)
    self.use_item2_num:SetText("x" .. commonNum)
  else
    self.use_item2_img:SetActive(false)
  end
  local isHaveShow = firstTickerNum and 0 < firstTickerNum or secondNum and 0 < secondNum or commonNum and 0 < commonNum
  self.get_other_reward_content:SetActive(isHaveShow)
  self.get_reward_tip2:SetText(LuaEntry.Player.name)
  if isHaveShow then
    self.get_first_reward_content:SetActive(true)
    self.empty_trick_content:SetActive(false)
  else
    self.get_first_reward_content:SetActive(false)
    self.empty_trick_content:SetActive(true)
  end
  self.specialRewardData = DataCenter.RewardManager:ReturnRewardParamForView(self.message.dayTotalRewardPreview)
  if self.specialRewardData and 0 < #self.specialRewardData then
    for i, v in ipairs(self.specialRewardData) do
      if self.u_i_common_res_item_list[i] == nil then
        local showIndex = "Item" .. i
        local item = self.u_i_common_res_item.gameObject:GameObjectSpawn(self.reward_content.transform)
        item.name = showIndex
        local obj = self.reward_content:AddComponent(UICommonResItem, item.name)
        self.u_i_common_res_item_list[i] = obj
      end
      self.u_i_common_res_item_list[i]:SetActive(true)
      self.u_i_common_res_item_list[i]:ReInit(v)
    end
    for i = #self.specialRewardData + 1, #self.u_i_common_res_item_list do
      self.u_i_common_res_item_list[i]:SetActive(false)
    end
  end
  local day = self.message.day
  local dayStr = DataCenter.ActLotteryDataManager:GetLotteryOpenTimeByDayNum(self.activityId, day)
  self.textTitle:SetLocalText("thxgiv_Lottery_text_5", dayStr)
  self.big_reward_title:SetLocalText("thxgiv_Lottery_text_6", self.message.tickerNumber)
  self.big_reward_num:SetText("")
  self:TryNextState()
end

function UIActLotteryBigRewardOpenView:ClearAllItem()
  self.reward_content:RemoveComponents(UICommonResItem)
  for _, v in ipairs(self.reward_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.u_i_common_res_item.gameObject:GameObjectRecycleAll()
  self.u_i_common_res_item_list = {}
end

local function OpenBtnClick(self)
  if self.curState == ViewState.PreAniWaitBtn then
    self:TryNextState()
  end
end

local function CloseBtnClick(self)
  if self.curState == ViewState.ResultAni then
    self.ctrl:CloseSelf()
    DataCenter.ActLotteryDataManager:GetOpenBigRewardViewClose()
    EventManager:GetInstance():Broadcast(EventId.ActLotteryOpenViewClose)
  end
end

local function TryNextState(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.nextStateTime then
    return
  end
  if self.curState == ViewState.None then
    self.pre_open_content:SetActive(true)
    self.result_content:SetActive(false)
    local res, time = self.pre_open_content:PlayAnimationReturnTime("ActLotteryPreOpenRewardIn")
    if time == nil then
      time = 0
    end
    self.curState = ViewState.PreAni1
    self.nextStateTime = curTime + time * 1000
  elseif self.curState == ViewState.PreAni1 then
    self.curState = ViewState.PreAniWaitBtn
    self.nextStateTime = 0
  elseif self.curState == ViewState.PreAniWaitBtn then
    local res, time = self.pre_open_content:PlayAnimationReturnTime("ActLotteryPreOpenRewardOpenAward2")
    if time == nil then
      time = 0
    end
    self.curState = ViewState.PreAni2
    self.nextStateTime = curTime + time * 1000
  elseif self.curState == ViewState.PreAni2 then
    self.pre_open_content:SetActive(false)
    self.result_content:SetActive(true)
    local res, time = self.result_content:PlayAnimationReturnTime("ActLotteryBigRewardSpecialShow_NoAwardIn")
    if time == nil then
      time = 0
    end
    self.curState = ViewState.Result
    self.nextStateTime = curTime + time * 1000 / 2
  elseif self.curState == ViewState.Result then
    self.curState = ViewState.ResultAni
    self.nextStateTime = 0
  end
end

local function Update100MS(self)
  if self.nextStateTime <= 0 then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.nextStateTime then
    self:TryNextState()
  end
end

UIActLotteryBigRewardOpenView.OnCreate = OnCreate
UIActLotteryBigRewardOpenView.OnDestroy = OnDestroy
UIActLotteryBigRewardOpenView.ComponentDefine = ComponentDefine
UIActLotteryBigRewardOpenView.ComponentDestroy = ComponentDestroy
UIActLotteryBigRewardOpenView.RefreshView = RefreshView
UIActLotteryBigRewardOpenView.OnAddListener = OnAddListener
UIActLotteryBigRewardOpenView.OnRemoveListener = OnRemoveListener
UIActLotteryBigRewardOpenView.CloseBtnClick = CloseBtnClick
UIActLotteryBigRewardOpenView.OpenBtnClick = OpenBtnClick
UIActLotteryBigRewardOpenView.TryNextState = TryNextState
UIActLotteryBigRewardOpenView.Update100MS = Update100MS
return UIActLotteryBigRewardOpenView
