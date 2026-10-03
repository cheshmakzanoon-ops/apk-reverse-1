local base = UIBaseView
local UIMultiBuyView = BaseClass("UIMultiBuyView", base)
local Localization = CS.GameEntry.Localization
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local title_path = "PopBg/TitleTxt"
local closeBtn_path = "PopBg/CloseBtn"
local bgBtn_path = "PopBg/panel"
local goodsItem_path = "offset/goodsCell"
local heroItem_path = "offset/heroCell"
local name_path = "offset/name"
local eachPrice_title_path = "offset/perTitleContent/perTitle"
local eachPrice_path = "offset/perTitleContent/perPrice"
local totalPrice_title_path = "offset/totalTitleContent/totalTitle"
local totalPrice_path = "offset/totalTitleContent/totalPrice"
local subBtn_path = "offset/subBtn"
local addBtn_path = "offset/addBtn"
local max_num_btn_path = "offset/maxNumBtn"
local slider_path = "offset/Slider"
local curNumIpt_path = "offset/curCountIpt"
local buyBtn_path = "offset/buyBtn"
local buyCost_path = "offset/buyBtn/cost"
local buyBtnTxt_path = "offset/buyBtn/cost/buyTxt"
local costItemIcon_path = "offset/buyBtn/cost/buyPrice/consumeIcon"
local costItemCount_path = "offset/buyBtn/cost/buyPrice"
local buyFree_path = "offset/buyBtn/free"
local buyFreeTxt_path = "offset/buyBtn/free/buyFreeTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(129008)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.bgBtnN = self:AddComponent(UIButton, bgBtn_path)
  self.bgBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.goodsItemN = self:AddComponent(UICommonResItem, goodsItem_path)
  self.heroItemN = self:AddComponent(UIHeroCellSmall, heroItem_path)
  self.nameN = self:AddComponent(UIText, name_path)
  self.eachPriceTitleN = self:AddComponent(UIText, eachPrice_title_path)
  self.eachPriceN = self:AddComponent(UIText, eachPrice_path)
  self.totalPriceTitleN = self:AddComponent(UIText, totalPrice_title_path)
  self.totalPriceN = self:AddComponent(UIText, totalPrice_path)
  self.subBtnN = self:AddComponent(UIButton, subBtn_path)
  self.subBtnN:SetOnClick(function()
    self:OnClickSubBtn()
  end)
  self.addBtnN = self:AddComponent(UIButton, addBtn_path)
  self.addBtnN:SetOnClick(function()
    self:OnClickAddBtn()
  end)
  self.max_num_btn = self:AddComponent(UIButton, max_num_btn_path)
  self.max_num_btn:SetOnClick(function()
    self:OnClickBuyMaxNumSetBtn()
  end)
  self.sliderN = self:AddComponent(UISlider, slider_path)
  self.sliderN:SetOnValueChanged(function(value)
    self:OnSliderValueChange(value)
  end)
  self.curNumIptN = self:AddComponent(UIInput, curNumIpt_path)
  self.curNumIptN:SetOnEndEdit(function(value)
    self:OnCurNumIptValueChange(value)
  end)
  self.buyBtnN = self:AddComponent(UIButton, buyBtn_path)
  self.buyBtnN:SetOnClick(function()
    self:OnClickBuyBtn()
  end)
  self.buyCostN = self:AddComponent(UIBaseContainer, buyCost_path)
  self.buyBtnTxtN = self:AddComponent(UIText, buyBtnTxt_path)
  self.buyBtnTxtN:SetLocalText(129011)
  self.consumeIconN = self:AddComponent(UIImage, costItemIcon_path)
  self.costCountN = self:AddComponent(UIText, costItemCount_path)
  self.costOutlineN = self:AddComponent(UIOutline, costItemCount_path)
  self.costShadowN = self:AddComponent(UIShadow, costItemCount_path)
  self.buyFreeN = self:AddComponent(UIBaseContainer, buyFree_path)
  self.buyFreeTxtN = self:AddComponent(UIText, buyFreeTxt_path)
  self.buyFreeTxtN:SetLocalText(130126)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.closeBtnN = nil
  self.bgBtnN = nil
  self.goodsItemN = nil
  self.heroItemN = nil
  self.eachPriceN = nil
  self.totalPriceN = nil
  self.subBtnN = nil
  self.addBtnN = nil
  self.max_num_btn = nil
  self.sliderN = nil
  self.curNumIptN = nil
  self.buyBtnN = nil
  self.buyBtnTxtN = nil
  self.consumeIconN = nil
  self.costCountN = nil
end

local function DataDefine(self)
  self.curCount = 1
  self.goodsInfo = nil
  self.consumeInfo = nil
  self.confirmCallBack = nil
