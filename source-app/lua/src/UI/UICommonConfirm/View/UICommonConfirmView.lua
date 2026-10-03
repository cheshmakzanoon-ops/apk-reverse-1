local UICommonConfirmView = BaseClass("UICommonConfirmView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_text_path = "UICommonMiniPopUpTitle/titleText"
local close_btn_path = "UICommonMiniPopUpTitle/CloseBtn"
local content_text_path = "DesContent"
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
local DEFAULT_TOGGLE_TEXT_ID = 110103
local DEFAULT_TITLE_TEXT_ID = 100378

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:RemoveUpdateTimer()
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

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self, self.OnCancelClick))
  self.content_text = self:AddComponent(UIText, content_text_path)
  self.close_panel_btn = self:AddComponent(UIButton, close_panel_btn_path)
  self.close_panel_btn:SetOnClick(BindCallback(self, self.OnCancelClick))
  self.left_btn = self:AddComponent(UIButton, left_btn_path)
  self.left_btn_text = self:AddComponent(UIText, left_btn_text_path)
  self.left_btn_pic_name = self:AddComponent(UIText, left_btn_pic_name_path)
  self.left_btn_pic_icon = self:AddComponent(UIImage, left_btn_pic_icon_path)
  self.right_btn = self:AddComponent(UIButton, right_btn_path)
  self.right_btn_text = self:AddComponent(UIText, right_btn_text_path)
  self.right_btn_pic_name = self:AddComponent(UIText, right_btn_pic_name_path)
  self.right_btn_pic_icon = self:AddComponent(UIImage, right_btn_pic_icon_path)
  self.checkbox_text = self:AddComponent(UIText, checkbox_text)
  self.back_toggle = self:AddComponent(UIToggle, back_toggle_path)
  self.back_toggle:SetIsOn(false)
  self.btnPanel = self:AddComponent(UIBaseContainer, btnPanel_path)
  self.btnPanel:SetActive(true)
  self.delay = self:AddComponent(UIBaseContainer, delay_path)
  self.delay_des = self:AddComponent(UITextMeshProUGUIEx, delay_des_path)
end

local function CommonDestroy(self)
  self.title_text = nil
  self.close_btn = nil
  self.content_text = nil
  self.left_btn = nil
  self.left_btn_text = nil
  self.right_btn = nil
  self.right_btn_text = nil
  self.checkbox_text = nil
  self.back_toggle = nil
  self.btnPanel = nil
  self.costParam = nil
  self.delay = nil
  self.delay_des = nil
end

local function OnCancelClick(self)
  self.ctrl:CloseSelf()
end

local function SetData(self, param)
  self.param = param
  if param then
    local cdConfirm = param.cdConfirm
    if cdConfirm and 0 < cdConfirm then
      self.cdConfirm = UITimeManager:GetInstance():GetServerSeconds() + cdConfirm
    else
      self.cdConfirm = nil
    end
  end
end

