local UIHeroRecruitView = BaseClass("UIHeroRecruitView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UITabCell = require("UI.UIHero2.UIHeroRecruit.Component.UITabCell")
local UITopItem = require("UI.UIHero2.UIHeroRecruit.Component.UITopItem")
local CampRecruitBgPath = "Assets/Main/TextureEx/UIHeroRecruitBg/%s.png"
local ResourceManager = CS.GameEntry.Resource
local btnOnePos
local LWMaxAdWatchAd = require("UI.LWUIMaxAd.Component.LWMaxAdWatchAd")
local CenterWorkerNewContentContainer = require("UI/UIHero2/UIHeroRecruit/Component/CenterWorkerNewContentContainer")
local UICommonTipsView = require("UI.UICommonTips.View.UICommonTipsView")
local sendMsgTime = 0
local time_tips_path = "Root/CenterContentContainer/TimeTips"
local text_time_open_path = "Root/CenterContentContainer/TimeTips/TextTimeOpen"
local default_img_path = "Root/CenterContentContainer/ImgBg/defaultImg"
local front_mask_path = "Root/CenterContentContainer/ImgBg/frontMask"
local btn_muti_type_change_path = "Root/CenterContentContainer/Layout/BtnMutiTypeChange"
local skip_root_path = "Root/CenterContentContainer/Layout/BtnRecruitTen/SkipRoot"
local select_skip_btn_path = "Root/CenterContentContainer/Layout/BtnRecruitTen/SkipRoot/SelectSkipBtn"
local select_img_path = "Root/CenterContentContainer/Layout/BtnRecruitTen/SkipRoot/SelectSkipBtn/SelectImg"
local UIHeroRecruitWishEntranceComponent = require("UI/UIHero2/UIHeroRecruitWish/Component/UIHeroRecruitWishEntranceComponent")
local PreviewComponent = require("UI/UIHero2/UIHeroRecruit/Component/Preview/UIHeroRecruitPreviewComponent")
local UIHeroRecruitCtrl = require("UI.UIHero2.UIHeroRecruit.Controller.UIHeroRecruitCtrl")
local ArrowManager = require("DataCenter.ArrowManager.ArrowManager")
local root_path = "Root"
local multi_type_change_eff_point_path = "Root/CenterContentContainer/Layout/BtnRecruitTen/MultiTypeChangeEffPoint"
local select_btn_icon_path = "Root/CenterContentContainer/Layout/BtnMutiTypeChange/SelectBtnIcon"
local RECRUIT_100_BTN_CHANGE_EFF_PATH = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_ui_herorecruit100_saoguang.prefab"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.ctrl:GetDataFromServer()
  self:OnOpen()
  if self.centerWorkerNewContentContainer and self.lotteryData then
    self.centerWorkerNewContentContainer:OnRequestWorkerLotteryInfo(self.lotteryData)
  end
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.RecruitmentUI)
end

