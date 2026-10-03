local UILWPlayerThumbsUpHistoryItem = BaseClass("UILWPlayerThumbsUpHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ui_player_head_path = "UIPlayerHead"
local txt_des_path = "Txt_Des"
local txt_time_path = "Txt_Time"
local txt_title_path = "Txt_Title"
local icon_path = "Bg/Icon"
local DEFAULT_ICON_PATH = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_gerenxinxi_dianzan.png"
local ICON_PATH = {
  [InteractiveUtil.ThumbsUpType.HighFive] = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/mjc_lianmeng_jizhang_liaotian_bg03.png",
  [InteractiveUtil.ThumbsUpType.BirthdayInformation] = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/zyf_shengrixitong_jitu_dangao_icon.png",
  [InteractiveUtil.ThumbsUpType.BirthdayRedPacket] = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/zyf_shengrixitong_jitu_dangao_icon.png"
}

function UILWPlayerThumbsUpHistoryItem:OnCreate()
  base.OnCreate(self)
  self.player_head = self:AddComponent(UICommonHead, ui_player_head_path)
  self.txt_des = self:AddComponent(UITextMeshProUGUIEx, txt_des_path)
  self.txt_time = self:AddComponent(UITextMeshProUGUIEx, txt_time_path)
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.player_head:SetEnableClickShowInfo(true, true)
end

function UILWPlayerThumbsUpHistoryItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerMessageInfo, self.RefreshUserInfo)
end

function UILWPlayerThumbsUpHistoryItem:OnRemoveListener()
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.RefreshUserInfo)
  base.OnRemoveListener(self)
end

function UILWPlayerThumbsUpHistoryItem:OnDestroy()
  base.OnDestroy(self)
  self.player_head = nil
  self.txt_des = nil
  self.txt_time = nil
  self.txt_title = nil
  self.icon = nil
  self.data = nil
end

function UILWPlayerThumbsUpHistoryItem:RefreshUserInfo(uid)
  if self.view.type == "friendCircle" and self.data and uid == self.data.uid then
    self:RefreshItem()
  end
end

function UILWPlayerThumbsUpHistoryItem:RefreshItem()
  if self.view.type == "friendCircle" and self.data then
    local _userinfo = ChatInterface.getUserData(self.data.uid)
    self.player_head:SetData(_userinfo.uid, _userinfo.headPic, _userinfo.headPicVer)
    local serverId = _userinfo.getServerId and _userinfo:getServerId() or _userinfo.serverId
    self.txt_title:SetText(UIUtil.FormatServerAllianceName(serverId, _userinfo.allianceSimpleName, _userinfo.userName))
    self.icon:LoadSprite(DEFAULT_ICON_PATH)
    self.icon:SetNativeSize()
  end
end

function UILWPlayerThumbsUpHistoryItem:ReInit(index, data)
  if self.view.type == "friendCircle" then
    self.data = data
    self:RefreshItem()
    self.txt_time:SetText(UITimeManager:GetInstance():ConvertServerTimeToLocalTime(self.data.createTime, false))
    self.txt_des:SetLocalText("like_reason_moment")
    return
  end
  if data.bigType == 1 then
    local langKey = InteractiveUtil.GetLangKeyByThumbType(data.smallType)
    self.txt_des:SetLocalText(langKey, data.name)
  else
    self.txt_des:SetText("")
  end
  local iconPath = DEFAULT_ICON_PATH
  if ICON_PATH[data.smallType] then
    iconPath = ICON_PATH[data.smallType]
  end
  self.icon:LoadSprite(iconPath)
  self.icon:SetNativeSize()
  self.player_head:ParseHeadInfo(data)
  local name = UIUtil.FormatServerAllianceName(data.serverId, data.abbr, data.name)
  self.txt_title:SetText(string.gsub(name, " ", "<space=10>"))
  self.txt_time:SetText(UITimeManager:GetInstance():ConvertServerTimeToLocalTime(data.time, false))
end

return UILWPlayerThumbsUpHistoryItem
