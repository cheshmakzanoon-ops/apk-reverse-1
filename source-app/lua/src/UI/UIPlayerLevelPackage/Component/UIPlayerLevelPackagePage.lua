local base = UIBaseContainer
local UIPlayerLevelPackagePage = BaseClass("UIPlayerLevelPackagePage", base)
local Localization = CS.GameEntry.Localization
local UIPlayerLevelPackageRewardItem = require("UI.UIPlayerLevelPackage.Component.UIPlayerLevelPackageRewardItem")
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")
local UIPlayerLevelPackagePageRewardChangeEntranceComponent = require("UI/LWUIPlayerLevelPackageRewardChange/Component/UIPlayerLevelPackagePageRewardChangeEntranceComponent")
local UIPlayerLevelPackagePageRewardChangeBgComponent = require("UI/LWUIPlayerLevelPackageRewardChange/Component/UIPlayerLevelPackagePageRewardChangeBgComponent")
local ResourceManager = CS.GameEntry.Resource
local UICommonHorseLampTMP = require("UI.UICommonTMPHorseRaceLamp.Component.UICommonHorseLampTMP")
local root_path = "Root"
local mainTitleText_path = "Root/Top/GameObject/MainTitleText"
local subTitleText_path = "Root/Top/GameObject/SubTitleText"
local timeContent_path = "Root/Top/TimeContent"
local timeText_path = "Root/Top/TimeContent/TimeText"
local rewardsScrollView_path = "Root/Center/Rewards/RewardsScrollView"
local rewardsScrollViewContent_path = "Root/Center/Rewards/RewardsScrollView/Viewport/Content"
local buyBtn_path = "Root/Center/Unpaid/buyBtn"
local buyBtnText_path = "Root/Center/Unpaid/buyBtn/buyTxt"
local discountValueText_path = "Root/Center/DiscountInfo/Bg/DiscountText"
local giftPack_path = "Root/Center/Unpaid/buyBtn/UIGiftPackagePoint"
local backGround_path = "Root/bg_adv/BackGround"
local foreGround_path = "Root/bg_adv/ForeGround"
local heroSpineContainer_path = "Root/bg_adv/HeroSpineViewport/HeroSpineContainer"
local bg_path = "Root/bg_adv/Bg"
local closeBtn_path = "Root/bg_adv/CloseBtn"
local remainTimeText_path = "Root/Center/RemainPurchaseTimeText"
local reward_content_bg1_path = "Root/Center/Rewards/rewardContentBg1"
local reward_content_bg2_path = "Root/Center/Rewards/rewardContentBg2"
local reward_content_bg3_path = "Root/Center/Rewards/rewardContentBg3"
local reward_content_bg4_path = "Root/Center/Rewards/rewardContentBg4"
local huawen1_path = "Root/Center/bgHuawenContent/huawen1"
local huawen2_path = "Root/Center/bgHuawenContent/huawen2"
local huawen3_path = "Root/Center/bgHuawenContent/huawen3"
local effect1_content_path = "Root/bg_adv/Effect1Content"
local effect2_content_path = "Root/bg_adv/Effect2Content"
local buyConditionText_path = "Root/Center/BuyConditionText"
local unpaid_path = "Root/Center/Unpaid"
local sub_title_extra_text_path = "Root/Center/Container/SubTitleExtraText"
local info_btn_path = "Root/Center/Container/InfoBtn"
local info_tips_path = "Root/Center/Container/InfoBtn/InfoTips"
local TipsContent_path = "Root/Center/Container/InfoBtn/InfoTips/BubbleTipsBtn/InfoTipsText"
local tip_close_btn_path = "Root/Center/Container/InfoBtn/InfoTips/TipCloseBtn"
local title_content = "Root/Top/GameObject"
local defaultSubTitleTextHeight = 204.4

local function GetScrollItem(self, listview, index)
  local rewards = self.rewards
  index = index + 1
  if index < 1 or index > #rewards then
    return nil
  end
  local item = listview:NewListViewItem("RewardItem")
  local script = self.rewardsScrollContent:GetComponent(item.gameObject.name, UIPlayerLevelPackageRewardItem)
  if script == nil then
    NameCount = NameCount + 1
    local nameStr = tostring(NameCount)
    item.gameObject.name = nameStr
    script = self.rewardsScrollContent:AddComponent(UIPlayerLevelPackageRewardItem, nameStr)
  end
  local waitShowTime = 0
  if self.waitOpenAniFinTime and 0 < self.waitOpenAniFinTime then
    waitShowTime = self.waitOpenAniFinTime + index * 0.03
  end
  script:ReInit(rewards[index], self.rechargeId, waitShowTime)
  return item
