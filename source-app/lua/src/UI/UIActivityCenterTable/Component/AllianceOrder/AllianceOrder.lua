local base = UIBaseView
local AllianceOrder = BaseClass("AllianceOrder", base)
local Localization = CS.GameEntry.Localization
local Manager = DataCenter.ActAllianceOrderManager
local UIOrderListItem = require("UI.UIActivityCenterTable.Component.AllianceOrder.UIOrderListItem")
local UIPreviewItem = require("UI.UIActivityCenterTable.Component.AllianceOrder.UIPreviewItem")
local UIStorageShopGo = require("UI.UIStorageShopGo.UIStorageShopGo")
local blackMask_path = "BlackMask"
local main_path = "Panel/Main"
local title_content_path = "Panel/TitleContent"
local title_path = title_content_path .. "/Title"
local intro_path = title_content_path .. "/Intro"
local myToken_path = title_content_path .. "/Title/MyToken"
local myTokenInfo_path = title_content_path .. "/Title/MyToken/MyTokenInfo"
local myTokenCount_path = title_content_path .. "/Title/MyToken/MyTokenCount"
local myTokenAdd_path = title_content_path .. "/Title/MyToken/MyTokenAdd/MyTokenAddBtn"
local noAlliance_path = "Panel/NoAlliance"
local noAllianceDesc_path = noAlliance_path .. "/Bubble/NoAllianceDesc"
local joinAllianceBtn_path = noAlliance_path .. "/JoinAlliance"
local joinAllianceText_path = noAlliance_path .. "/JoinAlliance/JoinAllianceText"
local progress_path = "Panel/Main/Right/Progress"
local progressDesc_path = progress_path .. "/ProgressDesc"
local progressLastTime_path = progress_path .. "/ProgressLastTime"
local progressSlider_path = progress_path .. "/ProgressSlider"
local progressCount_path = progress_path .. "/ProgressCount"
local progressBox_path = progress_path .. "/ProgressBox"
local progressStage_path = progress_path .. "/ProgressStageBg/ProgressStage"
local myOrderBg_path = "Panel/Main/Right/MyOrderBg"
local myOrder_path = "Panel/Main/Right/MyOrderBg/MyOrder"
local myOrderItemName_path = myOrder_path .. "/MyOrderItemName"
local myOrderItemImage_path = myOrder_path .. "/MyOrderItemImage"
local myOrderResA_path = myOrder_path .. "/MyOrderResList/ResA"
local myOrderResAImage_path = myOrder_path .. "/MyOrderResList/ResA/ResAImage"
local myOrderResACount_path = myOrder_path .. "/MyOrderResList/ResA/ResACount"
local myOrderResB_path = myOrder_path .. "/MyOrderResList/ResB"
local myOrderResBImage_path = myOrder_path .. "/MyOrderResList/ResB/ResBImage"
local myOrderResBCount_path = myOrder_path .. "/MyOrderResList/ResB/ResBCount"
local myOrderSlider_path = myOrder_path .. "/MyOrderSlider"
local myOrderSliderGlow_path = myOrder_path .. "/MyOrderSliderGlow"
local myOrderNeedCount_path = myOrder_path .. "/MyOrderNeedCount"
local myOrderCount_path = myOrder_path .. "/MyOrderCount"
local myOrderHave_path = myOrder_path .. "/MyOrderHave"
local myOrderRewardDesc_path = myOrder_path .. "/MyOrderRewardDesc"
local myOrderFillBtn_path = myOrder_path .. "/BtnList/MyOrderFillBtn"
local myOrderFillText_path = myOrder_path .. "/BtnList/MyOrderFillBtn/MyOrderFillText"
local myOrderFillRedDot_path = myOrder_path .. "/BtnList/MyOrderFillBtn/MyOrderFillRedDot"
local myOrderCancelBtn_path = myOrder_path .. "/BtnList/MyOrderCancelBtn"
local myOrderCancelText_path = myOrder_path .. "/BtnList/MyOrderCancelBtn/MyOrderCancelText"
local myOrderTakeBtn_path = myOrder_path .. "/BtnList/MyOrderTakeBtn"
local myOrderTakeText_path = myOrder_path .. "/BtnList/MyOrderTakeBtn/MyOrderTakeText"
local myOrderCompleteBtn_path = myOrder_path .. "/BtnList/MyOrderCompleteBtn"
local myOrderCompleteText_path = myOrder_path .. "/BtnList/MyOrderCompleteBtn/MyOrderCompleteText"
local storageShopGo_path = myOrder_path .. "/UIStorageShopGo"
local goto_btn_path = myOrder_path .. "/GotoBtn"
local myOrderEmpty_path = "Panel/Main/Right/MyOrderBg/MyOrderEmpty"
local myOrderEmptyTitle_path = myOrderEmpty_path .. "/MyOrderEmptyTitle"
local myOrderEmptyDesc_path = myOrderEmpty_path .. "/MyOrderEmptyDesc"
local myOrderGlow_path = myOrderBg_path .. "/MyOrderGlow"
local orderList_path = "Panel/Main/Left/OrderList"
local orderListScroll_path = orderList_path .. "/OrderListScroll"
local orderListContent_path = orderList_path .. "/OrderListScroll/OrderListContent"
local preview_path = "Panel/Main/Right/Preview"
local previewScroll_path = preview_path .. "/PreviewScroll"
local previewDesc_path = preview_path .. "/PreviewDesc"
local previewFinish_path = preview_path .. "/PreviewFinish"
local previewClose_path = preview_path .. "/PreviewClose"
local showRank_path = preview_path .. "/ShowRank"
local showRankText_path = preview_path .. "/ShowRank/ShowRankText"
local fillTip_path = myOrderBg_path .. "/FillTip"
local fillTipIcon_path = fillTip_path .. "/FillTipIcon"
local fillTipCount_path = fillTip_path .. "/FillTipCount"
local extra_effect_path = "Panel/UIExtraEffect"
local OrderListItemHeight = 236
local MyOrderBtnLeftPosX = 79
local MyOrderBtnCenterPosX = 158
local MyOrderBtnRightPosX = 237
local TOKEN_ITEM_ID = 210153