end

local function DataDestroy(self)
  self.curCount = nil
  self.goodsInfo = nil
  self.consumeInfo = nil
  self.confirmCallBack = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGold, self.PurchaseRefresh)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGold, self.PurchaseRefresh)
  base.OnRemoveListener(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:TrySetCurNum(self.curCount)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function InitData(self)
  local tempParam = self:GetUserData()
  if not tempParam then
    return
  end
  self.goodsInfo = tempParam.goodsInfo
  self.consumeInfo = tempParam.consumeInfo
  self.confirmCallBack = tempParam.callback
  self.curCount = tempParam.limitCount or self.curCount
  self.notEnoughCallBack = tempParam.notEnoughCallBack
  self.shopType = checknumber(tempParam.shopType)
  self:InitUI()
end

local function InitUI(self)
  if not self.goodsInfo or not self.consumeInfo then
    return
  end
  if self.goodsInfo.isPoster then
    self.heroItemN:SetActive(true)
    self.goodsItemN:SetActive(false)
    self.heroItemN:InitWithConfigIdByPoster(self.goodsInfo.itemId)
  else
    self.heroItemN:SetActive(false)
    self.goodsItemN:SetActive(true)
    local param = {
      rewardType = self.goodsInfo.rewardType,
      itemId = self.goodsInfo.itemId,
      count = self.goodsInfo.count
    }
    self.goodsItemN:ReInit(param)
  end
  local strName = ""
  if self.goodsInfo.rewardType == RewardType.GOODS then
    local itemName = DataCenter.ItemTemplateManager:GetName(self.goodsInfo.itemId)
    strName = itemName
  elseif self.goodsInfo.rewardType == RewardType.RESOURCE_ITEM then
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(self.goodsInfo.itemId)
    strName = Localization:GetString(template.name)
  elseif self.goodsInfo.rewardType == RewardType.EQUIP then
    local template = DataCenter.EquipTemplateManager:GetTemplate(self.goodsInfo.itemId)
    strName = Localization:GetString(template.name)
  else
    local heroName = HeroUtils.GetHeroNameByConfigId(self.goodsInfo.itemId)
    strName = heroName
  end
  self.nameN:SetText(strName)
  self.eachPriceTitleN:SetLocalText(129009, "")
  self.eachPriceN:SetText(self.goodsInfo.eachPrice)
  self.totalPriceTitleN:SetLocalText(129010, "")
  self.curNumIptN:SetText(self.curCount)
  if self.goodsInfo.eachPrice > 0 then
    self.buyCostN:SetActive(true)
    self.buyFreeN:SetActive(false)
    local resType = RewardToResType[self.consumeInfo.currencyType]
    if resType and DataCenter.ResourceManager:GetResourceIconByType(resType) then
      local resIcon = DataCenter.ResourceManager:GetResourceIconByType(RewardToResType[self.consumeInfo.currencyType])
      self.consumeIconN:LoadSprite(resIcon)
    else
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.consumeInfo.currencyId)
      self.consumeIconN:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
    end
  else
    self.buyCostN:SetActive(false)
    self.buyFreeN:SetActive(true)
    self.curCount = self.goodsInfo.limitCount
  end
  self:TrySetCurNum(self.curCount)
end

local function PurchaseRefresh(self)
  self:TrySetCurNum(self.curCount)
end

local function TrySetCurNum(self, tempNum, updateMaxTag)
  tempNum = tonumber(tempNum) or self.curCount
  tempNum = math.floor(tempNum + 0.5)
  if tempNum <= 0 then
    tempNum = 1
  elseif tempNum > self.goodsInfo.limitCount then
    tempNum = self.goodsInfo.limitCount
  end
  tempNum = Mathf.Round(tempNum)
  self.curCount = tempNum
  local costEnough = self:CheckCostEnough(false)
  local costColor1 = costEnough and WhiteColor or RedColor
  local costColor2 = costEnough and WhiteColor or RedColor
  local outlineColor = costEnough and YellowBtnShadowLightColor or Color.New(1, 1, 1, 0)
  self.curNumIptN:SetText(self.curCount)
  self.sliderN:SetValueWithoutNotify(self.curCount / self.goodsInfo.limitCount)
  local tempTotalPrice = self.curCount * self.goodsInfo.eachPrice
  self.totalPriceN:SetText(tempTotalPrice)
  self.totalPriceN:SetColor(costColor1)
  self.costCountN:SetText(tempTotalPrice)
  self.costCountN:SetColor(costColor2)
  self.costOutlineN:SetColor(outlineColor)
  self.costShadowN:SetAllColor(outlineColor)
  if updateMaxTag then
    DataCenter.CommonShopManager:SetAutoSelectMaxCountTag(self.shopType, self.curCount >= self.goodsInfo.limitCount)
  end
