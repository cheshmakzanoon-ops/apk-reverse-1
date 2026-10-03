local UIRedenvelopeSendView = BaseClass("UIRedenvelopeSendView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local playerHead = "ImgBg/Rect_Head/UIPlayerHead/HeadIcon"
local playerHeadFg = "ImgBg/Rect_Head/UIPlayerHead/Foreground"
local playerHeadBg = "ImgBg/Rect_HeadBg"
local txt_content1_path = "ImgBg/Txt_Content1"
local txt_content2_path = "ImgBg/Txt_Content2"
local btn_sendRed_path = "ImgBg/Btn_SendRed"
local txt_sendRed_path = "ImgBg/Btn_SendRed/Txt_SendRed"
local return_btn_path = "panel"

local function OnCreate(self)
  base.OnCreate(self)
  self.playerHead = self:AddComponent(UIPlayerHead, playerHead)
  self.playerHeadFg = self:AddComponent(UIImage, playerHeadFg)
  self._content1_txt = self:AddComponent(UIText, txt_content1_path)
  self._content2_txt = self:AddComponent(UIText, txt_content2_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self._sendRed_btn = self:AddComponent(UIButton, btn_sendRed_path)
  self._sendRed_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self._sendRed_txt = self:AddComponent(UIText, txt_sendRed_path)
  self.playerHeadBg = self:AddComponent(UIBaseContainer, playerHeadBg)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:OnRefresh()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnRefresh(self)
  self.data = self:GetUserData()
  self:SetContent()
end

local function SetContent(self)
  self.redData = DataCenter.AllianceRedPacketManager:GetRedPacketByUUid(self.data)
  self.playerHead:SetData(self.redData.uid, self.redData.pic, self.redData.picV)
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  self.playerHeadFg:SetActive(curTime < self.redData.mCardET)
  self.playerHeadBg:SetActive(curTime >= self.redData.mCardET)
  local buildId = GetTableData(TableName.SysRedPacket, self.redData.reasonId, "building")
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  local lvConfig = GetTableData(TableName.SysRedPacket, self.redData.reasonId, "level")
  self._content1_txt:SetText(Localization:GetString("390889", Localization:GetString(buildTemplate.name), lvConfig))
  self._content2_txt:SetActive(true)
  self._content2_txt:SetLocalText(390891)
  self._sendRed_txt:SetLocalText(390890)
end

local function SendChatRed(self)
  self.ctrl:SendChatRed(self.data)
end

UIRedenvelopeSendView.OnCreate = OnCreate
UIRedenvelopeSendView.OnDestroy = OnDestroy
UIRedenvelopeSendView.OnRefresh = OnRefresh
UIRedenvelopeSendView.OnEnable = OnEnable
UIRedenvelopeSendView.OnDisable = OnDisable
UIRedenvelopeSendView.OnAddListener = OnAddListener
UIRedenvelopeSendView.OnRemoveListener = OnRemoveListener
UIRedenvelopeSendView.SetContent = SetContent
UIRedenvelopeSendView.SendChatRed = SendChatRed
return UIRedenvelopeSendView
