local HeroMonthCardMain = BaseClass("HeroMonthCardMain", UIBaseView)
local ResourceManager = CS.GameEntry.Resource
local base = UIBaseView
local HeroMonthCardItem = require("UI.UIGiftPackage.Component.HeroMonthCard.HeroMonthCardItem")
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")
local month_card_name_path = "bookBg/month_card_name"
local tip_path = "bookBg/tip"
local scroll_view_path = "bookBg/scroll_view"
local time_text_path = "bookBg/month_card_name/timeBg/time_text"
local left_text_path = "bookBg/month_card_name/left_text_bg/left_text"
local left_text_bg_path = "bookBg/month_card_name/left_text_bg"
local buy_tip_path = "bookBg/buy_tipBg/buy_tip"
local buy_btn_path = "bookBg/buy_btn"
local buy_btn_text_path = "bookBg/buy_btn/buy_btn_text"
local package_reward_path = "bookBg/package/packageIcon"
local tipBtn_path = "bookBg/tipBtn"
local package_txt_path = "bookBg/package/package_txt"
local have_time_text_path = "bookBg/have_time_text"
local heroSpineContainerPath = "bookBg/HeroSpineContainerMask/HeroSpineContainer"
local u_i_gift_package_point_path = "bookBg/buy_btn/UIGiftPackagePoint"
local u_i_common_res_item_path = "bookBg/rewardShowContent/UICommonResItem"
local reward_content_path = "bookBg/rewardShowContent/rewardContent"
local bg_path = "bg"
local banner_raw_image_path = "bookBg/BannerRawImage"
local buy_tips_path = "bookBg/buyTips"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshHeroMonthCardAll, self.DoWhenDataBack)
  self:AddUIListener(EventId.OnUnDelayPassDay, self.OnPassDay)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshHeroMonthCardAll, self.DoWhenDataBack)
  self:RemoveUIListener(EventId.OnUnDelayPassDay, self.OnPassDay)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.month_card_name = self:AddComponent(UIText, month_card_name_path)
  self.tip = self:AddComponent(UIText, tip_path)
  self.tip:SetLocalText(320358)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.time_text = self:AddComponent(UIText, time_text_path)
  self.left_text = self:AddComponent(UIText, left_text_path)
  self.left_text:SetText("")
  self.buy_tip = self:AddComponent(UIText, buy_tip_path)
  self.left_text_bg = self:AddComponent(UIBaseContainer, left_text_bg_path)
  self.buy_btn = self:AddComponent(LWBtnBuyRefundRemind, buy_btn_path)
  self.buy_btn:SetBuyClickAction(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBuyClick()
  end)
  self.package_reward = self:AddComponent(UIButton, package_reward_path)
  self.package_reward:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnRewardPreviewBtnClick()
  end)
  self.tipBtn = self:AddComponent(UIButton, tipBtn_path)
  self.tipBtn:SetOnClick(function()
    self:OnTipBtnClick()
  end)
  self.package_txt = self:AddComponent(UIText, package_txt_path)
  self.package_txt:SetLocalText(2800122)
  self.have_time_text = self:AddComponent(UIText, have_time_text_path)
  self.have_time_text:SetText("")
  self.heroSpineContainer = self:AddComponent(UIBaseContainer, heroSpineContainerPath)
  self.u_i_common_res_item = self:AddComponent(UICanvasGroup, u_i_common_res_item_path)
  self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.u_i_common_res_item:SetActive(false)
  self.u_i_common_res_item.gameObject:GameObjectCreatePool()
  self.u_i_common_res_item_list = {}
  self.bg = self:AddComponent(UIImage, bg_path)
  self.banner_raw_image = self:AddComponent(UIRawImage, banner_raw_image_path)
  self.buy_tips = self:AddComponent(UITextMeshProUGUIEx, buy_tips_path)
end