local function OnDestroy(self)
  self:DeleteFreeCountdownTimer()
  self:CloseBarAni()
  self:ComponentDestroy()
  if self.heroSpineRequest ~= nil then
    self.heroSpineRequest:Destroy()
    self.heroSpineRequest = nil
  end
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.anim = self:AddComponent(UIAnimator, "")
  local gray_image = self:AddComponent(UIImage, "Gray")
  self.gray = gray_image:GetMaterial()
  local btnBack = self:AddComponent(UIButton, "Root/BottomBar/BtnBack")
  btnBack:SetOnClick(BindCallback(self, self.ClosePanel))
  self.textTitle = self:AddComponent(UIText, "Root/TopBar/TextTitle")
  self.uiTopItem = self:AddComponent(UITopItem, "Root/CenterContentContainer/ItemBar")
  self.imgBg = self:AddComponent(UIRawImage, "Root/CenterContentContainer/ImgBg")
  self.heroSpine = self:AddComponent(UIBaseContainer, "Root/CenterContentContainer/ImgBg/HeroSpineContainer")
  self.scrollViewTab = self:AddComponent(UIScrollView, "Root/BottomBar/TabContent/ScrollView")
  self.default_img = self:AddComponent(UIBaseContainer, default_img_path)
  self.btnRecruitOneImg = self:AddComponent(UIImage, "Root/CenterContentContainer/BtnRecruitOne")
  self.btnRecruitOne = self:AddComponent(UIButton, "Root/CenterContentContainer/BtnRecruitOne")
  self.btnRecruitTenImg = self:AddComponent(UIImage, "Root/CenterContentContainer/Layout/BtnRecruitTen")
  self.btnRecruitTen = self:AddComponent(UIButton, "Root/CenterContentContainer/Layout/BtnRecruitTen")
  self.btnRecruitOne:SetOnClick(BindCallback(self, self.OnBtnRecruitOneClick))
  self.btnRecruitTen:SetOnClick(BindCallback(self, self.OnBtnRecruitTenClick))
  if btnOnePos == nil then
    btnOnePos = self.btnRecruitOne.transform.localPosition
  end
  self.textBtn1Shadow = self:AddComponent(UIShadow, "Root/CenterContentContainer/BtnRecruitOne/TextBtn1")
  self.textBtn1 = self:AddComponent(UIText, "Root/CenterContentContainer/BtnRecruitOne/TextBtn1")
  self.textBtn2Shadow = self:AddComponent(UIShadow, "Root/CenterContentContainer/Layout/BtnRecruitTen/TextBtn2")
  self.textBtn2 = self:AddComponent(UIText, "Root/CenterContentContainer/Layout/BtnRecruitTen/TextBtn2")
  self.imgCostItem1 = self:AddComponent(UIImage, "Root/CenterContentContainer/BtnRecruitOne/ImgCostItem1")
  self.textCost1 = self:AddComponent(UIText, "Root/CenterContentContainer/BtnRecruitOne/ImgCostItem1/TextCost1")
  self.imgCostItem2 = self:AddComponent(UIImage, "Root/CenterContentContainer/Layout/BtnRecruitTen/ImgCostItem2")
  self.textCost2 = self:AddComponent(UIText, "Root/CenterContentContainer/Layout/BtnRecruitTen/ImgCostItem2/TextCost2")
  self.time_tips = self:AddComponent(UIImage, time_tips_path)
  self.text_time_open = self:AddComponent(UIText, text_time_open_path)
  self.front_mask = self:AddComponent(UIImage, front_mask_path)
  self.recruitOneFreeText = self:AddComponent(UIText, "Root/CenterContentContainer/BtnRecruitOne/FreeRecruitText")
  self.recruitOneFreeCountDownText = self:AddComponent(UIText, "Root/CenterContentContainer/BtnRecruitOne/NextFreeCountDownText")
  self.recruitOneFreeTimesText = self:AddComponent(UIText, "Root/CenterContentContainer/BtnRecruitOne/FreeRecruitTimesText")
  self.recruitOneFreeText:SetLocalText(151114)
  self.scrollViewTab:SetOnItemMoveIn(BindCallback(self, self.OnCreateCell))
  self.scrollViewTab:SetOnItemMoveOut(BindCallback(self, self.OnDeleteCell))
  self.getItemBtn = self:AddComponent(UIButton, "Root/CenterContentContainer/GetItemBtn")
  self.getItemIcon = self:AddComponent(UIImage, "Root/CenterContentContainer/GetItemBtn/GetItemIcon")
  self.getItemBtnName = self:AddComponent(UIText, "Root/CenterContentContainer/GetItemBtn/GetItemBtnName")
  self.getItemBtn:SetOnClick(function()
    if self.lotteryData then
      local costItems = self.lotteryData:GetCostItems()
      if costItems and 0 < #costItems then
        local itemId = costItems[1].itemId
        LWResourceLackUtil:GotoGoodsItemLack(itemId, 1)
      end
    end
  end)
  self.heroCardContent = self:AddComponent(UIBaseContainer, "Root/CenterContentContainer")
  self.centerWorkerNewContentContainer = self:AddComponent(CenterWorkerNewContentContainer, "Root/CenterWorkerNewContentContainer")
  self.textTitle:SetLocalText(110021)
  self.textBtn1:SetLocalText(110115)
  self.textBtn2:SetLocalText(110116)
  self.topBar = self:AddComponent(UIBaseContainer, "Root/TopBar")
  self.bottomBar = self:AddComponent(UIBaseContainer, "Root/BottomBar")
  self.topBarPos = self:AddComponent(UIBaseContainer, "Root/TopBarPos")
  self.bottomBarPos = self:AddComponent(UIBaseContainer, "Root/BottomBarPos")
  self:ResetBarPos()
  self.packageContent = self:AddComponent(UIBaseContainer, "Root/CenterContentContainer/packageContent")
  self.packageNameText = self:AddComponent(UIText, "Root/CenterContentContainer/packageContent/GiftPackageContent/PackageNameText")
  self.packageDiscountTip = self:AddComponent(UIBaseContainer, "Root/CenterContentContainer/packageContent/GiftPackageContent/DiscountTip")
  self.packageDiscountTipText = self:AddComponent(UIText, "Root/CenterContentContainer/packageContent/GiftPackageContent/DiscountTip/DiscountTipText")
  self.giftPackageItemScroll = self:AddComponent(UIScrollView, "Root/CenterContentContainer/packageContent/GiftPackageContent/CellScroll")
  self.giftPackageItemScroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnPackageCreateCell(itemObj, index)
  end)
  self.giftPackageItemScroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnPackageDeleteCell(itemObj, index)
  end)
  self.payBtn = self:AddComponent(UIButton, "Root/CenterContentContainer/packageContent/GiftPackageContent/PayBtn")
  self.payBtn:SetOnClick(function()
    self:OnPayBtnClick()
  end)
  self.payBtn:SetSafeClickMode(true)
  self.payBtnPriceText = self:AddComponent(UIText, "Root/CenterContentContainer/packageContent/GiftPackageContent/PayBtn/PayBtnPriceText")
  self.luckyContent = self:AddComponent(UIBaseContainer, "Root/CenterContentContainer/rightTopLayout/luckyContent")
  self.lickyFill = self:AddComponent(UIImage, "Root/CenterContentContainer/rightTopLayout/luckyContent/Slider/FillArea/Fill")
  self.luckyNum = self:AddComponent(UIText, "Root/CenterContentContainer/rightTopLayout/luckyContent/luckynum")
  self.luckyImage = self:AddComponent(UIButton, "Root/CenterContentContainer/rightTopLayout/luckyContent/luckyImage")
  self.luckyTextContent = self:AddComponent(UIText, "Root/CenterContentContainer/rightTopLayout/luckyContent/luckyTextContent")
  self.luckyText = self:AddComponent(UIText, "Root/CenterContentContainer/rightTopLayout/luckyContent/luckyTextContent/TextContent")
  self.luckyImgArrow = self:AddComponent(UIText, "Root/CenterContentContainer/rightTopLayout/luckyContent/ImgArrow")
  self.itemBar1 = self:AddComponent(UITopItem, "Root/TopBar/TopBarList/ItemBar1")
  self.itemBar2 = self:AddComponent(UITopItem, "Root/TopBar/TopBarList/ItemBar2")
  self.itemBarList = {
    self.itemBar1,
    self.itemBar2
  }
  self.rateBtn = self:AddComponent(UIButton, "Root/CenterContentContainer/rightTopLayout/rateBtn")
  self.rateBtn:SetOnClick(function()
    self:OnRateBtnClick()
  end)
  self.textRateBtn = self:AddComponent(UIText, "Root/CenterContentContainer/rightTopLayout/rateBtn/rateBtnText")
  self.textRateBtn:SetText(Localization:GetString("herorecruit_info_tabletitle2"))
  self.luckyImage:SetOnClick(function()
    self:OnLuckyBtnClick()
  end)
  self.canClick = true
  self.compPreviewContent = self:AddComponent(PreviewComponent, "Root/CenterContentContainer/PreviewContent")
  self.compWatchAd = self:AddComponent(LWMaxAdWatchAd, "Root/WatchAdContent")
  self.btnWishGuide = self:AddComponent(UIButton, "Root/CenterContentContainer/rightTopLayout/wishGuideBtn")
  self.btnWishGuide:SetOnClick(function()
    self:OnBtnWishGuideClick()
  end)
  self.textWishGuide = self:AddComponent(UIText, "Root/CenterContentContainer/rightTopLayout/wishGuideBtn/wishGuideText")
  self.textWishGuide:SetText(Localization:GetString("function_preview_title"))
  self.compWishGuideRed = self:AddComponent(UIBaseContainer, "Root/CenterContentContainer/rightTopLayout/wishGuideBtn/RedWishGuide")
  self.compWishContent = self:AddComponent(UIHeroRecruitWishEntranceComponent, "Root/CenterContentContainer/WishContent")
  self.compRightTopContent = self:AddComponent(UIBaseContainer, "Root/CenterContentContainer/rightTopLayout")
  self.multiRecruitChangeImg = self:AddComponent(UIImage, btn_muti_type_change_path)
  self.multiRecruitChangeBtn = self:AddComponent(UIButton, btn_muti_type_change_path)
  self.multiRecruitChangeBtn:SetOnClick(function()
    self:ChangeMultiRecruitType()
  end)
  self.skipAreaObj = self:AddComponent(UIBaseContainer, skip_root_path)
  self.skipToggleBtn = self:AddComponent(UIButton, select_skip_btn_path)
  self.skipToggleBtn:SetOnClick(function()
    self:ClickChangeSkipBtn()
  end)
  self.skipSelectImgObj = self:AddComponent(UIBaseContainer, select_img_path)
  self.change100RecruitEff = self:AddComponent(UIVfx, multi_type_change_eff_point_path, RECRUIT_100_BTN_CHANGE_EFF_PATH, {
    lifeType = UIVfxLifeType.Stay
  })
  self.multiRecruitChangeBtnImg = self:AddComponent(UIBaseContainer, select_btn_icon_path)
  self.rootObj = self:AddComponent(UIBaseContainer, root_path)
end

local function ComponentDestroy(self)
  self.anim = nil
  self.textTitle = nil
  self.uiTopItem = nil
  self.scrollViewTab = nil
  self.textBtn1 = nil
  self.textBtn2 = nil
  self.imgCostItem1 = nil
  self.textCost1 = nil
  self.imgCostItem2 = nil
  self.textCost2 = nil
  self.recruitOneFreeText = nil
  self.recruitOneFreeCountDownText = nil
  self.recruitOneFreeTimesText = nil
  self.getItemBtn = nil
  self.getItemIcon = nil
  self.getItemBtnName = nil
  self.heroCardContent = nil
  self.centerWorkerNewContentContainer = nil
  self.topBar = nil
  self.bottomBar = nil
  self.topBarPos = nil
  self.bottomBarPos = nil
  self.packageContent = nil
  self.packageNameText = nil
  self.packageDiscountTip = nil
  self.packageDiscountTipText = nil
  self.giftPackageItemScroll = nil
  self.payBtn = nil
  self.payBtnPriceText = nil
  self.luckyContent = nil
  self.lickyFill = nil
  self.luckyNum = nil
  self.luckyImage = nil
  self.itemBar1 = nil
  self.itemBar2 = nil
  self.itemBarList = nil
  self.rateBtn = nil
  self.textRateBtn = nil
  self.default_img = nil
  self.front_mask = nil
  self.compWishContent = nil
  self.sliderWish = nil
  self.imgWish = nil
  self.btnWishImage = nil
  self.textWishNum = nil
  self.btnWishGuide = nil
  self.textWishGuide = nil
  self.compWishContent = nil
  self.compWishGuideRed = nil
  self.compRightTopContent = nil
  self.multiRecruitChangeBtn = nil
  self.multiRecruitChangeImg = nil
  self.skipAreaObj = nil
  self.skipToggleBtn = nil
  self.skipSelectImgObj = nil
  self.btnRecruitOne = nil
  self.btnRecruitTen = nil
  self.rootObj = nil
  self.change100RecruitEff = nil
  self.luckyTextContent = nil
  self.luckyText = nil
  self.luckyImgArrow = nil
  if self.guideTimer then
    self.guideTimer:Stop()
    self.guideTimer = nil
  end
  if self.showArrowTimer then
    self.showArrowTimer:Stop()
    self.showArrowTimer = nil
  end
  self.compWatchAd = nil
