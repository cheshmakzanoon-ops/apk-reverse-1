local base = UIBaseView
local UIPlayerLevelPackageView = BaseClass("UIPlayerLevelPackageView", base)
local Localization = CS.GameEntry.Localization
local UIPlayerLevelPackagePageToggle = require("UI.UIPlayerLevelPackage.Component.UIPlayerLevelPackagePageToggle")
local UIPlayerLevelPackagePage = require("UI.UIPlayerLevelPackage.Component.UIPlayerLevelPackagePage")
local ResourceManager = CS.GameEntry.Resource
local UnityUILoopListViewInitParam = typeof(CS.SuperScrollView.LoopListViewInitParam)
local closeBgPanel_path = "Panel"
local root_path = "Root"
local closeBtn_path = "Root/Top/CloseBtn"
local toggleTemplate_path = "Root/TogglesScroll/Toggle"
local toggleContainer_path = "Root/TogglesScroll/Viewport/Content"
local packagesScroll_path = "Root/Mask/PackagesScroll"
local packagesScrollContent_path = "Root/Mask/PackagesScroll/PackagesViewport/PackagesContent"
local leftArrow_path = "Root/LeftArrow"
local rightArrow_path = "Root/RightArrow"
local blocker_path = "Root/Mask/PackagesScroll/Blocker"
local togglesScroll_path = "Root/ToggleScroll"
local togglesContent_path = "Root/ToggleScroll/ToggleViewport/ToggleContent"
local empty_icon_hang_up_point_path = "Panel/EmptyIconHangUpPoint"
local empty_icon_path = "Panel/EmptyIconHangUpPoint/EmptyIcon"
local free_package_btn_path = "TopLayer/freePackageBtn"
local free_pack_text_path = "TopLayer/freePackageBtn/FreePackText"
local mask4_in_store_path = "Root/mask4InStore"
local FREE_REWARD_TYPE = 1

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.inited = false
  DataCenter.ArrowManager:RemoveFingerArrow()
  if not self.userData then
    return
  end
  self.rechargeId, self.recharges = self:GetUserData()
  self.sourceType = RechargeEntryType.MainUIPop
  self:FilterValidRecharges()
  self:RefreshUI4SourceType()
  if table.IsNullOrEmpty(self.validRecharges) then
    self:TryCloseView()
    return
  end
  local gotoIndex = 1
  for i = 1, #self.validRecharges do
    if self.validRecharges[i] == self.rechargeId then
      gotoIndex = i
      break
    end
  end
  self:CreateToggles()
  self:RefreshPackageList()
  self:GotoToggle(gotoIndex)
  DataCenter.LWSoundManager:PlaySound(62266, false)
end

function UIPlayerLevelPackageView:ReInit4StorePage(rechargeId, recharges)
  self.sourceType = RechargeEntryType.PopRechargeInStore
  self.rechargeId = rechargeId
  self.recharges = recharges
  self:FilterValidRecharges()
  self:RefreshUI4SourceType()
  if table.IsNullOrEmpty(self.validRecharges) then
    self:TryCloseView()
    self.packageScroll:SetListItemCount(0, false, false)
    self.packageScroll:RefreshAllShownItem()
    self.togglesScroll:SetListItemCount(0, false, false)
    self.togglesScroll:RefreshAllShownItem()
    self:RefreshArrows()
    self.emptyIcon:SetActive(true)
    return
  end
  self.emptyIcon:SetActive(false)
  local gotoIndex = 1
  for i = 1, #self.validRecharges do
    if self.validRecharges[i] == self.rechargeId then
      gotoIndex = i
      break
    end
  end
  self:CreateToggles()
  self:RefreshPackageList()
  self:GotoToggle(gotoIndex)
  DataCenter.LWSoundManager:PlaySound(62266, false)
end

function UIPlayerLevelPackageView:OnScreenSizeChange()
  self:RefreshUI4SourceType()
end

