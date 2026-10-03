local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UICitySkinExchange = BaseClass("UICitySkinExchange", base)
local Localization = CS.GameEntry.Localization
local UICitySkinExchangeItem = require("UI.UIActivityCenterTable.Component.UICitySkin.UICitySkinExchangeItem")
local titleTextPath = "RightView/Top/title"
local remainTimeTextPath = "RightView/Top/RemainTimeContent/RemainTimeText"
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

function UICitySkinExchange:OnCreate()
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

function UICitySkinExchange:ComponentDefine()
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
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetail, {anim = true}, param)
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
end

function UICitySkinExchange:OnDestroy()
  self:DeleteTimer()
  self:ClearScroll()
  self:ComponentDestroy()
  self.timer_action = nil
  self.exchange_action = nil
  self.goto_action = nil
  base.OnDestroy(self)
end

function UICitySkinExchange:ClearScroll()
  self.exchangeItemContent:RemoveComponents(UICitySkinExchangeItem)
  self.exchangeItemScroll:ClearAllItems()
end

function UICitySkinExchange:ComponentDestroy()
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
end

function UICitySkinExchange:OnEnable()
  base.OnEnable(self)
end

function UICitySkinExchange:OnDisable()
  base.OnDisable(self)
  self:DeleteTimer()
end

function UICitySkinExchange:OnGetData(rechargeId)
  if not rechargeId then
    return
  end
end

function UICitySkinExchange:OnExchangeItem()
  self:RefreshExchangeItems()
end

function UICitySkinExchange:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CitySkinExchange, self.OnExchangeItem)
end

function UICitySkinExchange:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CitySkinExchange, self.OnExchangeItem)
end

function UICitySkinExchange:RefreshRewardList()
  if not self.actInfo then
    return
  end
end

function UICitySkinExchange:Refresh()
  self:RefreshRewardList(true)
  self:RefreshScore()
end

function UICitySkinExchange:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UICitySkinExchange:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, nil, false, false, false)
    self.timer:Start()
  end
end

function UICitySkinExchange:RefreshTime()
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

function UICitySkinExchange:RefreshExchangeItems()
  if not self.actDetailInfo then
    return
  end
  self.showDataList = {}
  if self.actDetailInfo.items then
    self.showDataList = DeepCopy(self.actDetailInfo.items)
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

function UICitySkinExchange:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.actBaseData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.actBaseData then
    self.titleText:SetLocalText(self.actBaseData.name)
    if self.redSwitchCheck then
      self.redSwitchCheck:SetActive(DataCenter.ActCitySkinDataManager:GetExchangeRedPointConditon(self.activityId))
    end
    if not string.IsNullOrEmpty(self.actBaseData.para_5) then
      self.skinEffect:SetActive(true)
      local effects = DecorationUtil.GetEffectDesc(tonumber(self.actBaseData.para_5))
      local ownEffectStr = effects.ownEffect
      self.skinEffectOwnEffectText:SetText(ownEffectStr)
      local useEffectStr = effects.useEffect
      self.skinEffectUsingEffectText:SetText(useEffectStr)
    else
      self.skinEffect:SetActive(false)
    end
  else
    if self.redSwitchCheck then
      self.SetActive(false)
    end
    self.skinEffect:SetActive(false)
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
end

function UICitySkinExchange:ExchangeItem(data)
  if not data then
    return
  end
  if data.curCount >= data.maxCount then
    return
  end
  if not self.actBaseData then
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
        local curNum = DataCenter.ItemData:GetItemCount(id)
        local cost = count
        local canGetNum = math.floor(curNum / cost)
        defaultSelectNum = math.max(defaultSelectNum, canGetNum)
        break
      end
    end
  end
  local actBaseInfo = self.actBaseData
  local exchangeData = data
  
  function param.callback(buyCount)
    SFSNetwork.SendMessage(MsgDefines.CitySkinExchange, actBaseInfo.id, exchangeData.id, buyCount)
  end
  
  param.limitCount = defaultSelectNum
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMultiBuy, {anim = true}, param)
end

function UICitySkinExchange:GotoAct()
  if self.view and self.actBaseData then
    local jumpto = self.actBaseData:GetFirstActiveJumpTo()
    if 0 < jumpto then
      GoToUtil.GoActWindow({jumpto}, false)
    end
  end
end

function UICitySkinExchange:SetItemIsRewardDecoAndEternal(data)
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

return UICitySkinExchange