local function ComponentDestroy(self)
  self:ClearAllItem()
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self:ClearScroll()
  self.tipBtn = nil
  self.u_i_common_res_item = nil
  self.reward_content = nil
  self.bg = nil
  self.banner_raw_image = nil
  self.buy_tips = nil
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function DoWhenDataBack(self)
  self:SetData(self.actId, false)
end

local function OnPassDay(self)
  self:SetData(self.actId, false)
end

local function SetData(self, actId, autoToCanReceive)
  self.actId = actId
  if autoToCanReceive == nil then
    autoToCanReceive = true
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
  if self.activityInfo == nil then
    return
  end
  local groupId = self.activityInfo.subType
  self.activityId = DataCenter.HeroMonthCardManager:GetActivityIdByGroupId(groupId)
  if self.activityId == nil or self.activityId == 0 then
    return
  end
  DataCenter.HeroMonthCardManager:SetNewFlag(self.activityId)
  local data = DataCenter.HeroMonthCardManager:GetHeroMonthCardInfo(self.activityId)
  if data == nil then
    DataCenter.HeroMonthCardManager:GetDataFromServer()
    return
  end
  local template = DataCenter.HeroMonthCardManager:GetTemplate(data.activityId)
  local timeStr
  timeStr = UITimeManager:GetInstance():TimeStampToDayForLocal(data.startTime) .. "-" .. UITimeManager:GetInstance():TimeStampToDayForLocal(data.endTime - 1000)
  self.time_text:SetText(timeStr)
  self.curRechargeId = data.exchangeId
  local packageInfo = GiftPackageData.get(self.curRechargeId)
  self.month_card_name:SetLocalText(template.name)
  local flag = data.buy == BuyFlag.BUY
  self.have_time_text:SetActive(flag)
  if flag then
    self.buy_btn:SetActive(false)
    self.buy_tips:SetActive(false)
  elseif packageInfo ~= nil then
    local commonBuyConditions = DataCenter.RewardManager:ParseBuyConditionStr(packageInfo:getBuyCondition())
    local inconsistentConditions = DataCenter.RewardManager:GetInconsistentBuyConditions(commonBuyConditions)
    if not table.IsNullOrEmpty(inconsistentConditions) then
      local tips = DataCenter.RewardManager:ConvertBuyConditionToText(inconsistentConditions[1])
      self.buy_btn:SetActive(false)
      self.buy_tips:SetActive(true)
      self.buy_tips:SetText(tips)
    else
      self.buy_btn:SetActive(true)
      self.buy_tips:SetActive(false)
    end
  else
    self.buy_btn:SetActive(false)
    self.buy_tips:SetActive(false)
  end
  self:ClearScroll(self)
  self.rewardList = data.rewardArr
  if 0 < #self.rewardList then
    self.scroll_view:SetTotalCount(#self.rewardList)
    self.scroll_view:RefillCells()
    if autoToCanReceive then
      local index = 0
      local nextCanGetIndex = 0
      for _, v in ipairs(self.rewardList) do
        local rewardState = DataCenter.HeroMonthCardManager:GetRewardState(self.activityId, v)
        if rewardState == HeroMonthCardRewardState.REWARD_STATE_CAN_RECEIVE then
          index = v.day
          break
        end
        if rewardState == HeroMonthCardRewardState.REWARD_STATE_UNRECEIVED then
          nextCanGetIndex = v.day
          break
        end
      end
      local jumpIndex = 0
      if 0 < index then
        jumpIndex = index
      elseif 0 < nextCanGetIndex then
        jumpIndex = nextCanGetIndex
      end
      if 15 < jumpIndex then
        do
          local moveNum = math.floor(jumpIndex / 5)
          local speed = moveNum * 160 * 2
          self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
            if self.delayTimer then
              self.delayTimer:Stop()
              self.delayTimer = nil
            end
            self.scroll_view:ScrollToCell(jumpIndex, speed)
          end, 0.01)
        end
      end
    end
  end
  if flag then
    self.buy_btn:SetPriceText(Localization:GetString(280124))
  elseif packageInfo ~= nil then
    local strPrice = DataCenter.PayManager:GetDollarText(packageInfo:getPrice(), packageInfo:getProductID())
    self.buy_btn:Init(packageInfo)
    self.buy_btn:RefreshPoint()
  end
  self.buy_tip:SetText(string.format("%s%%", tostring(template.sale_num)))
  local spinePath = template.hero_pic
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
  if not string.IsNullOrEmpty(spinePath) then
    local request = ResourceManager:InstantiateAsync(spinePath)
    self.heroSpineLoadRequest = request
    request:completed("+", function()
      if request.isError or request.gameObject == nil then
        self.heroSpineLoadRequest = nil
        return
      end
      request.gameObject:SetActive(true)
      local rectTransform = request.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
      if rectTransform ~= nil then
        rectTransform:SetParent(self.heroSpineContainer.transform)
        rectTransform:Set_localScale(0.5, 0.5, 1)
        rectTransform:Set_anchoredPosition(150, 170, 0)
      end
    end)
  end
  self:OnRewardShowContentRefresh()
