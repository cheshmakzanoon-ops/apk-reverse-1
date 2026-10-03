local UILWCommonRenameViewView = BaseClass("UILWCommonRenameViewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UILWCommonRenameViewView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UILWCommonRenameViewView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWCommonRenameViewView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnClose = self:AddComponent(UIButton, "PopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle = self:AddComponent(UIText, "PopUpTitle/Common_img_title/titleText")
  self.textCurNameTitle = self:AddComponent(UIText, "PopUpTitle/Content/CurNameLayout/TextCurNameTitle")
  self.textCurNameValue = self:AddComponent(UIText, "PopUpTitle/Content/CurNameLayout/TextCurNameValue")
  self.textInputTitle = self:AddComponent(UIText, "PopUpTitle/Content/TextInputTitle")
  self.compInputField = self:AddComponent(UIInput, "PopUpTitle/Content/InputField")
  self.compInputField:SetOnValueChange(function(value)
    self:OnInputValueChange(value)
  end)
  self.compInputField:SetOnEndEdit(function(value)
    self:OnInputValueChange(value)
  end)
  self.textHolder = self:AddComponent(UIText, "PopUpTitle/Content/InputField/viewport/holder")
  self.textHolder:SetText(Localization:GetString("dominator_change_name_desc_3"))
  self.textNum = self:AddComponent(UIText, "PopUpTitle/Content/InputField/viewport/numText")
  self.btnConfirm = self:AddComponent(UIButton, "PopUpTitle/BtnConfirm")
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.textConfirm = self:AddComponent(UIText, "PopUpTitle/BtnConfirm/Content/ButtonText")
  self.textWarn = self:AddComponent(UIText, "PopUpTitle/Content/warnText")
end

function UILWCommonRenameViewView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.btnClose = nil
  self.textTitle = nil
  self.textCurNameTitle = nil
  self.textCurNameValue = nil
  self.textInputTitle = nil
  self.compInputField = nil
  self.btnConfirm = nil
  self.textConfirm = nil
  self.textHolder = nil
  self.textWarn = nil
  self.textNum = nil
end

function UILWCommonRenameViewView:DataDefine()
  self.checkState = CheckNameType.MinNameChar
  self.canChange = false
end

function UILWCommonRenameViewView:DataDestroy()
end

function UILWCommonRenameViewView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.TacticalCardCheckEditCardGroupNameSuccess, self.OnCheckNameCallback)
end

function UILWCommonRenameViewView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.TacticalCardCheckEditCardGroupNameSuccess, self.OnCheckNameCallback)
end

function UILWCommonRenameViewView:OnOpen()
  local params = self:GetUserData()
  local titleKey = params.titleKey
  local curNameTitleKey = params.curNameTitleKey
  local curNameStr = params.curNameStr
  self.confirmCallback = params.confirmCallback
  if not string.IsNullOrEmpty(titleKey) then
    self.textTitle:SetLocalText(titleKey)
  else
    self.textTitle:SetText("")
  end
  if not string.IsNullOrEmpty(curNameTitleKey) then
    self.textCurNameTitle:SetText(Localization:GetString(curNameTitleKey))
  end
  self.textCurNameValue:SetText(curNameStr or "")
  self.textWarn:SetText("")
  self.textNum:SetText("")
  self.compInputField:SetText("")
  self.canChange = false
  self.inputValue = ""
  CS.UIGray.SetGray(self.btnConfirm.transform, true, false)
end

function UILWCommonRenameViewView:OnInputValueChange(value)
  self.inputValue = value
  local state = self:CheckNameLength(self.inputValue)
  if state == CheckNameType.None then
    SFSNetwork.SendMessage(MsgDefines.BattleCardPlanNameCheck, {
      name = self.inputValue
    })
  else
    self:UpdateCheckStateUI(state)
  end
  self.textHolder:SetActive(string.IsNullOrEmpty(self.inputValue))
end

function UILWCommonRenameViewView:CheckNameLength(name)
  local type = CheckNameType.None
  local len = #name
  if len < MIN_AL_NAME_CHAR then
    type = CheckNameType.MinNameChar
  elseif len > MAX_AL_NAME_CHAR then
    type = CheckNameType.MaxNameChar
  end
  return type
end

function UILWCommonRenameViewView:UpdateCheckStateUI(state)
  self.canChange = false
  if string.IsNullOrEmpty(self.inputValue) then
    self.textNum:SetText("")
    self.textWarn:SetText("")
  else
    self.checkState = state
    local len = #self.inputValue
    self.textNum:SetText(len .. "/" .. MAX_AL_NAME_CHAR)
    if state == CheckNameType.None then
      self.textWarn:SetText("")
      self.canChange = true
    elseif state == CheckNameType.MinNameChar or state == CheckNameType.MaxNameChar then
      self.textWarn:SetLocalText(120193)
    elseif state == CheckNameType.Exist then
      self.textWarn:SetLocalText(280038)
    elseif state == CheckNameType.IllegalChar then
      self.textWarn:SetLocalText(129082)
    elseif state == CheckNameType.SensitiveWords then
      self.textWarn:SetLocalText(280073)
    else
      self.canChange = true
      self.textWarn:SetText("")
    end
  end
  CS.UIGray.SetGray(self.btnConfirm.transform, not self.canChange, self.canChange)
end

function UILWCommonRenameViewView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UILWCommonRenameViewView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILWCommonRenameViewView:OnBtnConfirmClick()
  if string.IsNullOrEmpty(self.inputValue) then
    return
  end
  local state = self.checkState
  if self.inputValue == "" then
    state = CheckNameType.MinNameChar
  end
  if state == CheckNameType.IllegalChar then
    UIUtil.ShowTipsId(129082)
    return
  elseif state == CheckNameType.MinNameChar or state == CheckNameType.MaxNameChar then
    UIUtil.ShowTipsId(120193)
    return
  elseif state == CheckNameType.Exist then
    UIUtil.ShowTipsId(280038)
    return
  elseif state == CheckNameType.SensitiveWords then
    UIUtil.ShowTipsId(280073)
    return
  end
  if self.confirmCallback then
    self.confirmCallback(self.inputValue)
  end
  self.ctrl:CloseSelf()
end

function UILWCommonRenameViewView:OnCheckNameCallback(state)
  local len = #self.inputValue
  if len < MIN_AL_NAME_CHAR then
    state = CheckNameType.MinNameChar
  elseif len > MAX_AL_NAME_CHAR then
    state = CheckNameType.MaxNameChar
  end
  self:UpdateCheckStateUI(state)
end

return UILWCommonRenameViewView
