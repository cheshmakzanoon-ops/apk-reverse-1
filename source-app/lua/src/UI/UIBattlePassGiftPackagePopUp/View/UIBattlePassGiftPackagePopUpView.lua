local UIBattlePassGiftPackagePopUpView = BaseClass("UIBattlePassGiftPackagePopUpView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local close_path = "Close"
local back_path = "UIScrollPackContent/CloseBtn"
local bg_path = "UIScrollPackContent/Bg"
local title_path = "UIScrollPackContent/Title"
local title1_path = "UIScrollPackContent/Title1"
local title2_path = "UIScrollPackContent/Title2"
local time_path = "UIScrollPackContent/TimeBg/Time"
local scroll_view_path = "UIScrollPackContent/ScrollView"
local buy_btn_path = "UIScrollPackContent/BuyButton"
local buy_text_path = "UIScrollPackContent/BuyButton/BuyButtonText"
local point_path = "UIScrollPackContent/BuyButton/UIGiftPackagePoint"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:DeleteTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.close_btn = self:AddComponent(UIButton, close_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.back_btn = self:AddComponent(UIButton, back_path)
  self.back_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.bg_image = self:AddComponent(UIImage, bg_path)
  self.title_text = self:AddComponent(UIText, title_path)
  self.title1_txt = self:AddComponent(UIText, title1_path)
  self.title2_txt = self:AddComponent(UIText, title2_path)
  self._time_txt = self:AddComponent(UIText, time_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
  self.buy_btn:SetOnClick(function()
    self:OnBuyClick()
  end)
  self.buy_btn:SetSafeClickMode(true)
  self.buy_text = self:AddComponent(UIText, buy_text_path)
  self.point_rect = self:AddComponent(UIGiftPackagePoint, point_path)
end

local function ComponentDestroy(self)
  self.bg_image = nil
  self.title_text = nil
  self._time_txt = nil
  self.scroll_view = nil
  self.buy_btn = nil
  self.buy_text = nil
  self.point_rect = nil
end

local function DataDefine(self)
  self.rewardList = nil
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime(temp)
  end
  
  self.packageInfo = nil
end

local function DataDestroy(self)
  self.rewardList = nil
  self.timer_action = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActBattlePassRefresh, self.ReInit)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActBattlePassRefresh, self.ReInit)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  self.actId = self:GetUserData()
  self.actData = DataCenter.ActBattlePassData:GetInfoByActId(self.actId)
  if self.actData == nil then
    return
  end
  self.packageInfo = GiftPackageData.get(self.actData:GetExchangeId())
  if self.packageInfo and self.actData.battlePass.unlock == 0 then
    self.buy_btn:SetActive(true)
    local price = DataCenter.PayManager:GetDollarText(self.packageInfo:getPrice(), self.packageInfo:getProductID())
    self.buy_text:SetText(price)
    self.point_rect:RefreshPoint(self.packageInfo)
    self.title_text:SetLocalText("320002", string.format("%s%%", self.packageInfo:getPercent()))
    self.title1_txt:SetText(self.packageInfo:getDescText())
  else
    self.buy_btn:SetActive(false)
    self.title_text:SetText("")
    self.title1_txt:SetText("")
  end
  self:ShowCells()
end

local function ShowCells(self)
  self.rewardList = self.actData:CheckLvGetReward(1, 1, true)
  if self.packageInfo then
    local exchangeReward = self.packageInfo:getItems(true)
    if not table.IsNullOrEmpty(exchangeReward) then
      for i, v in pairs(exchangeReward) do
        table.insert(self.rewardList, i, v)
      end
    end
  end
  local count = table.count(self.rewardList)
  if 0 < count then
    self.scroll_view:SetTotalCount(count)
    self.scroll_view:RefillCells()
  end
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UICommonResItem)
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  itemObj.transform:Set_localScale(1, 1, 1)
  local item = self.scroll_view:AddComponent(UICommonResItem, itemObj)
  item:ReInit(self.rewardList[index])
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UICommonResItem)
end

local function AddTimer(self, actListData)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, actListData, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self, actListData)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > actListData.endTime then
    self:DeleteTimer()
  else
    local timeRemaining = actListData.endTime - curTime
    self._time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(timeRemaining))
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function OnBuyClick(self)
  if self.packageInfo then
    if self.packageInfo.tryShowBuyAlertCondition ~= nil then
      self.packageInfo:tryShowBuyAlertCondition(function()
        if self.packageInfo == nil then
          return
        end
        if self.actId == nil then
          return
        end
        DataCenter.PayManager:CallPayment(self.packageInfo, UIWindowNames.UIBattlePassGiftPackagePopUp, nil, self.actId)
        self.ctrl:CloseSelf()
      end)
    else
      DataCenter.PayManager:CallPayment(self.packageInfo, UIWindowNames.UIBattlePassGiftPackagePopUp, nil, self.actId)
      self.ctrl:CloseSelf()
    end
  end
end

UIBattlePassGiftPackagePopUpView.OnCreate = OnCreate
UIBattlePassGiftPackagePopUpView.OnDestroy = OnDestroy
UIBattlePassGiftPackagePopUpView.ComponentDefine = ComponentDefine
UIBattlePassGiftPackagePopUpView.DataDefine = DataDefine
UIBattlePassGiftPackagePopUpView.DataDestroy = DataDestroy
UIBattlePassGiftPackagePopUpView.OnAddListener = OnAddListener
UIBattlePassGiftPackagePopUpView.OnRemoveListener = OnRemoveListener
UIBattlePassGiftPackagePopUpView.ReInit = ReInit
UIBattlePassGiftPackagePopUpView.ShowCells = ShowCells
UIBattlePassGiftPackagePopUpView.ClearScroll = ClearScroll
UIBattlePassGiftPackagePopUpView.OnCreateCell = OnCreateCell
UIBattlePassGiftPackagePopUpView.OnDeleteCell = OnDeleteCell
UIBattlePassGiftPackagePopUpView.OnBuyClick = OnBuyClick
UIBattlePassGiftPackagePopUpView.OnEnable = OnEnable
UIBattlePassGiftPackagePopUpView.OnDisable = OnDisable
UIBattlePassGiftPackagePopUpView.ComponentDestroy = ComponentDestroy
UIBattlePassGiftPackagePopUpView.AddTimer = AddTimer
UIBattlePassGiftPackagePopUpView.RefreshTime = RefreshTime
UIBattlePassGiftPackagePopUpView.DeleteTimer = DeleteTimer
return UIBattlePassGiftPackagePopUpView
