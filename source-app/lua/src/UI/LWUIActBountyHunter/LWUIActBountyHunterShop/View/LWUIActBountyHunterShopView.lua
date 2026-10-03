local LWUIActBountyHunterShopView = BaseClass("LWUIActBountyHunterShopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUIActBountyHunterShopItemComponent = require("UI/LWUIActBountyHunter/LWUIActBountyHunterShop/Component/LWUIActBountyHunterShopItemComponent")
local UITopItem = require("UI.UIActivityCenterTable.Component.UILuckyRoll.UITopItem")
local itemHigh = 289
local contentMaxHigh = 900
local closeBtn_path = "contentView/topcontent/CloseBtn"
local colsebg_path = "colsebg"
local UIActMonopolyShopItem_path = "contentView/UIActMonopolyShopItem"
local scrollView_path = "contentView/ScrollView"
local content_path = "contentView/ScrollView/SoftViewport/Content"
local bg_path = "contentView/topcontent/bg"
local content_bg_path = "contentView/contentBg"
local info_btn_path = "contentView/topcontent/InfoBtn"

function LWUIActBountyHunterShopView:OnCreate()
  base.OnCreate(self)
  self.activityId = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActBountyHunterShopView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActBountyHunterShopView:OnEnable()
  base.OnEnable(self)
  self:OnOpen()
end

function LWUIActBountyHunterShopView:ComponentDefine()
  self.animator = self:AddComponent(UIAnimator, "")
  self.close_btn = self:AddComponent(UIButton, closeBtn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
    EventManager:GetInstance():Broadcast(EventId.ActMonopolyShopViewClose)
  end)
  self.colsebg = self:AddComponent(UIButton, colsebg_path)
  self.colsebg:SetOnClick(function()
    self.ctrl:CloseSelf()
    EventManager:GetInstance():Broadcast(EventId.ActMonopolyShopViewClose)
  end)
  self.scrollView = self:AddComponent(UILayoutElement, scrollView_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.content_bg = self:AddComponent(UIImage, content_bg_path)
  self.textTitle = self:AddComponent(UIText, "contentView/topcontent/Desc")
  self.textDes = self:AddComponent(UIText, "contentView/topcontent/Desc2")
  self.compDiamondBar = self:AddComponent(UITopItem, "contentView/topcontent/DiamondBar")
  self.infoBtn = self:AddComponent(UIButton, info_btn_path)
  self.infoBtn:SetOnClick(function()
    self:InfoBtnClick()
  end)
end

function LWUIActBountyHunterShopView:ComponentDestroy()
  self:ClearAllItem()
  self.animator = nil
  self.close_btn = nil
  self.colsebg = nil
  self.scrollView = nil
  self.shopItems = nil
  self.content = nil
  self.bg = nil
  self.content_bg = nil
  self.textTitle = nil
  self.textDes = nil
  self.compDiamondBar = nil
end

function LWUIActBountyHunterShopView:DataDefine()
end

function LWUIActBountyHunterShopView:DataDestroy()
end

function LWUIActBountyHunterShopView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BountyHunterShopEventUpdate, self.OnGetShopDataChangeMsg)
  self:AddUIListener(EventId.OnPackageInfoUpdated, self.OnGetShopDataChangeMsg)
  self:AddUIListener(EventId.UpdateGold, self.OnRefreshGold)
end

function LWUIActBountyHunterShopView:OnRemoveListener()
  self:RemoveUIListener(EventId.BountyHunterShopEventUpdate, self.OnGetShopDataChangeMsg)
  self:RemoveUIListener(EventId.OnPackageInfoUpdated, self.OnGetShopDataChangeMsg)
  self:RemoveUIListener(EventId.UpdateGold, self.OnRefreshGold)
  base.OnRemoveListener(self)
end

function LWUIActBountyHunterShopView:ReopenWithoutCreate()
  base.ReopenWithoutCreate(self)
  self:RefreshView()
  self:OnRefreshGold()
end

function LWUIActBountyHunterShopView:OnOpen()
  self.activityData = DataCenter.BountyHunterActDataManager:GetActData(self.activityId)
  if self.activityData == nil then
    self.ctrl:CloseSelf()
    return
  end
  self:RefreshView()
  PostEventLog.Track(PostEventLog.Defines.BountyHunterOpenEventShop)
end

function LWUIActBountyHunterShopView:ClearAllItem()
  self.content:RemoveComponents(LWUIActBountyHunterShopItemComponent)
  self.items = {}
  if not self.itemReqs then
    self.itemReqs = {}
    return
  end
  for _, req in pairs(self.itemReqs) do
    req:Destroy()
  end
end

function LWUIActBountyHunterShopView:RefreshView()
  if self.activityData == nil then
    self.ctrl:CloseSelf()
    return
  end
  local eventShopDataList = self.activityData:GetEventShopDataListInTimeOrder()
  if table.IsNullOrEmpty(eventShopDataList) then
    self.ctrl:CloseSelf()
    return
  end
  if self.eventShopDataList ~= nil and #self.eventShopDataList == #eventShopDataList then
    self.eventShopDataList = eventShopDataList
    self:RefreshAllItems()
  else
    self.eventShopDataList = eventShopDataList
    self:CreateAllItems()
  end
  self.curShowEarliestData = self.activityData:GetEarliestEventShopData()
  self.compDiamondBar:SetData(nil, ResourceType.Gold, function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWResourceInfo, {anim = true}, ResourceType.Gold)
  end)
  self:RefreshShopTimesInfo()
