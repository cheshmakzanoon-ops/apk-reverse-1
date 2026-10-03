local base = UIBaseView
local CommonVipShopPanel = BaseClass("CommonVipShopPanel", base)
local Localization = CS.GameEntry.Localization
local CommonGoodsShopItem = require("UI.UICommonShop.Component.CommonShopVip.CommonVipShopItem")
local svGoods_path = "Anim/ScrollView"
local content_path = "Anim/ScrollView/Content"
local anim_path = "Anim"
local refreshTip_path = "Anim/Top/refreshTip"
local refreshCd_path = "Anim/Top/refreshTip/refreshCd"
local vipTip_path = "Anim/Top/vipLevel"
local vipBtn_path = "Anim/Top/infoBtn"

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
  self.refreshCdN = self:AddComponent(UIText, refreshTip_path)
  self.vipTipN = self:AddComponent(UIText, vipTip_path)
  self.vipBtnN = self:AddComponent(UIButton, vipBtn_path)
  self.vipBtnN:SetActive(false)
end

local function ComponentDestroy(self)
  if not IsNull(self.clickFingerHandle) then
    self.clickFingerHandle:Destroy()
    self.clickFingerHandle = nil
  end
  self:ClearItemCell()
  self.contentN = nil
  self.animN = nil
  self.refreshCdN = nil
  self.vipTipN = nil
  self.vipBtnN = nil
end

local function DataDefine(self)
  self.curShowType = nil
  self.goodsList = {}
  self.goodsItemsList = {}
  self.listGO = {}
  self.focusShopId = nil
  self.focusShopItemId = nil
end

local function DataDestroy(self)
  if self.delayCreateFingerTimer then
    self.delayCreateFingerTimer:Stop()
    self.delayCreateFingerTimer = nil
  end
  if self.delayDestroyFingerTimer then
    self.delayDestroyFingerTimer:Stop()
    self.delayDestroyFingerTimer = nil
  end
  self.curShowType = nil
  self.goodsList = nil
  self.goodsItemsList = nil
  self.listGO = nil
  self.focusShopId = nil
  self.focusShopItemId = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateOneCommonShop, self.OnUpdateCommonShop)
  self:AddUIListener(EventId.UpdateGold, self.RefreshAll)
  self:AddUIListener(EventId.RefreshItems, self.RefreshAll)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateOneCommonShop, self.OnUpdateCommonShop)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshAll)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshAll)
  base.OnRemoveListener(self)
end

local function ShowPanel(self, shopType, focusShopId)
  self.curShowType = shopType
  if self.refresh_time_root ~= nil then
    self.refresh_time_root:SetActive(true)
    self.refresh_time_title:SetLocalText("shop_cycle_tips_01")
    self.refresh_time_txt:SetText("")
  end
  self.focusShopId = focusShopId
  self:RefreshAll()
end

local function RefreshAll(self, shopType, focusShopId)
  if shopType and shopType ~= self.curShowType then
    return
  end
  local vipInfo = DataCenter.VIPManager:GetVipData()
  self.vipTipN:SetLocalText("104211", vipInfo.level)
  local nextWeek = UITimeManager:GetInstance():GetNextWeekDay(1)
  self.refreshCdEndT = nextWeek
  self:AddRefreshCdTimer()
  self:SetRefreshCd()
  local focusItemIndex
  if focusShopId then
    self.focusShopItemId = focusShopId
    for i, v in ipairs(self.goodsList) do
      if v.id == focusShopId then
        focusItemIndex = i
        break
      end
    end
    self:HandleFocusShopItemGuide()
  end
  self.goodsList = DataCenter.CommonShopManager:GetGoodsListByShopType(self.curShowType)
  self.contentN:SetItemCount(#self.goodsList)
  if focusItemIndex then
    self.contentN.gameObject.transform:Set_anchoredPosition(0, 0)
    self.contentN:MoveItemByIndex(focusItemIndex - 1, 0.5)
  end
end

local function OnInitScroll(self, go, index)
  local item = self.svGoodsN:AddComponent(CommonGoodsShopItem, go)
  self.listGO[go] = item
end

local function OnUpdateScroll(self, go, index)
  local conf = self.goodsList[index + 1]
  if conf == nil then
    return
  end
  go.name = conf.id
  local cellItem = self.listGO[go]
  if not cellItem then
    return
  end
  cellItem:SetItem(self.goodsList[index + 1])
  cellItem:SetActive(true)
end

local function OnDestroyScrollItem(self, go, index)
end

local function ClearItemCell(self)
  self.svGoodsN:RemoveComponents(CommonGoodsShopItem)
  self.contentN:DestroyChildNode()
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
  if not self:GetActive() then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = math.ceil(self.refreshCdEndT - curTime)
  if 0 < remainTime then
    local time_txt = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
    self.refreshCdN:SetText(Localization:GetString("2000273", time_txt))
    if self.refresh_time_txt ~= nil then
      self.refresh_time_txt:SetText(time_txt)
    end
  else
    self.refreshCdN:SetText("")
    if self.refresh_time_txt ~= nil then
      self.refresh_time_txt:SetText("00:00:00")
    end
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

local function OnClickVipBtn(self)
  local mgr = DataCenter.LWFunctionUnlockManager
  local unlock = mgr:CheckCanShow(LWFunctionUnlockType.MainUI_VIP)
  if unlock then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVip, {anim = true, hideTop = true})
  else
    UIUtil.ShowTips(Localization:GetString("320269", k3))
  end
