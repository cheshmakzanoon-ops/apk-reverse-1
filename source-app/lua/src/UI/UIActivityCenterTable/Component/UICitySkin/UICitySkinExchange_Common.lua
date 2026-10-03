local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UICitySkinExchange_Common = BaseClass("UICitySkinExchange_Common", base)
local Localization = CS.GameEntry.Localization
local UICitySkinExchangeItem = require("UI.UIActivityCenterTable.Component.UICitySkin.UICitySkinExchangeItem_Common")
local ActBannerEffectContent = require("UI.UIActivityCenterTable.Component.LimitedTimeFeast.ActBannerEffectContent")
local titleTextPath = "RightView/Top/title"
local remainTimeTextPath = "RightView/Top/TimeContent/openTime"
local infoBtnPath = "RightView/Top/InfoBtn"
local exchangeItemScrollPath = "RightView/Rect_Bottom/ScrollView"
local exchangeItemContentPath = "RightView/Rect_Bottom/ScrollView/Viewport/Content"
local bg1Path = "Bg1"
local bg2Path = "Bg2"
local bgImagePath = "BgImage"
local bannerPath = "Banner"
local skinEffectPath = "RightView/Top/Scroll View/Viewport/SkinEffect"
local skinEffectUsingEffectPath = "RightView/Top/Scroll View/Viewport/SkinEffect/UsingEffect"
local skinEffectUsingEffectTextPath = "RightView/Top/Scroll View/Viewport/SkinEffect/UsingEffect/UseEffectText"
local skinEffectOwnEffectPath = "RightView/Top/Scroll View/Viewport/SkinEffect/OwnEffect"
local skinEffectOwnEffectTextPath = "RightView/Top/Scroll View/Viewport/SkinEffect/OwnEffect/OwnEffectText"
local red_switch_path = "RightView/Top/redSwitch"
local red_switch_btn_path = "RightView/Top/redSwitch/redSwitchBtn"
local checkmark_path = "RightView/Top/redSwitch/redSwitchBtn/Background/Checkmark"
local act_banner_effect_content_path = "ActBannerEffectContent"
local use_item_btn_path = "RightView/UseItemBtn"
local use_item_btn_icon_path = "RightView/UseItemBtn/UseItemBtnIcon"
local use_item_btn_red_dot_path = "RightView/UseItemBtn/UseItemBtnRedDot"

function UICitySkinExchange_Common:OnCreate()
  base.OnCreate(self)
  
  function self.timer_action()
    self:RefreshTime()
  end
  
  function self.exchange_action(data)
    self:ExchangeItem(data)
  end
  
  function self.goto_action()
    self:GotoAct()
  end
  
  self:ComponentDefine()
  self.waitMsgBack = false
end

local function GetItemNameSequence(self)
  NameCount = NameCount + 1
  return tostring(NameCount)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.showDataList then
    return nil
  end
  local ShowInfo = self.showDataList[index]
  local item = loopScroll:NewListViewItem("TargetItem")
  local script = self.exchangeItemContent:GetComponent(item.gameObject.name, UICitySkinExchangeItem)
  if script == nil then
    local objectName = tostring(GetItemNameSequence(self))
    item.gameObject.name = objectName
    script = self.exchangeItemContent:AddComponent(UICitySkinExchangeItem, objectName)
  end
  script:SetActive(true)
  script:SetData(ShowInfo, self.exchange_action, self.goto_action, self.actBaseData.id)
  return item
end

