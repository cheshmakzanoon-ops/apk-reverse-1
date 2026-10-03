local UIBusinessCenterResourceItem = require("UI.UIBusinessCenter.Component.UIBusinessCenterResourceItem")
local UIBusinessCenterCell = require("UI.UIBusinessCenter.Component.UIBusinessCenterCell")
local UIBusinessCenterView = BaseClass("UIBusinessCenterView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local return_btn_path = "Return"
local close_btn_path = "safeArea/CloseBtn"
local title_path = "safeArea/panel/title_main"
local end_time_text_path = "safeArea/panel/RightGo/Deliver/Time/TimerText"
local need_item_list_path = "safeArea/panel/RightGo/Deliver/Submit/ResourceItemContent"
local enter_btn_path = "safeArea/panel/RightGo/Deliver/Submit/SendBtn"
local enter_btn_name_path = "safeArea/panel/RightGo/Deliver/Submit/SendBtn/btnTxt_green_big"
local select_go_path = "Business_bg_xuanzhong"
local scroll_view_path = "safeArea/panel/ScrollView"
local submit_content_path = "safeArea/panel/RightGo/Deliver/Submit"
local submitGray_content_path = "safeArea/panel/RightGo/Deliver/Submit/LockGrayBtn"
local submitGray_txt_path = "safeArea/panel/RightGo/Deliver/Submit/LockGrayBtn/btnTxt_LockGraydes"
local count_down_path = "safeArea/panel/RightGo/Deliver/TimeSlider_up"
local count_down_btn_path = "safeArea/panel/RightGo/Deliver/TimeSlider_up/count_down_btn"
local count_down_progress_path = "safeArea/panel/RightGo/Deliver/TimeSlider_up/Fill"
local count_down_progress_text_path = "safeArea/panel/RightGo/Deliver/TimeSlider_up/Count_down_text"
local currentIndex = -1
local delete_btn_path = "safeArea/panel/RightGo/Deliver/Submit/deleteBtn"
local delete_btn_img_path = "safeArea/panel/RightGo/Deliver/Submit/deleteBtn/deleteBtn_img"
local tip_path = "safeArea/panel/RightGo/Deliver/Tip"
local tip_title_path = "safeArea/panel/RightGo/Deliver/Tip/Bg/Title"
local tip_des_path = "safeArea/panel/RightGo/Deliver/Tip/Bg/Des"
local diamondCost_btn_path = "safeArea/panel/RightGo/Deliver/DiamondCost/DiamondCostBtn"
local diamondCost_btn_txt_path = "safeArea/panel/RightGo/Deliver/DiamondCost/DiamondCostBtn/Gold/btnTxt_des"
local diamondCost_btn_costTxt_path = "safeArea/panel/RightGo/Deliver/DiamondCost/DiamondCostBtn/Gold/btnTxt_cost"
local diamondCost_des_txt_path = "safeArea/panel/RightGo/Deliver/DiamondCost/DiamondCostDes"
local diamondCost_content_path = "safeArea/panel/RightGo/Deliver/DiamondCost"
local lock_btn_path = "safeArea/panel/RightGo/Deliver/Lock/LockBtn"
local lock_btn_txt_path = "safeArea/panel/RightGo/Deliver/Lock/LockBtn/btnTxt_lockdes"
local lock_des_txt_path = "safeArea/panel/RightGo/Deliver/Lock/LockDes"
local lock_content_path = "safeArea/panel/RightGo/Deliver/Lock"
local time_content_path = "safeArea/panel/RightGo/Deliver/Time"
local dialog_txt_path = "safeArea/panel/RightGo/tips/DialogLabel"
local extra_effect_path = "safeArea/UIExtraEffect"
local AnimName = {
  Enter = "CommonPopup_movein",
  Exit = "CommonPopup_moveout"
}
local PanelAni = {
  Show = "Business_show",
  Close = "Business_close",
  ResourceItem_show = "UIBusinessCenterResourceItem_show",
  ResourceItem_close = "UIBusinessCenterResourceItem_close",
  ResourceItem_wancheng = "Searching_wancheng"
}
SelectPosition = Vector3.New(0, -136, 0)
local submitPos

local function OnCreate(self)
  base.OnCreate(self)
  self.isArrow = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self:StopNoCanSubmitEffect()
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.need_item_list = self:AddComponent(UIBaseContainer, need_item_list_path)
  self.submit_btn = self:AddComponent(UIButton, enter_btn_path)
  self.submit_btn_name = self:AddComponent(UIText, enter_btn_name_path)
  self.submit_btn_name_shadow = self:AddComponent(UIShadow, enter_btn_name_path)
  if submitPos == nil then
    submitPos = self.submit_btn.transform.localPosition
  end
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.end_time_text = self:AddComponent(UIText, end_time_text_path)
  self.title = self:AddComponent(UIText, title_path)
  self.select_go = self:AddComponent(UIBaseContainer, select_go_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
    DOTween.Restart(PanelAni.Close)
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
    DOTween.Restart(PanelAni.Close)
  end)
  self.submit_btn:SetOnClick(function()
    self:OnSubmitBtnClick()
  end)
  self.submitGray_btn = self:AddComponent(UIBaseContainer, submitGray_content_path)
  self.submitGray_txt = self:AddComponent(UIText, submitGray_txt_path)
  self.submitGray_txt_shadow = self:AddComponent(UIShadow, submitGray_txt_path)
  self.tip = self:AddComponent(UIBaseContainer, tip_path)
  self.tip_title = self:AddComponent(UIText, tip_title_path)
  self.tip_des = self:AddComponent(UIText, tip_des_path)
  self.tip_anim = self:AddComponent(UIAnimator, tip_path)
  self.delete_btn = self:AddComponent(UIButton, delete_btn_path)
  self.delete_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnDeleteBtnClick()
  end)
  self.delete_btn_img = self:AddComponent(UIImage, delete_btn_img_path)
  self.diamondCost_btn = self:AddComponent(UIButton, diamondCost_btn_path)
  self.diamondCost_btn_txt = self:AddComponent(UIText, diamondCost_btn_txt_path)
  self.diamondCost_btn_costTxt = self:AddComponent(UIText, diamondCost_btn_costTxt_path)
  self.diamondCost_des_txt = self:AddComponent(UIText, diamondCost_des_txt_path)
  self.diamondCost_content = self:AddComponent(UIBaseContainer, diamondCost_content_path)
  self.diamondCost_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnDiamondCostBtnClick()
  end)
  self.lock_btn = self:AddComponent(UIButton, lock_btn_path)
  self.lock_btn_txt = self:AddComponent(UIText, lock_btn_txt_path)
  self.lock_des_txt = self:AddComponent(UIText, lock_des_txt_path)
  self.lock_content = self:AddComponent(UIBaseContainer, lock_content_path)
  self.lock_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnLockBtnClick()
  end)
  self.submit_content = self:AddComponent(UIBaseContainer, submit_content_path)
  self.time_btn = self:AddComponent(UIButton, time_content_path)
  self.time_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnShowTipClick()
  end)
  self.dialog_txt = self:AddComponent(UIText, dialog_txt_path)
  self.count_down = self:AddComponent(UIBaseContainer, count_down_path)
  self.count_down_progress = self:AddComponent(UIImage, count_down_progress_path)
  self.count_down_progress_text = self:AddComponent(UIText, count_down_progress_text_path)
  self.count_down_progress_text:SetLocalText(GameDialogDefine.SUBMIT_ORDER)
  self.count_down_btn = self:AddComponent(UIButton, count_down_btn_path)
  self.count_down_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnCountDownBtnClick()
  end)
  self.extra_effect = self:AddComponent(UIExtraEffect, extra_effect_path)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  if self.select_go ~= nil then
    self.select_go:SetActive(false)
    self.select_go.transform:SetParent(self.transform)
  end
  self.return_btn = nil
  self.need_item_list = nil
  self.submit_btn = nil
  self.submit_btn_name = nil
  self.submit_btn_name_shadow = nil
  self.close_btn = nil
  self.end_time_text = nil
  self.title = nil
  self.select_go = nil
  self.scroll_view = nil
  self.tip = nil
  self.tip_title = nil
  self.tip_des = nil
  self.tip_anim = nil
  self.count_down_btn = nil
  self.delete_btn = nil
  self.delete_btn_img = nil
  self.diamondCost_btn = nil
  self.diamondCost_btn_txt = nil
  self.diamondCost_btn_costTxt = nil
  self.diamondCost_des_txt = nil
  self.diamondCost_content = nil
  self.lock_btn = nil
  self.lock_btn_txt = nil
  self.lock_des_txt = nil
  self.lock_content = nil
  self.submit_content = nil
  self.time_btn = nil
  self.dialog_txt = nil
  self.count_down = nil
  self.count_down_progress_text = nil
  self.count_down_progress = nil
  self.extra_effect = nil