function UIPlayerLevelPackageView:RefreshUI4SourceType()
  if self.sourceType and self.sourceType == RechargeEntryType.PopRechargeInStore then
    self.anim:Enable(false)
    local heightWidthRatio = Screen.height / Screen.width
    local targetScale = 1.7777777777777777 < heightWidthRatio and 1 or 0.9
    if Screen.safeArea.height < Screen.height then
      targetScale = targetScale * Screen.safeArea.height / Screen.height
    end
    local offsetY = 1.7777777777777777 < heightWidthRatio and 0 or -40
    self:SetScaleAndBGColor(targetScale, "#393b94", 1)
    self.emptyHangupPoint:SetActive(true)
    self.freeRewardBtn:SetActive(true)
    self.root.rectTransform:Set_anchoredPosition(0, offsetY, 0)
    self:RefreshFreeRewardState()
    self.mask4InStore:SetActive(true)
    self.closeBgPanel:SetInteractable(false)
  else
    self:SetScaleAndBGColor(1, "#050013")
    self.anim:Enable(true)
    self.emptyHangupPoint:SetActive(false)
    self.freeRewardBtn:SetActive(false)
    self.root.rectTransform:Set_anchoredPosition(0, 0, 0)
    self.mask4InStore:SetActive(false)
    self.closeBgPanel:SetInteractable(true)
  end
end

function UIPlayerLevelPackageView:SetScaleAndBGColor(scale, colorHexStr, canvasGroupAlpha)
  if self.root and not IsNull(self.root) and scale then
    self.root.transform:Set_localScale(scale, scale, scale)
  end
  if self.bgImg and not IsNull(self.bgImg) and colorHexStr then
    self.bgImg:SetColorHex(colorHexStr)
  end
  if self.canvasGroup and not IsNull(self.canvasGroup) and canvasGroupAlpha then
    self.canvasGroup:SetAlpha(canvasGroupAlpha)
    if 0 < canvasGroupAlpha then
      self.canvasGroup:SetBlocksRaycasts(true)
    end
  end
end

local function GetScrollItem(self, listview, index)
  local pageList = self.validRecharges
  index = index + 1
  if index < 1 or index > #pageList then
    return nil
  end
  local item = listview:NewListViewItem("UIPlayerLevelPackagePage")
  local script = self.packageScrollContent:GetComponent(item.gameObject.name, UIPlayerLevelPackagePage)
  if script == nil then
    NameCount = NameCount + 1
    local nameStr = tostring(NameCount)
    item.gameObject.name = nameStr
    script = self.packageScrollContent:AddComponent(UIPlayerLevelPackagePage, nameStr)
    local isShowCloseBtn = not self.sourceType or self.sourceType == RechargeEntryType.MainUIPop
    
    local function onChildBeginDrag(eventData)
      self:OnChildBeginDrag(eventData)
    end
    
    local function onChildDrag(eventData)
      self:OnChildDrag(eventData)
    end
    
    local function onChildEndDrag(eventData)
      self:OnChildEndDrag(eventData)
    end
    
    local function onCloseCallback(rechargeId)
      self:OnClose(rechargeId)
    end
    
    script:Init(self.sourceType, isShowCloseBtn, onChildBeginDrag, onChildDrag, onChildEndDrag, onCloseCallback)
  end
  script:SetData(pageList[index])
  return item
end

function UIPlayerLevelPackageView:OnClose(rechargeId)
  local line = DataCenter.RechargeManager:GetLine(rechargeId)
  if not line then
    return
  end
  if line.entry_type ~= RechargeEntryType.PopRechargeInStore then
    return
  end
  local effectPath = "Assets/Main/Prefabs/Effect/UI/UIPlayerLevelPackageNew/Eff_ui_GiftPackageFold_guangqiu.prefab"
  local startPos = CS.GameEntry.UICamera:ScreenToWorldPoint(Vector3.New(Screen.width / 2, Screen.height / 2, 0))
  local endPos = UIUtil.GetUIMainSavePos(UIMainSavePosType.Gold) + Vector2.New(13, -13)
  UIUtil.DoFlySimpleFuncDelay(effectPath, startPos, endPos, 0.5, 0.1, nil, function()
    local arriveEffPath = "Assets/Main/Prefabs/Effect/UI/UIPlayerLevelPackageNew/Eff_ui_GiftPackageFold_glow.prefab"
    UIUtil.DoFlySimpleFuncDelay(arriveEffPath, endPos, endPos, 0.5, 0.05)
  end)
