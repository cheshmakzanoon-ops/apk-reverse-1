local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local ActGiftGivingMain = BaseClass("ActGiftGivingMain", base)
local Localization = CS.GameEntry.Localization
local txt_act_name_path = "rect/topContent/Txt_ActName"
local txt_times_path = "rect/topContent/TimeContent/txtContent/Txt_Times"
local resource_num_path = "rect/topContent/ResBar/numContent/resourceNum"
local resource_icon_path = "rect/topContent/ResBar/resourceIcon"
local add_btn_path = "rect/topContent/ResBar/addBtn"
local add_red_point_path = "rect/topContent/ResBar/addBtn/addRedPoint"
local btn_info_path = "rect/topContent/BtnInfo"
local btn_reward_path = "rect/topContent/BtnReward"
local item_path = "rect/bottomContent/rewardContent/Item"
local content_path = "rect/bottomContent/rewardContent/ScrollView/Viewport/Content"
local auto_btn_path = "rect/bottomContent/autoBtn"
local btn_give_path = "rect/bottomContent/BtnGive"
local auto_btn_be_select_path = "rect/bottomContent/autoBtn/autoBtnBeSelect"
local txt_act_desc_path = "rect/topContent/Txt_ActDesc"
local exchange_tip_txt_path = "rect/bottomContent/exchangeTipContent/exchangeTipTxt"
local exchang_tip_item1_path = "rect/bottomContent/exchangeTipContent/exchangeContent/exchangTipItem1"
local exchang_tip_item2_path = "rect/bottomContent/exchangeTipContent/exchangeContent/exchangTipItem2"
local exchang_tip_item3_1_path = "rect/bottomContent/exchangeTipContent/exchangeContent/exchangTipItem3_1"
local exchang_tip_item3_2_path = "rect/bottomContent/exchangeTipContent/exchangeContent/exchangTipItem3_2"
local exchang_tip_item3_3_path = "rect/bottomContent/exchangeTipContent/exchangeContent/exchangTipItem3_3"
local send_btn_content_path = "rect/centerContent/SendBtnContent"
local send_item_name_path = "rect/centerContent/SendBtnContent/SendItemName"
local send_item_num_path = "rect/centerContent/SendBtnContent/SendItemNum"
local exchange_content_path = "rect/centerContent/exchangeContent"
local exchange_item_red_point_path = "rect/centerContent/exchangeContent/exchangeItemRedPoint"
local bubble1_content_path = "rect/centerContent/Bubble1Content"
local bubble1_txt_path = "rect/centerContent/Bubble1Content/bubble1Txt"
local bubble1_res_item_path = "rect/centerContent/Bubble1Content/Bubble1ResItem"
local bubble2_content_path = "rect/centerContent/Bubble2Content"
local bubble2_txt_path = "rect/centerContent/Bubble2Content/bubble2Txt"
local bubble2_res_item_path = "rect/centerContent/Bubble2Content/Bubble2ResItem"