end

local function DataDefine(self)
  self.heroSpineRequest = nil
  self.curMultiRecruitType = nil
end

local function DataDestroy(self)
  self:DeleteFreeCountdownTimer()
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  if self.arrowTime ~= nil then
    self.arrowTime:Stop()
    self.arrowTime = nil
  end
  if self.closeCallBack ~= nil then
    self.closeCallBack()
  end
  if self.selectBtnIconTweenSeq then
    self.selectBtnIconTweenSeq:Kill()
    self.selectBtnIconTweenSeq = nil
  end
  self.lotteryData = nil
  self.curMultiRecruitType = nil
  self.isSelectSkip = nil
  self.prevItemCount = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  DataCenter.LotteryDataManager:CheckCampRecruitFlag()
  self:UpdateView(false)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroicRecruitmentData, self.OnHandleRecruitResponse)
  self:AddUIListener(EventId.RecruitCampChange, self.OnHandleCampSwitch)
  self:AddUIListener(EventId.UpdateGiftPackData, self.UpdateGiftPackage)
  self:AddUIListener(EventId.HeroLotteryInfoUpdate, self.OnDataUpdate)
  self:AddUIListener(EventId.RefreshItems, self.OnItemRefresh)
  self:AddUIListener(EventId.UIHeroRecruitHideBarAni, self.PlayHideBarAni)
  self:AddUIListener(EventId.UIHeroRecruitShowBarAni, self.PlayShowBarAni)
  self:AddUIListener(EventId.HeroLotteryClaimWishGuideSuccess, self.OnClaimWishGuide)
  self:AddUIListener(EventId.CloseRecruit100Panel, self.OnCloseRecruit100Reward)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.HeroicRecruitmentData, self.OnHandleRecruitResponse)
  self:RemoveUIListener(EventId.RecruitCampChange, self.OnHandleCampSwitch)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.UpdateGiftPackage)
  self:RemoveUIListener(EventId.HeroLotteryInfoUpdate, self.OnDataUpdate)
  self:RemoveUIListener(EventId.RefreshItems, self.OnItemRefresh)
  self:RemoveUIListener(EventId.UIHeroRecruitHideBarAni, self.PlayHideBarAni)
  self:RemoveUIListener(EventId.UIHeroRecruitShowBarAni, self.PlayShowBarAni)
  self:RemoveUIListener(EventId.HeroLotteryClaimWishGuideSuccess, self.OnClaimWishGuide)
  self:RemoveUIListener(EventId.CloseRecruit100Panel, self.OnCloseRecruit100Reward)
  base.OnRemoveListener(self)
end

local function RefreshGoldNum(self)
  local gold = LuaEntry.Player.gold
  self.textGoldNum:SetText(string.GetFormattedSeperatorNum(gold))
end

local function OnOpen(self)
  self:GenerateTabs()
  local fromBubble, isArrow, selectIndex, closeCallBack, isWorker = self:GetUserData()
  self.isArrow = isArrow
  local isWorkerUnlock, lockTips = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.Worker_Lottery)
  local idx = 1
  if selectIndex and self.dataList ~= nil then
    for i, v in pairs(self.dataList) do
      if v.id == selectIndex then
        idx = i
        break
      end
    end
  end
  if fromBubble then
    idx = DataCenter.LotteryDataManager:GetCurTipBubbleType()
  end
  self.closeCallBack = closeCallBack
  local questTemplate = DataCenter.GuideManager.questTemplate
  if isWorker and isWorkerUnlock then
    for i, v in pairs(self.dataList) do
      if v.type == OfficerRecruitType.WorkerRecruit then
        idx = i
        break
      end
    end
  elseif self.dataList ~= nil and questTemplate ~= nil and not string.IsNullOrEmpty(questTemplate.para1) then
    for i, v in pairs(self.dataList) do
      if tonumber(v.id) == questTemplate.para1 then
        idx = i
        self.isArrow = i
        break
      end
    end
  end
  self:OnSwitchTab(idx)
  self.anim:Play("Eff_UIHeroRecruit_in")
end

local function GenerateTabs(self)
  self.dataList = self.ctrl:GetNewLotteryList()
  local dataCount = table.count(self.dataList)
  self:ClearTabs()
  if dataCount <= 0 then
    return
  end
  self.scrollViewTab:SetTotalCount(dataCount)
  self.scrollViewTab:RefillCells(1)
  self.arrowTime = TimerManager:GetInstance():DelayInvoke(function()
    if self.isArrow then
      local isCur = self.currentTabIdx == self.isArrow
      local param = {}
      if self.tabs and next(self.tabs) then
        param.position = self.tabs[self.isArrow]:GetPosition()
        param.positionType = PositionType.Screen
        param.isPanel = false
        self.isArrow = nil
      end
      if isCur then
        param.position = self.btnRecruitOne.transform.position
      else
        param.isReversal = true
        param.YisReversal = true
      end
      if param.position ~= nil then
        DataCenter.ArrowManager:ShowArrow(param)
      end
    end
  end, 0.5)
end

local function ClearTabs(self)
  self.scrollViewTab:ClearCells()
  self.scrollViewTab:RemoveComponents(UITabCell)
  self.tabs = {}
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local data = self.dataList[index]
  local tabCell = self.scrollViewTab:AddComponent(UITabCell, itemObj)
  tabCell:SetData(index, data, BindCallback(self, self.OnSwitchTab))
  self.tabs[index] = tabCell
end

local function OnDeleteCell(self, itemObj, index)
  self.scrollViewTab:RemoveComponent(itemObj.name, UITabCell)
  self.tabs[index] = nil
end

local function RefreshCellsRedPoint(self)
  if self.tabs ~= nil then
    for i, v in pairs(self.tabs) do
      v:UpdateRedPoint()
    end
  end
end

local function OnSwitchTab(self, idx, force)
  if not force and idx == self.currentTabIdx then
    return
  end
  if self.dataList == nil or table.count(self.dataList) == 0 then
    return
  end
  if idx == nil or idx == 0 or idx > table.count(self.dataList) then
    idx = 1
  end
  local lastTab = self.tabs[self.currentTabIdx]
  self.currentTabIdx = idx
  local curTab = self.tabs[self.currentTabIdx]
  if lastTab ~= nil then
    lastTab:UpdateSelect()
  end
  if curTab ~= nil then
    curTab:UpdateSelect()
  end
  self:DeleteFreeCountdownTimer()
  local isRefreshPackageItem = true
  self:UpdateView(isRefreshPackageItem)
  DataCenter.ArrowManager:RemoveArrow()
end