end

local function ClearScroll(self)
  self.packageScrollContent:RemoveComponents(UIPlayerLevelPackagePage)
  self.packageScroll:ClearAllItems()
end

local function StartPackageDrag(self, setIndex)
  self.packagesDragging = true
  if setIndex then
    self.beginDragRechargeIndex = self.rechargeListIndex
  end
end

local function EndPackageDrag(self)
  self.packagesDragging = false
  self.beginDragRechargeIndex = nil
end

local function GetScrollToggleItem(self, listview, index)
  local pageList = self.validRecharges
  index = index + 1
  if index < 1 or index > #pageList then
    return nil
  end
  local item = listview:NewListViewItem("previewWindowItem")
  local script = self.togglesScrollContent:GetComponent(item.gameObject.name, UIPlayerLevelPackagePageToggle)
  if script == nil then
    NameCount = NameCount + 1
    local nameStr = tostring(NameCount)
    item.gameObject.name = nameStr
    script = self.togglesScrollContent:AddComponent(UIPlayerLevelPackagePageToggle, nameStr)
    script:InitCallback(function(listIndex, _item)
      self:OnClickToggle(listIndex, _item)
    end)
  end
  script:SetData(pageList[index], index, self.sourceType)
  script:SetSelected(self.rechargeListIndex == index)
  return item
end

local function ClearToggles(self)
  self.togglesScrollContent:RemoveComponents(UIPlayerLevelPackagePageToggle)
  self.togglesScroll:ClearAllItems()
end

local function OnDestroy(self)
  ClearScroll(self)
  ClearToggles(self)
  self:ClearToggles()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnItemSnapFinish(self, listView, item)
  local curItemIndex = item.ItemIndex
  if self.packagesDragging and self.beginDragRechargeIndex ~= curItemIndex + 1 then
    local offset = 0
    offset = offset + 270 * curItemIndex
    self.togglesScroll:ResetListView()
    self.togglesScroll:MovePanelToItemIndex(curItemIndex, -offset)
  end
  EndPackageDrag(self)
end

local function ChangeFocusIndex(self, index, move)
  self.curRechargeIndex = self.validRecharges[index]
  self.rechargeListIndex = index
  if move then
    StartPackageDrag(self)
    self.packageScroll:ResetListView()
    self.packageScroll:MovePanelToItemIndex(index - 1, 0)
    if #self.validRecharges == 1 then
      self.togglesScroll:RefreshAllShownItem()
    end
  end
  self:RefreshArrows()
end

local function RefreshEachItemFocusState(self, item, para)
  local cachedTransform = item.CachedRectTransform
  if cachedTransform then
    local script = self.packageScrollContent:GetComponent(cachedTransform.name, UIPlayerLevelPackagePage)
    if script then
      script:SetFocus(item.ItemIndex == para)
    end
  end
end

local function OnItemSnapNearestChanged(self, listView, item)
  local itemIndex = item.ItemIndex
  ChangeFocusIndex(self, itemIndex + 1, false)
end

