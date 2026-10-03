local base = UIBaseContainer
local SnowStormWorldAllianceMember = BaseClass("SnowStormWorldAllianceMember", base)
local Localization = CS.GameEntry.Localization
local assistanceBtn_path = "AssistanceBtn"
local playerHead_path = "UIPlayerHead"
local name_path = "name"
local temperature_path = "temperature"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.assistanceBtn = self:AddComponent(UIButton, assistanceBtn_path)
  self.playerHead = self:AddComponent(UIBaseContainer, playerHead_path)
  self.name = self:AddComponent(UIText, name_path)
  self.temperature = self:AddComponent(UIText, temperature_path)
  self.headIcon = self:AddComponent(UICommonHead, playerHead_path)
  self.assistanceBtn:SetOnClick(function()
    self:OnAssistanceBtn()
  end)
end

local function ComponentDestroy(self)
  self.assistanceBtn = nil
  self.playerHead = nil
  self.name = nil
  self.temperature = nil
  self.headIcon = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SnowStormWorldAllianceMember:SetData(data)
  self.curTemp = data.curTemp or 0
  self.pointId = data.pointId
  self.memeberName = data.name
  self.uid = data.uid
  self.name:SetText(self.memeberName .. "@" .. tostring(LuaEntry.Player:GetSourceServerId()))
  local temp = string.format("%s,%.2f,\194\176C", Localization:GetString("season_s2_storm_event_18"), self.curTemp)
  self.temperature:SetText(temp)
  self.headIcon:SetHeadAndFrame(data.uid, data.headPic, data.headPicVer, false, data.headSkinId, data.headSkinET)
  self.headIcon:SetEnableClickShowInfo(true)
end

function SnowStormWorldAllianceMember:OnAssistanceBtn()
  GoToUtil.CloseAllWindows()
  GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(self.pointId, ForceChangeScene.World), CS.SceneManager.World.InitZoom)
end

SnowStormWorldAllianceMember.OnCreate = OnCreate
SnowStormWorldAllianceMember.OnDestroy = OnDestroy
SnowStormWorldAllianceMember.OnEnable = OnEnable
SnowStormWorldAllianceMember.OnDisable = OnDisable
SnowStormWorldAllianceMember.ComponentDefine = ComponentDefine
SnowStormWorldAllianceMember.ComponentDestroy = ComponentDestroy
SnowStormWorldAllianceMember.DataDefine = DataDefine
SnowStormWorldAllianceMember.DataDestroy = DataDestroy
return SnowStormWorldAllianceMember
