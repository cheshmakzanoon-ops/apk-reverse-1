local QuestTemplate = BaseClass("QuestTemplate")
local Localization = CS.GameEntry.Localization
local PveShowType = {MainCityLv = 1}

local function __init(self)
  self.id = 0
  self.name = ""
  self.desc = ""
  self.gotype2 = QuestGoType.None
  self.gopara = {}
  self.desctype = QuestDescType.Normal
  self.para1 = 0
  self.para2 = 0
  self.para3 = 0
  self.type = QuestType.Main
  self.order = 0
  self.position = 0
  self.icon = ""
  self.mainshow = ""
  self.autoreward = 0
  self.list = ""
  self.progressshow = ""
  self.autoopen = 0
  self.guidShow = 0
  self.listType = 0
  self.bubble = 0
  self.questPre = ""
  self.pve_show = ""
  self.guide_complete = ""
  self.bp_score = 0
  self.seasonTask = false
  self.seaconConditionMin = nil
  self.seaconConditionMax = nil
end

local function __delete(self)
  self.id = nil
  self.name = nil
  self.desc = nil
  self.type2 = nil
  self.gotype2 = nil
  self.gopara = nil
  self.desctype = nil
  self.para1 = nil
  self.para2 = nil
  self.para3 = nil
  self.type = nil
  self.order = nil
  self.position = nil
  self.icon = nil
  self.mainshow = nil
  self.autoreward = nil
  self.list = nil
  self.progressshow = nil
  self.autoopen = nil
  self.guidShow = nil
  self.listType = nil
  self.bubble = nil
  self.questPre = nil
  self.pve_show = nil
  self.guide_complete = nil
  self.bp_score = nil
  self.seasonTask = nil
  self.seaconConditionMin = nil
  self.seaconConditionMax = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.name = row:getValue("name", "")
  self.desc = row:getValue("desc", "")
  self.type2 = tonumber(row:getValue("type2"))
  self.gotype2 = row:getValue("gotype2")
  self.gopara = row:getValue("gopara")
  self.desctype = row:getValue("desctype")
  local param = row:getValue("para1")
  self.para1 = tonumber(param[1])
  self.para2 = row:getValue("para2")
  self.para3 = row:getValue("para3")
  self.type = row:getIntValue("type")
  self.type2 = row:getIntValue("type2")
  self.order = row:getIntValue("order")
  self.position = row:getValue("position")
  self.icon = row:getValue("icon", "")
  self.banner = row:getValue("banner", "")
  self.accept1 = row:getValue("accept1")
  self.accept2 = row:getValue("accept2")
  self.mainshow = row:getValue("mainshow", "")
  self.autoreward = row:getValue("autoreward")
  self.list = row:getValue("list")
  self.progressshow = row:getValue("progressshow")
  self.autoopen = tonumber(row:getValue("autoopen"))
  self.listType = tonumber(row:getValue("listType"))
  local bubble = row:getValue("bubble")
  self.bubble = bubble == "" and 0 or tonumber(bubble)
  self.questPre = row:getValue("quest_pre", "")
  self.preTaskId = row:getValue("pre", "")
  self.pve_show = row:getValue("pveshow", "")
  self.guide_complete = row:getValue("guide_complete", "")
  self.bp_score = row:getValue("bp_score") or {}
  local season = row:getValue("season") or nil
  if string.IsNullOrEmpty(season) then
    self.seasonTask = false
  else
    local condition = string.split(season, "-")
    if #condition == 2 then
      self.seasonTask = true
      self.seaconConditionMin = tonumber(condition[1])
      self.seaconConditionMax = tonumber(condition[2])
    end
  end
  local quest_show = row:getValue("quest_show")
  if quest_show ~= nil and quest_show ~= "" then
    self.taskHowToPlayId, self.taskFinishBtnTxt = string.match(quest_show, "([^;]+);([^;]+)")
  end
end

local function GetDesc(self, isChatView)
  return QuestUtil.GetQuestDesc(self, isChatView)
end

local function SetGuidShow(self, state)
  if state then
    self.guidShow = 0
  else
    self.guidShow = 1
  end
end

local function GetGuidShow(self)
  return self.guidShow
end

local function UnpackPveShow(self)
  if self.pve_show == "" then
    return true
  end
  local str = string.split(self.pve_show, ";")
  if tonumber(str[1]) == PveShowType.MainCityLv and DataCenter.BuildManager.MainLv >= tonumber(str[2]) then
    return true
  end
  return false
end

local function CheckSeason(self, curSeason)
  if self.seasonTask then
    if curSeason >= self.seaconConditionMin and curSeason <= self.seaconConditionMax then
      return self.type2 ~= 517
    else
      return false
    end
  else
    return true
  end
end

function QuestTemplate:GetPreQuestId()
  if not string.IsNullOrEmpty(self.questPre) then
    return self.questPre
  end
  if not string.IsNullOrEmpty(self.preTaskId) then
    return self.preTaskId
  end
  return nil
end

function QuestTemplate:GetIconPath()
  if string.IsNullOrEmpty(self.icon) then
    return ""
  end
  if string.sub(self.icon, 1, 7) == "Assets/" then
    return self.icon
  end
  return string.format(LoadPath.UIMainQuest, self.icon)
end

QuestTemplate.__init = __init
QuestTemplate.__delete = __delete
QuestTemplate.InitData = InitData
QuestTemplate.GetDesc = GetDesc
QuestTemplate.SetGuidShow = SetGuidShow
QuestTemplate.GetGuidShow = GetGuidShow
QuestTemplate.UnpackPveShow = UnpackPveShow
QuestTemplate.CheckSeason = CheckSeason
return QuestTemplate