local function UpdatePityText(self)
  local lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(self.curLotteryId)
  local now = UITimeManager:GetInstance():GetServerTime()
  local flag = true
  if lotteryData == nil then
    flag = false
  elseif lotteryData:IsDurationType() and now < lotteryData.startTime then
    flag = false
  end
  self.rateBtn:SetActive(flag)
  if lotteryData ~= nil and lotteryData.pityMaxProtectNum > 0 and flag then
    self.luckyContent:SetActive(true)
    local pityCurProtectNum = lotteryData.pityCurProtectNum
    self.luckyNum:SetLocalText(150033, pityCurProtectNum, lotteryData.pityMaxProtectNum)
    local percent = pityCurProtectNum / lotteryData.pityMaxProtectNum
    percent = math.max(0, math.min(percent, 1))
    self.lickyFill:SetFillAmount(percent)
    self:UpdateLuckyContentState(false, lotteryData.pityMaxProtectNum - pityCurProtectNum)
  else
    self.luckyContent:SetActive(false)
  end
end

function UIHeroRecruitView:DeleteFreeCountdownTimer()
  self.prevCanFreeRecruitState = nil
  if self.freeCountdownTimer ~= nil then
    self.freeCountdownTimer:Stop()
    self.freeCountdownTimer = nil
  end
end

function UIHeroRecruitView:AddFreeCountdownTimer()
  if self.freeCountdownTimer == nil then
    local time = 1
    self.freeCountdownTimer = TimerManager:GetInstance():GetTimer(time, self.RefreshFreeCountdown, self, false, false, false)
    self.freeCountdownTimer:Start()
  end
end

function UIHeroRecruitView:RefreshFreeCountdown()
  local canFreeRecruit = self.lotteryData:CanFreeRecruit()
  if canFreeRecruit ~= self.prevCanFreeRecruitState then
    if canFreeRecruit then
      self.recruitOneFreeText:SetActive(true)
      self.recruitOneFreeCountDownText:SetActive(false)
      self.recruitOneFreeTimesText:SetActive(false)
      self.imgCostItem1:SetActive(false)
    else
      self.recruitOneFreeText:SetActive(false)
      self.recruitOneFreeCountDownText:SetActive(true)
      self.recruitOneFreeTimesText:SetActive(false)
      self.imgCostItem1:SetActive(true)
    end
  end
  self.prevCanFreeRecruitState = canFreeRecruit
  if canFreeRecruit then
    self:DeleteFreeCountdownTimer()
    return true
  else
    local now = UITimeManager:GetInstance():GetServerSeconds()
    self.recruitOneFreeCountDownText:SetLocalText(151113, UITimeManager:GetInstance():SecondToFmtString(self.lotteryData.dailyFreeNextFreshTime - now))
    return false
  end
end

local function UpdateView(self, isRefreshPackageItem)
  self:CloseBarAni()
  self:ResetBarPos()
  local curTab = self.dataList[self.currentTabIdx]
  if curTab.type == OfficerRecruitType.WorkerRecruit then
    self:UpdateWorkerView()
  else
    self:UpdateHeroView(isRefreshPackageItem)
  end
  self:RefreshWatchAd()
  self:SkinAnimUpdateSkipRootPosition()
end

local function UpdateWorkerView(self)
  self.heroCardContent:SetActive(false)
  self.centerWorkerNewContentContainer:SetActive(true)
  self.curLotteryId = self.dataList[self.currentTabIdx].id
  self.lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(self.curLotteryId)
  self.centerWorkerNewContentContainer:OnOpen(self.lotteryData)
  self:UpdateTopItemBar()
end

local function UpdateHeroView(self, isRefreshPackageItem)
  self.heroCardContent:SetActive(true)
  self.centerWorkerNewContentContainer:SetActive(false)
  self.curLotteryId = self.dataList[self.currentTabIdx].id
  self.lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(self.curLotteryId)
  self.isSelectSkip = CommonUtil.PlayerPrefsGetBool("Recruit100SkipState", false)
  if not string.IsNullOrEmpty(self.lotteryData.foreground_image) then
    self.front_mask:SetActive(true)
    self.front_mask:LoadSprite(self.lotteryData.foreground_image)
  else
    self.front_mask:SetActive(false)
  end
  self:UpdateCurMultiRecruitType()
  self:UpdateBg()
  self:UpdateTopItemBar()
  self:UpdatePityText()
  if isRefreshPackageItem then
    self:UpdateGiftPackageInfo()
  end
  self:UpdateBottomButtons()
  self:RefreshCellsRedPoint()
  self:UpdateHeroWish()
  self:UpdatePreview()
end

local function UpdateCurMultiRecruitType(self)
  self:SetCurMultiRecruitType(UIHeroMultiRecruitType.Ten)
  local costItemId, costItemNum = self:GetItemCost()
  local itemId = costItemId
  local item = DataCenter.ItemData:GetItemById(itemId)
  local curHave = item and item.count or 0
  self.prevItemCount = curHave
end

local function SetCurMultiRecruitType(self, targetMultiRecruitType)
  if self.canClick == false then
    return
  end
  local conditionInfo = self.lotteryData and self.lotteryData:GetHundredBtnShowCondition()
  if targetMultiRecruitType == UIHeroMultiRecruitType.OneHundred and not conditionInfo then
    return
  end
  if (not self.curMultiRecruitType or self.curMultiRecruitType == UIHeroMultiRecruitType.Ten) and targetMultiRecruitType == UIHeroMultiRecruitType.OneHundred then
    self.change100RecruitEff:Replay()
  else
    self.change100RecruitEff:Stop()
  end
  self.curMultiRecruitType = targetMultiRecruitType
end

local function UpdateHeroWish(self)
  self.btnWishGuide:SetActive(DataCenter.LotteryDataManager:IsShowHeroWishGuide())
  self.compWishGuideRed:SetActive(DataCenter.LotteryDataManager:IsCanClaimHeroWishGuideReward())
  if not self.lotteryData then
    return
  end
  local isShowWish = self.lotteryData:IsShowWish()
  self.compWishContent:SetActive(isShowWish)
  if isShowWish then
    self.compWishContent:ReInit(self.curLotteryId)
  end
end

local function UpdatePreview(self)
  if not self.lotteryData then
    return
  end
  local previewInfo = self.lotteryData:GetPreviewInfo()
  local isShowPreview = not table.IsNullOrEmpty(previewInfo)
  self.compPreviewContent:SetActive(isShowPreview)
  if isShowPreview then
    self.compPreviewContent:ReInit(self.curLotteryId)
  end
end

local function UpdateBg(self)
  if self.lotteryData == nil then
    return
  end
  local vec = string.split(self.lotteryData.picture, "|")
  if self.heroSpineRequest ~= nil then
    self.heroSpineRequest:Destroy()
    self.heroSpineRequest = nil
  end
  if table.count(vec) == 2 then
    local path = string.format(CampRecruitBgPath, vec[1])
    local heroPath = vec[2]
    self.imgBg:LoadSprite(path)
    self.default_img:SetActive(false)
    local request = ResourceManager:InstantiateAsync(heroPath)
    self.heroSpineRequest = request
    request:completed("+", function()
      if request.isError or request.gameObject == nil then
        self.heroSpineRequest = nil
        return
      end
      request.gameObject:SetActive(true)
      local spineScale = 1
      local spinePos = {0, 0}
      if not table.IsNullOrEmpty(self.lotteryData.spineParam) and table.count(self.lotteryData.spineParam) >= 3 then
        spineScale = self.lotteryData.spineParam[1]
        spinePos = {
          self.lotteryData.spineParam[2],
          self.lotteryData.spineParam[3]
        }
      end
      self.heroSpine.rectTransform:Set_localScale(spineScale, spineScale, 1)
      self.heroSpine.rectTransform:Set_anchoredPosition(spinePos[1], spinePos[2], 0)
      local rectTransform = request.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
      if rectTransform ~= nil then
        rectTransform:SetParent(self.heroSpine.transform)
        rectTransform:Set_localScale(1, 1, 1)
        rectTransform:Set_anchoredPosition(0, 0)
      end
    end)
  elseif table.count(vec) == 1 then
    local path = string.format(CampRecruitBgPath, vec[1])
    self.imgBg:LoadSprite(path)
    if self.lotteryData.is_season == 1 then
      self.default_img:SetActive(false)
    else
      self.default_img:SetActive(true)
    end
  end
