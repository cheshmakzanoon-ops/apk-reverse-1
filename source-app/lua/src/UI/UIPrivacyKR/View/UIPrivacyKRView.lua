local UIPrivacyKRView = BaseClass("UIPrivacyKRView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local SDKManager = CS.SDKManager
local compBook = {
  {
    path = "Root/ScrollView/Viewport/Content",
    name = "content",
    type = UITextMeshProUGUIEx
  },
  {
    path = "Root/agreeBtn1",
    name = "agree_btn1",
    type = UIButton
  },
  {
    path = "Root/agreeBtn1/agreeBtn1BeSelect",
    name = "agree_btn1_be_select",
    type = UIImage
  },
  {
    path = "Root/agreeBtn1/tipContent/agreeTip1",
    name = "agree_tip1",
    type = UITextMeshProUGUIEx
  },
  {
    path = "Root/agreeBtn2",
    name = "agree_btn2",
    type = UIButton
  },
  {
    path = "Root/agreeBtn2/agreeBtn2BeSelect",
    name = "agree_btn2_be_select",
    type = UIImage
  },
  {
    path = "Root/agreeBtn2/tipContent/agreeTip2",
    name = "agree_tip2",
    type = UITextMeshProUGUIEx
  },
  {
    path = "Root/agreeBtn3",
    name = "agree_btn3",
    type = UIButton
  },
  {
    path = "Root/agreeBtn3/agreeBtn3BeSelect",
    name = "agree_btn3_be_select",
    type = UIImage
  },
  {
    path = "Root/agreeBtn3/tipContent/agreeTip3",
    name = "agree_tip3",
    type = UITextMeshProUGUIEx
  },
  {
    path = "Root/BtnAgreeAll",
    name = "btn_agree_all",
    type = UIButton
  },
  {
    path = "Root/BtnEnterGame",
    name = "btn_enter_game",
    type = UIButton
  }
}

function UIPrivacyKRView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
  self:RefreshView()
end

function UIPrivacyKRView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIPrivacyKRView:OnAddListener()
  base.OnAddListener(self)
end

function UIPrivacyKRView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIPrivacyKRView:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.agree_btn1:SetOnClick(function()
    self:OnAgreeClick(1)
  end)
  self.agree_btn2:SetOnClick(function()
    self:OnAgreeClick(2)
  end)
  self.agree_btn3:SetOnClick(function()
    self:OnAgreeClick(3)
  end)
  self.btn_agree_all:SetOnClick(function()
    self:OnAgreeAllClick()
  end)
  self.btn_enter_game:SetOnClick(function()
    self:OnConfirmClick()
  end)
  self.agree_tip1:OnPointerClick(function(eventData)
    self:OnAgreeTip1PointerClick(eventData.position)
  end)
  self.agree_tip2:OnPointerClick(function(eventData)
    self:OnAgreeTip2PointerClick(eventData.position)
  end)
  self.agree_tip3:OnPointerClick(function(eventData)
    self:OnAgreeTip3PointerClick(eventData.position)
  end)
  self.content:OnPointerClick(function(eventData)
    self:OnContentPointerClick(eventData.position)
  end)
end

function UIPrivacyKRView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIPrivacyKRView:DataDefine()
  self.agree1 = false
  self.agree2 = false
  self.agree3 = false
end

function UIPrivacyKRView:DataDestroy()
  self.agree1 = nil
  self.agree2 = nil
  self.agree3 = nil
end

function UIPrivacyKRView:RefreshView()
  self.agree_btn1_be_select:SetActive(self.agree1)
  self.agree_btn2_be_select:SetActive(self.agree2)
  self.agree_btn3_be_select:SetActive(self.agree3)
  if self.agree1 and self.agree2 and self.agree3 then
    UIGray.SetGray(self.btn_enter_game.transform, false, true)
  else
    UIGray.SetGray(self.btn_enter_game.transform, true, true)
  end
end

function UIPrivacyKRView:OnAgreeTip1PointerClick(clickPos)
  local linkId = self.agree_tip1:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  CS.SDKManager.OpenURL(linkId)
end

function UIPrivacyKRView:OnAgreeTip2PointerClick(clickPos)
  local linkId = self.agree_tip2:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  CS.SDKManager.OpenURL(linkId)
end

function UIPrivacyKRView:OnAgreeTip3PointerClick(clickPos)
  local linkId = self.agree_tip3:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  CS.SDKManager.OpenURL(linkId)
end

function UIPrivacyKRView:OnContentPointerClick(clickPos)
  local linkId = self.content:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  if "OpenAIHelp" == linkId then
    local id = "E009"
    CS.AIHelp.AIHelpProxy.Show(id, Localization:GetString("2700006"))
  end
end

function UIPrivacyKRView:OnAgreeClick(agreeId)
  if agreeId == 1 then
    self.agree1 = not self.agree1
  elseif agreeId == 2 then
    self.agree2 = not self.agree2
  elseif agreeId == 3 then
    self.agree3 = not self.agree3
  end
  self:RefreshView()
end

function UIPrivacyKRView:OnAgreeAllClick()
  self.agree1 = true
  self.agree2 = true
  self.agree3 = true
  self:RefreshView()
end

function UIPrivacyKRView:OnConfirmClick()
  if self.agree1 and self.agree2 and self.agree3 then
    self:RecordPostEvent()
    EventManager:GetInstance():Broadcast(EventId.UIPrivacy_Confirm)
    self.ctrl:CloseSelf()
  end
end

function UIPrivacyKRView:RecordPostEvent()
  local urlList = {}
  local agree_tip_list = {
    self.agree_tip1,
    self.agree_tip2,
    self.agree_tip3
  }
  for i, agree_tip in ipairs(agree_tip_list) do
    agree_tip.unity_tmpro:ForceMeshUpdate()
    local textInfo = agree_tip.unity_tmpro.textInfo
    local links = textInfo.linkInfo
    local linkedLen = links.Length
    for i = 1, linkedLen do
      local link = links[i - 1]
      local linkText = link:GetLinkID()
      if not string.IsNullOrEmpty(linkText) then
        table.insert(urlList, linkText)
      end
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

function UIPrivacyKRView:ReInit()
  local agree_tip1_key = "game_start_option1"
  local agree_tip2_key = "game_start_option2_new"
  local agree_tip3_key = "game_start_option3_new"
  self.agree_tip1_key = agree_tip1_key
  self.agree_tip2_key = agree_tip2_key
  self.agree_tip3_key = agree_tip3_key
  self.agree_tip1:SetLocalText(agree_tip1_key)
  self.agree_tip2:SetLocalText(agree_tip2_key)
  self.agree_tip3:SetLocalText(agree_tip3_key)
end

return UIPrivacyKRView