function UICitySkinExchange_Common:ComponentDefine()
  self.titleText = self:AddComponent(UIText, titleTextPath)
  self.remainText = self:AddComponent(UIText, remainTimeTextPath)
  self.infoBtn = self:AddComponent(UIButton, infoBtnPath)
  self.infoBtn:SetOnClick(function()
    if not self.activityId then
      return
    end
    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if activityData == nil then
      return
    end
    local param = {}
    param.activityRulesStr = Localization:GetString(activityData.story)
    param.activityId = self.activityId
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailCommon, {anim = true}, param)
  end)
  self.exchangeItemScroll = self:AddComponent(UILoopListView2, exchangeItemScrollPath)
  self.exchangeItemScroll:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.exchangeItemContent = self:AddComponent(UIBaseContainer, exchangeItemContentPath)
  self.skinEffect = self:AddComponent(UIBaseContainer, skinEffectPath)
  self.skinEffectUsingEffect = self:AddComponent(UIBaseContainer, skinEffectUsingEffectPath)
  self.skinEffectUsingEffectText = self:AddComponent(UIText, skinEffectUsingEffectTextPath)
  self.skinEffectOwnEffect = self:AddComponent(UIBaseContainer, skinEffectOwnEffectPath)
  self.skinEffectOwnEffectText = self:AddComponent(UIText, skinEffectOwnEffectTextPath)
  if self.transform and self.transform:Find(red_switch_path) then
    self.redSwitch = self:AddComponent(UIBaseContainer, red_switch_path)
    self.redSwitchBtn = self:AddComponent(UIButton, red_switch_btn_path)
    self.redSwitchCheck = self:AddComponent(UIImage, checkmark_path)
    self.redSwitchCheck:SetActive(false)
    self.redSwitchBtn:SetOnClick(function()
      if not self.actBaseData then
        return
      end
      local nowState = DataCenter.ActCitySkinDataManager:GetExchangeRedPointConditon(self.actBaseData.id)
      DataCenter.ActCitySkinDataManager:SetExchangeRedPointConditon(self.activityId, not nowState)
      self.redSwitchCheck:SetActive(not nowState)
      if not nowState then
        UIUtil.ShowTipsId("activity_99051desc_2")
      end
    end)
  end
  self.bg1 = self:AddComponent(UIImage, "Bg1")
  self.bg2 = self:AddComponent(UIRawImage, "Bg2")
  self.headFrame = self:AddComponent(UICommonResItem, "RightView/Top/UICommonResItem")
  self.useTitle = self:AddComponent(UIText, "RightView/Top/Scroll View/Viewport/SkinEffect/UsingEffect/Title/UseTitle")
  self.ownTitle = self:AddComponent(UIText, "RightView/Top/Scroll View/Viewport/SkinEffect/OwnEffect/Title/OwnTitle")
  self.act_banner_effect_content = self:AddComponent(ActBannerEffectContent, act_banner_effect_content_path)
  self.use_item_btn = self:AddComponent(UIButton, use_item_btn_path)
  self.use_item_btn:SetOnClick(function()
    self:OnUseItemBtnClick()
  end)
  self.use_item_btn_icon = self:AddComponent(UIImage, use_item_btn_icon_path)
  self.use_item_btn:SetActive(false)
  self.use_item_btn_red_dot = self:AddComponent(UIImage, use_item_btn_red_dot_path)
end

function UICitySkinExchange_Common:OnDestroy()
  self:DeleteTimer()
  self:ClearScroll()
  self:ComponentDestroy()
  self.timer_action = nil
  self.exchange_action = nil
  self.goto_action = nil
  base.OnDestroy(self)
end

function UICitySkinExchange_Common:ClearScroll()
  self.exchangeItemContent:RemoveComponents(UICitySkinExchangeItem)
  self.exchangeItemScroll:ClearAllItems()
end

function UICitySkinExchange_Common:ComponentDestroy()
  self.titleText = nil
  self.remainText = nil
  self.infoBtn = nil
  self.exchangeItemScroll = nil
  self.exchangeItemContent = nil
  self.skinEffect = nil
  self.skinEffectUsingEffect = nil
  self.skinEffectUsingEffectText = nil
  self.skinEffectOwnEffect = nil
  self.skinEffectOwnEffectText = nil
  self.bg1 = nil
  self.bg2 = nil
  self.headFrame = nil
  self.useTitle = nil
  self.ownTitle = nil
  self.act_banner_effect_content = nil
  self.use_item_btn = nil
  self.use_item_btn_icon = nil
  self.use_item_btn_red_dot = nil
end

function UICitySkinExchange_Common:OnEnable()
  base.OnEnable(self)
end

function UICitySkinExchange_Common:OnDisable()
  base.OnDisable(self)
end

function UICitySkinExchange_Common:OnGetData(rechargeId)
  if not rechargeId then
    return
  end
end

function UICitySkinExchange_Common:OnExchangeItem()
  self:RefreshExchangeItems()
end

function UICitySkinExchange_Common:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CitySkinExchange, self.OnExchangeItem)
  self:AddUIListener(EventId.UseItemSuccess, self.UseItemSuccessHandle)
end

function UICitySkinExchange_Common:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CitySkinExchange, self.OnExchangeItem)
  self:RemoveUIListener(EventId.UseItemSuccess, self.UseItemSuccessHandle)
end

function UICitySkinExchange_Common:RefreshRewardList()
  if not self.actInfo then
    return
  end
end

function UICitySkinExchange_Common:Refresh()
  self:RefreshRewardList(true)
  self:RefreshScore()
end

function UICitySkinExchange_Common:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UICitySkinExchange_Common:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, nil, false, false, false)
    self.timer:Start()
  end
