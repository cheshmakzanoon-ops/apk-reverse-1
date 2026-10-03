local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_PostGhostParkourRecordShare = BaseClass("PostGhostParkourRecordShare", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local PlayItem = require("UI.UIGhostParkour.Outside.RecordPop.Component.PlayerItemComponent")
local lights = {
  "Assets/Main/Sprites/UI/UIGhostParkour/UIGhostParkourBanner/mjc_paoku_fenxiang_liaotian_1.png",
  "Assets/Main/Sprites/UI/UIGhostParkour/UIGhostParkourBanner/mjc_paoku_fenxiang_liaotian_2.png"
}
local darks = {
  "Assets/Main/Sprites/UI/UIGhostParkour/UIGhostParkourBanner/mjc_paoku_fenxiang_liaotian_an_1.png",
  "Assets/Main/Sprites/UI/UIGhostParkour/UIGhostParkourBanner/mjc_paoku_fenxiang_liaotian_an_2.png"
}

function ChatItemPost_PostGhostParkourRecordShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ChatItemPost_PostGhostParkourRecordShare:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChatItemPost_PostGhostParkourRecordShare:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compLeftPlayer = self.viewSkin:AddComponent(self, PlayItem, 2)
  self.compRightPlayer = self.viewSkin:AddComponent(self, PlayItem, 3)
  self.textTipsLight = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.rawImgBg = self:AddComponent(UIImage, "ChatShareNode")
end

function ChatItemPost_PostGhostParkourRecordShare:ComponentDestroy()
  self.viewSkin = nil
  self.rawImgBg = nil
  self.compLeftPlayer = nil
  self.compRightPlayer = nil
  self.textTipsLight = nil
end

function ChatItemPost_PostGhostParkourRecordShare:DataDefine()
end

function ChatItemPost_PostGhostParkourRecordShare:DataDestroy()
  self.stageId = nil
  self.data = nil
  self.isWinner = nil
end

function ChatItemPost_PostGhostParkourRecordShare:OnAddListener()
  base.OnAddListener(self)
end

function ChatItemPost_PostGhostParkourRecordShare:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ChatItemPost_PostGhostParkourRecordShare:OnLoaded()
  local chatData = self:ChatData()
  if chatData == nil then
    return
  end
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self._userInfo = ChatManager2:GetInstance().User:getChatUserInfo(self._chatData.senderUid, true)
  self:RefreshView(chatData)
end

function ChatItemPost_PostGhostParkourRecordShare:RefreshView(chatData)
  self.stageId = nil
  self.data = nil
  self.isWinner = nil
  if self._chatData.attachmentId then
    local attachJson = rapidjson.decode(self._chatData.attachmentId)
    if attachJson then
      self.stageId = attachJson.stageId
      self.data = attachJson.data
      self.isWinner = attachJson.isWinner
      if attachJson.name and attachJson.score then
        local scoreTime = UITimeManager:GetInstance():GetCompetitionTimeFormat(attachJson.score)
        if self.isWinner then
          self.textTipsLight:SetLocalText("ghost_parkour_share_win", attachJson.name, scoreTime)
        else
          self.textTipsLight:SetLocalText("ghost_parkour_share_lose", attachJson.name, scoreTime)
        end
      end
      local defense = false
      if self.data.defendInfo.uid == LuaEntry.Player.uid then
        defense = true
      end
      local sprites = lights
      if ChatInterface.GetChatTheme() == ChatUIThemeConfig.ChatMode.Night then
        sprites = darks
      end
      if defense then
        self.rawImgBg:LoadSpriteAsync(sprites[2])
        self.compLeftPlayer:SetData(self.data.defendInfo, false, self.stageId, self.data.attackInfo, attachJson.round)
        self.compRightPlayer:SetData(self.data.attackInfo, true, self.stageId, self.data.defendInfo, attachJson.round)
      else
        self.rawImgBg:LoadSpriteAsync(sprites[1])
        self.compLeftPlayer:SetData(self.data.attackInfo, true, self.stageId, self.data.defendInfo, attachJson.round)
        self.compRightPlayer:SetData(self.data.defendInfo, false, self.stageId, self.data.attackInfo, attachJson.round)
      end
    end
  end
end

return ChatItemPost_PostGhostParkourRecordShare
