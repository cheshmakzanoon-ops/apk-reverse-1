local CenterWorkerNewContentContainer = BaseClass("CenterWorkerNewContentContainer", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Const = require("Scene.CityVisitor.Const")
local UITopItem = require("UI.UIHero2.UIHeroRecruit.Component.UITopItem")
local UICommonTipsView = require("UI.UICommonTips.View.UICommonTipsView")
local CampRecruitBgPath = "Assets/Main/TextureEx/UIHeroRecruitBg/%s.png"
local RECRUIT_100_BTN_CHANGE_EFF_PATH = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_ui_herorecruit100_saoguang.prefab"
local sendMsgTime = 0

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.uiTopItem = self:AddComponent(UITopItem, "ItemBar")
  self.imgBg = self:AddComponent(UIRawImage, "ImgBg")
  self.heroSpine = self:AddComponent(UIBaseContainer, "ImgBg/HeroSpineContainer")
  self.btnRecruitOneImg = self:AddComponent(UIImage, "BtnRecruitOne")
  self.btnRecruitOne = self:AddComponent(UIButton, "BtnRecruitOne")
  self.btnRecruitTenImg = self:AddComponent(UIImage, "Layout/BtnRecruitTen")
  self.btnRecruitTen = self:AddComponent(UIButton, "Layout/BtnRecruitTen")
  self.btnRecruitOne:SetOnClick(BindCallback(self, self.OnBtnRecruitOneClick))
  self.btnRecruitTen:SetOnClick(BindCallback(self, self.OnBtnRecruitTenClick))
  self.textBtn1Shadow = self:AddComponent(UIShadow, "BtnRecruitOne/TextBtn1")
  self.textBtn1 = self:AddComponent(UIText, "BtnRecruitOne/TextBtn1")
  self.textBtn2Shadow = self:AddComponent(UIShadow, "Layout/BtnRecruitTen/TextBtn2")
  self.textBtn2 = self:AddComponent(UIText, "Layout/BtnRecruitTen/TextBtn2")
  self.imgCostItem1 = self:AddComponent(UIImage, "BtnRecruitOne/ImgCostItem1")
  self.textCost1 = self:AddComponent(UIText, "BtnRecruitOne/ImgCostItem1/TextCost1")
  self.imgCostItem2 = self:AddComponent(UIImage, "Layout/BtnRecruitTen/ImgCostItem2")
  self.textCost2 = self:AddComponent(UIText, "Layout/BtnRecruitTen/ImgCostItem2/TextCost2")
  self.gray = self.view.gray
  self.multiRecruitChangeImg = self:AddComponent(UIImage, "Layout/BtnMutiTypeChange")
  self.multiRecruitChangeBtn = self:AddComponent(UIButton, "Layout/BtnMutiTypeChange")
  self.multiRecruitChangeBtn:SetOnClick(function()
    self:ChangeMultiRecruitType()
  end)
  self.skipAreaObj = self:AddComponent(UIBaseContainer, "Layout/BtnRecruitTen/SkipRoot")
  self.skipToggleBtn = self:AddComponent(UIButton, "Layout/BtnRecruitTen/SkipRoot/SelectSkipBtn")
  self.skipToggleBtn:SetOnClick(function()
    self:ClickChangeSkipBtn()
  end)
  self.skipSelectImgObj = self:AddComponent(UIBaseContainer, "Layout/BtnRecruitTen/SkipRoot/SelectSkipBtn/SelectImg")
  self.change100RecruitEff = self:AddComponent(UIVfx, "Layout/BtnRecruitTen/MultiTypeChangeEffPoint", RECRUIT_100_BTN_CHANGE_EFF_PATH, {
    lifeType = UIVfxLifeType.Stay
  })
  self.multiRecruitChangeBtnImg = self:AddComponent(UIBaseContainer, "Layout/BtnMutiTypeChange/SelectBtnIcon")
  self.recruitOneFreeText = self:AddComponent(UIText, "BtnRecruitOne/FreeRecruitText")
  self.recruitOneFreeCountDownText = self:AddComponent(UIText, "BtnRecruitOne/NextFreeCountDownText")
  self.recruitOneFreeTimesText = self:AddComponent(UIText, "BtnRecruitOne/FreeRecruitTimesText")
  self.recruitOneFreeText:SetLocalText(151114)
  self.packageContent = self:AddComponent(UIBaseContainer, "packageContent")
  self.packageNameText = self:AddComponent(UIText, "packageContent/GiftPackageContent/PackageNameText")
  self.packageDiscountTip = self:AddComponent(UIBaseContainer, "packageContent/GiftPackageContent/DiscountTip")
  self.packageDiscountTipText = self:AddComponent(UIText, "packageContent/GiftPackageContent/DiscountTip/DiscountTipText")
  self.giftPackageItemScroll = self:AddComponent(UIScrollView, "packageContent/GiftPackageContent/CellScroll")
  self.giftPackageItemScroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnPackageCreateCell(itemObj, index)
  end)
  self.giftPackageItemScroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnPackageDeleteCell(itemObj, index)
  end)
  self.payBtn = self:AddComponent(UIButton, "packageContent/GiftPackageContent/PayBtn")
  self.payBtn:SetOnClick(function()
    self:OnPayBtnClick()
  end)
  self.payBtn:SetSafeClickMode(true)
  self.payBtnPriceText = self:AddComponent(UIText, "packageContent/GiftPackageContent/PayBtn/PayBtnPriceText")
  self.luckyContent = self:AddComponent(UIBaseContainer, "luckyContent")
  self.lickyFill = self:AddComponent(UIImage, "luckyContent/Slider/FillArea/Fill")
  self.luckyNum = self:AddComponent(UIText, "luckyContent/luckynum")
  self.luckyImage = self:AddComponent(UIButton, "luckyContent/luckyImage")
  self.rateBtn = self:AddComponent(UIButton, "rateBtn")
  self.rateBtn:SetOnClick(function()
    self:OnRateBtnClick()
  end)
  self.luckyImage:SetOnClick(function()
    self:OnLuckyBtnClick()
  end)
  self.textBtn1:SetLocalText(110115)
  self.textBtn2:SetLocalText(110116)