end

local function ClearScroll(self)
  if self.rewardsScrollView then
    self.rewardsScrollContent:RemoveComponents(UIPlayerLevelPackageRewardItem)
    self.rewardsScrollView:ClearAllItems()
  end
end

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function DestroyHeroSpine(self)
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
  self.curSpinePath = nil
end

local function OnDestroy(self)
  DestroyHeroSpine(self)
  ClearScroll(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIAnimator, root_path)
  self.mainTitleText = self:AddComponent(UIText, mainTitleText_path)
  self.subTitleText = self:AddComponent(UIText, subTitleText_path)
  self.timeContent = self:AddComponent(UIBaseContainer, timeContent_path)
  self.timeText = self:AddComponent(UIText, timeText_path)
  self.buyBtn = self:AddComponent(LWBtnBuyRefundRemind, buyBtn_path)
  self.buyBtn:SetBuyClickAction(function()
    self:OnClickPayBtn()
  end)
  self.buyBtn:SetSafeClickMode(true)
  self.discountValueText = self:AddComponent(UIText, discountValueText_path)
  self.rewardsScrollView = self:AddComponent(UILoopListView2, rewardsScrollView_path)
  self.rewardsScrollView:InitListView(0, function(listview, index)
    return GetScrollItem(self, listview, index)
  end)
  self.dragging = false
  self.hasTellParentBeginDrag = false
  self.rewardsScrollContent = self:AddComponent(UIBaseContainer, rewardsScrollViewContent_path)
  self.rewardsEventTrigger = self:AddComponent(UIEventTrigger, rewardsScrollView_path)
  self.rewardsEventTrigger:OnBeginDrag(function(eventData)
    self.dragging = true
    self.beginDragPositionX = eventData.position.x
    self.hasTellParentBeginDrag = false
    if self.onChildBeginDrag then
      self.onChildBeginDrag(eventData)
    end
  end)
  self.rewardsEventTrigger:OnDrag(function(eventData)
    if self.onChildDrag then
      self.onChildDrag(eventData)
    end
  end)
  self.rewardsEventTrigger:OnEndDrag(function(eventData)
    self.dragging = false
    if self.onChildEndDrag then
      self.onChildEndDrag(eventData)
    end
    if self.hasTellParentBeginDrag and self.onChildEndDrag then
      self.onChildEndDrag(eventData)
    end
    self.hasTellParentBeginDrag = false
  end)
  self.backGround = self:AddComponent(UIRawImage, backGround_path)
  self.foreGround = self:AddComponent(UIRawImage, foreGround_path)
  self.heroSpineContainer = self:AddComponent(UIBaseContainer, heroSpineContainer_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtn:SetOnClick(function()
    self:DoClose()
  end)
  self.remainTimeText = self:AddComponent(UIText, remainTimeText_path)
  self.remainTimeText:SetText("")
  self.reward_content_bg1 = self:AddComponent(UIImage, reward_content_bg1_path)
  self.reward_content_bg2 = self:AddComponent(UIImage, reward_content_bg2_path)
  self.reward_content_bg3 = self:AddComponent(UIImage, reward_content_bg3_path)
  self.reward_content_bg4 = self:AddComponent(UIImage, reward_content_bg4_path)
  self.huawen1 = self:AddComponent(UIImage, huawen1_path)
  self.huawen2 = self:AddComponent(UIImage, huawen2_path)
  self.huawen3 = self:AddComponent(UIImage, huawen3_path)
  self.effect1_content = self:AddComponent(UIBaseContainer, effect1_content_path)
  self.effect2_content = self:AddComponent(UIBaseContainer, effect2_content_path)
  self.unpaidRoot = self:AddComponent(UIBaseContainer, unpaid_path)
  self.textBuyCondition = self:AddComponent(UIText, buyConditionText_path)
  self.textBuyCondition:SetActive(false)
  self.buyFreeBtn = self:AddComponent(UIButton, "Root/Center/Unpaid/buyFreeBtn")
  self.buyFreeBtnBg = self:AddComponent(UIImage, "Root/Center/Unpaid/buyFreeBtn")
  self.buyFreeBtn:SetOnClick(function()
    self:OnClickFreeAndGoldPayBtn()
  end)
  self.buyFreeBtn:SetSafeClickMode(true)
  self.buyFreeBtnText = self:AddComponent(UITextMeshProUGUIEx, "Root/Center/Unpaid/buyFreeBtn/layout/buyFreeBtnText")
  self.buyFreeCostIcon = self:AddComponent(UIImage, "Root/Center/Unpaid/buyFreeBtn/layout/buyFreeCostIcon")
  self.discountIndoNode = self:AddComponent(UIBaseContainer, "Root/Center/DiscountInfo")
  self.sizeFitter = self.buyFreeBtnText.rectTransform:GetComponent(typeof(CS.UnityEngine.UI.ContentSizeFitter))
  self.compRewardChangeBgRoot = self:AddComponent(UIBaseContainer, "Root/RewardChangeBgRoot")
  self.compRewardChangeEntranceRoot = self:AddComponent(UIBaseContainer, "Root/Top/RewardChangeEntranceRoot")
  self.sub_title_extra_text = self:AddComponent(UICommonHorseLampTMP, sub_title_extra_text_path)
  self.moreInfoBtn = self:AddComponent(UIButton, info_btn_path)
  self.moreInfoBtn:SetOnClick(function()
    self:ClickMoreInfoBtn()
  end)
  self.moreInfoTipObj = self:AddComponent(UIBaseContainer, info_tips_path)
  self.moreInfoCloseBtn = self:AddComponent(UIButton, tip_close_btn_path)
  self.moreInfoCloseBtn:SetOnClick(function()
    self:ClickMoreInfoCloseBtn()
  end)
  self.TipsContent = self:AddComponent(UITextMeshProUGUIEx, TipsContent_path)
  self.titleContent = self:AddComponent(UIBaseContainer, title_content)
end

local function ComponentDestroy(self)
  self.buyFreeBtn = nil
  self.buyFreeBtnBg = nil
  self.buyFreeBtnText = nil
  self.buyFreeCostIcon = nil
  self.discountIndoNode = nil
  self.titleContent = nil
  self.mainTitleText = nil
  self.subTitleText = nil
  self.timeContent = nil
  self.timeText = nil
  self.rewardsScrollView = nil
  self.buyBtn = nil
  self.discountValueText = nil
  self.backGround = nil
  self.foreGround = nil
  self.heroSpineContainer = nil
  self.bg = nil
  self.reward_content_bg1 = nil
  self.reward_content_bg2 = nil
  self.reward_content_bg3 = nil
  self.reward_content_bg4 = nil
  self.huawen1 = nil
  self.huawen2 = nil
  self.huawen3 = nil
  self.effect1_content = nil
  self.effect2_content = nil
  self.unpaidRoot = nil
  self.textBuyCondition = nil
  self.sizeFitter = nil
  self.compRewardChangeBgRoot = nil
  self.compRewardChangeEntranceRoot = nil
  self.rewardChangeEntrance = nil
  self.rewardChangeBg = nil
  self.sub_title_extra_text = nil
  self.moreInfoBtn = nil
  self.moreInfoTipObj = nil
  self.moreInfoCloseBtn = nil
  self.TipsContent = nil
end

local function DataDefine(self)
  self.packageInfo = nil
  self.rewards = {}
  self.toggleIndex = nil
  self.nextUpdateTime = nil
  self.hideRedOnce = nil
  self.waitOpenAniFinTime = nil
  self.openAniDelayTimer = nil
  self.effect1Path = nil
  self.effect1Request = nil
  self.effect2Path = nil
  self.effect2Request = nil
  self.showData = nil
  self.packageServerId = nil
end

local function DataDestroy(self)
  self.packageInfo = nil
  self.rewards = nil
  self.toggleIndex = nil
  self.nextUpdateTime = nil
  self:CloseOpenAniTimer()
  self.waitOpenAniFinTime = nil
  self.openAniDelayTimer = nil
  self:DeleteEffect1Content()
  self:DeleteEffect2Content()
  self.effect1Path = nil
  self.effect1Request = nil
  self.effect2Path = nil
  self.effect2Request = nil
  self.showData = nil
  self.packageServerId = nil
end

local function RefreshPackageData(self)
  local packages = GiftPackageData.GetAllAvailablePackageByRechargeId(self.rechargeId)
  if not table.IsNullOrEmpty(packages) then
    self.packageInfo = packages[1]
  else
    self.packageInfo = nil
  end
  self.showData = DataCenter.RechargeManager:GetGiftShowDataById(self.rechargeId)
  if self.packageInfo == nil then
    return
  end
  if self.packageInfo._serverData then
    self.packageServerId = self.packageInfo._serverData.id
  else
    self.packageServerId = nil
  end
  local template = DataCenter.ExchangeSpecialManager:GetTemplateContainPackageId(self.packageServerId)
  self.isPyramidPackage = template ~= nil
end

local function RefreshPackageShowInfo(self)
  if not self.packageInfo then
    return
  end
  self.mainTitleText:SetText(self.packageInfo:getNameText())
  self.subTitleText:SetText(self.packageInfo:getDescText())
  self.discountValueText:SetText(self.packageInfo:getPercent())
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.titleContent.transform)
end

