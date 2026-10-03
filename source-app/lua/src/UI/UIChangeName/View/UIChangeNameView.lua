local UIChangeNameView = BaseClass("UIChangeNameView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "UICommonMiniPopUpTitle/titleText"
local des_path = "ImgBg/desText"
local input_path = "ImgBg/InputField"
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local close_btn_path = "UICommonMiniPopUpTitle/CloseBtn"
local warn_path = "ImgBg/warnText"
local name_path = "ImgBg/nameText"
local num_path = "ImgBg/numText"
local gray_img_path = "ImgBg/Button/Gray"
local first_use_txt_path = "ImgBg/Button/firstUseText"
local use_item_obj_path = "ImgBg/Button/UseItem"
local use_txt_path = "ImgBg/Button/UseItem/Txt1"
local use_btn_path = "ImgBg/Button"
local use_diamondtxt_path = "ImgBg/Button/UseItem/txt2"
local use_consumption_icon = "ImgBg/Button/UseItem/icon"
local diamondIcon = "Common_icon_gold"
local changeNameCardIcon = "item006"
local diamondNum = 1
local haveChangeName

local function OnCreate(self)
  base.OnCreate(self)
  self.checkState = CheckNameType.MinNameChar
  local tab = self:GetUserData()
  if tab ~= nil and tab.window == "chat" then
    self._isfromchat = true
  end
  self.ctrl.fromWindow = tab and tab.window or nil
  self.ctrl.callback = tab and tab.callback or nil
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText(390306)
  self.first_use_txt = self:AddComponent(UIText, first_use_txt_path)
  self.first_use_txt:SetLocalText(130126)
  self.first_use_txt:SetActive(false)
  self.use_txt = self:AddComponent(UIText, use_txt_path)
  self.use_txt:SetLocalText(GameDialogDefine.CONFIRM)
  self.first_use_txt_shadow = self:AddComponent(UIShadow, first_use_txt_path)
  self.use_txt_shadow = self:AddComponent(UIShadow, use_txt_path)
  self.use_diamondtxt = self:AddComponent(UIText, use_diamondtxt_path)
  self.des = self:AddComponent(UIText, des_path)
  self.des:SetLocalText(390132)
  self.warn = self:AddComponent(UIText, warn_path)
  self.warn:SetText("")
  self.nameTxt = self:AddComponent(UIText, name_path)
  self.nameTxt:SetLocalText(100031)
  self.numTxt = self:AddComponent(UIText, num_path)
  self.numTxt:SetText("")
  self.gray_img = self:AddComponent(UIBaseContainer, gray_img_path)
  self.use_item_obj = self:AddComponent(UIBaseContainer, use_item_obj_path)
  self.use_item_obj:SetActive(true)
  self.use_btn = self:AddComponent(UIButton, use_btn_path)
  self.use_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnChangeNameClick()
  end)
  self.input = self:AddComponent(UIInput, input_path)
  self.input:SetOnValueChange(function(value)
    self:IptOnValueChange(value)
  end)
  self.input:SetOnEndEdit(function(value)
    self:IptOnValueChange(value)
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.consumImg = self:AddComponent(UIImage, use_consumption_icon)
  if self._isfromchat and LuaEntry.Player.renameTime < 1 then
    self.des:SetLocalText(280081)
    self.first_use_txt:SetLocalText(110006)
    self.first_use_txt:SetActive(true)
    self.use_item_obj:SetActive(false)
  elseif LuaEntry.Player.renameTime < 1 then
    self.first_use_txt:SetLocalText(110006)
    self.first_use_txt:SetActive(true)
    self.use_item_obj:SetActive(false)
  end
end

local function Update(self)
  if self.inputValue == "" then
    return
  end
  local state = self.ctrl:CheckName(self.inputValue)
  self:CheckNameChangeState(state)
end

local function OnDestroy(self)
  self.title = nil
  self.des = nil
  self.warn = nil
  self.first_use_txt = nil
  self.use_txt = nil
  self.des = nil
  self.warn = nil
  self.gray_img = nil
  self.use_item_obj = nil
  self.nameTxt = nil
  self.numTxt = nil
  self.use_btn = nil
  self.input = nil
  self.close_btn = nil
  self.return_btn = nil
  self.inputValue = nil
  self.first_use_txt_shadow = nil
  self.use_txt_shadow = nil
  self.use_diamondtxt = nil
  self.diamondNum = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:InitButtonState()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function InitButtonState(self)
  self.input:SetText("")
  self.inputValue = ""
  self.gray_img:SetActive(false)
  self.canChange = false
  haveChangeName = self.ctrl:CheckHaveEnoughItem()
  diamondNum = DataCenter.ItemTemplateManager:GetItemPrice(SpecialItemId.CHANGE_NAME)
  if haveChangeName == true then
    diamondNum = 1
    self.use_diamondtxt:SetText("X" .. diamondNum)
    self.consumImg:LoadSprite(string.format(LoadPath.ItemPath, changeNameCardIcon))
    self.consumImg.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  else
    self.use_diamondtxt:SetText(diamondNum)
    self.consumImg.transform:Set_localScale(ResetScale.x * 1.2, ResetScale.y * 1.2, ResetScale.z * 1.2)
    self.consumImg:LoadSprite(string.format(LoadPath.LWCommonPath, diamondIcon))
    local num = CommonUtil.GetResOrItemCount(ResourceType.Gold)
    if num - diamondNum < 0 then
      return
    end
  end
end

local function CanBuy()
  local num = CommonUtil.GetResOrItemCount(ResourceType.Gold)
  if haveChangeName == true then
    return true
  end
  if num - diamondNum < 0 then
    return false
  end
  return true
end

local function IptOnValueChange(self, value)
  self.inputValue = value
  local state = self.ctrl:CheckName(self.inputValue)
  if state == CheckNameType.None then
    self.ctrl:SendCheckNameMessage(self.inputValue)
  else
    self:CheckNameChangeState(state)
  end
end

local function OnChangeNameClick(self)
  local state = self.checkState
  if self.inputValue == "" then
    state = CheckNameType.MinNameChar
  end
  print(state)
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
  if LuaEntry.Player.renameTime < 1 then
    self.ctrl:SendChangeNameMessage(self.inputValue)
    self.ctrl:CloseSelf()
    return
  end
  local tips = "280028"
  if haveChangeName == true then
    tips = "280171"
  elseif CanBuy() == false then
    UIUtil.ShowTipsId("E100001")
    return
  end
  UIUtil.ShowMessage(Localization:GetString(tips, diamondNum), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    self.ctrl:SendChangeNameMessage(self.inputValue)
    self.ctrl:CloseSelf()
  end)
end

local function OnCheckNameBack(self, data)
  local state = data
  local ctrlCheckState = self.ctrl:CheckName(self.inputValue)
  if ctrlCheckState == CheckNameType.None then
  else
    state = ctrlCheckState
  end
  self:CheckNameChangeState(state)
end

local function CheckNameChangeState(self, type)
  if self.inputValue == "" then
    if self._isfromchat and LuaEntry.Player.renameTime < 1 then
      self.des:SetLocalText(280081)
    else
      self.des:SetLocalText(390132)
    end
    self.numTxt:SetText("")
  else
    self.des:SetText("")
    local len = #self.inputValue
    self.numTxt:SetText(len .. "/" .. MAX_AL_NAME_CHAR)
  end
  if self.inputValue == "" then
    self.warn:SetText("")
    return
  end
  self.checkState = type
  if type == CheckNameType.None and self.ctrl:CheckHaveEnoughItem() then
    self.warn:SetText("")
    self.canChange = true
  else
    self.canChange = false
    if type == CheckNameType.MinNameChar or type == CheckNameType.MaxNameChar then
      self.warn:SetLocalText(120193)
    elseif type == CheckNameType.Exist then
      self.warn:SetLocalText(280038)
    elseif type == CheckNameType.IllegalChar then
      self.warn:SetLocalText(129082)
    elseif type == CheckNameType.SensitiveWords then
      self.warn:SetLocalText(280073)
    else
      self.warn:SetText("")
    end
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.NickNameChackEvent, self.OnCheckNameBack)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.NickNameChackEvent, self.OnCheckNameBack)
end

UIChangeNameView.OnCreate = OnCreate
UIChangeNameView.OnDestroy = OnDestroy
UIChangeNameView.InitButtonState = InitButtonState
UIChangeNameView.OnEnable = OnEnable
UIChangeNameView.OnDisable = OnDisable
UIChangeNameView.IptOnValueChange = IptOnValueChange
UIChangeNameView.OnChangeNameClick = OnChangeNameClick
UIChangeNameView.OnCheckNameBack = OnCheckNameBack
UIChangeNameView.CheckNameChangeState = CheckNameChangeState
UIChangeNameView.OnAddListener = OnAddListener
UIChangeNameView.OnRemoveListener = OnRemoveListener
return UIChangeNameView