end

local function ComponentDestroy(self)
  self.multiRecruitChangeBtn = nil
  self.multiRecruitChangeImg = nil
  self.skipAreaObj = nil
  self.skipToggleBtn = nil
  self.skipSelectImgObj = nil
  self.change100RecruitEff = nil
end

local function DataDefine(self)
  self.curMultiRecruitType = nil
  self.canClick = true
end

local function DataDestroy(self)
  self:DeleteFreeCountdownTimer()
  self.lotteryData = nil
  self.curMultiRecruitType = nil
  if self.selectBtnIconTweenSeq then
    self.selectBtnIconTweenSeq:Kill()
    self.selectBtnIconTweenSeq = nil
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.WorkericRecruitmentData, self.OnHandleRecruitResponse)
  self:AddUIListener(EventId.WorkerLotteryInfoGet, self.OnWorkerLotteryInfoGetMsg)
  self:AddUIListener(EventId.CloseRecruit100Panel, self.OnCloseRecruit100Reward)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.WorkericRecruitmentData, self.OnHandleRecruitResponse)
  self:RemoveUIListener(EventId.WorkerLotteryInfoGet, self.OnWorkerLotteryInfoGetMsg)
  self:RemoveUIListener(EventId.CloseRecruit100Panel, self.OnCloseRecruit100Reward)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:DeleteFreeCountdownTimer()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnOpen(self, data)
  self.lotteryData = data
  self.isSelectSkip = CommonUtil.PlayerPrefsGetBool("WorkerRecruit100SkipState", false)
  self:UpdateCurMultiRecruitType()
  self:UpdateView()
end

function CenterWorkerNewContentContainer:DeleteFreeCountdownTimer()
  self.prevCanFreeRecruitState = nil
  if self.freeCountdownTimer ~= nil then
    self.freeCountdownTimer:Stop()
    self.freeCountdownTimer = nil
  end
end

function CenterWorkerNewContentContainer:AddFreeCountdownTimer()
  if self.freeCountdownTimer == nil then
    local time = 1
    self.freeCountdownTimer = TimerManager:GetInstance():GetTimer(time, self.RefreshFreeCountdown, self, false, false, false)
    self.freeCountdownTimer:Start()
  end
end

function CenterWorkerNewContentContainer:RefreshFreeCountdown()
  local canFreeRecruit = self.workerLotteryInfo:CanFreeRecruit()
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
    self.recruitOneFreeCountDownText:SetLocalText(151113, UITimeManager:GetInstance():SecondToFmtString(self.workerLotteryInfo.nextFreeTime / 1000 - now))
    return false
  end
end

local function UpdateView(self)
  self.workerLotteryInfo = DataCenter.WorkerLotteryDataManager:GetWorkerLotteryData()
  self:UpdateBg()
  self:UpdatePityText()
  self:UpdateGiftPackageInfo()
  self:UpdateBottomButtons()
  self:SkinAnimUpdateSkipRootPosition()