end

local function CheckCostEnough(self, showTip)
  local tempTotalPrice = self.curCount * self.goodsInfo.eachPrice
  local resType = RewardToResType[self.consumeInfo.currencyType]
  if resType and DataCenter.ResourceManager:GetResourceIconByType(resType) then
    if resType == ResourceType.Gold then
      if tempTotalPrice > LuaEntry.Player.gold then
        if showTip then
          GoToUtil.GotoPayTips(tempTotalPrice)
        end
        return false
      end
    else
      local cnt = LuaEntry.Resource:GetCntByResType(resType)
      if tempTotalPrice > cnt then
        if showTip then
          local data = {}
          table.insert(data, {resType = resType, need = tempTotalPrice})
          LWResourceLackUtil:GotoResLack(data)
        end
        return false
      end
    end
  else
    local curNum = DataCenter.ItemData:GetItemCount(self.consumeInfo.currencyId)
    if tempTotalPrice > curNum then
      if showTip then
        UIUtil.ShowTipsId(GameDialogDefine.NO_ITEM)
      end
      return false
    end
  end
  return true
end

local function OnClickCloseBtn(self)
  self.ctrl:CloseSelf()
end

local function OnClickSubBtn(self)
  local num = self.curCount - 1
  self:TrySetCurNum(num, true)
end

local function OnClickAddBtn(self)
  local num = self.curCount + 1
  self:TrySetCurNum(num, true)
end

local function OnSliderValueChange(self, value)
  local num = self.goodsInfo.limitCount * value
  self:TrySetCurNum(num, true)
end

local function OnCurNumIptValueChange(self, value)
  self:TrySetCurNum(value, true)
end

local function OnClickBuyMaxNumSetBtn(self)
  local maxNum = self:GetBuyMaxNum()
  self:TrySetCurNum(maxNum, true)
end

local function GetBuyMaxNum(self)
  local maxNum = 0
  local eachPrice = self.goodsInfo.eachPrice
  local resCount = 0
  local resType = RewardToResType[self.consumeInfo.currencyType]
  if resType and DataCenter.ResourceManager:GetResourceIconByType(resType) then
    if resType == ResourceType.Gold then
      resCount = LuaEntry.Player.gold
    else
      resCount = LuaEntry.Resource:GetCntByResType(resType)
    end
  else
    local curNum = DataCenter.ItemData:GetItemCount(self.consumeInfo.currencyId)
    resCount = curNum
  end
  maxNum = math.floor(resCount / eachPrice)
  return maxNum
end

local function OnClickBuyBtn(self)
  local showTips = self.notEnoughCallBack == nil
  if not self:CheckCostEnough(showTips) then
    if self.notEnoughCallBack ~= nil then
      local tempTotalPrice = self.curCount * self.goodsInfo.eachPrice
      self.notEnoughCallBack(tempTotalPrice)
      self.ctrl:CloseSelf()
      return
    end
    return
  end
  self.ctrl:CloseSelf()
  if self.confirmCallBack then
    self.confirmCallBack(self.curCount)
  end
end

UIMultiBuyView.OnCreate = OnCreate
UIMultiBuyView.OnDestroy = OnDestroy
UIMultiBuyView.OnAddListener = OnAddListener
UIMultiBuyView.OnRemoveListener = OnRemoveListener
UIMultiBuyView.ComponentDefine = ComponentDefine
UIMultiBuyView.ComponentDestroy = ComponentDestroy
UIMultiBuyView.DataDefine = DataDefine
UIMultiBuyView.DataDestroy = DataDestroy
UIMultiBuyView.OnEnable = OnEnable
UIMultiBuyView.OnDisable = OnDisable
UIMultiBuyView.InitData = InitData
UIMultiBuyView.InitUI = InitUI
UIMultiBuyView.PurchaseRefresh = PurchaseRefresh
UIMultiBuyView.TrySetCurNum = TrySetCurNum
UIMultiBuyView.CheckCostEnough = CheckCostEnough
UIMultiBuyView.OnClickCloseBtn = OnClickCloseBtn
UIMultiBuyView.OnClickSubBtn = OnClickSubBtn
UIMultiBuyView.OnClickAddBtn = OnClickAddBtn
UIMultiBuyView.OnSliderValueChange = OnSliderValueChange
UIMultiBuyView.OnCurNumIptValueChange = OnCurNumIptValueChange
UIMultiBuyView.OnClickBuyMaxNumSetBtn = OnClickBuyMaxNumSetBtn
UIMultiBuyView.GetBuyMaxNum = GetBuyMaxNum
UIMultiBuyView.OnClickBuyBtn = OnClickBuyBtn
return UIMultiBuyView
