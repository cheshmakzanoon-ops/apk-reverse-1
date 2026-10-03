local UILWVisibilitySettingsView = BaseClass("UILWVisibilitySettingsView", UIBaseView)
local UIVisibilityCell = require("UI.LWPlayerInfo.UILWVisibilitySettings.Component.UIVisibilityCell")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_text_path = "Content/UICommonPopUpTop/TitleText"
local button_text_path = "Content/BottomGroup/ButtonScaleNode/CommonButton/Content/ButtonText"
local DarkConfig = {
  {settingTextColor = "#000000", titleTextColor = "#FFFFFF"},
  {settingTextColor = "#828282", titleTextColor = "#E6E6E6"}
}

function UILWVisibilitySettingsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UILWVisibilitySettingsView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWVisibilitySettingsView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compVisibilityCall = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.compLayout = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.textSetting = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnCommon = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnCommon:SetOnClick(function()
    self:OnBtnCommonClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnMask = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnMask:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.titleText = self:AddComponent(UIText, title_text_path)
  self.buttonText = self:AddComponent(UIText, button_text_path)
  self.itemObj = self.compVisibilityCall.gameObject
  self.itemObj:GameObjectCreatePool()
  self.itemObj:SetActive(false)
end

function UILWVisibilitySettingsView:ComponentDestroy()
  self.itemObj:GameObjectRecycleAll()
  self.viewSkin = nil
  self.compVisibilityCall = nil
  self.compLayout = nil
  self.textSetting = nil
  self.btnCommon = nil
  self.btnClose = nil
  self.btnMask = nil
end

function UILWVisibilitySettingsView:DataDefine()
  self.data = self:GetUserData()
  self.selectType = self.data:GetVisibility()
  self.visibilityConfig = ChatInterface.getMoment():GetVisibilityConfig()
  self.visibilityItemDict = {}
end

function UILWVisibilitySettingsView:DataDestroy()
end

function UILWVisibilitySettingsView:OnAddListener()
  base.OnAddListener(self)
end

function UILWVisibilitySettingsView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWVisibilitySettingsView:ReInit()
  local goItem, theItem
  for i = 1, #self.visibilityConfig do
    goItem = self.itemObj:GameObjectSpawn(self.compLayout.transform)
    goItem.name = string.format("Visibility_%d", i)
    theItem = self.compLayout:AddComponent(UIVisibilityCell, goItem.name)
    theItem:ReInit(self.visibilityConfig[i], i, function(index)
      self:OnVisibilityItemClick(index)
    end)
    goItem:SetActive(true)
    self.visibilityItemDict[i] = theItem
    if self.selectType == self.visibilityConfig[i].visibilityRange then
      self.selectIndex = i
    end
  end
  if not self.selectIndex then
    self.selectIndex = 1
  end
  self:OnVisibilityItemClick(self.selectIndex)
  self.textSetting:SetLocalText("moment_range_set")
  self.buttonText:SetLocalText(GameDialogDefine.CONFIRM)
  self.titleText:SetLocalText(280012)
  self:DarkMode()
end

function UILWVisibilitySettingsView:DarkMode()
  local config = DarkConfig[ChatInterface.GetChatTheme()]
  self.titleText:SetColorHex(config.titleTextColor)
  self.textSetting:SetColorHex(config.settingTextColor)
end

function UILWVisibilitySettingsView:OnVisibilityItemClick(index)
  if not index then
    return
  end
  if self.selectIndex then
    self.visibilityItemDict[self.selectIndex]:SelectItem(false)
  end
  self.visibilityItemDict[index]:SelectItem(true)
  self.selectIndex = index
end

function UILWVisibilitySettingsView:OnBtnCommonClick()
  local rangeType = self.visibilityConfig[self.selectIndex].visibilityRange
  local authTable = ChatInterface.getMoment():GetAuth()
  authTable[rangeType] = 1
  self.data.auth = authTable
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.MomentTimeLineUpdateAuth, self.data.seqId, self.data.auth)
  self.ctrl:CloseSelf()
end

function UILWVisibilitySettingsView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return UILWVisibilitySettingsView
