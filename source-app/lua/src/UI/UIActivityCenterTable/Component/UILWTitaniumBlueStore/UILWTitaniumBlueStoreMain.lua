local UILWTitaniumBlueStoreMain = BaseClass("UILWTitaniumBlueStoreMain", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UILWTitaniumBlueBoxRewardItemRender = require("UI.UIActivityCenterTable.Component.UILWTitaniumBlueStore.UILWTitaniumBlueBoxRewardItemRender")
local UILWTitaniumBlueProductItemRender = require("UI.UIActivityCenterTable.Component.UILWTitaniumBlueStore.UILWTitaniumBlueProductItemRender")
local title_text_path = "TopContent/TitleText"
local des_text_path = "TopContent/DesText"
local time_text_path = "TopContent/TimeText"
local info_btn_path = "TopContent/InfoBtn"
local titanium_blue_value_text_path = "TopContent/TitaniumBlueArea/TitaniumBlueValueText"
local titanium_blue_good_icon_path = "TopContent/TitaniumBlueArea/TitaniumBlueGoodIcon"
local add_btn_path = "TopContent/TitaniumBlueArea/addBtn"
local add_red_point_path = "TopContent/TitaniumBlueArea/addRedPoint"
local slider_path = "TopContent/ProgressContent/Slider"
local titanium_blue_cumulate_value_text_path = "TopContent/ProgressContent/TitaniumBlueCumulateValueText"
local reward_box_item_render_path = "TopContent/ProgressContent/RewardBoxItemRender"
local reward_content_path = "TopContent/ProgressContent/RewardContent"
local product_scroll_view_path = "ProductScrollView"

function UILWTitaniumBlueStoreMain:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UILWTitaniumBlueStoreMain:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTitaniumBlueStoreMain:DataDefine()
  self.activityId = 0
  self.activityData = nil
  self.shopProductDataList = {}
  self.boxRewardDataList = {}
  self.curTitaniumBlueTotalScoreValue = 0
  self.boxRewardItemRenderList = {}
  self.boxRewardRatio = 0
  self.showMessageTips = false
end

function UILWTitaniumBlueStoreMain:DataDestroy()
  self.activityId = nil
  self.activityData = nil
  self.shopProductDataList = nil
  self.boxRewardDataList = nil
  self.curTitaniumBlueTotalScoreValue = nil
  self.boxRewardItemRenderList = nil
  self.boxRewardRatio = nil
  self.showMessageTips = nil
end

function UILWTitaniumBlueStoreMain:OnDisable()
  base.OnDisable(self)
end

function UILWTitaniumBlueStoreMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.OnRefreshItems)
  self:AddUIListener(EventId.RefreshTitaniumBlueDailyRewardData, self.RefreshAddBtnRedPoint)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.OnRefreshActivityData)
  self:AddUIListener(EventId.RefreshTitaniumBlueTotalScoreData, self.OnRefreshTotalScoreProgress)
  self:AddUIListener(EventId.UpdateGold, self.OnRefreshItems)
end

function UILWTitaniumBlueStoreMain:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshItems, self.OnRefreshItems)
  self:RemoveUIListener(EventId.RefreshTitaniumBlueDailyRewardData, self.RefreshAddBtnRedPoint)
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.OnRefreshActivityData)
  self:RemoveUIListener(EventId.RefreshTitaniumBlueTotalScoreData, self.OnRefreshTotalScoreProgress)
  self:RemoveUIListener(EventId.UpdateGold, self.OnRefreshItems)
  base.OnRemoveListener(self)
end