local function RefreshAll(self)
  RefreshPackageData(self)
  if not self.packageInfo then
    self.buyBtn:SetActive(false)
    return
  end
  if not self.packageInfo:isTimeValid() then
    self.buyBtn:SetActive(false)
    return
  end
  self.timeContent:SetActive(self.packageInfo._tableData.time_type ~= 8)
  self.buyBtn:SetActive(true)
  self.rewardStyle = 0
  if not self.showData then
    self.backGround:SetActive(false)
    self.foreGround:SetActive(false)
    DestroyHeroSpine(self)
  else
    local bgPath = self.showData.banner_bg_new
    if not string.IsNullOrEmpty(bgPath) then
      self.backGround:SetActive(true)
      self.backGround:LoadSpriteAsync(string.format(LoadPath.UIPopPackBackGround, bgPath))
      self.backGround:SetSizeDeltaXY(self.showData.bg_pic_init_size[1] or 700, self.showData.bg_pic_init_size[2] or 316)
    else
      self.backGround:SetActive(false)
    end
    local foreGroundType = tonumber(self.showData.banner_pic_new[1]) or 0
    if foreGroundType then
      if foreGroundType == 1 then
        self.foreGround:SetActive(true)
        local foreGroundPath = self.showData.banner_pic_new[2] or ""
        self.foreGround:LoadSpriteAsync(string.format(LoadPath.UIPopPackForeGround, foreGroundPath))
        DestroyHeroSpine(self)
        self.foreGround.rectTransform:Set_sizeDelta(self.showData.banner_pic_init_size[1] or 700, self.showData.banner_pic_init_size[2] or 316)
      elseif foreGroundType == 2 then
        self.foreGround:SetActive(false)
        local spinePath = self.showData.banner_pic_new[2] or ""
        if not string.IsNullOrEmpty(spinePath) then
          if self.curSpinePath == nil or self.curSpinePath ~= nil and self.curSpinePath ~= spinePath then
            DestroyHeroSpine(self)
            local request = ResourceManager:InstantiateAsync(spinePath)
            self.heroSpineLoadRequest = request
            request:completed("+", function()
              if request.isError or IsNull(request.gameObject) then
                self.heroSpineLoadRequest = nil
                return
              end
              local obj = request.gameObject
              obj:SetActive(true)
              obj.transform:SetParent(self.heroSpineContainer.transform)
              obj.transform.localPosition = Vector3.New(0, 0, 0)
              obj.transform.localScale = Vector3.New(CommonUtil.IsArabicAutoMirrorOpen() and -1 or 1, 1, 1)
            end)
            self.curSpinePath = spinePath
          end
        else
          DestroyHeroSpine(self)
        end
      else
        self.foreGround:SetActive(false)
        DestroyHeroSpine(self)
      end
    else
      self.foreGround:SetActive(false)
      DestroyHeroSpine(self)
    end
    self.rewardStyle = self.showData.board_color
    if self.showData.resource_config1_list and #self.showData.resource_config1_list == 5 then
      self.bg:LoadSprite(string.format(LoadPath.UIPlayerLevelPackage, self.showData.resource_config1_list[5]))
      self.reward_content_bg1:LoadSprite(string.format(LoadPath.UIPlayerLevelPackage, self.showData.resource_config1_list[1]))
      self.reward_content_bg2:LoadSprite(string.format(LoadPath.UIPlayerLevelPackage, self.showData.resource_config1_list[3]))
      self.reward_content_bg3:LoadSprite(string.format(LoadPath.UIPlayerLevelPackage, self.showData.resource_config1_list[2]))
      self.reward_content_bg4:LoadSprite(string.format(LoadPath.UIPlayerLevelPackage, self.showData.resource_config1_list[4]))
    end
    if self.showData.resource_config2_list and #self.showData.resource_config2_list == 2 and #self.showData.resource_config2_list[2] == 4 then
      self.huawen1:SetColorRGBA255(self.showData.resource_config2_list[2][1], self.showData.resource_config2_list[2][2], self.showData.resource_config2_list[2][3], self.showData.resource_config2_list[2][4])
      self.huawen2:SetColorRGBA255(self.showData.resource_config2_list[2][1], self.showData.resource_config2_list[2][2], self.showData.resource_config2_list[2][3], self.showData.resource_config2_list[2][4])
      self.huawen3:SetColorRGBA255(self.showData.resource_config2_list[2][1], self.showData.resource_config2_list[2][2], self.showData.resource_config2_list[2][3], self.showData.resource_config2_list[2][4])
    end
    self:ReloadEffectContent(self.showData.bg_effect_name, self.showData.for_effect_name)
  end
  self:RefreshRewards()
  if self.isPyramidPackage then
    local template = DataCenter.ExchangeSpecialManager:GetTemplateContainPackageId(self.packageServerId)
    if not template then
      return
    end
    DataCenter.ExchangeSpecialManager:RequestExchangeSpecialDecorationReduce(template.id, false)
  end
  self:RefreshPyramidPackageShow()
  RefreshPackageShowInfo(self)
  self:RefreshPayState()
  self:RefreshRewardChange()
