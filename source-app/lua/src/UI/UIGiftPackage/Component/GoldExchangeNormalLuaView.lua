local UIGiftPackageCell = require("UI.UIGiftPackage.Component.UIGiftPackageCell")
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local GoldExchangeNormalLuaView = BaseClass("GoldExchangeNormalLuaView", UIBaseContainer)
local base = UIBaseContainer
local picPathName1 = "Assets/Main/TextureEx/GiftPackage/%s/%s_beijing1"
local defaultPicPath = "Picture_tongyonglibao"
local Localization = CS.GameEntry.Localization
local Timer = CS.GameEntry.Timer
local image_path = "ImgBg"
local title_name_path = "Name/TxtName"
local time_path = "TopInfo/TxtCd"
local desc_path = "TopInfo/TxtDesc"
local cur_price_path = "Bottom/Button/TxtPrice2"
local buy_btn_path = "Bottom/Button"
local scroll_view_path = "CellScroll"
local img_desc_path = "TopInfo/ImgDesc"
local _cp_discountBg = "TopInfo/discountBg"
local _cp_txtdiscount = "TopInfo/discountBg/txtDiscount"
local discountTip1_path = "Bottom/LimitText"
local point_path = "Bottom/Button/UIGiftPackagePoint"
local buyConditionText_path = "Bottom/BuyConditionText"
local lineBgName = {
  ["1"] = "UI_packstore_bg_purple",
  ["2"] = "UI_packstore_bg_blue",
  ["3"] = "UI_packstore_bg_orange"
}
local TypeColor = {
  OrangeYellowColor,
  GreenColor,
  RedColor
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.image = self:AddComponent(UIImage, image_path)
  self.title_name = self:AddComponent(UIText, title_name_path)
  self.time = self:AddComponent(UIText, time_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.cur_price = self:AddComponent(UIText, cur_price_path)
  self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
  self.img_desc = self:AddComponent(UIImage, img_desc_path)
  self._discountBg = self:AddComponent(UIBaseContainer, _cp_discountBg)
  self._txtdiscount = self:AddComponent(UIText, _cp_txtdiscount)
  self.discountTip1 = self:AddComponent(UIText, discountTip1_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.buy_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.view.ctrl:BuyGift(self.param.info)
  end)
  self.buy_btn:SetSafeClickMode(true)
  self.point_rect = self:AddComponent(UIGiftPackagePoint, point_path)
  self.textBuyCondition = self:AddComponent(UIText, buyConditionText_path)
  self.textBuyCondition:SetActive(false)
end

local function ComponentDestroy(self)
  self.image = nil
  self.title_name = nil
  self.time = nil
  self.desc = nil
  self.money = nil
  self.cur_price = nil
  self.buy_btn = nil
  self.scroll_view = nil
  self.img_desc = nil
  self.point_rect = nil
  self.textBuyCondition = nil
end

local function DataDefine(self)
  self.param = {}
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self.timeValue = nil
  self.buyBtnEnable = nil
  self.listParam = {}
  self.position = nil
  self.needTrans = nil
  self.imgColor = nil
end

local function DataDestroy(self)
  self.param = nil
  self.timer_action = nil
  self:DeleteTimer()
  self.timeValue = nil
  self.buyBtnEnable = nil
  self.listParam = nil
  self.position = nil
  self.needTrans = nil
  self.imgColor = nil
end

local function ReInit(self, param)
  self.param = param
  local info = self.param.info
  self.title_name:SetLocalText(info:getName())
  self.pngName1 = string.format(picPathName1, info:getUIKey(), info:getUIKey())
  self:LoadImage()
  self.cur_price:SetText(DataCenter.PayManager:GetDollarText(info:getPrice(), info:getProductID()))
  local _descText = info:getDescText()
  if _descText ~= nil and _descText ~= "" then
    self.desc:SetText(_descText)
  end
  self.point_rect:RefreshPoint(info)
  local discountTips = info:GetDiscountTips()
  if discountTips and discountTips[3] then
    self._discountBg:SetActive(true)
    self._txtdiscount:SetText(discountTips[3])
  else
    local hasPercent = info:hasPercent()
    if hasPercent then
      self._discountBg:SetActive(true)
      self._txtdiscount:SetLocalText("giftpackage_value", info:getPercent())
    else
      self._discountBg:SetActive(false)
    end
  end
  self:RefreshTime()
  if self.param.info:getTimeType() ~= PackTimeType.AlwaysHideTime then
    self:AddTimer()
  end
  self:ShowAllCells()
  local isBuyConditionOk = true
  local inconsistentConditions
  if self.param.info.getInconsistentBuyConditions then
    inconsistentConditions = self.param.info:getInconsistentBuyConditions()
    if not table.IsNullOrEmpty(inconsistentConditions) then
      isBuyConditionOk = false
    end
  end
  if not isBuyConditionOk then
    self.buy_btn:SetActive(false)
    self.textBuyCondition:SetActive(true)
    self.textBuyCondition:SetText(DataCenter.RewardManager:ConvertBuyConditionToText(inconsistentConditions[1]))
  else
    self.buy_btn:SetActive(true)
    self.textBuyCondition:SetActive(false)
  end
end

local function ShowArrow(self)
  local param = {}
  param.position = self.buy_btn.transform.position
  param.arrowType = ArrowType.Normal
  param.positionType = PositionType.Screen
  TimerManager:GetInstance():DelayInvoke(function()
    DataCenter.ArrowManager:ShowArrow(param)
  end, 0.1)
end

local function LoadImage(self)
  local bgParam = self.param.info:getPopupImageMini()
  if not string.IsNullOrEmpty(bgParam) then
    self.image:LoadSprite(bgParam)
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  if self.param.info:getTimeType() == PackTimeType.AlwaysHideTime then
    self:SetTime("")
    self:SetBuyButtonEnable(true)
    return
  end
  local curTime = Timer:GetServerTime()
  local leftTime, b2 = math.modf(self.param.info:getEndTime() - curTime)
  if 0 <= leftTime then
    self:SetTime(Timer:MilliSecondToFmtString(leftTime))
    self:SetBuyButtonEnable(true)
  else
    self:SetTime(Localization:GetString("120077"))
    self:SetBuyButtonEnable(false)
  end
end

local function SetBuyButtonEnable(self, value)
  if self.buyBtnEnable ~= value then
    self.buyBtnEnable = value
    self.buy_btn:SetInteractable(value)
  end
end

local function SetTime(self, value)
  if self.timeValue ~= value then
    self.timeValue = value
    self.time:SetText(value)
  end
end

local function ShowAllCells(self)
  self:GetCellsList()
  self:ClearScroll()
  if #self.listParam > 0 then
    self.scroll_view:SetTotalCount(#self.listParam)
    self.scroll_view:RefillCells()
  end
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(UIGiftPackageCell, itemObj)
  cellItem:ReInit(self.listParam[index])
end

function GoldExchangeNormalLuaView:CreateHeroCell()
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIGiftPackageCell)
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIGiftPackageCell)
end

local function GetCellsList(self)
  local info = self.param.info
  self.listParam = info:getItems(true)
end

local function OnBeginDrag(self, eventData)
  self.needTrans = nil
  self.position = eventData.position
  if self.param.scrollView ~= nil then
    self.param.scrollView:OnBeginDrag(eventData)
  end
  self.scroll_view:OnBeginDrag(eventData)
end

local function OnEndDrag(self, eventData)
  self.needTrans = nil
  if self.param.scrollView ~= nil then
    self.param.scrollView:OnEndDrag(eventData)
  end
  self.scroll_view:OnEndDrag(eventData)
end

local function OnDrag(self, eventData)
  if self.needTrans == nil then
    local X = math.abs(eventData.position.x - self.position.x)
    local Y = math.abs(eventData.position.y - self.position.y)
    if X > Y then
      self.needTrans = true
    elseif X < Y then
      self.needTrans = false
    end
  end
  if self.needTrans ~= nil then
    if self.needTrans then
      if self.param.scrollView ~= nil then
        self.param.scrollView:OnDrag(eventData)
      end
    else
      self.scroll_view:OnDrag(eventData)
    end
  end
end

local function SetImgColor(self, value)
  if self.imgColor ~= value then
    self.imgColor = value
    self.img_desc:SetColor(value)
  end
end

GoldExchangeNormalLuaView.OnCreate = OnCreate
GoldExchangeNormalLuaView.OnDestroy = OnDestroy
GoldExchangeNormalLuaView.ReInit = ReInit
GoldExchangeNormalLuaView.ComponentDefine = ComponentDefine
GoldExchangeNormalLuaView.ComponentDestroy = ComponentDestroy
GoldExchangeNormalLuaView.DataDefine = DataDefine
GoldExchangeNormalLuaView.DataDestroy = DataDestroy
GoldExchangeNormalLuaView.LoadImage = LoadImage
GoldExchangeNormalLuaView.AddTimer = AddTimer
GoldExchangeNormalLuaView.DeleteTimer = DeleteTimer
GoldExchangeNormalLuaView.RefreshTime = RefreshTime
GoldExchangeNormalLuaView.SetBuyButtonEnable = SetBuyButtonEnable
GoldExchangeNormalLuaView.SetTime = SetTime
GoldExchangeNormalLuaView.GetCellsList = GetCellsList
GoldExchangeNormalLuaView.ShowAllCells = ShowAllCells
GoldExchangeNormalLuaView.ClearScroll = ClearScroll
GoldExchangeNormalLuaView.OnCreateCell = OnCreateCell
GoldExchangeNormalLuaView.OnDeleteCell = OnDeleteCell
GoldExchangeNormalLuaView.ShowArrow = ShowArrow
GoldExchangeNormalLuaView.OnDrag = OnDrag
GoldExchangeNormalLuaView.OnEndDrag = OnEndDrag
GoldExchangeNormalLuaView.OnBeginDrag = OnBeginDrag
GoldExchangeNormalLuaView.SetImgColor = SetImgColor
return GoldExchangeNormalLuaView
