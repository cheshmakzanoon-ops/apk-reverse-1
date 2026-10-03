local UIActEpidemicOperateLogItem = BaseClass("UIActEpidemicOperateLogItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_team_path = "Icon/TeamIcon"
local icon_type_path = "Icon/TypeIcon"
local txt_time_path = "Txt_Time"
local txt_des_path = "Txt_Des"
local IMG_TEAM_A = "lrb_shamofengbao_A"
local IMG_TEAM_B = "lrb_shamofengbao_B"
local IMG_TYPE_OUT = "zyf_caozuojilu_likai"
local IMG_TYPE_CMD = "zyf_caozuojilu_zhihui"
local IMG_TYPE_MAIN = "zyf_caozuojilu_jinru"
local IMG_TYPE_SUB = "zyf_caozuojilu_tibu"
local IMG_TYPE_CMD_OUT = "zyf_caozuojilu_quxiao"
local IMG_TYPE_GOU = "zyf_caozuojilu_fangqi2"
local IMG_TYPE_CHA = "zyf_caozuojilu_fangqi"
local IMG_TYPE_TIME = "zyf_caozuojilu_shijian"
local IMG_LORD = "cfm_huodong_shamofengbao_lishi_tubiao_2"
local IMG_FARM = "cfm_huodong_shamofengbao_lishi_tubiao_1"

function UIActEpidemicOperateLogItem:OnCreate()
  base.OnCreate(self)
  self.icon_team = self:AddComponent(UIImage, icon_team_path)
  self.icon_type = self:AddComponent(UIImage, icon_type_path)
  self.txt_time = self:AddComponent(UIText, txt_time_path)
  self.txt_des = self:AddComponent(UITextMeshProUGUIEx, txt_des_path)
end

function UIActEpidemicOperateLogItem:OnDestroy()
  self.bg_icon = nil
  self.txt_time = nil
  self.txt_des = nil
  base.OnDestroy(self)
end

function UIActEpidemicOperateLogItem:SetItem(logInfo)
  local type = logInfo ~= nil and logInfo.type or 0
  local params = logInfo ~= nil and logInfo.params or ""
  local extra = string.split(params, ",") or {}
  self:LoadIcon(type, extra)
  self:SetDesc(type, extra)
  local time = logInfo ~= nil and logInfo.time or 0
  self.txt_time:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(time * 1000))
end

function UIActEpidemicOperateLogItem:LoadIcon(type, extra)
  local teamPath, typePath
  if type == EpidemicOperateLogType.ArbiterAdd or type == EpidemicOperateLogType.ArbiterRemove then
    teamPath = toInt(extra[3]) == 2 and IMG_TEAM_B or IMG_TEAM_A
  elseif type < EpidemicOperateLogType.GroupCancel or type == EpidemicOperateLogType.CommanderAdd or type == EpidemicOperateLogType.CommanderRemove then
    teamPath = toInt(extra[5]) == 2 and IMG_TEAM_B or IMG_TEAM_A
  elseif type == EpidemicOperateLogType.ChangeRole or type == EpidemicOperateLogType.ChangeTime then
    teamPath = toInt(extra[3]) == 2 and IMG_TEAM_B or IMG_TEAM_A
  elseif type == EpidemicOperateLogType.GroupOpen or type == EpidemicOperateLogType.GroupCancel then
    teamPath = IMG_TEAM_B
  end
  if not string.IsNullOrEmpty(teamPath) then
    self.icon_team:LoadSprite(string.format(LoadPath.LWBattleFieldEpidemicPath, teamPath))
    self.icon_team:SetNativeSize()
  end
  if type == EpidemicOperateLogType.PlayerRemove then
    typePath = IMG_TYPE_OUT
  elseif type == EpidemicOperateLogType.PlayerGroupAdd1 then
    typePath = IMG_TYPE_MAIN
  elseif type == EpidemicOperateLogType.PlayerGroupAdd2 then
    typePath = IMG_TYPE_SUB
  elseif type == EpidemicOperateLogType.ArbiterAdd then
    typePath = IMG_TYPE_CMD
  elseif type == EpidemicOperateLogType.ArbiterRemove then
    typePath = IMG_TYPE_CMD_OUT
  elseif type == EpidemicOperateLogType.GroupCancel then
    typePath = IMG_TYPE_CHA
  elseif type == EpidemicOperateLogType.GroupOpen then
    typePath = IMG_TYPE_GOU
  elseif type == EpidemicOperateLogType.ChangeRole then
    typePath = toInt(extra[4]) == 1 and IMG_LORD or IMG_FARM
  elseif type == EpidemicOperateLogType.ChangeTime then
    typePath = IMG_TYPE_TIME
  elseif type == EpidemicOperateLogType.CommanderAdd then
    typePath = IMG_TYPE_CMD
  elseif type == EpidemicOperateLogType.CommanderRemove then
    typePath = IMG_TYPE_CMD_OUT
  end
  self.icon_type:LoadSprite(string.format(LoadPath.LWBattleFieldEpidemicPath, typePath))
  self.icon_type:SetNativeSize()