function UILWTitaniumBlueStoreMain:ComponentDefine()
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.des_text = self:AddComponent(UIText, des_text_path)
  self.time_text = self:AddComponent(UIText, time_text_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    self:InfoBtnClick()
  end)
  self.titanium_blue_value_text = self:AddComponent(UIText, titanium_blue_value_text_path)
  self.add_btn = self:AddComponent(UIButton, add_btn_path)
  self.add_btn:SetOnClick(function()
    self:AddBtnClick()
  end)
  self.add_red_point = self:AddComponent(UIImage, add_red_point_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.titanium_blue_cumulate_value_text = self:AddComponent(UIText, titanium_blue_cumulate_value_text_path)
  self.titanium_blue_good_icon = self:AddComponent(UIImage, titanium_blue_good_icon_path)
  self.reward_box_item_render_obj = self.transform:Find(reward_box_item_render_path).gameObject
  self.reward_box_item_render_obj:GameObjectCreatePool()
  self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.product_scroll_view = self:AddComponent(UIScrollView, product_scroll_view_path)
  self.product_scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnProductItemMoveIn(itemObj, index)
  end)
  self.product_scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnProductItemMoveOut(itemObj, index)
  end)
end

function UILWTitaniumBlueStoreMain:ComponentDestroy()
  self.title_text = nil
  self.des_text = nil
  self.time_text = nil
  self.info_btn = nil
  self.titanium_blue_value_text = nil
  self.titanium_blue_good_icon = nil
  self.add_btn = nil
  self.add_red_point = nil
  self.slider = nil
  self.titanium_blue_cumulate_value_text = nil
  self:ClearBoxReward()
  self.reward_content = nil
  self.reward_box_item_render_obj = nil
  self:ClearScroll()
  self.product_scroll_view = nil
end

function UILWTitaniumBlueStoreMain:Update1000MS()
  self:RefreshTimerCountdown()
end

function UILWTitaniumBlueStoreMain:OnRefreshItems()
  self:RefreshTitaniumBlueCurrencyCount()
end

function UILWTitaniumBlueStoreMain:OnRefreshActivityData(activityId)
  if self.activityId == activityId then
    self:UpdateView()
  end
end

function UILWTitaniumBlueStoreMain:OnRefreshTotalScoreProgress(addScore)
  self:RefreshProgress()
end

function UILWTitaniumBlueStoreMain:SetData(activityId)
  self.activityId = activityId
  self:UpdateView()
end

function UILWTitaniumBlueStoreMain:UpdateView()
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityData ~= nil then
    self.title_text:SetLocalText(self.activityData.name)
    self.des_text:SetLocalText(self.activityData.story)
    self:RefreshTimerCountdown()
    self:RefreshTitaniumBlueCurrencyCount()
    self:ShowProductScroll()
    self:ShowBoxReward()
    self:RefreshProgress()
    self:RefreshAddBtnRedPoint()
  end
end

function UILWTitaniumBlueStoreMain:RefreshTimerCountdown()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local surplusTime = DataCenter.LWTitaniumBlueStoreManager.endTime - curTime
  if 0 < surplusTime and self.time_text then
    self.time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime))
  end
  if surplusTime <= 0 and not self.showMessageTips then
    if self.time_text then
      self.time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(0))
    end
    self.showMessageTips = true
    
    local function closeSelf()
      self.view.ctrl:CloseSelf()
    end
    
    UIUtil.ShowMessage(Localization:GetString("activity_blue_shop_desc11"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, closeSelf, closeSelf, closeSelf, Localization:GetString("activity_blue_shop_desc10"))
  end
end

function UILWTitaniumBlueStoreMain:RefreshTitaniumBlueCurrencyCount()
  local iconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, tonumber(self.activityData.para_2))
  self.titanium_blue_good_icon:LoadSprite(iconPath)
  local itemData = DataCenter.ItemData:GetItemById(tonumber(self.activityData.para_2))
  self.titanium_blue_value_text:SetText(itemData and itemData.count or 0)
end

function UILWTitaniumBlueStoreMain:ShowProductScroll()
  self:ClearScroll()
  self.shopProductDataList = DataCenter.LWTitaniumBlueStoreManager.productList
  local dataCount = #self.shopProductDataList
  if 0 < dataCount then
    self.product_scroll_view:SetTotalCount(dataCount)
    self.product_scroll_view:RefillCells()
  end
end