end

local function UpdateTopItemBar(self)
  local curTab = self.dataList[self.currentTabIdx]
  local goldIndex = 2
  local itemIndex = 1
  self.itemBarList[goldIndex]:SetActive(true)
  self.itemBarList[goldIndex]:SetData(nil, ResourceType.Gold)
  if curTab.type == OfficerRecruitType.WorkerRecruit then
    local oldItemId = LuaEntry.DataConfig:TryGetNum("worker_recruit_1", "k3", 0)
    local itemId = DataCenter.LotteryDataManager:GetOnlyWorkerLotteryCostItemId() or oldItemId
    if 0 < itemId then
      self.itemBarList[itemIndex]:SetActive(true)
      self.itemBarList[itemIndex]:SetData(tostring(itemId))
    else
      self.itemBarList[itemIndex]:SetActive(false)
    end
  else
    local costItems
    if self.lotteryData ~= nil then
      costItems = self.lotteryData:GetCostItems()
    else
      costItems = {}
      local item = GetTableData(TableName.HeroRecruit, self.curLotteryId, "item")
      local list1 = string.split(item, "|")
      for k, value in ipairs(list1) do
        local list2 = string.split(value, ";")
        local t = {}
        t.itemId = list2[1]
        t.itemNum = tonumber(list2[2])
        costItems[k] = t
      end
    end
    if costItems == nil or #costItems <= 0 then
      self.itemBarList[itemIndex]:SetActive(false)
      return
    end
    local itemId = costItems[1].itemId
    self.itemBarList[itemIndex]:SetActive(true)
    self.itemBarList[itemIndex]:SetData(itemId)
  end
end

local function UpdateBottomButtons(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  local flag = true
  if self.lotteryData == nil then
    self.btnRecruitOne:SetActive(false)
    self.btnRecruitTen:SetActive(false)
    self.time_tips:SetActive(false)
    return
  end
  if self.lotteryData:IsDurationType() then
    if now < self.lotteryData.startTime then
      self.time_tips:SetActive(true)
      self.btnRecruitOne:SetActive(false)
      self.btnRecruitTen:SetActive(false)
      self.multiRecruitChangeBtn:SetActive(false)
      self:Update1000MS()
      flag = false
      return
    elseif now < self.lotteryData.endTime then
      self.time_tips:SetActive(true)
      self.btnRecruitOne:SetActive(true)
      self.btnRecruitTen:SetActive(true)
      self:Update1000MS()
    else
      self.time_tips:SetActive(false)
      self.btnRecruitOne:SetActive(false)
      self.btnRecruitTen:SetActive(false)
    end
  else
    self.time_tips:SetActive(false)
    self.btnRecruitOne:SetActive(true)
    self.btnRecruitTen:SetActive(true)
  end
  local supportFreeRecruit = self.lotteryData:IsSupportFreeRecruit()
  local needUpdator = false
  if supportFreeRecruit then
    needUpdator = not self:RefreshFreeCountdown()
  else
    self.recruitOneFreeText:SetActive(false)
    self.recruitOneFreeCountDownText:SetActive(false)
    self.recruitOneFreeTimesText:SetActive(false)
    self.imgCostItem1:SetActive(true)
  end
  if needUpdator then
    self:AddFreeCountdownTimer()
  else
    self:DeleteFreeCountdownTimer()
  end
  self.btnRecruitOne:SetActive(true)
  local showTenFlag = true
  self.btnRecruitTen:SetActive(showTenFlag)
  if self.canClick == false then
    self.btnRecruitOneImg:SetMaterial(self.gray)
    self.btnRecruitTenImg:SetMaterial(self.gray)
    self.multiRecruitChangeImg:SetMaterial(self.gray)
  else
    self.btnRecruitOneImg:SetMaterial(nil)
    self.btnRecruitTenImg:SetMaterial(nil)
    self.multiRecruitChangeImg:SetMaterial(nil)
  end
  local costItems = self.lotteryData:GetCostItems()
  self.imgCostItem1:LoadSprite(string.format(LoadPath.ItemPath, DataCenter.ItemTemplateManager:GetItemTemplate(costItems[1].itemId).icon))
  self.textCost1:SetText(costItems[1].itemNum)
  local isCanHundredRecruit = self:IsCanShowHundredBtn()
  self:UpdateMultiChangeBtnState(isCanHundredRecruit)
  self.skipAreaObj:SetActive(self.curMultiRecruitType == UIHeroMultiRecruitType.OneHundred)
  if isCanHundredRecruit then
    self:UpdateSkipToggleState()
  end
  local costItemId, costItemNum = self:GetItemCost()
  self.imgCostItem2:LoadSprite(string.format(LoadPath.ItemPath, DataCenter.ItemTemplateManager:GetItemTemplate(costItemId).icon))
  self.textCost2:SetText(costItemNum)
  local multiBtnKey = self.curMultiRecruitType == UIHeroMultiRecruitType.OneHundred and "hero_recruit_100_tips4" or 110116
  self.textBtn2:SetLocalText(multiBtnKey)
end

local function UpdateMultiChangeBtnState(self, isCanHundredRecruit)
  self.multiRecruitChangeBtn:SetActive(isCanHundredRecruit)
  if not isCanHundredRecruit then
    if self.selectBtnIconTweenSeq then
      self.selectBtnIconTweenSeq:Pause()
    end
    return
  end
  if not self.selectBtnIconTweenSeq then
    self.selectBtnIconTweenSeq = CS.DG.Tweening.DOTween.Sequence()
    self.selectBtnIconTweenSeq:Append(self.multiRecruitChangeBtnImg.transform:DORotate(Vector3.New(0, 0, -180), 0.8, CS.DG.Tweening.RotateMode.LocalAxisAdd):SetEase(CS.DG.Tweening.Ease.Linear))
    self.selectBtnIconTweenSeq:AppendInterval(2)
    self.selectBtnIconTweenSeq:Append(self.multiRecruitChangeBtnImg.transform:DORotate(Vector3.New(0, 0, -180), 0.8, CS.DG.Tweening.RotateMode.LocalAxisAdd):SetEase(CS.DG.Tweening.Ease.Linear))
    self.selectBtnIconTweenSeq:AppendInterval(2)
    self.selectBtnIconTweenSeq:SetLoops(-1)
  else
    self.selectBtnIconTweenSeq:PlayForward()
  end
end

local function UpdateGiftPackage(self)
  local isRefreshPackageItem = true
  self:UpdateView(isRefreshPackageItem)
end

local function UpdateGiftPackageInfo(self)
  local lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(self.curLotteryId)
  local costItems = lotteryData:GetCostItems()
  local itemId = costItems[1].itemId
  self.packageData = self.ctrl:GetPackageInfoByItemId(itemId)
  self.packageContent:SetActive(self.packageData ~= nil)
  if self.packageData == nil then
    self.compRightTopContent:SetAnchoredPositionXY(self.compRightTopContent:GetAnchoredPositionX(), -225)
  else
    self.compRightTopContent:SetAnchoredPositionXY(self.compRightTopContent:GetAnchoredPositionX(), -391)
  end
  if self.packageData then
    self.packageNameText:SetText(self.packageData:getNameText())
    if self.packageData:hasPercent() then
      self.packageDiscountTip:SetActive(true)
      self.packageDiscountTipText:SetLocalText(2000111, self.packageData:getPercent())
    else
      self.packageDiscountTip:SetActive(false)
      self.packageDiscountTipText:SetText("")
    end
    self:ClearPackageScroll()
    self.packageRewardList = self.packageData:getItems(false)
    if #self.packageRewardList > 0 then
      self.giftPackageItemScroll:SetActive(true)
      self.giftPackageItemScroll:SetTotalCount(#self.packageRewardList)
      self.giftPackageItemScroll:RefillCells()
    else
      self.giftPackageItemScroll:SetActive(false)
    end
    self.payBtnPriceText:SetText(self.packageData:getPriceText())
    self.payBtnPriceText:SetColor(WhiteColor)
  end
end

local function ClearPackageScroll(self)
  self.giftPackageItemScroll:ClearCells()
  self.giftPackageItemScroll:RemoveComponents(UICommonResItem)
end

local function OnPackageCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.giftPackageItemScroll:AddComponent(UICommonResItem, itemObj)
  cellItem:ReInit(self.packageRewardList[index])
end

local function OnPackageDeleteCell(self, itemObj, index)
  self.giftPackageItemScroll:RemoveComponent(itemObj.name, UICommonResItem)
end

local function OnPayBtnClick(self)
  if self.packageData then
    DataCenter.PayManager:CallPayment(self.packageData, "GoldExchangeView", "")
  end
end

local function Update1000MS(self)
  if self.time_tips == nil then
    return
  end
  self:SkinAnimUpdateSkipRootPosition()
  if not self.time_tips:GetActive() then
    return
  end
  if self.lotteryData ~= nil then
    if self.lotteryData:IsDurationType() then
      local now = UITimeManager:GetInstance():GetServerTime()
      local leftTime = -1
      local strTime = ""
      if now < self.lotteryData.startTime then
        self.time_tips:SetAnchoredPositionXY(0, 310)
        leftTime = math.max(0, self.lotteryData.startTime - now)
        strTime = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
        self.text_time_open:SetText(Localization:GetString("season_recruit_tips001") .. "\n" .. strTime)
      elseif now < self.lotteryData.endTime then
        self.time_tips:SetAnchoredPositionXY(0, 440)
        leftTime = math.max(0, self.lotteryData.endTime - now)
        strTime = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
        self.text_time_open:SetText(Localization:GetString("season_recruit_tips002") .. "\n" .. strTime)
      else
        leftTime = 0
      end
      if leftTime == 0 then
        if self.time_tips:GetActive() then
          self.btnRecruitOne:SetActive(true)
          self.btnRecruitTen:SetActive(true)
          self:UpdatePityText()
          self:UpdateHeroWish()
          self.time_tips:SetActive(false)
        end
      elseif not self.time_tips:GetActive() then
        self.time_tips:SetActive(true)
        self.btnRecruitOne:SetActive(false)
        self.btnRecruitTen:SetActive(false)
      end
    elseif self.time_tips:GetActive() then
      self:UpdatePityText()
      self:UpdateHeroWish()
      self.btnRecruitOne:SetActive(true)
      self.btnRecruitTen:SetActive(true)
      self.time_tips:SetActive(false)
    end
  end
end

local function SkinAnimUpdateSkipRootPosition(self)
  if self.skipAreaObj == nil then
    return
  end
  if self.time_tips == nil then
    return
  end
  if self.compWishContent == nil then
    return
  end
  if self.time_tips:GetActive() or self.compWishContent:GetActive() then
    self.skipAreaObj:SetAnchoredPositionXY(-139, 206)
  else
    self.skipAreaObj:SetAnchoredPositionXY(-139, 101)
  end
end

local function OnBtnInfoClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruitTip, {anim = true}, self.curLotteryId)
end

local function OnBtnChangeCampClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruitChangeCamp, self.curLotteryId)
end