end

function UIPlayerLevelPackagePage:RefreshPyramidPackageShow()
  self.moreInfoTipObj:SetActive(false)
  if not self.packageInfo or not self.isPyramidPackage then
    self.subTitleText:SetSizeDeltaY(defaultSubTitleTextHeight)
    self.sub_title_extra_text:SetActive(false)
    self.moreInfoBtn:SetActive(false)
    return
  end
  self.sub_title_extra_text:SetActive(self.isPyramidPackage)
  local template = DataCenter.ExchangeSpecialManager:GetTemplateContainPackageId(self.packageServerId)
  if template then
    local subTitleStr = Localization:GetString(template.decoration_des1)
    if CommonUtil.IsArabicAutoMirrorOpen() then
      self.sub_title_extra_text:SetTextWithLength(subTitleStr, 592, NoRollingAlignment.Right)
    else
      self.sub_title_extra_text:SetTextWithLength(subTitleStr, 592, NoRollingAlignment.Left)
    end
  end
  self.TipsContent:SetText("")
  self.moreInfoBtn:SetActive(self.isPyramidPackage)
  if self.isPyramidPackage then
    self.subTitleText:SetSizeDeltaY(117.9)
  else
    self.subTitleText:SetSizeDeltaY(defaultSubTitleTextHeight)
  end
