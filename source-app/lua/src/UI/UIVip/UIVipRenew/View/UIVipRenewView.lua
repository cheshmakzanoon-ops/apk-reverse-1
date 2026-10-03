local CellPointGood = require("UI.UIVip.UIVipRenew.Component.CellPointGood")
local UIVipRenewView = BaseClass("UIVipRenewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIVipRenewView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIVipRenewView:ComponentDefine()
  self.title_txt = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self._close_panel_btn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self._close_panel_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self._close_btn = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self._close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.scroll_view = self:AddComponent(UIScrollViewSimple, "Bg/ScrollView")
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.title1Text = self:AddComponent(UIText, "Bg/SliderGo/Common_bg1/Title1Text")
  self.title1Text:SetLocalText(2000281)
  self.leftTimeText = self:AddComponent(UIText, "Bg/SliderGo/Common_bg1/LeftTimeText")
  self.displayItem = self:AddComponent(UICommonResItem, "Bg/SliderGo/Common_bg1/UICommonResItem")
  local itemId = LuaEntry.DataConfig:TryGetNum("vip_aps", "k4")
  local param = {}
  param.rewardType = RewardType.GOODS
  param.itemId = itemId
  self.displayItem:ReInit(param)
  self.displayItem:SetFlagActive(false)
end

function UIVipRenewView:DataDefine()
  self.vipInfo = {}
  self.viptemplate = {}
  self.listGo = {}
  self.curIndex = 0
end

function UIVipRenewView:OnDestroy()
  self.title_txt = nil
  self._close_btn = nil
  self:ClearScroll()
  self.scroll_view = nil
  self.title1Text = nil
  self.leftTimeText = nil
  self.displayItem = nil
  self.curIndex = nil
  self.listGo = nil
  base.OnDestroy(self)
end

function UIVipRenewView:OnEnable()
  base.OnEnable(self)
end

function UIVipRenewView:OnDisable()
  base.OnDisable(self)
end

function UIVipRenewView:RefreshGold()
  if not table.IsNullOrEmpty(self.listGo) then
    for i, v in pairs(self.listGo) do
      if v then
        v:RefreshPriceTextColor()
      end
    end
  end
end

function UIVipRenewView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.VipDataRefresh, self.Refresh)
  self:AddUIListener(EventId.UpdateGold, self.RefreshGold)
  self:AddUIListener(EventId.UseItemSuccess, self.RefreshUsedItem)
end

function UIVipRenewView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.VipDataRefresh, self.Refresh)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshGold)
  self:RemoveUIListener(EventId.UseItemSuccess, self.RefreshUsedItem)
end

function UIVipRenewView:RefreshUsedItem(itemId)
  if self.curIndex ~= 0 and self.listGo[self.curIndex] then
    self.listGo[self.curIndex]:UpdateNum(self.list[self.curIndex])
  end
end

function UIVipRenewView:Refresh()
  self.vipInfo = DataCenter.VIPManager:GetVipData()
  self:SetValue()
  if self.vipInfo then
    if self.vipInfo.endTime and self.vipInfo.endTime > 0 then
      self.shouldUpdate = true
    else
      self.shouldUpdate = false
    end
  end
end

function UIVipRenewView:Update()
  if self.shouldUpdate then
    local showTime = false
    if self.vipInfo then
      local curTime = UITimeManager:GetInstance():GetServerSeconds()
      local endTime = self.vipInfo.endTime
      if endTime and 0 < endTime and curTime <= endTime then
        self.leftTimeText:SetLocalText(2000291, UITimeManager:GetInstance():SecondToFmtString(self.vipInfo.endTime - curTime))
        showTime = true
      end
    end
    if not showTime then
      self.leftTimeText:SetText("")
      self.shouldUpdate = false
    end
  end
end

function UIVipRenewView:ReInit()
  self.title_txt:SetLocalText(2000280)
  self.vipInfo = DataCenter.VIPManager:GetVipData()
  self:SetValue()
  self:RefreshData()
  if self.vipInfo then
    if self.vipInfo.endTime and self.vipInfo.endTime > 0 then
      self.shouldUpdate = true
    else
      self.leftTimeText:SetText("")
      self.shouldUpdate = false
    end
  end
end

function UIVipRenewView:SetValue()
end

function UIVipRenewView:RefreshData()
  self:ClearScroll()
  local idList = DataCenter.VIPManager:GetRenewGoodList()
  self.list = {}
  for i, v in ipairs(idList) do
    local itemData = {}
    itemData.id = v
    table.insert(self.list, itemData)
  end
  local monthCardInfo = DataCenter.MonthCardNewManager:GetGolloesMonthCard()
  if not monthCardInfo then
    local gotoMonthCardData = {}
    gotoMonthCardData.gotoMonthCard = 1
    table.insert(self.list, gotoMonthCardData)
  elseif not monthCardInfo:IsBought() then
    local gotoMonthCardData = {}
    gotoMonthCardData.gotoMonthCard = 1
    table.insert(self.list, gotoMonthCardData)
  end
  if self.list ~= nil then
    self.scroll_view:SetTotalCount(#self.list)
    self.scroll_view:RefillCells()
  end
end

function UIVipRenewView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(CellPointGood, itemObj)
  
  local function callBack(tempIndex)
    self:OnClickCallBack(tempIndex)
  end
  
  self.listGo[index] = cellItem
  cellItem:RefreshData(self.list[index], callBack, index)
end

function UIVipRenewView:OnClickCallBack(index)
  self.curIndex = index
end

function UIVipRenewView:OnItemMoveOut(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, CellPointGood)
  self.listGo[index] = nil
end

function UIVipRenewView:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(CellPointGood)
end

return UIVipRenewView
