local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_Train = BaseClass("ChatItemPost_Train", IChatItemPost)
local base = IChatItemPost
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")

function ChatItemPost_Train:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_Train:ComponentDefine()
  self._shareNode = self:AddComponent(UIButton, "")
  self._shareNode:SetOnClick(BindCallback(self, self.OnClickBg))
  self.bg = self:AddComponent(UIImage, "bg")
  self.title = self:AddComponent(UIText, "title")
  self.hp = self:AddComponent(UIText, "hp")
  self.name = self:AddComponent(UIText, "name")
  self.level = self:AddComponent(UIText, "level")
  self.power = self:AddComponent(UIText, "power")
  self.head = self:AddComponent(UICommonHead, "DriverHead")
  self.icon = self:AddComponent(UIImage, "icon")
end

function ChatItemPost_Train:OnClickBg()
  if self.data == nil then
    return
  end
  RailwayUtil.JumpToTrainByMarchUuid(self.data.marchUuid, self.data.serverId, self.data.worldId)
end

function ChatItemPost_Train:OnLoaded()
  local chatdata = self:ChatData()
  if chatdata == nil then
    return
  end
  local senderUid = chatdata.senderUid
  local _userInfo = ChatManager2:GetInstance().User:getChatUserInfo(senderUid, true)
  if self._chatNameLayout then
    self._chatNameLayout:UpdateName(_userInfo, chatdata)
  end
  local data = rapidjson.decode(chatdata.attachmentId)
  self.title:SetLocalText("alliance_train_050")
  self.hp:SetLocalText("457581", math.floor(data.completeness * 100))
  self.head:SetHeadAndFrame(data.uid, data.headPic, data.headPicVer, false, data.headSkinId, data.headSkinET)
  self.name:SetText(UIUtil.FormatAllianceAndName(data.abbr, data.name))
  self.level:SetText("Lv." .. data.level)
  self.power:SetText(string.GetFormattedSeparatorNum(data.ownerPower))
  local iconPath
  if data.isUR then
    iconPath = "Assets/Main/Sprites/UI/UILWRailwayTrain/zxl_huoche_fenxiang_jin.png"
  else
    iconPath = "Assets/Main/Sprites/UI/UILWRailwayTrain/zxl_huoche_fenxiang_putong.png"
  end
  self.icon:LoadSprite(iconPath)
  if chatdata:isMyChat() then
    self.bg:LoadSprite(ChatInterface.GetChatUIPath(UIAssets.ChatItemBg_right))
  else
    self.bg:LoadSprite(ChatInterface.GetChatUIPath(UIAssets.ChatItemBg_left))
  end
  self.data = data
end

function ChatItemPost_Train:OnRecycle()
  self.data = nil
end

return ChatItemPost_Train
