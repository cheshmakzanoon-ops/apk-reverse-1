local UILWDominatorEditUserNameView = BaseClass("UILWDominatorEditUserNameView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UILWDominatorEditUserNameView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UILWDominatorEditUserNameView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorEditUserNameView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnClose = self:AddComponent(UIButton, "PopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle = self:AddComponent(UIText, "PopUpTitle/Common_img_title/titleText")
  self.textTitle:SetText(Localization:GetString("dominator_change_name_titel_1"))
  self.textCurNameTitle = self:AddComponent(UIText, "PopUpTitle/Content/CurNameLayout/TextCurNameTitle")
  self.textCurNameTitle:SetText(Localization:GetString("dominator_change_name_desc_1"))
  self.textCurNameValue = self:AddComponent(UIText, "PopUpTitle/Content/CurNameLayout/TextCurNameValue")
  self.textInputTitle = self:AddComponent(UIText, "PopUpTitle/Content/TextInputTitle")
  self.textInputTitle:SetText(Localization:GetString("dominator_change_name_desc_2"))
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
  self.textConfirm = self:AddComponent(UIText, "PopUpTitle/BtnConfirm/TextConfirm")
  self.textConfirm:SetText(Localization:GetString("dominator_change_name_button_1"))
  self.imgBtnNameEditIcon = self:AddComponent(UIImage, "PopUpTitle/BtnConfirm/BtnNameEditLayout/BtnNameEditIcon")
  self.textBtnNameEditNum = self:AddComponent(UIText, "PopUpTitle/BtnConfirm/BtnNameEditLayout/BtnNameEditNum")
  self.textWarn = self:AddComponent(UIText, "PopUpTitle/Content/warnText")
end

function UILWDominatorEditUserNameView:ComponentDestroy()
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
  self.imgBtnNameEditIcon = nil
  self.textBtnNameEditNum = nil
end

function UILWDominatorEditUserNameView:DataDefine()
  self.checkState = CheckNameType.MinNameChar
  self.canChange = false
end

function UILWDominatorEditUserNameView:DataDestroy()
end

function UILWDominatorEditUserNameView:OnOpen()
  self.uuid = self:GetUserData()
  if self.uuid == nil then
    return
  end
  self.info = DataCenter.DominatorManager:GetInfoByUuid(self.uuid)
  if self.info == nil then
    return
  end
  self.imgBtnNameEditIcon:LoadSprite(string.format(LoadPath.CommonPath, "Common_icon_gold"))
  local num = DataCenter.DominatorManager:GetEditUserNameDiamondCostNum()
  self.textBtnNameEditNum:SetText(tostring(num))
  self.textCurNameValue:SetText(self.info:GetUserName())
  self.textWarn:SetText("")
  self.textNum:SetText("")
  self.compInputField:SetText("")
  self.canChange = false
  self.inputValue = ""
  CS.UIGray.SetGray(self.btnConfirm.transform, true, false)
end

function UILWDominatorEditUserNameView:OnInputValueChange(value)
  self.inputValue = value
  local state = self.ctrl:CheckNameLength(self.inputValue)
  if state == CheckNameType.None then
    DataCenter.DominatorManager:SendCheckEditUserNameMessage(self.uuid, self.inputValue)
  else
    self:UpdateCheckStateUI(state)
  end
  self.textHolder:SetActive(string.IsNullOrEmpty(self.inputValue))
end

function UILWDominatorEditUserNameView:UpdateCheckStateUI(state)
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

function UILWDominatorEditUserNameView:OnCheckNameCallback(state)
  local len = #self.inputValue
  if len < MIN_AL_NAME_CHAR then
    state = CheckNameType.MinNameChar
  elseif len > MAX_AL_NAME_CHAR then
    state = CheckNameType.MaxNameChar
  end
  self:UpdateCheckStateUI(state)
end

function UILWDominatorEditUserNameView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DominatorEditUserNameSuccess, self.OnEditSuccess)
  self:AddUIListener(EventId.DominatorCheckEditUserNameSuccess, self.OnCheckNameCallback)
end

function UILWDominatorEditUserNameView:OnRemoveListener()
  self:RemoveUIListener(EventId.DominatorEditUserNameSuccess, self.OnEditSuccess)
  self:RemoveUIListener(EventId.DominatorCheckEditUserNameSuccess, self.OnCheckNameCallback)
  base.OnRemoveListener(self)
end

function UILWDominatorEditUserNameView:OnEditSuccess()
  self.ctrl:CloseSelf()
end

function UILWDominatorEditUserNameView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UILWDominatorEditUserNameView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILWDominatorEditUserNameView:OnBtnConfirmClick()
  local needNum = DataCenter.DominatorManager:GetEditUserNameDiamondCostNum()
  if needNum <= 0 then
    return
  end
  local num = CommonUtil.GetResOrItemCount(ResourceType.Gold)
  if needNum > num then
    UIUtil.ShowTipsId("E100001")
    return
  end
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
  if self.uuid then
    DataCenter.DominatorManager:SendEditUserNameMessage(self.uuid, self.inputValue)
  end
end

return UILWDominatorEditUserNameView