local function RefreshView(self)
  self:RemoveUpdateTimer()
  if self.param == nil then
    self.ctrl:CloseSelf()
    return
  end
  local param = self.param
  local confirm_btn = self.right_btn
  local cancel_btn = self.left_btn
  local confirmBtnParam = param.confirmBtnParam
  local cancelBtnParam = param.cancelBtnParam
  param.type = param.type or CommonConfirmPanelType.Default
  param.btnType = param.btnType or CommonConfirmBtnType.Default
  if param.btnType == CommonConfirmBtnType.Default then
  elseif param.type == CommonConfirmPanelType.Default then
    confirm_btn = self.left_btn
    cancel_btn = self.right_btn
  end
  if param.type == CommonConfirmPanelType.Default then
    self.btnPanel:SetActive(true)
  else
    self.btnPanel:SetActive(false)
  end
  local toggleParam = param.toggleParam
  if toggleParam and toggleParam.toggleText and toggleParam.toggleText ~= "" then
    self.checkbox_text:SetText(toggleParam.toggleText)
  else
    self.checkbox_text:SetLocalText(DEFAULT_TOGGLE_TEXT_ID)
  end
  if param.title ~= nil and param.title ~= "" then
    self.title_text:SetText(param.title)
  else
    self.title_text:SetLocalText(DEFAULT_TITLE_TEXT_ID)
  end
  if param.contentText ~= nil and param.contentText ~= "" then
    self.content_text:SetText(param.contentText)
    if param.alignment then
      self.content_text:SetAlignment(param.alignment)
    else
      self.content_text:SetAlignment(CS.UnityEngine.TextAnchor.MiddleCenter)
    end
  else
    self.content_text:SetText("")
  end
  local showConfirm, showCancel
  if param.btnNum ~= nil then
    showConfirm = param.btnNum > 0
    confirm_btn:SetActive(showConfirm)
    showCancel = param.btnNum > 1
    cancel_btn:SetActive(showCancel)
    if param.btnNum > 2 then
      param.btnNum = 2
    end
  else
    confirm_btn:SetActive(false)
    cancel_btn:SetActive(false)
  end
  if showConfirm then
    if confirmBtnParam == nil then
      return
    end
    if confirmBtnParam.action then
      confirm_btn:SetOnClick(function()
        if self:CheckSureBtn() then
          self:OnCloseInTimer()
          confirmBtnParam.action(not self.back_toggle:GetIsOn())
        end
      end)
    else
      confirm_btn:SetOnClick(BindCallback(self, self.OnCancelClick))
    end
    if param.type == CommonConfirmPanelType.Default and param.btnType == CommonConfirmBtnType.Default then
      local useText
      self.right_btn_text:SetActive(true)
      self.right_btn_pic_name:SetActive(false)
      if self.cdConfirm and 0 < self.cdConfirm then
        CS.UIGray.SetGray(confirm_btn.transform, true, false)
        self:OnUpdateSec()
        self:AddUpdateTimer()
      else
        useText = self.right_btn_text
        if confirmBtnParam.context ~= nil and confirmBtnParam.context ~= "" then
          if param.notUseDialog then
            useText:SetText(confirmBtnParam.context)
          else
            useText:SetLocalText(confirmBtnParam.context)
          end
        else
          useText:SetLocalText(GameDialogDefine.CONFIRM)
        end
      end
    end
  end
  if showCancel then
    if cancelBtnParam and cancelBtnParam.action then
      cancel_btn:SetOnClick(function()
        self:OnCloseInTimer()
        cancelBtnParam.action()
      end)
    else
      cancel_btn:SetOnClick(BindCallback(self, self.OnCancelClick))
    end
    if param.type == CommonConfirmPanelType.Default and param.btnType == CommonConfirmBtnType.Default then
      local useText
      if cancelBtnParam == nil or cancelBtnParam.btnPicPath == nil or cancelBtnParam.btnPicPath == "" then
        self.left_btn_text:SetActive(true)
        self.left_btn_pic_name:SetActive(false)
        useText = self.left_btn_text
      else
        self.left_btn_text:SetActive(false)
        self.left_btn_pic_name:SetActive(true)
        useText = self.left_btn_pic_name
        self.left_btn_pic_icon:LoadSprite(cancelBtnParam.btnPicPath)
      end
      if cancelBtnParam and cancelBtnParam.context ~= nil and cancelBtnParam.context ~= "" then
        if param.notUseDialog then
          useText:SetText(cancelBtnParam.context)
        else
          useText:SetLocalText(cancelBtnParam.context)
        end
      else
        useText:SetLocalText(GameDialogDefine.CANCEL)
      end
    end
  end
  if param.closeAction then
    self.close_btn:SetOnClick(function()
      self:OnCloseInTimer()
      self.param.closeAction()
    end)
    self.close_panel_btn:SetOnClick(function()
      self:OnCloseInTimer()
      self.param.closeAction()
    end)
  else
    self.close_btn:SetOnClick(BindCallback(self, self.OnCancelClick))
    self.close_panel_btn:SetOnClick(BindCallback(self, self.OnCancelClick))
  end
  self.back_toggle:SetOnValueChanged(nil)
  self.back_toggle:SetIsOn(false)
  self.back_toggle:SetOnValueChanged(function()
    if param.toggleParam and param.toggleParam.toggleAction then
      param.toggleParam.toggleAction(not self.back_toggle:GetIsOn())
    end
  end)
  self.delayConfirmFlag = param.delayConfirm ~= nil
  param.showToggle = param.showToggle == nil and true or param.showToggle
  local showToggle = param.showToggle and not self.delayConfirmFlag
  self.back_toggle:SetActive(showToggle)
  cancel_btn:LoadSprite(string.format(LoadPath.LWCommonPath, "tongyong_cfm_anniu_3"))
  confirm_btn:LoadSprite(string.format(LoadPath.LWCommonPath, "tongyong_cfm_anniu_1"))
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

local function OnCloseInTimer(self)
  self.OnCloseClick = true
  local closeTimer = TimerManager:GetInstance():GetTimer(0.1, function()
    if self.OnCloseClick and self.ctrl then
      self.ctrl:CloseSelf()
    end
  end, nil, true, false, false)
  closeTimer:Start()
end

function UICommonConfirmView:CheckSureBtn()
  if self.delayConfirmFlag then
    if self.param and self.param.confirmBtnParam then
      UIUtil.ShowTips(Localization:GetString(self.param.confirmBtnParam.delayConfirm.des2, self.delayTimer))
    end
    return false
  end
  return true
end

local function AddUpdateTimer(self)
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
  if self.param and self.param.confirmBtnParam then
    local confirmBtnParam = self.param.confirmBtnParam
    if not string.IsNullOrEmpty(confirmBtnParam.context) then
      if self.param.notUseDialog then
        str = confirmBtnParam.context
      else
        str = Localization:GetString(confirmBtnParam.context)
      end
    else
      str = Localization:GetString(GameDialogDefine.CONFIRM)
    end
  end
  if leftSec <= 0 then
    self:RemoveUpdateTimer()
    self.right_btn_text:SetText(str)
    CS.UIGray.SetGray(self.right_btn.transform, false, true)
  else
    self.right_btn_text:SetText(leftSec .. "s " .. str)
  end
end

UICommonConfirmView.OnCreate = OnCreate
UICommonConfirmView.OnDestroy = OnDestroy
UICommonConfirmView.OnEnable = OnEnable
UICommonConfirmView.OnDisable = OnDisable
UICommonConfirmView.OnAddListener = OnAddListener
UICommonConfirmView.OnRemoveListener = OnRemoveListener
UICommonConfirmView.ComponentDefine = ComponentDefine
UICommonConfirmView.OnCancelClick = OnCancelClick
UICommonConfirmView.RefreshView = RefreshView
UICommonConfirmView.SetData = SetData
UICommonConfirmView.OnCloseInTimer = OnCloseInTimer
UICommonConfirmView.AddUpdateTimer = AddUpdateTimer
UICommonConfirmView.RemoveUpdateTimer = RemoveUpdateTimer
UICommonConfirmView.OnUpdateSec = OnUpdateSec
UICommonConfirmView.CommonDestroy = CommonDestroy
return UICommonConfirmView
