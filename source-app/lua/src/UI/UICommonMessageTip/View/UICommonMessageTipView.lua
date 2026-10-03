local UICommonMessageTipView = BaseClass("UICommonMessageTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UpperCenter = CS.UnityEngine.TextAnchor.MiddleCenter
local title_path = "Layout/UICommonPopBg/TitleTxt"
local return_btn_path = "panel"
local close_btn_path = "Layout/UICommonPopBg/CloseBtn"
local tips_txt_path = "Layout/DesName"
local btn_1_path = "Layout/BtnGo/LeftBtn"
local btn_1_txt_path = "Layout/BtnGo/LeftBtn/LeftBtnName"
local btn_2_path = "Layout/BtnGo/RightBtn"
local btn_2_txt_path = "Layout/BtnGo/RightBtn/RightBtnName"
local item_path = "Layout/BtnGo/LeftBtn/item"
local goods_icon_path = "Layout/BtnGo/LeftBtn/item/goodsIcon"
local item_count_path = "Layout/BtnGo/LeftBtn/item/itemCount"
local common_pop_bg_path = "Layout/UICommonPopBg"
local height_1 = 8.6
local height_2 = 28

local function OnCreate(self)
  base.OnCreate(self)
  self.common_pop_bg = self:AddComponent(UIBaseContainer, common_pop_bg_path)
  self.title = self:AddComponent(UIText, title_path)
  self.tips_txt = self:AddComponent(UIText, tips_txt_path)
  self.time_txt = self:AddComponent(UIText, "Layout/time")
  self.btn_1 = self:AddComponent(UIButton, btn_1_path)
  self.btn_1_txt = self:AddComponent(UIText, btn_1_txt_path)
  self.btn_2 = self:AddComponent(UIButton, btn_2_path)
  self.btn_2_txt = self:AddComponent(UIText, btn_2_txt_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.buy_com = self:AddComponent(UIBaseComponent, "Layout/BtnGo/LeftBtn/buy")
  self.buyBtnName = self:AddComponent(UIText, "Layout/BtnGo/LeftBtn/buy/buyName")
  self.buyBtnPrice = self:AddComponent(UIText, "Layout/BtnGo/LeftBtn/buy/price")
  self.content = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "Layout")
  self.item = self:AddComponent(UIBaseContainer, item_path)
  self.goods_icon = self:AddComponent(UIImage, goods_icon_path)
  self.item_count = self:AddComponent(UITextMeshProUGUIEx, item_count_path)
end

local function OnDestroy(self)
  self:RemoveUpdateTimer()
  if self.isBuy then
    self.btn_1_txt:SetActive(true)
    self.buy_com:SetActive(false)
  end
  self.common_pop_bg = nil
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
  self.expTimestamp = nil
  self.countdownCallback = nil
  self.customTitleStr = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshData()
end

local function OnDisable(self)
  base.OnDisable(self)
  if self.updateTipsTextTimer then
    self.updateTipsTextTimer:Stop()
    self.updateTipsTextTimer = nil
  end
end

local function SetData(self, tipText, btnNum, text1, text2, action1, action2, closeAction, titleText, isChangeImg, noPlayCloseEffect, enableBtn1, enableBtn2, isBuy, timeStamp, alignment, showCloseBtn, costItemData, customTitleStr)
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
  self.expTimestamp = nil
  self.countdownCallback = nil
  if self.updateTipsTextTimer then
    self.updateTipsTextTimer:Stop()
    self.updateTipsTextTimer = nil
  end
  self.customTitleStr = customTitleStr
end

local function SetBtnSprite(self, btn_1_spr, btn_2_spr)
  self.btn_1_spr = btn_1_spr
  self.btn_2_spr = btn_2_spr
end

local function RefreshData(self)
  self:RemoveUpdateTimer()
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
  if not string.IsNullOrEmpty(self.customTitleStr) then
    self.title:SetText(self.customTitleStr)
  elseif not string.IsNullOrEmpty(self.titleText) then
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
    self.btn_2:SetActive(self.btnNum > 1)
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
  if self.timeStamp then
    self:AddUpdateTimer()
    self.time_txt:SetActive(true)
    self:OnUpdateSec()
  else
    self.time_txt:SetActive(false)
  end
  self:StartCountdown()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.common_pop_bg.transform)
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

local function OnCloseInTimer(self)
  self.OnCloseClick = true
  local closeTimer = TimerManager:GetInstance():GetTimer(0.1, function()
    if self.OnCloseClick and self.ctrl then
      self.ctrl:CloseSelf(self.noPlayCloseEffect)
    end
  end, nil, true, false, false)
  closeTimer:Start()
end

local function AddUpdateTimer(self)
  if self.updateSecTimer == nil then
    self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, false)
    self.updateSecTimer:Start()
  end
end

local function RemoveUpdateTimer(self)
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
end

local function OnUpdateSec(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(self.timeStamp - now)
  self.time_txt:SetText(timeStr)
end

local function SetExpTimestamp(self, expTimestamp, countdownCallback)
  self.expTimestamp = expTimestamp
  self.countdownCallback = countdownCallback
end

local function StartCountdown(self)
  if self.expTimestamp == nil then
    if self.updateTipsTextTimer then
      self.updateTipsTextTimer:Stop()
      self.updateTipsTextTimer = nil
    end
    return
  end
  self.updateTipsTextTimer = TimerManager:GetInstance():GetTimer(1, self.UpdateTipsTextTick, self, false, false, false)
  self.updateTipsTextTimer:Start()
  self:UpdateTipsTextTick()
end

local function UpdateTipsTextTick(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.expTimestamp - now
  if 0 < remainTime then
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
    self.tips_txt:SetText(Localization:GetString(self.tipText, timeStr))
  else
    if self.updateTipsTextTimer then
      self.updateTipsTextTimer:Stop()
      self.updateTipsTextTimer = nil
    end
    if self.countdownCallback then
      self.countdownCallback()
    end
    self.ctrl:CloseSelf()
  end
end

UICommonMessageTipView.OnCreate = OnCreate
UICommonMessageTipView.OnDestroy = OnDestroy
UICommonMessageTipView.OnEnable = OnEnable
UICommonMessageTipView.OnDisable = OnDisable
UICommonMessageTipView.SetData = SetData
UICommonMessageTipView.RefreshData = RefreshData
UICommonMessageTipView.OnCloseInTimer = OnCloseInTimer
UICommonMessageTipView.AddUpdateTimer = AddUpdateTimer
UICommonMessageTipView.RemoveUpdateTimer = RemoveUpdateTimer
UICommonMessageTipView.OnUpdateSec = OnUpdateSec
UICommonMessageTipView.SetBtnSprite = SetBtnSprite
UICommonMessageTipView.StartCountdown = StartCountdown
UICommonMessageTipView.UpdateTipsTextTick = UpdateTipsTextTick
UICommonMessageTipView.SetExpTimestamp = SetExpTimestamp
return UICommonMessageTipView
