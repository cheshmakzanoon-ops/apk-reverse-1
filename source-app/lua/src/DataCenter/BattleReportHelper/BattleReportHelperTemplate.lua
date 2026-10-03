local BattleReportHelperTemplate = BaseClass("BattleReportHelperTemplate")
local Localization = CS.GameEntry.Localization
local loadstring = loadstring or load

local function __init(self)
  self.id = 0
  self.score_func = ""
  self.report_key = ""
  self.type = 0
  self.mode_type = 0
  self.cate = 0
  self.typePara = {}
  self.dialog_1 = ""
  self.dialog_2 = ""
  self.dialog_3 = ""
  self.dialog_4 = ""
  self.dialog_5 = ""
end

local function __delete(self)
  self.id = nil
  self.score_func = nil
  self.report_key = nil
  self.type = nil
  self.mode_type = nil
  self.cate = nil
  self.typePara = nil
  self.dialog_1 = nil
  self.dialog_2 = nil
  self.dialog_3 = nil
  self.dialog_4 = nil
  self.dialog_5 = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.score_func = row:getValue("score_func") or ""
  self.report_key = row:getValue("report_key") or ""
  self.type = tonumber(row:getValue("type")) or 0
  self.mode_type = tonumber(row:getValue("mode_type")) or 0
  self.cate = tonumber(row:getValue("cate")) or 0
  self.typePara = row:getValue("typePara") or {}
  self.dialog_1 = row:getValue("dialog_1") or ""
  self.dialog_2 = row:getValue("dialog_2") or ""
  self.dialog_3 = row:getValue("dialog_3") or ""
  self.dialog_4 = row:getValue("dialog_4") or ""
  self.dialog_5 = row:getValue("dialog_5") or ""
end

BattleReportHelperTemplate.__init = __init
BattleReportHelperTemplate.__delete = __delete
BattleReportHelperTemplate.InitData = InitData
return BattleReportHelperTemplate