function ActGiftGivingMain:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function ActGiftGivingMain:OnDestroy()
  self:ClearAllItem()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActGiftGivingMain:ComponentDefine()
  self.txt_act_name = self:AddComponent(UITextMeshProUGUIEx, txt_act_name_path)
  self.txt_times = self:AddComponent(UITextMeshProUGUIEx, txt_times_path)
  self.resource_num = self:AddComponent(UITextMeshProUGUIEx, resource_num_path)
  self.resource_icon = self:AddComponent(UIImage, resource_icon_path)
  self.add_btn = self:AddComponent(UIButton, add_btn_path)
  self.add_red_point = self:AddComponent(UIImage, add_red_point_path)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_reward = self:AddComponent(UIButton, btn_reward_path)
  self.item = self:AddComponent(UICanvasGroup, item_path)
  self.item:SetActive(false)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.auto_btn = self:AddComponent(UIButton, auto_btn_path)
  self.btn_give = self:AddComponent(UIButton, btn_give_path)
  self.auto_btn_be_select = self:AddComponent(UIImage, auto_btn_be_select_path)
  self.add_btn:SetOnClick(function()
    self:OnAddBtnClick()
  end)
  self.btn_info:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
  self.btn_reward:SetOnClick(function()
    self:OnRewardBtnClick()
  end)
  self.btn_give:SetOnClick(function()
    self:OnGiveBtnClick()
  end)
  self.auto_btn:SetOnClick(function()
    self:OnAutoBtnClick()
  end)
  self.txt_act_desc = self:AddComponent(UITextMeshProUGUIEx, txt_act_desc_path)
  self.exchange_tip_txt = self:AddComponent(UITextMeshProUGUIEx, exchange_tip_txt_path)
  self.exchang_tip_item1 = self:AddComponent(UICommonResItem, exchang_tip_item1_path)
  self.exchang_tip_item2 = self:AddComponent(UICommonResItem, exchang_tip_item2_path)
  self.exchang_tip_item3_1 = self:AddComponent(UICommonResItem, exchang_tip_item3_1_path)
  self.exchang_tip_item3_2 = self:AddComponent(UICommonResItem, exchang_tip_item3_2_path)
  self.exchang_tip_item3_3 = self:AddComponent(UICommonResItem, exchang_tip_item3_3_path)
  self.exchang_tip_item3_tab = {
    self.exchang_tip_item3_1,
    self.exchang_tip_item3_2,
    self.exchang_tip_item3_3
  }
  self.send_btn_content = self:AddComponent(UIButton, send_btn_content_path)
  self.send_item_name = self:AddComponent(UITextMeshProUGUIEx, send_item_name_path)
  self.send_item_num = self:AddComponent(UITextMeshProUGUIEx, send_item_num_path)
  self.exchange_content = self:AddComponent(UIButton, exchange_content_path)
  self.exchange_item_red_point = self:AddComponent(UIImage, exchange_item_red_point_path)
  self.bubble1_content = self:AddComponent(UICanvasGroup, bubble1_content_path)
  self.bubble1_txt = self:AddComponent(UITextMeshProUGUIEx, bubble1_txt_path)
  self.bubble1_res_item = self:AddComponent(UICommonResItem, bubble1_res_item_path)
  self.bubble2_content = self:AddComponent(UICanvasGroup, bubble2_content_path)
  self.bubble2_txt = self:AddComponent(UITextMeshProUGUIEx, bubble2_txt_path)
  self.bubble2_res_item = self:AddComponent(UICommonResItem, bubble2_res_item_path)
  self.send_btn_content:SetOnClick(function()
    self:OnGiveBtnClick()
  end)
  self.exchange_content:SetOnClick(function()
    self:OnAddBtnClick()
  end)
end

function ActGiftGivingMain:ComponentDestroy()
  self.txt_act_name = nil
  self.txt_times = nil
  self.resource_num = nil
  self.resource_icon = nil
  self.add_btn = nil
  self.add_red_point = nil
  self.btn_info = nil
  self.btn_reward = nil
  self.item = nil
  self.content = nil
  self.auto_btn = nil
  self.btn_give = nil
  self.auto_btn_be_select = nil
  self.exchange_tip_txt = nil
  self.exchang_tip_item1 = nil
  self.exchang_tip_item2 = nil
  self.exchang_tip_item3_1 = nil
  self.exchang_tip_item3_2 = nil
  self.exchang_tip_item3_3 = nil
  self.send_btn_content = nil
  self.send_item_name = nil
  self.send_item_num = nil
  self.exchange_content = nil
  self.exchange_item_red_point = nil
  self.bubble1_content = nil
  self.bubble1_txt = nil
  self.bubble1_res_item = nil
  self.bubble2_content = nil
  self.bubble2_txt = nil
  self.bubble2_res_item = nil
  self.txt_act_desc = nil
end

function ActGiftGivingMain:DataDefine()
end

function ActGiftGivingMain:DataDestroy()
end

function ActGiftGivingMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActGiftGivingDetailDataGet, self.GetActDetailDataMsg)
  self:AddUIListener(EventId.ActGiftGivingReceiveGiveReward, self.GetReceiveGiveRewardMsg)
  self:AddUIListener(EventId.ActGiftGivingExchange, self.GetActItemChangeMsg)
  self:AddUIListener(EventId.ActGiftGivingGive, self.GetActItemChangeMsg)
end

function ActGiftGivingMain:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActGiftGivingDetailDataGet, self.GetActDetailDataMsg)
  self:RemoveUIListener(EventId.ActGiftGivingReceiveGiveReward, self.GetReceiveGiveRewardMsg)
  self:RemoveUIListener(EventId.ActGiftGivingExchange, self.GetActItemChangeMsg)
  self:RemoveUIListener(EventId.ActGiftGivingGive, self.GetActItemChangeMsg)
end

function ActGiftGivingMain:OnEnable()
  base.OnEnable(self)
end

function ActGiftGivingMain:OnDisable()
  base.OnDisable(self)
end

function ActGiftGivingMain:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = tonumber(activityId)
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.activityDetailData = DataCenter.ActGiftGivingDataManager:GetActData(self.activityId)
  if self.activityDetailData == nil then
    return
  end
  self.activityTemp = DataCenter.ActGiftGivingDataManager:GetTempByActInfo(self.activityInfo)
  self.targetIndex = DataCenter.ActGiftGivingDataManager:GetRewardTargetIndex(self.activityId)
  self:RefreshShowConfigView()
  self:RefreshView()
  SFSNetwork.SendMessage(MsgDefines.ThanksgivingInfo, self.activityId)
end

function ActGiftGivingMain:RefreshView()
  self:Update1000MS()
  self.txt_act_name:SetLocalText(self.activityInfo.name)
  self.txt_act_desc:SetLocalText(self.activityInfo.bannerTittle)
  self:RefreshResContent()
  self:RefreshRewardContent()
  self:RefreshGiveBtnContent()
  self:RefreshAutoGiveContent()
  self:RefreshCanGetRewardShowContent()
  self:RefreshCenterContent()
end

function ActGiftGivingMain:RefreshCenterContent()
  if not self.activityDetailData then
    return
  end
  local itemId = self.activityTemp.give_item
  local curNum = DataCenter.ItemData:GetItemCount(itemId)
  local costItemId = self.activityTemp.merge_cost_item_tab[1]
  local costCurNum = DataCenter.ItemData:GetItemCount(costItemId)
  local getItemId = self.activityTemp.owner_give_item_tab[1]
  local getItemNum = DataCenter.ItemData:GetItemCount(getItemId)
  self.send_item_name:SetLocalText("thxgiv_MapSent")
  self.send_item_num:SetText("x" .. curNum)
  self.exchange_item_red_point:SetActive(self.activityDetailData:GetCanCookNum() > 0)
  local bubble1Param = {
    rewardType = RewardType.GOODS,
    itemId = itemId
  }
  self.bubble1_res_item:ReInit(bubble1Param)
  local bubble2Param = {
    rewardType = RewardType.GOODS,
    itemId = getItemId
  }
  self.bubble2_res_item:ReInit(bubble2Param)
  local teach_show_tab = self.activityTemp.teach_show_tab
  if teach_show_tab and #teach_show_tab == 4 then
    self.exchange_tip_txt:SetLocalText(teach_show_tab[1])
    local item1Param = {
      rewardType = RewardType.GOODS,
      itemId = tonumber(teach_show_tab[2])
    }
    self.exchang_tip_item1:ReInit(item1Param)
    local item2Param = {
      rewardType = RewardType.GOODS,
      itemId = tonumber(teach_show_tab[3])
    }
    self.exchang_tip_item2:ReInit(item2Param)
    local item3Arr = string.split(teach_show_tab[4], ";")
    for i, v in ipairs(self.exchang_tip_item3_tab) do
      if i <= #item3Arr then
        v:SetActive(true)
        local item3Param = {
          rewardType = RewardType.GOODS,
          itemId = tonumber(item3Arr[i])
        }
        v:ReInit(item3Param)
      else
        v:SetActive(false)
      end
    end
  end
  self.bubble1_content:SetActive(curNum <= 0)
  self.bubble2_content:SetActive(0 < curNum)
