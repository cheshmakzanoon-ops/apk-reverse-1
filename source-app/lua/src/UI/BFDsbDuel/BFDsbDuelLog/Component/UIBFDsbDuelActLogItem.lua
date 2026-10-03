local UIBFDsbDuelActLogItem = BaseClass("UIBFDsbDuelActLogItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_team_path = "Icon/TeamIcon"
local icon_type_path = "Icon/TypeIcon"
local txt_time_path = "Txt_Time"
local txt_des_path = "Txt_Des"
local IMG_TEAM_A = "lrb_shamofengbao_A"
local IMG_TEAM_B = "lrb_shamofengbao_B"
local IMG_TYPE_OUT = "zyf_caozuojilu_likai"
local IMG_TYPE_MAIN = "zyf_caozuojilu_jinru"
local IMG_TYPE_SUB = "zyf_caozuojilu_tibu"
local IMG_TYPE_CMD_OUT = "zyf_caozuojilu_quxiao"
local IMG_TYPE_GOU = "zyf_caozuojilu_fangqi2"
local IMG_TYPE_CHA = "zyf_caozuojilu_fangqi"
local IMG_LORD = "cfm_huodong_shamofengbao_lishi_tubiao_2"
local IMG_FARM = "cfm_huodong_shamofengbao_lishi_tubiao_1"

function UIBFDsbDuelActLogItem:OnCreate()
  base.OnCreate(self)
  self.icon_team = self:AddComponent(UIImage, icon_team_path)
  self.icon_type = self:AddComponent(UIImage, icon_type_path)
  self.txt_time = self:AddComponent(UIText, txt_time_path)
  self.txt_des = self:AddComponent(UITextMeshProUGUIEx, txt_des_path)
end

function UIBFDsbDuelActLogItem:OnDestroy()
  self.icon_team = nil
  self.icon_type = nil
  self.txt_time = nil
  self.txt_des = nil
  base.OnDestroy(self)
end

function UIBFDsbDuelActLogItem:SetItem(logInfo)
  local type = logInfo ~= nil and logInfo.type or 0
  local params = logInfo ~= nil and logInfo.params or ""
  local extra = string.split(params, ",") or {}
  self:LoadIcon(type, extra)
  self:SetDesc(type, extra)
  local time = logInfo ~= nil and logInfo.time or 0
  self.txt_time:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(time * 1000))
end

function UIBFDsbDuelActLogItem:LoadIcon(type, extra)
  local teamPath, typePath, aFlag
  if type < BattlefieldDsbConst.BF_DSB_OPERATE_LOG_TYPE.GroupBCancel then
    teamPath = toInt(extra[5]) == 2 and IMG_TEAM_B or IMG_TEAM_A
  else
    teamPath = toInt(extra[3]) == 2 and IMG_TEAM_B or IMG_TEAM_A
  end
  self.icon_team:LoadSpriteAsyncWithCallback(string.format(LoadPath.LWBattleFieldDsbDuelPath, teamPath), function()
    if self.icon_team then
      self.icon_team:SetNativeSize()
    end
  end)
  if type == BattlefieldDsbConst.BF_DSB_OPERATE_LOG_TYPE.PlayerRemove then
    typePath = IMG_TYPE_OUT
  elseif type == BattlefieldDsbConst.BF_DSB_OPERATE_LOG_TYPE.PlayerGroupAddMain then
    typePath = IMG_TYPE_MAIN
  elseif type == BattlefieldDsbConst.BF_DSB_OPERATE_LOG_TYPE.PlayerGroupAddSub then
    typePath = IMG_TYPE_SUB
  elseif type == BattlefieldDsbConst.BF_DSB_OPERATE_LOG_TYPE.GroupBCancel then
    typePath = IMG_TYPE_CHA
  elseif type == BattlefieldDsbConst.BF_DSB_OPERATE_LOG_TYPE.GroupBOpen then
    typePath = IMG_TYPE_GOU
  end
  if typePath then
    self.icon_type:LoadSpriteAsyncWithCallback(string.format(LoadPath.LWBattleFieldDsbDuelPath, typePath), function()
      if self.icon_type then
        self.icon_type:SetNativeSize()
      end
    end)
  end
end

function UIBFDsbDuelActLogItem:SetDesc(type, extra)
  local str = ""
  local oShow
  if extra[1] == "sys" then
    oShow = Localization:GetString("310002")
  else
    oShow = UIUtil.FormatAllianceAndName(nil, extra[2] or "", extra[1])
  end
  local tShow, team, role
  if type < BattlefieldDsbConst.BF_DSB_OPERATE_LOG_TYPE.GroupBCancel then
    tShow = UIUtil.FormatAllianceAndName(nil, extra[4] or "", extra[3])
    team = toInt(extra[5]) == 2 and Localization:GetString("YiBianJinQu_trivial_tips_6") or Localization:GetString("YiBianJinQu_trivial_tips_5")
  end
  if type == BattlefieldDsbConst.BF_DSB_OPERATE_LOG_TYPE.PlayerRemove then
    str = Localization:GetString("Desert_strom_log_tips_1002", oShow, tShow, team)
  elseif type == BattlefieldDsbConst.BF_DSB_OPERATE_LOG_TYPE.PlayerGroupAddMain then
    str = Localization:GetString("Desert_strom_log_tips_1004", oShow, tShow, team)
  elseif type == BattlefieldDsbConst.BF_DSB_OPERATE_LOG_TYPE.PlayerGroupAddSub then
    str = Localization:GetString("Desert_strom_log_tips_1003", oShow, tShow, team)
  elseif type == BattlefieldDsbConst.BF_DSB_OPERATE_LOG_TYPE.GroupBCancel then
    str = Localization:GetString("Desert_strom_log_tips_1007", oShow)
  elseif type == BattlefieldDsbConst.BF_DSB_OPERATE_LOG_TYPE.GroupBOpen then
    str = Localization:GetString("Desert_strom_log_tips_1008", oShow)
  end
  self.txt_des:SetText(str)
end

return UIBFDsbDuelActLogItem
