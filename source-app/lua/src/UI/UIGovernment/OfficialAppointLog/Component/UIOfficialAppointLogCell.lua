local base = UIBaseContainer
local UIOfficialAppointLogCell = BaseClass("UIOfficialAppointLogCell", base)
local nameText_path = "NameText"
local dialogText_path = "DialogText"
local bg_path = "Bg"
local tipText_path = "TipText"
local playerHead_Path = "Head/UIPlayerHead"
local tip_text_path = "TipText"

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
  self.bg = self:AddComponent(UIImage, bg_path)
  self.tipText = self:AddComponent(UIText, tipText_path)
  self.playerHead = self:AddComponent(UICommonHead, playerHead_Path)
  self.playerHead:SetEnableClickShowInfo(true, true)
  self.tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
end

local function ComponentDestroy(self)
  self.nameText = nil
  self.dialogText = nil
  self.bg = nil
  self.tipText = nil
  self.playerHead = nil
  self.tip_text = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, postionId, data)
  self.nameText:SetText(data:GetFullName(data.uid))
  local framePath
  if data.headSkinId then
    framePath = DataCenter.DecorationDataManager:GetHeadFrame(data.headSkinId, data.headSkinET, false)
  end
  self.playerHead:SetData(data.uid, data.pic, data.picver, nil, framePath)
  local isServer = CS.GameEntry.Setting:GetBool(SettingKeys.OFFICIAL_APPLY_TIME_SHOW_MODE, true)
  self:SetTimeShowMode(data.appointTime, data.fireTime, isServer)
  if data.uid == LuaEntry.Player.uid then
    self.bg:SetColor(Color.New(0.6392156862745098, 0.8901960784313725, 0.5215686274509804, 1))
  else
    self.bg:SetColor(Color.New(0.9098039215686274, 0.8274509803921568, 0.8431372549019608, 1))
  end
  if data.uid == LuaEntry.Player.uid then
    self.nameText:SetColor(Color.New(0.2901960784313726, 0.5764705882352941, 0.15294117647058825, 1))
  elseif not string.IsNullOrEmpty(data.allianceId) and data.allianceId == LuaEntry.Player:GetAllianceUid() then
    self.nameText:SetColor(Color.New(0.14901960784313725, 0.5803921568627451, 0.8, 1))
  else
    self.nameText:SetColor(Color.New(0.16470588235294117, 0.1568627450980392, 0.18823529411764706, 1))
  end
  if data.uid == LuaEntry.Player.uid then
    self.dialogText:SetColor(Color.New(0.0784313725490196, 0.6627450980392157, 0.10588235294117647, 1))
    self.tipText:SetColor(Color.New(0.0784313725490196, 0.6627450980392157, 0.10588235294117647, 1))
  else
    self.dialogText:SetColor(Color.New(0.16470588235294117, 0.1568627450980392, 0.18823529411764706, 1))
    self.tipText:SetColor(Color.New(0.16470588235294117, 0.1568627450980392, 0.18823529411764706, 1))
  end
end

local function SetTimeShowMode(self, appointTime, endTime, isServer)
  local timeText = ""
  if isServer then
    timeText = UITimeManager:GetInstance():TimeStampToTimeForServer(tonumber(appointTime))
    if endTime and 0 < endTime then
      timeText = timeText .. " ~ " .. UITimeManager:GetInstance():TimeStampToTimeForServer(tonumber(endTime))
    end
    self.tip_text:SetLocalText("officer_apply_018")
  else
    timeText = UITimeManager:GetInstance():TimeStampToTimeForLocal(tonumber(appointTime))
    if endTime and 0 < endTime then
      timeText = timeText .. " ~ " .. UITimeManager:GetInstance():TimeStampToTimeForLocal(tonumber(endTime))
    end
    self.tip_text:SetLocalText("officer_apply_050")
  end
  self.dialogText:SetText(timeText)
end

UIOfficialAppointLogCell.OnCreate = OnCreate
UIOfficialAppointLogCell.OnDestroy = OnDestroy
UIOfficialAppointLogCell.OnEnable = OnEnable
UIOfficialAppointLogCell.OnDisable = OnDisable
UIOfficialAppointLogCell.ComponentDefine = ComponentDefine
UIOfficialAppointLogCell.ComponentDestroy = ComponentDestroy
UIOfficialAppointLogCell.DataDefine = DataDefine
UIOfficialAppointLogCell.DataDestroy = DataDestroy
UIOfficialAppointLogCell.SetData = SetData
UIOfficialAppointLogCell.SetTimeShowMode = SetTimeShowMode
return UIOfficialAppointLogCell
