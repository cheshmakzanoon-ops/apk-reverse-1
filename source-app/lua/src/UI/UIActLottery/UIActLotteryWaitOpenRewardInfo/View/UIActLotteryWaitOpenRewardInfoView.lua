local UIActLotteryWaitOpenRewardInfoView = BaseClass("UIActLotteryWaitOpenRewardInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local special_type_name_path = "ManualContent/InfoContent/topInfoContent/ticketContent/specialTypeName"
local special_type_no_val_path = "ManualContent/InfoContent/topInfoContent/ticketContent/specialTypeNoVal"
local special_type_num_path = "ManualContent/InfoContent/topInfoContent/ticketContent/specialTypeNum"
local top_info_txt_path = "ManualContent/InfoContent/topInfoContent/topInfoTxt"
local top_info_btn_path = "ManualContent/InfoContent/topInfoContent/topInfoBtn"
local top_info_btn_txt_path = "ManualContent/InfoContent/topInfoContent/topInfoBtn/topInfoBtnTxt"
local machine_special_type_name_path = "ManualContent/InfoContent/bottomInfoContent/MachineImg/MachineSpecialTypeName"
local machine_special_type_no_val_path = "ManualContent/InfoContent/bottomInfoContent/MachineImg/MachineSpecialTypeNoVal"
local bottom_info_txt_path = "ManualContent/InfoContent/bottomInfoContent/bottomInfoTxt"
local u_i_common_res_item_path = "ManualContent/InfoContent/bottomInfoContent/UICommonResItem"
local reward_content_item_path = "ManualContent/InfoContent/bottomInfoContent/rewardContent/rewardContentItem"

function UIActLotteryWaitOpenRewardInfoView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:UpdateContent()
end

function UIActLotteryWaitOpenRewardInfoView:OnDestroy()
  self:ClearAllItem()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActLotteryWaitOpenRewardInfoView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText")
  self.textTitle:SetLocalText("thxgiv_Lottery_machine1")
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/Common_bg_orange/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.special_type_name = self:AddComponent(UITextMeshProUGUIEx, special_type_name_path)
  self.special_type_no_val = self:AddComponent(UITextMeshProUGUIEx, special_type_no_val_path)
  self.special_type_num = self:AddComponent(UITextMeshProUGUIEx, special_type_num_path)
  self.top_info_txt = self:AddComponent(UITextMeshProUGUIEx, top_info_txt_path)
  self.top_info_btn = self:AddComponent(UIButton, top_info_btn_path)
  self.top_info_btn_txt = self:AddComponent(UITextMeshProUGUIEx, top_info_btn_txt_path)
  self.machine_special_type_name = self:AddComponent(UITextMeshProUGUIEx, machine_special_type_name_path)
  self.machine_special_type_no_val = self:AddComponent(UITextMeshProUGUIEx, machine_special_type_no_val_path)
  self.bottom_info_txt = self:AddComponent(UITextMeshProUGUIEx, bottom_info_txt_path)
  self.u_i_common_res_item = self:AddComponent(UICanvasGroup, u_i_common_res_item_path)
  self.reward_content_item = self:AddComponent(UIBaseContainer, reward_content_item_path)
  self.top_info_btn_txt:SetLocalText("110018")
  self.u_i_common_res_item:SetActive(false)
  self.u_i_common_res_item.gameObject:GameObjectCreatePool()
  self.u_i_common_res_item_list = {}
  self.top_info_btn:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
end

function UIActLotteryWaitOpenRewardInfoView:ComponentDestroy()
  self.special_type_name = nil
  self.special_type_no_val = nil
  self.special_type_num = nil
  self.top_info_txt = nil
  self.top_info_btn = nil
  self.top_info_btn_txt = nil
  self.machine_special_type_name = nil
  self.machine_special_type_no_val = nil
  self.bottom_info_txt = nil
  self.u_i_common_res_item = nil
  self.reward_content_item = nil
end

function UIActLotteryWaitOpenRewardInfoView:DataDefine()
  self.activityId = self:GetUserData()
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.activityTemp = DataCenter.ActLotteryDataManager:GetTempByActInfo(self.activityInfo)
  self.activityDetailData = DataCenter.ActLotteryDataManager:GetActData(self.activityId)
  if self.activityDetailData == nil then
    return
  end
  if self.activityDetailData:CheckOwnerRecordExpired() then
    SFSNetwork.SendMessage(MsgDefines.LottoOwnerRecord, self.activityId)
  end
end

function UIActLotteryWaitOpenRewardInfoView:DataDestroy()
end

function UIActLotteryWaitOpenRewardInfoView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActLotteryOwnerRecordMsg, self.GetActLotteryOwnerRecordMsgMsg)
end