end

function HeroMonthCardMain:SetBuyDiamondViewType(buyDiamondViewType)
  if self.activityId == nil or self.activityId == 0 then
    return
  end
  local data = DataCenter.HeroMonthCardManager:GetHeroMonthCardInfo(self.activityId)
  if data == nil then
    return
  end
  local template = DataCenter.HeroMonthCardManager:GetTemplate(data.activityId)
  if template == nil then
    return
  end
  if buyDiamondViewType == BuyDiamondViewType.Normal then
    if not string.IsNullOrEmpty(template.interface_banner) then
      self.banner_raw_image:LoadSprite(string.format(LoadPath.HeroMonthCardNewTexturePath, template.interface_banner))
      self.banner_raw_image:SetNativeSize()
    end
    if not string.IsNullOrEmpty(template.bg) then
      self.bg:LoadSprite(string.format(LoadPath.HeroMonthCardSpritePath, template.bg))
    end
  elseif buyDiamondViewType == BuyDiamondViewType.PopUp then
    if not string.IsNullOrEmpty(template.banner) then
      self.banner_raw_image:LoadSprite(string.format(LoadPath.HeroMonthCardNewTexturePath, template.banner))
      self.banner_raw_image:SetNativeSize()
    end
    DataCenter.HeroMonthCardManager:SetIsHavePop(self.activityId)
  end
end

function HeroMonthCardMain:OnRewardShowContentRefresh()
  self.showRewardData = {}
  local packageInfo = GiftPackageData.get(self.curRechargeId)
  if packageInfo then
    self.showRewardData = packageInfo:getItems(true)
  end
  if self.showRewardData and #self.showRewardData > 0 then
    for i, v in ipairs(self.showRewardData) do
      if self.u_i_common_res_item_list[i] == nil then
        local showIndex = "Item" .. i
        local item = self.u_i_common_res_item.gameObject:GameObjectSpawn(self.reward_content.transform)
        item.name = showIndex
        local obj = self.reward_content:AddComponent(UICommonResItem, item.name)
        self.u_i_common_res_item_list[i] = obj
      end
      self.u_i_common_res_item_list[i]:SetActive(true)
      self.u_i_common_res_item_list[i]:ReInit(v)
    end
    for i = #self.showRewardData + 1, #self.u_i_common_res_item_list do
      self.u_i_common_res_item_list[i]:SetActive(false)
    end
  end
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(HeroMonthCardItem, itemObj)
  local numPerLine = self.scroll_view.unity_scroll_view.m_ContentConstraintCount
  local showLine = index ~= table.count(self.rewardList) and math.fmod(index, numPerLine) ~= 0
  local day = self.rewardList[index].day
  cellItem:SetItem(self.activityId, day, showLine)
end

local function OnItemMoveOut(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, HeroMonthCardItem)
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(HeroMonthCardItem)
end

local function OnBuyClick(self)
  local packageInfo = GiftPackageData.get(self.curRechargeId)
  if packageInfo ~= nil then
    DataCenter.PayManager:BuyGift(packageInfo)
  end
