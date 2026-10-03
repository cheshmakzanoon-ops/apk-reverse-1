local UISpeed = BaseClass("UISpeed", UIBaseView)
local base = UIBaseView
local UIItemCell = require("UI.UISpeed.Component.UIItemCell")
local UIResItemExtraItem = require("UI.UISpeed.Component.UIResItemExtraComponent")
local Localization = CS.GameEntry.Localization
local GiftPackTemplate = require("DataCenter.GiftPackageData.GiftPackTemplate")
local UICommonHorseLampTMP = require("UI.UICommonTMPHorseRaceLamp.Component.UICommonHorseLampTMP")
local panel_path = "UICommonPopUpTitle/panel"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local title_text_path = "UICommonPopUpTitle/Common_img_title/titleText"
local alhelp_path = "Bg/TopContent/AlHelpRemain"
local alhelp_remain_txt_path = "Bg/TopContent/AlHelpRemain/root/resourceNum"
local icon_path = "Bg/TopContent/SliderGo/Common_bg1/BuildIcon"
local slider_path = "Bg/TopContent/SliderGo/Common_bg1/Slider"
local pro_img_path = "Bg/TopContent/SliderGo/Common_bg1/Slider/Fill Area/Fill"
local left_time_path = "Bg/TopContent/SliderGo/Common_bg1/LeftTime"
local vfx_canFree_path = "Bg/TopContent/SliderGo/Common_bg1/VFX_CanFree"
local more_btn_go_path = "MoreBtn"
local use_count_btn_path = "MoreBtn/UseCountBtn"
local use_count_btn_name_path = "MoreBtn/UseCountBtn/UseCountBtnName"
local use_max_btn_path = "MoreBtn/UseMaxBtn"
local use_max_btn_name_path = "MoreBtn/UseMaxBtn/UseMaxBtnName"
local content_container_path = "Bg/Container"
local package_path = "Bg/Container/AdvCell"
local common_bg1_path = "Bg/Container/AdvCell/Common_bg1"
local packageCloseBtn_path = "Bg/Container/AdvCell/CloseBtnBg/PackageCloseBtn"
local packageNameTxt_path = "Bg/Container/AdvCell/Common_bg1/NameText"
local packageDescTxt_path = "Bg/Container/AdvCell/Common_bg1/DesText"
local packageBuyBtn_path = "Bg/Container/AdvCell/Common_bg1/BuyBtn"
local packageBuyBtnTxt_path = "Bg/Container/AdvCell/Common_bg1/BuyBtn/BuyBtnLabel"
local packageImgB_path = "Bg/Container/AdvCell/Common_bg1/packageIcon"
local packageImgBMustBuy_path = "Bg/Container/AdvCell/Common_bg1/packageIconMustBuy"
local resourceImgB_path = "Bg/Container/AdvCell/Common_bg1/resourceIcon"
local packageJumpBtn_path = "Bg/Container/AdvCell/Common_bg1/jumpBtn"
local packageDiscountTip_path = "Bg/Container/AdvCell/Common_bg1/DiscountTip"
local packageDiscountTipText_path = "Bg/Container/AdvCell/Common_bg1/DiscountTip/DiscountTipText"
local packageRewardScrollView_path = "Bg/Container/AdvCell/Common_bg1/CellScroll"
local scrollview_path = "Bg/Container/ScrollViews"
local content_path = "Bg/Container/ScrollViews/viewport/Content"
local bg_path = "Bg"
local desert_battle_tips_btn_path = "Bg/DesertBattleTipsBtn"
local ItemSpd = {
  [ItemSpdMenu.ItemSpdMenu_City] = EffectDefine.BUILD_TIME_REDUCE,
  [ItemSpdMenu.ItemSpdMenu_Science] = EffectDefine.RESEARCH_TIME_REDUCE
}
local SliderLength = 523
local MoreBtnPos = Vector3.New(360, 0, 0)
local OutTime = 600000
local SpeedUpCountType = {Quantification10 = 1, Quantification100 = 2}
local defaultScrollViewsHeight = 525.5
local pyramidScrollViewsHeight = 358.7

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  SFSNetwork.SendMessage(MsgDefines.AllianceShowHelp)
  self:ReInit()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:ClearPackageRewardScroll()
  self:ClearPyramidPackageRewardScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, panel_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.pro_img = self:AddComponent(UIImage, pro_img_path)
  self.left_time = self:AddComponent(UIText, left_time_path)
  self.alhelp_container = self:AddComponent(UIBaseContainer, alhelp_path)
  self.alhelp_remain_txt = self:AddComponent(UIText, alhelp_remain_txt_path)
  self.more_btn_go = self:AddComponent(UIAnimator, more_btn_go_path)
  self.use_count_btn = self:AddComponent(UIButton, use_count_btn_path)
  self.use_count_btn_name = self:AddComponent(UIText, use_count_btn_name_path)
  self.use_max_btn = self:AddComponent(UIButton, use_max_btn_path)
  self.use_max_btn_name = self:AddComponent(UIText, use_max_btn_name_path)
  self.content_container = self:AddComponent(UIBaseContainer, content_container_path)
  self.btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.use_count_btn:SetOnClick(function()
    self.clickUseSpeedUpCountType = SpeedUpCountType.Quantification100
    self:MoreBtnClick()
  end)
  self.use_max_btn:SetOnClick(function()
    self.clickUseSpeedUpCountType = SpeedUpCountType.Quantification10
    self:MoreBtnClick()
  end)
  self.package = self:AddComponent(UIBaseContainer, package_path)
  self.packageBg = self:AddComponent(UIImage, common_bg1_path)
  self.packageNameTxt = self:AddComponent(UIText, packageNameTxt_path)
  self.packageDescTxt = self:AddComponent(UIText, packageDescTxt_path)
  self.packageImgB = self:AddComponent(UIImage, packageImgB_path)
  self.packageImgBMustBuy = self:AddComponent(UIRawImage, packageImgBMustBuy_path)
  self.resourceImgB = self:AddComponent(UIImage, resourceImgB_path)
  self.packageCloseBtn = self:AddComponent(UIButton, packageCloseBtn_path)
  self.packageCloseBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.packageBuyBtnTxt = self:AddComponent(UIText, packageBuyBtnTxt_path)
  self.packageBuyBtn = self:AddComponent(UIButton, packageBuyBtn_path)
  self.packageBuyBtn:SetOnClick(function()
    if self.packageInfo then
      self.ctrl:BuyGift(self.packageInfo)
    end
  end)
  self.packageBuyBtn:SetSafeClickMode(true)
  self.packageJumpBtn = self:AddComponent(UIButton, packageJumpBtn_path)
  self.packageJumpBtn:SetOnClick(function()
    self:OnClickJumpToPackBtn()
  end)
  self.packageDiscountTip = self:AddComponent(UIBaseContainer, packageDiscountTip_path)
  self.packageDiscountTipText = self:AddComponent(UIText, packageDiscountTipText_path)
  self.packageRewardScrollView = self:AddComponent(UIScrollView, packageRewardScrollView_path)
  self.packageRewardScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreatePackageRewardCell(itemObj, index)
  end)
  self.packageRewardScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeletePackageRewardCell(itemObj, index)
  end)
  self.pyramidPackage = self:AddComponent(UIBaseContainer, "Bg/Container/PyramidAdvCell")
  self.pyramidPackageBg = self:AddComponent(UIImage, "Bg/Container/PyramidAdvCell/PyramidAdvBg")
  self.pyramidPackageIcon = self:AddComponent(UIImage, "Bg/Container/PyramidAdvCell/PyramidAdvBg/PyramidCdReduceRoot/PyramidpackageIcon")
  self.pyramidPackageNameTxt = self:AddComponent(UIText, "Bg/Container/PyramidAdvCell/PyramidAdvBg/PyramidNameText")
  self.pyramidPercentReduceTxt = self:AddComponent(UIText, "Bg/Container/PyramidAdvCell/PyramidAdvBg/PyramidCdReduceRoot/ScienceCdReduce")
  self.scienceIcon = self:AddComponent(UIImage, "Bg/Container/PyramidAdvCell/PyramidAdvBg/PyramidCdReduceRoot/ScienceCdReduce/ScienceIcon")
  self.pyramidPercentReduceBtn = self:AddComponent(UIButton, "Bg/Container/PyramidAdvCell/PyramidAdvBg/PyramidCdReduceRoot")
  self.pyramidPercentReduceBtn:SetOnClick(function()
    if self.curPyramidTemplate == nil then
      return
    end
    local param = {}
    param.baseBuildingId = self.curPyramidTemplate.decoration_id
    param.alignObject = self.pyramidPercentReduceBtn
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWDecorationBookProperty, {anim = false}, param)
  end)
  self.pyramidPackageDescTxt = self:AddComponent(UICommonHorseLampTMP, "Bg/Container/PyramidAdvCell/PyramidAdvBg/PyramidDes")
  self.pyramidPackageBuyBtnTxt = self:AddComponent(UIText, "Bg/Container/PyramidAdvCell/PyramidAdvBg/PyramidBuyBtn/PyramidBuyBtnLabel")
  self.pyramidPackageBuyBtn = self:AddComponent(UIButton, "Bg/Container/PyramidAdvCell/PyramidAdvBg/PyramidBuyBtn")
  self.pyramidPackageBuyBtn:SetOnClick(function()
    if self.packageInfo then
      self.ctrl:BuyGift(self.packageInfo)
    end
  end)
  self.pyramidPackageBuyBtn:SetSafeClickMode(true)
  self.pyramidPackageDiscountTip = self:AddComponent(UIBaseContainer, "Bg/Container/PyramidAdvCell/PyramidAdvBg/PyramidDiscountTip")
  self.pyramidPackageDiscountTipText = self:AddComponent(UIText, "Bg/Container/PyramidAdvCell/PyramidAdvBg/PyramidDiscountTip/PyramidDiscountTipText")
  self.pyramidPackageRewardScrollView = self:AddComponent(UIScrollView, "Bg/Container/PyramidAdvCell/PyramidAdvBg/PyramidCellScroll")
  self.pyramidPackageRewardScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreatePyramidPackageRewardCell(itemObj, index)
  end)
  self.pyramidPackageRewardScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeletePyramidPackageRewardCell(itemObj, index)
  end)
  self.moreInfoBtn = self:AddComponent(UIButton, "Bg/Container/InfoBtn")
  self.moreInfoBtn:SetOnClick(function()
    self:ClickMoreInfoBtn()
  end)
  self.moreInfoTipObj = self:AddComponent(UIBaseContainer, "Bg/Container/InfoBtn/InfoTips")
  self.moreInfoCloseBtn = self:AddComponent(UIButton, "Bg/Container/InfoBtn/InfoTips/TipCloseBtn")
  self.moreInfoCloseBtn:SetOnClick(function()
    self:ClickMoreInfoCloseBtn()
  end)
  self.TipsContent = self:AddComponent(UITextMeshProUGUIEx, "Bg/Container/InfoBtn/InfoTips/BubbleTipsBtn/InfoTipsText")
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.scrollviewLayout = self:AddComponent(UILayoutElement, scrollview_path)
  self.scrollview = self:AddComponent(UIScrollView, scrollview_path)
  self.scrollview:SetExtraFillSize(0, 669.5)
  self.scrollview:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scrollview:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.vfx_canFree = self:AddComponent(UIBaseContainer, vfx_canFree_path)
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.desert_battle_tips_btn = self:AddComponent(UIButton, desert_battle_tips_btn_path)
  self.desert_battle_tips_btn:SetOnClick(function()
    UIUtil.ShowTipsId("Desert_strom_tips1017")
  end)
  self.desert_battle_tips_btn:SetActive(BattleFieldUtil.InBattleField(BattleFieldType.Desert))
