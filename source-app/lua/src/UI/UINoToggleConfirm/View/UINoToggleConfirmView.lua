local UINoToggleConfirmView = BaseClass("UINoToggleConfirmView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_text_path = "UICommonMiniPopUpTitle/titleText"
local close_btn_path = "UICommonMiniPopUpTitle/CloseBtn"
local content_text_path = "DesName"
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
end

local function OnCancelClick(self)
  self.ctrl:OnCancelClick()
end

local function ToggleControlBorS(self)
  self.ctrl:OnCheckBoxClick(self.back_toggle:GetIsOn())
end

local function SetData(self, title, contentText, btnNum, text1, text2, sureAction, toggleAction, cancelAction, closeAction, isChangeImg, toggleText, btnNoUseDialog, leftBtnPicName, rightBtnPicName, showToggle)
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
end

local function RefreshView(self)
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
  else
    self.content_text:SetText("")
  end
  if self.btnNum ~= nil then
    self.left_btn:SetActive(self.btnNum > 0)
    self.right_btn:SetActive(self.btnNum > 1)
    if self.btnNum > 2 then
      self.btnNum = 2
    end
  else
    self.left_btn:SetActive(false)
    self.right_btn:SetActive(false)
  end
  if self.left_btn:GetActive() then
    if self.sureAction then
      self.left_btn:SetOnClick(function()
        self:OnCloseInTimer()
        self.sureAction()
      end)
    else
      self.left_btn:SetOnClick(function()
        self:OnCancelClick()
      end)
    end
    local useText
    if self.leftBtnPicName == nil or self.leftBtnPicName == "" then
      self.left_btn_text:SetActive(true)
      self.left_btn_pic_name:SetActive(false)
      useText = self.left_btn_text
    else
      self.left_btn_text:SetActive(false)
      self.left_btn_pic_name:SetActive(true)
      useText = self.left_btn_pic_name
      self.left_btn_pic_icon:LoadSprite(self.leftBtnPicName)
    end
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
  if self.right_btn:GetActive() then
    if self.cancelAction then
      self.right_btn:SetOnClick(function()
        self:OnCloseInTimer()
        self.cancelAction()
      end)
    else
      self.right_btn:SetOnClick(function()
        self:OnCancelClick()
      end)
    end
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
  if self.closeAction then
    self.close_btn:SetOnClick(function()
      self:OnCloseInTimer()
      self.closeAction()
    end)
  else
    self.close_btn:SetOnClick(function()
      self:OnCancelClick()
    end)
  end
  self.back_toggle:SetOnValueChanged(nil)
  self.back_toggle:SetIsOn(false)
  self.back_toggle:SetOnValueChanged(function()
    self.toggleAction(not self.back_toggle:GetIsOn())
  end)
  self.back_toggle:SetActive(self.showToggle)
  if self.isChangeImg then
    local lfImg = "tongyong_cfm_anniu_4"
    local rtImg = "tongyong_cfm_anniu_3"
    if type(self.isChangeImg) == "string" and not string.IsNullOrEmpty(self.isChangeImg) then
      local imgs = string.split(self.isChangeImg, "|")
      if imgs and #imgs == 2 then
        lfImg = imgs[1]
        rtImg = imgs[2]
      end
    end
    self.left_btn:LoadSprite(string.format(LoadPath.LWCommonPath, lfImg))
    self.right_btn:LoadSprite(string.format(LoadPath.LWCommonPath, rtImg))
  else
    self.right_btn:LoadSprite(string.format(LoadPath.LWCommonPath, "tongyong_cfm_anniu_3"))
    self.left_btn:LoadSprite(string.format(LoadPath.LWCommonPath, "tongyong_cfm_anniu_1"))
  end
end

local function OnDestroy(self)
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

UINoToggleConfirmView.OnCreate = OnCreate
UINoToggleConfirmView.OnDestroy = OnDestroy
UINoToggleConfirmView.OnEnable = OnEnable
UINoToggleConfirmView.OnDisable = OnDisable
UINoToggleConfirmView.OnAddListener = OnAddListener
UINoToggleConfirmView.OnRemoveListener = OnRemoveListener
UINoToggleConfirmView.ComponentDefine = ComponentDefine
UINoToggleConfirmView.OnCancelClick = OnCancelClick
UINoToggleConfirmView.RefreshView = RefreshView
UINoToggleConfirmView.ToggleControlBorS = ToggleControlBorS
UINoToggleConfirmView.SetData = SetData
UINoToggleConfirmView.OnCloseInTimer = OnCloseInTimer
return UINoToggleConfirmView
