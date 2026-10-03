local UIMonsterInvasionShopView = BaseClass("UIMonsterInvasionShopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIMonsterInvasionShopItem = require("UI.MonsterInvasion.UIMonsterInvasionShop.Component.UIMonsterInvasionShopItem")
local txt_title_path = "UICommonPopUpTitle/safearea/TopBar/TextTitle"
local close_btn_path = "UICommonPopUpTitle/safearea/BtnClose"
local return_btn_path = "UICommonPopUpTitle/panel"
local exchangeItemScrollPath = "shopObj/ScrollView"
local exchangeItemContentPath = "shopObj/ScrollView/Viewport/Content"

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
  local script = self.exchangeItemContent:GetComponent(item.gameObject.name, UIMonsterInvasionShopItem)
  if script == nil then
    local objectName = tostring(GetItemNameSequence(self))
    item.gameObject.name = objectName
    script = self.exchangeItemContent:AddComponent(UIMonsterInvasionShopItem, objectName)
  end
  script:SetActive(true)
  script:SetData(ShowInfo, self.exchange_action, self.goto_action, self.activityId)
  return item
end

local function OnCreate(self)
  base.OnCreate(self)
  self.activityId = self:GetUserData()
  self.activityId = tonumber(self.activityId)
  
  function self.exchange_action(data)
    self:ExchangeItem(data)
  end
  
  function self.goto_action()
    self:GotoAct()
  end
  
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.exchangeItemScroll = self:AddComponent(UILoopListView2, exchangeItemScrollPath)
  self.exchangeItemScroll:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.exchangeItemContent = self:AddComponent(UIBaseContainer, exchangeItemContentPath)
  self.haveItemTxt = self:AddComponent(UITextMeshProUGUIEx, "shopObj/haveItemContent/haveItemTxt")
  self.haveItemNum = self:AddComponent(UITextMeshProUGUIEx, "shopObj/haveItemContent/haveItemNum")
  self.costImage = self:AddComponent(UIImage, "shopObj/haveItemContent/costImage")
  self.toggle = self:AddComponent(UIToggle, "shopObj/haveItemContent/Toggle")
  self.toggle:SetIsOn(DataCenter.ActivityMonsterInvasionDataManager:IsShopRedOn())
  self.toggle:SetOnValueChanged(function(tf)
    DataCenter.ActivityMonsterInvasionDataManager:SetShopRedOn(tf)
  end)
  self.haveItemTxt:SetLocalText("activity_99051desc_1")
  self:RefreshList()
  local shopRecordData = DataCenter.ActivityMonsterInvasionDataManager:GetActShopData(self.activityId)
  if #shopRecordData == 0 then
    SFSNetwork.SendMessage(MsgDefines.MonsterShopInfo, self.activityId)
  end
end

local function OnDestroy(self)
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.MonsterInvasionShopDataUpdate, self.RefreshList)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.MonsterInvasionShopDataUpdate, self.RefreshList)
end

local function RefreshList(self)
  self.showDataList = {}
  local shopRecordData = DataCenter.ActivityMonsterInvasionDataManager:GetActShopData(self.activityId)
  if shopRecordData then
    for k, v in pairs(shopRecordData) do
      local id = v.id
      local temp = DataCenter.ActivityMonsterInvasionDataManager:GetExchangeTempalte(id)
      local maxCount = temp.cycle_times
      local isFinish = maxCount <= v.count
      local needItems = {
        [temp.currency_id] = temp.cost
      }
      local order = temp.order
      local reward = {
        [1] = {
          rewardType = RewardType.GOODS,
          itemId = temp.commodity,
          count = temp.commodity_num
        }
      }
      local data = {
        id = id,
        count = v.count,
        maxCount = maxCount,
        isFinish = isFinish,
        temp = temp,
        needItems = needItems,
        reward = reward,
        order = order
      }
      table.insert(self.showDataList, data)
    end
    table.sort(self.showDataList, function(a, b)
      if a.isFinish and not b.isFinish then
        return false
      end
      if not a.isFinish and b.isFinish then
        return true
      end
      if a.order and b.order then
        return a.order < b.order
      else
        return false
      end
    end)
  end
  if not table.IsNullOrEmpty(self.showDataList) then
    self.exchangeItemScroll:SetActive(true)
    self.exchangeItemScroll:SetListItemCount(#self.showDataList, false, false)
    self.exchangeItemScroll:RefreshAllShownItem()
    self:RefreshHaveItemInfo()
  else
    self.exchangeItemScroll:SetActive(false)
  end
end

local function GotoAct(self)
  SFSNetwork.SendMessage(MsgDefines.FindMonsterInvasion, WorldMonsterSpecialType.MonsterInvasion)
end

local function ExchangeItem(self, data)
  if not data then
    return
  end
  if data.count >= data.maxCount then
    return
  end
  local param = {}
  param.goodsInfo = {}
  if not table.IsNullOrEmpty(data.reward) then
    local targetItem = data.reward[1]
    param.goodsInfo.rewardType = targetItem.rewardType
    param.goodsInfo.itemId = targetItem.itemId
    param.goodsInfo.count = targetItem.count
    local limit = data.maxCount - data.count
    limit = math.max(limit, 0)
    param.goodsInfo.limitCount = limit == 0 and MaxLimit or limit
    param.goodsInfo.eachPrice = 1
    if data.needItems then
      for id, count in pairs(data.needItems) do
        param.consumeInfo = {}
        param.consumeInfo.currencyType = RewardType.GOODS
        param.consumeInfo.currencyId = id
        param.goodsInfo.eachPrice = count
        break
      end
    end
  end
  local exchangeData = data
  
  function param.callback(buyCount)
    SFSNetwork.SendMessage(MsgDefines.MonsterShopBuy, self.activityId, exchangeData.id, buyCount)
  end
  
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMultiBuy, {anim = true}, param)
end

function UIMonsterInvasionShopView:RefreshHaveItemInfo()
  if not self.showDataList or #self.showDataList == 0 then
    return
  end
  local needItem = self.showDataList[1].needItems
  local goodsId
  for id, count in pairs(needItem) do
    goodsId = id
    break
  end
  if not goodsId then
    return
  end
  local curNum = DataCenter.ItemData:GetItemCount(goodsId)
  self.haveItemNum:SetText(curNum)
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(goodsId)
  self.costImage:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
end

UIMonsterInvasionShopView.OnCreate = OnCreate
UIMonsterInvasionShopView.OnDestroy = OnDestroy
UIMonsterInvasionShopView.OnAddListener = OnAddListener
UIMonsterInvasionShopView.OnRemoveListener = OnRemoveListener
UIMonsterInvasionShopView.RefreshList = RefreshList
UIMonsterInvasionShopView.GotoAct = GotoAct
UIMonsterInvasionShopView.ExchangeItem = ExchangeItem
return UIMonsterInvasionShopView