function AllianceOrder:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function AllianceOrder:OnDestroy()
  DataCenter.DailyActivityManager:UpdateActViewHistory(7)
  self:StopTimer()
  self:ClearOrderListScroll()
  self:ClearPreviewScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function AllianceOrder:StopTimer()
  if self.tokenTimer then
    self.tokenTimer:Stop()
  end
  if self.actTimer then
    self.actTimer:Stop()
  end
end

function AllianceOrder:OnEnable()
  base.OnEnable(self)
  self.active = true
  self.myOrderBg_anim:SetActive(false)
  self.myOrder_anim:SetActive(false)
  self.myOrderEmpty_anim:SetActive(false)
  self.myOrderTake_btn:SetActive(false)
  self.myOrderFill_btn:SetActive(false)
  self.myOrderGlow_go:SetActive(false)
  self.myOrderSliderGlow_go:SetActive(false)
  self.myOrderCancel_btn:SetActive(false)
  self.myOrderComplete_btn:SetActive(false)
  self.progress_go:SetActive(false)
  self.orderList_go:SetActive(false)
  self.fillTip_go:SetActive(false)
  self.extra_effect:SetData(HeroStationEffectType.GlobalMoney, self, function()
    self.view.ctrl:CloseSelf()
  end)
  self:TryCheckOrder()
  if not string.IsNullOrEmpty(LuaEntry.Player.allianceId) then
    Manager:SendMessageGetInfo()
  else
    self:RefreshAll(false)
  end
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(Manager.actData.id)
  self:TryDisplayWelcome()
end

function AllianceOrder:OnDisable()
  self:UnselectItem()
  self.active = false
  base.OnDisable(self)
end

function AllianceOrder:DataDefine()
  self.act = nil
  self.selectedOrderUuid = -1
  self.fillingOrder = nil
  self.tokenTimer = nil
  self.actTimer = nil
  self.orderListItems = {}
  self.haveCountCache = 0
  self.active = false
  self.tween = nil
end

function AllianceOrder:DataDestroy()
  self.act = nil
  self.selectedOrderUuid = nil
  self.fillingOrder = nil
  self.tokenTimer = nil
  self.actTimer = nil
  self.orderListItems = nil
  self.haveCountCache = nil
  self.active = nil
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
end

