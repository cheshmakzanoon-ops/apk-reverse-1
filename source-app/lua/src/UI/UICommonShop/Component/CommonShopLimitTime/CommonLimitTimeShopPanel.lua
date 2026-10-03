local base = UIBaseView
local CommonLimitTimeShopPanel = BaseClass("CommonLimitTimeShopPanel", base)
local Localization = CS.GameEntry.Localization
local CommonGoodsShopItem = require("UI.UICommonShop.Component.CommonShopGoods.CommonGoodsShopItem")
local UIGray = CS.UIGray
local svGoods_path = "Anim/ScrollView"
local content_path = "Anim/ScrollView/Content"
local anim_path = "Anim"
local refreshTip_path = "Anim/Top/refreshTip"
local refreshCd_path = "Anim/Top/refreshTip/refreshCd"
local refreshTimes_path = "Anim/Top/refresh/refreshTimes"
local refreshCost_path = "Anim/Top/refresh/refresh"
local refreshCostIcon_path = "Anim/Top/refresh/refresh/refreshCost/refreshIcon"
local refreshCostNum_path = "Anim/Top/refresh/refresh/refreshCost"
local refreshBtn_path = "Anim/Top/refreshBtn"
local freeContainer_path = "Anim/Top/refresh/free"
local freeTxt_path = "Anim/Top/refresh/free/freeTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DelRefreshCdTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.svGoodsN = self:AddComponent(UIScrollRect, svGoods_path)
  self.contentN = self:AddComponent(GridInfinityScrollView, content_path)
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.contentN:Init(bindFunc1, bindFunc2, bindFunc3)
  self.animN = self:AddComponent(UIAnimator, anim_path)
  self.refreshTipN = self:AddComponent(UIText, refreshTip_path)
  self.refreshTipN:SetText("")
  self.refreshCdN = self:AddComponent(UIText, refreshCd_path)
  self.refreshTimesN = self:AddComponent(UIText, refreshTimes_path)
  self.refreshCostN = self:AddComponent(UIBaseContainer, refreshCost_path)
  self.refreshCostIconN = self:AddComponent(UIImage, refreshCostIcon_path)
  self.refreshCostNumN = self:AddComponent(UIText, refreshCostNum_path)
  self.refreshBtnN = self:AddComponent(UIButton, refreshBtn_path)
  self.refreshBtnN:SetOnClick(function()
    self:OnClickRefreshBtn()
  end)
  self.freeContainerN = self:AddComponent(UIBaseContainer, freeContainer_path)
  self.freeTxtN = self:AddComponent(UIText, freeTxt_path)
  self.freeTxtN:SetLocalText(130126)
end

local function ComponentDestroy(self)
  self:ClearItemCell()
  self.contentN = nil
  self.animN = nil
  self.refreshTipN = nil
  self.refreshCdN = nil
  self.vipTipN = nil
  self.vipBtnN = nil
end

local function DataDefine(self)
  self.curShowType = nil
  self.goodsList = {}
  self.goodsItemsList = {}
  self.model = {}
  self.listGO = {}
  self.refreshCostDic = nil
end

local function DataDestroy(self)
  self.curShowType = nil
  self.goodsList = nil
  self.goodsItemsList = nil
  self.model = nil
  self.listGO = nil
  self.refreshCostDic = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateOneCommonShop, self.RefreshAll)
  self:AddUIListener(EventId.UpdateGold, self.RefreshAll)
  self:AddUIListener(EventId.RefreshItems, self.RefreshAll)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateOneCommonShop, self.RefreshAll)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshAll)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshAll)
  base.OnRemoveListener(self)
end

local function ShowPanel(self, shopType)
  self.curShowType = shopType
  self:RefreshAll()
end