end

local function UpdateCurMultiRecruitType(self)
  self:SetCurMultiRecruitType(UIWorkerMultiRecruitType.Ten)
end

local function SetCurMultiRecruitType(self, targetMultiRecruitType)
  if self.canClick == false then
    return
  end
  local conditionInfo = self.lotteryData and self.lotteryData:GetHundredBtnShowCondition()
  if targetMultiRecruitType == UIWorkerMultiRecruitType.OneHundred and not conditionInfo then
    return
  end
  if (not self.curMultiRecruitType or self.curMultiRecruitType == UIWorkerMultiRecruitType.Ten) and targetMultiRecruitType == UIWorkerMultiRecruitType.OneHundred then
    self.change100RecruitEff:Replay()
  else
    self.change100RecruitEff:Stop()
  end
  self.curMultiRecruitType = targetMultiRecruitType
  self:UpdateBottomButtons()
end

function CenterWorkerNewContentContainer:ChangeMultiRecruitType()
  if not self.canClick then
    return
  end
  if self.curMultiRecruitType == UIWorkerMultiRecruitType.Ten and self:IsCanShowHundredBtn() then
    self:SetCurMultiRecruitType(UIWorkerMultiRecruitType.OneHundred)
  else
    self:SetCurMultiRecruitType(UIWorkerMultiRecruitType.Ten)
  end
  self:UpdateBottomButtons()
  self:SkinAnimUpdateSkipRootPosition()
end

function CenterWorkerNewContentContainer:ClickChangeSkipBtn()
  self.isSelectSkip = not self.isSelectSkip
  CommonUtil.PlayerPrefsSetBool("WorkerRecruit100SkipState", self.isSelectSkip)
  self:UpdateSkipToggleState()
end

function CenterWorkerNewContentContainer:UpdateBg()
  self.imgBg:LoadSpriteAuto(self.lotteryData.picture)
end

local function UpdatePityText(self)
  local workerLotteryInfo = self.workerLotteryInfo
  local oldPityMaxProtectNum = LuaEntry.DataConfig:TryGetNum("worker_recruit_1", "k8", 0)
  local pityMaxProtectNum = DataCenter.LotteryDataManager:GetOnlyWorkerLotteryGuaranteedDrawNum() or oldPityMaxProtectNum
  if workerLotteryInfo ~= nil and 0 < pityMaxProtectNum then
    self.luckyContent:SetActive(true)
    local pityCurProtectNum = workerLotteryInfo.curNum
    self.luckyNum:SetLocalText(150033, pityCurProtectNum, pityMaxProtectNum)
    local percent = pityCurProtectNum / pityMaxProtectNum
    percent = math.max(0, math.min(percent, 1))
    self.lickyFill:SetFillAmount(percent)
  else
    self.luckyContent:SetActive(false)
  end
end

local function UpdateBottomButtons(self)
  if self.workerLotteryInfo == nil then
    self.btnRecruitOne:SetActive(false)
    self.btnRecruitTen:SetActive(false)
    return
  end
  local supportFreeRecruit = true
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
  self.btnRecruitTen:SetActive(true)
  if self.canClick == false then
    self.btnRecruitOneImg:SetMaterial(self.gray)
    self.btnRecruitTenImg:SetMaterial(self.gray)
    self.multiRecruitChangeImg:SetMaterial(self.gray)
  else
    self.btnRecruitOneImg:SetMaterial(nil)
    self.btnRecruitTenImg:SetMaterial(nil)
    self.multiRecruitChangeImg:SetMaterial(nil)
  end
  local costItems = self.workerLotteryInfo:GetCostItems()
  self.imgCostItem1:LoadSprite(string.format(LoadPath.ItemPath, DataCenter.ItemTemplateManager:GetItemTemplate(costItems[1].itemId).icon))
  self.textCost1:SetText(costItems[1].itemNum)
  local isCanHundredRecruit = self:IsCanShowHundredBtn()
  self:UpdateMultiChangeBtnState(isCanHundredRecruit)
  self.skipAreaObj:SetActive(self.curMultiRecruitType == UIWorkerMultiRecruitType.OneHundred)
  if isCanHundredRecruit then
    self:UpdateSkipToggleState()
  end
  local costItemId, costItemNum = self:GetItemCost()
  self.imgCostItem2:LoadSprite(string.format(LoadPath.ItemPath, DataCenter.ItemTemplateManager:GetItemTemplate(costItemId).icon))
  self.textCost2:SetText(costItemNum)
  local multiBtnKey = self.curMultiRecruitType == UIWorkerMultiRecruitType.OneHundred and "hero_recruit_100_tips4" or 110116
  self.textBtn2:SetLocalText(multiBtnKey)