end

local function ComponentDestroy(self)
  self.more_btn_go.transform:SetParent(self.transform)
  self.more_btn_go:SetActive(false)
  self.btn = nil
  self.close_btn = nil
  self.title_text = nil
  self.icon = nil
  self.science_icon_bg = nil
  self.slider = nil
  self.left_time = nil
  self.scrollview = nil
  self.content = nil
  self.more_btn_go = nil
  self.more_btn = nil
  self.more_btn_name = nil
  self.content_container = nil
  self.use_count_btn = nil
  self.use_count_btn_name = nil
  self.use_max_btn = nil
  self.use_max_btn_name = nil
  self.packageNameTxt = nil
  self.packageDescTxt = nil
  self.packageImgB = nil
  self.resourceImgB = nil
  self.packageCloseBtn = nil
  self.packageBuyBtnTxt = nil
  self.packageBuyBtn = nil
  self.packageJumpBtn = nil
  self.packageDiscountTip = nil
  self.packageDiscountTipText = nil
  self.packageRewardScrollView = nil
  self.pyramidPackage = nil
  self.pyramidPackageBg = nil
  self.pyramidPackageIcon = nil
  self.pyramidPackageNameTxt = nil
  self.pyramidPercentReduceTxt = nil
  self.scienceIcon = nil
  self.pyramidPackageDescTxt = nil
  self.pyramidPackageBuyBtnTxt = nil
  self.pyramidPackageBuyBtn = nil
  self.pyramidPackageDiscountTip = nil
  self.pyramidPackageDiscountTipText = nil
  self.pyramidPackageRewardScrollView = nil
  self.bg = nil
  self.desert_battle_tips_btn = nil
end

local function DataDefine(self)
  self.queue = nil
  self.moreBtnGoActive = nil
  self.speedType = nil
  self.template = {}
  self.moreItemId = nil
  self.moreBtnMax = nil
  self.moreIndex = nil
  self.buildData = nil
  self.originalEndTime = nil
  self.endTime = 0
  self.startTime = 0
  self.ScienceBgActive = nil
  self.items = {}
  self.buyItems = {}
  self.itemNum = nil
  self.laseTime = 0
  self.lastCurTime = 0
  self.lastChangeTime = 0
  self.sliderValue = nil
  self.leftText = nil
  self.useItem = {}
  self.lastUserItemId = 0
  self.useItemActionLog = {}
  self.moreBtnPosition = nil
  self.moreBtnName = nil
  self.changeGold = 0
  self.cells = {}
  self.titleText = nil
  self.isChangeRefreshGold = nil
  self.moreParent = nil
  self.cacheUsedGolloesFreeTime = 0
  self.isHeroFreeTime = false
  self.isSignHeroFreeTIme = false
  self.packageInfo = nil
  self.isUseHeroAddTime = false
  self.isCreateScroll = false
  self.listGO = {}
  self.addTime = 0
  self.speedItemList = {}
  self.packageRewardList = {}
  self.clickUseSpeedUpCountType = nil
end

local function DataDestroy(self)
  if not self.isBuy then
    self:SendMsg()
  end
  self.queue = nil
  self.moreBtnGoActive = nil
  self.speedType = nil
  self.template = nil
  self.moreItemId = nil
  self.moreBtnMax = nil
  self.moreIndex = nil
  self.buildData = nil
  self.originalEndTime = nil
  self.endTime = 0
  self.startTime = 0
  self.ScienceBgActive = nil
  self.items = nil
  self.buyItems = nil
  self.itemNum = nil
  self.laseTime = nil
  self.lastChangeTime = nil
  self.sliderValue = nil
  self.leftText = nil
  self.useItem = nil
  self.lastUserItemId = 0
  self.useItemActionLog = nil
  self.moreBtnPosition = nil
  self.moreBtnName = nil
  self.cells = nil
  self.changeGold = nil
  self.titleText = nil
  self.isChangeRefreshGold = nil
  self.moreParent = nil
  self.cacheUsedGolloesFreeTime = nil
  self.isHeroFreeTime = nil
  self.isUseHeroAddTime = nil
  self.speedItemList = nil
  self.addTime = 0
  self.clickUseSpeedUpCountType = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
  self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
  self:AddUIListener(EventId.UpdateGiftPackData, self.UpdateGiftPackShow)
  self:AddUIListener(EventId.UIScrollToSomeWhere, self.GuidAutoScroll)
  self:AddUIListener(EventId.AllianceHelpUpdateSpeed, self.RefreshAlHelp)
  self:AddUIListener(EventId.PyramidReduceTips, self.RefreshPyramidPackageTipsAndReward)
end

local packIds = {}

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
  self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.UpdateGiftPackShow)
  self:RemoveUIListener(EventId.UIScrollToSomeWhere, self.GuidAutoScroll)
  self:RemoveUIListener(EventId.AllianceHelpUpdateSpeed, self.RefreshAlHelp)
  self:RemoveUIListener(EventId.PyramidReduceTips, self.RefreshPyramidPackageTipsAndReward)
end

function UISpeed:GetItemById(id)
  local item = DeepCopy(DataCenter.ItemData:GetItemById(id))
  if item and self.useItem[id] then
    item.count = item.count - self.useItem[id]
    if item.count <= 0 then
      return nil
    end
  end
  return item
end

