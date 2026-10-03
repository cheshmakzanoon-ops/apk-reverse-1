local UICreateAllianceView = BaseClass("UICreateAllianceView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "UICommonMiniPopUpTitle/titleText"
local des_path = "ImgBg/desText"
local input_path = "ImgBg/InputField"
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local close_btn_path = "UICommonMiniPopUpTitle/CloseBtn"
local warn_path = "ImgBg/warnText"
local use_btn_path = "ImgBg/createBtn"
local create_txt_path = "ImgBg/createBtn/createBtnName"
local cost_obj_path = "ImgBg/createBtn/costObj"
local cost_txt_path = "ImgBg/createBtn/costObj/costBtnName"
local cost_num_path = "ImgBg/createBtn/costObj/itemCount"
local gray_img_path = "ImgBg/gray"
local place_holder_txt_path = "ImgBg/InputField/Placeholder"
local costItemId = "210151"

local function OnCreate(self)
  base.OnCreate(self)
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText(390288)
  self.create_txt = self:AddComponent(UIText, create_txt_path)
  self.create_txt:SetLocalText(GameDialogDefine.CONFIRM)
  self.cost_txt = self:AddComponent(UIText, cost_txt_path)
  self.cost_txt:SetLocalText(GameDialogDefine.CONFIRM)
  self.cost_num = self:AddComponent(UIText, cost_num_path)
  self.cost_obj = self:AddComponent(UIBaseContainer, cost_obj_path)
  self.des = self:AddComponent(UIText, des_path)
  self.des:SetLocalText(390132)
  self.warn = self:AddComponent(UIText, warn_path)
  self.warn:SetText("")
  self.btn_image = self:AddComponent(UIImage, use_btn_path)
  self.gray_image = self:AddComponent(UIImage, gray_img_path)
  self.gray = self.gray_image:GetMaterial()
  self.place_holder_txt = self:AddComponent(UIText, place_holder_txt_path)
  self.place_holder_txt:SetLocalText(120177)
  self.cost_txt_shadow = self:AddComponent(UIShadow, cost_txt_path)
  self.cost_num_shadow = self:AddComponent(UIShadow, cost_num_path)
  self.use_btn = self:AddComponent(UIButton, use_btn_path)
  self.use_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnCreateClick()
  end)
  self.input = self:AddComponent(UIInput, input_path)
  self.input:SetOnValueChange(function(value)
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
end

local function OnDestroy(self)
  self.title = nil
  self.des = nil
  self.warn = nil
  self.use_txt = nil
  self.des = nil
  self.warn = nil
  self.gray_img = nil
  self.use_btn = nil
  self.input = nil
  self.close_btn = nil
  self.return_btn = nil
  self.inputValue = nil
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
  self.inputValue = ""
  self.input:SetText("")
  self.btn_image:SetMaterial(self.gray)
  self.cost_txt_shadow:SetAllColor(YellowBtnShadowGrayColor)
  self.cost_num_shadow:SetAllColor(YellowBtnShadowGrayColor)
  self.needGold = LuaEntry.DataConfig:TryGetNum("alliance_cost", "k5")
  local costItem = DataCenter.ItemData:GetItemById(costItemId)
  local ownNum = costItem and costItem.count or 0
  self.isCostEnough = true
  ownNum = self.isCostEnough and ownNum or "<color=#ff0000>0</color>"
  self.cost_num:SetText(ownNum .. "/1")
  self.cost_obj.gameObject:SetActive(false)
  self.create_txt.gameObject:SetActive(true)
  self.canChange = false
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

local function OnCreateClick(self)
  if self.canChange then
    if not self.isCostEnough then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackage, {anim = true}, {
        welfareTagType = WelfareTagType.PackStore,
        targetShowType = "3;1"
      })
      return
    end
    UIUtil.ShowMessage(Localization:GetString("390864"), 2, nil, nil, function()
      self.ctrl:OnCreateClick(self.inputValue, "", "")
    end, nil, nil)
  end
end

local function OnCheckNameBack(self, data)
  local state = data
  if state ~= nil and state == true then
    self:CheckNameChangeState(CheckNameType.IllegalChar)
  else
    self:CheckNameChangeState(CheckNameType.None)
  end
end

local function CheckNameChangeState(self, type)
  if type == CheckNameType.None then
    self.btn_image:SetMaterial(nil)
    self.cost_txt_shadow:SetAllColor(YellowBtnShadowLightColor)
    self.cost_num_shadow:SetAllColor(YellowBtnShadowLightColor)
    self.warn:SetText("")
    self.canChange = true
  else
    self.btn_image:SetMaterial(self.gray)
    self.cost_txt_shadow:SetAllColor(YellowBtnShadowGrayColor)
    self.cost_num_shadow:SetAllColor(YellowBtnShadowGrayColor)
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
  self:AddUIListener(EventId.AllianceChangeNameSuccess, self.OnCheckNameBack)
  self:AddUIListener(EventId.AllianceCreateSuccess, self.OnCreateSuccess)
  self:AddUIListener(EventId.RefreshItems, self.InitButtonState)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceChangeNameSuccess, self.OnCheckNameBack)
  self:RemoveUIListener(EventId.AllianceCreateSuccess, self.OnCreateSuccess)
  self:RemoveUIListener(EventId.RefreshItems, self.InitButtonState)
end

local function OnCreateSuccess(self)
  self.ctrl:Close()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceMainTable)
end

UICreateAllianceView.OnCreate = OnCreate
UICreateAllianceView.OnDestroy = OnDestroy
UICreateAllianceView.InitButtonState = InitButtonState
UICreateAllianceView.OnEnable = OnEnable
UICreateAllianceView.OnDisable = OnDisable
UICreateAllianceView.IptOnValueChange = IptOnValueChange
UICreateAllianceView.OnCreateClick = OnCreateClick
UICreateAllianceView.OnCheckNameBack = OnCheckNameBack
UICreateAllianceView.CheckNameChangeState = CheckNameChangeState
UICreateAllianceView.OnAddListener = OnAddListener
UICreateAllianceView.OnRemoveListener = OnRemoveListener
UICreateAllianceView.OnCreateSuccess = OnCreateSuccess
return UICreateAllianceView
