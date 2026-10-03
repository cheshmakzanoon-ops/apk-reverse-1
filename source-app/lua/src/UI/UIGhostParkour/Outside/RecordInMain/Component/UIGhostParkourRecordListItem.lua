local base = UIBaseContainer
local UIGhostParkourRecordListItem = BaseClass("UIGhostParkourRecordListItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonHead = require("Framework.UI.Component.UICommonHead")

function UIGhostParkourRecordListItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIGhostParkourRecordListItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGhostParkourRecordListItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 1)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.imgEmoji = self.viewSkin:AddComponent(self, UIImage, 5)
end

function UIGhostParkourRecordListItem:ComponentDestroy()
  self.viewSkin = nil
  self.compUIPlayerHead = nil
  self.textName = nil
  self.textDesc = nil
  self.textTime = nil
  self.imgEmoji = nil
end

function UIGhostParkourRecordListItem:DataDefine()
end

function UIGhostParkourRecordListItem:DataDestroy()
end

function UIGhostParkourRecordListItem:OnAddListener()
  base.OnAddListener(self)
end

function UIGhostParkourRecordListItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIGhostParkourRecordListItem:SetItem(data)
  local time = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(data.time)
  self.textTime:SetText(time)
  local playerInfo = data.attackInfo
  self.compUIPlayerHead:SetHeadAndFrame(playerInfo.uid, playerInfo.pic, playerInfo.picver, nil, playerInfo.headSkinId, playerInfo.headSkinET)
  local name = playerInfo.name
  if not string.IsNullOrEmpty(playerInfo.abbr) then
    name = UIUtil.FormatAllianceAndName(playerInfo.abbr, name)
  end
  self.textName:SetText(name)
  local line = LocalController:instance():getLine(TableName.LW_EMOJI, playerInfo.emojiId)
  if line and line.path then
    self.imgEmoji.gameObject:SetActive(true)
    self.imgEmoji:LoadSpriteAsync("Assets/Main/Sprites/UI/LWChatEmoji/Default/" .. line.path .. ".png")
  else
    self.imgEmoji.gameObject:SetActive(false)
  end
  self.textDesc:SetLocalText("ghost_parkour_record_message_desc")
end

return UIGhostParkourRecordListItem