end

function UIPlayerLevelPackagePage:RefreshPyramidPackageTipsAndReward(msg)
  if msg == nil then
    return
  end
  if not self.isPyramidPackage then
    return
  end
  local template = DataCenter.ExchangeSpecialManager:GetTemplateContainPackageId(self.packageServerId)
  if not template then
    return
  end
  if tostring(msg.id) ~= tostring(template.id) then
    return
  end
  local tipText = DataCenter.ExchangeSpecialManager:GetSpeedInfoTipText(msg.id)
  self.TipsContent:SetText(tipText)
  for i = 1, #self.rewards do
    if self.rewards[i].isShowExtraFlag then
      table.remove(self.rewards, i)
      break
    end
  end
  local extraReward = {}
  extraReward.id = msg.itemId
  extraReward.itemId = tonumber(msg.itemId)
  extraReward.count = msg.itemNum
  extraReward.rewardType = 7
  extraReward.isShowExtraFlag = true
  if extraReward.id ~= 0 and extraReward.count > 0 then
    table.insert(self.rewards, extraReward)
  end
  if #self.rewards > 0 then
    self.rewardsScrollView:SetListItemCount(#self.rewards, false, false)
    self.rewardsScrollView:RefreshAllShownItem()
  end
end

local function RefreshRewards(self)
  local buyType = self.packageInfo:GetBuyType()
  if buyType == GiftPackageBuyType.Money then
    self.rewards = self.packageInfo:getItems(true)
  else
    self.rewards = self.packageInfo:getFreeAndGoldBuyReward()
  end
  if self.isPyramidPackage then
    ClearScroll(self)
  elseif #self.rewards > 0 then
    self.rewardsScrollView:SetListItemCount(#self.rewards, false, false)
    self.rewardsScrollView:RefreshAllShownItem()
  end
end

local function Update1000MS(self)
  if not self.packageInfo then
    return
  end
  local countDown = self.packageInfo:getCountdown() / 1000
  local countDownText = UITimeManager:GetInstance():SecondToFmtString(countDown)
  self.timeText:SetText(countDownText)
  if countDown <= 1500 then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.nextUpdateTime and curTime >= self.nextUpdateTime then
    return
  end
end

local function RefreshPayState(self)
  if self.packageInfo then
    local buyType = self.packageInfo:GetBuyType()
    local inconsistentConditions
    if self.packageInfo.getInconsistentBuyConditions then
      inconsistentConditions = self.packageInfo:getInconsistentBuyConditions()
    end
    local isBuyConditionOk = table.IsNullOrEmpty(inconsistentConditions)
    if not isBuyConditionOk then
      self.unpaidRoot:SetActive(false)
      self.remainTimeText:SetActive(false)
      self.textBuyCondition:SetActive(true)
      self.textBuyCondition:SetText(DataCenter.RewardManager:ConvertBuyConditionToText(inconsistentConditions[1]))
    else
      self.unpaidRoot:SetActive(true)
      self.remainTimeText:SetActive(true)
      self.textBuyCondition:SetActive(false)
    end
    if buyType == GiftPackageBuyType.Money then
      self.buyBtn:Init(self.packageInfo)
      self.buyBtn:RefreshPoint()
    else
      if buyType == GiftPackageBuyType.PlayerGold then
        local resourceType, num = self.packageInfo:GetResourceBuyCostTypeAndNum()
        if resourceType ~= nil then
          self.buyFreeCostIcon:LoadSprite(CommonUtil.GetResOrItemIcon(resourceType))
          self.buyFreeBtnText:SetText(num)
        else
          Logger.LogError("\231\173\150\229\136\146\233\133\141\233\148\153\228\186\134\239\188\129  exchangeId:" .. self.packageInfo._tableData.id)
        end
        self.buyFreeBtnBg:LoadSprite("Assets/Main/Sprites/UI/UIPlayerLevelPackage/cfm_pailian_anniu.png")
        self.sizeFitter.enabled = true
        self.buyFreeBtnText:SetColor(Color.New(0.5882352941176471, 0.2823529411764706, 0.07450980392156863, 1))
      else
        self.buyFreeBtnText:SetLocalText("2010805")
        self.buyFreeBtnBg:LoadSprite("Assets/Main/Sprites/UI/UIPlayerLevelPackage/lyt_dengjilibao_fhj_lvanniu.png")
        self.sizeFitter.enabled = false
        self.buyFreeBtnText:SetSizeDeltaXY(300, 100)
        self.buyFreeBtnText:SetColor(Color.New(0, 0.41568627450980394, 0.1843137254901961, 1))
      end
      self.buyFreeCostIcon:SetActive(buyType == GiftPackageBuyType.PlayerGold)
      self.buyBtn:RefreshPoint()
    end
    self.discountIndoNode:SetActive(buyType == GiftPackageBuyType.Money)
    self.buyBtn:SetActive(buyType == GiftPackageBuyType.Money)
    self.buyFreeBtn:SetActive(buyType ~= GiftPackageBuyType.Money)
    self.remainTimeText:SetLocalText("getpackagetime", self.packageInfo:getBuyTimes() - self.packageInfo:getHasGetCount())
  else
    self.remainTimeText:SetText("")
  end
end

local function OnClickPayBtn(self)
  if self.packageInfo and self.packageInfo:getID() ~= -1 then
    if self.sourceType == RechargeEntryType.PopRechargeInStore then
      DataCenter.PayManager:CallPayment(self.packageInfo, UIWindowNames.UIPlayerLevelPackage)
    else
      self.view.ctrl:BuyGift(self.packageInfo)
    end
  end
end

function UIPlayerLevelPackagePage:OnClickFreeAndGoldPayBtn()
  if self.packageInfo and self.packageInfo:getID() ~= -1 then
    local template = self.packageInfo._tableData
    SFSNetwork.SendMessage(MsgDefines.ExchangeDiamondBuy, tonumber(template.id))
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.PyramidReduceTips, self.RefreshPyramidPackageTipsAndReward)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.PyramidReduceTips, self.RefreshPyramidPackageTipsAndReward)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
  self.dragging = false
  self.hasTellParentBeginDrag = false