local function MoreBtnClick(self)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Speed_Button, false)
  local template = self:GetItemTemplate(self.moreItemId)
  local useCount = 0
  if self.clickUseSpeedUpCountType == SpeedUpCountType.Quantification100 then
    useCount = math.min(self.moreBtnMax, 100)
  elseif self.clickUseSpeedUpCountType == SpeedUpCountType.Quantification10 then
    useCount = math.min(self.moreBtnMax, 10)
  end
  self:AppendUseItemActionLog(template.id, useCount, "MoreBtnClick")
  self:UseAddItem(template.id, useCount)
  local oneTime = 0
  local temp = string.split(template.para1, ";")
  if temp ~= nil and 1 < #temp then
    oneTime = DataCenter.ItemTemplateManager:GetShowTime(temp[1], temp[2])
    self:ReduceTime(oneTime * useCount)
  end
  local item = self:GetItemById(template.id)
  if item == nil then
    self:HideMoreBtn()
    self:GetAllItems()
    local param = {}
    for i = 1, #self.buyItems do
      if template.para3 == self.buyItems[i].para3 then
        param.template = self.buyItems[i]
      end
    end
    if param.template then
      param.stateType = UIItemCell.StateType.Buy
      param.goldImage = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
      
      function param.callBack(index, template, isBuy)
        self:CellsCallBack(index, template, isBuy)
      end
      
      param.index = self.moreIndex
      param.isSignHeroFreeTIme = self.isSignHeroFreeTIme
      self.cells[self.moreIndex]:ReInit(param)
    else
      self:ClearScroll()
      self.scrollview:SetTotalCount(#self.items + #self.buyItems)
      self.scrollview:RefillCells(1, true)
    end
  else
    self:ShowMoreBtnName(oneTime, item)
    if self.cells[self.moreIndex] ~= nil then
      self.cells[self.moreIndex]:RefreshOwnCount(item.count)
    end
  end
end

local function ReInit(self)
  self.isChangeRefreshGold = true
  self.title_text:SetLocalText(100159)
  local speedType, uuid = self:GetUserData()
  self.speedType = tonumber(speedType)
  self.uuid = tonumber(uuid)
  self:ReInitLeftTime()
  self.more_btn_go:SetActive(false)
  self:ShowImage()
  self.curRechargeId = nil
  self.curPyramidTemplate = nil
  self.isShowPyramidPackage = self:CanBuyPyramidPackage(self.speedType)
  self.moreInfoBtn:SetActive(self.isShowPyramidPackage)
  self.pyramidPackage:SetActive(self.isShowPyramidPackage)
  self.package:SetActive(not self.isShowPyramidPackage)
  if self.isShowPyramidPackage then
    if self.curPyramidTemplate then
      DataCenter.ExchangeSpecialManager:RequestExchangeSpecialDecorationReduce(self.curPyramidTemplate.id, true)
    end
    self.scrollviewLayout:SetMinHeight(pyramidScrollViewsHeight)
    self:TryShowPyramidPackage()
  else
    self.scrollviewLayout:SetMinHeight(defaultScrollViewsHeight)
    self:TryShowPackage()
  end
  self:ShowCells()
  self:RefreshAlHelp()
end

function UISpeed:CanBuyPyramidPackage(speedType)
  local template = DataCenter.ExchangeSpecialManager:GetCanBuyPackageTemplate(speedType)
  self.curPyramidTemplate = template
  return template ~= nil
end

local function ReInitLeftTime(self)
  self.needUpdate = true
  if self.speedType == ItemSpdMenu.ItemSpdMenu_City then
    self.buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.uuid)
    self.queue = nil
    self.originalEndTime = self.buildData.updateTime
    self.endTime = self.buildData.updateTime
    self.startTime = self.buildData.startTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.startTime then
      self.startTime = curTime
    end
  elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Fix_Ruins then
    self.buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.uuid)
    self.queue = nil
    self.originalEndTime = self.buildData.destroyEndTime
    self.endTime = self.buildData.destroyEndTime
    self.startTime = self.buildData.destroyStartTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.startTime then
      self.startTime = curTime
    end
  elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Soldier then
    self.buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.uuid)
    self.queue = nil
    self.originalEndTime = self.buildData.productEndTime
    self.endTime = self.buildData.productEndTime
    self.startTime = self.buildData.productTime
    local hasWorker = true
    if not hasWorker then
      self.needUpdate = false
      self.addTime = 0
    else
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime < self.startTime then
        self.startTime = curTime
      end
    end
  elseif self.speedType == ItemSpdMenu.ItemSpdMenu_DuanZao or self.speedType == ItemSpdMenu.ItemSpdMenu_Chip_Crate then
    self.buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.uuid)
    self.queue = nil
    self.originalEndTime = self.buildData.productEndTime
    self.endTime = self.buildData.productEndTime
    self.startTime = self.buildData.productTime
    local hasWorker = true
    if not hasWorker then
      self.needUpdate = false
      self.addTime = 0
    else
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime < self.startTime then
        self.startTime = curTime
      end
    end
  else
    self.buildData = nil
    self.queue = DataCenter.QueueDataManager:GetQueueByUuid(self.uuid)
    self.originalEndTime = self.queue.endTime
    self.endTime = self.queue.endTime
    self.startTime = self.queue.startTime
  end
end

local function RefreshAlHelp(self, uuid)
  local alhelpData = DataCenter.AllianceHelpDataManager:GetSelfAllianceHelp(self.uuid)
  local isSoliderSpeed = self.speedType == ItemSpdMenu.ItemSpdMenu_Soldier
  local isCraft = self.speedType == ItemSpdMenu.ItemSpdMenu_DuanZao
  self.alhelp_container:SetActive(alhelpData ~= nil and not isSoliderSpeed and not isCraft)
  if alhelpData then
    local helpInfo = string.format("%d/%d", alhelpData.nowCount, alhelpData.maxCount)
    self.alhelp_remain_txt:SetText(helpInfo)
  end
  if uuid then
    self:AllianceHelpUpdateSpeedTime(uuid)
  end
end

local function AllianceHelpUpdateSpeedTime(self, uuid)
  if self.uuid == uuid then
    if self.speedType == ItemSpdMenu.ItemSpdMenu_City or self.speedType == ItemSpdMenu.ItemSpdMenu_Fix_Ruins then
      self:UpdateBuildDataSignal(uuid)
    elseif self.queue then
      self.endTime = self.endTime - self.originalEndTime + self.queue.endTime
      self.originalEndTime = self.queue.endTime
    end
  end
end