function AllianceOrder:ComponentDefine()
  self.blackMask_go = self:AddComponent(UIBaseContainer, blackMask_path)
  self.blackMask_go:SetActive(false)
  self.main_go = self:AddComponent(UIBaseContainer, main_path)
  self.title_content_go = self:AddComponent(UIBaseContainer, title_content_path)
  self.title_text = self:AddComponent(UIText, title_path)
  self.title_text:SetLocalText(Manager.actData.name)
  self.intro_btn = self:AddComponent(UIButton, intro_path)
  self.intro_btn:SetOnClick(function()
    UIUtil.ShowIntro(Localization:GetString(tostring(Manager.actData.name)), Localization:GetString("100239"), Localization:GetString(tostring(Manager.actData.story)))
  end)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.title_text.transform.parent)
  self.showRank_btn = self:AddComponent(UIButton, showRank_path)
  self.showRank_btn:SetOnClick(function()
    self:ShowRank()
  end)
  self.showRank_text = self:AddComponent(UIText, showRankText_path)
  self.showRank_text:SetLocalText(390040)
  self.noAlliance_go = self:AddComponent(UIBaseContainer, noAlliance_path)
  self.noAllianceDesc_text = self:AddComponent(UIText, noAllianceDesc_path)
  self.noAllianceDesc_text:SetLocalText(371059)
  self.joinAlliance_btn = self:AddComponent(UIButton, joinAllianceBtn_path)
  self.joinAlliance_btn:SetOnClick(function()
    self:JoinAlliance()
  end)
  self.joinAlliance_text = self:AddComponent(UIText, joinAllianceText_path)
  self.joinAlliance_text:SetLocalText(390079)
  self.myToken_go = self:AddComponent(UIBaseContainer, myToken_path)
  self.myTokenInfo_text = self:AddComponent(UIText, myTokenInfo_path)
  self.myTokenInfo_text:SetLocalText(371054)
  self.myTokenCount_text = self:AddComponent(UIText, myTokenCount_path)
  self.myTokenCount_text:SetText("")
  self.myTokenAdd_btn = self:AddComponent(UIButton, myTokenAdd_path)
  self.myTokenAdd_btn:SetOnClick(function()
    self:OnClickAddToken()
  end)
  self.progress_go = self:AddComponent(UIBaseContainer, progress_path)
  self.progressDesc_text = self:AddComponent(UIText, progressDesc_path)
  self.progressDesc_text:SetLocalText(371062)
  self.progressLastTime_text = self:AddComponent(UIText, progressLastTime_path)
  self.progressSlider_slider = self:AddComponent(UISlider, progressSlider_path)
  self.progressSlider_slider:SetInteractable(false)
  self.progressCount_text = self:AddComponent(UIText, progressCount_path)
  self.progressBox_btn = self:AddComponent(UIButton, progressBox_path)
  self.progressBox_btn:SetOnClick(function()
    self:OnClickBox()
  end)
  self.progressBox_anim = self:AddComponent(UIAnimator, progressBox_path)
  self.progressStage_text = self:AddComponent(UIText, progressStage_path)
  self.myOrderBg_anim = self:AddComponent(UIAnimator, myOrderBg_path)
  self.myOrder_anim = self:AddComponent(UIAnimator, myOrder_path)
  self.myOrderItemName_text = self:AddComponent(UIText, myOrderItemName_path)
  self.myOrderItemImage_img = self:AddComponent(UIImage, myOrderItemImage_path)
  self.myOrderResA_go = self:AddComponent(UIBaseContainer, myOrderResA_path)
  self.myOrderResA_img = self:AddComponent(UIImage, myOrderResAImage_path)
  self.myOrderResA_text = self:AddComponent(UIText, myOrderResACount_path)
  self.myOrderResB_go = self:AddComponent(UIBaseContainer, myOrderResB_path)
  self.myOrderResB_img = self:AddComponent(UIImage, myOrderResBImage_path)
  self.myOrderResB_text = self:AddComponent(UIText, myOrderResBCount_path)
  self.myOrderSlider_slider = self:AddComponent(UISlider, myOrderSlider_path)
  self.myOrderSlider_slider:SetInteractable(false)
  self.myOrderSliderGlow_go = self:AddComponent(UIBaseContainer, myOrderSliderGlow_path)
  self.myOrderNeedCount_text = self:AddComponent(UIText, myOrderNeedCount_path)
  self.myOrderCount_text = self:AddComponent(UIText, myOrderCount_path)
  self.myOrderHave_text = self:AddComponent(UIText, myOrderHave_path)
  self.myOrderRewardDesc_text = self:AddComponent(UIText, myOrderRewardDesc_path)
  self.myOrderRewardDesc_text:SetLocalText(130065)
  self.myOrderFill_btn = self:AddComponent(UIButton, myOrderFillBtn_path)
  self.myOrderFill_btn:SetOnClick(function()
    self:FillOrder()
  end)
  self.myOrderFill_text = self:AddComponent(UIText, myOrderFillText_path)
  self.myOrderFill_text:SetLocalText(371064)
  self.myOrderFillRedDot_go = self:AddComponent(UIBaseContainer, myOrderFillRedDot_path)
  self.myOrderCancel_btn = self:AddComponent(UIButton, myOrderCancelBtn_path)
  self.myOrderCancel_btn:SetOnClick(function()
    self:ShowGiveUp()
  end)
  self.myOrderCancel_text = self:AddComponent(UIText, myOrderCancelText_path)
  self.myOrderCancel_text:SetLocalText(110075)
  self.myOrderTake_btn = self:AddComponent(UIButton, myOrderTakeBtn_path)
  self.myOrderTake_btn:SetOnClick(function()
    self:TakeOrder()
  end)
  self.myOrderTake_text = self:AddComponent(UIText, myOrderTakeText_path)
  self.myOrderTake_text:SetLocalText(371058)
  self.myOrderComplete_btn = self:AddComponent(UIButton, myOrderCompleteBtn_path)
  self.myOrderComplete_btn:SetOnClick(function()
    self:TakeAndFillOrder()
  end)
  self.myOrderComplete_text = self:AddComponent(UIText, myOrderCompleteText_path)
  self.myOrderComplete_text:SetLocalText(110009)
  self.myOrderEmpty_anim = self:AddComponent(UIAnimator, myOrderEmpty_path)
  self.myOrderEmptyTitle_text = self:AddComponent(UIText, myOrderEmptyTitle_path)
  self.myOrderEmptyTitle_text:SetLocalText(371084)
  self.myOrderEmptyDesc_text = self:AddComponent(UIText, myOrderEmptyDesc_path)
  self.myOrderEmptyDesc_text:SetLocalText(371075)
  self.myOrderGlow_go = self:AddComponent(UIBaseContainer, myOrderGlow_path)
  self.storageShopGo = self:AddComponent(UIStorageShopGo, storageShopGo_path)
  self.storageShopGo:ReInit()
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.goto_btn:SetOnClick(function()
    local orderTemplate = Manager:GetOrderTemplateByUuid(self.selectedOrderUuid) or Manager:GetMyOrderTemplate()
    if orderTemplate ~= nil then
      GoToUtil.GotoColdStorage(orderTemplate.product_id)
    end
  end)
  self.orderList_go = self:AddComponent(UIBaseContainer, orderList_path)
  self.orderListScroll_go = self:AddComponent(UIBaseContainer, orderListScroll_path)
  self.orderListContent_sv = self:AddComponent(GridInfinityScrollView, orderListContent_path)
  local OnInitOrderListCell = BindCallback(self, self.OnInitOrderListCell)
  local OnUpdateOrderListCell = BindCallback(self, self.OnUpdateOrderListCell)
  local OnDestroyOrderListCell = BindCallback(self, self.OnDestroyOrderListCell)
  self.orderListContent_sv:Init(OnInitOrderListCell, OnUpdateOrderListCell, OnDestroyOrderListCell)
  self.preview_anim = self:AddComponent(UIAnimator, preview_path)
  self.previewScroll_scroll = self:AddComponent(UIScrollView, previewScroll_path)
  self.previewScroll_scroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreatePreviewCell(itemObj, index)
  end)
  self.previewScroll_scroll:SetOnItemMoveOut(function(itemObj, _)
    self:OnDeletePreviewCell(itemObj)
  end)
  self.previewDesc_text = self:AddComponent(UIText, previewDesc_path)
  self.previewFinish_text = self:AddComponent(UIText, previewFinish_path)
  self.previewFinish_text:SetLocalText(371081)
  self.previewClose_btn = self:AddComponent(UIButton, previewClose_path)
  self.previewClose_btn:SetOnClick(function()
    self:ShowPreview(false)
  end)
  self.fillTip_go = self:AddComponent(UIBaseContainer, fillTip_path)
  self.fillTip_img = self:AddComponent(UIImage, fillTipIcon_path)
  self.fillTip_text = self:AddComponent(UIText, fillTipCount_path)
  self.extra_effect = self:AddComponent(UIExtraEffect, extra_effect_path)