end

local function DataDefine(self)
  self.index = 1
  self.list = {}
  self.orderUuid = nil
  self.leftText = Localization:GetString(GameDialogDefine.LEFT_TIME)
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self.endTime = 0
  self.orderId = -1
  self.template = nil
  self.needResourceItemCells = {}
  self.freeNeedResourceItemCells = {}
  self.loadingCell = {}
  self.isRed = false
  self.cells = {}
  self.isPlaySubAnim = false
  self.submitTimer = nil
  self.isDoEnterAnim = true
  self.isShowAnim = false
  self.seletIndex = 0
  self.leftTime = 0
  self.state = PurchaseOrderState.NORMAL
  self.isDelete = false
  self.changeIndex = 0
  self.hasCoolDown = 0 < DataCenter.ResidentOrderDataManager:GetOrderSendLeftTime()
end

local function DataDestroy(self)
  DataCenter.ResidentOrderDataManager.selectUuid = self.orderUuid
  self.index = nil
  self.list = nil
  self.orderUuid = nil
  self.leftText = nil
  self.timer_action = nil
  self:DeleteSubTimer()
  self:DeleteTimer()
  self.endTime = nil
  self.orderId = nil
  self.state = nil
  self.template = nil
  self.needResourceItemCells = nil
  self.freeNeedResourceItemCells = nil
  self.loadingCell = nil
  self.isRed = nil
  self.cells = nil
  self.isPlaySubAnim = nil
  self.submitTimer = nil
  self.isDoEnterAnim = false
  self.isShowAnim = false
  self.leftTime = nil
  self.isDelete = nil
  self.changeIndex = nil
  self.hasCoolDown = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.isDoEnterAnim = true
  self.title:SetLocalText(GameDialogDefine.BUSINESS_CENTER)
  self.submit_btn_name:SetLocalText(GameDialogDefine.SUBMIT_ORDER)
  self.tip:SetActive(false)
  self.diamondCost_des_txt:SetLocalText(130419)
  self.diamondCost_btn_txt:SetLocalText(100159)
  self.lock_des_txt:SetLocalText(130420)
  self.lock_btn_txt:SetLocalText(110003)
  self.submitGray_txt:SetLocalText(GameDialogDefine.SUBMIT_ORDER)
  self.dialog_txt:SetLocalText(self:GetWorld())
  self.extra_effect:SetData(HeroStationEffectType.GlobalMoney, self)
  DOTween.Restart(PanelAni.Show)
  self:RefreshResidentOrderSignal()
