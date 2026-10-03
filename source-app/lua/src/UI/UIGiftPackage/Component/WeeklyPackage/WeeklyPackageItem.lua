local GolloesCampItem = BaseClass("GolloesCampItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGiftItem = require("UI.UIGiftPackage.Component.UIGiftItem")
local UIGray = CS.UIGray
local packageIcon_path = "Image/packageIcon"
local isHot_path = "Image/isHot"
local isHotTxt_path = "Image/isHot/isHotTxt"
local discount_path = "Image/discount"
local discountTxt_path = "Image/discount/discountTxt"
local limitTip_path = "Image/limit"
local buyBtn_path = "Image/Button"
local buyBtnTxt_path = "Image/Button/TxtPrice2"
local freeBtn_path = "Image/BuyBtn"
local freeBtnTxt_path = "Image/BuyBtn/BuyText"
local mask_path = "Image/mask"
local soldOutBg_path = "Image/boughBg"
local soldOut_path = "Image/boughBg/bought"
local rewards_path = "Image/ItemGroup/rewardItem%s/SmallItem%s"
local freeRedPoint_path = "Image/redDot"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.packageIconN = self:AddComponent(UIImage, packageIcon_path)
  self.isHotN = self:AddComponent(UIBaseContainer, isHot_path)
  self.isHotTxtN = self:AddComponent(UIText, isHotTxt_path)
  self.discountN = self:AddComponent(UIBaseContainer, discount_path)
  self.discountTxtN = self:AddComponent(UIText, discountTxt_path)
  self.limitTipN = self:AddComponent(UIText, limitTip_path)
  self.buyBtnN = self:AddComponent(UIButton, buyBtn_path)
  self.buyBtnImg = self:AddComponent(UIImage, buyBtn_path)
  self.buyBtnN:SetOnClick(function()
    self:OnClickBuyBtn()
  end)
  self.buyBtnN:SetSafeClickMode(true)
  self.buyBtnTxtN = self:AddComponent(UIText, buyBtnTxt_path)
  self.freeBtnN = self:AddComponent(UIButton, freeBtn_path)
  self.freeBtnImg = self:AddComponent(UIImage, freeBtn_path)
  self.freeBtnN:SetOnClick(function()
    self:OnClickCliamFreePackage()
  end)
  self.freeBtnTxtN = self:AddComponent(UIText, freeBtnTxt_path)
  self.soldOutBgN = self:AddComponent(UIBaseContainer, soldOutBg_path)
  self.maskN = self:AddComponent(UIBaseContainer, mask_path)
  self.soldOutN = self:AddComponent(UIText, soldOut_path)
  self.soldOutN:SetLocalText(320268)
  self.freeBtnTxt_shadow = self:AddComponent(UIShadow, freeBtnTxt_path)
  self.discountTxt_shadow = self:AddComponent(UIShadow, discountTxt_path)
  self.isHotTxt_shadow = self:AddComponent(UIShadow, isHotTxt_path)
  self.buyBtnTxt_shadow = self:AddComponent(UIShadow, buyBtnTxt_path)
  self.rewardsTbN = {}
  for i = 1, 3 do
    local rewardItem = self:AddComponent(UIGiftItem, string.format(rewards_path, i, i))
    table.insert(self.rewardsTbN, rewardItem)
  end
  self.freeRedPointN = self:AddComponent(UIBaseContainer, freeRedPoint_path)
end

local function ComponentDestroy(self)
  self.packageIconN = nil
  self.isHotN = nil
  self.isHotTxtN = nil
  self.discountN = nil
  self.discountTxtN = nil
  self.limitTipN = nil
  self.buyBtnN = nil
  self.buyBtnTxtN = nil
  self.maskN = nil
  self.soldOutN = nil
  self.rewardsTbN = nil
  self.soldOutBgN = nil
end

local function DataDefine(self)
  self.packageInfo = nil
  self.rewardList = nil
end

local function DataDestroy(self)
  self.packageInfo = nil
  self.rewardList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.RefreshUI)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.RefreshUI)
  base.OnRemoveListener(self)
end

