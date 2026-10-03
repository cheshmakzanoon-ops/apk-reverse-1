local base = UIBaseContainer
local UIBargainShopPropItem_Common = BaseClass("UIBargainShopPropItem_Common", base)
local RemainingKey = "activity_bargain_shop_desc4"
local UIGray = CS.UIGray

function UIBargainShopPropItem_Common:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIBargainShopPropItem_Common:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshBargainProp, self.OnRefreshBargainProp)
end

function UIBargainShopPropItem_Common:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshBargainProp, self.OnRefreshBargainProp)
  base.OnRemoveListener(self)
end

function UIBargainShopPropItem_Common:OnRefreshBargainProp(propData)
  if self.data.uuid == propData.uuid then
    self:UpdateData(propData)
  end
end

function UIBargainShopPropItem_Common:ComponentDefine()
  self.curPrice_text = self:AddComponent(UIText, "Bg/buyBtn/layout/priceLayout/curPrice")
  self.beforePrice_text = self:AddComponent(UIText, "Bg/buyBtn/layout/beforePrice")
  self.propName_text = self:AddComponent(UIText, "Bg/propName")
  self.leftTimes_text = self:AddComponent(UIText, "Bg/leftTimes")
  self.priceIcon = self:AddComponent(UIImage, "Bg/buyBtn/layout/priceLayout/priceIcon")
  self.resItem = self:AddComponent(UICommonResItem, "Bg/UICommonResItem")
  self.layoutBtnCom = self:AddComponent(UIBaseContainer, "Bg/buyBtn/layout")
  self.buyBtn = self:AddComponent(UIButton, "Bg/buyBtn")
  self.sellOutText = self:AddComponent(UIText, "Bg/sellOut")
  self.tipCom = self:AddComponent(UIBaseContainer, "Bg/tip")
  self.baseCom = self:AddComponent(UIBaseContainer, "")
  self.buyBtn:SetOnClick(function()
    self:OnBuyBtnClck()
  end)
  self.Bg = self:AddComponent(UIImage, "Bg")
  self.CurPriceBg = self:AddComponent(UIImage, "Bg/CurPriceBg")
  self.buyBtnImg = self:AddComponent(UIImage, "Bg/buyBtn/bg")
  self.freeFlag = self:AddComponent(UIImage, "Bg/freeFlag")
  self.persistentFlag = self:TryAddComponent(UIImage, "Bg/persistentFlag")
end

function UIBargainShopPropItem_Common:ComponentDestroy()
  self.curPrice_text = nil
  self.beforePrice_text = nil
  self.propName_text = nil
  self.leftTimes_text = nil
  self.priceIcon = nil
  self.resItem = nil
  self.layoutBtnCom = nil
  self.buyBtn = nil
  self.sellOutText = nil
  self.tipCom = nil
  self.baseCom = nil
  self.data = nil
end

function UIBargainShopPropItem_Common:OnBuyBtnClck()
  if self.data == nil then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBargainShopShare, {anim = true}, self.data)
end

function UIBargainShopPropItem_Common:UpdateData(propData, activityId)
  self.data = propData
  local curPrice = self.data.template.price - self.data:GetReducePrice()
  self.curPrice_text:SetText(curPrice)
  if table.count(self.data.helpPlayers) > 0 then
    self.beforePrice_text:SetActive(true)
  else
    self.beforePrice_text:SetActive(false)
  end
  self.beforePrice_text:SetText(self.data.template.price)
  self.propName_text:SetText(DataCenter.RewardManager:GetNameByType(self.data.template.rewardType, self.data.template.itemId))
  self.priceIcon:LoadSpriteAuto(self.data.template:GetCurrencyIconPath())
  self.count = self.data.template.buyTimeLimit - self.data.buyNum
  self.leftTimes_text:SetLocalText(RemainingKey, self.count)
  self.freeFlag:SetActive(curPrice == 0)
  self.tipCom:SetActive(curPrice ~= 0 and self.data:GetIsSuper())
  if self.persistentFlag then
    self.persistentFlag:SetActive(self.data:GetIsPersistent())
  end
  if self.count > 0 then
    self.layoutBtnCom:SetActive(true)
    self.sellOutText:SetActive(false)
    UIGray.SetGray(self.baseCom.transform, false, true)
  else
    self.layoutBtnCom:SetActive(false)
    self.sellOutText:SetActive(true)
    UIGray.SetGray(self.baseCom.transform, true, false)
  end
  self.resItem:ReInit(self.data.template)
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if activityData then
    self:RefreshCommonNode(activityData:GetShowConfigTemp())
  end
end

function UIBargainShopPropItem_Common:RefreshTimerCountdown()
end

function UIBargainShopPropItem_Common:AddTimer()
end

function UIBargainShopPropItem_Common:DeleteTimer()
end

function UIBargainShopPropItem_Common:OnDestroy()
  self:ComponentDestroy()
end

function UIBargainShopPropItem_Common:DataDestroy()
end

function UIBargainShopPropItem_Common:RefreshCommonNode(showTemp)
  if showTemp and not string.IsNullOrEmpty(showTemp.pic_spec2) then
    local picNameList = string.split(showTemp.pic_spec2, "|")
    local name1 = picNameList[1]
    if name1 and not string.IsNullOrEmpty(name1) then
      self.Bg:LoadSpriteAuto(string.format(LoadPath.ActivityBargainShopUIPath, name1))
    end
    local name2 = picNameList[2]
    if name2 and not string.IsNullOrEmpty(name2) then
      self.CurPriceBg:SetEnable(true)
      self.CurPriceBg:LoadSpriteAuto(string.format(LoadPath.ActivityBargainShopUIPath, name2))
    else
      self.CurPriceBg:SetEnable(false)
    end
    local name3 = picNameList[3]
    if name3 and not string.IsNullOrEmpty(name3) then
      self.buyBtnImg:SetActive(true)
      self.buyBtnImg:LoadSpriteAuto(string.format(LoadPath.ActivityBargainShopUIPath, name3))
    else
      self.buyBtnImg:SetActive(false)
    end
  end
end

return UIBargainShopPropItem_Common