end

local function RefreshOrder(self)
  self.list = DataCenter.ResidentOrderDataManager:GetOrderList()
  if table.count(self.list) > 0 then
    self:CheckIndex()
    self:RefreshRight()
    if self.isDoEnterAnim == true then
      self:ShowCells()
    end
  else
    return
  end
  self.isDoEnterAnim = false
  if self.isArrow then
    local param = {}
    param.position = self.submit_btn.transform.position
    param.arrowType = ArrowType.Capacity
    param.positionType = PositionType.Screen
    DataCenter.ArrowManager:ShowArrow(param)
    self.isArrow = nil
  end
end

local function RefreshRight(self)
  local info = DataCenter.ResidentOrderDataManager:GetResidentOrderByUuid(self.list[self.index].uuid)
  if info ~= nil then
    self.endTime = info.expTime
    if info.state == PurchaseOrderState.FINISH then
      self.endTime = info.refreshTime
    end
    self.orderId = info.orderId
    self.state = info.state
    self.template = DataCenter.OrderTemplateManager:GetOrderTemplate(info.orderId)
    self.hasCoolDown = DataCenter.ResidentOrderDataManager:GetOrderSendLeftTime() > 0
    if self.template ~= nil then
      self:RefreshTime()
      self:AddTimer()
      self:ShowNeedResourceItems()
    end
    if self.tip:GetActive() then
      self:PlayExitAnim()
    end
    self.submit_content.gameObject:SetActive(false)
    self.diamondCost_content.gameObject:SetActive(false)
    self.lock_content.gameObject:SetActive(false)
    self.time_btn.gameObject:SetActive(false)
    local showDelete = tonumber(LuaEntry.Effect:GetGameEffect(EffectDefine.EFFECT_BUSINESS_CENTER_DELETE)) or 0
    if info.state == PurchaseOrderState.NORMAL then
      self.submit_content.gameObject:SetActive(true)
      self.time_btn.gameObject:SetActive(true)
      self.delete_btn:SetActive(0 < showDelete)
      if 0 < showDelete then
        self.submit_btn.transform.localPosition = submitPos
        self.submitGray_btn.transform.localPosition = submitPos
      else
        self.submit_btn.transform.localPosition = Vector3.New(0, submitPos.y, 0)
        self.submitGray_btn.transform.localPosition = Vector3.New(0, submitPos.y, 0)
      end
    elseif info.state == PurchaseOrderState.LOCKED then
      self.lock_content.gameObject:SetActive(true)
      self.count_down:SetActive(self.hasCoolDown == true)
      if 0 < showDelete then
        self.count_down.transform.localPosition = submitPos
      else
        self.count_down.transform.localPosition = Vector3.New(0, submitPos.y, 0)
      end
    elseif info.state == PurchaseOrderState.DELETE or info.state == PurchaseOrderState.FINISH then
      self.diamondCost_content.gameObject:SetActive(true)
      self.time_btn.gameObject:SetActive(false)
    end
  end
  local state = DataCenter.ResidentOrderDataManager:GetBusinessBubbleState()
  if state ~= BusinessBubbleState.Yes then
    self:StartNoCanSubmitEffect()
  else
    self:StopNoCanSubmitEffect()
  end