end

local function SetData(self, rechargeId)
  self.rechargeId = rechargeId
  self:CloseOpenAniTimer()
  local isHaveAni = false
  isHaveAni, self.waitOpenAniFinTime = self.root:PlayAnimationReturnTime("Eff_UIPlayerLevelPackagePage_In")
  if self.waitOpenAniFinTime and self.waitOpenAniFinTime > 0 then
    self.waitOpenAniFinTime = self.waitOpenAniFinTime / 3 * 2
    self.openAniDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.waitOpenAniFinTime = 0
      self:CloseOpenAniTimer()
    end, self.waitOpenAniFinTime)
  end
  self:RefreshAll()
end

local function CloseOpenAniTimer(self)
  if self.openAniDelayTimer then
    self.openAniDelayTimer:Stop()
    self.openAniDelayTimer = nil
  end
end

local function DeleteEffect1Content(self)
  if self.effect1Request ~= nil then
    self.effect1Request:Destroy()
    self.effect1Request = nil
  end
  self.effect1Path = nil
end

local function DeleteEffect2Content(self)
  if self.effect2Request ~= nil then
    self.effect2Request:Destroy()
    self.effect2Request = nil
  end
  self.effect2Path = nil
end

local function ReloadEffectContent(self, effect1Path, effect2Path)
  if self.effect1Path ~= effect1Path then
    self:DeleteEffect1Content()
    self.effect1Path = effect1Path
    if not string.IsNullOrEmpty(self.effect1Path) then
      self.effect1Request = ResourceManager:InstantiateAsync(self.effect1Path)
      self.effect1Request:completed("+", function(request)
        if request.isError or request.gameObject == nil then
          return
        end
        local obj = request.gameObject
        CommonUtil.CallAutoArabicMirrorManually(request)
        local parent = self.effect1_content
        obj:SetActive(true)
        local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
        if rectTransform ~= nil then
          rectTransform:SetParent(parent.transform)
          rectTransform:Set_localScale(1, 1, 1)
          rectTransform:Set_anchoredPosition(0, 0, 0)
        end
      end)
    end
  end
  if self.effect2Path ~= effect2Path then
    self:DeleteEffect2Content()
    self.effect2Path = effect2Path
    if not string.IsNullOrEmpty(self.effect2Path) then
      self.effect2Request = ResourceManager:InstantiateAsync(self.effect2Path)
      self.effect2Request:completed("+", function(request)
        if request.isError or request.gameObject == nil then
          return
        end
        local obj = request.gameObject
        local parent = self.effect2_content
        obj:SetActive(true)
        local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
        if rectTransform ~= nil then
          rectTransform:SetParent(parent.transform)
          rectTransform:Set_localScale(1, 1, 1)
          rectTransform:Set_anchoredPosition(0, 0, 0)
        end
      end)
    end
  end