end

function AllianceOrder:ComponentDestroy()
  self.blackMask_go = nil
  self.main_go = nil
  self.title_content_go = nil
  self.title_text = nil
  self.showRank_btn = nil
  self.showRank_text = nil
  self.noAlliance_go = nil
  self.noAllianceDesc_text = nil
  self.joinAlliance_btn = nil
  self.joinAlliance_text = nil
  self.myToken_go = nil
  self.myTokenInfo_text = nil
  self.myTokenCount_text = nil
  self.progress_go = nil
  self.progressDesc_text = nil
  self.progressLastTime_text = nil
  self.progressSlider_slider = nil
  self.progressCount_text = nil
  self.progressBox_btn = nil
  self.progressBox_anim = nil
  self.progressStage_text = nil
  self.myOrderBg_anim = nil
  self.myOrder_anim = nil
  self.myOrderItemName_text = nil
  self.myOrderItemImage_img = nil
  self.myOrderResA_go = nil
  self.myOrderResA_img = nil
  self.myOrderResA_text = nil
  self.myOrderResB_go = nil
  self.myOrderResB_img = nil
  self.myOrderResB_text = nil
  self.myOrderSlider_slider = nil
  self.myOrderSliderGlow_go = nil
  self.myOrderCount_text = nil
  self.myOrderHave_text = nil
  self.myOrderRewardDesc_text = nil
  self.myOrderFill_btn = nil
  self.myOrderFill_text = nil
  self.myOrderFillRedDot_go = nil
  self.myOrderCancel_btn = nil
  self.myOrderCancel_text = nil
  self.myOrderTake_btn = nil
  self.myOrderTake_text = nil
  self.myOrderEmpty_anim = nil
  self.myOrderGlow_go = nil
  self.storageShopGo = nil
  self.orderList_go = nil
  self.orderListScroll_go = nil
  self.orderListContent_sv = nil
  self.preview_anim = nil
  self.previewScroll_scroll = nil
  self.previewDesc_text = nil
  self.fillTip_go = nil
  self.fillTip_img = nil
  self.fillTip_text = nil
  self.extra_effect = nil
end

function AllianceOrder:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceOrderGetInfo, self.OnGetInfo)
  self:AddUIListener(EventId.AllianceOrderReceive, self.OnReceive)
  self:AddUIListener(EventId.AllianceOrderGiveUp, self.OnGiveUp)
  self:AddUIListener(EventId.AllianceOrderFill, self.OnFill)
  self:AddUIListener(EventId.AllianceOrderGetReward, self.OnGetReward)
  self:AddUIListener(EventId.AllianceOrderAddToken, self.OnAddToken)
  self:AddUIListener(EventId.END_SEARCH, self.FindMonsterEnd)
  self:AddUIListener(EventId.CloseUI, self.RefreshMyOrder)
end

function AllianceOrder:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceOrderGetInfo, self.OnGetInfo)
  self:RemoveUIListener(EventId.AllianceOrderReceive, self.OnReceive)
  self:RemoveUIListener(EventId.AllianceOrderGiveUp, self.OnGiveUp)
  self:RemoveUIListener(EventId.AllianceOrderFill, self.OnFill)
  self:RemoveUIListener(EventId.AllianceOrderGetReward, self.OnGetReward)
  self:RemoveUIListener(EventId.AllianceOrderAddToken, self.OnAddToken)
  self:RemoveUIListener(EventId.END_SEARCH, self.FindMonsterEnd)
  self:RemoveUIListener(EventId.CloseUI, self.RefreshMyOrder)
end

function AllianceOrder:FindMonsterEnd(param)
  local worldPosition = SceneUtils.TileIndexToWorld(param.pointId)
  WorldArrowManager:GetInstance():ShowArrowEffect(param.uuid, worldPosition, ArrowType.Monster)
  GoToUtil.GotoPos(worldPosition, CS.SceneManager.World.InitZoom)
  GoToUtil.CloseAllWindows()
end

function AllianceOrder:OnInitOrderListCell(go, index)
  local item = self.orderListScroll_go:AddComponent(UIOrderListItem, go)
  item:SetType(EnumActivity.AllianceOrder.Type)
  self.orderListItems[go] = item
end

function AllianceOrder:OnUpdateOrderListCell(go, index)
  local item = self.orderListItems[go]
  go.name = index
  local orderInfo = self:GetOrderInfo()
  local data = orderInfo.orderList[index + 1]
  data.selected = self.selectedOrderUuid == data.uuid
  item.view = self
  item:SetData(data)
  item:SetSelection(data.selected)
  item:SetOnClick(self.OnClickItem)
end

function AllianceOrder:OnDestroyOrderListCell(go, index)
end

function AllianceOrder:ReInitOrderListScroll()
  local orderInfo = self:GetOrderInfo()
  local count = #orderInfo.orderList
  self.orderListContent_sv:SetItemCount(count)
  self.orderListContent_sv:MoveItemByIndex(0, 0)
end

function AllianceOrder:ClearOrderListScroll()
  self.orderListScroll_go:RemoveComponents(UIOrderListItem)
  self.orderListContent_sv:DestroyChildNode()
end

function AllianceOrder:OnCreatePreviewCell(itemObj, index)
  itemObj.name = "PreviewItem_" .. index
  local item = self.previewScroll_scroll:AddComponent(UIPreviewItem, itemObj)
  local stageReward = Manager:GetStageReward()
  if stageReward then
    local data = stageReward.rewards[index]
    item:SetData(data)
  end
end

function AllianceOrder:OnDeletePreviewCell(itemObj)
  self.previewScroll_scroll:RemoveComponent(itemObj.name, UIPreviewItem)
end