local function TryShowPackage(self)
  if self.speedType == ItemSpdMenu.ItemSpdMenu_City then
    self.packageInfo = self.ctrl:GetQuickPackageInfo(2)
  elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Science then
    self.packageInfo = self.ctrl:GetQuickPackageInfo(3)
  elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Soldier then
    self.packageInfo = self.ctrl:GetQuickPackageInfo(4)
  elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Heal then
    self.packageInfo = self.ctrl:GetQuickPackageInfo(5)
  end
  if not self.packageInfo then
    self.packageInfo = self.ctrl:GetQuickPackageInfo(1)
  end
  if self.packageInfo then
    self.package:SetActive(true)
    self.packageNameTxt:SetLocalText(self.packageInfo:getName())
    local packageIcon = ""
    local isDailyMustBuyPackage = self.ctrl:IsDailyMustBuyPackage(self.packageInfo)
    if isDailyMustBuyPackage then
      if not string.IsNullOrEmpty(self.packageInfo:getLackPic()) then
        packageIcon = string.format(LoadPath.UIPackageShop, self.packageInfo:getLackPic())
      elseif not string.IsNullOrEmpty(self.packageInfo:getPopupImageH()) then
        packageIcon = string.format(LoadPath.UIDailyMustBuy, self.packageInfo:getPopupImageH())
      end
    elseif not string.IsNullOrEmpty(self.packageInfo:getLackPic()) then
      packageIcon = string.format(LoadPath.UIPackageShop, self.packageInfo:getLackPic())
    elseif not string.IsNullOrEmpty(self.packageInfo:getPopupImageB()) then
      packageIcon = self.packageInfo:getPopupImageB()
    end
    if string.IsNullOrEmpty(packageIcon) then
      self.packageImgBMustBuy:SetActive(false)
      self.packageImgB:SetActive(false)
    else
      local prefix = "Assets/Main/Sprites/"
      if string.sub(packageIcon, 1, #prefix) == prefix then
        self.packageImgB:SetActive(true)
        self.packageImgBMustBuy:SetActive(false)
        self.packageImgB:LoadSprite(packageIcon)
      else
        self.packageImgB:SetActive(false)
        self.packageImgBMustBuy:SetActive(true)
        self.packageImgBMustBuy:LoadSprite(packageIcon)
      end
    end
    self.packageBuyBtnTxt:SetText(self.packageInfo:getPriceText())
    local percent = self.packageInfo:getPercent()
    if percent then
      self.packageDiscountTip:SetActive(true)
      self.packageDiscountTipText:SetLocalText(2000111, percent)
    else
      self.packageDiscountTip:SetActive(false)
    end
    self:ClearPackageRewardScroll()
    self.packageRewardList = self.packageInfo:getItems(false)
    if #self.packageRewardList > 0 then
      self.packageRewardScrollView:SetActive(true)
      self.packageRewardScrollView:SetTotalCount(#self.packageRewardList)
      self.packageRewardScrollView:RefillCells(1, true)
    else
      self.packageRewardScrollView:SetActive(false)
    end
  else
    self.package:SetActive(false)
  end
end

function UISpeed:TryShowPyramidPackage()
  self.moreInfoBtn:SetActive(self.curPyramidTemplate)
  self.pyramidPackage:SetActive(self.curPyramidTemplate)
  if not self.curPyramidTemplate then
    self.moreInfoBtn:SetActive(false)
    self.pyramidPackage:SetActive(false)
    return
  end
  self.packageInfo = self.curPyramidTemplate:GetCanBuyPackage()
  local subTitleStr = Localization:GetString(self.curPyramidTemplate.decoration_des1)
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.pyramidPackageDescTxt:SetTextWithLength(subTitleStr, 469, NoRollingAlignment.Right)
  else
    self.pyramidPackageDescTxt:SetTextWithLength(subTitleStr, 469, NoRollingAlignment.Left)
  end
  self.pyramidPercentReduceTxt:SetText("")
  self.scienceIcon:LoadSpriteAuto(self.curPyramidTemplate.effect_icon)
  local packIds = {}
  local curGiftId = self.packageInfo._serverData.id
  table.insert(packIds, curGiftId)
  while not string.IsNullOrEmpty(curGiftId) do
    local lineData = LocalController:instance():getLine(TableName.Exchange, curGiftId)
    if lineData == nil then
      curGiftId = ""
      break
    end
    local template = GiftPackTemplate.New()
    template:InitConfig(lineData)
    if string.IsNullOrEmpty(template.nextgift) then
      curGiftId = ""
      break
    end
    curGiftId = template.nextgift
    table.insert(packIds, curGiftId)
  end
  curGiftId = self.packageInfo._serverData.id
  while not string.IsNullOrEmpty(curGiftId) do
    local lineData = LocalController:instance():getLine(TableName.Exchange, curGiftId)
    if lineData == nil then
      curGiftId = ""
      break
    end
    local template = GiftPackTemplate.New()
    template:InitConfig(lineData)
    if string.IsNullOrEmpty(template.forwardgift) then
      curGiftId = ""
      break
    end
    curGiftId = template.forwardgift
    table.insert(packIds, curGiftId)
  end
  table.sort(packIds, function(a, b)
    return tonumber(a) < tonumber(b)
  end)
  local curIndex = 0
  for i = 1, #packIds do
    if packIds[i] == self.packageInfo._serverData.id then
      curIndex = i
      break
    end
  end
  if 0 <= curIndex then
    local buildCurLevelTemplate = self.curPyramidTemplate:GetBuildCurLevelTemplateByIndex(curIndex)
    if buildCurLevelTemplate then
      self.pyramidPercentReduceTxt:SetText(self.curPyramidTemplate:GetShowEffectWords(curIndex))
    end
  end
  self.pyramidPackageBg:LoadSpriteAsyncWithCallback("Assets/Main/Sprites/UI/PyramidSpeedUp/zxl_jiasu_libao_bg.png", function(sprite)
    if self.pyramidPackageBg then
      self.pyramidPackageBg:SetNativeSize()
    end
  end)
  self.pyramidPackageIcon:LoadSpriteAsyncWithCallback(self.curPyramidTemplate.decoration_icon, function(sprite)
    if self.pyramidPackageIcon then
      self.pyramidPackageIcon:SetNativeSize()
    end
  end)
  self.pyramidPackageNameTxt:SetLocalText(self.packageInfo:getName())
  self.pyramidPackageBuyBtnTxt:SetText(self.packageInfo:getPriceText())
  local percent = self.packageInfo:getPercent()
  if percent then
    self.pyramidPackageDiscountTip:SetActive(true)
    self.pyramidPackageDiscountTipText:SetText(percent .. "%")
  else
    self.pyramidPackageDiscountTip:SetActive(false)
  end
  self:ClearPyramidPackageRewardScroll()
end

function UISpeed:UpdateGiftPackShow()
  self.isShowPyramidPackage = self:CanBuyPyramidPackage(self.speedType)
  self.moreInfoBtn:SetActive(self.isShowPyramidPackage)
  self.pyramidPackage:SetActive(self.isShowPyramidPackage)
  self.package:SetActive(not self.isShowPyramidPackage)
  if self.isShowPyramidPackage then
    if self.curPyramidTemplate then
      DataCenter.ExchangeSpecialManager:RequestExchangeSpecialDecorationReduce(self.curPyramidTemplate.id, true)
    end
    self.scrollviewLayout:SetMinHeight(pyramidScrollViewsHeight)
    self:TryShowPyramidPackage()
  else
    self.scrollviewLayout:SetMinHeight(defaultScrollViewsHeight)
    self:TryShowPackage()
  end
  self:ShowCells()
end

local function ShowImage(self)
  if self.speedType == ItemSpdMenu.ItemSpdMenu_Science then
    if self.queue ~= nil then
      local template = DataCenter.ScienceManager:GetSearchingScienceTemplate(self.queue.uuid)
      if template ~= nil then
        self.icon:LoadSprite(string.format(LoadPath.UILWScience, template.icon))
        self.icon.rectTransform:Set_sizeDelta(109, 113)
      end
    end
  elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Soldier then
    local soldierId = DataCenter.SoldierDataManager:GetSoldierIdByLevel(self.buildData.prodStatus)
    local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(soldierId)
    if soldierTemplate ~= nil then
      local elevenData = T11Util.GetSelfCurSoldierData()
      local iconPath = DataCenter.SoldierDataManager:GetSoldierIconByTmp(soldierTemplate, elevenData)
      self.icon:LoadSprite(iconPath)
      self.icon.rectTransform:Set_sizeDelta(123, 125)
    end
  elseif self.speedType == ItemSpdMenu.ItemSpdMenu_DuanZao then
    local equipCfgId = self.buildData.prodStatus
    local icon = DataCenter.EquipTemplateManager:GetEquipIconById(equipCfgId)
    if icon ~= nil then
      self.icon:LoadSprite(string.format(LoadPath.ItemPath, icon))
      self.icon.rectTransform:Set_sizeDelta(123, 125)
    end
  elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Chip_Crate then
    self.icon:SetActive(false)
  elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Heal then
    self.icon:LoadSprite(HospitalItemImageName)
    self.icon.rectTransform:Set_sizeDelta(78, 83)
  elseif self.speedType == ItemSpdMenu.ItemSpdMenu_City or self.speedType == ItemSpdMenu.ItemSpdMenu_Fix_Ruins then
    if self.buildData ~= nil then
      local level = 1
      if self.buildData.level > 0 then
        level = self.buildData.level
      end
      self.icon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.buildData.itemId, level))
      self.icon.rectTransform:Set_sizeDelta(170, 164)
    end
  elseif self.speedType == ItemSpdMenu.ItemSpdT11_BreakUpgrade then
    if not T11Util.IsUnlockT11() then
      self.icon.rectTransform:Set_sizeDelta(0, 0)
    else
      self.icon:LoadSprite(T11Util.GetNextStageSkillIcon())
      self.icon.rectTransform:Set_sizeDelta(70, 70)
    end
  end
end

local function ShowCells(self)
  self:GetAllItems()
  self.more_btn_go:SetActive(false)
  local count = #self.items + #self.buyItems
  self.scrollview:SetActive(true)
  self:ClearScroll()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content_container.rectTransform)
  self.scrollview:SetTotalCount(count)
  self.scrollview:RefillCells(1, true)
  self.isCreateScroll = true
end

local function GuidAutoScroll(self, itemId)
  if self.items then
    local index
    for i = 1, table.count(self.items) do
      if self.items[i].itemId == tostring(itemId) then
        index = i
      end
    end
    if index then
      if 3 < index then
        index = index - 2
      end
      self.scrollview:ScrollToCell(index - 1, 0.3)
    end
  end
end

local function ClearScroll(self)
  self.scrollview:ClearCells()
  self.scrollview:RemoveComponents(UIItemCell)
end

local function ClearPackageRewardScroll(self)
  self.packageRewardScrollView:ClearCells()
  self.packageRewardScrollView:RemoveComponents(UICommonResItem)
end

function UISpeed:ClearPyramidPackageRewardScroll()
  self.pyramidPackageRewardScrollView:ClearCells()
  self.pyramidPackageRewardScrollView:RemoveComponents(UIResItemExtraItem)
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local item = self.scrollview:AddComponent(UIItemCell, itemObj)
  if not item then
    return
  end
  local param = UIItemCell.Param.New()
  if index > self.itemNum then
    param.stateType = UIItemCell.StateType.Buy
    param.template = self.buyItems[index - self.itemNum]
    param.goldImage = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
  else
    param.stateType = UIItemCell.StateType.Own
    param.count = self.items[index].count
    param.template = self:GetItemTemplate(self.items[index].itemId)
    param.itemId = self.items[index].itemId
    if param.itemId == "UseSpeedUpBuy" then
      param.template = {}
      param.template.price = self.items[index].price
      param.template.buyList = self.items[index].buyList
      param.template.itemId = "UseSpeedUpBuy"
      param.template.speedUpTime = self.items[index].speedUpTime
    elseif param.itemId == "UseSpeedUp" then
      param.speedUpTime = self.items[index].speedUpTime
    end
  end
  
  function param.callBack(index, template, isBuy)
    self:CellsCallBack(index, template, isBuy)
  end
  
  param.index = index
  param.isSignHeroFreeTIme = self.isSignHeroFreeTIme
  item:ReInit(param)
  self.cells[index] = item
