local ActLotteryBigRewardSpecialShowView = BaseClass("ActLotteryBigRewardSpecialShowView", UIBaseView)
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
local pre_open_content_path = "preOpenContent"
local open_btn_path = "preOpenContent/Root/MachineContent/openBtn"
local result_content_path = "resultContent"
local special_type_time1_path = "resultContent/Root/Panel/CenterContent/bg1/specialTypeTime1"
local special_type_name1_path = "resultContent/Root/Panel/CenterContent/bg1/specialTypeName1"
local special_type_num1_path = "resultContent/Root/Panel/CenterContent/bg1/specialTypeNum1"
local special_type_time2_path = "resultContent/Root/Panel/CenterContent/mask/bg2/specialTypeTime2"
local special_type_name2_path = "resultContent/Root/Panel/CenterContent/mask/bg2/specialTypeName2"
local special_type_num2_path = "resultContent/Root/Panel/CenterContent/mask/bg2/specialTypeNum2"
local get_btn_path = "resultContent/Root/Panel/GetBtn"
local u_i_common_res_item_path = "resultContent/Root/Panel/CenterContent/UICommonResItem"
local reward_content_path = "resultContent/Root/Panel/CenterContent/RewardScrollView/Viewport/RewardContent"
local other_title_text_path = "resultContent/Root/Panel/CongrationArea/OtherTitleBg/OtherTitleText"
local tip_txt_path = "resultContent/Root/Panel/tipTxt"

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
  self.pre_open_content = self:AddComponent(UIAnimator, pre_open_content_path)
  self.open_btn = self:AddComponent(UIButton, open_btn_path)
  self.result_content = self:AddComponent(UIAnimator, result_content_path)
  self.special_type_time1 = self:AddComponent(UITextMeshProUGUIEx, special_type_time1_path)
  self.special_type_name1 = self:AddComponent(UITextMeshProUGUIEx, special_type_name1_path)
  self.special_type_num1 = self:AddComponent(UITextMeshProUGUIEx, special_type_num1_path)
  self.special_type_time2 = self:AddComponent(UITextMeshProUGUIEx, special_type_time2_path)
  self.special_type_name2 = self:AddComponent(UITextMeshProUGUIEx, special_type_name2_path)
  self.special_type_num2 = self:AddComponent(UITextMeshProUGUIEx, special_type_num2_path)
  self.get_btn = self:AddComponent(UIButton, get_btn_path)
  self.open_btn:SetOnClick(function()
    self:OpenBtnClick()
  end)
  self.get_btn:SetOnClick(function()
    self:CloseBtnClick()
  end)
  self.u_i_common_res_item = self:AddComponent(UICanvasGroup, u_i_common_res_item_path)
  self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.u_i_common_res_item:SetActive(false)
  self.u_i_common_res_item.gameObject:GameObjectCreatePool()
  self.u_i_common_res_item_list = {}
  self.other_title_text = self:AddComponent(UITextMeshProUGUIEx, other_title_text_path)
  self.tip_txt = self:AddComponent(UITextMeshProUGUIEx, tip_txt_path)
end

local function ComponentDestroy(self)
  self.pre_open_content = nil
  self.open_btn = nil
  self.result_content = nil
  self.special_type_time1 = nil
  self.special_type_name1 = nil
  self.special_type_num1 = nil
  self.special_type_time2 = nil
  self.special_type_name2 = nil
  self.special_type_num2 = nil
  self.get_btn = nil
  self.u_i_common_res_item = nil
  self.reward_content = nil
  self.other_title_text = nil
  self.tip_txt = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function RefreshView(self)
  self.message = self:GetUserData()
  self.special_type_num1:SetText(self.message.tickerNumber)
  self.special_type_num2:SetText(self.message.tickerNumber)
  local timeTxt = DataCenter.ActLotteryDataManager:GetLotteryOpenTime(self.message.createTime * 1000)
  self.special_type_time1:SetText(timeTxt)
  self.special_type_time2:SetText(timeTxt)
  self.special_type_name1:SetText(DataCenter.ActLotteryDataManager:GetLotteryRankName(1))
  self.special_type_name2:SetText(DataCenter.ActLotteryDataManager:GetLotteryRankName(0, true))
  self.reward_content:SetAnchoredPositionXY(0, 0)
  self.specialRewardData = DataCenter.RewardManager:ReturnRewardParamForView(self.message.bigRewardReview)
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
  local dayStr = DataCenter.ActLotteryDataManager:GetLotteryOpenTimeByDayNum(self.message.activityId, day)
  self.other_title_text:SetLocalText("thxgiv_Lottery_text_3", dayStr)
  self.tip_txt:SetLocalText("thxgiv_Lottery_text_4", self.message.tickerNumber)
  self:TryNextState()
end

function ActLotteryBigRewardSpecialShowView:ClearAllItem()
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
  if self.curState ~= ViewState.ResultAni then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.LottoReceiveBigReward, self.message.activityId, self.message.day)
  self.ctrl:CloseSelf()
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
    local res, time = self.result_content:PlayAnimationReturnTime("ActLotteryBigRewardSpecialShow_In")
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

ActLotteryBigRewardSpecialShowView.OnCreate = OnCreate
ActLotteryBigRewardSpecialShowView.OnDestroy = OnDestroy
ActLotteryBigRewardSpecialShowView.ComponentDefine = ComponentDefine
ActLotteryBigRewardSpecialShowView.ComponentDestroy = ComponentDestroy
ActLotteryBigRewardSpecialShowView.RefreshView = RefreshView
ActLotteryBigRewardSpecialShowView.OnAddListener = OnAddListener
ActLotteryBigRewardSpecialShowView.OnRemoveListener = OnRemoveListener
ActLotteryBigRewardSpecialShowView.CloseBtnClick = CloseBtnClick
ActLotteryBigRewardSpecialShowView.OpenBtnClick = OpenBtnClick
ActLotteryBigRewardSpecialShowView.TryNextState = TryNextState
ActLotteryBigRewardSpecialShowView.Update100MS = Update100MS
return ActLotteryBigRewardSpecialShowView