function AllianceOrder:ReinitPreviewScroll()
  self:ClearPreviewScroll()
  local stageReward = Manager:GetStageReward()
  if stageReward then
    local count = #stageReward.rewards
    self.previewScroll_scroll:SetTotalCount(count)
    if 0 < count then
      self.previewScroll_scroll:RefillCells()
    end
  end
end

function AllianceOrder:ClearPreviewScroll()
  self.previewScroll_scroll:ClearCells()
  self.previewScroll_scroll:RemoveComponents(UIPreviewItem)
end

function AllianceOrder:GetOrderInfo()
  return Manager.orderInfo
end

function AllianceOrder:SelectItem(uuid)
  self:UnselectItem()
  local item = self:GetItem(uuid)
  if item then
    item:SetSelection(true)
  end
  self.selectedOrderUuid = uuid
end

function AllianceOrder:UnselectItem()
  local item = self:GetSelectedItem()
  if item then
    item:SetSelection(false)
  end
  self.selectedOrderUuid = -1
end

function AllianceOrder:GetSelectedItem()
  return self:GetItem(self.selectedOrderUuid)
end

function AllianceOrder:GetItem(uuid)
  for _, item in pairs(self.orderListItems) do
    if item.data and item.data.uuid == uuid then
      return item
    end
  end
  return nil
end