local function ComponentDefine(self)
  self.closeBgPanel = self:AddComponent(UIButton, closeBgPanel_path)
  self.closeBgPanel:SetOnClick(function()
    self:TryCloseView()
  end)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtn:SetOnClick(function()
    self:TryCloseView()
  end)
  self.content = self:AddComponent(UIBaseContainer, toggleContainer_path)
  self.toggleTemplate = self:AddComponent(UIBaseContainer, toggleTemplate_path)
  self.toggleTemplate.gameObject:GameObjectCreatePool()
  self.packageScroll = self:AddComponent(UILoopListView2, packagesScroll_path)
  self.packageScrollRect = self:AddComponent(UIScrollRect, packagesScroll_path)
  local listInitDefaultPara = CS.SuperScrollView.LoopListViewInitParam.CopyDefaultInitParam()
  listInitDefaultPara.mSmoothDumpRate = 0.04
  self.packageScroll:InitListViewParam(0, function(listview, index)
    return GetScrollItem(self, listview, index)
  end, listInitDefaultPara)
  self.packageScroll:SetOnSnapItemFinished(function(listView, item)
    OnItemSnapFinish(self, listView, item)
  end)
  self.packageScroll:SetOnSnapNearestChanged(function(listView, item)
    OnItemSnapNearestChanged(self, listView, item)
  end)
  self.packageScroll:SetOnBeginDragAction(function(eventData)
    self:OnSelfBeginDrag(eventData)
  end)
  self.packageScroll:SetOnEndDragAction(function(eventData)
    self:OnSelfEndDrag(eventData)
  end)
  self.packageScrollContent = self:AddComponent(UIBaseContainer, packagesScrollContent_path)
  self.leftArrow = self:AddComponent(UIButton, leftArrow_path)
  self.leftArrow:SetOnClick(function()
    if self.packageScroll and self.rechargeListIndex and self.rechargeListIndex > 1 then
      StartPackageDrag(self)
      self.packageScroll:SetSnapTargetItemIndex(self.rechargeListIndex - 2)
    end
  end)
  self.rightArrow = self:AddComponent(UIButton, rightArrow_path)
  self.rightArrow:SetOnClick(function()
    if self.packageScroll and self.rechargeListIndex and self.rechargeListIndex < #self.validRecharges then
      StartPackageDrag(self)
      self.packageScroll:SetSnapTargetItemIndex(self.rechargeListIndex)
    end
  end)
  self.blocker = self:AddComponent(UIEventTrigger, blocker_path)
  self.blocker:OnBeginDrag(function(eventData)
    self:OnChildBeginDrag(eventData)
  end)
  self.blocker:OnEndDrag(function(eventData)
    self:OnChildEndDrag(eventData)
  end)
  self.blocker:OnDrag(function(eventData)
    self:OnChildDrag(eventData)
  end)
  self.togglesScroll = self:AddComponent(UILoopListView2, togglesScroll_path)
  listInitDefaultPara = CS.SuperScrollView.LoopListViewInitParam.CopyDefaultInitParam()
  listInitDefaultPara.mSmoothDumpRate = 0.04
  self.togglesScroll:InitListViewParam(0, function(listview, index)
    return GetScrollToggleItem(self, listview, index)
  end, listInitDefaultPara)
  self.togglesScrollContent = self:AddComponent(UIBaseContainer, togglesContent_path)
  self.anim = self:AddComponent(UIAnimator, "")
  self.root = self:AddComponent(UIBaseComponent, root_path)
  self.bgImg = self:AddComponent(UIImage, closeBgPanel_path)
  self.canvasGroup = self:AddComponent(UICanvasGroup, "")
  self.emptyHangupPoint = self:AddComponent(UIBaseComponent, empty_icon_hang_up_point_path)
  self.emptyIcon = self:AddComponent(UIBaseComponent, empty_icon_path)
  self.freeRewardBtn = self:AddComponent(UIButton, free_package_btn_path)
  self.freeRewardBtn:SetOnClick(function()
    self:OnClickClaimFreePackage()
  end)
  self.freePackageBtnAnimN = self:AddComponent(UIAnimator, free_package_btn_path)
  self.freeTxtN = self:AddComponent(UIText, free_pack_text_path)
  self.mask4InStore = self:AddComponent(UIBaseComponent, mask4_in_store_path)
end

local function ComponentDestroy(self)
  self.closeBgPanel = nil
  self.closeBtn = nil
  self.content = nil
  self.toggleTemplate = nil
  if self.claimFreeTimer then
    self.claimFreeTimer:Stop()
    self.claimFreeTimer = nil
    SFSNetwork.SendMessage(MsgDefines.FreeRewardReceive, FREE_REWARD_TYPE)
  end
end

local function DataDefine(self)
  self.packageInfo = nil
  self.rewards = {}
  self.curRechargeIndex = nil
  self.rechargeListIndex = nil
  self.nextUpdateTime = nil
  self.hideRedOnce = nil