end

function CommonVipShopPanel:SetNodeList(refresh_time_root, refresh_time_title, refresh_time_txt, spe_res_num)
  self.refresh_time_root = refresh_time_root
  self.refresh_time_title = refresh_time_title
  self.refresh_time_txt = refresh_time_txt
  self.spe_res_num = spe_res_num
end

function CommonVipShopPanel:OnUpdateCommonShop(shopType)
  self:RefreshAll(shopType, self.focusShopId)
  self.focusShopId = nil
end

function CommonVipShopPanel:GetCellItemByShopId(id)
  if self.listGO then
    for i, v in pairs(self.listGO) do
      if v.goodsConf and v.goodsConf.id == id then
        return v
      end
    end
  end
end

function CommonVipShopPanel:HandleFocusShopItemGuide()
  if self.focusShopItemId then
    local focusShopItemId = self.focusShopItemId
    self.delayCreateFingerTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.clickFingerHandle = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger.prefab")
      self.clickFingerHandle:completed("+", function(handle)
        if handle.isError then
          return
        end
        CommonUtil.CallAutoArabicMirrorManually(handle)
        local gameObject = handle.gameObject
        local transform = gameObject.transform
        transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Normal.Name).transform, false)
        transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local item = self:GetCellItemByShopId(focusShopItemId)
        if item and item.goodsItemN then
          transform.position = item.goodsItemN.transform.position
        end
        self.delayDestroyFingerTimer = TimerManager:GetInstance():DelayInvoke(function()
          if self.clickFingerHandle then
            self.clickFingerHandle:Destroy()
            self.clickFingerHandle = nil
          end
        end, 1)
      end)
    end, 1)
    self.focusShopItemId = nil
  end
end

CommonVipShopPanel.OnCreate = OnCreate
CommonVipShopPanel.OnDestroy = OnDestroy
CommonVipShopPanel.OnAddListener = OnAddListener
CommonVipShopPanel.OnRemoveListener = OnRemoveListener
CommonVipShopPanel.ComponentDefine = ComponentDefine
CommonVipShopPanel.ComponentDestroy = ComponentDestroy
CommonVipShopPanel.DataDefine = DataDefine
CommonVipShopPanel.DataDestroy = DataDestroy
CommonVipShopPanel.ShowPanel = ShowPanel
CommonVipShopPanel.RefreshAll = RefreshAll
CommonVipShopPanel.OnInitScroll = OnInitScroll
CommonVipShopPanel.OnUpdateScroll = OnUpdateScroll
CommonVipShopPanel.OnDestroyScrollItem = OnDestroyScrollItem
CommonVipShopPanel.ClearItemCell = ClearItemCell
CommonVipShopPanel.OnClickVipBtn = OnClickVipBtn
CommonVipShopPanel.AddRefreshCdTimer = AddRefreshCdTimer
CommonVipShopPanel.SetRefreshCd = SetRefreshCd
CommonVipShopPanel.DelRefreshCdTimer = DelRefreshCdTimer
return CommonVipShopPanel