end

local function PlayExitAnim(self)
  local ret, time = self.tip_anim:PlayAnimationReturnTime(AnimName.Exit)
  if ret then
    self.closeTimer = TimerManager:GetInstance():GetTimer(time, function()
      if self.closeTimer ~= nil then
        self.closeTimer:Stop()
        self.closeTimer = nil
      end
      if self ~= nil then
        self.tip:SetActive(false)
      end
    end, self, true, false, false)
    self.closeTimer:Start()
  else
    self.tip:SetActive(false)
  end
end

local function PlayTipAnim(self, param)
  self.tip:SetActive(true)
  self.tip_title:SetText(param.name)
  self.tip_des:SetText(param.buildName)
  self.tip.gameObject.transform:Set_localPosition(param.x, self.tip.gameObject.transform.localPosition.y, self.tip.gameObject.transform.localPosition.z)
  self.tip_anim:Play(AnimName.Enter, 0, 0)
end

local function CheckIndex(self, param)
  self.index = nil
  if self.isArrow then
    for i = 1, #self.list do
      if self.isArrow == 1 then
        if self.list[i].id > 0 then
          local state = DataCenter.ResidentOrderDataManager:GetOrderStateByOrderUuid(self.list[i].uuid)
          if state == ResidentOrderState.Yes then
            self.index = i
            currentIndex = self.index
            self.orderUuid = self.list[self.index].uuid
            return
          end
        end
      elseif self.list[i].id == self.isArrow then
        self.index = i
        currentIndex = self.index
        self.orderUuid = self.list[self.index].uuid
        return
      end
    end
  end
  if 0 < currentIndex then
    self.index = currentIndex
    self.orderUuid = self.list[self.index].uuid
    return
  end
  if self.isDoEnterAnim == true then
    for i = 1, table.length(self.list) do
      local state = DataCenter.ResidentOrderDataManager:GetOrderStateByOrderUuid(self.list[i].uuid)
      if state == ResidentOrderState.Yes then
        self.index = i
        self.orderUuid = self.list[self.index].uuid
        break
      end
    end
    if self.index == nil or self.index > table.count(self.list) then
      self.index = 1
      self.orderUuid = self.list[self.index].uuid
    end
  elseif self.orderUuid == nil then
    self.index = 1
    self.orderUuid = self.list[self.index].uuid
  else
    for k, v in ipairs(self.list) do
      if v.uuid == self.orderUuid then
        self.index = k
        return
      end
    end
    if self.index ~= nil and self.index <= table.count(self.list) then
      self.orderUuid = self.list[self.index].uuid
    else
      self.index = 1
      self.orderUuid = self.list[self.index].uuid
    end
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshResourceItem, self.UpdateResourceItemSignal)
  self:AddUIListener(EventId.RefreshResidentOrder, self.RefreshResidentOrderSignal)
  self:AddUIListener(EventId.SoldResourceItem, self.UpdateResourceItemSignal)
  self:AddUIListener(EventId.END_SEARCH, self.FindMonsterEnd)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.END_SEARCH, self.FindMonsterEnd)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.UpdateResourceItemSignal)
  self:RemoveUIListener(EventId.RefreshResidentOrder, self.RefreshResidentOrderSignal)
  self:RemoveUIListener(EventId.SoldResourceItem, self.UpdateResourceItemSignal)
end

local function FindMonsterEnd(self, param)
  local worldPosition = SceneUtils.TileIndexToWorld(param.pointId, ForceChangeScene.World)
  WorldArrowManager:GetInstance():ShowArrowEffect(param.uuid, worldPosition, ArrowType.Monster)
  GoToUtil.GotoWorldPos(worldPosition, CS.SceneManager.World.InitZoom)
end

local function ShowCells(self)
  self:ClearScroll()
  local count = table.count(self.list)
  if 0 < count then
    self.scroll_view:SetTotalCount(count)
    self.scroll_view:RefillCells()
  end
  self:CheckNoSubmitGuide()
end

local function ClearScroll(self)
  if self.scroll_view == nil then
    return
  end
  self.cells = {}
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIBusinessCenterCell)
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local item = self.scroll_view:AddComponent(UIBusinessCenterCell, itemObj)
  local param = {}
  param.uuid = self.list[index].uuid
  param.orderId = self.list[index].id
  param.index = index
  
  function param.callBack(indexI, position)
    self:CellCallBack(indexI, position)
  end
  
  param.isDoEnterAnim = self.isDoEnterAnim
  param.changeIndex = self.changeIndex
  item:ReInit(param)
  self.cells[index] = item
  if self.index == index then
    self:ChangeSelectGo(index)
  end