end

function UIPlayerLevelPackagePage:RefreshRewardChange()
  local isShow = false
  if DataCenter.GiftPackageChangePreviewManager:IsFunctionOn() and self.packageInfo ~= nil then
    local curTemplate = DataCenter.GiftPackageChangePreviewManager:GetRewardChangeShowDataByGiftInfo(self.packageInfo)
    isShow = curTemplate ~= nil
  end
  if isShow then
    if self.rewardChangeEntranceReq == nil then
      self.rewardChangeEntranceReq = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIPlayerLevelPackageRewardChange/UIPlayerLevelPackagePageRewardChangeEntrance.prefab", function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.compRewardChangeEntranceRoot.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:Set_localPosition(0, 0, 0)
        self.rewardChangeEntrance = self.compRewardChangeEntranceRoot:AddComponent(UIPlayerLevelPackagePageRewardChangeEntranceComponent, go.name)
        self.rewardChangeEntrance:ReInit(self.packageInfo)
      end)
    end
    if self.rewardChangeBgReq == nil then
      self.rewardChangeBgReq = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWUIPlayerLevelPackageRewardChange/UIPlayerLevelPackagePageRewardChangeBg2.prefab", function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.compRewardChangeBgRoot.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:Set_localPosition(0, 0, 0)
        self.rewardChangeBg = self.compRewardChangeBgRoot:AddComponent(UIPlayerLevelPackagePageRewardChangeBgComponent, go.name)
        self.rewardChangeBg:ReInit(self.packageInfo)
      end)
    end
  else
    if self.rewardChangeEntrance then
      self.compRewardChangeEntranceRoot:RemoveComponents(UIPlayerLevelPackagePageRewardChangeEntranceComponent)
    end
    if self.rewardChangeBg then
      self.compRewardChangeBgRoot:RemoveComponents(UIPlayerLevelPackagePageRewardChangeBgComponent)
    end
    if self.rewardChangeEntranceReq ~= nil then
      self.rewardChangeEntranceReq:Destroy()
      self.rewardChangeEntranceReq = nil
      self.rewardChangeEntrance = nil
    end
    if self.rewardChangeBgReq ~= nil then
      self.rewardChangeBgReq:Destroy()
      self.rewardChangeBgReq = nil
      self.rewardChangeBg = nil
    end
  end