end

function ActGiftGivingMain:Update1000MS()
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
end

function ActGiftGivingMain:RefreshResContent()
  if not self.activityDetailData then
    return
  end
  local itemId = self.activityTemp.give_item
  local iconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, itemId)
  self.resource_icon:LoadSprite(iconPath)
  local curNum = DataCenter.ItemData:GetItemCount(itemId)
  self.resource_num:SetText(curNum)
end

function ActGiftGivingMain:RefreshRewardContent()
  if not self.activityDetailData then
    return
  end
  self.btn_reward:SetActive(self.targetIndex > 0)
end

function ActGiftGivingMain:RefreshGiveBtnContent()
end

function ActGiftGivingMain:RefreshAutoGiveContent()
  if not self.activityDetailData then
    return
  end
  local isAuto = DataCenter.ActGiftGivingDataManager:GetIsAutoSend(self.activityId)
  self.auto_btn_be_select:SetActive(isAuto)
end

function ActGiftGivingMain:RefreshCanGetRewardShowContent()
  if not self.activityDetailData then
    return
  end
  local showData = {}
  if #self.activityTemp.owner_give_item_tab > 0 then
    showData[1] = {
      rewardType = RewardType.GOODS,
      itemId = self.activityTemp.owner_give_item_tab[1],
      count = self.activityTemp.owner_give_item_tab[2]
    }
  end
end

function ActGiftGivingMain:RefreshShowConfigView()
  if not self.activityDetailData then
    return
  end
  local showTemp = self.activityInfo:GetShowConfigTemp()
  if showTemp == nil then
    return
  end
end

function ActGiftGivingMain:OnAddBtnClick()
  if not self.activityDetailData then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActGiftGivingDropPanel, {anim = true}, self.activityId)
end

function ActGiftGivingMain:OnInfoBtnClick()
  local param = {}
  param.activityRulesStr = Localization:GetString(self.activityInfo.story)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetail, {anim = true}, param)
end

function ActGiftGivingMain:OnRewardBtnClick()
  if not self.activityDetailData then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActGiftGivingRewardGet, {anim = true}, self.activityId)
end

function ActGiftGivingMain:OnGiveBtnClick()
  if not self.activityDetailData then
    return
  end
  local itemId = self.activityTemp.give_item
  local curNum = DataCenter.ItemData:GetItemCount(itemId)
  if 0 < curNum then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActGiftGivingSelectMember, {anim = true}, self.activityId)
    if self.activityDetailData:CheckIsGivePlayersDataExpired() then
      SFSNetwork.SendMessage(MsgDefines.ThanksgivingRecommend, self.activityId)
    end
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActGiftGivingDropPanel, {anim = true}, self.activityId)
  end
end

function ActGiftGivingMain:OnAutoBtnClick()
  if not self.activityDetailData then
    return
  end
  local isAuto = DataCenter.ActGiftGivingDataManager:GetIsAutoSend(self.activityId)
  DataCenter.ActGiftGivingDataManager:SetIsAutoSend(self.activityId, not isAuto)
  self:RefreshAutoGiveContent()
end

function ActGiftGivingMain:ClearAllItem()
end

function ActGiftGivingMain:GetActDetailDataMsg()
  self.targetIndex = DataCenter.ActGiftGivingDataManager:GetRewardTargetIndex(self.activityId)
  self:RefreshView()
end

function ActGiftGivingMain:GetReceiveGiveRewardMsg()
  self.targetIndex = DataCenter.ActGiftGivingDataManager:GetRewardTargetIndex(self.activityId)
  self:RefreshView()
end

function ActGiftGivingMain:GetActItemChangeMsg()
  self:RefreshView()
end

return ActGiftGivingMain