end

local function OnDeleteCell(self, itemObj, index)
  if self.index == index then
    self.select_go.transform:SetParent(self.transform)
    self.select_go:SetActive(false)
  end
  self.cells[index] = nil
  self.scroll_view:RemoveComponent(itemObj.name, UIBusinessCenterCell)
end

local function DoSubmit(self)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Bill, false)
  DataCenter.ResidentOrderDataManager:SendOrderFinish(self.orderUuid)
  local info = DataCenter.ResidentOrderDataManager:GetResidentOrderByUuid(self.orderUuid)
  local template = DataCenter.OrderTemplateManager:GetOrderTemplate(info.orderId)
  local exp = DataCenter.ResidentOrderDataManager:GetExp(template.exp, info.random ~= nil, info.random)
  local pos = self.submit_btn.gameObject.transform.position
  local rewardTyp = RewardType.FOOD
  local pic = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_icon_money.png"
  local flyPos = Vector3:New(0, 0, 0)
  self.ctrl:CloseSelf()
  UIUtil.DoFly(tonumber(rewardTyp), 10, pic, pos, flyPos)
  if info.random < template.random_value and DataCenter.PlayerLevelManager:CanAddExpToday() then
    DataCenter.PlayerLevelManager:FlyExp(ExpSource.Order, pos, exp)
  end
end

local function OnSubmitBtnClick(self)
  if DataCenter.ResidentOrderDataManager:GetOrderSendLeftTime() > 0 then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    return
  end
  if DataCenter.ResidentOrderDataManager:IsReachMax() then
    UIUtil.ShowSingleTip(Localization:GetString("120320"))
    return
  end
  self.orderUuid = self.list[self.index].uuid
  local state = DataCenter.ResidentOrderDataManager:GetOrderStateByOrderUuid(self.orderUuid)
  if state == ResidentOrderState.Yes then
    local now = UITimeManager:GetInstance():GetServerTime()
    if now < self.endTime then
      self:DoSubmit()
    end
  elseif state == ResidentOrderState.CanBuy then
    local tmp = {}
    local items = self.template:GetNeedResourceItem()
    if items ~= nil then
      for _, v in ipairs(items) do
        tmp[v.needId] = v.count
      end
    end
    local param = DataCenter.ResourceItemDataManager:GetAllLackResourceItemParams(tmp, function()
      local now = UITimeManager:GetInstance():GetServerTime()
      if now < self.endTime then
        self:DoSubmit()
      end
    end)
    if param.canBuy == true and 0 < param.totalDiamond then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_FailClick, false)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceItemLack, {anim = true}, param)
    end
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(0.02, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  local sendLeftTime = DataCenter.ResidentOrderDataManager:GetOrderSendLeftTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.count_down:GetActive() and sendLeftTime <= 0 then
    self:UpdateResourceItemSignal()
    return
  end
  local info = DataCenter.ResidentOrderDataManager:GetResidentOrderByUuid(self.list[self.index].uuid)
  if info and info.state ~= PurchaseOrderState.DELETE and info.state ~= PurchaseOrderState.LOCKED and info.state ~= PurchaseOrderState.FINISH then
    local showDelete = tonumber(LuaEntry.Effect:GetGameEffect(EffectDefine.EFFECT_BUSINESS_CENTER_DELETE)) or 0
    self.count_down:SetActive(0 < sendLeftTime)
    if 0 < sendLeftTime then
      if 0 < showDelete then
        self.count_down.transform.localPosition = submitPos
      else
        self.count_down.transform.localPosition = Vector3.New(0, submitPos.y, 0)
      end
    end
  else
    self.count_down:SetActive(false)
  end
  if 0 < sendLeftTime then
    local startTime = DataCenter.ResidentOrderDataManager.lastGetOrderRewardTime
    local passTime = now - startTime
    local percent = passTime / (passTime + sendLeftTime)
    self.count_down_progress:SetFillAmount(percent)
  end
  if 0 < self.orderId and self.state ~= PurchaseOrderState.LOCKED then
    self.leftTime = self.endTime - now
    if 0 >= self.leftTime then
      self.end_time_text:SetText(self.leftText .. UITimeManager:GetInstance():MilliSecondToFmtString(0))
    else
      self.end_time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.leftTime))
      local cost = CommonUtil.GetTimeDiamondCost(self.leftTime / 1000)
      self.diamondCost_btn_costTxt:SetText(tostring(cost))
    end
  end
end

