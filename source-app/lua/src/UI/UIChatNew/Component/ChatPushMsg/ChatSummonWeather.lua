local base = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatSummonWeather = BaseClass("ChatSummonWeather", base)
local SeasonWeatherIcon = require("UI.LWSeason.LWSeasonWeather.Component.SeasonWeatherIcon")
local rapidjson = require("rapidjson")

function ChatSummonWeather:OnCreate()
  base.OnCreate(self)
  self.cellArea = self:AddComponent(UIBaseContainer, "")
  self.bodySprite = self:AddComponent(UIRawImage, "Assistant/Role/icon")
  self.bgSprite = self:AddComponent(UIImage, "Assistant")
  self.message = self:AddComponent(UITextMeshProUGUIEx, "Assistant/RichTextRoot/RichText")
  self.messageLayoutGroup = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "Assistant/RichTextRoot")
  self.message:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  self.fx = self:AddComponent(UIBaseContainer, "Assistant/Role/fx")
end

function ChatSummonWeather:OnDestroy()
  self.cellArea = nil
  self.bodySprite = nil
  self.bgSprite = nil
  self.message = nil
  self.messageLayoutGroup = nil
  self.tmpEventTrigger = nil
  base.OnDestroy(self)
end

function ChatSummonWeather:OnAddListener()
  base.OnAddListener(self)
end

function ChatSummonWeather:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ChatSummonWeather:OnPointerClick(clickPos)
  if not LuaEntry.Player:IsLoginSourceServer() then
    UIUtil.ShowTipsId("season_tips166")
    return
  end
  if self._chatData and self._chatData.extra and self._chatData.extra.customJsonParam and DataCenter.SeasonWeatherManager:IsOpen() and not DataCenter.SeasonWeatherManager:IsCloseUI() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonWeather, {anim = true})
  end
end

function ChatSummonWeather:UpdateItem(_chat_data, _index)
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
  if self._chatData and self._chatData.extra and self._chatData.extra.customJsonParam then
    local jsonObj = rapidjson.decode(self._chatData.extra.customJsonParam)
    self:SetIcon(jsonObj and jsonObj.curWeatherId or 0)
  end
end

function ChatSummonWeather:SetIcon(weatherType)
  if self.weatherIcon then
    self.weatherIcon:ReInit(weatherType)
    return
  end
  if not self.req then
    self.req = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWSeason1/Effect/Eff_ui_S1_weather_icon1.prefab", function(req)
      local obj = req.gameObject
      if IsNull(obj) then
        return
      end
      local trans = obj.transform
      trans:SetParent(self.fx.transform)
      trans.localScale = Vector3.one
      trans.localPosition = Vector3.zero
      local weatherIcon = self.fx:AddComponent(SeasonWeatherIcon, obj.name)
      weatherIcon:ReInit(weatherType)
      self.weatherIcon = weatherIcon
    end)
  end
end

return ChatSummonWeather
