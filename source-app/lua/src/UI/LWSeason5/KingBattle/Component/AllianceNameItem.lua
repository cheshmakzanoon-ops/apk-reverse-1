local base = UIBaseContainer
local AllianceNameItem = BaseClass("AllianceNameItem", base)
local btn_path = ""
local abbr_path = "allianceAbbr"
local name_path = "allianceName"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:AddUIListener(EventId.SearchAllianceSuccess, self.OnAllianceDataCallBack)
end

local function OnDestroy(self)
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.OnAllianceDataCallBack)
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
  self.btn = self:AddComponent(UIButton, btn_path)
  self.abbr = self:AddComponent(UIText, abbr_path)
  self.name = self:AddComponent(UIText, name_path)
  self.btn:SetOnClick(function()
    if not string.IsNullOrEmpty(self.allianceId) then
      UIUtil.TryShowAllianceInfo(nil, self.allianceId, nil)
    end
  end)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.abbr = nil
  self.name = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function AllianceNameItem:ReInit(allianceId, data)
  self.allianceId = allianceId
  self.data = data
  if data then
    local msg = UIUtil.FormatServerAllianceName(data.serverId, data.allianceAbbr, nil)
    self.abbr:SetText(msg)
    self.name:SetText(data.allianceName)
    self.serverId = data.serverId
  else
    self.abbr:SetText("")
    self.name:SetText("")
  end
  if (data == nil or data.allianceAbbr == nil or data.allianceName == nil) and not string.IsNullOrEmpty(allianceId) then
    local allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(allianceId)
    if allianceInfo == nil then
      SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, allianceId)
    end
  end
end

function AllianceNameItem:OnAllianceDataCallBack()
  if string.IsNullOrEmpty(self.allianceId) then
    return
  end
  local data = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.allianceId)
  if data == nil then
    return
  end
  local serverId = self.serverId or data.createServer
  if data.ownerServerId and data.ownerServerId > 0 then
    serverId = data.ownerServerId
  end
  local msg = UIUtil.FormatServerAllianceName(serverId, data.abbr, nil)
  self.abbr:SetText(msg)
  self.name:SetText(data.allianceName)
end

AllianceNameItem.OnCreate = OnCreate
AllianceNameItem.OnDestroy = OnDestroy
AllianceNameItem.OnEnable = OnEnable
AllianceNameItem.OnDisable = OnDisable
AllianceNameItem.ComponentDefine = ComponentDefine
AllianceNameItem.ComponentDestroy = ComponentDestroy
AllianceNameItem.DataDefine = DataDefine
AllianceNameItem.DataDestroy = DataDestroy
return AllianceNameItem
