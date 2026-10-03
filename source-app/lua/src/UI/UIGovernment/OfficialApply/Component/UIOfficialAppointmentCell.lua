local base = UIBaseContainer
local UIOfficialAppointmentCell = BaseClass("UIOfficialAppointmentCell", base)
local Color = _ENV.Color
local LuaEntry = _ENV.LuaEntry
local nameText_path = "NameText"
local dialogText_path = "DialogText"
local jumpBtn_Path = "BtnGroup/JumpBtn"
local removeBtn_path = "BtnGroup/RemoveBtn"
local bg_path = "Bg"
local tipText_path = "TipText"
local playerHead_Path = "Head/UIPlayerHead"
local state_text_path = "StateText"
local btn_group_path = "BtnGroup"
local tip_text_path = "TipText"
local upPosY = 14
local centerPosY = 0
local posX = 246

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.nameText = self:AddComponent(UIText, nameText_path)
  self.dialogText = self:AddComponent(UIText, dialogText_path)
  self.jumpBtn = self:AddComponent(UIButton, jumpBtn_Path)
  self.removeBtn = self:AddComponent(UIButton, removeBtn_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.tipText = self:AddComponent(UIText, tipText_path)
  self.playerHead = self:AddComponent(UICommonHead, playerHead_Path)
  self.playerHead:SetEnableClickShowInfo(true, true)
  self.jumpBtn:SetOnClick(function()
    if self.isLock then
      UIUtil.ShowTipsId(457059)
      return
    end
    DataCenter.GovernmentManager:TryKingdomPositionAppoint(self.positionId, self.data, DataCenter.GovernmentTemplateManager:GetTemplate(self.positionId), nil)
  end)
  self.removeBtn:SetOnClick(function()
    local isCtrl = DataCenter.OfficialApplyManager:IsManager(self.serverId)
    self.view.ctrl:SendKingdomPositionAppointmentDelete(self.positionId, self.data, isCtrl)
  end)
  self.state_text = self:AddComponent(UITextMeshProUGUIEx, state_text_path)
  self.btn_group = self:AddComponent(UIBaseContainer, btn_group_path)
  posX = self.btn_group:GetAnchoredPositionX()
  self.tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
end

local function ComponentDestroy(self)
  self.nameText = nil
  self.dialogText = nil
  self.jumpBtn = nil
  self.removeBtn = nil
  self.bg = nil
  self.tipText = nil
  self.playerHead = nil
  self.state_text = nil
  self.btn_group = nil
  self.tip_text = nil
end

local function DataDefine(self)
  self.positionId = nil
  self.isLock = nil
end

local function DataDestroy(self)
  self.positionId = nil
  self.isLock = nil
end

local function SetData(self, positionId, data, isLock, serverId)
  self.serverId = serverId
  self.positionId = positionId
  self.data = data
  local framePath
  if data.headSkinId then
    framePath = DataCenter.DecorationDataManager:GetHeadFrame(data.headSkinId, data.headSkinET, false)
  end
  self.playerHead:SetData(data.uid, data.pic, data.picver, nil, framePath)
  self.nameText:SetText(data:GetFullName(data.uid))
  local isServer = CS.GameEntry.Setting:GetBool(SettingKeys.OFFICIAL_APPLY_TIME_SHOW_MODE, true)
  self:SetTimeShowMode(data.appointTime, isServer)
  local isCtrl = DataCenter.OfficialApplyManager:IsManager(self.serverId)
  if isCtrl then
    self.jumpBtn:SetActive(true)
    self.removeBtn:SetActive(true)
    self.state_text:SetActive(true)
    self.btn_group:SetAnchoredPositionXY(posX, upPosY)
    if data.state == 0 then
      self.state_text:SetLocalText("393016")
      self.state_text:SetColor(Color.New(0.16470588235294117, 0.1568627450980392, 0.18823529411764706, 1))
    elseif data.state == 1 then
      self.state_text:SetLocalText("393015")
      self.state_text:SetColor(Color.New(0.0784313725490196, 0.6627450980392157, 0.10588235294117647, 1))
    elseif data.state == 2 then
      self.state_text:SetLocalText("officer_apply_027")
      self.state_text:SetColor(Color.New(0.16470588235294117, 0.1568627450980392, 0.18823529411764706, 1))
    end
  else
    self.state_text:SetActive(false)
    self.btn_group:SetAnchoredPositionXY(posX, centerPosY)
    if data.uid == LuaEntry.Player.uid then
      self.jumpBtn:SetActive(false)
      self.removeBtn:SetActive(true)
    else
      self.jumpBtn:SetActive(false)
      self.removeBtn:SetActive(false)
    end
  end
  if data.uid == LuaEntry.Player.uid then
    self.bg:SetColor(Color.New(0.6392156862745098, 0.8901960784313725, 0.5215686274509804, 1))
    self.nameText:SetColor(Color.New(0.2901960784313726, 0.5764705882352941, 0.15294117647058825, 1))
    self.dialogText:SetColor(Color.New(0.0784313725490196, 0.6627450980392157, 0.10588235294117647, 1))
    self.tipText:SetColor(Color.New(0.0784313725490196, 0.6627450980392157, 0.10588235294117647, 1))
  else
    self.bg:SetColor(Color.New(0.9098039215686274, 0.8274509803921568, 0.8431372549019608, 1))
    if not string.IsNullOrEmpty(data.allianceId) and data.allianceId == LuaEntry.Player:GetAllianceUid() then
      self.nameText:SetColor(Color.New(0.14901960784313725, 0.5803921568627451, 0.8, 1))
    else
      self.nameText:SetColor(Color.New(0.16470588235294117, 0.1568627450980392, 0.18823529411764706, 1))
    end
    self.dialogText:SetColor(Color.New(0.16470588235294117, 0.1568627450980392, 0.18823529411764706, 1))
    self.tipText:SetColor(Color.New(0.16470588235294117, 0.1568627450980392, 0.18823529411764706, 1))
  end
  self:SetLock(isLock)
end

local function SetLock(self, isLock)
  self.isLock = isLock
  CS.UIGray.SetGray(self.jumpBtn.transform, self.isLock, true)
end

local function SetTimeShowMode(self, time, isServer)
  local timeText = ""
  if isServer then
    timeText = UITimeManager:GetInstance():TimeStampToTimeForServer(tonumber(time))
    self.tip_text:SetLocalText("officer_apply_032")
  else
    timeText = UITimeManager:GetInstance():TimeStampToTimeForLocal(tonumber(time))
    self.tip_text:SetLocalText("officer_apply_049")
  end
  self.dialogText:SetText(timeText)
end

UIOfficialAppointmentCell.OnCreate = OnCreate
UIOfficialAppointmentCell.OnDestroy = OnDestroy
UIOfficialAppointmentCell.OnEnable = OnEnable
UIOfficialAppointmentCell.OnDisable = OnDisable
UIOfficialAppointmentCell.ComponentDefine = ComponentDefine
UIOfficialAppointmentCell.ComponentDestroy = ComponentDestroy
UIOfficialAppointmentCell.DataDefine = DataDefine
UIOfficialAppointmentCell.DataDestroy = DataDestroy
UIOfficialAppointmentCell.SetData = SetData
UIOfficialAppointmentCell.SetLock = SetLock
UIOfficialAppointmentCell.SetTimeShowMode = SetTimeShowMode
return UIOfficialAppointmentCell
