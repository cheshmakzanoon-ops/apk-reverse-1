local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIBargainShopTop = require("UI.UIActivityCenterTable.Component.UIBargainShop.UIBargainShopTop")
local UIBargainShopPropItem = require("UI.UIActivityCenterTable.Component.UIBargainShop.UIBargainShopPropItem")
local UIBargainShopMain = BaseClass("UIBargainShopMain", base)

function UIBargainShopMain:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UIBargainShopMain:ComponentDefine()
  self.top = self:AddComponent(UIBargainShopTop, "rect/top")
  self.productList = self:AddComponent(UIScrollView, "productList")
  self.showChatBtn = self:AddComponent(UIButton, "showChatBtn")
  self.showChatIcon = self:AddComponent(UIButton, "showChatBtn/Image")
  self.redDot = self:AddComponent(UIBaseContainer, "rect/top/ExpArea/addRedPoint")
  self.showChatBtn:SetOnClick(function()
    self:OnShowChatBtnClick()
  end)
  self.productList:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.productList:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
end

function UIBargainShopMain:OnShowChatBtnClick()
  self.shieldChatIsOn = not self.shieldChatIsOn
  if self.data then
    self.data:SetShieldChatIsOn(self.shieldChatIsOn)
  end
  self:RefreshShieldBtnIcon()
end

function UIBargainShopMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshBargainShop, self.OnRefreshShopView)
  self:AddUIListener(EventId.BargainDayRewardUpdate, self.RefreshRewardRedDot)
end

function UIBargainShopMain:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshBargainShop, self.OnRefreshShopView)
  self:RemoveUIListener(EventId.BargainDayRewardUpdate, self.RefreshRewardRedDot)
  base.OnRemoveListener(self)
end

function UIBargainShopMain:RefreshRewardRedDot()
  self.redDot:SetActive(DataCenter.ActBargainShopData:CanGetFreePack(tonumber(self.activityId)))
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function UIBargainShopMain:OnRefreshShopView()
  self:UpdateView()
end

function UIBargainShopMain:RefreshShieldBtnIcon()
  self.showChatIcon:SetActive(self.shieldChatIsOn)
end

function UIBargainShopMain:ComponentDestroy()
  self:ClearScroll()
  self.top = nil
  self.productList = nil
  self.showChatBtn = nil
  self.showChatIcon = nil
  self.showChatBtn = nil
end

function UIBargainShopMain:ShowScroll()
  self:ClearScroll()
  local count = #self.data.productList
  self.productList:SetTotalCount(count)
  if 0 < count then
    self.productList:RefillCells()
  end
end

function UIBargainShopMain:ClearScroll()
  self.productList:ClearCells()
  self.productList:RemoveComponents(UIBargainShopPropItem)
end

function UIBargainShopMain:OnDeleteCell(itemObj, index)
  self.productList:RemoveComponent(itemObj.name, UIBargainShopPropItem)
end

function UIBargainShopMain:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.productList:AddComponent(UIBargainShopPropItem, itemObj)
  item:UpdateData(self.data.productList[index])
end

function UIBargainShopMain:SetData(activityId)
  base.SetData(self, activityId)
  SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, self.activityId)
  self.activityId = activityId
  self:UpdateView()
end

function UIBargainShopMain:UpdateView()
  self.data = DataCenter.ActBargainShopData:GetInfoByActId(self.activityId)
  self:RefreshRewardRedDot()
  local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.top:UpdateData(self.data, actListData)
  self:ShowScroll()
  self.shieldChatIsOn = self.data:GetShieldChatIsOn()
  self:RefreshShieldBtnIcon()
end

function UIBargainShopMain:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBargainShopMain:OnEnable()
  base.OnEnable(self)
end

function UIBargainShopMain:OnDisable()
  base.OnDisable(self)
end

function UIBargainShopMain:DataDefine()
  self.activityId = nil
  self.data = nil
end

return UIBargainShopMain