function AllianceOrder:ScrollToItem(uuid)
  local rowCount = (#self:GetOrderInfo().orderList + 3) // 4
  local row = Manager:GetOrderIndex(uuid) // 4
  local targetRow
  local pos = self.orderListContent_sv.transform.localPosition
  if row < rowCount - 2 then
    targetRow = row
    pos.y = targetRow * OrderListItemHeight
  else
    targetRow = rowCount - 3
    pos.y = targetRow * OrderListItemHeight + 83
  end
  self.orderListContent_sv.transform.localPosition = pos
  self.orderListContent_sv:ForceUpdate()
  return targetRow
end

function AllianceOrder:OrderListAppear(startRow)
  for _, item in pairs(self.orderListItems) do
    if item.data then
      item:Appear(startRow)
    end
  end
end

function AllianceOrder:OnClickItem(item)
  if self.tween then
    self.tween:Kill()
    self.tween = nil
    self:FillAnimCallback(self.fillingUuid)
  end
  if item:IsTaken() and not item:IsMine() then
    UIUtil.ShowTipsId(371070)
  elseif item:IsCompleted() then
    UIUtil.ShowTipsId(371074)
  else
    self:SelectItem(item.data.uuid)
    self:RefreshMyOrder()
  end
end

function AllianceOrder:OnGetInfo()
  if not self.active then
    return
  end
  self:RefreshAll(true)
end

function AllianceOrder:OnReceive(uuid)
  if not self.active then
    return
  end
  self:RefreshMyOrder()
  self:RefreshMyToken()
  self:RefreshProgress()
  self:RefreshItem(uuid)
end

function AllianceOrder:OnGiveUp(uuid)
  if not self.active then
    return
  end
  self:RefreshMyOrder()
  self:RefreshProgress()
  self:RefreshItem(uuid)
end

function AllianceOrder:OnFill(uuid)
  if not self.active then
    return
  end
  local orderTemplate = Manager:GetOrderTemplateByUuid(uuid)
  local order = Manager:GetOrder(uuid)
  self:ShowFillTip()
  self:IncreaseMyOrderSlider(order.fill, orderTemplate.product_num, function()
    self:FillAnimCallback(uuid)
  end)
  self.fillingUuid = uuid
end

function AllianceOrder:FillAnimCallback(uuid)
  local order = Manager:GetOrder(uuid)
  local flipItem
  if order.state == 2 then
    flipItem = self:GetSelectedItem()
    self:FlyReward(uuid)
    self:UnselectItem()
    self.myOrderGlow_go:SetActive(false)
    self:ShowButton(self.myOrderFill_btn, false)
    self:ShowButton(self.myOrderCancel_btn, false)
    self.myOrderGlow_go:SetActive(true)
  end
  self:RefreshMyOrder()
  self:RefreshMyToken()
  self:RefreshProgress()
  self:RefreshSameResItems(uuid)
  if flipItem then
    flipItem:Flip()
  end
end

function AllianceOrder:OnGetReward()
  if not self.active then
    return
  end
  self:RefreshMyOrder()
  self:RefreshProgress()
  self:RefreshPreview()
end

function AllianceOrder:OnAddToken()
  if not self.active then
    return
  end
  self:RefreshMyToken()
end

function AllianceOrder:RefreshSameResItems(uuid)
  local targetOrderTemplate = Manager:GetOrderTemplateByUuid(uuid)
  local orderInfo = self:GetOrderInfo()
  for _, order in pairs(orderInfo.orderList) do
    local orderTemplate = Manager:GetOrderTemplate(order.orderId)
    if orderTemplate.product_id == targetOrderTemplate.product_id then
      self:RefreshItem(order.uuid)
    end
  end
end

function AllianceOrder:RefreshItem(uuid)
  local order = Manager:GetOrder(uuid)
  local item = self:GetItem(uuid)
  if item then
    item:SetData(order)
    item:SetSelection(uuid == self.selectedOrderUuid)
  end
end

function AllianceOrder:RefreshMyToken()
  local orderInfo = self:GetOrderInfo()
  if orderInfo.token > 0 then
    self.myTokenInfo_text:SetLocalText(371054)
    self.myTokenCount_text:SetText(orderInfo.token .. "/" .. orderInfo.tokenMax)
  else
    if self.tokenTimer then
      self.tokenTimer:Stop()
      self.tokenTimer = nil
    end
    
    local function TokenTimeAction()
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local restTime = math.floor(orderInfo.tokenRefreshTime - curTime)
      local restTimeStr = CS.GameEntry.Timer:MilliSecondToFmtString(restTime)
      if 0 <= restTime then
      else
        if self.tokenTimer then
          self.tokenTimer:Stop()
          self.tokenTimer = nil
        end
        Manager:SendMessageGetInfo()
      end
    end
    
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local restTime = math.floor(orderInfo.tokenRefreshTime - curTime)
    local restTimeStr = CS.GameEntry.Timer:MilliSecondToFmtString(restTime)
    self.myTokenInfo_text:SetLocalText(371054)
    self.myTokenCount_text:SetText(orderInfo.token .. "/" .. orderInfo.tokenMax)
    self.tokenTimer = TimerManager:GetInstance():GetTimer(0.5, TokenTimeAction, self, false, false, false)
    self.tokenTimer:Start()
  end
end

function AllianceOrder:RefreshProgress(ignoreSlider)
  local orderInfo = self:GetOrderInfo()
  local stageReward = Manager:GetStageReward()
  self.progress_go:SetActive(true)
  local playBoxAnim, sliderValue, countText, stageText
  if stageReward then
    local cur = orderInfo.allianceFinish
    local max = stageReward.needAllianceFinish
    playBoxAnim = cur >= max
    sliderValue = cur / max
    countText = cur .. "/" .. max
    stageText = stageReward.stage - 1 .. "/" .. #orderInfo.stageRewardList
  else
    playBoxAnim = false
    sliderValue = 1
    countText = "MAX"
    stageText = #orderInfo.stageRewardList .. "/" .. #orderInfo.stageRewardList
  end
  self.progressBox_anim:Play(playBoxAnim and "V_progress_box" or "V_progress_box_idle", 0, 0)
  self.progressCount_text:SetText(countText)
  self.progressStage_text:SetText(stageText)
  if not ignoreSlider then
    self.progressSlider_slider:SetValue(sliderValue)
  end
  if self.actTimer then
    self.actTimer:Stop()
    self.actTimer = nil
  end
  
  local function ActTimeAction()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local restTime = math.max(math.floor(Manager.actData.endTime - curTime), 0)
    local restTimeStr = CS.GameEntry.Timer:MilliSecondToFmtString(restTime)
    self.progressLastTime_text:SetLocalText(371061, restTimeStr)
    if restTime <= 0 then
      if self.actTimer then
        self.actTimer:Stop()
        self.actTimer = nil
      end
      self.progressLastTime_text:SetText("Activity ended")
    end
  end
  
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local restTime = math.max(math.floor(Manager.actData.endTime - curTime), 0)
  local restTimeStr = CS.GameEntry.Timer:MilliSecondToFmtString(restTime)
  self.progressLastTime_text:SetLocalText(371061, restTimeStr)
  self.actTimer = TimerManager:GetInstance():GetTimer(1, ActTimeAction, self, false, false, false)
  self.actTimer:Start()
end

function AllianceOrder:RefreshMyOrder()
  if self.tween and self.tween:IsPlaying() then
    return
  end
  local orderTemplate = Manager:GetOrderTemplateByUuid(self.selectedOrderUuid) or Manager:GetMyOrderTemplate()
  local order = Manager:GetMyOrder()
  local hasTakenOrder = order and order.uuid == self.selectedOrderUuid
  if not orderTemplate then
    self:ShowMyOrder(false)
    return
  end
  self:ShowMyOrder(true)
  self:ShowButton(self.myOrderFill_btn, hasTakenOrder)
  self:ShowButton(self.myOrderCancel_btn, hasTakenOrder)
  self.myOrderSlider_slider:SetActive(hasTakenOrder)
  self.myOrderNeedCount_text:SetActive(not hasTakenOrder)
  self.myOrderCount_text:SetActive(hasTakenOrder)
  local resTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(orderTemplate.product_id)
  local resData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(orderTemplate.product_id)
  local haveCount = resData and resData.number or 0
  if hasTakenOrder then
    local cur = order.fill or 0
    local max = orderTemplate.product_num
    self.myOrderSlider_slider:SetValue(cur / max)
    self.myOrderCount_text:SetText(cur .. "/" .. max)
    self:ShowButton(self.myOrderTake_btn, false)
    self:ShowButton(self.myOrderComplete_btn, false)
    self.myOrderFillRedDot_go:SetActive(0 < haveCount)
  else
    self.myOrderSlider_slider:SetValue(0)
    self.myOrderNeedCount_text:SetText("x" .. orderTemplate.product_num)
    self:ShowButton(self.myOrderTake_btn, not order)
    self:ShowButton(self.myOrderComplete_btn, not order and haveCount >= orderTemplate.product_num)
    local pos = self.myOrderTake_btn:GetAnchoredPosition()
    pos.x = haveCount >= orderTemplate.product_num and MyOrderBtnLeftPosX or MyOrderBtnCenterPosX
    self.myOrderTake_btn:SetAnchoredPosition(pos)
  end
  self.myOrderItemName_text:SetLocalText(resTemplate.name)
  self.myOrderItemImage_img:LoadSprite(string.format(LoadPath.ItemPath, resTemplate.pic))
  self.myOrderHave_text:SetLocalText(371055, haveCount)
  if not string.IsNullOrEmpty(orderTemplate.money) then
    local money = orderTemplate.money
    money = DataCenter.HeroStationManager:CalcEffectedValue(money, HeroStationEffectType.GlobalMoney)
    money = Mathf.Round(money)
    self.myOrderResA_img:LoadSprite(string.format(LoadPath.ItemPath, "item2003"))
    self.myOrderResA_text:SetText(money)
    self.myOrderResB_go:SetActive(false)
  else
    self.myOrderResB_go:SetActive(true)
  end
end

function AllianceOrder:RefreshOrderList()
  self.orderList_go:SetActive(true)
  self:ReInitOrderListScroll()
end

function AllianceOrder:RefreshPreview()
  local stageReward = Manager:GetStageReward()
  if stageReward then
    self.previewDesc_text:SetActive(true)
    self.previewScroll_scroll:SetActive(true)
    self.previewFinish_text:SetActive(false)
    self.previewDesc_text:SetLocalText(371073, stageReward.needAllianceFinish)
    self:ReinitPreviewScroll()
  else
    self.previewDesc_text:SetActive(false)
    self.previewScroll_scroll:SetActive(false)
    self.previewFinish_text:SetActive(true)
  end
end

function AllianceOrder:RefreshAll(hasAlliance)
  self:ShowNoAlliance(not hasAlliance)
  self:ShowPreview(false)
  if hasAlliance then
    local order = Manager:GetMyOrder()
    if order then
      self:SelectItem(order.uuid)
    end
    self:RefreshMyToken()
    self:RefreshProgress()
    self:RefreshMyOrder()
    self:RefreshOrderList()
    self:RefreshPreview()
    local startRow = 0
    if order then
      startRow = self:ScrollToItem(order.uuid)
    end
    self:OrderListAppear(startRow)
  end
end

function AllianceOrder:ShowNoAlliance(show)
  self.noAlliance_go:SetActive(show)
  self.main_go:SetActive(not show)
end

function AllianceOrder:ShowMyOrder(show)
  local function InternalShow(g, s, a)
    if s and not g:GetActiveInHierarchy() then
      g:SetActive(true)
      
      if a then
        g:Play("V_shangcheng_myoder_chuxian", 0, 0)
      end
    elseif not s and g:GetActiveInHierarchy() then
      g:SetActive(false)
    end
  end
  
  if not self.myOrderBg_anim:GetActiveInHierarchy() then
    self.myOrderBg_anim:SetActive(true)
    self.myOrderBg_anim:Play("V_shangcheng_myoder_chuxian", 0, 0)
    InternalShow(self.myOrder_anim, show, false)
    InternalShow(self.myOrderEmpty_anim, not show, false)
  else
    InternalShow(self.myOrder_anim, show, false)
    InternalShow(self.myOrderEmpty_anim, not show, true)
  end
end

function AllianceOrder:ShowButton(btn, show)
  if show and not btn:GetActiveInHierarchy() then
    btn:SetActive(true)
  elseif not show and btn:GetActiveInHierarchy() then
    btn:SetActive(false)
  end
end

function AllianceOrder:ShowGiveUp()
  UIUtil.ShowMessage(Localization:GetString("371065"), 2, GameDialogDefine.CANCEL, GameDialogDefine.CONFIRM, nil, function()
    self:GiveUpOrder()
  end, nil, "371080")
end

function AllianceOrder:ShowPreview(show)
  local active = self.preview_anim:GetActiveInHierarchy()
  if show and not active then
    self.preview_anim:SetActive(true)
    self.preview_anim:Play("CommonPopup_movein", 0, 0)
  elseif not show and active then
    self.preview_anim:SetActive(false)
  end
end

function AllianceOrder:ShowRank()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIRankDetailList, {anim = true}, RankType.AllianceOrder)
end