local function OnBtnRecruitOneClick(self)
  DataCenter.ArrowManager:RemoveArrow()
  if self.canClick == false then
    return
  end
  if self.lotteryData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < sendMsgTime + 1000 then
    return
  end
  sendMsgTime = curTime
  local supportFreeRecruit = self.lotteryData:IsSupportFreeRecruit()
  local canFreeRecruit = self.lotteryData:CanFreeRecruit()
  local costItems = self.lotteryData:GetCostItems()
  local itemId = costItems[1].itemId
  local itemNum = costItems[1].itemNum
  if supportFreeRecruit and canFreeRecruit then
    local function DoRecruit()
      self.canClick = false
      
      self.btnRecruitOneImg:SetMaterial(self.gray)
      self.btnRecruitTenImg:SetMaterial(self.gray)
      self.multiRecruitChangeImg:SetMaterial(self.gray)
      DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ClickHeroRecruit, SaveGuideDoneValue)
      SFSNetwork.SendMessage(MsgDefines.LotteryHeroCard, self.curLotteryId, 0, 1, itemId)
    end
    
    local showEmptyWishConfirm = self.lotteryData:IsShowWish() and self.lotteryData:GetCurSelectWishHeroId() == nil
    if showEmptyWishConfirm then
      UIUtil.ShowSecondMessage("", Localization:GetString("herorecruit_alert1"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        DoRecruit()
      end, nil, nil, nil, false, nil, nil, nil, nil, false)
    else
      local wishHeroRankConfirmKey = self.lotteryData:GetWishLotterySecondConfirmKey()
      if not string.IsNullOrEmpty(wishHeroRankConfirmKey) then
        UIUtil.ShowSecondMessage("", Localization:GetString(wishHeroRankConfirmKey), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          DoRecruit()
        end, nil, nil, nil, false, nil, nil, nil, nil, false)
      else
        DoRecruit()
      end
    end
    return
  else
    local item = DataCenter.ItemData:GetItemById(itemId)
    local have = item and item.count or 0
    if itemNum > have then
      LWResourceLackUtil:GotoGoodsItemLack(itemId, itemNum - have)
      return
    end
    
    local function DoRecruit()
      self.canClick = false
      self.btnRecruitOneImg:SetMaterial(self.gray)
      self.btnRecruitTenImg:SetMaterial(self.gray)
      self.multiRecruitChangeImg:SetMaterial(self.gray)
      DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ClickHeroRecruit, SaveGuideDoneValue)
      SFSNetwork.SendMessage(MsgDefines.LotteryHeroCard, self.curLotteryId, 0, 0, itemId)
    end
    
    local showEmptyWishConfirm = self.lotteryData:IsShowWish() and self.lotteryData:GetCurSelectWishHeroId() == nil
    if showEmptyWishConfirm then
      UIUtil.ShowSecondMessage("", Localization:GetString("herorecruit_alert1"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        DoRecruit()
      end, nil, nil, nil, false, nil, nil, nil, nil, false)
    else
      do
        local wishHeroRankConfirmKey = self.lotteryData:GetWishLotterySecondConfirmKey()
        if not string.IsNullOrEmpty(wishHeroRankConfirmKey) then
          UIUtil.ShowSecondMessage("", Localization:GetString(wishHeroRankConfirmKey), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            DoRecruit()
          end, nil, nil, nil, false, nil, nil, nil, nil, false)
        else
          DoRecruit()
        end
      end
    end
  end
end

local function OnBtnRecruitTenClick(self)
  DataCenter.ArrowManager:RemoveArrow()
  if self.canClick == false then
    return
  end
  if self.lotteryData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < sendMsgTime + 1000 then
    return
  end
  sendMsgTime = curTime
  local costItemId, costItemNum = self:GetItemCost()
  local itemId = costItemId
  local itemNum = costItemNum
  local item = DataCenter.ItemData:GetItemById(itemId)
  local have = item and item.count or 0
  if itemNum > have then
    LWResourceLackUtil:GotoGoodsItemLack(itemId, itemNum - have)
    return
  end
  local type = 1
  if self.curMultiRecruitType == UIHeroMultiRecruitType.OneHundred then
    type = 2
  end
  local showEmptyWishConfirm = self.lotteryData:IsShowWish() and self.lotteryData:GetCurSelectWishHeroId() == nil
  if showEmptyWishConfirm then
    UIUtil.ShowSecondMessage("", Localization:GetString("herorecruit_alert1"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self:ExecuteMultiRecruitAction(type, itemId)
    end, nil, nil, nil, false, nil, nil, nil, nil, false)
  else
    local wishHeroRankConfirmKey = self.lotteryData:GetWishLotterySecondConfirmKey()
    if not string.IsNullOrEmpty(wishHeroRankConfirmKey) then
      UIUtil.ShowSecondMessage("", Localization:GetString(wishHeroRankConfirmKey), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        self:ExecuteMultiRecruitAction(type, itemId)
      end, nil, nil, nil, false, nil, nil, nil, nil, false)
    else
      self:ExecuteMultiRecruitAction(type, itemId)
    end
  end
end

function UIHeroRecruitView:ExecuteMultiRecruitAction(type, itemId)
  local function DoRecruit()
    self.canClick = false
    
    self.btnRecruitOneImg:SetMaterial(self.gray)
    self.btnRecruitTenImg:SetMaterial(self.gray)
    self.multiRecruitChangeImg:SetMaterial(self.gray)
    DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ClickHeroRecruit, SaveGuideDoneValue)
    SFSNetwork.SendMessage(MsgDefines.LotteryHeroCard, self.curLotteryId, type, 0, itemId)
  end
  
  local isGetAllBoxFromRecruit = self:CheckIsUnlockAllRewardBoxFromRecruit()
  local isSelectTen = self.curMultiRecruitType == UIHeroMultiRecruitType.Ten
  if not isSelectTen and isGetAllBoxFromRecruit then
    UIUtil.TryShowConfirm(TodayNoSecondConfirmType.RecruitConfirmWhenAllianceCompete, Localization:GetString("hero_recruit_100_tips3"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      DoRecruit()
    end, function()
    end, nil, nil, false, nil, nil)
  else
    DoRecruit()
  end
end

local function OnHandleRecruitResponse(self, message)
  local rewardList = message.lotteryHero
  if not rewardList then
    return
  end
  local rewardType = UIHeroMultiRecruitType.Ten
  if message.isTen and toInt(message.isTen) == 2 then
    rewardType = UIHeroMultiRecruitType.OneHundred
  else
    local rewardNum = table.count(rewardList) or 0
    rewardType = 10 < rewardNum and UIHeroMultiRecruitType.OneHundred or UIHeroMultiRecruitType.Ten
  end
  if rewardType == UIHeroMultiRecruitType.Ten then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIHeroRecruitRewardNew) == false then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruitRewardNew, self.curLotteryId, message)
    end
  elseif UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIHero100Recruit) == false then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHero100Recruit, self.curLotteryId, message, self.isSelectSkip, true)
  end
  self.canClick = true
  local curTime = UITimeManager:GetInstance():GetServerTime()
  sendMsgTime = curTime
  local isRefreshPackageItem = false
  self:UpdateView(isRefreshPackageItem)
