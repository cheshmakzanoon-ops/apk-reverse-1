local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemNeutralAttack = BaseClass("ChatItemNeutralAttack", IChatItem)
local base = IChatItem
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local _cp_text = "ChatAnchor/Background/DialogText"
local _cp_rich_text = "ChatAnchor/Background/DialogRichText"
local _cp_obj_ChatAnchor = "ChatAnchor"
local _cp_bg = "ChatAnchor/Background"
local _cp_background = "Image"

function ChatItemNeutralAttack:ComponentDefine()
  self._obj = self:AddComponent(UIBaseContainer, _cp_obj_ChatAnchor)
  self._text = self:AddComponent(UIText, _cp_text)
  self._rich_text = self:AddComponent(UITextMeshProUGUIEx, _cp_rich_text)
  self._background = self:AddComponent(UIImage, _cp_background)
  self._bgBtnLongPress = self:AddComponent(UIButton_LongPress, _cp_bg)
  if self._bgBtnLongPress then
    self._bgBtnLongPress:SetTouchBgGray(true)
    self._bgBtnLongPress:SetClickAction(function()
      self:GotoAction()
    end)
  end
  self._rich_text:SetActive(false)
end

function ChatItemNeutralAttack:GotoAction()
  local extra = self._chatdata.extra or {}
  local allianceCityInfo = extra.allianceCityInfo or ""
  local tabCityInfo = rapidjson.decode(allianceCityInfo)
  if tabCityInfo == nil then
    return
  end
  local cityId = tabCityInfo.cityId or 0
  local strPos = GetTableData(TableName.WorldCity, cityId, "location")
  local tabPos = string.split(strPos, "|")
  if table.count(tabPos) ~= 2 then
    return
  end
  local vec2 = CS.UnityEngine.Vector2Int(tonumber(tabPos[1]), tonumber(tabPos[2]))
  if CS.SceneManager:IsInCity() then
    if not SceneUtils.CheckCanGotoWorld() then
      return
    end
    local pointId = SceneUtils.TileToWorld(vec2, ForceChangeScene.World)
    EventManager:GetInstance():Broadcast(ChatEventEnum.LF_CloseChatView, true)
    GoToUtil.GotoWorldPos(pointId, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
    end)
  end
  local pointId = SceneUtils.TilePosToIndex(vec2)
  GoToUtil.CloseAllWindows()
  EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
  GoToUtil.MoveToWorldPoint(pointId)
end

function ChatItemNeutralAttack:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemNeutralAttack:UpdateItem(_chatdata)
  if _chatdata == nil then
    return
  end
  self._chatdata = _chatdata
  local maxWidth = self:GetChatItemMaxWidth()
  local minHeight = 136
  self._obj.rectTransform:Set_sizeDelta(maxWidth, minHeight)
  local str = _chatdata:getMessageWithExtra(true)
  if str:find("X:") ~= nil and str:find("Y:") ~= nil then
    str = string.gsub(str, "[(]", "<u>(")
    str = string.gsub(str, "[)]", ")</u>")
    self._rich_text:SetText(str)
    self._text:SetActive(false)
    self._rich_text:SetActive(true)
  else
    self._text:SetText(str)
    self._text:SetActive(true)
    self._rich_text:SetActive(false)
  end
  self._obj.rectTransform:Set_sizeDelta(maxWidth, minHeight)
end

return ChatItemNeutralAttack