function AllianceOrder:OnClickBox()
  local orderInfo = self:GetOrderInfo()
  local stageReward = Manager:GetStageReward()
  if Manager:HasFinishedAlliance() then
    if Manager:HasFinishedSelf() then
      Manager:SendMessageGetReward(orderInfo.stage)
      Manager.redDotData.checkedStageReward = false
      Manager.redDotData.canGetStageReward = false
    else
      UIUtil.ShowTips(Localization:GetString("371072", stageReward.needFinish))
      Manager.redDotData.checkedStageReward = true
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    end
  else
    self:ShowPreview(true)
  end
end

function AllianceOrder:JoinAlliance()
  self.view.ctrl:CloseSelf()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceIntro, {anim = true})
end

function AllianceOrder:FillOrder()
  local order = Manager:GetMyOrder()
  local orderTemplate = Manager:GetMyOrderTemplate()
  local restCount = orderTemplate.product_num - order.fill
  local resData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(orderTemplate.product_id)
  local haveCount = resData and resData.number or 0
  self.haveCountCache = haveCount
  local fillCount = math.min(restCount, haveCount)
  if 0 < fillCount then
    Manager:SendMessageFill(resData.uuid, order.uuid, fillCount)
    self:SetFillTip(orderTemplate.product_id, fillCount)
  else
    local need = {
      [orderTemplate.product_id] = restCount
    }
    local param = DataCenter.ResourceItemDataManager:GetAllLackResourceItemParams(need, function()
      self.haveCountCache = restCount
      Manager:SendMessageFill(0, order.uuid, restCount)
      self:SetFillTip(orderTemplate.product_id, restCount)
    end)
    if param.canBuy == true and param.totalDiamond > 0 then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_FailClick, false)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceItemLack, {anim = true}, param)
    end
  end
end

function AllianceOrder:GiveUpOrder()
  local order = Manager:GetMyOrder()
  Manager:SendMessageGiveUp(order.uuid)
end

function AllianceOrder:TakeOrder()
  local orderInfo = self:GetOrderInfo()
  if orderInfo.token > 0 then
    Manager:SendMessageReceive(self.selectedOrderUuid)
  else
    UIUtil.ShowTipsId(371071)
  end
end

function AllianceOrder:TakeAndFillOrder()
  local orderInfo = self:GetOrderInfo()
  local order = Manager:GetOrder(self.selectedOrderUuid)
  local orderTemplate = Manager:GetOrderTemplateByUuid(self.selectedOrderUuid)
  local restCount = orderTemplate.product_num - order.fill
  local resData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(orderTemplate.product_id)
  local haveCount = resData and resData.number or 0
  self.haveCountCache = haveCount
  local fillCount = math.min(restCount, haveCount)
  if 0 < orderInfo.token then
    Manager:SendMessageReceiveAndFill(self.selectedOrderUuid)
    self:SetFillTip(orderTemplate.product_id, fillCount)
  else
    UIUtil.ShowTipsId(371071)
  end