end

local function OnDeleteCell(self, itemObj, index)
  self.scrollview:RemoveComponent(itemObj.name, UIItemCell)
  if self.showTimer == nil then
    self:HideMoreBtn()
  end
end

local function OnInitScroll(self, go, index)
  local item = self.scrollview:AddComponent(UIItemCell, go)
  self.listGO[go] = item
end

local function OnUpdateScroll(self, go, index)
  local cellItem = self.listGO[go]
  if not cellItem then
    return
  end
  local param = UIItemCell.Param.New()
  if index + 1 > self.itemNum then
    param.stateType = UIItemCell.StateType.Buy
    param.template = self.buyItems[index + 1 - self.itemNum]
    param.goldImage = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
  else
    param.stateType = UIItemCell.StateType.Own
    param.count = self.items[index + 1].count
    param.template = self:GetItemTemplate(self.items[index + 1].itemId)
    param.itemId = self.items[index + 1].itemId
    cellItem.gameObject.name = param.itemId
    if param.itemId == "UseSpeedUpBuy" then
      param.template = {}
      param.template.price = self.items[index + 1].price
      param.template.speedUpTime = self.items[index + 1].speedUpTime
    end
  end
  
  function param.callBack(index, template, isBuy)
    self:CellsCallBack(index, template, isBuy)
  end
  
  param.index = index + 1
  param.isSignHeroFreeTIme = self.isSignHeroFreeTIme
  cellItem:ReInit(param)
  self.cells[index + 1] = cellItem
end

local function OnDestroyScrollItem(self, go, index)
  if self.showTimer == nil then
    self:HideMoreBtn()
  end
end

function UISpeed:SendBuy()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local time = (self.endTime - curTime) / 1000
  local price = CommonUtil.GetTimeDiamondCost(math.floor(time))
  
  local function closeFun()
    self.isBuy = false
  end
  
  local param = {
    contentText = Localization:GetString(GameDialogDefine.COST_DIAMOND_CONFIRM_TIPS1, string.GetFormattedSeperatorNum(price)),
    btnNum = 2,
    confirmBtnParam = {
      action = function()
        self:SendMsg()
        if self.speedType == ItemSpdMenu.ItemSpdMenu_City then
          SFSNetwork.SendMessage(MsgDefines.BuildCcdMNew, {
            bUUID = self.uuid,
            useGold = price,
            isFixRuins = false
          }, self.cacheUsedGolloesFreeTime)
        elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Fix_Ruins then
          SFSNetwork.SendMessage(MsgDefines.BuildCcdMNew, {
            bUUID = self.uuid,
            useGold = price,
            isFixRuins = true
          }, self.cacheUsedGolloesFreeTime)
        elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Soldier or self.speedType == ItemSpdMenu.ItemSpdMenu_DuanZao or self.speedType == ItemSpdMenu.ItemSpdMenu_Chip_Crate then
          SFSNetwork.SendMessage(MsgDefines.BuildingCampAccel, self.uuid, nil, price)
        else
          SFSNetwork.SendMessage(MsgDefines.QueueCcdMNew, {
            qUUID = self.uuid,
            useGold = price
          }, self.cacheUsedGolloesFreeTime)
        end
        PostEventLog.Track(PostEventLog.Defines.OneTapSpeedUp_diamond_confirm, {})
        self.ctrl:CloseSelf()
      end
    },
    cancelBtnParam = {action = closeFun},
    closeAction = closeFun
  }
  UIUtil.TryShowDiamondConfirm(TodayNoSecondConfirmType.UpgradeUseDiamond, param)
end

function UISpeed:GetSpeedItem()
  local list = DeepCopy(DataCenter.ItemData:GetSpeedItem(self.speedType)) or {}
  local useItemCount
  for i = #list, 1, -1 do
    useItemCount = self.useItem[list[i].itemId]
    if useItemCount then
      list[i].count = list[i].count - useItemCount
      if list[i].count <= 0 then
        table.remove(list, i)
      end
    end
  end
  return list
end

local function CellsCallBack(self, index, template, isBuy)
  if isBuy then
    self:HideMoreBtn()
    if LuaEntry.Player.gold >= template.price then
      if template.itemId == "UseSpeedUpBuy" then
        self.isBuy = true
        self:SendBuy()
      else
        UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog, Localization:GetString(GameDialogDefine.SPEND_SOMETHING_BUY_SOMETHING, string.GetFormattedSeperatorNum(template.price), Localization:GetString(GameDialogDefine.DIAMOND), DataCenter.ItemTemplateManager:GetName(template.id)), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          local time = 0
          local temp = string.split(template.para1, ";")
          if temp ~= nil and 1 < #temp then
            time = DataCenter.ItemTemplateManager:GetShowTime(temp[1], temp[2])
          end
          local curTime = UITimeManager:GetInstance():GetServerTime()
          local outTime = curTime + time - self.endTime
          if outTime >= OutTime then
            local tips = Localization:GetString("120001", UITimeManager:GetInstance():MilliSecondToFmtString(outTime))
            UIUtil.ShowMessage(tips, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
              self:ConfirmBuy(template, time)
            end)
          else
            self:ConfirmBuy(template, time)
          end
        end)
      end
    else
      if template.itemId == "UseSpeedUpBuy" then
        PostEventLog.Track(PostEventLog.Defines.OneTapSpeedUp_diamond_confirm_notenough, {})
      end
      GoToUtil.GotoPayTips(template.price)
    end
  else
    self.moreIndex = index
    local item
    if table.IsNullOrEmpty(self.items) then
      return
    end
    for i = 1, #self.items do
      local _item = self.items[i]
      if _item and _item.itemId and _item.itemId == template.id then
        item = _item
        break
      end
    end
    if not item then
      return
    end
    if item.itemId == "GolloesFreeTime" then
      local useGolloesTime = self:GetGolloesMaxFreeTime()
      local strGolloesTime = UITimeManager:GetInstance():MilliSecondToFmtString(useGolloesTime)
      UIUtil.ShowMessage(Localization:GetString("320262", strGolloesTime), 2, nil, nil, function()
        self.cacheUsedGolloesFreeTime = self.cacheUsedGolloesFreeTime + useGolloesTime
        self:ReduceTime(useGolloesTime)
        self:ShowCells()
      end, nil, nil)
    elseif item.itemId == "Speedup_Consigliere" then
      local freeTime = LuaEntry.Effect:GetGameEffect(EffectDefine.BUILD_TIME_REDUCE)
      self:ReduceTime(freeTime * SecToMilSec)
      self:ShowCells()
      self.isUseHeroAddTime = true
    elseif item.itemId == "Speedup_FederalCop" then
      local freeTime = LuaEntry.Effect:GetGameEffect(EffectDefine.RESEARCH_TIME_REDUCE)
      self:ReduceTime(freeTime * SecToMilSec)
      self:ShowCells()
      self.isUseHeroAddTime = true
    elseif item.itemId == "Speedup_kongzhitai" then
      local freeTime
      if self.speedType == ItemSpdMenu.ItemSpdMenu_City then
        freeTime = LuaEntry.Effect:GetGameEffect(EffectDefine.BUILD_TIME_REDUCE)
      elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Science then
        freeTime = LuaEntry.Effect:GetGameEffect(EffectDefine.RESEARCH_TIME_REDUCE)
      end
      self:ReduceTime(freeTime * SecToMilSec)
      self:ShowCells()
      self.isUseHeroAddTime = true
    elseif item.itemId == "UseSpeedUp" then
      local info = {}
      local list = self:GetSpeedItem()
      local time
      self.speedItemList, time = self:GetOneSpeedUp(list)
      info.itemList = self.speedItemList
      
      function info.callBack()
        if self.speedItemList then
          local time = 0
          local item
          for i = 1, #self.speedItemList do
            item = self.speedItemList[i].item
            if item then
              if item.para3 and item.count and item.itemId then
                self:AppendUseItemActionLog(item.itemId, item.count, "OneTapSpeedUp")
                self:UseAddItem(item.itemId, item.count)
                time = time + tonumber(self.speedItemList[i].item.para3) * self.speedItemList[i].item.count * SecToMilSec
              elseif item.itemId then
                Logger.LogError("error speedUp itemId : " .. item.itemId)
              else
                Logger.LogError("error speedUp !! index is nil : " .. i)
              end
            end
          end
          if 0 < time then
            self:ReduceTime(time)
          end
          PostEventLog.Track(PostEventLog.Defines.OneTapSpeedUp_item_confirm, {})
          self:ShowCells()
        end
      end
      
      local curTime = UITimeManager:GetInstance():GetServerTime()
      info.remainingTime = math.max(0, self.endTime - curTime)
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWPropUsePanel, {anim = true}, info)
    else
      self.moreItemId = item.itemId
      do
        local time = 0
        local temp = string.split(template.para1, ";")
        if temp ~= nil and 1 < #temp then
          time = DataCenter.ItemTemplateManager:GetShowTime(temp[1], temp[2])
        end
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local outTime = curTime + time - self.endTime
        if 60000 < outTime then
          local tips = Localization:GetString("120001", UITimeManager:GetInstance():MilliSecondToFmtString(outTime))
          local isFunctionOn = LuaEntry.DataConfig:CheckSwitch("quick_return_switch")
          if isFunctionOn then
            tips = tips .. "\n" .. Localization:GetString("quick_return_2")
          end
          UIUtil.ShowMessage(tips, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            self:ConfirmUse(template.id, item, time)
            if 0 < outTime then
              DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Speed_Button2, false)
            else
              DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Speed_Button, false)
            end
          end, nil, nil, nil, nil, true)
        else
          self:ConfirmUse(template.id, item, time)
          if 0 < outTime then
            DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Speed_Button2, false)
          else
            DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Speed_Button, false)
          end
        end
      end
    end
  end
