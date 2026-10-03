local AllianceLanguageItem = require("UI.UIAlliance.UIAllianceChangeLanguage.Component.AllianceLanguageItem")
local UIAllianceChangeLanguageView = BaseClass("UIAllianceChangeLanguageView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "UICommonMiniPopUpTitle/titleText"
local close_btn_path = "UICommonMiniPopUpTitle/CloseBtn"
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local content_path = "ImgBg/ScrollView/Viewport/Content"
local set_btn_path = "ImgBg/Button"
local set_txt_path = "ImgBg/Button/useText"

local function OnCreate(self)
  base.OnCreate(self)
  local param = self:GetUserData()
  self.curLanguage = param.curLanguage
  self.confirmCallBack = param.callback
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText(100101)
  self.set_txt = self:AddComponent(UIText, set_txt_path)
  self.set_txt:SetLocalText(GameDialogDefine.CONFIRM)
  self.set_btn = self:AddComponent(UIButton, set_btn_path)
  self.set_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnSetBtnClick()
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.languageList = {}
end

local function OnDestroy(self)
  self.curLanguage = nil
  self.txt_title = nil
  self.set_txt = nil
  self.set_btn = nil
  self.close_btn = nil
  self.return_btn = nil
  self.content = nil
  self.languageList = nil
  base.OnDestroy(self)
end

local function RefreshList(self)
  self:SetAllCellDestroy()
  local list = self.ctrl:GetLanguageList()
  if list ~= nil then
    self.modelCount = 0
    for i = 1, table.length(list) do
      self.modelCount = self.modelCount + 1
      self.model[self.modelCount] = self:GameObjectInstantiateAsync(UIAssets.AllianceLanguageItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.content:AddComponent(AllianceLanguageItem, nameStr)
        self.languageList[list[i]] = cell
        self.languageList[list[i]]:RefreshData(list[i], self.curLanguage)
      end)
    end
  end
end

local function SetCurLanguage(self, newLanguage)
  if self.languageList[newLanguage] ~= nil then
    if newLanguage == self.curLanguage then
      self.languageList[newLanguage]:SetSelect(true)
    else
      if self.languageList[self.curLanguage] ~= nil then
        self.languageList[self.curLanguage]:SetSelect(false)
      end
      self.languageList[newLanguage]:SetSelect(true)
      self.curLanguage = newLanguage
    end
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshList()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnSetBtnClick(self)
  if self.confirmCallBack then
    self.confirmCallBack(self.curLanguage)
  end
  self.ctrl:CloseSelf()
end

local function SetAllCellDestroy(self)
  self.content:RemoveComponents(AllianceLanguageItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
  self.languageList = {}
end

UIAllianceChangeLanguageView.OnCreate = OnCreate
UIAllianceChangeLanguageView.OnDestroy = OnDestroy
UIAllianceChangeLanguageView.RefreshList = RefreshList
UIAllianceChangeLanguageView.OnEnable = OnEnable
UIAllianceChangeLanguageView.OnDisable = OnDisable
UIAllianceChangeLanguageView.SetCurLanguage = SetCurLanguage
UIAllianceChangeLanguageView.OnSetBtnClick = OnSetBtnClick
UIAllianceChangeLanguageView.SetAllCellDestroy = SetAllCellDestroy
return UIAllianceChangeLanguageView