function UIActLotteryWaitOpenRewardInfoView:OnRemoveListener()
  self:RemoveUIListener(EventId.ActLotteryOwnerRecordMsg, self.GetActLotteryOwnerRecordMsgMsg)
  base.OnRemoveListener(self)
end

function UIActLotteryWaitOpenRewardInfoView:UpdateContent()
  if self.activityId == nil then
    return
  end
  self.recordData = self.activityDetailData:GetOwnerRecord()
  local targetRewardId = self.activityTemp.big_reward[1]
  self.specialRewardData = DataCenter.ActLotteryDataManager:GetRewardDataById(targetRewardId)
  self.curDayNumReal, self.nextOpenTimeReal = DataCenter.ActLotteryDataManager:GetRealBigRewardTimeData(self.activityId)
  self.curRecordData = nil
  if self.recordData then
    for i, v in ipairs(self.recordData) do
      if v.day == self.curDayNumReal + 1 then
        self.curRecordData = v
        break
      end
    end
  end
  if self.specialRewardData and #self.specialRewardData > 0 then
    for i, v in ipairs(self.specialRewardData) do
      if self.u_i_common_res_item_list[i] == nil then
        local showIndex = "Item" .. i
        local item = self.u_i_common_res_item.gameObject:GameObjectSpawn(self.reward_content_item.transform)
        item.name = showIndex
        local obj = self.reward_content_item:AddComponent(UICommonResItem, item.name)
        self.u_i_common_res_item_list[i] = obj
      end
      self.u_i_common_res_item_list[i]:SetActive(true)
      self.u_i_common_res_item_list[i]:ReInit(v)
    end
    for i = #self.specialRewardData + 1, #self.u_i_common_res_item_list do
      self.u_i_common_res_item_list[i]:SetActive(false)
    end
  end
  local firstNum = 0
  if self.curRecordData and self.curRecordData.firstTickerArr then
    firstNum = #self.curRecordData.firstTickerArr
  end
  local firstTickName = DataCenter.ActLotteryDataManager:GetLotteryRankName(1)
  local winTickName = DataCenter.ActLotteryDataManager:GetLotteryRankName(0, true)
  self.special_type_name:SetText(firstTickName)
  self.special_type_no_val:SetLocalText("thxgiv_numberNo3")
  self.machine_special_type_name:SetText(winTickName)
  self.machine_special_type_no_val:SetLocalText("thxgiv_numberNo3")
  self.special_type_num:SetText("x" .. firstNum)
  self.top_info_txt:SetLocalText("thxgiv_Lottery_machine2", firstNum)
  self:Update1000MS()
end

function UIActLotteryWaitOpenRewardInfoView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIActLotteryWaitOpenRewardInfoView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIActLotteryWaitOpenRewardInfoView:GetActLotteryOwnerRecordMsgMsg()
  self:UpdateContent()
end

function UIActLotteryWaitOpenRewardInfoView:ClearAllItem()
  self.reward_content_item:RemoveComponents(UICommonResItem)
  for _, v in ipairs(self.reward_content_item.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.u_i_common_res_item.gameObject:GameObjectRecycleAll()
  self.u_i_common_res_item_list = {}
end

function UIActLotteryWaitOpenRewardInfoView:Update1000MS()
  if self.activityDetailData == nil then
    return
  end
  if self.curDayNumReal == nil or self.nextOpenTimeReal == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.nextOpenTimeReal - curTime
  if leftTime <= 0 then
    return
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.bottom_info_txt:SetLocalText("thxgiv_Lottery_machine3", countDownTimeStr)
  if leftTime <= 0 and self.nextOpenTimeReal > 0 then
    self:UpdateContent()
  end
end

return UIActLotteryWaitOpenRewardInfoView
