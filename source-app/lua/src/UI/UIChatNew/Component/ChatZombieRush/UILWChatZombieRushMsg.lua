local base = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local UILWChatZombieRushMsg = BaseClass("UILWChatZombieRushMsg", base)
local rapidjson = require("rapidjson")
local rich_text_path = "Assistant/RichTextRoot/RichText"

function UILWChatZombieRushMsg:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWChatZombieRushMsg:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWChatZombieRushMsg:ComponentDefine()
  self.rich_text = self:AddComponent(UITextMeshProUGUIEx, rich_text_path)
  self.rich_text:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
end

function UILWChatZombieRushMsg:ComponentDestroy()
  self.rich_text = nil
end

function UILWChatZombieRushMsg:UpdateItem(_chat_data, _index)
  self._chatData = _chat_data
  local message = self._chatData:getSuperParsedResult()
  if message == nil then
    message = self._chatData:getMessageWithExtra(false)
    self._chatData:setSuperParsedResult(message)
  end
  self.rich_text:SetText(message)
end

function UILWChatZombieRushMsg:OnPointerClick(clickPos)
  if not LuaEntry.Player:IsInSelfServer() then
    UIUtil.ShowTipsId("server_tips_002")
    return
  end
  if self._chatData ~= nil then
    local pointId = -1
    if self._chatData and self._chatData.extra and self._chatData.extra.customJsonParam then
      local jsonObj = rapidjson.decode(self._chatData.extra.customJsonParam)
      if jsonObj and jsonObj.pointId then
        pointId = jsonObj.pointId
      end
    end
    if 0 <= pointId then
      EventManager:GetInstance():Broadcast(ChatEventEnum.LF_CloseChatView, true)
      GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), nil, nil)
    end
  end
end

return UILWChatZombieRushMsg
