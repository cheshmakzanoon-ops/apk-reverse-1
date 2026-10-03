local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_ActMigrationShare = BaseClass("ActMigrationShare", IChatItemPost)
local base = IChatItemPost
local UIServerBattleZoneInfo = require("UI.UIGovernment.ServerBattleMain.Component.UIServerBattleZoneInfo")
local rapidjson = require("rapidjson")
local _cp_ShareTitle = "ShareTitle"
local _cp_shareMsg = "ShareIconNode/ShareMsg/Msg"
local _cp_shareNode = ""
local tips_text_path = "ShareIconNode/ShareMsg/Tips"
local home_icon_path = "ShareIconNode/House/homeIcon"
local server_bg_path = "ShareIconNode/House/ServerBg"
local server_txt_path = "ShareIconNode/House/ServerBg/ServerTxt"

function ChatItemPost_ActMigrationShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_ActMigrationShare:ComponentDefine()
  self._shareTitle = self:AddComponent(UIText, _cp_ShareTitle)
  self._shareMsg = self:AddComponent(UIText, _cp_shareMsg)
  self._shareNode = self:AddComponent(UIButton, _cp_shareNode)
  self._shareNode:SetOnClick(BindCallback(self, self.OnClickBg))
  self.tipsText = self:AddComponent(UIText, tips_text_path)
  self.serverText = self:AddComponent(UIText, server_txt_path)
end

function ChatItemPost_ActMigrationShare:OnClickBg()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.serverId == nil or self.serverId <= 0 then
    return
  end
  DataCenter.ActMigrationManager:JumpFromShare(self.serverId)
end

function ChatItemPost_ActMigrationShare:OnLoaded()
  local chatData = self:ChatData()
  if not chatData then
    return
  end
  local attachInfo = chatData:getMessageParam(false)
  if not attachInfo or not attachInfo.config_id then
    return
  end
  self.attachInfo = attachInfo
  self._shareTitle:SetLocalText("migration_activity_interface_10068")
  self.tipsText:SetLocalText("migration_activity_interface_10070")
  self._shareMsg:SetText(CS.GameEntry.Localization:GetString("migration_activity_interface_10069", attachInfo.serverId))
  self:ShowServerInfo(attachInfo.serverId, attachInfo.config_id)
  local senderUid = chatData.senderUid
  local _userInfo = ChatManager2:GetInstance().User:getChatUserInfo(senderUid, true)
  if self._chatNameLayout then
    self._chatNameLayout:UpdateName(_userInfo, chatData)
  end
end

function ChatItemPost_ActMigrationShare:OnRecycle()
end

function ChatItemPost_ActMigrationShare:ShowServerInfo(serverId, serverCfgId)
  self.cfgId = serverCfgId or 511001
  self.serverId = toInt(serverId)
  if self.cfgId and self.home_icon then
    local itemCfg = DataCenter.ItemTemplateManager:GetItemTemplate(self.cfgId)
    if itemCfg ~= nil then
      self.home_icon:LoadSprite(string.format(LoadPath.ItemPath, itemCfg.icon))
    end
  end
  self.serverText:SetText(string.format("#%s", serverId))
end

return ChatItemPost_ActMigrationShare