end

local function DataDestroy(self)
  self.packageInfo = nil
  self.rewards = nil
  self.curRechargeIndex = nil
  self.rechargeListIndex = nil
  self.nextUpdateTime = nil
end

local function RefreshPackageList(self)
  if #self.validRecharges > 0 then
    self.packageScroll:StopMovement()
    self.packageScroll:SetListItemCount(#self.validRecharges, false, false)
    self.packageScroll:RefreshAllShownItem()
    self.emptyIcon:SetActive(false)
  else
    self:RefreshArrows()
    self.emptyIcon:SetActive(true)
  end
end

local function Update1000MS(self)
  if self.nextUpdateTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= self.nextUpdateTime then
      self:OnUpdateGiftPackageData()
    end
  end
end

local function OnClickPayBtn(self)
  if self.packageInfo and self.packageInfo:getID() ~= -1 then
    DataCenter.PayManager:CallPayment(self.packageInfo, UIWindowNames.UIPlayerLevelPackage)
  end
end

local function OnClickCloseBtn(self)
  self:TryCloseView()
end

function UIPlayerLevelPackageView:TryCloseView()
  if (not self.sourceType or self.sourceType == RechargeEntryType.MainUIPop) and self.ctrl then
    self.ctrl:CloseSelf()
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.OnUpdateGiftPackageData)
  self:AddUIListener(EventId.RechargeFreeRewardReceiveStateUpdate, self.RefreshFreeRewardState)
  self:AddUIListener(EventId.OnUnDelayPassDay, self.OnPassDay)
  self:AddUIListener(EventId.SCREEN_SIZE_CHANGE, self.OnScreenSizeChange)
  self.addListener = true
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  if self.addListener then
    self:RemoveUIListener(EventId.UpdateGiftPackData, self.OnUpdateGiftPackageData)
    self:RemoveUIListener(EventId.RechargeFreeRewardReceiveStateUpdate, self.RefreshFreeRewardState)
    self:RemoveUIListener(EventId.OnUnDelayPassDay, self.OnPassDay)
    self:RemoveUIListener(EventId.SCREEN_SIZE_CHANGE, self.OnScreenSizeChange)
    self.addListener = false
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
  self.beginDragPos = nil
  self.beginDragRechargeIndex = nil
  self.packagesDragging = nil
end