end

function CenterWorkerNewContentContainer:IsCanShowHundredBtn()
  local conditionInfo = self.lotteryData:GetHundredBtnShowCondition()
  if not conditionInfo then
    return false
  end
  local itemId = conditionInfo.itemId
  local needCount = conditionInfo.itemNum
  local haveNum = DataCenter.ItemData:GetItemCount(itemId)
  return needCount <= haveNum
end

function CenterWorkerNewContentContainer:UpdateMultiChangeBtnState(isCanHundredRecruit)
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

function CenterWorkerNewContentContainer:UpdateSkipToggleState()
  if not IsNull(self.skipSelectImgObj) then
    self.skipSelectImgObj:SetActive(self.isSelectSkip)
  end
end

function CenterWorkerNewContentContainer:GetItemCost()
  if self.curMultiRecruitType == UIWorkerMultiRecruitType.Ten then
    local costItems = self.workerLotteryInfo:GetCostItems()
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

local function UpdateGiftPackage(self)
  self:UpdateView()
end

local function UpdateGiftPackageInfo(self)
  local workerLotteryInfo = self.workerLotteryInfo
  local costItems = workerLotteryInfo:GetCostItems()
  local itemId = costItems[1].itemId
  self.packageData = self.view.ctrl:GetPackageInfoByItemId(itemId)
  self.packageContent:SetActive(self.packageData ~= nil)
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

local function SkinAnimUpdateSkipRootPosition(self)
  if self.skipAreaObj == nil then
    return
  end
  self.skipAreaObj:SetAnchoredPositionXY(-139, 101)
end

local function OnBtnRecruitOneClick(self)
  DataCenter.ArrowManager:RemoveArrow()
  if self.canClick == false then
    return
  end
  if self.workerLotteryInfo == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < sendMsgTime + 1000 then
    return
  end
  sendMsgTime = curTime
  local supportFreeRecruit = true
  local canFreeRecruit = self.workerLotteryInfo:CanFreeRecruit()
  local costItems = self.workerLotteryInfo:GetCostItems()
  local itemId = costItems[1].itemId
  local itemNum = costItems[1].itemNum
  if supportFreeRecruit and canFreeRecruit then
    self.canClick = false
    self.btnRecruitOneImg:SetMaterial(self.gray)
    self.btnRecruitTenImg:SetMaterial(self.gray)
    self.multiRecruitChangeImg:SetMaterial(self.gray)
    SFSNetwork.SendMessage(MsgDefines.LotteryWorkerCard, 1, 0, tonumber(self.lotteryData.id))
    return
  else
    local item = DataCenter.ItemData:GetItemById(itemId)
    local have = item and item.count or 0
    if itemNum > have then
      LWResourceLackUtil:GotoGoodsItemLack(itemId, itemNum - have)
      return
    end
    self.canClick = false
    self.btnRecruitOneImg:SetMaterial(self.gray)
    self.btnRecruitTenImg:SetMaterial(self.gray)
    self.multiRecruitChangeImg:SetMaterial(self.gray)
    SFSNetwork.SendMessage(MsgDefines.LotteryWorkerCard, 0, 0, tonumber(self.lotteryData.id))
  end
end

local function OnBtnRecruitTenClick(self)
  DataCenter.ArrowManager:RemoveArrow()
  if self.canClick == false then
    return
  end
  if self.workerLotteryInfo == nil then
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
  local type = self.curMultiRecruitType
  self.canClick = false
  self.btnRecruitOneImg:SetMaterial(self.gray)
  self.btnRecruitTenImg:SetMaterial(self.gray)
  self.multiRecruitChangeImg:SetMaterial(self.gray)
  SFSNetwork.SendMessage(MsgDefines.LotteryWorkerCard, 0, type, tonumber(self.lotteryData.id))
end

local function OnHandleRecruitResponse(self, message)
  local isTen = message.isTen
  if isTen == nil then
    Logger.LogError("\229\183\165\228\186\186\230\138\189\229\141\161\229\165\150\229\138\177\231\177\187\229\158\139\228\184\186\231\169\186")
    return
  end
  if isTen == UIWorkerMultiRecruitType.OneHundred then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIHero100Recruit) == false then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHero100Recruit, self.lotteryData.id, message, self.isSelectSkip, false)
    end
  elseif UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIWorkerRecruitReward) == false then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorkerRecruitReward, {anim = true}, message)
  end
  self.canClick = true
  local curTime = UITimeManager:GetInstance():GetServerTime()
  sendMsgTime = curTime
  self:UpdateView()