local function RefreshAll(self, shopType)
  if shopType and shopType ~= self.curShowType then
    return
  end
  local k1 = LuaEntry.DataConfig:TryGetNum("shop_random", "k1")
  local refreshed = DataCenter.CommonShopManager:GetLimitShopRefreshTimes()
  self.refreshTimesN:SetText(Localization:GetString("372234", k1 - refreshed .. "/" .. k1))
  if not self.refreshCostDic then
    self.refreshCostDic = {}
    local strCost = LuaEntry.DataConfig:TryGetStr("shop_random", "k2")
    local arrCost = string.split(strCost, ";")
    for i, v in ipairs(arrCost) do
      if not string.IsNullOrEmpty(v) then
        self.refreshCostDic[i] = tonumber(v)
      end
    end
  end
  if self.refreshCostDic[refreshed + 1] then
    if self.refreshCostDic[refreshed + 1] == 0 then
      self.freeContainerN:SetActive(true)
      self.refreshCostN:SetActive(false)
    else
      self.freeContainerN:SetActive(false)
      self.refreshCostN:SetActive(true)
      self.refreshCostNumN:SetText(self.refreshCostDic[refreshed + 1])
      if self.refreshCostDic[refreshed + 1] < LuaEntry.Player.gold then
        self.refreshCostNumN:SetColor(WhiteColor)
      else
        self.refreshCostNumN:SetColor(RedColor)
      end
    end
  else
    self.freeContainerN:SetActive(false)
    self.refreshCostN:SetActive(false)
  end
  if k1 <= refreshed then
    UIGray.SetGray(self.refreshBtnN.transform, true, false)
  else
    UIGray.SetGray(self.refreshBtnN.transform, false, true)
  end
  self.refreshCdEndT = DataCenter.CommonShopManager:GetLimitShopNextRefreshTs()
  self:AddRefreshCdTimer()
  self:SetRefreshCd()
  self.goodsList = DataCenter.CommonShopManager:GetGoodsListByShopType(self.curShowType)
  self.contentN:SetItemCount(#self.goodsList)
end

local function OnInitScroll(self, go, index)
  local item = self.svGoodsN:AddComponent(CommonGoodsShopItem, go)
  self.listGO[go] = item
end

local function OnUpdateScroll(self, go, index)
  local conf = self.goodsList[index + 1]
  go.name = conf.id
  local cellItem = self.listGO[go]
  if not cellItem then
    return
  end
  cellItem:SetItem(self.goodsList[index + 1])
end

local function OnDestroyScrollItem(self, go, index)
end

local function ClearItemCell(self)
  self.svGoodsN:RemoveComponents(CommonGoodsShopItem)
  self.contentN:DestroyChildNode()
end

local function RefreshList(self)
  self:SetAllCellDestroy()
  local list = self.goodsList
  if list ~= nil then
    self.modelCount = 0
    for i = 1, table.length(list) do
      self.modelCount = self.modelCount + 1
      self.model[self.modelCount] = self:GameObjectInstantiateAsync(UIAssets.CommonGoodsShopItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.contentN.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.contentN:AddComponent(CommonGoodsShopItem, nameStr)
        cell:SetItem(list[i])
      end)
    end
  end
end

local function SetAllCellDestroy(self)
  self.contentN:RemoveComponents(CommonGoodsShopItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.svGoodsN:AddComponent(CommonGoodsShopItem, itemObj)
  cellItem:SetItem(self.goodsList[index])
end

local function OnItemMoveOut(self, itemObj, index)
  self.svGoodsN:RemoveComponent(itemObj.name, CommonGoodsShopItem)
end

local function AddRefreshCdTimer(self)
  function self.RefreshCdTimerAction()
    self:SetRefreshCd()
  end
  
  if self.refreshCdTimer == nil then
    self.refreshCdTimer = TimerManager:GetInstance():GetTimer(1, self.RefreshCdTimerAction, self, false, false, false)
  end
  self.refreshCdTimer:Start()
end

local function SetRefreshCd(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = math.ceil(self.refreshCdEndT - curTime)
  if 0 < remainTime then
    self.refreshCdN:SetText(Localization:GetString("104209", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)))
  else
    self.refreshCdN:SetText("")
    self:DelRefreshCdTimer()
    SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, self.curShowType)
  end
end

local function DelRefreshCdTimer(self)
  if self.refreshCdTimer ~= nil then
    self.refreshCdTimer:Stop()
    self.refreshCdTimer = nil
  end
end

local function OnClickRefreshBtn(self)
  local k3 = LuaEntry.DataConfig:TryGetNum("shop_random", "k1")
  local refreshed = DataCenter.CommonShopManager:GetLimitShopRefreshTimes()
  if k3 > refreshed then
    local refreshed = DataCenter.CommonShopManager:GetLimitShopRefreshTimes()
    local tempCost = self.refreshCostDic[refreshed + 1]
    
    local function callback()
      if tempCost <= LuaEntry.Player.gold then
        UIGray.SetGray(self.refreshBtnN.transform, true, false)
        SFSNetwork.SendMessage(MsgDefines.RefreshCommonShop, self.curShowType)
      else
        GoToUtil.GotoPayTips(tempCost)
      end
    end
    
    if 0 < tempCost then
      UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog, Localization:GetString(320490), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        callback()
      end)
    else
      callback()
    end
  end
end

CommonLimitTimeShopPanel.OnCreate = OnCreate
CommonLimitTimeShopPanel.OnDestroy = OnDestroy
CommonLimitTimeShopPanel.OnAddListener = OnAddListener
CommonLimitTimeShopPanel.OnRemoveListener = OnRemoveListener
CommonLimitTimeShopPanel.ComponentDefine = ComponentDefine
CommonLimitTimeShopPanel.ComponentDestroy = ComponentDestroy
CommonLimitTimeShopPanel.DataDefine = DataDefine
CommonLimitTimeShopPanel.DataDestroy = DataDestroy
CommonLimitTimeShopPanel.ShowPanel = ShowPanel
CommonLimitTimeShopPanel.RefreshAll = RefreshAll
CommonLimitTimeShopPanel.OnInitScroll = OnInitScroll
CommonLimitTimeShopPanel.OnUpdateScroll = OnUpdateScroll
CommonLimitTimeShopPanel.OnDestroyScrollItem = OnDestroyScrollItem
CommonLimitTimeShopPanel.ClearItemCell = ClearItemCell
CommonLimitTimeShopPanel.OnClickRefreshBtn = OnClickRefreshBtn
CommonLimitTimeShopPanel.OnItemMoveIn = OnItemMoveIn
CommonLimitTimeShopPanel.OnItemMoveOut = OnItemMoveOut
CommonLimitTimeShopPanel.AddRefreshCdTimer = AddRefreshCdTimer
CommonLimitTimeShopPanel.SetRefreshCd = SetRefreshCd
CommonLimitTimeShopPanel.DelRefreshCdTimer = DelRefreshCdTimer
CommonLimitTimeShopPanel.RefreshList = RefreshList
CommonLimitTimeShopPanel.SetAllCellDestroy = SetAllCellDestroy
return CommonLimitTimeShopPanel
