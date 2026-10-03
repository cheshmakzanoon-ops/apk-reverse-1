local base = UIBaseContainer
local UIAccountIdBindPersonalInfoComponent = BaseClass("UIAccountIdBindPersonalInfoComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonHead = require("Framework.UI.Component.UICommonHead")

function UIAccountIdBindPersonalInfoComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAccountIdBindPersonalInfoComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAccountIdBindPersonalInfoComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textContent = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textID = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textIDValue = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textBindGame = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 6)
  self.textPlayerName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textZone = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textLevel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.btnCancel = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnCancel:SetOnClick(function()
    self:OnBtnCancelClick()
  end)
  self.textCancelBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.btnConfirm = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.textConfirmBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
end

function UIAccountIdBindPersonalInfoComponent:ComponentDestroy()
  self.textTitle = nil
  self.textContent = nil
  self.textID = nil
  self.textIDValue = nil
  self.textBindGame = nil
  self.compUIPlayerHead = nil
  self.textPlayerName = nil
  self.textZone = nil
  self.textLevel = nil
  self.btnCancel = nil
  self.textCancelBtn = nil
  self.btnConfirm = nil
  self.textConfirmBtn = nil
end

function UIAccountIdBindPersonalInfoComponent:DataDefine()
  self.curState = nil
end

function UIAccountIdBindPersonalInfoComponent:DataDestroy()
  self.curState = nil
end

function UIAccountIdBindPersonalInfoComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIAccountIdBindPersonalInfoComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAccountIdBindPersonalInfoComponent:OnBtnCancelClick()
end

function UIAccountIdBindPersonalInfoComponent:OnBtnConfirmClick()
  if self.curState then
    self.curState:OnClickRight()
  end
end

function UIAccountIdBindPersonalInfoComponent:Init(state)
  self.curState = state
  self.btnCancel:SetActive(false)
  self:InitCurRoleInfo()
  self:SetLocalizeText()
end

function UIAccountIdBindPersonalInfoComponent:InitCurRoleInfo()
  local accountBindMail = DataCenter.AccountManager.MailAccount.gameAccount
  self.textIDValue:SetText(accountBindMail)
  local uid = LuaEntry.Player:GetUid()
  local pic = LuaEntry.Player:GetPic()
  local picVer = LuaEntry.Player.picVer
  local headSkinPath = LuaEntry.Player:GetHeadBgImg()
  self.compUIPlayerHead:SetData(uid, pic, picVer, nil, headSkinPath)
  self.textPlayerName:SetText(LuaEntry.Player:GetName())
  self.textZone:SetText("#" .. LuaEntry.Player:GetSourceServerId())
  self.textLevel:SetText(Localization:GetString("151116") .. tostring(DataCenter.BuildManager.MainLv))
end

function UIAccountIdBindPersonalInfoComponent:SetLocalizeText()
  if self.curState then
    local stateLocalization = self.curState.GetStateLocalization and self.curState:GetStateLocalization() or {}
    self.textTitle:SetLocalText(stateLocalization.titleStr)
    self.textContent:SetActive(not string.IsNullOrEmpty(stateLocalization.contentStr))
    self.textContent:SetLocalText(stateLocalization.contentStr)
    self.textConfirmBtn:SetLocalText(stateLocalization.confirmBtnStr)
    self.textID:SetText("LastWar ID")
    self.textBindGame:SetLocalText(stateLocalization.noteStr)
  end
end

return UIAccountIdBindPersonalInfoComponent