end

local function OnRateBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorkerRecruitTip, {anim = true}, {
    lotteryData = self.lotteryData
  })
end

local function OnLuckyBtnClick(self)
  local param = UICommonTipsView.ParamDataClass.New()
  local workerLotteryInfo = self.workerLotteryInfo
  local pityCurProtectNum = workerLotteryInfo.curNum + 1
  local oldTotalNum = LuaEntry.DataConfig:TryGetNum("worker_recruit_1", "k8", 0)
  local totalNum = DataCenter.LotteryDataManager:GetOnlyWorkerLotteryGuaranteedDrawNum() or oldTotalNum
  param.content = Localization:GetString("worker_ui107", totalNum - pityCurProtectNum + 1)
  param.position = self.luckyImage:GetPosition()
  param.deltaY = -20
  param.contentX = -20
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonTips, {anim = false}, param)
end

local function OnWorkerLotteryInfoGetMsg(self)
  self:DeleteFreeCountdownTimer()
  self:UpdateView()
end

function CenterWorkerNewContentContainer:OnRequestWorkerLotteryInfo(lotteryData)
  SFSNetwork.SendMessage(MsgDefines.WorkerLotteryInfo, tonumber(lotteryData.id))
end

function CenterWorkerNewContentContainer:OnCloseRecruit100Reward(isHeroDraw)
  if isHeroDraw then
    return
  end
  self:SetCurMultiRecruitType(UIWorkerMultiRecruitType.Ten)
  self.isSelectSkip = CommonUtil.PlayerPrefsGetBool("WorkerRecruit100SkipState", false)
  if self.curMultiRecruitType == UIWorkerMultiRecruitType.OneHundred then
    self:UpdateSkipToggleState()
  end
end

CenterWorkerNewContentContainer.OnCreate = OnCreate
CenterWorkerNewContentContainer.OnDestroy = OnDestroy
CenterWorkerNewContentContainer.DataDefine = DataDefine
CenterWorkerNewContentContainer.DataDestroy = DataDestroy
CenterWorkerNewContentContainer.ComponentDefine = ComponentDefine
CenterWorkerNewContentContainer.ComponentDestroy = ComponentDestroy
CenterWorkerNewContentContainer.OnAddListener = OnAddListener
CenterWorkerNewContentContainer.OnRemoveListener = OnRemoveListener
CenterWorkerNewContentContainer.OnEnable = OnEnable
CenterWorkerNewContentContainer.OnDisable = OnDisable
CenterWorkerNewContentContainer.OnOpen = OnOpen
CenterWorkerNewContentContainer.UpdateView = UpdateView
CenterWorkerNewContentContainer.UpdatePityText = UpdatePityText
CenterWorkerNewContentContainer.UpdateGiftPackageInfo = UpdateGiftPackageInfo
CenterWorkerNewContentContainer.UpdateGiftPackage = UpdateGiftPackage
CenterWorkerNewContentContainer.ClearPackageScroll = ClearPackageScroll
CenterWorkerNewContentContainer.OnPackageCreateCell = OnPackageCreateCell
CenterWorkerNewContentContainer.OnPackageDeleteCell = OnPackageDeleteCell
CenterWorkerNewContentContainer.OnPayBtnClick = OnPayBtnClick
CenterWorkerNewContentContainer.UpdateBottomButtons = UpdateBottomButtons
CenterWorkerNewContentContainer.OnHandleRecruitResponse = OnHandleRecruitResponse
CenterWorkerNewContentContainer.OnBtnRecruitOneClick = OnBtnRecruitOneClick
CenterWorkerNewContentContainer.OnBtnRecruitTenClick = OnBtnRecruitTenClick
CenterWorkerNewContentContainer.OnWorkerLotteryInfoGetMsg = OnWorkerLotteryInfoGetMsg
CenterWorkerNewContentContainer.OnLuckyBtnClick = OnLuckyBtnClick
CenterWorkerNewContentContainer.OnRateBtnClick = OnRateBtnClick
CenterWorkerNewContentContainer.UpdateCurMultiRecruitType = UpdateCurMultiRecruitType
CenterWorkerNewContentContainer.SetCurMultiRecruitType = SetCurMultiRecruitType
CenterWorkerNewContentContainer.SkinAnimUpdateSkipRootPosition = SkinAnimUpdateSkipRootPosition
return CenterWorkerNewContentContainer