end

local function ConfirmUse(self, id, item, time)
  self:AppendUseItemActionLog(id, 1, "UseSpeedUp")
  self:UseAddItem(id, 1)
  self:ReduceTime(time)
  item = self:GetItemById(id)
  if item and 1 < item.count then
    self.more_btn_go:SetActive(true)
    self:ShowMoreBtn()
    self:ShowMoreBtnName(time, item)
  else
    self.more_btn_go:SetActive(false)
    self:GetAllItems()
    local param = {}
    for i = 1, #self.buyItems do
      if item.para3 == self.buyItems[i].para3 then
        param.template = self.buyItems[i]
      end
    end
    if param.template then
      param.stateType = UIItemCell.StateType.Buy
      param.goldImage = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
      
      function param.callBack(index, template, isBuy)
        self:CellsCallBack(index, template, isBuy)
      end
      
      param.index = self.moreIndex
      param.isSignHeroFreeTIme = self.isSignHeroFreeTIme
      self.cells[self.moreIndex]:ReInit(param)
    else
      local pos = self.content:GetAnchoredPosition()
      self:ClearScroll()
      self.scrollview:SetTotalCount(#self.items + #self.buyItems)
      self.scrollview:RefillCells(1, true)
      self.content:SetAnchoredPosition(pos)
    end
  end
  if self.cells[self.moreIndex] ~= nil and item and 1 <= item.count then
    self.cells[self.moreIndex]:RefreshOwnCount(item.count)
  end
  EventManager:GetInstance():Broadcast(EventId.AddSpeedSuccess, NewQueueType.Science)
  EventManager:GetInstance():Broadcast(EventId.GF_building_speedup_by_item, item)
end

local function ConfirmBuy(self, template, time, number)
  local tempNumber = number and number or 1
  self:UseAddItem(template.id, tempNumber)
  self:ReduceTime(time * tempNumber)
  LuaEntry.Player.gold = LuaEntry.Player.gold - template.price * tempNumber
  self.changeGold = self.changeGold + template.price * tempNumber
  self.isChangeRefreshGold = false
  EventManager:GetInstance():Broadcast(EventId.UpdateGold)
end

local function Update(self)
  if self.endTime ~= nil then
    local curTime = 0
    if self.needUpdate then
      curTime = UITimeManager:GetInstance():GetServerTime()
    else
      curTime = self.startTime + self.addTime
    end
    if curTime >= self.endTime then
      self.endTime = 0
      self.ctrl:CloseSelf()
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UICommonMessageTip) then
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonMessageTip)
      end
    else
      local changeTime = self.endTime - curTime
      local maxTime = self.endTime - self.startTime
      if 0 < changeTime then
        local tempTimeSec = math.ceil(changeTime / 1000)
        if tempTimeSec ~= self.laseTime then
          self.laseTime = tempTimeSec
          local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
          self:SetLeftText(tempTimeValue)
          if self.isHeroFreeTime then
            local freeTime = 0
            if self.speedType == ItemSpdMenu.ItemSpdMenu_City then
              freeTime = LuaEntry.Effect:GetGameEffect(EffectDefine.BUILD_TIME_REDUCE)
            elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Science then
              freeTime = LuaEntry.Effect:GetGameEffect(EffectDefine.RESEARCH_TIME_REDUCE)
            end
            if freeTime ~= 0 then
              if changeTime <= freeTime * SecToMilSec then
                self.isSignHeroFreeTIme = true
                self:SetProBgPath(true)
                self.vfx_canFree:SetActive(true)
                for i, v in pairs(self.cells) do
                  if v:IsHeroFreeTimeCell() then
                    v:RefreshState(true)
                  end
                end
              else
                self:SetProBgPath(false)
                self.vfx_canFree:SetActive(false)
                for i, v in pairs(self.cells) do
                  if v:IsHeroFreeTimeCell() then
                    v:RefreshState(false)
                  end
                end
              end
            else
              self:SetProBgPath(false)
              self.vfx_canFree:SetActive(false)
            end
          end
        end
        if 0 < maxTime then
          local tempValue = 1 - changeTime / maxTime
          if TimeBarUtil.CheckIsNeedChangeBar(changeTime, self.lastChangeTime, maxTime, SliderLength) then
            self.lastChangeTime = changeTime
            self:SetSliderValue(tempValue)
          end
        end
      end
    end
  end
end

local function SetProBgPath(self, state)
  if self.lastState ~= state then
    if state then
      self.pro_img:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_pro_green"))
      self.scrollview:ScrollToCell(0, 0.3)
    else
      self.pro_img:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_pro_yellow"))
    end
    self.lastState = state
  end
end

local function SetSliderValue(self, value)
  if self.sliderValue ~= value then
    self.sliderValue = value
    self.slider:SetValue(value)
  end
end

local function SetLeftText(self, value)
  if self.leftText ~= value then
    self.leftText = value
    self.left_time:SetText(value)
  end
end

local function GetAllItems(self)
  self.items = self:GetSpeedItem()
  table.sort(self.items, self.SortItem)
  self:TryAddHeroFreeTime(self.speedType)
  self:TryAddOneClickAccelerationBuy()
  self:TryAddOneClickAcceleration()
  self.itemNum = #self.items
  self.buyItems = {}
end

local function GetOneSpeedUp(self, list)
  if list and 0 < #list then
    return LWResourceLackUtil:GetSpeedUpGoods(self.endTime, self.speedType, list)
  else
    return {}
  end
end

