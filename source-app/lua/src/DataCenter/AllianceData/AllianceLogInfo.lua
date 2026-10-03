local AllianceLogInfo = BaseClass("AllianceLogInfo")
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")

local function __init(self)
  self.uuid = ""
  self.type = 0
  self.code = ""
  self.time = 0
  self.params = {}
  self.trans = {}
  self.sign = 0
  self.pos = nil
  self.icon = ""
  self.color = ""
end

local function __delete(self)
  self.uuid = nil
  self.type = nil
  self.code = nil
  self.time = nil
  self.params = nil
  self.trans = nil
  self.sign = nil
  self.pos = nil
  self.icon = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.type ~= nil then
    self.type = message.type
    if message.type <= 9 then
      self.sign = 1
    elseif message.type > 9 then
      self.sign = 2
    end
  end
  if message.time ~= nil then
    self.time = message.time
  end
  if message.params ~= nil then
    self.params = message.params
  end
  if message.trans ~= nil then
    self.trans = message.trans
  end
  local cfg = LocalController:instance():getLine(TableName.LW_AllianceRecord, self.type)
  if cfg then
    self.icon = cfg.icon
    self.color = cfg.color
    self.code = cfg.dialogId
  end
end

local function GetStrLog(self, isIgnore)
  if next(self.params) then
    local template = self:AnalyseParam(isIgnore)
    self:DealRemarkName(template)
    return Localization:GetString(self.code, table.unpack(template))
  end
  return Localization:GetString(self.code)
end

function AllianceLogInfo:DealRemarkName(template)
  if (self.code == "455064" or self.code == "455065" or self.code == "455072" or self.code == "455073") and self.params[7] and self.params[8] then
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.params[7], template[2])
    template[2] = showName
    showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.params[8], template[4])
    template[4] = showName
  end
end

local function AnalyseParam(self, isIgnore)
  local param = {}
  local disguised = false
  if #self.params >= 6 then
    local t = self.params[6]
    disguised = toInt(t) == 1
  end
  for i = 1, #self.params do
    if self.trans[i] == 0 then
      param[i] = self.params[i]
    elseif self.trans[i] == 1 then
      param[i] = Localization:GetString(self.params[i])
    elseif self.trans[i] == 2 then
      local pos = SceneUtils.IndexToTilePos(tonumber(self.params[i]), ForceChangeScene.World)
      if isIgnore then
        param[i] = Localization:GetString(GameDialogDefine.SHOW_POS, pos.x, pos.y)
      else
        param[i] = "<u>" .. Localization:GetString(GameDialogDefine.SHOW_POS, pos.x, pos.y) .. "</u>"
      end
      self.pos = tonumber(self.params[i])
    elseif self.trans[i] == 3 then
      if not string.IsNullOrEmpty(self.params[i]) then
        param[i] = "[" .. self.params[i] .. "]"
      else
        param[i] = self.params[i] or ""
      end
    elseif self.trans[i] == 4 then
      if not string.IsNullOrEmpty(self.params[i]) then
        param[i] = UITimeManager:GetInstance():TimeStampToTimeForServer(self.params[i])
      else
        param[i] = self.params[i] or ""
      end
    elseif self.trans[i] == 5 then
      local serverId, pointId = string.split_ii(self.params[i], "|")
      param[i] = UIUtil.MakeJumpLink(pointId, serverId, 0)
    end
    if i == 2 and disguised then
      param[i] = Localization:GetString("season_mastery_173")
    end
  end
  return param
end

local function GetLogSignIconPath(self)
  if self.sign == 1 then
    return string.format(LoadPath.UIAlliance, "UIAlliance_img_title_member")
  elseif self.sign == 2 then
    return string.format(LoadPath.UIAlliance, "UIAlliance_img_title_battle")
  end
end

local function GetPos(self)
  return self.pos
end

AllianceLogInfo.__init = __init
AllianceLogInfo.__delete = __delete
AllianceLogInfo.ParseData = ParseData
AllianceLogInfo.GetStrLog = GetStrLog
AllianceLogInfo.AnalyseParam = AnalyseParam
AllianceLogInfo.GetLogSignIconPath = GetLogSignIconPath
AllianceLogInfo.GetPos = GetPos
return AllianceLogInfo
