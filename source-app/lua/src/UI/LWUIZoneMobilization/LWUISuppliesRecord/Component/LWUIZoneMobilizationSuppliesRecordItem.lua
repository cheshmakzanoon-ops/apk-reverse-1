local base = UIBaseContainer
local LWUIZoneMobilizationSuppliesRecordItem = BaseClass("LWUIZoneMobilizationSuppliesRecordItem", base)
local Localization = CS.GameEntry.Localization
local playerHeadObj_path = "UIPlayerHead"
local icon_path = "Bg/Icon"
local time_text_path = "TimeText"
local desc_text_path = "DescText"
local ICON_PATH = "Assets/Main/Sprites/UI/LWUIZoneMobilization/%s.png"

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
  self.playerHeadObj = self:AddComponent(UICommonHead, playerHeadObj_path)
  self.playerHeadObj:SetEnableClickShowInfo(true, true)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
end

local function ComponentDestroy(self)
  self.playerHeadObj = nil
  self.icon = nil
  self.time_text = nil
  self.desc_text = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function InitData(self, data)
  self.data = data
  if data == nil then
    return
  end
  self.playerHeadObj:SetHead(data.uid, data.headPic, data.headPicVer)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = curTime - data.time
  local timeStr = UIUtil.GetDeltaTimeTimeStr(deltaTime)
  self.time_text:SetText(timeStr)
  local cfgId = data.cfgId
  local type = data.type
  local playName = "[" .. data.abbr .. "]" .. data.name
  if type == 1 then
    if cfgId then
      local line = LocalController:instance():tryGetLine(TableName.AllianceMine, cfgId)
      if line then
        local name = CS.GameEntry.Localization:GetString(line.name)
        local special_flag = line.special_flag
        local flag = tonumber(special_flag) == 1 and 0 or 1
        local dialogId
        if flag == 0 then
          dialogId = "zone_mobilization_donated_supplies_small_record"
        else
          dialogId = "zone_mobilization_donated_supplies_record"
        end
        self.desc_text:SetLocalText(dialogId, playName, line.city_level, name)
        local iconPath = DataCenter.LWZoneMobilizationManager:GetSuppliesIcon(flag)
        self.icon:LoadSprite(string.format(ICON_PATH, iconPath))
      end
    end
  elseif type == 2 and cfgId then
    local line = LocalController:instance():tryGetLine(TableName.LWIceSupplies, cfgId)
    if line then
      local name = CS.GameEntry.Localization:GetString(line.name)
      local flag = line.type == 6 and 0 or 1
      local dialogId
      if flag == 0 then
        dialogId = "zone_mobilization_donated_supplies_small_record"
      else
        dialogId = "zone_mobilization_donated_supplies_record"
      end
      self.desc_text:SetLocalText(dialogId, playName, line.level, name)
      local iconPath = DataCenter.LWZoneMobilizationManager:GetResourceIcon(flag)
      self.icon:LoadSprite(string.format(ICON_PATH, iconPath))
    end
  end
end

LWUIZoneMobilizationSuppliesRecordItem.OnCreate = OnCreate
LWUIZoneMobilizationSuppliesRecordItem.OnDestroy = OnDestroy
LWUIZoneMobilizationSuppliesRecordItem.OnEnable = OnEnable
LWUIZoneMobilizationSuppliesRecordItem.OnDisable = OnDisable
LWUIZoneMobilizationSuppliesRecordItem.ComponentDefine = ComponentDefine
LWUIZoneMobilizationSuppliesRecordItem.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationSuppliesRecordItem.DataDefine = DataDefine
LWUIZoneMobilizationSuppliesRecordItem.DataDestroy = DataDestroy
LWUIZoneMobilizationSuppliesRecordItem.InitData = InitData
return LWUIZoneMobilizationSuppliesRecordItem