local function TryAddOneClickAccelerationBuy(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local time = (self.endTime - curTime) / 1000
  local virtualItem = {}
  virtualItem.itemId = "UseSpeedUpBuy"
  virtualItem.price = CommonUtil.GetTimeDiamondCost(math.floor(time))
  virtualItem.stateType = 2
  virtualItem.para1 = 1
  virtualItem.speedUpTime = time
  table.insert(self.items, 1, virtualItem)
end

function UISpeed:GetSpeedUpTime(speedItemList, time)
  local speedUpTime = 0
  if not speedItemList or not time then
    return 0
  end
  if 0 < #speedItemList then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local tempTime = (self.endTime - curTime) / 1000
    speedUpTime = tempTime - time
  end
  return speedUpTime
end

local function TryAddOneClickAcceleration(self)
  local list = self:GetSpeedItem()
  local time
  self.speedItemList, time = self:GetOneSpeedUp(list)
  if self.speedItemList and #self.speedItemList > 0 then
    local virtualItem = {}
    virtualItem.itemId = "UseSpeedUp"
    virtualItem.para1 = 1
    virtualItem.speedUpTime = self:GetSpeedUpTime(self.speedItemList, time)
    table.insert(self.items, 1, virtualItem)
  end
end

local function GetItemTemplate(self, id)
  local nId = tonumber(id)
  if not nId then
    return nil
  end
  local temp = self.template[id]
  if temp == nil then
    self.template[id] = DataCenter.ItemTemplateManager:GetItemTemplate(id)
  end
  return self.template[id]
end

local function SortItem(a, b)
  local goodsTemplate1 = DataCenter.ItemTemplateManager:GetItemTemplate(a.itemId)
  local goodsTemplate2 = DataCenter.ItemTemplateManager:GetItemTemplate(b.itemId)
  if goodsTemplate1 == nil then
    return false
  elseif goodsTemplate2 == nil then
    return true
  else
    if goodsTemplate1.type2 < goodsTemplate2.type2 then
      return false
    elseif goodsTemplate1.type2 > goodsTemplate2.type2 then
      return true
    end
    if goodsTemplate1.order > goodsTemplate2.order then
      return false
    elseif goodsTemplate1.order < goodsTemplate2.order then
      return true
    else
      local id1 = tonumber(a.itemId)
      local id2 = tonumber(b.itemId)
      if id1 > id2 then
        return true
      elseif id1 < id2 then
        return false
      end
    end
  end
  return false
end

local function SortItemTemplate(a, b)
  if a == nil then
    return false
  elseif b == nil then
    return true
  elseif a.order > b.order then
    return false
  elseif a.order < b.order then
    return true
  else
    local id1 = tonumber(a.id)
    local id2 = tonumber(b.id)
    if id1 > id2 then
      return true
    elseif id1 < id2 then
      return false
    end
  end
  return false
end

local function AppendUseItemActionLog(self, itemId, count, approachStr)
  if not (itemId and count) or count <= 0 then
    return
  end
  self.useItemActionLog = self.useItemActionLog or {}
  approachStr = approachStr or ""
  table.insert(self.useItemActionLog, approachStr .. "|" .. tostring(itemId) .. "|" .. tostring(count) .. "; ")
end

local function UseAddItem(self, itemId, count)
  if not itemId or not count then
    return
  end
  self.lastUserItemId = itemId
  if self.useItem[itemId] == nil then
    self.useItem[itemId] = count
  else
    self.useItem[itemId] = self.useItem[itemId] + count
  end
  DataCenter.GetDuelScoreManager:UseSpeed(self.speedType, itemId, count)
end

local function TryAddGolloesFreeTime(self)
  local isAvailable = DataCenter.MonthCardNewManager:CheckIfGolloesMonthCardAvailable()
  if not isAvailable then
    return
  end
  local freeTime = DataCenter.GolloesCampManager:GetFreeSpeedTime() - self.cacheUsedGolloesFreeTime
  freeTime = freeTime < 0 and 0 or freeTime
  local virtualItem = {}
  virtualItem.itemId = "GolloesFreeTime"
  virtualItem.use = "0"
  virtualItem.count = freeTime
  virtualItem.para1 = 7
  virtualItem.para2 = 1
  virtualItem.para3 = 60
  virtualItem.para4 = ""
  virtualItem.uuid = ""
  virtualItem.cbitem = ""
  virtualItem.cbpart = ""
  virtualItem.cbnum = ""
  virtualItem.rightseffect = ""
  table.insert(self.items, 1, virtualItem)
end

local function TryAddHeroFreeTime(self, type)
  if type == ItemSpdMenu.ItemSpdMenu_City or type == ItemSpdMenu.ItemSpdMenu_Science then
    local freeTime = DataCenter.HeroDataManager:GetFreeAddTimeHero(ItemSpd[type])
    local effectTime = LuaEntry.Effect:GetGameEffect(ItemSpd[type])
    if freeTime or 0 < effectTime then
      self.isHeroFreeTime = true
      local virtualItem = {}
      virtualItem.itemId = "Speedup_kongzhitai"
      local time = LuaEntry.Effect:GetGameEffect(type == ItemSpdMenu.ItemSpdMenu_City and EffectDefine.BUILD_TIME_REDUCE or EffectDefine.RESEARCH_TIME_REDUCE)
      virtualItem.count = time
      virtualItem.heroName = HeroUtils.GetHeroNameByConfigId(type == ItemSpdMenu.ItemSpdMenu_City and 11001 or 22001)
      table.insert(self.items, 1, virtualItem)
    end
  end
end

local function GetGolloesMaxFreeTime(self)
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = self.endTime
  if self.isHeroFreeTime then
    local heroFreeTime = 0
    if ItemSpd[self.speedType] then
      heroFreeTime = LuaEntry.Effect:GetGameEffect(ItemSpd[self.speedType])
    end
    if self.endTime - serverTime > heroFreeTime * SecToMilSec then
      endTime = endTime - heroFreeTime * SecToMilSec
    end
  end
  local remainTimeMs = endTime - serverTime
  local golloesRemainTime = DataCenter.GolloesCampManager:GetFreeSpeedTime() - self.cacheUsedGolloesFreeTime
  local finalT = 0
  if remainTimeMs < golloesRemainTime then
    finalT = remainTimeMs
  else
    finalT = golloesRemainTime
  end
  return finalT
end

local function ReduceTime(self, time)
  if self.needUpdate then
    self.endTime = self.endTime - time
    self.startTime = self.startTime - time
  else
    self.addTime = self.addTime + time
  end
  for i, v in pairs(self.cells) do
    if v.param then
      if v.param.itemId == "UseSpeedUpBuy" then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local time = (self.endTime - curTime) / 1000
        v.param.template.price = CommonUtil.GetTimeDiamondCost(math.floor(time))
        v.param.template.speedUpTime = time
        v:ReInit(v.param)
      elseif v.param.itemId == "UseSpeedUp" then
        local list = self:GetSpeedItem()
        local tempTime
        self.speedItemList, tempTime = self:GetOneSpeedUp(list)
        v.param.speedUpTime = self:GetSpeedUpTime(self.speedItemList, tempTime)
        v:ReInit(v.param)
      end
    end
  end
end

local function ShowMoreBtn(self)
  local moreParent = self.cells[self.moreIndex]:GetMoreBtnParent()
  if self.moreParent ~= moreParent then
    self.moreParent = moreParent
    self.more_btn_go.transform:SetParent(moreParent)
    local isArabicAutoMirrorOpen = CommonUtil.IsArabicAutoMirrorOpen()
    if isArabicAutoMirrorOpen then
      self.more_btn_go.transform:Set_localPosition(35, ResetPosition.y, ResetPosition.z)
    else
      self.more_btn_go.transform:Set_localPosition(-35, ResetPosition.y, ResetPosition.z)
    end
    local ret, time = self.more_btn_go:PlayAnimationReturnTime("ShowMoreBtn")
    if ret then
      self.showTimer = TimerManager:GetInstance():GetTimer(time + 0.5, function()
        if self.showTimer ~= nil then
          self.showTimer:Stop()
          self.showTimer = nil
        end
      end, self, true, false, false)
      self.showTimer:Start()
    end
  end
end

local function HideMoreBtn(self)
  if self.moreParent then
    self.moreParent = nil
    self.more_btn_go.transform:SetParent(self.transform)
    self.more_btn_go.transform:SetAsFirstSibling()
    self.more_btn_go:Play("CloseMoreBtn", 0, 0)
  end
end

local function ShowMoreBtnName(self, oneTime, item)
  if 0 < oneTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local endTime = self.endTime
    if self.isHeroFreeTime then
      local freeTime = 0
      if self.speedType == ItemSpdMenu.ItemSpdMenu_City then
        freeTime = LuaEntry.Effect:GetGameEffect(EffectDefine.BUILD_TIME_REDUCE)
      elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Science then
        freeTime = LuaEntry.Effect:GetGameEffect(EffectDefine.RESEARCH_TIME_REDUCE)
      end
      if freeTime ~= 0 and not self.isSignHeroFreeTIme then
        endTime = self.endTime - freeTime * SecToMilSec
      end
    end
    self.moreBtnMax = math.floor((endTime - curTime) / oneTime)
    if self.moreBtnMax > item.count then
      self.moreBtnMax = item.count
    end
    if self.moreBtnMax > 1 then
      self.use_max_btn:SetActive(self.moreBtnMax > 1)
      self.use_count_btn:SetActive(self.moreBtnMax > 10)
      if self.moreBtnMax > 1 then
        local showNum = math.min(self.moreBtnMax, 10)
        self.use_max_btn_name:SetText("x" .. showNum)
      end
      if self.moreBtnMax > 10 then
        local showNum = math.min(self.moreBtnMax, 100)
        self.use_count_btn_name:SetText("x" .. showNum)
      end
    else
      self.more_btn_go:SetActive(false)
    end
  end
end

local function SendMsg(self)
  local itemStr = ""
  local lastUserItemCount = self.useItem[self.lastUserItemId] or 0
  self.useItem[self.lastUserItemId] = nil
  for k, v in pairs(self.useItem) do
    if itemStr == "" then
      itemStr = k .. ";" .. v
    else
      itemStr = itemStr .. "|" .. k .. ";" .. v
    end
  end
  if self.lastUserItemId ~= 0 then
    if itemStr == "" then
      itemStr = self.lastUserItemId .. ";" .. lastUserItemCount
    else
      itemStr = itemStr .. "|" .. self.lastUserItemId .. ";" .. lastUserItemCount
    end
  end
  if itemStr ~= "" or 0 < self.cacheUsedGolloesFreeTime then
    local actionLog = ""
    if self.useItemActionLog ~= nil then
      actionLog = table.concat(self.useItemActionLog)
    end
    if actionLog ~= "" then
      Logger.LogInfo(string.format("[UISpeedView] SendMsg\239\188\154 speedType=%s uuid=%s useItemPath=%s", tostring(self.speedType), tostring(self.uuid), actionLog))
    end
    if self.speedType == ItemSpdMenu.ItemSpdMenu_City then
      SFSNetwork.SendMessage(MsgDefines.BuildCcdMNew, {
        bUUID = self.uuid,
        itemIDs = itemStr,
        isFixRuins = false
      }, self.cacheUsedGolloesFreeTime)
    elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Fix_Ruins then
      SFSNetwork.SendMessage(MsgDefines.BuildCcdMNew, {
        bUUID = self.uuid,
        itemIDs = itemStr,
        isFixRuins = true
      }, self.cacheUsedGolloesFreeTime)
    elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Soldier or self.speedType == ItemSpdMenu.ItemSpdMenu_DuanZao or self.speedType == ItemSpdMenu.ItemSpdMenu_Chip_Crate then
      SFSNetwork.SendMessage(MsgDefines.BuildingCampAccel, self.uuid, itemStr)
    else
      SFSNetwork.SendMessage(MsgDefines.QueueCcdMNew, {
        qUUID = self.uuid,
        itemIDs = itemStr,
        isGold = IsGold.NoUseGold
      }, self.cacheUsedGolloesFreeTime)
    end
  end
  if self.isUseHeroAddTime then
    if self.speedType == ItemSpdMenu.ItemSpdMenu_City then
      SFSNetwork.SendMessage(MsgDefines.BuildCcdMNew, {
        bUUID = self.uuid,
        itemIDs = "",
        isFixRuins = false
      })
    elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Science then
      SFSNetwork.SendMessage(MsgDefines.QueueCcdMNew, {
        qUUID = self.uuid,
        itemIDs = "",
        isGold = IsGold.NoUseGold
      })
    end
  end
end

local function UpdateBuildDataSignal(self, uuid)
  if self.uuid == uuid then
    if self.speedType == ItemSpdMenu.ItemSpdMenu_City then
      self.endTime = self.endTime - self.originalEndTime + self.buildData.updateTime
      self.originalEndTime = self.buildData.updateTime
    elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Fix_Ruins then
      self.endTime = self.endTime - self.originalEndTime + self.buildData.destroyEndTime
      self.originalEndTime = self.buildData.destroyEndTime
    end
  end
end

local function UpdateGoldSignal(self)
  if self.isChangeRefreshGold then
    local gold = LuaEntry.Player.gold
    if self.changeGold ~= 0 then
      LuaEntry.Player.gold = gold - self.changeGold
    end
  else
    self.isChangeRefreshGold = true
  end
  self:RefreshGold()
end

local function RefreshGold(self)
  local gold = LuaEntry.Player.gold
  for k, v in pairs(self.cells) do
    v:RefreshColor(gold)
  end
end

local function OnClickJumpToPackBtn(self)
  if self.packageInfo then
    GoToUtil.GotoGiftPackView(self.packageInfo)
  end
end

local function OnCreatePackageRewardCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.packageRewardScrollView:AddComponent(UICommonResItem, itemObj)
  cellItem:ReInit(self.packageRewardList[index])
end

local function OnDeletePackageRewardCell(self, itemObj, index)
  self.packageRewardScrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

function UISpeed:OnCreatePyramidPackageRewardCell(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.pyramidPackageRewardScrollView:AddComponent(UIResItemExtraItem, itemObj)
  cellItem:ReInit(self.packageRewardList[index])
end

function UISpeed:OnDeletePyramidPackageRewardCell(itemObj, index)
  self.pyramidPackageRewardScrollView:RemoveComponent(itemObj.name, UIResItemExtraItem)
end

function UISpeed:ClickMoreInfoBtn()
  if not self.moreInfoTipObj then
    return
  end
  self.moreInfoTipObj:SetActive(not self.moreInfoTipObj.activeSelf)
end

function UISpeed:ClickMoreInfoCloseBtn()
  if not self.moreInfoTipObj then
    return
  end
  self.moreInfoTipObj:SetActive(false)
end

function UISpeed:RefreshPyramidPackageTipsAndReward(msg)
  if not self.isShowPyramidPackage then
    return
  end
  local tipText = DataCenter.ExchangeSpecialManager:GetSpeedInfoTipText(msg.id)
  self.TipsContent:SetText(tipText)
  self.packageRewardList = self.packageInfo:getItems(false)
  for i = 1, #self.packageRewardList do
    if self.packageRewardList[i].isShowExtraFlag then
      table.remove(self.packageRewardList, i)
      break
    end
  end
  local extraReward = {}
  extraReward.id = msg.itemId
  extraReward.itemId = tonumber(msg.itemId)
  extraReward.count = msg.itemNum
  extraReward.rewardType = 7
  extraReward.isShowExtraFlag = true
  extraReward.trainRewardState = TrainRewardState.EnglishExtra
  if extraReward.id ~= 0 and extraReward.count > 0 then
    table.insert(self.packageRewardList, extraReward)
  end
  if #self.packageRewardList > 0 then
    self.pyramidPackageRewardScrollView:SetActive(true)
    self.pyramidPackageRewardScrollView:SetTotalCount(#self.packageRewardList)
    self.pyramidPackageRewardScrollView:RefillCells(1, true)
  else
    self.pyramidPackageRewardScrollView:SetActive(false)
  end
end

UISpeed.OnCreate = OnCreate
UISpeed.OnDestroy = OnDestroy
UISpeed.OnEnable = OnEnable
UISpeed.OnDisable = OnDisable
UISpeed.ComponentDefine = ComponentDefine
UISpeed.ComponentDestroy = ComponentDestroy
UISpeed.DataDefine = DataDefine
UISpeed.DataDestroy = DataDestroy
UISpeed.OnAddListener = OnAddListener
UISpeed.OnRemoveListener = OnRemoveListener
UISpeed.MoreBtnClick = MoreBtnClick
UISpeed.ClearScroll = ClearScroll
UISpeed.ReInit = ReInit
UISpeed.ShowImage = ShowImage
UISpeed.ShowCells = ShowCells
UISpeed.GuidAutoScroll = GuidAutoScroll
UISpeed.CellsCallBack = CellsCallBack
UISpeed.Update = Update
UISpeed.SetProBgPath = SetProBgPath
UISpeed.SetSliderValue = SetSliderValue
UISpeed.SetLeftText = SetLeftText
UISpeed.GetAllItems = GetAllItems
UISpeed.GetItemTemplate = GetItemTemplate
UISpeed.SortItem = SortItem
UISpeed.SortItemTemplate = SortItemTemplate
UISpeed.AppendUseItemActionLog = AppendUseItemActionLog
UISpeed.UseAddItem = UseAddItem
UISpeed.ReduceTime = ReduceTime
UISpeed.ShowMoreBtn = ShowMoreBtn
UISpeed.ShowMoreBtnName = ShowMoreBtnName
UISpeed.SendMsg = SendMsg
UISpeed.UpdateBuildDataSignal = UpdateBuildDataSignal
UISpeed.ConfirmUse = ConfirmUse
UISpeed.ConfirmBuy = ConfirmBuy
UISpeed.UpdateGoldSignal = UpdateGoldSignal
UISpeed.RefreshGold = RefreshGold
UISpeed.HideMoreBtn = HideMoreBtn
UISpeed.TryAddGolloesFreeTime = TryAddGolloesFreeTime
UISpeed.GetGolloesMaxFreeTime = GetGolloesMaxFreeTime
UISpeed.TryAddHeroFreeTime = TryAddHeroFreeTime
UISpeed.OnClickJumpToPackBtn = OnClickJumpToPackBtn
UISpeed.TryShowPackage = TryShowPackage
UISpeed.OnInitScroll = OnInitScroll
UISpeed.OnUpdateScroll = OnUpdateScroll
UISpeed.OnDestroyScrollItem = OnDestroyScrollItem
UISpeed.OnCreateCell = OnCreateCell
UISpeed.OnDeleteCell = OnDeleteCell
UISpeed.OnCreatePackageRewardCell = OnCreatePackageRewardCell
UISpeed.OnDeletePackageRewardCell = OnDeletePackageRewardCell
UISpeed.ClearPackageRewardScroll = ClearPackageRewardScroll
UISpeed.TryAddOneClickAcceleration = TryAddOneClickAcceleration
UISpeed.GetOneSpeedUp = GetOneSpeedUp
UISpeed.TryAddOneClickAccelerationBuy = TryAddOneClickAccelerationBuy
UISpeed.RefreshAlHelp = RefreshAlHelp
UISpeed.ReInitLeftTime = ReInitLeftTime
UISpeed.AllianceHelpUpdateSpeedTime = AllianceHelpUpdateSpeedTime
return UISpeed
