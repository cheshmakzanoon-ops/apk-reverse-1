local PastureDesTip = BaseClass("PastureDesTip", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local name_txt_path = "showMainObj/nameTxt"
local time_txt_path = "showMainObj/need/needTimeTxt"
local show_main_obj_path = "showMainObj"
local res_img_path = "showMainObj/need/needResIcon"
local price_txt_path = "showMainObj/need/priceTxt"
local price_des_path = "showMainObj/need/priceDesTxt"
local num_txt_path = "showMainObj/need/numTxt"
local num_des_path = "showMainObj/need/numDesTxt"
local goods_img_path = "showMainObj/need/productIcon"
local need_layout_path = "showMainObj/need"
local buy_layout_path = "showMainObj/buy"
local coin_img_path = "showMainObj/buy/needCoinIcon"
local tips_txt_path = "showMainObj/buy/tipsTxt"
local buy_txt_path = "showMainObj/buy/buyTxt"
local arrow_left_path = "showMainObj/arrow_left"
local arrow_right_path = "showMainObj/arrow_right"
local irrigateLayout_path = "showMainObj/irrigate"
local irriNeedName_path = "showMainObj/irrigate/irriNeedName"
local irriNeedNum_path = "showMainObj/irrigate/irriNeedNum"
local irriTip_path = "showMainObj/irrigate/irriTip"
local irriTimeTip_path = "showMainObj/irrigate/irriTimeTip"
local irriTime_path = "showMainObj/irrigate/irriTimeTip/irriTime"
local this_path = ""

local function OnCreate(self)
  base.OnCreate(self)
  self.name_txt = self:AddComponent(UIText, name_txt_path)
  self.time_txt = self:AddComponent(UIText, time_txt_path)
  self.show_main_obj = self:AddComponent(UIBaseContainer, show_main_obj_path)
  self.need_layout_obj = self:AddComponent(UIBaseContainer, need_layout_path)
  self.buy_layout_obj = self:AddComponent(UIBaseContainer, buy_layout_path)
  self.price_txt = self:AddComponent(UIText, price_txt_path)
  self.num_txt = self:AddComponent(UIText, num_txt_path)
  self.res_img = self:AddComponent(UIImage, res_img_path)
  self.goods_img = self:AddComponent(UIImage, goods_img_path)
  self.price_des = self:AddComponent(UIText, price_des_path)
  self.num_des = self:AddComponent(UIText, num_des_path)
  self.animator = self:AddComponent(UIAnimator, this_path)
  self.coin_img = self:AddComponent(UIImage, coin_img_path)
  self.tips_txt = self:AddComponent(UIText, tips_txt_path)
  self.buy_txt = self:AddComponent(UIText, buy_txt_path)
  self.arrow_left = self:AddComponent(UIImage, arrow_left_path)
  self.arrow_right = self:AddComponent(UIImage, arrow_right_path)
  self.irrigateLayoutObj = self:AddComponent(UIBaseContainer, irrigateLayout_path)
  self.irriNeedNameN = self:AddComponent(UIText, irriNeedName_path)
  self.irriNeedNumN = self:AddComponent(UIText, irriNeedNum_path)
  self.irriTipN = self:AddComponent(UIText, irriTip_path)
  self.irriTimeTipN = self:AddComponent(UIText, irriTimeTip_path)
  self.irriTimeN = self:AddComponent(UIText, irriTime_path)
end

local function OnDestroy(self)
  self.name_txt = nil
  self.time_txt = nil
  self.show_main_obj = nil
  self.price_txt = nil
  self.num_txt = nil
  self.total_txt = nil
  self.res_img = nil
  self.goods_img = nil
  self.price_des = nil
  self.num_des = nil
  self.need_layout_obj = nil
  self.buy_layout_obj = nil
  self.coin_img = nil
  self.tips_txt = nil
  self.buy_txt = nil
  self.arrow_left = nil
  self.irrigateLayoutObj = nil
  self.irriNeedNameN = nil
  self.irriNeedNumN = nil
  self.irriTipN = nil
  self.irriTimeN = nil
  self.arrow_right = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetShowState(self, isOpen)
  if isOpen then
    self.animator:Play("MenuOpen", 0, 0)
  else
    self.animator:Play("MenuClose", 0, 0)
  end
end

local function RefreshData(self, data, posX, posY, isFeed)
  self:SetPosition(posX, posY)
  self.data = data
  self.name_txt:SetLocalText(self.data.name)
  if isFeed then
    self.need_layout_obj:SetActive(true)
    self.buy_layout_obj:SetActive(false)
    self.irrigateLayoutObj:SetActive(false)
    self.time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringForCountdown(self.data.produce_time))
    self.num_des:SetText(Localization:GetString("130067") .. ": ")
    self.price_des:SetLocalText(390662, "")
    self.num_txt:SetText(self.data.canGetItemNum)
    self.goods_img:LoadSprite(self.data.itemIcon)
    if self.data.needResourceType ~= nil then
      self.price_txt:SetText(self.data.needResourceNum)
      local resourceState = self.view.ctrl:CheckIsResourceEnough(self.data.needResourceType, self.data.needResourceNum, 1)
      if resourceState then
        self.price_txt:SetColor(BlueColor)
      else
        self.price_txt:SetColor(RedColor)
      end
      self.res_img:LoadSprite(self.data.needResourceIcon)
    elseif self.data.needGoodsId ~= nil then
      self.price_txt:SetText(self.data.needGoodsNum)
      local resourceState = self.view.ctrl:CheckIsResourceGoodsEnough(self.data.needGoodsId, self.data.needGoodsNum, 1)
      if resourceState then
        self.price_txt:SetColor(BlueColor)
      else
        self.price_txt:SetColor(RedColor)
      end
      self.res_img:LoadSprite(self.data.needGoodsIcon)
    end
  elseif self.data.farmState == FarmStateType.Irrigate then
    self.irrigateLayoutObj:SetActive(true)
    self.need_layout_obj:SetActive(false)
    self.buy_layout_obj:SetActive(false)
    self.irriTipN:SetLocalText(395412, self.data.irrigateInfo.maxTimes)
    self.irriNeedNameN:SetLocalText(110040)
    self.irriNeedNumN:SetText(self.data.irrigateInfo.cost)
    if self.data.irrigateInfo.remainTimes >= self.data.irrigateInfo.maxTimes then
      self.irriTimeTipN:SetActive(false)
    else
      self.irriTimeTipN:SetActive(true)
      self.irriTimeTipN:SetLocalText(104199)
      local serverT = UITimeManager:GetInstance():GetServerTime()
      local nextRecoverT = self.data.irrigateInfo.lastRecoverTime + self.data.irrigateInfo.recoverTimeS * 1000 - serverT
      local allNeedT = (self.data.irrigateInfo.maxTimes - self.data.irrigateInfo.remainTimes - 1) * self.data.irrigateInfo.recoverTimeS * 1000 + nextRecoverT
      self.irriTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringSpecial(allNeedT))
    end
  else
    self.need_layout_obj:SetActive(false)
    self.buy_layout_obj:SetActive(true)
    self.irrigateLayoutObj:SetActive(false)
    if not string.IsNullOrEmpty(self.data.unlockTip) then
      self.tips_txt:SetText(self.data.unlockTip)
    else
      self.tips_txt:SetText(Localization:GetString(GameDialogDefine.BUY_ONE_NEW, Localization:GetString(self.data.name)))
    end
    if self.data.needResourceType ~= nil then
      self.buy_txt:SetText(self.data.needResourceNum)
      local resourceState = self.view.ctrl:CheckIsResourceEnough(self.data.needResourceType, self.data.needResourceNum, 1)
      if resourceState then
        self.buy_txt:SetColor(BlueColor)
      else
        self.buy_txt:SetColor(RedColor)
      end
      self.coin_img:LoadSprite(self.data.needResourceIcon)
    elseif self.data.needGoodsId ~= nil then
      self.buy_txt:SetText(self.data.needGoodsNum)
      local resourceState = self.view.ctrl:CheckIsResourceGoodsEnough(self.data.needGoodsId, self.data.needGoodsNum, 1)
      if resourceState then
        self.buy_txt:SetColor(BlueColor)
      else
        self.buy_txt:SetColor(RedColor)
      end
      self.coin_img:LoadSprite(self.data.needGoodsIcon)
    end
  end
end

local function SetPosition(self, posX, posY)
  local screenSizeW = Screen.width
  local screenSizeH = Screen.height
  local scale = screenSizeH / 750.0
  local v3 = self.transform.position
  if posX < screenSizeW / 2 then
    posX = posX + (self.rectTransform.rect.width + 110) * scale
    self.arrow_left:SetActive(true)
    self.arrow_right:SetActive(false)
  else
    self.arrow_left:SetActive(false)
    self.arrow_right:SetActive(true)
  end
  v3.x = posX
  v3.y = posY
  self.transform.position = v3
  local rectPos = self.rectTransform.anchoredPosition
  local x = rectPos.x
  local y = rectPos.y + 60
  local tempAnchoredPosition = Vector2.New(x, y)
  self.rectTransform.anchoredPosition = tempAnchoredPosition
end

PastureDesTip.OnDestroy = OnDestroy
PastureDesTip.OnCreate = OnCreate
PastureDesTip.OnEnable = OnEnable
PastureDesTip.OnDisable = OnDisable
PastureDesTip.RefreshData = RefreshData
PastureDesTip.SetShowState = SetShowState
PastureDesTip.SetPosition = SetPosition
return PastureDesTip