local function CreateToggles(self)
  if table.IsNullOrEmpty(self.validRecharges) then
    return
  end
  if #self.validRecharges > 0 then
    self.togglesScroll:StopMovement()
    self.togglesScroll:SetListItemCount(#self.validRecharges, false, false)
    self.togglesScroll:RefreshAllShownItem()
  end
end

local function FilterValidRecharges(self)
  self.validRecharges = {}
  if table.IsNullOrEmpty(self.recharges) then
    return
  end
  local minTime = {}
  for i = 1, #self.recharges do
    local recharge = self.recharges[i]
    if recharge then
      local packages = GiftPackageData.GetAllAvailablePackageByRechargeId(recharge)
      if not table.IsNullOrEmpty(packages) then
        local package = packages[1]
        if package and package:isTimeValid() and package:canGet() then
          local countDown = package:getCountdown()
          if 1500 < countDown then
            table.insert(self.validRecharges, recharge)
            minTime[recharge] = countDown
          end
        end
      end
    end
  end
  if #self.validRecharges > 0 then
    table.sort(self.validRecharges, function(a, b)
      local orderA = DataCenter.RechargeManager:getStrValue(a, "order")
      local orderB = DataCenter.RechargeManager:getStrValue(b, "order")
      if orderA ~= orderB then
        return orderA < orderB
      end
      if minTime[a] == minTime[b] then
        return a < b
      else
        return minTime[a] < minTime[b]
      end
    end)
  end
  self.nextUpdateTime = nil
  if not table.IsNullOrEmpty(self.validRecharges) then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local minCountdown
    for _, rid in ipairs(self.validRecharges) do
      local t = minTime[rid]
      if t and (minCountdown == nil or minCountdown > t) then
        minCountdown = t
      end
    end
    if minCountdown then
      self.nextUpdateTime = curTime + minCountdown
    end
  end
end

local function IsRechargeValid(self, rechargeId)
  if table.IsNullOrEmpty(self.validRecharges) then
    return false, nil
  end
  for i = 1, #self.validRecharges do
    if self.validRecharges[i] == rechargeId then
      return true, i
    end
  end
  return false, nil
end

local function FallbackToAvaliable(self)
  if table.IsNullOrEmpty(self.validRecharges) then
    return
  end
  local prevRechargeIndex = self.curRechargeIndex
  local prevRechargeListIndex = self.rechargeListIndex
  if prevRechargeIndex and prevRechargeListIndex and prevRechargeListIndex > #self.validRecharges then
    ChangeFocusIndex(self, #self.validRecharges, true)
  end
end

function UIPlayerLevelPackageView:OnPassDay()
  if self.sourceType == RechargeEntryType.PopRechargeInStore then
    self.recharges = WelfareController.GetPopupPackages(RechargeEntryType.PopRechargeInStore)
  end
  self:OnUpdateGiftPackageData()
  self:RefreshFreeRewardState()
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshWelfareRedDot)
end

local function OnUpdateGiftPackageData(self)
  self:FilterValidRecharges()
  if table.IsNullOrEmpty(self.validRecharges) then
    if self.ctrl then
      self.ctrl:CloseSelf()
      return
    end
    self.packageScroll:SetListItemCount(0, false, false)
    self.packageScroll:RefreshAllShownItem()
    self.togglesScroll:SetListItemCount(0, false, false)
    self.togglesScroll:RefreshAllShownItem()
    self:RefreshArrows()
    self.emptyIcon:SetActive(true)
    return
  end
  self:CreateToggles()
  self:RefreshPackageList()
  if not self.validRecharges[self.rechargeListIndex] then
    ChangeFocusIndex(self, #self.validRecharges, true)
  else
    self.packageScroll:RefreshAllShownItem()
  end
  self:RefreshArrows()
end

local function GotoToggle(self, index)
  if not self.validRecharges then
    return
  end
  if index < 1 or index > #self.validRecharges then
    return
  end
  ChangeFocusIndex(self, index, true)
end

local function OnChildBeginDrag(self, eventData)
  if self.packageScroll then
    self.packageScroll:OnBeginDrag(eventData)
  end
end

local function OnChildEndDrag(self, eventData)
  if self.packageScroll then
    self.packageScroll:OnEndDrag(eventData)
  end
end

local function OnChildDrag(self, eventData)
  if self.packageScroll then
    self.packageScroll:OnDrag(eventData)
  end
end

local function OnSelfBeginDrag(self, eventData)
  if self.packagesDragging then
    return
  end
  if self.packageScroll then
    self.beginDragPos = self.packageScrollRect:GetHorizontalNormalizedPosition()
  end
  StartPackageDrag(self, true)
end

local function OnSelfEndDrag(self, eventData)
  if table.IsNullOrEmpty(self.validRecharges) then
    return
  end
  if self.packageScroll and self.beginDragPos and self.beginDragRechargeIndex == self.rechargeListIndex then
    local endDragPos = self.packageScrollRect:GetHorizontalNormalizedPosition()
    if math.abs(endDragPos - self.beginDragPos) > 0.05 then
      if endDragPos > self.beginDragPos and self.rechargeListIndex < #self.validRecharges then
        self.packageScroll:SetSnapTargetItemIndex(self.rechargeListIndex)
      elseif endDragPos < self.beginDragPos and self.rechargeListIndex > 1 then
        self.packageScroll:SetSnapTargetItemIndex(self.rechargeListIndex - 2)
      end
      return
    end
  end
end

local function RefreshArrows(self)
  if not self.rechargeListIndex or table.IsNullOrEmpty(self.validRecharges) then
    self.leftArrow:SetActive(false)
    self.rightArrow:SetActive(false)
    return
  end
  self.leftArrow:SetActive(self.rechargeListIndex > 1)
  self.rightArrow:SetActive(self.rechargeListIndex < #self.validRecharges)
end

local function OnClickToggle(self, listIndex, item)
  if self.rechargeListIndex == listIndex then
    return
  end
  ChangeFocusIndex(self, listIndex, true)
end

function UIPlayerLevelPackageView:OnClickClaimFreePackage()
  if self.sourceType ~= RechargeEntryType.PopRechargeInStore then
    return
  end
  if self.claimFreeTimer then
    return
  end
  local hasFreeReward = DataCenter.RechargeManager:GetIsCanReceiveFreeReward(FREE_REWARD_TYPE)
  if hasFreeReward then
    self.freePackageBtnAnimN:Play("V_ui_zhoukabaoxiang_01_open", 0, 0)
    self.claimFreeTimer = TimerManager:GetInstance():DelayInvoke(function()
      SFSNetwork.SendMessage(MsgDefines.FreeRewardReceive, FREE_REWARD_TYPE)
      self.claimFreeTimer = nil
    end, 0.5)
  else
    UIUtil.ShowTipsId(170003)
  end
end

function UIPlayerLevelPackageView:RefreshFreeRewardState()
  if self.sourceType ~= RechargeEntryType.PopRechargeInStore then
    return
  end
  local hasFreeReward = DataCenter.RechargeManager:GetIsCanReceiveFreeReward(FREE_REWARD_TYPE)
  if not hasFreeReward then
    self.freePackageBtnAnimN:Play("V_ui_zhoukabaoxiang_01_opened", 0, 0)
    self.freeTxtN:SetLocalText(170003)
  else
    self.freePackageBtnAnimN:Play("V_ui_zhoukabaoxiang_01_idle", 0, 0)
    self.freeTxtN:SetLocalText(320227)
  end
end

UIPlayerLevelPackageView.OnCreate = OnCreate
UIPlayerLevelPackageView.OnDestroy = OnDestroy
UIPlayerLevelPackageView.OnAddListener = OnAddListener
UIPlayerLevelPackageView.OnRemoveListener = OnRemoveListener
UIPlayerLevelPackageView.ComponentDefine = ComponentDefine
UIPlayerLevelPackageView.ComponentDestroy = ComponentDestroy
UIPlayerLevelPackageView.DataDefine = DataDefine
UIPlayerLevelPackageView.DataDestroy = DataDestroy
UIPlayerLevelPackageView.OnClickPayBtn = OnClickPayBtn
UIPlayerLevelPackageView.OnClickCloseBtn = OnClickCloseBtn
UIPlayerLevelPackageView.Update1000MS = Update1000MS
UIPlayerLevelPackageView.OnEnable = OnEnable
UIPlayerLevelPackageView.OnDisable = OnDisable
UIPlayerLevelPackageView.ClearToggles = ClearToggles
UIPlayerLevelPackageView.CreateToggles = CreateToggles
UIPlayerLevelPackageView.FilterValidRecharges = FilterValidRecharges
UIPlayerLevelPackageView.IsRechargeValid = IsRechargeValid
UIPlayerLevelPackageView.FallbackToAvaliable = FallbackToAvaliable
UIPlayerLevelPackageView.OnUpdateGiftPackageData = OnUpdateGiftPackageData
UIPlayerLevelPackageView.GotoToggle = GotoToggle
UIPlayerLevelPackageView.RefreshPackageList = RefreshPackageList
UIPlayerLevelPackageView.OnChildBeginDrag = OnChildBeginDrag
UIPlayerLevelPackageView.OnChildEndDrag = OnChildEndDrag
UIPlayerLevelPackageView.OnChildDrag = OnChildDrag
UIPlayerLevelPackageView.RefreshArrows = RefreshArrows
UIPlayerLevelPackageView.OnClickToggle = OnClickToggle
UIPlayerLevelPackageView.OnSelfBeginDrag = OnSelfBeginDrag
UIPlayerLevelPackageView.OnSelfEndDrag = OnSelfEndDrag
return UIPlayerLevelPackageView