end

function AllianceOrder:FlyReward(uuid)
  local orderTemplate = Manager:GetOrderTemplateByUuid(uuid)
  if not string.IsNullOrEmpty(orderTemplate.money) then
    local moneyTemplate = DataCenter.ResourceTemplateManager:GetResourceTemplate(ResourceType.Food)
    UIUtil.DoFly(RewardType.FOOD, 5, moneyTemplate.icon, self.myOrderResA_img.transform.position, VecZero)
  else
  end
end

function AllianceOrder:SetFillTip(resId, count)
  local resTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(resId)
  self.fillTip_img:LoadSprite(string.format(LoadPath.ItemPath, resTemplate.pic))
  self.fillTip_text:SetText("-" .. count)
end

function AllianceOrder:ShowFillTip()
  self.fillTip_go:SetActive(false)
  self.fillTip_go:SetActive(true)
end

function AllianceOrder:TryDisplayWelcome()
  if DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.UIPanel, "activity_alliance_order") then
    self.blackMask_go:SetActive(true)
    DataCenter.GuideManager:SetGuideEndCallBack(function()
      self.blackMask_go:SetActive(false)
    end)
  end
end

function AllianceOrder:TryCheckOrder()
  local orderTemplate = Manager:GetMyOrderTemplate()
  if orderTemplate then
    local resData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(orderTemplate.product_id)
    local haveCount = resData and resData.number or 0
    if 0 < haveCount then
      Manager.redDotData.checkedOrder = true
    end
  end
end

function AllianceOrder:IncreaseMyOrderSlider(endValue, maxValue, callback)
  self.myOrderSliderGlow_go:SetActive(false)
  self.myOrderSlider_slider:SetActive(true)
  self.myOrderCount_text:SetActive(true)
  self.myOrderNeedCount_text:SetActive(false)
  local startValue = math.floor(self.myOrderSlider_slider:GetValue() * maxValue + 0.5)
  
  local function Getter()
    return startValue
  end
  
  local function Setter(x)
    if self.myOrderSlider_slider then
      local value = math.floor(x + 0.5)
      local delta = value - startValue
      self.myOrderSlider_slider:SetValue(value / maxValue)
      self.myOrderCount_text:SetText(value .. "/" .. maxValue)
      self.myOrderHave_text:SetLocalText(371055, self.haveCountCache - delta)
    end
  end
  
  self.tween = DOTween.Sequence():Append(DOTween.To(Getter, Setter, endValue, 0.65)):AppendCallback(function()
    if endValue == maxValue then
      self.myOrderSliderGlow_go:SetActive(true)
    end
  end):AppendInterval(0.35):AppendCallback(function()
    self.tween = nil
    callback()
  end)
end

function AllianceOrder:OnClickAddToken()
  local orderInfo = self:GetOrderInfo()
  local data = DataCenter.ItemData:GetItemById(TOKEN_ITEM_ID)
  local itemCount = data and data.count or 0
  local itemCountStr = "<color=" .. (itemCount == 0 and "red" or "white") .. ">" .. itemCount .. "</color>/1"
  local dataList = {
    [1] = {
      rewardType = RewardType.GOODS,
      itemId = TOKEN_ITEM_ID,
      count = itemCountStr
    }
  }
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local restTime = math.floor(orderInfo.tokenRefreshTime - curTime)
  local restTimeStr = CS.GameEntry.Timer:MilliSecondToFmtString(restTime)
  local topDesc = Localization:GetString("372171", orderInfo.token) .. "/" .. orderInfo.tokenMax
  local bottomDesc = Localization:GetString("372173", math.max(Manager.TOKEN_ADD_MAX - orderInfo.tokenAdded, 0))
  if orderInfo.token < orderInfo.tokenMax then
    topDesc = topDesc .. "\n" .. Localization:GetString("372172", restTimeStr)
  end
  
  local function onConfirm()
    if orderInfo.tokenAdded >= Manager.TOKEN_ADD_MAX then
      UIUtil.ShowTipsId(372176)
    elseif 0 < itemCount then
      Manager:SendMessageAddToken(TOKEN_ITEM_ID, 1)
    else
      UIUtil.ShowMessage(Localization:GetString("372177"), 1, "110003", "", function()
        local packList = GiftPackageData.GetGivenPacks(TOKEN_ITEM_ID)
        if not table.IsNullOrEmpty(packList) then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackage, {anim = true}, {
            targetPackageId = packList[1]:getID()
          })
        else
          UIUtil.ShowTipsId(120080)
        end
      end)
    end
  end
  
  local function timerAction(view)
    local tCurTime = UITimeManager:GetInstance():GetServerTime()
    local tRestTime = math.floor(orderInfo.tokenRefreshTime - tCurTime)
    local tRestTimeStr = CS.GameEntry.Timer:MilliSecondToFmtString(tRestTime)
    local tTopDesc = Localization:GetString("372171", orderInfo.token) .. "/" .. orderInfo.tokenMax
    if orderInfo.token < orderInfo.tokenMax then
      tTopDesc = tTopDesc .. "\n" .. Localization:GetString("372172", tRestTimeStr)
    end
    view.top_desc_text:SetText(tTopDesc)
  end
  
  local param = {
    title = Localization:GetString("372170"),
    topDesc = topDesc,
    bottomDesc = bottomDesc,
    dataList = dataList,
    onConfirm = onConfirm,
    timerAction = timerAction
  }
  UIUtil.ShowUseItemTip(param)
end

return AllianceOrder