local function SetItem(self, tempPackage)
  self.packageInfo = tempPackage
  self.rewardList = self:GetCellsList()
  if not tempPackage.isWeeklyFreePackage then
    self.packageId = tempPackage:getID()
  end
  self:RefreshUI()
end

local function RefreshUI(self)
  if self.packageId then
    self.packageInfo = GiftPackageData.get(self.packageId)
    self.rewardList = self:GetCellsList()
  end
  local bgParam = self.packageInfo:getPopupImageMini()
  if bgParam and bgParam ~= "" then
    local bgPath = string.format("Assets/Main/Sprites/UI/UIweeklyPackage/%s", bgParam)
    self.packageIconN:LoadSprite(bgPath)
  end
  local discountTips = self.packageInfo:GetDiscountTips()
  if discountTips and discountTips[1] then
    self.limitTipN:SetText(discountTips[1])
  else
    self.limitTipN:SetText("")
  end
  if discountTips and discountTips[2] then
    self.isHotN:SetActive(true)
    self.isHotTxtN:SetText(discountTips[2])
  else
    self.isHotN:SetActive(false)
  end
  if discountTips and discountTips[3] then
    self.discountN:SetActive(true)
    self.discountTxtN:SetText(discountTips[3])
  else
    local hasPercent = self.packageInfo:hasPercent()
    if hasPercent then
      self.discountN:SetActive(true)
      self.discountTxtN:SetText(string.format("%s%%", self.packageInfo:getPercent()))
    else
      self.discountN:SetActive(false)
    end
  end
  for i, tempItem in ipairs(self.rewardsTbN) do
    if i <= #self.rewardList then
      tempItem:SetActive(true)
      tempItem:ReInit(self.rewardList[i])
    else
      tempItem:SetActive(false)
    end
  end
  local strPrice = ""
  local boughtNum = 0
  local maxNum = 0
  if self.packageInfo.isWeeklyFreePackage then
    strPrice = Localization:GetString("130126")
    boughtNum = GiftPackageData.CheckIfHasFreeWeeklyPackage() and 0 or 1
    maxNum = 1
    self.freeRedPointN:SetActive(true)
    self.freeBtnN:SetActive(true)
    self.buyBtnN:SetActive(false)
    self.freeBtnTxtN:SetText(strPrice)
  else
    strPrice = DataCenter.PayManager:GetDollarText(self.packageInfo:getPrice(), self.packageInfo:getProductID())
    boughtNum = self.packageInfo:getHasGetCount()
    maxNum = self.packageInfo:getBuyTimes()
    self.freeRedPointN:SetActive(false)
    self.freeBtnN:SetActive(false)
    self.buyBtnN:SetActive(true)
    self.buyBtnTxtN:SetText(strPrice)
  end
  if boughtNum >= maxNum then
    self.freeRedPointN:SetActive(false)
    self.soldOutBgN:SetActive(true)
    self.maskN:SetActive(true)
    UIGray.SetGray(self.freeBtnN.transform, true, true)
    UIGray.SetGray(self.transform, true, true)
    UIGray.SetGray(self.soldOutBgN.transform, false, true)
    self.freeBtnTxt_shadow:SetAllColor(YellowBtnShadowGrayColor)
    self.buyBtnTxt_shadow:SetAllColor(YellowBtnShadowGrayColor)
    self.discountTxt_shadow:SetAllColor(YellowBtnShadowGrayColor)
    self.isHotTxt_shadow:SetAllColor(YellowBtnShadowGrayColor)
    self.buyBtnImg:SetColor(Color.New(1, 1, 1, 0))
    self.freeBtnImg:SetColor(Color.New(1, 1, 1, 0))
    self.buyBtnN:SetInteractable(false)
    self.freeBtnN:SetInteractable(false)
  else
    self.maskN:SetActive(false)
    self.soldOutBgN:SetActive(false)
    UIGray.SetGray(self.freeBtnN.transform, false, true)
    UIGray.SetGray(self.transform, false, true)
    self.freeBtnTxt_shadow:SetAllColor(GreenBtnShadowLightColor)
    self.buyBtnTxt_shadow:SetAllColor(YellowBtnShadowLightColor)
    self.discountTxt_shadow:SetAllColor(Color.New(0.7529411764705882, 0.2823529411764706, 0, 1))
    self.isHotTxt_shadow:SetAllColor(Color.New(0.7529411764705882, 0.2823529411764706, 0, 1))
    self.buyBtnImg:SetColor(Color.New(1, 1, 1, 1))
    self.freeBtnImg:SetColor(Color.New(1, 1, 1, 1))
    self.buyBtnN:SetInteractable(true)
    self.freeBtnN:SetInteractable(true)
  end
  local remainTimes = maxNum - boughtNum
  remainTimes = remainTimes < 0 and 0 or remainTimes
  if 0 < remainTimes then
    self.limitTipN:SetText(Localization:GetString("320319", remainTimes))
  else
    self.limitTipN:SetText("")
  end