end

function LWUIActBountyHunterShopView:RefreshAllItems()
  if self.items then
    for i, v in ipairs(self.items) do
      v:RefreshView()
    end
  end
end

function LWUIActBountyHunterShopView:CreateAllItems()
  self:ClearAllItem()
  if self.eventShopDataList[1] then
    local tmpData = LocalController:instance():getLine(TableName.Bounty_Hunter_Event, toInt(self.eventShopDataList[1].eventId))
    if tmpData then
      self.textTitle:SetLocalText(tmpData.name)
    end
  end
  local num = 0
  for i, v in ipairs(self.eventShopDataList) do
    self.itemReqs[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/BountyHunterShop/BountyHunterShopItem.prefab", function(req)
      if req.isError then
        return
      end
      local go = req.gameObject
      go.name = tostring(v.uuid)
      go:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local item = self.content:AddComponent(LWUIActBountyHunterShopItemComponent, go.name)
      item:SetData(self.activityId, v.uuid)
      table.insert(self.items, item)
    end)
    num = num + 1
  end
  local contentH = num * itemHigh
  contentH = math.min(contentH, contentMaxHigh)
  self.scrollView:SetPreferredHeight(contentH)
end

function LWUIActBountyHunterShopView:OnGetShopDataChangeMsg()
  self:RefreshView()
end

function LWUIActBountyHunterShopView:Update1000MS()
  if self.curShowEarliestData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.curShowEarliestData.durationTime - curTime
  if leftTime <= 0 then
    self:RefreshView()
  end
end

function LWUIActBountyHunterShopView:OnRefreshGold()
  if self.compDiamondBar then
    self.compDiamondBar:RefreshData()
  end
end

function LWUIActBountyHunterShopView:RefreshShopTimesInfo()
  local alreadyRefreshTimes = self.activityData:GetCurShopEventTimes()
  local maxRefreshTimes = 0
  local paramTmp = self.activityData and self.activityData:GetHunterActTmpParaData()
  if paramTmp and paramTmp.event_daily_maxnum then
    maxRefreshTimes = paramTmp.event_daily_maxnum[BountyHunterEventType4Server.Shop] or 0
  end
  self.textDes:SetLocalText("activity_hunter_trade_desc4", alreadyRefreshTimes, maxRefreshTimes)
end

function LWUIActBountyHunterShopView:InfoBtnClick()
  local param = {}
  local titleKey = ""
  local descKey = ""
  local hunterTmp = self.activityData:GetBountyHunterTmp()
  if hunterTmp and hunterTmp.trade_info and #hunterTmp.trade_info >= 2 then
    titleKey = hunterTmp.trade_info[1]
    descKey = hunterTmp.trade_info[2]
  end
  param.title = titleKey
  param.activityRulesStr = Localization:GetString(descKey)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

return LWUIActBountyHunterShopView
