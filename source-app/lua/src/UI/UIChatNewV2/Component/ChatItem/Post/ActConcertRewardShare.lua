local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_ActConcertRewardShare = BaseClass("ChatItemPost_ActConcertRewardShare", IChatItemPost)
local base = IChatItemPost
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local rich_text_path = "Assistant/RichTextRoot/RichText"
local button_path = "Button"

function ChatItemPost_ActConcertRewardShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_ActConcertRewardShare:OnDestroy()
  base.OnDestroy(self)
end

function ChatItemPost_ActConcertRewardShare:ComponentDefine()
  self.rich_text = self:AddComponent(UITextMeshProUGUIEx, rich_text_path)
  self.clickBtn = self:AddComponent(UIButton, button_path)
  self.clickBtn:SetOnClick(function()
    self:JumpToTargetPos()
  end)
end

function ChatItemPost_ActConcertRewardShare:ComponentDestroy()
  self.playerNameText = nil
  self.playerHead = nil
  self.rankText = nil
  self.rankIcon = nil
  self.starItem = nil
end

function ChatItemPost_ActConcertRewardShare:UpdateItem(chatData)
  if not chatData then
    return
  end
  if not chatData.attachmentId then
    return
  end
  local attachJson = rapidjson.decode(chatData.attachmentId)
  if not attachJson or table.count(attachJson) <= 0 then
    return
  end
  if not attachJson.pointId then
    return
  end
  self.pointId = attachJson.pointId
  local playerName = attachJson.playerName or ""
  local pos = SceneUtils.IndexToTilePos(self.pointId)
  local posStr = string.format("(%d,%d)", pos.x, pos.y)
  self.rich_text:SetText(CS.GameEntry.Localization:GetString("activity_concert_6", playerName, posStr))
end

function ChatItemPost_ActConcertRewardShare:OnRecycle()
  self.data = nil
end

function ChatItemPost_ActConcertRewardShare:JumpToTargetPos()
  EventManager:GetInstance():Broadcast(ChatEventEnum.LF_CloseChatView, true)
  GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(self.pointId, ForceChangeScene.World))
end

return ChatItemPost_ActConcertRewardShare