local function ShowNeedResourceItems(self)
  for k, v in pairs(self.needResourceItemCells) do
    v:SetActive(false)
    table.insert(self.freeNeedResourceItemCells, v)
  end
  self.needResourceItemCells = {}
  self.isRed = false
  self.needDiamond = 0
  local items = self.template:GetNeedResourceItem()
  if items ~= nil then
    for k, v in ipairs(items) do
      local param = UIBusinessCenterResourceItem.Param.New()
      param.itemId = v.needId
      param.count = v.count
      local result, diamondNum = DataCenter.ResourceItemDataManager:GetResourceItemBuyPriceTotal(param.itemId, param.count)
      if result == false then
        self.isRed = true
      end
      self.needDiamond = self.needDiamond + diamondNum
      self:AddOneNeedResourceCells(param)
    end
  end
  self:RefreshBtn()
end

local function AddOneNeedResourceCells(self, param)
  if #self.freeNeedResourceItemCells > 0 then
    local temp = table.remove(self.freeNeedResourceItemCells)
    if temp ~= nil then
      temp:SetActive(true)
      temp:ReInit(param)
      temp.transform:SetParent(self.need_item_list.transform)
      temp.transform:SetAsLastSibling()
      self.needResourceItemCells[param.itemId] = temp
      DOTween.Restart(PanelAni.ResourceItem_show)
    end
  elseif self.loadingCell[param.itemId] == nil then
    self.loadingCell[param.itemId] = true
    self:GameObjectInstantiateAsync(UIAssets.UIBusinessCenterResourceItem, function(request)
      self.loadingCell[param.itemId] = nil
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.need_item_list.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:SetAsLastSibling()
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      self.needResourceItemCells[param.itemId] = self.need_item_list:AddComponent(UIBusinessCenterResourceItem, nameStr)
      self.needResourceItemCells[param.itemId]:ReInit(param)
      DOTween.Restart(PanelAni.ResourceItem_show)
    end)
  end
end

local function RefreshState(self)
  self.hasCoolDown = DataCenter.ResidentOrderDataManager:GetOrderSendLeftTime() > 0
  self.isRed = false
  for k, v in pairs(self.needResourceItemCells) do
    v:RefreshState()
    local own = 0
    local data = DataCenter.ResourceItemDataManager:GetItemDataByItemId(v.param.itemId)
    if data ~= nil then
      own = data.number
    end
    if own < v.param.count then
      self.isRed = true
    end
  end
  self:RefreshBtn()
end

local function RefreshBtn(self)
  self.isRed = false
  local isRed = false
  local state = DataCenter.ResidentOrderDataManager:GetOrderStateByOrderUuid(self.orderUuid)
  if state ~= ResidentOrderState.Yes then
    isRed = not DataCenter.BuildManager:IsShowDiamond()
  end
  local info = DataCenter.ResidentOrderDataManager:GetResidentOrderByUuid(self.list[self.index].uuid)
  if self.hasCoolDown == true then
    self.submit_btn.gameObject:SetActive(false)
    self.submitGray_btn.gameObject:SetActive(false)
    if info and info.state == PurchaseOrderState.DELETE or info.state == PurchaseOrderState.FINISH then
      self.count_down:SetActive(false)
    else
      self.count_down:SetActive(true)
      local showDelete = tonumber(LuaEntry.Effect:GetGameEffect(EffectDefine.EFFECT_BUSINESS_CENTER_DELETE)) or 0
      if 0 < showDelete then
        self.count_down.transform.localPosition = submitPos
      else
        self.count_down.transform.localPosition = Vector3.New(0, submitPos.y, 0)
      end
    end
  else
    self.count_down:SetActive(false)
    if isRed then
      self.submit_btn:SetInteractable(false)
      self.submitGray_btn.gameObject:SetActive(true)
      self.submitGray_txt_shadow:SetAllColor(YellowBtnShadowGrayColor)
      self.submit_btn.gameObject:SetActive(false)
    else
      self.submit_btn:SetInteractable(true)
      self.submit_btn_name_shadow:SetAllColor(GreenBtnShadowLightColor)
      self.submitGray_txt_shadow:SetAllColor(GreenBtnShadowLightColor)
      self.submitGray_btn.gameObject:SetActive(false)
      self.submit_btn.gameObject:SetActive(true)
    end
  end
end

local function CellCallBack(self, index)
  if self.index ~= index then
    currentIndex = index
    self.index = index
    self.orderUuid = self.list[self.index].uuid
    self:ChangeSelectGo(index)
    self:RefreshRight()
  end
end

local function UpdateResourceItemSignal(self)
  for k, v in pairs(self.cells) do
    v:RefreshState()
  end
  self:RefreshState()
end

