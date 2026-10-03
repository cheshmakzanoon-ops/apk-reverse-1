local UISellConfirmView = BaseClass("UISellConfirmView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UISellConfirmCostBtnPanel = require("UI.UISellConfirm.Component.UISellConfirmCostBtnPanel")
local title_text_path = "UICommonMiniPopUpTitle/titleText"
local close_btn_path = "UICommonMiniPopUpTitle/CloseBtn"
local content_text_path = "DesName"
local close_panel_btn_path = "UICommonMiniPopUpTitle/panel"
local left_btn_path = "BtnGo/LeftBtn"
local left_btn_text_path = "BtnGo/LeftBtn/LeftBtnName"
local right_btn_path = "BtnGo/RightBtn"
local right_btn_text_path = "BtnGo/RightBtn/RightBtnName"
local back_toggle_path = "backToggle"
local checkbox_text = "backToggle/Text"
local left_btn_pic_name_path = "BtnGo/LeftBtn/LeftBtnWithPicName"
local left_btn_pic_icon_path = "BtnGo/LeftBtn/LeftBtnWithPicName/LeftBtnWithPicIcon"
local right_btn_pic_name_path = "BtnGo/RightBtn/RightBtnWithPicName"
local right_btn_pic_icon_path = "BtnGo/RightBtn/RightBtnWithPicName/RightBtnWithPicIcon"
local btnPanel_path = "BtnGo"
local costBtnPanel_path = "CostBtnGo"
local delay_path = "delay"
local delay_des_path = "delay/delayDes"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.content_text = self:AddComponent(UIText, content_text_path)
  self.close_panel_btn = self:AddComponent(UIButton, close_panel_btn_path)
  self.close_panel_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.left_btn = self:AddComponent(UIButton, left_btn_path)
  self.left_btn_text = self:AddComponent(UIText, left_btn_text_path)
  self.right_btn = self:AddComponent(UIButton, right_btn_path)
  self.right_btn_text = self:AddComponent(UIText, right_btn_text_path)
  self.right_btn:SetOnClick(function()
    self:OnCancelClick()
  end)
  self.checkbox_text = self:AddComponent(UIText, checkbox_text)
  self.back_toggle = self:AddComponent(UIToggle, back_toggle_path)
  self.back_toggle:SetIsOn(false)
  self.left_btn_pic_name = self:AddComponent(UIText, left_btn_pic_name_path)
  self.left_btn_pic_icon = self:AddComponent(UIImage, left_btn_pic_icon_path)
  self.right_btn_pic_name = self:AddComponent(UIText, right_btn_pic_name_path)
  self.right_btn_pic_icon = self:AddComponent(UIImage, right_btn_pic_icon_path)
  self.btnPanel = self:AddComponent(UIBaseContainer, btnPanel_path)
  self.costBtnPanel = self:AddComponent(UISellConfirmCostBtnPanel, costBtnPanel_path)
  self.delay = self:AddComponent(UIBaseContainer, delay_path)
  self.delay_des = self:AddComponent(UITextMeshProUGUIEx, delay_des_path)
end

local function OnCancelClick(self)
  self.ctrl:OnCancelClick()
end

local function ToggleControlBorS(self)
  self.ctrl:OnCheckBoxClick(self.back_toggle:GetIsOn())
end

local function SetData(self, title, contentText, btnNum, text1, text2, sureAction, toggleAction, cancelAction, closeAction, isChangeImg, toggleText, btnNoUseDialog, leftBtnPicName, rightBtnPicName, showToggle, costParam, delayConfirm, alignment, cdConfirm)
  self.title = title
  self.content = contentText
  self.btnNum = btnNum
  self.sureAction = sureAction
  self.cancelAction = cancelAction
  self.closeAction = closeAction
  self.toggleAction = toggleAction
  self.isChangeImg = isChangeImg
  self.text1 = text1
  self.text2 = text2
  self.OnCloseClick = false
  self.toggleText = toggleText
  self.btnNoUseDialog = btnNoUseDialog
  self.leftBtnPicName = leftBtnPicName
  self.rightBtnPicName = rightBtnPicName
  self.showToggle = showToggle == nil and true or showToggle
  self.costParam = costParam
  self.delayConfirm = delayConfirm
  self.alignment = alignment
  if cdConfirm and 0 < cdConfirm then
    self.cdConfirm = UITimeManager:GetInstance():GetServerSeconds() + cdConfirm
  else
    self.cdConfirm = nil
  end
end

local function RefreshView(self)
  self:RemoveUpdateTimer()
  local left_btn = self.left_btn
  local right_btn = self.right_btn
  local showCostBtnPanel = false
  if self.costParam and self.costParam.left and self.costParam.right then
    left_btn = self.costBtnPanel.leftBtn
    right_btn = self.costBtnPanel.rightBtn
    showCostBtnPanel = true
    self.btnPanel:SetActive(false)
    self.costBtnPanel:SetActive(true)
    self.costBtnPanel:SetData(self.text1, self.text2, self.btnNoUseDialog, self.costParam)
  else
    self.btnPanel:SetActive(true)
    self.costBtnPanel:SetActive(false)
  end
  if self.toggleText ~= nil and self.toggleText ~= "" then
    self.checkbox_text:SetText(self.toggleText)
  else
    self.checkbox_text:SetLocalText(120059)
  end
  if self.title ~= nil and self.title ~= "" then
    self.title_text:SetText(self.title)
  else
    self.title_text:SetLocalText(100378)
  end
  if self.content ~= nil and self.content ~= "" then
    self.content_text:SetText(self.content)
    if self.alignment then
      self.content_text:SetAlignment(self.alignment)
    else
      self.content_text:SetAlignment(CS.UnityEngine.TextAnchor.MiddleCenter)
    end
  else
    self.content_text:SetText("")
  end
  if self.btnNum ~= nil then
    left_btn:SetActive(self.btnNum > 0)
    right_btn:SetActive(self.btnNum > 1)
    if self.btnNum > 2 then
      self.btnNum = 2
    end
  else
    left_btn:SetActive(false)
    right_btn:SetActive(false)
  end
  if left_btn:GetActive() then
    if self.sureAction then
      left_btn:SetOnClick(function()
        if self:CheckSureBtn() then
          self:OnCloseInTimer()
          self.sureAction()
        end
      end)
    else
      left_btn:SetOnClick(function()
        self:OnCancelClick()
      end)
    end
    if not showCostBtnPanel then
      local useText
      self.left_btn_text:SetActive(true)
      self.left_btn_pic_name:SetActive(false)
      if self.cdConfirm and 0 < self.cdConfirm then
        CS.UIGray.SetGray(self.left_btn.transform, true, false)
        self:OnUpdateSec()
        self:AddUpdateTimer()
      else
        useText = self.left_btn_text
        if self.text1 ~= nil and self.text1 ~= "" then
          if self.btnNoUseDialog then
            useText:SetText(self.text1)
          else
            useText:SetLocalText(self.text1)
          end
        else
          useText:SetLocalText(GameDialogDefine.CONFIRM)
        end
      end
    end
  end
  if right_btn:GetActive() then
    if self.cancelAction then
      right_btn:SetOnClick(function()
        self:OnCloseInTimer()
        self.cancelAction()
      end)
    else
      right_btn:SetOnClick(function()
        self:OnCancelClick()
      end)
    end
    if not showCostBtnPanel then
      local useText
      if self.rightBtnPicName == nil or self.rightBtnPicName == "" then
        self.right_btn_text:SetActive(true)
        self.right_btn_pic_name:SetActive(false)
        useText = self.right_btn_text
      else
        self.right_btn_text:SetActive(false)
        self.right_btn_pic_name:SetActive(true)
        useText = self.right_btn_pic_name
        self.right_btn_pic_icon:LoadSprite(self.rightBtnPicName)
      end
      if self.text2 ~= nil and self.text2 ~= "" then
        if self.btnNoUseDialog then
          useText:SetText(self.text2)
        else
          useText:SetLocalText(self.text2)
        end
      else
        useText:SetLocalText(GameDialogDefine.CANCEL)
      end
    end
  end
  if self.closeAction then
    self.close_btn:SetOnClick(function()
      self:OnCloseInTimer()
      self.closeAction()
    end)
    self.close_panel_btn:SetOnClick(function()
      self:OnCloseInTimer()
      self.closeAction()
    end)
  else
    self.close_btn:SetOnClick(function()
      self:OnCancelClick()
    end)
    self.close_panel_btn:SetOnClick(function()
      self:OnCancelClick()
    end)
  end
  self.back_toggle:SetOnValueChanged(nil)
  self.back_toggle:SetIsOn(false)
  self.back_toggle:SetOnValueChanged(function()
    self.toggleAction(not self.back_toggle:GetIsOn())
  end)
  self.delayConfirmFlag = self.delayConfirm ~= nil
  local showToggle = self.showToggle and not delayConfirmFlag
  self.back_toggle:SetActive(showToggle)
  if self.delayConfirmFlag then
    left_btn:SetSafeClickMode(true)
    self.delayTimer = self.delayConfirm.delayTime
    self.delay:SetActive(true)
    CS.UIGray.SetGray(self.left_btn.transform, true, true)
    if self.delayConfirm.des1 == nil then
      self.delayConfirm.des1 = "season_alliance_reward_tips_1"
    end
    if self.delayConfirm.des2 == nil then
      self.delayConfirm.des2 = "season_alliance_reward_tips_2"
    end
    self.delay_des:SetText(Localization:GetString(self.delayConfirm.des1, self.delayTimer))
  else
    self.delay:SetActive(false)
    CS.UIGray.SetGray(self.left_btn.transform, false, true)
  end
  if self.isChangeImg then
    left_btn:LoadSprite(string.format(LoadPath.LWCommonPath, "tongyong_cfm_anniu_4"))
    right_btn:LoadSprite(string.format(LoadPath.LWCommonPath, "tongyong_cfm_anniu_3"))
  else
    right_btn:LoadSprite(string.format(LoadPath.LWCommonPath, "tongyong_cfm_anniu_3"))
    left_btn:LoadSprite(string.format(LoadPath.LWCommonPath, "tongyong_cfm_anniu_1"))
  end
  local size = self.content_text:GetSizeDelta()
  local x, y, z = self.content_text:GetLocalPositionXYZ()
  if not self.delay:GetActive() and not self.back_toggle:GetActive() then
    size.y = 280
    y = 37.77
  else
    size.y = 195
    y = 67.77
  end
  self.content_text:SetSizeDelta(size)
  self.content_text:SetLocalPositionXYZ(x, y, z)
end

local function OnDestroy(self)
  self:RemoveUpdateTimer()
  self.title_text = nil
  self.close_btn = nil
  self.content_text = nil
  self.left_btn = nil
  self.left_btn_text = nil
  self.right_btn = nil
  self.right_btn_text = nil
  self.checkbox_text = nil
  self.back_toggle = nil
  self.isChangeImg = nil
  self.toggleText = nil
  self.btnPanel = nil
  self.costBtnPanel = nil
  self.costParam = nil
  self.delay = nil
  self.delay_des = nil
  self.delayConfirm = nil
  self.delayConfirmFlag = nil
  self.delayTimer = nil
  self.cdConfirm = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshView()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
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

function UISellConfirmView:Update1000MS()
  if self.delayConfirmFlag then
    self.delayTimer = self.delayTimer - 1
    if self.delayTimer > 0 then
      self.delay_des:SetText(Localization:GetString(self.delayConfirm.des1, self.delayTimer))
    else
      self.delayConfirmFlag = false
      self.delay:SetActive(false)
      CS.UIGray.SetGray(self.left_btn.transform, false, true)
    end
  end
end

function UISellConfirmView:CheckSureBtn()
  if self.delayConfirmFlag then
    UIUtil.ShowTips(Localization:GetString(self.delayConfirm.des2, self.delayTimer))
    return false
  end
  return true
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
  local now = UITimeManager:GetInstance():GetServerSeconds()
  local leftSec = self.cdConfirm - now
  leftSec = 0 < leftSec and leftSec or 0
  local str
  if string.IsNullOrEmpty(self.text1) then
    str = Localization:GetString(GameDialogDefine.CONFIRM)
  elseif self.btnNoUseDialog then
    str = self.text1
  else
    str = Localization:GetString(self.text1)
  end
  if leftSec <= 0 then
    self:RemoveUpdateTimer()
    self.left_btn_text:SetText(str)
    CS.UIGray.SetGray(self.left_btn.transform, false, true)
  else
    self.left_btn_text:SetText(leftSec .. "s " .. str)
  end
end

UISellConfirmView.OnCreate = OnCreate
UISellConfirmView.OnDestroy = OnDestroy
UISellConfirmView.OnEnable = OnEnable
UISellConfirmView.OnDisable = OnDisable
UISellConfirmView.OnAddListener = OnAddListener
UISellConfirmView.OnRemoveListener = OnRemoveListener
UISellConfirmView.ComponentDefine = ComponentDefine
UISellConfirmView.OnCancelClick = OnCancelClick
UISellConfirmView.RefreshView = RefreshView
UISellConfirmView.ToggleControlBorS = ToggleControlBorS
UISellConfirmView.SetData = SetData
UISellConfirmView.OnCloseInTimer = OnCloseInTimer
UISellConfirmView.AddUpdateTimer = AddUpdateTimer
UISellConfirmView.RemoveUpdateTimer = RemoveUpdateTimer
UISellConfirmView.OnUpdateSec = OnUpdateSec
return UISellConfirmView