end

function UIPlayerLevelPackagePage:ClickMoreInfoBtn()
  if not self.moreInfoTipObj then
    return
  end
  if not self.moreInfoTipObj.activeSelf then
    local template = DataCenter.ExchangeSpecialManager:GetTemplateContainPackageId(self.packageServerId)
    if template then
      local tipText = DataCenter.ExchangeSpecialManager:GetSpeedInfoTipText(template.id)
      self.TipsContent:SetText(tipText)
    end
  end
  self.moreInfoTipObj:SetActive(not self.moreInfoTipObj.activeSelf)
end

function UIPlayerLevelPackagePage:ClickMoreInfoCloseBtn()
  if not self.moreInfoTipObj then
    return
  end
  self.moreInfoTipObj:SetActive(false)
end

function UIPlayerLevelPackagePage:Init(sourceType, isShowCloseBtn, onChildBeginDrag, onChildDrag, onChildEndDrag, onCloseCallback)
  self.sourceType = sourceType
  self.closeBtn:SetActive(isShowCloseBtn)
  self.onChildBeginDrag = onChildBeginDrag
  self.onChildDrag = onChildDrag
  self.onChildEndDrag = onChildEndDrag
  self.onCloseCallback = onCloseCallback
end

function UIPlayerLevelPackagePage:DoClose()
  if self.onCloseCallback then
    self.onCloseCallback(self.rechargeId)
  end
  self.view.ctrl:CloseSelf()
end

UIPlayerLevelPackagePage.OnCreate = OnCreate
UIPlayerLevelPackagePage.OnDestroy = OnDestroy
UIPlayerLevelPackagePage.OnAddListener = OnAddListener
UIPlayerLevelPackagePage.OnRemoveListener = OnRemoveListener
UIPlayerLevelPackagePage.ComponentDefine = ComponentDefine
UIPlayerLevelPackagePage.ComponentDestroy = ComponentDestroy
UIPlayerLevelPackagePage.DataDefine = DataDefine
UIPlayerLevelPackagePage.DataDestroy = DataDestroy
UIPlayerLevelPackagePage.RefreshAll = RefreshAll
UIPlayerLevelPackagePage.RefreshRewards = RefreshRewards
UIPlayerLevelPackagePage.RefreshPayState = RefreshPayState
UIPlayerLevelPackagePage.OnClickPayBtn = OnClickPayBtn
UIPlayerLevelPackagePage.Update1000MS = Update1000MS
UIPlayerLevelPackagePage.OnEnable = OnEnable
UIPlayerLevelPackagePage.OnDisable = OnDisable
UIPlayerLevelPackagePage.RefreshPackageData = RefreshPackageData
UIPlayerLevelPackagePage.RefreshPackageShowInfo = RefreshPackageShowInfo
UIPlayerLevelPackagePage.ClearScroll = ClearScroll
UIPlayerLevelPackagePage.SetData = SetData
UIPlayerLevelPackagePage.CloseOpenAniTimer = CloseOpenAniTimer
UIPlayerLevelPackagePage.DeleteEffect1Content = DeleteEffect1Content
UIPlayerLevelPackagePage.DeleteEffect2Content = DeleteEffect2Content
UIPlayerLevelPackagePage.ReloadEffectContent = ReloadEffectContent
return UIPlayerLevelPackagePage