end

function UICitySkinExchange_Common:RefreshTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.actBaseData then
    if curTime > self.actBaseData.endTime then
      self:DeleteTimer()
      self.remainText:SetLocalText(2000409)
    else
      self.remainText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.actBaseData.endTime - curTime))
    end
  else
    self:DeleteTimer()
    self.remainText:SetText("")
  end
end

function UICitySkinExchange_Common:RefreshExchangeItems()
  if not self.actDetailInfo then
    return
  end
  self.waitMsgBack = false
  self.showDataList = {}
  if self.actDetailInfo.items then
    self.showDataList = DeepCopy(self.actDetailInfo.items)
    local len = #self.showDataList
    for i = len, 1, -1 do
      if self.showDataList[i].order == nil then
        table.remove(self.showDataList, i)
      end
    end
    for k, v in ipairs(self.showDataList) do
      self:SetItemIsRewardDecoAndEternal(v)
    end
    table.sort(self.showDataList, function(a, b)
      if a.isRewardDecoAndEternal ~= b.isRewardDecoAndEternal then
        return b.isRewardDecoAndEternal
      end
      local aIsFinish = a.curCount >= a.maxCount
      local bIsFinish = b.curCount >= b.maxCount
      if aIsFinish and not bIsFinish then
        return false
      end
      if not aIsFinish and bIsFinish then
        return true
      end
      if a.order ~= b.order then
        return a.order < b.order
      end
      if a.id and b.id then
        return a.id < b.id
      else
        return false
      end
    end)
  end
  if not table.IsNullOrEmpty(self.showDataList) then
    self.exchangeItemScroll:SetActive(true)
    self.exchangeItemScroll:SetListItemCount(#self.showDataList, false, false)
    self.exchangeItemScroll:RefreshAllShownItem()
  else
    self.exchangeItemScroll:SetActive(false)
  end
end

function UICitySkinExchange_Common:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.actBaseData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.actBaseData then
    local name = not string.IsNullOrEmpty(self.actBaseData.bannerTittle) and self.actBaseData.bannerTittle or self.actBaseData.name
    self.titleText:SetLocalText(name)
    if self.redSwitchCheck then
      self.redSwitchCheck:SetActive(DataCenter.ActCitySkinDataManager:GetExchangeRedPointConditon(self.activityId))
    end
    if not string.IsNullOrEmpty(self.actBaseData.activity_pic) then
      self.bg2:LoadSprite(DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.CitySkinExchangeFestivalPath, self.actBaseData.activity_pic))
      self.bg2:SetNativeSize(true)
    end
    self:RefreshCommonNode(self.actBaseData:GetShowConfigTemp())
    if not string.IsNullOrEmpty(self.actBaseData.para_5) then
      self.skinEffect:SetActive(true)
      local effects = DecorationUtil.GetEffectDesc(tonumber(self.actBaseData.para_5))
      local ownEffectStr = effects.ownEffect
      self.skinEffectOwnEffectText:SetText(ownEffectStr)
      local useEffectStr = effects.useEffect
      self.skinEffectUsingEffectText:SetText(useEffectStr)
      self.useTitle:SetActive(not string.IsNullOrEmpty(useEffectStr))
      self.ownTitle:SetActive(not string.IsNullOrEmpty(ownEffectStr))
      local skinTemplate = DataCenter.DecorationTemplateManager:GetTemplate(tonumber(self.actBaseData.para_5))
      if skinTemplate and not table.IsNullOrEmpty(skinTemplate.gainMethod) and skinTemplate.type == DecorationType.DecorationType_Head_Frame then
        local headFrameData = {}
        headFrameData.rewardType = RewardType.GOODS
        headFrameData.itemId = skinTemplate.gainMethod[1].id
        self.headFrame:ReInit(headFrameData)
        self.headFrame:SetActive(true)
      else
        self.headFrame:SetActive(false)
      end
    else
      self.skinEffect:SetActive(false)
      self.headFrame:SetActive(false)
    end
  elseif self.redSwitchCheck then
    self.SetActive(false)
  end
  self.actDetailInfo = DataCenter.ActCitySkinDataManager:GetActCitySkinExchangeInfo(self.activityId)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.actBaseData then
    if curTime > self.actBaseData.endTime then
      self.remainText:SetLocalText(2000409)
    else
      self:AddTimer()
    end
  else
    self.remainText:SetText("")
  end
  self:RefreshExchangeItems()
  self.act_banner_effect_content:SetData(self.actBaseData, true)
  local packingParams = {
    activityId = self.activityId,
    isShowItemTopBar = false
  }
  EventManager:GetInstance():Broadcast(EventId.ActivityCommonGroupView_FestivalPackagingModify, packingParams)