end

local function OnHandleCampSwitch(self, lotteryId)
  self:GenerateTabs()
  local idx = self.currentTabIdx
  for k, v in pairs(self.dataList) do
    if v.id == lotteryId then
      idx = k
      break
    end
  end
  self:OnSwitchTab(idx, true)
end

local function OnDataUpdate(self)
  local allData = self.ctrl:GetNewLotteryList()
  local isChange = false
  if self.dataList == nil or allData == nil or table.count(self.dataList) ~= table.count(allData) then
    isChange = true
  else
    local index = 1
    local total = table.count(self.dataList)
    while index <= total do
      if allData[index].id ~= self.dataList[index].id then
        isChange = true
        break
      else
        if allData[index].dailyFree ~= self.dataList[index].dailyFree then
          isChange = true
          break
        end
        if allData[index].dailyFreeNextFreshTime ~= self.dataList[index].dailyFreeNextFreshTime then
          isChange = true
          break
        end
      end
      index = index + 1
    end
  end
  if isChange then
    self:OnOpen()
  end
end

local function ClosePanel(self)
  if self.closeCallBack ~= nil then
    self.closeCallBack()
  end
  self.ctrl.CloseSelf()
end

local function ResetBarPos(self)
  self.topBar:SetPosition(self.topBarPos:GetPosition())
  self.bottomBar:SetPosition(self.bottomBarPos:GetPosition())
end

local function CloseBarAni(self)
  if self.barAniSeq ~= nil then
    self.barAniSeq:Kill()
    self.barAniSeq = nil
  end
end

local function PlayHideBarAni(self)
  self:CloseBarAni()
  local moveTime = 0.6
  local moveY = 500
  self.barAniSeq = DOTween.Sequence()
  self.barAniSeq:Append(self.topBar.transform:DOMoveY(self.topBarPos:GetPosition().y + moveY, moveTime))
  self.barAniSeq:Insert(0, self.bottomBar.transform:DOMoveY(self.bottomBarPos:GetPosition().y - moveY, moveTime))
  self.barAniSeq:OnComplete(function()
    self:CloseBarAni()
  end)
end

local function PlayShowBarAni(self)
  self:CloseBarAni()
  local moveTime = 0.6
  self.barAniSeq = DOTween.Sequence()
  self.barAniSeq:Append(self.topBar.transform:DOMoveY(self.topBarPos:GetPosition().y, moveTime))
  self.barAniSeq:Insert(0, self.bottomBar.transform:DOMoveY(self.bottomBarPos:GetPosition().y, moveTime))
  self.barAniSeq:OnComplete(function()
    self:CloseBarAni()
  end)
end

local function OnRateBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruitTipNew, {anim = true}, self.curLotteryId)
end

local function OnLuckyBtnClick(self)
  local param = UICommonTipsView.ParamDataClass.New()
  local lotteryData = self.lotteryData
  local pityCurProtectNum = lotteryData.pityCurProtectNum + 1
  local totalNum = lotteryData.pityMaxProtectNum
  if not string.IsNullOrEmpty(lotteryData.recruit_lucky_info) then
    param.content = Localization:GetString(lotteryData.recruit_lucky_info, totalNum - pityCurProtectNum + 1)
  else
    param.content = Localization:GetString("150217", totalNum - pityCurProtectNum + 1)
  end
  param.position = self.luckyImage:GetPosition()
  param.deltaY = -20
  param.contentX = -20
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonTips, {anim = false}, param)
  self:UpdateLuckyContentState(true)
end

function UIHeroRecruitView:OnBtnWishGuideClick()
  if DataCenter.LotteryDataManager:IsShowHeroWishGuide() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruitWishGuide, {anim = true})
  end
end

function UIHeroRecruitView:OnClaimWishGuide()
  self.compWishGuideRed:SetActive(DataCenter.LotteryDataManager:IsCanClaimHeroWishGuideReward())
end

function UIHeroRecruitView:IsCanShowHundredBtn()
  local conditionInfo = self.lotteryData:GetHundredBtnShowCondition()
  if not conditionInfo then
    return false
  end
  local itemId = conditionInfo.itemId
  local needCount = conditionInfo.itemNum
  local haveNum = DataCenter.ItemData:GetItemCount(itemId)
  return needCount <= haveNum
end