end

function UIActEpidemicOperateLogItem:SetDesc(type, extra)
  local str = ""
  local oShow
  if extra[1] == "sys" then
    oShow = Localization:GetString("310002")
  else
    oShow = UIUtil.FormatAllianceAndName(nil, extra[2] or "", extra[1])
  end
  local tShow, team, role
  if type == EpidemicOperateLogType.ArbiterAdd or type == EpidemicOperateLogType.ArbiterRemove then
    tShow = extra[4] or ""
    team = toInt(extra[3]) == 2 and Localization:GetString("YiBianJinQu_trivial_tips_6") or Localization:GetString("YiBianJinQu_trivial_tips_5")
  elseif type < EpidemicOperateLogType.GroupCancel or type == EpidemicOperateLogType.CommanderAdd or type == EpidemicOperateLogType.CommanderRemove then
    tShow = UIUtil.FormatAllianceAndName(nil, extra[4] or "", extra[3])
    team = toInt(extra[5]) == 2 and Localization:GetString("YiBianJinQu_trivial_tips_6") or Localization:GetString("YiBianJinQu_trivial_tips_5")
  end
  if type == EpidemicOperateLogType.PlayerRemove then
    str = Localization:GetString("Desert_strom_log_tips_1002", oShow, tShow, team)
  elseif type == EpidemicOperateLogType.PlayerGroupAdd1 then
    str = Localization:GetString("Desert_strom_log_tips_1004", oShow, tShow, team)
  elseif type == EpidemicOperateLogType.PlayerGroupAdd2 then
    str = Localization:GetString("Desert_strom_log_tips_1003", oShow, tShow, team)
  elseif type == EpidemicOperateLogType.ArbiterAdd then
    str = Localization:GetString("YiBianJinQu_trivial_tips_22", oShow, tShow, team)
  elseif type == EpidemicOperateLogType.ArbiterRemove then
    str = Localization:GetString("Desert_strom_log_tips_1006", oShow, tShow, team)
  elseif type == EpidemicOperateLogType.GroupCancel then
    str = Localization:GetString("Desert_strom_log_tips_1007", oShow)
  elseif type == EpidemicOperateLogType.GroupOpen then
    str = Localization:GetString("Desert_strom_log_tips_1008", oShow)
  elseif type == EpidemicOperateLogType.ChangeRole then
    tShow = UIUtil.FormatAllianceAndName(nil, extra[4] or "", extra[3])
    team = toInt(extra[3]) == 2 and Localization:GetString("YiBianJinQu_trivial_tips_6") or Localization:GetString("YiBianJinQu_trivial_tips_5")
    role = toInt(extra[4]) == 2 and ActEpidemicUtils.GetRoleNameByRoleId(EpidemicZoneRole.Farmer) or ActEpidemicUtils.GetRoleNameByRoleId(EpidemicZoneRole.Lord)
    str = Localization:GetString("YiBianJinQu_trivial_tips_23", team, role)
  elseif type == EpidemicOperateLogType.ChangeTime then
    team = toInt(extra[3]) == 2 and "B" or "A"
    local startTime = toInt(extra[4])
    local endTime = toInt(extra[5])
    local startTimeStr = UITimeManager:GetInstance():TimeStampToTimeForServer(startTime, true)
    local endTimeStr = UITimeManager:GetInstance():TimeStampToTimeForServer(endTime, true)
    local time = startTimeStr .. " ~ " .. endTimeStr
    str = Localization:GetString("Desert_strom_log_tips_1010", oShow, team, time)
  elseif type == EpidemicOperateLogType.CommanderAdd then
    str = Localization:GetString("Desert_strom_log_tips_1005", oShow, tShow, team)
  elseif type == EpidemicOperateLogType.CommanderRemove then
    str = Localization:GetString("Desert_strom_log_tips_1006", oShow, tShow, team)
  end
  self.txt_des:SetText(str)
end

return UIActEpidemicOperateLogItem
