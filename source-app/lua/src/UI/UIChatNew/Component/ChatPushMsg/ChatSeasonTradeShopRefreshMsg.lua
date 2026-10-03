local base = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatSeasonTradeShopRefreshMsg = BaseClass("ChatSeasonTradeShopRefreshMsg", base)
local rapidjson = require("rapidjson")
local u_i_player_head_path = "Content/UIPlayerHead"
local lord_title_path = "Content/lordTitle"
local player_name_text_path = "Content/PlayerNameText"
local rich_text_path = "Content/RichText"
local content_path = "Content"

function ChatSeasonTradeShopRefreshMsg:OnCreate()
  base.OnCreate(self)
  self.playerHead = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.lord_title = self:AddComponent(UIImage, lord_title_path)
  self.player_name_text = self:AddComponent(UITextMeshProUGUIEx, player_name_text_path)
  self.message = self:AddComponent(UITextMeshProUGUIEx, rich_text_path)
  self.message:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  self.btn = self:AddComponent(UIButton, content_path)
  self.btn:SetOnClick(function()
    self:OnPointerClick()
  end)
end

function ChatSeasonTradeShopRefreshMsg:OnDestroy()
  self.playerHead = nil
  self.player_name_text = nil
  self.message = nil
  self.lord_title = nil
  base.OnDestroy(self)
end

function ChatSeasonTradeShopRefreshMsg:GetJsonObj()
  if self._chatData and self._chatData.extra and self._chatData.extra.customJsonParam then
    return rapidjson.decode(self._chatData.extra.customJsonParam)
  end
  return nil
end

function ChatSeasonTradeShopRefreshMsg:OnPointerClick(clickPos)
  local post = self._chatData ~= nil and self._chatData.post or nil
  if post == PostType.SeasonTradeShopRefresh then
    local jsonObj = self:GetJsonObj()
    local serverId = jsonObj ~= nil and jsonObj.serverId or nil
    local pointId = jsonObj ~= nil and jsonObj.pointId or nil
    if pointId ~= nil then
      GoToUtil.CloseAllWindows()
      local willPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
      GoToUtil.GotoWorldPos(willPos, nil, 0.02, nil, serverId)
    end
  end
end

function ChatSeasonTradeShopRefreshMsg:UpdateItem(_chat_data, _index)
  self._chatIndex = _index
  self._chatData = _chat_data
  self._roomId = _chat_data.roomId
  self._msgSeq = tostring(self._chatData.seqId)
  local _message = _chat_data:getSuperParsedResult()
  if _message == nil then
    _message = _chat_data:getMessageWithExtra(false)
  end
  self.message:SetActive(false)
  self.message:SetText(_message)
  self.message:SetActive(true)
  local jsonObj = self:GetJsonObj()
  if jsonObj then
    local userInfo = jsonObj
    local tradeId = jsonObj.tradeId
    local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(tradeId, LuaEntry.Player:GetCurServerId())
    if cityMeta and not string.IsNullOrEmpty(cityMeta.lord_cap) then
      self.lord_title:LoadSpriteAsyncEx(cityMeta.lord_cap)
      self.lord_title:SetActive(true)
      self.playerHead:SetHeadAndFrame(userInfo.uid, userInfo.pic, userInfo.picVer, false)
    else
      self.lord_title:SetActive(false)
      self.playerHead:SetHeadAndFrame(userInfo.uid, userInfo.pic, userInfo.picVer, false, userInfo.headSkinId, userInfo.headSkinET)
    end
    local playerServerId = jsonObj.playerServerId or jsonObj.serverId
    local strUser = UIUtil.FormatServerAllianceName(playerServerId, userInfo.abbr, userInfo.name)
    self.player_name_text:SetText(strUser)
  end
end

return ChatSeasonTradeShopRefreshMsg
