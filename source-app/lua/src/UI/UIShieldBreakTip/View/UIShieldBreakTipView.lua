local UIShieldBreakTipView = BaseClass("UIShieldBreakTipView", UIBaseView)
local base = UIBaseView
local CityBuffItemCell = require("UI.UILWCityBuff.Component.CityBuffItemCell")
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UpperCenter = CS.UnityEngine.TextAnchor.UpperCenter
local title_path = "Layout/UICommonPopBg/TitleTxt"
local return_btn_path = "panel"
local close_btn_path = "Layout/UICommonPopBg/CloseBtn"
local tips_txt_path = "Layout/desc"
local btn_1_path = "Layout/BtnGo/LeftBtn"
local btn_1_txt_path = "Layout/BtnGo/LeftBtn/LeftBtnName"
local btn_2_path = "Layout/BtnGo/RightBtn"
local btn_2_txt_path = "Layout/BtnGo/RightBtn/RightBtnName"
local item_path = "Layout/BtnGo/LeftBtn/item"
local goods_icon_path = "Layout/BtnGo/LeftBtn/item/goodsIcon"
local item_count_path = "Layout/BtnGo/LeftBtn/item/itemCount"
local city_buff_cell_path = "Layout/CityBuffCell"
local height_1 = 8.6
local height_2 = 28

