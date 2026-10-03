local UIResourceExchangeView = BaseClass("UIResourceExchangeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UICommonResItem = require("UI.UIResourceExchange.Component.UIResourceExchangeCell")
local title_path = "UICommonMiniPopUpTitle/titleText"
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local close_btn_path = "UICommonMiniPopUpTitle/CloseBtn"
local btn_2_path = "BtnGo/RightBtn"
local btn_2_txt_path = "BtnGo/RightBtn/RightBtnName"
local icon1_path = "UICommonResItem1"
local count1_text_path = "UICommonResItem1/clickBtn/NumText"
local icon2_path = "UICommonResItem2"
local name2_text_path = "UICommonResItem2/NameText2"
local slider_path = "Slider"
local add_btn_path = "AddButton"
local sub_btn_path = "ReduceButton"
local curNum_txt_path = "Txt_CurNum"
local tips_txt_path = "Txt_Tips"

local function OnCreate(self)
  base.OnCreate(self)
  self.title = self:AddComponent(UIText, title_path)
  self.btn_2 = self:AddComponent(UIButton, btn_2_path)
  self.btn_2_txt = self:AddComponent(UIText, btn_2_txt_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.icon = self:AddComponent(UICommonResItem, icon1_path)
  self.count_text = self:AddComponent(UIText, count1_text_path)
  self.name2_text = self:AddComponent(UIText, name2_text_path)
  self.exchangeIcon = self:AddComponent(UICommonResItem, icon2_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider:SetOnValueChanged(function(value)
    self:OnValueChange(value)
  end)
  self.add_btn = self:AddComponent(UIButton, add_btn_path)
  self.add_btn:SetOnClick(function()
    self:OnAdd()
  end)
  self.sub_btn = self:AddComponent(UIButton, sub_btn_path)
  self.sub_btn:SetOnClick(function()
    self:OnSub()
  end)
  self._curNum_txt = self:AddComponent(UIText, curNum_txt_path)
  self.tips_txt = self:AddComponent(UIText, tips_txt_path)
  self:SetData(self:GetUserData())
end

local function OnDestroy(self)
  self.titleText = nil
  self.tipText = nil
  self.text1 = nil
  self.text2 = nil
  self.action1 = nil
  self.closeAction = nil
  self.action2 = nil
  self.title = nil
  self.btn_2 = nil
  self.btn_2_txt = nil
  self.close_btn = nil
  self.return_btn = nil
  self._curNum_txt = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetData(self, tipText, text2, action2, closeAction, titleText, item1, item2)
  self.titleText = titleText
  self.tipText = tipText
  self.text2 = text2
  self.closeAction = closeAction
  self.action2 = action2
  self.OnCloseClick = false
  self.item = item1
  self.exchangeItem = item2
  self:RefreshData()
end

local function RefreshData(self)
  if self.titleText ~= nil and self.titleText ~= "" then
    self.title:SetLocalText(self.titleText)
  else
    self.title:SetLocalText(100378)
  end
  if self.btn_2:GetActive() then
    if self.action2 then
      self.btn_2:SetOnClick(function()
        self:OnCloseInTimer()
        self.action2()
      end)
    else
      self.btn_2:SetOnClick(function()
        self:OnClickFunc()
      end)
    end
    if self.text2 ~= nil and self.text2 ~= "" then
      self.btn_2_txt:SetLocalText(self.text2)
    else
      self.btn_2_txt:SetLocalText(GameDialogDefine.CANCEL)
    end
  end
  if self.closeAction then
    self.close_btn:SetOnClick(function()
      self:OnCloseInTimer()
      self.closeAction()
    end)
    self.return_btn:SetOnClick(function()
      self:OnCloseInTimer()
      self.closeAction()
    end)
  else
    self.close_btn:SetOnClick(function()
      self.ctrl:CloseSelf()
    end)
    self.return_btn:SetOnClick(function()
      self.ctrl:CloseSelf()
    end)
  end
  if self.item then
    self.icon:SetActive(true)
    self.icon:ReInit(self.item)
    self.exchangeIcon:ReInit(self.exchangeItem)
  else
    self.icon:SetActive(false)
  end
  self.minValue = 1
  local item = DataCenter.ItemData:GetItemById(self.item.itemId)
  if item then
    self.maxNum = item.count
  end
  self:RefreshSlider(self.item.count)
  self:SetItemName(self.item.count)
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.item.itemId)
  local str = Localization:GetString(goods.name)
  if self.item.exchangeType == 1 then
    for i, v in pairs(goods.name_value) do
      str = Localization:GetString(i, string.GetFormattedSeperatorNum(tonumber(goods.para)))
    end
  elseif self.item.exchangeType == 2 then
    str = Localization:GetString(goods.name)
  end
  if self.exchangeItem.rewardType == RewardType.RESOURCE_ITEM then
    local name = DataCenter.RewardManager:GetNameByType(self.exchangeItem.rewardType, self.exchangeItem.itemId)
    self.tips_txt:SetLocalText(143588, str, name)
  else
    local name = ResourceTypeTxt[self.exchangeItem.rewardType]
    self.tips_txt:SetLocalText(143588, str, Localization:GetString(name))
  end
  self.curNum = self.item.count
end

local function OnValueChange(self, val)
  local cnt = math.floor(val * (self.maxNum - self.minValue) + self.minValue + 0.5)
  self._curNum_txt:SetText(cnt)
  self:SetCountText(cnt)
  self:SetItemName(cnt)
end

local function OnAdd(self)
  local value = self.slider:GetValue()
  local cnt = math.floor(value * (self.maxNum - self.minValue) + self.minValue + 0.5)
  if self:CheckChange(cnt + 1) then
    self:RefreshSlider(cnt + 1)
  end
end

local function OnSub(self)
  local value = self.slider:GetValue()
  local cnt = math.floor(value * (self.maxNum - self.minValue) + self.minValue + 0.5)
  if self:CheckChange(cnt - 1) then
    self:RefreshSlider(cnt - 1)
  end
end

local function CheckChange(self, willNun)
  if willNun >= self.minValue and willNun <= self.maxNum then
    return true
  end
  return false
end

local function RefreshSlider(self, num)
  local percent = (num - self.minValue) / math.max(self.maxNum - self.minValue, 1)
  self.slider:SetValue(percent)
end

local function SetItemName(self, value)
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.item.itemId)
  self.curNum = value
  self.name2_text:SetText(string.GetFormattedSeperatorNum(self.exchangeItem.scale * value))
end

local function SetCountText(self, value)
  self.icon:SetItemCount(value)
end

local function OnClickFunc(self)
  if self.curNum then
    if self.exchangeItem.rewardType == RewardType.RESOURCE_ITEM and DataCenter.ResourceItemDataManager:CheckIsStorageFull(self.curNum * self.exchangeItem.scale) then
      self.ctrl:CloseSelf()
      GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
      return
    end
    if self.item.isRefresh then
      local param1 = {}
      param1.tips = self.item.tips
      param1.count = self.item.lacktab.disNum - self.curNum * self.exchangeItem.scale
      param1.useCount = self.maxNum - self.curNum
      param1.type = self.item.lacktab.resType
      DataCenter.ResLackManager:SetRefreshParam(param1)
    end
    if self.item.exchangeType == 1 then
      local item = DataCenter.ItemData:GetItemById(self.item.itemId)
      if item then
        SFSNetwork.SendMessage(MsgDefines.ItemUse, {
          uuid = item.uuid,
          num = self.curNum
        })
      end
    elseif self.item.exchangeType == 2 then
      local param = {}
      param.index = self.item.index
      param.useItemCount = self.curNum
      param.useFree = false
      SFSNetwork.SendMessage(MsgDefines.BuyInKonbini, param)
    elseif self.item.exchangeType == 3 then
      SFSNetwork.SendMessage(MsgDefines.ItemUse, {
        uuid = self.item.uuid,
        num = self.curNum,
        para1 = tostring(self.item.selectIndex)
      })
    end
  end
  self.ctrl:CloseSelf()
end

local function OnCloseInTimer(self)
  self.OnCloseClick = true
  local closeTimer = TimerManager:GetInstance():GetTimer(0.1, function()
    if self.OnCloseClick and self.ctrl then
      self.ctrl:CloseSelf()
    end
  end, nil, true, false, false)
  closeTimer:Start()
end

UIResourceExchangeView.OnCreate = OnCreate
UIResourceExchangeView.OnDestroy = OnDestroy
UIResourceExchangeView.OnEnable = OnEnable
UIResourceExchangeView.OnDisable = OnDisable
UIResourceExchangeView.SetData = SetData
UIResourceExchangeView.RefreshData = RefreshData
UIResourceExchangeView.RefreshItem = RefreshItem
UIResourceExchangeView.OnCloseInTimer = OnCloseInTimer
UIResourceExchangeView.SetItemIconImage = SetItemIconImage
UIResourceExchangeView.SetItemQualityImage = SetItemQualityImage
UIResourceExchangeView.SetFlagActive = SetFlagActive
UIResourceExchangeView.SetFlagText = SetFlagText
UIResourceExchangeView.SetItemName = SetItemName
UIResourceExchangeView.SetCountText = SetCountText
UIResourceExchangeView.OnBtnClick = OnBtnClick
UIResourceExchangeView.OnValueChange = OnValueChange
UIResourceExchangeView.OnAdd = OnAdd
UIResourceExchangeView.OnSub = OnSub
UIResourceExchangeView.CheckChange = CheckChange
UIResourceExchangeView.RefreshSlider = RefreshSlider
UIResourceExchangeView.OnClickFunc = OnClickFunc
return UIResourceExchangeView
