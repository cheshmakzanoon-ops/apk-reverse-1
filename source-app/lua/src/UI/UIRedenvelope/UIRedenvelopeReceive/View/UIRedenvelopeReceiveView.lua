local UIRedenvelopeReceiveView = BaseClass("UIRedenvelopeReceiveView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_content1_path = "ImgBg/Txt_Content1"
local txt_content3_path = "ImgBg/Txt_Content3"
local txt_time_path = "ImgBg/Rect_Time/Txt_Time"
local img_icon_path = "ImgBg/NeedResourceCell/ResourceIcon"
local txt_num_path = "ImgBg/NeedResourceCell/ResourceNum"
local playerHead = "ImgBg/Rect_RedOwn/Rect_Head/UIPlayerHead/HeadIcon"
local playerHeadFg = "ImgBg/Rect_RedOwn/Rect_Head/UIPlayerHead/Foreground"
local txt_redOwnName_path = "ImgBg/Rect_RedOwn/Txt_RedOwnName"
local btn_sendRed_path = "ImgBg/Btn_SendRed"
local return_btn_path = "panel"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function ComponentDefine(self)
  self._content1_txt = self:AddComponent(UIText, txt_content1_path)
  self._content3_txt = self:AddComponent(UIText, txt_content3_path)
  self._time_txt = self:AddComponent(UIText, txt_time_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.playerHead = self:AddComponent(UIPlayerHead, playerHead)
  self.playerHeadFg = self:AddComponent(UIImage, playerHeadFg)
  self._redOwnName_txt = self:AddComponent(UIText, txt_redOwnName_path)
  self._sendRed_btn = self:AddComponent(UIButton, btn_sendRed_path)
  self._sendRed_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:SendChatRed()
  end)
end

local function DataDefine(self)
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
end

local function OnDestroy(self)
  self:DeleteTimer()
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
  self.message = self:GetUserData()
  local k1 = LuaEntry.DataConfig:TryGetNum("red_packet_time", "k1")
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local buildId = GetTableData(TableName.SysRedPacket, self.message.extra.reasonId, "building")
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  local lvConfig = GetTableData(TableName.SysRedPacket, self.message.extra.reasonId, "level")
  self._redOwnName_txt:SetText(self.message.extra.userName)
  self._content1_txt:SetText(Localization:GetString("390892", self.message.extra.userName, Localization:GetString(buildTemplate.name), lvConfig))
  self.playerHead:SetData(self.message.extra.uid, self.message.extra.headPic, self.message.extra.headPicVer)
  self.playerHeadFg:SetActive(self.message.extra.mCardET > curTime * 0.001)
  if self.message.status == RedPacketState.VALID then
    self._content3_txt:SetActive(true)
    self._content3_txt:SetLocalText(390893)
    self.endTime = self.message.createTime + k1 * 3600 * 1000
    self:AddTime()
    self._time_txt:SetText(Localization:GetString("390899") .. UITimeManager:GetInstance():MilliSecondToFmtString(self.endTime - curTime))
  end
end

local function AddTime(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.endTime then
    self.ctrl:CloseSelf()
  else
    self._time_txt:SetText(Localization:GetString("390899") .. UITimeManager:GetInstance():MilliSecondToFmtString(self.endTime - curTime))
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function SendChatRed(self)
  self.ctrl:SendChatRed(self.message)
end

UIRedenvelopeReceiveView.OnCreate = OnCreate
UIRedenvelopeReceiveView.ComponentDefine = ComponentDefine
UIRedenvelopeReceiveView.DataDefine = DataDefine
UIRedenvelopeReceiveView.OnDestroy = OnDestroy
UIRedenvelopeReceiveView.OnRefresh = OnRefresh
UIRedenvelopeReceiveView.OnEnable = OnEnable
UIRedenvelopeReceiveView.OnDisable = OnDisable
UIRedenvelopeReceiveView.OnAddListener = OnAddListener
UIRedenvelopeReceiveView.OnRemoveListener = OnRemoveListener
UIRedenvelopeReceiveView.AddTime = AddTime
UIRedenvelopeReceiveView.RefreshTime = RefreshTime
UIRedenvelopeReceiveView.DeleteTimer = DeleteTimer
UIRedenvelopeReceiveView.SendChatRed = SendChatRed
return UIRedenvelopeReceiveView
