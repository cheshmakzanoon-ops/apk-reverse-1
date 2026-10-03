local UIPrivacyView = BaseClass("UIPrivacyView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SDKManager = CS.SDKManager
local compBook = {
  {
    path = "BtnGo/Content",
    name = "content_text",
    type = UITextMeshProUGUIEx
  },
  {
    path = "BtnGo/PlayBtn",
    name = "playBtn",
    type = UIButton
  },
  {
    path = "BtnGo/PlayBtn/BtnText",
    name = "playBtn_text",
    type = UITextMeshProUGUIEx
  }
}

function UIPrivacyView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIPrivacyView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIPrivacyView:OnAddListener()
  base.OnAddListener(self)
end

function UIPrivacyView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIPrivacyView:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.content_text:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  self.playBtn:SetOnClick(function()
    self:OnConfirmClick()
  end)
end

function UIPrivacyView:DataDefine()
end

function UIPrivacyView:OnPointerClick(clickPos)
  local linkId = self.content_text:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  CS.SDKManager.OpenURL(linkId)
end

function UIPrivacyView:OnConfirmClick()
  self:RecordPostEvent()
  EventManager:GetInstance():Broadcast(EventId.UIPrivacy_Confirm)
  self.ctrl:CloseSelf()
end

function UIPrivacyView:RecordPostEvent()
  local urlList = {}
  self.content_text.unity_tmpro:ForceMeshUpdate()
  local textInfo = self.content_text.unity_tmpro.textInfo
  local links = textInfo.linkInfo
  local linkedLen = links.Length
  for i = 1, linkedLen do
    local link = links[i - 1]
    local linkText = link:GetLinkID()
    if not string.IsNullOrEmpty(linkText) then
      table.insert(urlList, linkText)
    end
  end
  local eventData = {}
  if 0 < #urlList then
    if urlList[1] then
      eventData.s_para1 = urlList[1]
    end
    if urlList[2] then
      eventData.s_para2 = urlList[2]
    end
    if urlList[3] then
      eventData.s_para3 = urlList[3]
    end
    if urlList[4] then
      eventData.s_para4 = urlList[4]
    end
  end
  PostEventLog.Track(PostEventLog.Defines.DMA_AGREE_RECORD, eventData)
end

function UIPrivacyView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIPrivacyView:DataDestroy()
end

function UIPrivacyView:ReInit()
  local mode = self:GetUserData()
  local content_text_key = "game_start_notice001_new"
  local isIos = SDKManager.IS_IPhonePlayer()
  local isConfirmed = CSharpCallLuaInterface.IsPrivacyConfirmed()
  if isConfirmed then
    content_text_key = "game_start_notice002_new"
  else
    content_text_key = "game_start_notice001_new"
  end
  self.content_text_key = content_text_key
  self.content_text:SetLocalText(content_text_key)
  self.playBtn_text:SetText(Localization:GetString(100833))
end

return UIPrivacyView