end

local function GetCellsList(self)
  local listParam = {}
  local info = self.packageInfo
  if self.packageInfo.isWeeklyFreePackage then
    for i, v in ipairs(self.packageInfo.rewards) do
      local tempParam = {}
      tempParam.type = RewardToResType[v.type]
      if type(v.value) == "table" then
        tempParam.itemId = v.value.id
        tempParam.count = v.value.num
      else
        tempParam.count = v.value
        tempParam.itemId = tempParam.type
      end
      table.insert(listParam, tempParam)
    end
    return listParam
  end
  local goldParam = {}
  local goldNum = tonumber(info:getDiamond())
  if 0 < goldNum then
    goldParam.count = string.GetFormattedSeperatorNum(goldNum)
    goldParam.itemId = ResourceType.Gold
    table.insert(listParam, goldParam)
  end
  local heroStr = info:getHeroesStr()
  if not string.IsNullOrEmpty(heroStr) then
    local arr = string.split(heroStr, ";")
    if #arr == 2 then
      local param = {}
      param.heroId = arr[1]
      param.count = arr[2]
      table.insert(listParam, param)
    end
  end
  local str = info:getItemsStr()
  local _item_use = info:getItemUse()
  if _item_use ~= nil and _item_use ~= "" then
    str = _item_use .. "|" .. str
  end
  local arrMiddle = string.split(str, "|")
  if arrMiddle ~= nil and 0 < #arrMiddle then
    for k, v in ipairs(arrMiddle) do
      local arr = string.split(v, ";")
      if arr[1] ~= "" then
        local param = {}
        param.itemId = arr[1]
        param.count = arr[2]
        table.insert(listParam, param)
      end
    end
  end
  return listParam
end

local function OnClickBuyBtn(self)
  self.view.ctrl:BuyGift(self.packageInfo)
end

local function OnClickCliamFreePackage(self)
  SFSNetwork.SendMessage(MsgDefines.BuyFreeWeeklyPackage, false)
end

local function ShowArrow(self)
  local param = {}
  param.position = self.buyBtnN.transform.position
  param.arrowType = ArrowType.Normal
  param.positionType = PositionType.Screen
  TimerManager:GetInstance():DelayInvoke(function()
    DataCenter.ArrowManager:ShowArrow(param)
  end, 0.1)
end

GolloesCampItem.OnCreate = OnCreate
GolloesCampItem.OnDestroy = OnDestroy
GolloesCampItem.OnEnable = OnEnable
GolloesCampItem.OnDisable = OnDisable
GolloesCampItem.ComponentDefine = ComponentDefine
GolloesCampItem.ComponentDestroy = ComponentDestroy
GolloesCampItem.DataDefine = DataDefine
GolloesCampItem.DataDestroy = DataDestroy
GolloesCampItem.OnAddListener = OnAddListener
GolloesCampItem.OnRemoveListener = OnRemoveListener
GolloesCampItem.SetItem = SetItem
GolloesCampItem.RefreshUI = RefreshUI
GolloesCampItem.GetCellsList = GetCellsList
GolloesCampItem.OnClickBuyBtn = OnClickBuyBtn
GolloesCampItem.OnClickCliamFreePackage = OnClickCliamFreePackage
GolloesCampItem.ShowArrow = ShowArrow
return GolloesCampItem
