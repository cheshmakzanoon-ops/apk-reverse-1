local UISettingLanguageView = BaseClass("UISettingLanguageView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UISettingLanguageCell = require("UI.UISetting.UISettingLanguage.Component.UISettingLanguageCell")
local txt_title_path = "Root/Content/txtTitle"
local close_btn_path = "Panel"
local return_btn_path = "Root/Content/btnClose"
local scroll_view_path = "Root/Content/ImgBg/ScrollView"
local conform_btn_path = "Root/Content/ConfirmButton"
local conform_name_path = "Root/Content/ConfirmButton/ConfirmTitleTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:SetAllCellsDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.conform_btn = self:AddComponent(UIButton, conform_btn_path)
  self.conform_name = self:AddComponent(UIText, conform_name_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.conform_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnConfirmBtnClick()
  end)
  self.toggle = self:AddComponent(UIToggle, "Root/ToggleText/GMToggle")
  self.toggle:SetIsOn(Localization.ShowKey)
  self.toggle:SetOnValueChanged(function(tf)
    self:ToggleControlBorS(tf)
  end)
  self.toggleText = self:AddComponent(UIText, "Root/ToggleText")
  self.toggleText:SetActive(LuaEntry.Player:GetGMFlag() > 0)
end

local function ComponentDestroy(self)
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.scroll_view = nil
  self.conform_btn = nil
  self.conform_name = nil
  self.toggle = nil
  self.toggleText = nil
end

local function DataDefine(self)
  self.list = {}
  self.cells = {}
  self.selectIndex = nil
  self.initLanguage = nil
  self.settingType = self:GetUserData() or SettingType.Language
end

local function DataDestroy(self)
  self.list = nil
  self.cells = nil
  self.selectIndex = nil
  self.initLanguage = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.conform_name:SetLocalText(GameDialogDefine.CONFIRM)
  if self.settingType == SettingType.Voice then
    self.initLanguage = DataCenter.LWSoundManager:GetVoiceLang()
    self.txt_title:SetLocalText("voice_selection_title")
  elseif self.settingType == SettingType.ChatTranslateLanguage then
    self.txt_title:SetLocalText("im_set_translate")
    self.initLanguage = ChatInterface.GetChatTranslateLanguage()
  else
    self.initLanguage = Localization:GetLanguage()
    self.txt_title:SetLocalText(100101)
  end
  self:ShowCells()
end

local function SetAllCellsDestroy(self)
  self:ClearScroll()
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ShowCells(self)
  self:ClearScroll()
  self.list = self:GetShowList()
  local tempCount = table.count(self.list)
  if 0 < tempCount then
    self.scroll_view:SetTotalCount(tempCount)
    self.scroll_view:RefillCells()
  end
end

local function OnCellMoveIn(self, itemObj, index)
  local tempType = self.list[index]
  itemObj.name = tempType
  local cellItem = self.scroll_view:AddComponent(UISettingLanguageCell, itemObj)
  local param = UISettingLanguageCell.Param.New()
  param.index = index
  if tempType == Language.Arabic then
    param.name = string.format("<b>%s</b>", SuportedLanguagesName[tempType])
  else
    param.name = SuportedLanguagesName[tempType]
  end
  param.isSelect = self.selectIndex == index
  
  function param.callBack(tempIndex)
    self:CellCallBack(tempIndex)
  end
  
  param.languageIndex = tempType
  param.settingType = self.settingType
  cellItem:ReInit(param)
  self.cells[index] = cellItem
end

local function OnCellMoveOut(self, itemObj, index)
  self.cells[index] = nil
  self.scroll_view:RemoveComponent(itemObj.name, UISettingLanguageCell)
end

local function ClearScroll(self)
  self.cells = {}
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UISettingLanguageCell)
end

local function GetShowList(self)
  local list = {}
  local supportedLanguages = SuportedLanguages
  if self.settingType == SettingType.Voice then
    supportedLanguages = DataCenter.LWSoundManager:GetSupportedVoiceLangs()
  end
  if self.settingType == SettingType.ChatTranslateLanguage then
    supportedLanguages = ChatTranslateLanguage
  end
  for _, v in ipairs(supportedLanguages) do
    if not (v == Language.ChineseSimplified and LuaEntry.Player:GetGMFlag() <= 0) or not CS.NetworkURLConfig.IsOnline then
      if v == self.initLanguage then
        table.insert(list, 1, v)
      else
        table.insert(list, v)
      end
    end
  end
  self.selectIndex = 1
  return list
end

local function OnConfirmBtnClick(self)
  local temp = self.list[self.selectIndex]
  if temp == self.initLanguage then
    self.ctrl:CloseSelf()
  elseif self.settingType == SettingType.Voice then
    UIUtil.ShowMessage(Localization:GetString("voice_selection", Localization:GetString(SuportedLanguagesLocalName[temp])), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      DataCenter.LWSoundManager:SetVoiceLang(temp)
      self.ctrl:CloseSelf()
    end)
  elseif self.settingType == SettingType.ChatTranslateLanguage then
    UIUtil.ShowMessage(Localization:GetString("im_set_translate_des", Localization:GetString(SuportedLanguagesLocalName[temp])), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      ChatInterface.getTranslateMgr():SetChatTranslateLanguage(temp)
      self.ctrl:CloseSelf()
    end)
  else
    UIUtil.ShowMessage(Localization:GetString("280075", Localization:GetString(SuportedLanguagesLocalName[temp])), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      ChatInterface.getTranslateMgr():SetChatTranslateLanguage(temp)
      Localization:SetLanguage(temp)
      CS.ApplicationLaunch.Instance:ReloadGame()
    end)
  end
end

local function CellCallBack(self, index)
  if self.selectIndex ~= index then
    self:SetCellsSelect(self.selectIndex, false)
    self:SetCellsSelect(index, true)
    self.selectIndex = index
  end
end

local function SetCellsSelect(self, index, value)
  local temp = self.cells[index]
  if temp ~= nil then
    temp:SetSelect(value)
  end
end

function UISettingLanguageView:ToggleControlBorS(isShowKey)
  Localization.ShowKey = isShowKey
  Setting:SetBool(SettingKeys.GM_ONLY_SHOW_KEY_FLAG .. LuaEntry.Player.uid, isShowKey)
end

UISettingLanguageView.OnCreate = OnCreate
UISettingLanguageView.OnDestroy = OnDestroy
UISettingLanguageView.OnEnable = OnEnable
UISettingLanguageView.OnDisable = OnDisable
UISettingLanguageView.OnAddListener = OnAddListener
UISettingLanguageView.OnRemoveListener = OnRemoveListener
UISettingLanguageView.ComponentDefine = ComponentDefine
UISettingLanguageView.ComponentDestroy = ComponentDestroy
UISettingLanguageView.DataDefine = DataDefine
UISettingLanguageView.DataDestroy = DataDestroy
UISettingLanguageView.ReInit = ReInit
UISettingLanguageView.SetAllCellsDestroy = SetAllCellsDestroy
UISettingLanguageView.ShowCells = ShowCells
UISettingLanguageView.OnCellMoveIn = OnCellMoveIn
UISettingLanguageView.OnCellMoveOut = OnCellMoveOut
UISettingLanguageView.ClearScroll = ClearScroll
UISettingLanguageView.GetShowList = GetShowList
UISettingLanguageView.OnConfirmBtnClick = OnConfirmBtnClick
UISettingLanguageView.CellCallBack = CellCallBack
UISettingLanguageView.SetCellsSelect = SetCellsSelect
return UISettingLanguageView
