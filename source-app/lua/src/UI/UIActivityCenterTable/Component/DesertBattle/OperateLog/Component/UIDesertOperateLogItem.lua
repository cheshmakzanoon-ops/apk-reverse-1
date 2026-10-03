local UIDesertOperateLogItem = BaseClass("UIDesertOperateLogItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_team_path = "Icon/TeamIcon"
local icon_type_path = "Icon/TypeIcon"
local txt_time_path = "Txt_Time"
local txt_des_path = "Txt_Des"
local IMG_TEAM_A = "zyf_caozuojilu_A"
local IMG_TEAM_B = "zyf_caozuojilu_B"
local IMG_TYPE_OUT = "zyf_caozuojilu_likai"
local IMG_TYPE_CMD = "zyf_caozuojilu_zhihui"
local IMG_TYPE_MAIN = "zyf_caozuojilu_jinru"
local IMG_TYPE_SUB = "zyf_caozuojilu_tibu"
local IMG_TYPE_CMD_OUT = "zyf_caozuojilu_quxiao"
local IMG_TYPE_GOU = "zyf_caozuojilu_fangqi2"
local IMG_TYPE_CHA = "zyf_caozuojilu_fangqi"
local IMG_TYPE_TIME = "zyf_caozuojilu_shijian"

function UIDesertOperateLogItem:OnCreate()
  base.OnCreate(self)
  self.icon_team = self:AddComponent(UIImage, icon_team_path)
  self.icon_type = self:AddComponent(UIImage, icon_type_path)
  self.txt_time = self:AddComponent(UIText, txt_time_path)
  self.txt_des = self:AddComponent(UITextMeshProUGUIEx, txt_des_path)
end

function UIDesertOperateLogItem:OnDestroy()
  self.bg_icon = nil
  self.txt_time = nil
  self.txt_des = nil
  base.OnDestroy(self)
end

function UIDesertOperateLogItem:SetItem(logInfo)
  local type = logInfo ~= nil and logInfo.type or 0
  local params = logInfo ~= nil and logInfo.params or ""
  local extra = string.split(params, ",") or {}
  self:LoadIcon(type, extra)
  self:SetDesc(type, extra)
  local time = logInfo ~= nil and logInfo.time or 0
  self.txt_time:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(time * 1000))
end

function UIDesertOperateLogItem:LoadIcon(type, extra)
  local teamPath, typePath, aFlag
  if type < DragonOperateLogType.GroupCancel then
    teamPath = toInt(extra[5]) == 2 and IMG_TEAM_B or IMG_TEAM_A
  elseif type < DragonOperateLogType.ChangeTime then
    teamPath = IMG_TEAM_B
  else
    teamPath = toInt(extra[3]) == 2 and IMG_TEAM_B or IMG_TEAM_A
  end
  self.icon_team:LoadSpriteAsyncWithCallback(string.format(LoadPath.LWBattleFieldDesertPath, "Operate/" .. teamPath), function()
    if self.icon_team then
      self.icon_team:SetNativeSize()
    end
  end)
  if type == DragonOperateLogType.PlayerRemove then
    typePath = IMG_TYPE_OUT
  elseif type == DragonOperateLogType.PlayerGroupAdd1 then
    typePath = IMG_TYPE_MAIN
  elseif type == DragonOperateLogType.PlayerGroupAdd2 then
    typePath = IMG_TYPE_SUB
  elseif type == DragonOperateLogType.CommanderAdd then
    typePath = IMG_TYPE_CMD
  elseif type == DragonOperateLogType.CommanderRemove then
    typePath = IMG_TYPE_CMD_OUT
  elseif type == DragonOperateLogType.GroupCancel then
    typePath = IMG_TYPE_CHA
  elseif type == DragonOperateLogType.GroupOpen then
    typePath = IMG_TYPE_GOU
  elseif type == DragonOperateLogType.ChangeTime then
    typePath = IMG_TYPE_TIME
  end
  self.icon_type:LoadSpriteAsyncWithCallback(string.format(LoadPath.LWBattleFieldDesertPath, "Operate/" .. typePath), function()
    if self.icon_type then
      self.icon_type:SetNativeSize()
    end
  end)
end

function UIDesertOperateLogItem:SetDesc(type, extra)
  local str = ""
  local oShow
  if extra[1] == "sys" then
    oShow = Localization:GetString("310002")
  else
    oShow = UIUtil.FormatAllianceAndName(nil, extra[2] or "", extra[1])
  end
  local tShow, team
  if type < DragonOperateLogType.GroupCancel then
    tShow = UIUtil.FormatAllianceAndName(nil, extra[4] or "", extra[3])
    team = toInt(extra[5]) == 2 and "B" or "A"
  end
  if type == DragonOperateLogType.PlayerRemove then
    str = Localization:GetString("Desert_strom_log_tips_1002", oShow, tShow, team)
  elseif type == DragonOperateLogType.PlayerGroupAdd1 then
    str = Localization:GetString("Desert_strom_log_tips_1004", oShow, tShow, team)
  elseif type == DragonOperateLogType.PlayerGroupAdd2 then
    str = Localization:GetString("Desert_strom_log_tips_1003", oShow, tShow, team)
  elseif type == DragonOperateLogType.CommanderAdd then
    str = Localization:GetString("Desert_strom_log_tips_1005", oShow, tShow, team)
  elseif type == DragonOperateLogType.CommanderRemove then
    str = Localization:GetString("Desert_strom_log_tips_1006", oShow, tShow, team)
  elseif type == DragonOperateLogType.GroupCancel then
    str = Localization:GetString("Desert_strom_log_tips_1007", oShow)
  elseif type == DragonOperateLogType.GroupOpen then
    str = Localization:GetString("Desert_strom_log_tips_1008", oShow)
  elseif type == DragonOperateLogType.ChangeTime then
    team = toInt(extra[3]) == 2 and "B" or "A"
    local startTime = toInt(extra[4])
    local endTime = toInt(extra[5])
    local startTimeStr = UITimeManager:GetInstance():TimeStampToTimeForServer(startTime, true)
    local endTimeStr = UITimeManager:GetInstance():TimeStampToTimeForServer(endTime, true)
    local time = startTimeStr .. " ~ " .. endTimeStr
    str = Localization:GetString("Desert_strom_log_tips_1010", oShow, team, time)
  end
  self.txt_des:SetText(str)
end

return UIDesertOperateLogItem