function UILWTitaniumBlueStoreMain:OnProductItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.product_scroll_view:AddComponent(UILWTitaniumBlueProductItemRender, itemObj)
  if cellItem ~= nil then
    cellItem:SetData(self.activityId, self.shopProductDataList[index])
  end
end

function UILWTitaniumBlueStoreMain:OnProductItemMoveOut(itemObj, index)
  self.product_scroll_view:RemoveComponent(itemObj.name, UILWTitaniumBlueProductItemRender)
end

function UILWTitaniumBlueStoreMain:ClearScroll()
  self.product_scroll_view:ClearCells()
  self.product_scroll_view:RemoveComponents(UILWTitaniumBlueProductItemRender)
end

function UILWTitaniumBlueStoreMain:RefreshAddBtnRedPoint()
  self.add_red_point:SetActive(false)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function UILWTitaniumBlueStoreMain:ShowBoxReward()
  self.boxRewardItemRenderList = {}
  self:ClearBoxReward()
  self.boxRewardDataList = DataCenter.LWTitaniumBlueStoreManager.boxRewardsList
  local boxRewardCount = #self.boxRewardDataList
  self.boxRewardRatio = 1 / boxRewardCount
  for i = 1, boxRewardCount do
    local itemObj = self.reward_box_item_render_obj:GameObjectSpawn(self.reward_content.transform)
    itemObj.name = "item" .. i
    itemObj:SetActive(true)
    local boxRewardItemRender = self.reward_content:AddComponent(UILWTitaniumBlueBoxRewardItemRender, itemObj.name)
    boxRewardItemRender:SetData(self.activityId, self.boxRewardDataList[i])
    table.insert(self.boxRewardItemRenderList, boxRewardItemRender)
  end
end

function UILWTitaniumBlueStoreMain:ClearBoxReward()
  self.reward_content:RemoveComponents(UILWTitaniumBlueBoxRewardItemRender)
  self.reward_box_item_render_obj:GameObjectRecycleAll()
end

function UILWTitaniumBlueStoreMain:RefreshProgress()
  self.curTitaniumBlueTotalScoreValue = DataCenter.LWTitaniumBlueStoreManager.totalScore
  local progress, curTargetCount = self:CalcProgress()
  self.slider:SetValue(progress)
  self.titanium_blue_cumulate_value_text:SetText(self.curTitaniumBlueTotalScoreValue)
end

function UILWTitaniumBlueStoreMain:CalcProgress()
  local preTargetCount, curTargetCount = 0, 0
  local maxValue = DataCenter.LWTitaniumBlueStoreManager:GetBoxRewardMaxValue()
  if maxValue <= self.curTitaniumBlueTotalScoreValue then
    curTargetCount = maxValue
    return 1, curTargetCount
  end
  local progress = 0
  local targetIndex = 1
  for i = 1, #self.boxRewardDataList do
    if self.curTitaniumBlueTotalScoreValue >= self.boxRewardDataList[i].targetCount then
      progress = progress + self.boxRewardRatio
      curTargetCount = self.boxRewardDataList[i].targetCount
    else
      targetIndex = i
      curTargetCount = self.boxRewardDataList[i].targetCount
      break
    end
  end
  local preIndex = targetIndex - 1
  if 1 <= preIndex then
    preTargetCount = self.boxRewardDataList[preIndex].targetCount
  end
  local differenceCount = curTargetCount - preTargetCount
  local curCount = self.curTitaniumBlueTotalScoreValue - preTargetCount
  local tempProgress = curCount == 0 and 0 or curCount / differenceCount
  progress = progress + tempProgress * self.boxRewardRatio
  return progress, curTargetCount
end

function UILWTitaniumBlueStoreMain:InfoBtnClick()
  local param = {}
  param.activityRulesStr = Localization:GetString(self.activityData.desc_info)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function UILWTitaniumBlueStoreMain:AddBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local rewardPackGroupId = DataCenter.LWTitaniumBlueStoreManager:GetGiftPackId()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, self.activityId, rewardPackGroupId, tonumber(self.activityData.para_2))
end

return UILWTitaniumBlueStoreMain