end

function UICitySkinExchange_Common:ExchangeItem(data)
  if not data then
    return
  end
  if data.curCount >= data.maxCount then
    return
  end
  if not self.actBaseData then
    return
  end
  if self.waitMsgBack then
    return
  end
  local param = {}
  param.goodsInfo = {}
  local defaultSelectNum = 1
  if not table.IsNullOrEmpty(data.reward) then
    local targetItem = data.reward[1]
    param.goodsInfo.rewardType = targetItem.rewardType
    param.goodsInfo.itemId = targetItem.itemId
    param.goodsInfo.count = targetItem.count
    local limit = data.maxCount - data.curCount
    limit = math.max(limit, 0)
    param.goodsInfo.limitCount = limit == 0 and MaxLimit or limit
    param.goodsInfo.eachPrice = 1
    if data.needItems then
      for id, count in pairs(data.needItems) do
        param.consumeInfo = {}
        param.consumeInfo.currencyType = RewardType.GOODS
        param.consumeInfo.currencyId = id
        param.goodsInfo.eachPrice = count
        local curNum = DataCenter.ItemData:GetItemRealCount(id)
        local cost = count
        local canGetNum = math.floor(curNum / cost)
        break
      end
    end
  end
  local actBaseInfo = self.actBaseData
  local exchangeData = data
  local view = self
  
  function param.callback(buyCount)
    if view then
      view.waitMsgBack = true
    end
    SFSNetwork.SendMessage(MsgDefines.CitySkinExchange, actBaseInfo.id, exchangeData.id, buyCount)
  end
  
  param.limitCount = defaultSelectNum
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMultiBuy, {anim = true}, param)
end

function UICitySkinExchange_Common:GotoAct()
  if self.view and self.actBaseData then
    local jumpto = self.actBaseData:GetFirstActiveJumpTo()
    if 0 < jumpto then
      GoToUtil.GoActWindow({jumpto}, false)
    else
      UIUtil.ShowTipsId(801141)
    end
  end
end

function UICitySkinExchange_Common:SetItemIsRewardDecoAndEternal(data)
  local isRewardDecoAndEternal = false
  if data.reward and #data.reward > 0 then
    local targetRewardData = data.reward[1]
    if targetRewardData.rewardType == RewardType.GOODS then
      local itemId = targetRewardData.itemId
      local itemtemp = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
      if itemtemp and itemtemp.type == GOODS_TYPE.GOODS_TYPE_113 then
        isRewardDecoAndEternal = DataCenter.ItemTemplateManager:CheckDecorationEternalByGoodsType113ID(itemId)
      end
    end
  end
  data.isRewardDecoAndEternal = isRewardDecoAndEternal
end

function UICitySkinExchange_Common:RefreshCommonNode(showTemp)
  if showTemp then
    if not string.IsNullOrEmpty(showTemp.pic_spec1) then
      self.bg1:LoadSprite(DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.CitySkinExchangeFestivalPath, showTemp.pic_spec1))
    end
    UIActivityCenterCommonUtil.SetTopViewColor(self.titleText.gameObject, nil, nil, showTemp)
    local useItemBtnIconName = showTemp.usebox_btn
    if not string.IsNullOrEmpty(useItemBtnIconName) then
      self.use_item_btn:SetActive(true)
      self.use_item_btn_icon:LoadSpriteAuto(DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.CitySkinExchangeFestivalPath, useItemBtnIconName))
      self:RefreshUseItemBtnRedDot()
    else
      self.use_item_btn:SetActive(false)
    end
  end
end

function UICitySkinExchange_Common:UseItemSuccessHandle()
  self:RefreshExchangeItems()
  self:RefreshUseItemBtnRedDot()
end

function UICitySkinExchange_Common:RefreshUseItemBtnRedDot()
  local isRed = false
  local showTemp = self.actBaseData:GetShowConfigTemp()
  if showTemp then
    local usebox_list = showTemp.usebox_list
    if usebox_list and 0 < #usebox_list then
      for i, v in ipairs(usebox_list) do
        local curNum = DataCenter.ItemData:GetItemCount(v)
        if 0 < curNum then
          isRed = true
          break
        end
      end
    end
  end
  self.use_item_btn_red_dot:SetActive(isRed)
end

function UICitySkinExchange_Common:OnUseItemBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.ActCitySkinExchangeItemUse, {anim = true}, self.activityId)
end

return UICitySkinExchange_Common