end

local function Update1000MS(self)
  local data = DataCenter.HeroMonthCardManager:GetHeroMonthCardInfo(self.activityId)
  local leftTime = 0
  if data ~= nil then
    local now = UITimeManager:GetInstance():GetServerTime()
    leftTime = data.endTime - now
  end
  if leftTime < 1 then
    self.left_text:SetText("")
    self.have_time_text:SetText("")
  else
    local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    self.left_text:SetText(countDownTimeStr)
    self.have_time_text:SetText(UITimeManager:GetInstance():MillisionSecToWeekCardFormat(leftTime))
  end
end

local function OnRewardPreviewBtnClick(self)
  local param = UIPersonalArmsRewardTipView.ParamDataClass.New()
  param.position = self.package_reward.transform.position
  param.deltaX = 10
  param.dir = CommonUtil.IsArabicAutoMirrorOpen() and UIPersonalArmsRewardTipView.Direction.RIGHT or UIPersonalArmsRewardTipView.Direction.LEFT
  param.rewardList = self:GetShowRewardData()
  param.title = "2800118"
  param.titleFontSize = 28
  param.titleAlignment = CS.TMPro.TextAlignmentOptions.MidlineLeft
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsRewardTip, {anim = false}, param)
end

local function OnTipBtnClick(self)
  local data = DataCenter.HeroMonthCardManager:GetHeroMonthCardInfo(self.activityId)
  if data == nil then
    return
  end
  local template = DataCenter.HeroMonthCardManager:GetTemplate(data.activityId)
  local param = {}
  param.activityRulesStr = Localization:GetString(template.description)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function HeroMonthCardMain:GetShowRewardData()
  local sortList = {}
  local showList = {}
  local allReward = DataCenter.HeroMonthCardManager:GetAllReward(self.activityId)
  if allReward ~= nil and table.count(allReward) > 0 then
    for k1, v1 in pairs(allReward) do
      local rank = ItemColor.WHITE
      if v1.rewardType == RewardType.GOODS then
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(v1.itemId)
        if goods ~= nil then
          rank = goods.color
        end
      end
      local data = {rewardData = v1, rank = rank}
      table.insert(sortList, data)
    end
    table.sort(sortList, function(a, b)
      return a.rank > b.rank
    end)
    for k, v in ipairs(sortList) do
      table.insert(showList, v.rewardData)
    end
  end
  return showList
end

function HeroMonthCardMain:ClearAllItem()
  self.reward_content:RemoveComponents(UICommonResItem)
  for _, v in ipairs(self.reward_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.u_i_common_res_item.gameObject:GameObjectRecycleAll()
  self.u_i_common_res_item_list = {}
end

HeroMonthCardMain.OnCreate = OnCreate
HeroMonthCardMain.OnDestroy = OnDestroy
HeroMonthCardMain.OnAddListener = OnAddListener
HeroMonthCardMain.OnRemoveListener = OnRemoveListener
HeroMonthCardMain.ComponentDefine = ComponentDefine
HeroMonthCardMain.ComponentDestroy = ComponentDestroy
HeroMonthCardMain.DataDefine = DataDefine
HeroMonthCardMain.DataDestroy = DataDestroy
HeroMonthCardMain.SetData = SetData
HeroMonthCardMain.OnItemMoveIn = OnItemMoveIn
HeroMonthCardMain.OnItemMoveOut = OnItemMoveOut
HeroMonthCardMain.ClearScroll = ClearScroll
HeroMonthCardMain.DoWhenDataBack = DoWhenDataBack
HeroMonthCardMain.OnBuyClick = OnBuyClick
HeroMonthCardMain.Update1000MS = Update1000MS
HeroMonthCardMain.OnRewardPreviewBtnClick = OnRewardPreviewBtnClick
HeroMonthCardMain.OnTipBtnClick = OnTipBtnClick
HeroMonthCardMain.OnPassDay = OnPassDay
return HeroMonthCardMain