function UIShieldBreakTipView:OnCreate()
  base.OnCreate(self)
  self.title = self:AddComponent(UIText, title_path)
  self.tips_txt = self:AddComponent(UIText, tips_txt_path)
  self.btn_1 = self:AddComponent(UIButton, btn_1_path)
  self.btn_1_txt = self:AddComponent(UIText, btn_1_txt_path)
  self.btn_2 = self:AddComponent(UIButton, btn_2_path)
  self.btn_2_txt = self:AddComponent(UIText, btn_2_txt_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.buy_com = self:AddComponent(UIBaseComponent, "Layout/BtnGo/LeftBtn/buy")
  self.buyBtnName = self:AddComponent(UIText, "Layout/BtnGo/LeftBtn/buy/buyName")
  self.buyBtnPrice = self:AddComponent(UIText, "Layout/BtnGo/LeftBtn/buy/price")
  self.item = self:AddComponent(UIBaseContainer, item_path)
  self.goods_icon = self:AddComponent(UIImage, goods_icon_path)
  self.item_count = self:AddComponent(UITextMeshProUGUIEx, item_count_path)
  self.city_buff_cell = self:AddComponent(CityBuffItemCell, city_buff_cell_path)
end

function UIShieldBreakTipView:OnDestroy()
  if self.isBuy then
    self.btn_1_txt:SetActive(true)
    self.buy_com:SetActive(false)
  end
  self.titleText = nil
  self.tipText = nil
  self.text1 = nil
  self.text2 = nil
  self.action1 = nil
  self.closeAction = nil
  self.action2 = nil
  self.title = nil
  self.tips_txt = nil
  self.btn_1 = nil
  self.btn_1_txt = nil
  self.btn_2 = nil
  self.btn_2_txt = nil
  self.close_btn = nil
  self.return_btn = nil
  self.closeIsShow = nil
  self.isChangeImg = nil
  self.isBuy = nil
  self.costItemData = nil
  self.item = nil
  self.goods_icon = nil
  self.item_count = nil
  base.OnDestroy(self)
end

function UIShieldBreakTipView:OnEnable()
  base.OnEnable(self)
  self:RefreshData()
end

function UIShieldBreakTipView:OnDisable()
  base.OnDisable(self)
end

function UIShieldBreakTipView:SetData(tipText, btnNum, text1, text2, action1, action2, closeAction, titleText, isChangeImg, noPlayCloseEffect, enableBtn1, enableBtn2, isBuy, timeStamp, alignment, showCloseBtn, costItemData)
  self.titleText = titleText
  self.btnNum = btnNum
  self.tipText = tipText
  self.text1 = text1
  self.text2 = text2
  self.action1 = action1
  self.closeAction = closeAction
  self.action2 = action2
  self.OnCloseClick = false
  self.isChangeImg = isChangeImg
  self.noPlayCloseEffect = noPlayCloseEffect
  self.isBuy = isBuy
  self.timeStamp = timeStamp
  if enableBtn1 ~= nil then
    self.enableBtn1 = enableBtn1
  else
    self.enableBtn1 = true
  end
  if enableBtn2 ~= nil then
    self.enableBtn2 = enableBtn2
  else
    self.enableBtn2 = true
  end
  self.alignment = alignment
  self.showCloseBtn = showCloseBtn == nil and true or showCloseBtn
  self.costItemData = costItemData
end

function UIShieldBreakTipView:SetBtnSprite(btn_1_spr, btn_2_spr)
  self.btn_1_spr = btn_1_spr
  self.btn_2_spr = btn_2_spr
end

function UIShieldBreakTipView:RefreshData()
  local dataList = DataCenter.StatusManager:GetAllBuffData()
  for i = 1, #dataList do
    if tonumber(dataList[i].meta.type2) == 1 then
      self.city_buff_cell:SetStatus(dataList[i])
    end
  end
  if self.btn_1_spr == nil and self.btn_2_spr == nil then
    if self.isChangeImg then
      self.btn_1_spr = "tongyong_cfm_anniu_4"
      self.btn_2_spr = "tongyong_cfm_anniu_3"
    else
      self.btn_1_spr = "tongyong_cfm_anniu_5"
      self.btn_2_spr = "tongyong_cfm_anniu_3"
    end
  end
  self.btn_1:LoadSprite(string.format(LoadPath.LWCommonPath, self.btn_1_spr))
  self.btn_2:LoadSprite(string.format(LoadPath.LWCommonPath, self.btn_2_spr))
  if self.isBuy then
    self.btn_1:LoadSprite(string.format(LoadPath.LWCommonPath, "tongyong_cfm_anniu_3"))
    self.btn_1_txt:SetActive(false)
    self.buy_com:SetActive(true)
    self.buyBtnName:SetLocalText(self.text1)
    self.buyBtnPrice:SetColor(self.text2 > LuaEntry.Player.gold and RedColor or WhiteColor)
    self.buyBtnPrice:SetText(string.GetFormattedGoldNum(self.text2))
  end
  if self.titleText ~= nil and self.titleText ~= "" then
    self.title:SetLocalText(self.titleText)
  else
    self.title:SetLocalText(100378)
  end
  if self.alignment then
    self.tips_txt:SetAlignment(self.alignment)
  else
    self.tips_txt:SetAlignment(UpperCenter)
  end
  if self.tipText ~= nil and self.tipText ~= "" then
    self.tips_txt:SetText(self.tipText)
  else
    self.tips_txt:SetText("")
  end
  if self.btnNum ~= nil then
    self.btn_1:SetActive(self.btnNum > 0)
    self.btn_2:SetActive(1 < self.btnNum)
    if self.btnNum > 2 then
      self.btnNum = 2
    end
  else
    self.btn_1:SetActive(false)
    self.btn_2:SetActive(false)
  end
  if self.btn_1:GetActive() then
    if self.action1 then
      self.btn_1:SetOnClick(function()
        self:OnCloseInTimer()
        self.action1()
      end)
    else
      self.btn_1:SetOnClick(function()
        self.ctrl:CloseSelf()
      end)
    end
    if self.text1 ~= nil and self.text1 ~= "" then
      self.btn_1_txt:SetLocalText(self.text1)
    else
      self.btn_1_txt:SetLocalText(GameDialogDefine.CONFIRM)
    end
  end
  if self.btn_2:GetActive() then
    if self.action2 then
      self.btn_2:SetOnClick(function()
        self:OnCloseInTimer()
        self.action2()
      end)
    else
      self.btn_2:SetOnClick(function()
        self.ctrl:CloseSelf()
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
  UIGray.SetGray(self.btn_1.transform, not self.enableBtn1, self.enableBtn1)
  UIGray.SetGray(self.btn_2.transform, not self.enableBtn2, self.enableBtn2)
  self.close_btn:SetActive(self.showCloseBtn)
  self.item:SetActive(self.costItemData)
  if self.costItemData then
    self.btn_1_txt:SetAnchoredPositionXY(0, height_2)
    local costId = self.costItemData.itemId
    local costNum = self.costItemData.count
    local costItem = DataCenter.ItemData:GetItemById(costId)
    local costItemNum = costItem and costItem.count or 0
    local costTemp = DataCenter.ItemTemplateManager:GetItemTemplate(costId)
    local costIconPath = string.format(LoadPath.ItemPath, costTemp.icon)
    self.goods_icon:LoadSprite(costIconPath)
    if costNum > costItemNum then
      self.item_count:SetText(string.format("<color=#f53c3d>%d</color>/%d", costItemNum, costNum))
    else
      self.item_count:SetText(string.format("%d/%d", costItemNum, costNum))
    end
  else
    self.btn_1_txt:SetAnchoredPositionXY(0, height_1)
  end
end

function UIShieldBreakTipView:OnCloseInTimer()
  self.OnCloseClick = true
  local closeTimer = TimerManager:GetInstance():GetTimer(0.1, function()
    if self.OnCloseClick and self.ctrl then
      self.ctrl:CloseSelf(self.noPlayCloseEffect)
    end
  end, nil, true, false, false)
  closeTimer:Start()
end

return UIShieldBreakTipView
