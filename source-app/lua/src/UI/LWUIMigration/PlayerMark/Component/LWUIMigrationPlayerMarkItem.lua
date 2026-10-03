local base = UIBaseContainer
local LWUIMigrationPlayerMarkItem = BaseClass("LWUIMigrationPlayerMarkItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUIMigrationPlayerMarkItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIMigrationPlayerMarkItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIMigrationPlayerMarkItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compHead = self.viewSkin:AddComponent(self, UICommonHead, 1)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textServer = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textPower = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnDel = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnDel:SetOnClick(function()
    self:OnBtnDelClick()
  end)
  self.btnChat = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnChat:SetOnClick(function()
    self:OnBtnChatClick()
  end)
end

function LWUIMigrationPlayerMarkItem:ComponentDestroy()
  self.viewSkin = nil
  self.compHead = nil
  self.textName = nil
  self.textServer = nil
  self.textPower = nil
  self.btnDel = nil
  self.btnChat = nil
end

function LWUIMigrationPlayerMarkItem:DataDefine()
  self.compHead:SetEnableClickShowInfo(true, true)
  self.btnDel:SetSafeClickMode(true)
  self.btnChat:SetSafeClickMode(true)
end

function LWUIMigrationPlayerMarkItem:DataDestroy()
  self.uid = nil
end

function LWUIMigrationPlayerMarkItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.OnGetNewUserInfoSucc)
end

function LWUIMigrationPlayerMarkItem:OnRemoveListener()
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.OnGetNewUserInfoSucc)
  base.OnRemoveListener(self)
end

function LWUIMigrationPlayerMarkItem:OnBtnDelClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.uid == nil then
    return
  end
  if not DataCenter.ActMigrationManager:CheckCanSetting(true) then
    return
  end
  DataCenter.ActMigrationManager:ReqPlayerMark(self.uid, false)
end

function LWUIMigrationPlayerMarkItem:OnBtnChatClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.uid == nil then
    return
  end
  local data = {
    privateUserInfo = {
      uid = self.uid,
      userName = self.name
    }
  }
  GoToUtil.OpenChatView(true, {anim = false, immediately = true}, data)
end

function LWUIMigrationPlayerMarkItem:SetPlayer(uid)
  self.uid = uid
  self:OnGetNewUserInfoSucc(uid)
end

function LWUIMigrationPlayerMarkItem:OnGetNewUserInfoSucc(uid)
  if self.uid ~= uid then
    return
  end
  local info = UIUtil.GetPlayerInfoShowByUid(uid)
  if info then
    self.name = info.name
    self.compHead:ParseHeadInfo(info)
    self.textName:SetText(UIUtil.FormatAllianceAndName(info.alAbbr, info.name, info.uid))
    self.textServer:SetLocalText(208236, info.serverId)
    self.textPower:SetText(string.GetFormattedStr(info.power))
  end
end

return LWUIMigrationPlayerMarkItem