local function RefreshResidentOrderSignal(self, param)
  if self.isDoEnterAnim == true then
    self:RefreshOrder()
  elseif self.isDoEnterAnim == false and param == nil then
    self:RefreshCell()
  else
    self.isDelete = false
    if param == nil or param.type == BusinessRereshType.PurchaseOrderFinish then
    elseif param.type == BusinessRereshType.DeleteOrderFinish then
      self.isDelete = true
    end
    local temp = self.cells[self.index]
    if temp ~= nil then
      local info = DataCenter.ResidentOrderDataManager:GetResidentOrderByUuid(self.list[self.index].uuid)
      local orderId = -1
      if info ~= nil then
        orderId = info.orderId
        Setting:SetString(LuaEntry.Player.uid .. "ResidentOrder" .. self.index, info.expTime)
      end
      local time = temp:PlaySubmitAnim(orderId, self.isDelete, self.index)
      if 0 < time then
        self.seletIndex = self.index
        self.isPlaySubAnim = true
        self:DeleteSubTimer()
        self.isShowAnim = true
        self.submitTimer = TimerManager:GetInstance():GetTimer(time, function()
          self:SubTimeCallBack()
        end, true, false, false)
        self.submitTimer:Start()
        self:RefreshOrder()
      end
    end
  end
end

local function RefreshCell(self)
  local isRefresh = false
  for k, v in pairs(self.list) do
    local info = DataCenter.ResidentOrderDataManager:GetResidentOrderByUuid(v.uuid)
    if info ~= nil then
      local index = info.index + 1
      local leftTime = Setting:GetString(LuaEntry.Player.uid .. "ResidentOrder" .. index, "0")
      if Mathf.Floor(info.expTime) ~= Mathf.Floor(leftTime) and info.state == PurchaseOrderState.NORMAL then
        Setting:SetString(LuaEntry.Player.uid .. "ResidentOrder" .. index, info.expTime)
        local temp = self.cells[index]
        if temp ~= nil then
          local time = temp:PlaySubmitAnim(info.orderId, false, self.index)
          if 0 < time then
            self.isPlaySubAnim = true
            self.isShowAnim = true
            self.changeIndex = index
            TimerManager:GetInstance():DelayInvoke(function()
              self.isPlaySubAnim = false
              self:ShowCells()
              isRefresh = true
            end, time)
            self:RefreshOrder()
          end
        end
      end
    end
  end
  if isRefresh == false then
    self:RefreshOrder()
  end
end

local function ChangeSelectGo(self, index)
  if self.cells[index] ~= nil then
    self.select_go:SetActive(true)
    self.select_go.transform:SetParent(self.cells[index]:GetSelectTransform())
    self.select_go.transform:SetAsFirstSibling()
    self.select_go.transform.localRotation = ResetEulerAngles
    self.select_go.transform.localPosition = SelectPosition
    self.select_go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  end
end

local function SubTimeCallBack(self)
  self:DeleteSubTimer()
  self.isPlaySubAnim = false
  self.changeIndex = self.seletIndex
  self:ShowCells()
end

local function DeleteSubTimer(self)
  if self.submitTimer ~= nil then
    self.submitTimer:Stop()
    self.submitTimer = nil
  end
end

local function OnDeleteBtnClick(self)
  SFSNetwork.SendMessage(MsgDefines.PurchaseOrderDelete, {
    uuid = self.orderUuid
  })
end

local function OnDiamondCostBtnClick(self)
  local gold = LuaEntry.Player.gold
  local cost = CommonUtil.GetTimeDiamondCost(self.leftTime / 1000)
  self.diamondCost_btn_costTxt:SetText(tostring(cost))
  if gold < cost then
    GoToUtil.GotoPayTips(cost)
  else
    UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog, Localization:GetString(GameDialogDefine.USE_GOLF_TIP_DES), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self.orderUuid = self.list[self.index].uuid
      SFSNetwork.SendMessage(MsgDefines.PurchaseOrderImmediateRefresh, {
        uuid = self.orderUuid
      })
    end, function()
    end)
  end
end

local function OnLockBtnClick(self)
  GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_MAIN, WorldTileBtnType.City_Upgrade)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIBusinessCenter)
  DOTween.Restart(PanelAni.Close)
end

local function OnShowTipClick(self)
  self:ShowDesc("130421")
end

local function GetWorld(self)
  if DataCenter.ChapterTaskManager:IsCompleteAllChapter() == false then
    local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
    if chapterId ~= nil and chapterId < BusinessCenterChat then
      return "330333"
    end
  end
  local value = LuaEntry.DataConfig:TryGetStr("purchase_order_config", "k3")
  local worldStr = {}
  if value ~= nil and value ~= "" then
    local vec = string.split(value, ";")
    for k, v in ipairs(vec) do
      worldStr[k] = v
    end
  end
  local num = math.random(1, table.count(worldStr))
  return worldStr[num]
end

