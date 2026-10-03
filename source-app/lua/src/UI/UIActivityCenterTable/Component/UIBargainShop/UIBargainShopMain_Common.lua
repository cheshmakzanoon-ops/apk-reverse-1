local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIBargainShopTop = require("UI.UIActivityCenterTable.Component.UIBargainShop.UIBargainShopTop_Common")
local UIBargainShopPropItem = require("UI.UIActivityCenterTable.Component.UIBargainShop.UIBargainShopPropItem_Common")
local UIBargainShopMain_Common = BaseClass("UIBargainShopMain_Common_Common", base)

function UIBargainShopMain_Common:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UIBargainShopMain_Common:ComponentDefine()
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
  self.topBG = self:AddComponent(UIRawImage, "topBG")
  self.image = self:AddComponent(UIImage, "Image")
  self.showChat_txt = self:AddComponent(UIText, "showChat_txt")
end

function UIBargainShopMain_Common:OnShowChatBtnClick()
  self.shieldChatIsOn = not self.shieldChatIsOn
  if self.data then
    self.data:SetShieldChatIsOn(self.shieldChatIsOn)
  end
  self:RefreshShieldBtnIcon()
end

function UIBargainShopMain_Common:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshBargainShop, self.OnRefreshShopView)
  self:AddUIListener(EventId.BargainDayRewardUpdate, self.RefreshRewardRedDot)
end

function UIBargainShopMain_Common:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshBargainShop, self.OnRefreshShopView)
  self:RemoveUIListener(EventId.BargainDayRewardUpdate, self.RefreshRewardRedDot)
  base.OnRemoveListener(self)
end

function UIBargainShopMain_Common:RefreshRewardRedDot()
  local canGetReward = DataCenter.ActBargainShopData:CanGetFreePack(tonumber(self.activityId))
  self.redDot:SetActive(canGetReward)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function UIBargainShopMain_Common:OnRefreshShopView()
  self:UpdateView()
end

function UIBargainShopMain_Common:RefreshShieldBtnIcon()
  self.showChatIcon:SetActive(self.shieldChatIsOn)
end

function UIBargainShopMain_Common:ComponentDestroy()
  self:ClearScroll()
  self.top = nil
  self.productList = nil
  self.showChatBtn = nil
  self.showChatIcon = nil
  self.showChatBtn = nil
  self.topBG = nil
end

function UIBargainShopMain_Common:ShowScroll()
  self:ClearScroll()
  local count = #self.data.productList
  self.productList:SetTotalCount(count)
  if 0 < count then
    self.productList:RefillCells()
  end
end

function UIBargainShopMain_Common:ClearScroll()
  self.productList:ClearCells()
  self.productList:RemoveComponents(UIBargainShopPropItem)
end

function UIBargainShopMain_Common:OnDeleteCell(itemObj, index)
  self.productList:RemoveComponent(itemObj.name, UIBargainShopPropItem)
end

function UIBargainShopMain_Common:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.productList:AddComponent(UIBargainShopPropItem, itemObj)
  item:UpdateData(self.data.productList[index], self.activityId)
end

function UIBargainShopMain_Common:SetData(activityId)
  base.SetData(self, activityId)
  SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, self.activityId)
  self.activityId = activityId
  self:UpdateShowConfig()
end

function UIBargainShopMain_Common:UpdateShowConfig()
  local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if not actListData then
    return
  end
  if not string.IsNullOrEmpty(actListData.activity_pic) then
    self.topBG:LoadSpriteAuto(string.format(LoadPath.ActivityBargainShopBannerPath, actListData.activity_pic), function()
      if self.topBG then
        self.topBG:SetNativeSize()
      end
    end)
  end
  if not string.IsNullOrEmpty(actListData.para) then
    self.image:LoadSprite(string.format(LoadPath.ActivityBargainShopUIPath, actListData.para))
  end
  local actDetailData = DataCenter.ActBargainShopData:GetInfoByActId(self.activityId)
  if actDetailData then
    self.top:UpdateData(actDetailData, actListData)
  end
end

function UIBargainShopMain_Common:UpdateView()
  self:RefreshRewardRedDot()
  self.data = DataCenter.ActBargainShopData:GetInfoByActId(self.activityId)
  local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.top:UpdateData(self.data, actListData)
  self:ShowScroll()
  self.shieldChatIsOn = self.data:GetShieldChatIsOn()
  self:RefreshShieldBtnIcon()
  local showTemp = actListData:GetShowConfigTemp()
  if showTemp == nil then
    return
  end
  if not string.IsNullOrEmpty(showTemp.extra_para_color) then
    local r, g, b, a = string.match(showTemp.extra_para_color, "(%d+);(%d+);(%d+);(%d+)")
    if r and g and b and a then
      self.showChat_txt:SetColorRGBA255(tonumber(r), tonumber(g), tonumber(b), tonumber(a))
    else
      self.showChat_txt:SetColorHex("9899A0")
    end
  else
    self.showChat_txt:SetColorHex("9899A0")
  end
end

function UIBargainShopMain_Common:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBargainShopMain_Common:OnEnable()
  base.OnEnable(self)
end

function UIBargainShopMain_Common:OnDisable()
  base.OnDisable(self)
end

function UIBargainShopMain_Common:DataDefine()
  self.activityId = nil
  self.data = nil
end

return UIBargainShopMain_Common