function UIHeroRecruitView:ChangeMultiRecruitType()
  if not self.canClick then
    return
  end
  if self.curMultiRecruitType == UIHeroMultiRecruitType.Ten and self:IsCanShowHundredBtn() then
    self:SetCurMultiRecruitType(UIHeroMultiRecruitType.OneHundred)
  else
    self:SetCurMultiRecruitType(UIHeroMultiRecruitType.Ten)
  end
  self:UpdateBottomButtons()
  self:SkinAnimUpdateSkipRootPosition()
end

function UIHeroRecruitView:GetItemCost()
  if self.curMultiRecruitType == UIHeroMultiRecruitType.Ten then
    local costItems = self.lotteryData:GetCostItems()
    if 2 <= #costItems then
      return costItems[2].itemId, costItems[2].itemNum
    end
  else
    local hundredCostItems = self.lotteryData:GetHundredCost()
    if hundredCostItems then
      return hundredCostItems.itemId, hundredCostItems.itemNum
    else
      return -1, -1
    end
  end
end

function UIHeroRecruitView:CheckIsUnlockAllRewardBoxFromRecruit()
  local recruitScoreSourceType = 42
  local isTodayRecruit = DataCenter.AllianceCompeteDataManager:IsExistTargetScoreTypeInCurAllianceCompete(recruitScoreSourceType)
  if not isTodayRecruit then
    return false
  end
  return DataCenter.AllianceCompeteDataManager:IsCurScoreArriveMaxUnlockBox()
end

function UIHeroRecruitView:ClickChangeSkipBtn()
  self.isSelectSkip = not self.isSelectSkip
  CommonUtil.PlayerPrefsSetBool("Recruit100SkipState", self.isSelectSkip)
  self:UpdateSkipToggleState()
end

function UIHeroRecruitView:UpdateSkipToggleState()
  if not IsNull(self.skipSelectImgObj) then
    self.skipSelectImgObj:SetActive(self.isSelectSkip)
  end
end

function UIHeroRecruitView:OnCloseRecruit100Reward(isHeroDraw)
  if not isHeroDraw then
    return
  end
  self:SetCurMultiRecruitType(UIHeroMultiRecruitType.Ten)
  self.isSelectSkip = CommonUtil.PlayerPrefsGetBool("Recruit100SkipState", false)
  if self.curMultiRecruitType == UIHeroMultiRecruitType.OneHundred then
    self:UpdateSkipToggleState()
  end
end

function UIHeroRecruitView:UpdateLuckyContentState(clickBtn, num)
  local lotteryId = toInt(self.curLotteryId)
  if lotteryId ~= 221600 and lotteryId ~= 221700 then
    self:SetNumFalse()
    return
  end
  local value = DataCenter.HeroDataManager:GetHeroByHeroId(50006)
  if value then
    self:SetNumFalse()
  elseif not clickBtn then
    self:SetNum(num)
  else
    self:SetNumFalse()
  end
end

function UIHeroRecruitView:SetNum(num)
  self.luckyTextContent:SetActive(true)
  self.luckyText:SetActive(true)
  self.luckyImgArrow:SetActive(true)
  self.luckyText:SetLocalText("monopoly_event_tips_17", num)
end

function UIHeroRecruitView:SetNumFalse()
  self.luckyTextContent:SetActive(false)
  self.luckyText:SetActive(false)
  self.luckyImgArrow:SetActive(false)
end

function UIHeroRecruitView:OnItemRefresh()
  local isRefreshPackageItem = false
  self:UpdateView(isRefreshPackageItem)
end

function UIHeroRecruitView:RefreshWatchAd()
  local curTab = self.dataList[self.currentTabIdx]
  if curTab.type == OfficerRecruitType.WorkerRecruit then
    self.compWatchAd:RefreshView(AdCollectionId.WorkerRecruit)
  else
    self.compWatchAd:RefreshView(AdCollectionId.HeroRecruit)
  end
end

UIHeroRecruitView.OnCreate = OnCreate
UIHeroRecruitView.OnDestroy = OnDestroy
UIHeroRecruitView.OnEnable = OnEnable
UIHeroRecruitView.OnDisable = OnDisable
UIHeroRecruitView.OnAddListener = OnAddListener
UIHeroRecruitView.OnRemoveListener = OnRemoveListener
UIHeroRecruitView.ComponentDefine = ComponentDefine
UIHeroRecruitView.ComponentDestroy = ComponentDestroy
UIHeroRecruitView.DataDefine = DataDefine
UIHeroRecruitView.DataDestroy = DataDestroy
UIHeroRecruitView.RefreshGoldNum = RefreshGoldNum
UIHeroRecruitView.OnOpen = OnOpen
UIHeroRecruitView.GenerateTabs = GenerateTabs
UIHeroRecruitView.ClearTabs = ClearTabs
UIHeroRecruitView.OnCreateCell = OnCreateCell
UIHeroRecruitView.OnDeleteCell = OnDeleteCell
UIHeroRecruitView.RefreshCellsRedPoint = RefreshCellsRedPoint
UIHeroRecruitView.OnSwitchTab = OnSwitchTab
UIHeroRecruitView.OnDataUpdate = OnDataUpdate
UIHeroRecruitView.UpdateView = UpdateView
UIHeroRecruitView.UpdateBg = UpdateBg
UIHeroRecruitView.UpdateTopItemBar = UpdateTopItemBar
UIHeroRecruitView.UpdateBottomButtons = UpdateBottomButtons
UIHeroRecruitView.UpdateGiftPackage = UpdateGiftPackage
UIHeroRecruitView.UpdateGiftPackageInfo = UpdateGiftPackageInfo
UIHeroRecruitView.OnBtnInfoClick = OnBtnInfoClick
UIHeroRecruitView.OnBtnChangeCampClick = OnBtnChangeCampClick
UIHeroRecruitView.OnBtnRecruitOneClick = OnBtnRecruitOneClick
UIHeroRecruitView.OnBtnRecruitTenClick = OnBtnRecruitTenClick
UIHeroRecruitView.OnHandleRecruitResponse = OnHandleRecruitResponse
UIHeroRecruitView.OnHandleCampSwitch = OnHandleCampSwitch
UIHeroRecruitView.Update1000MS = Update1000MS
UIHeroRecruitView.UpdatePityText = UpdatePityText
UIHeroRecruitView.ClosePanel = ClosePanel
UIHeroRecruitView.UpdateHeroView = UpdateHeroView
UIHeroRecruitView.UpdateWorkerView = UpdateWorkerView
UIHeroRecruitView.ResetBarPos = ResetBarPos
UIHeroRecruitView.CloseBarAni = CloseBarAni
UIHeroRecruitView.PlayHideBarAni = PlayHideBarAni
UIHeroRecruitView.PlayShowBarAni = PlayShowBarAni
UIHeroRecruitView.ClearPackageScroll = ClearPackageScroll
UIHeroRecruitView.OnPackageCreateCell = OnPackageCreateCell
UIHeroRecruitView.OnPackageDeleteCell = OnPackageDeleteCell
UIHeroRecruitView.OnPayBtnClick = OnPayBtnClick
UIHeroRecruitView.OnRateBtnClick = OnRateBtnClick
UIHeroRecruitView.OnLuckyBtnClick = OnLuckyBtnClick
UIHeroRecruitView.UpdateHeroWish = UpdateHeroWish
UIHeroRecruitView.UpdatePreview = UpdatePreview
UIHeroRecruitView.UpdateMultiChangeBtnState = UpdateMultiChangeBtnState
UIHeroRecruitView.UpdateCurMultiRecruitType = UpdateCurMultiRecruitType
UIHeroRecruitView.SetCurMultiRecruitType = SetCurMultiRecruitType
UIHeroRecruitView.SkinAnimUpdateSkipRootPosition = SkinAnimUpdateSkipRootPosition
return UIHeroRecruitView