local function ShowDesc(self, desc)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.time_btn.gameObject.transform.position + Vector3.New(-20, 30, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.title = nil
  param.content = Localization:GetString(desc)
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 180
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function CheckNoSubmitGuide(self)
  local state = DataCenter.ResidentOrderDataManager:GetBusinessBubbleState()
  if state == BusinessBubbleState.NoSubmit then
    DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.BusinessNoSubmit, tostring(DataCenter.BuildManager.MainLv))
  end
end

local function OnCountDownBtnClick(self)
  UIUtil.ShowSingleTip(Localization:GetString("100428"))
end

local function StartNoCanSubmitEffect(self)
  self:StopNoCanSubmitEffect()
  local spr = self.delete_btn_img.unity_image
  if spr == nil then
    return
  end
  local fadeTime = 1.0
  local delayTime = 2.5
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  sequence:Append(spr:DOFade(1, 0))
  sequence:Append(spr:DOFade(0.5, fadeTime))
  sequence:Append(spr:DOFade(1, fadeTime))
  sequence:SetLoops(-1)
  self.tweenSequence = sequence
end

local function StopNoCanSubmitEffect(self)
  if self.tweenSequence ~= nil then
    self.tweenSequence:Pause()
    self.tweenSequence:Kill()
    self.tweenSequence = nil
    self.delete_btn_img:SetAlpha(1)
  end
end

UIBusinessCenterView.OnCreate = OnCreate
UIBusinessCenterView.OnDestroy = OnDestroy
UIBusinessCenterView.OnEnable = OnEnable
UIBusinessCenterView.OnDisable = OnDisable
UIBusinessCenterView.OnAddListener = OnAddListener
UIBusinessCenterView.OnRemoveListener = OnRemoveListener
UIBusinessCenterView.ComponentDefine = ComponentDefine
UIBusinessCenterView.ComponentDestroy = ComponentDestroy
UIBusinessCenterView.DataDefine = DataDefine
UIBusinessCenterView.DataDestroy = DataDestroy
UIBusinessCenterView.ReInit = ReInit
UIBusinessCenterView.OnSubmitBtnClick = OnSubmitBtnClick
UIBusinessCenterView.DeleteTimer = DeleteTimer
UIBusinessCenterView.AddTimer = AddTimer
UIBusinessCenterView.OnSubmitBtnClick = OnSubmitBtnClick
UIBusinessCenterView.RefreshTime = RefreshTime
UIBusinessCenterView.RefreshBtn = RefreshBtn
UIBusinessCenterView.RefreshState = RefreshState
UIBusinessCenterView.ShowNeedResourceItems = ShowNeedResourceItems
UIBusinessCenterView.AddOneNeedResourceCells = AddOneNeedResourceCells
UIBusinessCenterView.RefreshOrder = RefreshOrder
UIBusinessCenterView.RefreshRight = RefreshRight
UIBusinessCenterView.CheckIndex = CheckIndex
UIBusinessCenterView.ShowCells = ShowCells
UIBusinessCenterView.ClearScroll = ClearScroll
UIBusinessCenterView.OnCreateCell = OnCreateCell
UIBusinessCenterView.OnDeleteCell = OnDeleteCell
UIBusinessCenterView.CellCallBack = CellCallBack
UIBusinessCenterView.UpdateResourceItemSignal = UpdateResourceItemSignal
UIBusinessCenterView.RefreshResidentOrderSignal = RefreshResidentOrderSignal
UIBusinessCenterView.ChangeSelectGo = ChangeSelectGo
UIBusinessCenterView.SubTimeCallBack = SubTimeCallBack
UIBusinessCenterView.DeleteSubTimer = DeleteSubTimer
UIBusinessCenterView.PlayExitAnim = PlayExitAnim
UIBusinessCenterView.PlayTipAnim = PlayTipAnim
UIBusinessCenterView.OnDeleteBtnClick = OnDeleteBtnClick
UIBusinessCenterView.OnDiamondCostBtnClick = OnDiamondCostBtnClick
UIBusinessCenterView.OnLockBtnClick = OnLockBtnClick
UIBusinessCenterView.OnShowTipClick = OnShowTipClick
UIBusinessCenterView.GetWorld = GetWorld
UIBusinessCenterView.ShowDesc = ShowDesc
UIBusinessCenterView.RefreshCell = RefreshCell
UIBusinessCenterView.CheckNoSubmitGuide = CheckNoSubmitGuide
UIBusinessCenterView.OnCountDownBtnClick = OnCountDownBtnClick
UIBusinessCenterView.StartNoCanSubmitEffect = StartNoCanSubmitEffect
UIBusinessCenterView.StopNoCanSubmitEffect = StopNoCanSubmitEffect
UIBusinessCenterView.DoSubmit = DoSubmit
UIBusinessCenterView.FindMonsterEnd = FindMonsterEnd
return UIBusinessCenterView
