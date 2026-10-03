local base = UIBaseContainer
local KillZombieActivityPersonTask = BaseClass("KillZombieActivityPersonTask", base)
local Localization = CS.GameEntry.Localization
local level_info_lv_path = "level_info/level_info_lv"
local level_info_title_path = "level_info/level_info_title"
local level_info_desc_path = "level_info/level_info_desc"
local level_info_finish_path = "level_info/level_info_finish"
local level_btn_go_path = "level_info/LevelBtnGo"
local text_path = "level_info/LevelBtnGo/text"
local go_text_path = "level_info/LevelBtnGo/GoText"

function KillZombieActivityPersonTask:OnCreate()
  base.OnCreate(self)
  self.level_info_lv = self:AddComponent(UIText, level_info_lv_path)
  self.level_info_title = self:AddComponent(UIText, level_info_title_path)
  self.level_info_desc = self:AddComponent(UIText, level_info_desc_path)
  self.level_info_finish = self:AddComponent(UIText, level_info_finish_path)
  self.level_btn_go = self:AddComponent(UIButton, level_btn_go_path)
  self.text = self:AddComponent(UIText, text_path)
  self.go_text = self:AddComponent(UIText, go_text_path)
  self.go_text:SetLocalText("2010209")
  self.level_info_finish:SetLocalText("2010216")
  self.level_btn_go:SetOnClick(function()
    self:OnChallengeClick()
  end)
  self.level_btn_go:SetActive(false)
  self.level_info_finish:SetActive(false)
end

local function ProtectCall(fun, ...)
  local ok, msg = xpcall(fun, debug.traceback, ...)
  if not ok then
    Logger.LogError(msg)
  end
end

local function LogErrorInfo(monsterId, kill_zombie_difficulty_select, serverSelectLevel, kill_zombie_difficulty_level)
  local tMonsterId = monsterId == nil and -1 or monsterId
  local tableName = LuaEntry.Player:GetABTestTableName(TableName.Monster)
  local oneTemplate = LocalController:instance():getLine(tableName, monsterId)
  local name = oneTemplate ~= nil and oneTemplate.name or "Template NULL"
  if name == nil then
    name = "Name NULL"
  end
  Logger.LogError("Check Error KillZombieActPersonalTask, kill_zombie_difficulty_select : " .. kill_zombie_difficulty_select .. ",serverSelectLevel :" .. serverSelectLevel .. ",kill_zombie_difficulty_level:" .. kill_zombie_difficulty_level .. ",monsterId:" .. tMonsterId .. ",tableName :" .. tableName .. ",name:" .. name)
end

function KillZombieActivityPersonTask:SetData(data)
  self.theData = data
  self:UpdateData()
end

function KillZombieActivityPersonTask:UpdateData()
  if self.level_btn_go == nil then
    return
  end
  local dataList = DataCenter.ActivityKillZombieManager:GetListByType(1)
  local kill_zombie_data = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_PLAYER_INFO)
  local kill_zombie_difficulty_level = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_LEVEL, 0)
  local kill_zombie_difficulty_select = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, 0)
  if kill_zombie_data and kill_zombie_data.finish == 1 then
    self.level_btn_go:SetActive(false)
    self.level_info_finish:SetActive(true)
  else
    self.level_btn_go:SetActive(kill_zombie_difficulty_select and kill_zombie_difficulty_select ~= 0)
    self.level_info_finish:SetActive(false)
  end
  if kill_zombie_difficulty_select < dataList.min then
    kill_zombie_difficulty_select = dataList.min
  elseif kill_zombie_difficulty_select > dataList.max then
    kill_zombie_difficulty_select = dataList.max
  end
  local serverSelectLevel = kill_zombie_difficulty_level
  if kill_zombie_difficulty_level == 0 then
    kill_zombie_difficulty_level = 1
  end
  local monsterId = dataList.data[kill_zombie_difficulty_select].monsterList[kill_zombie_difficulty_level]
  local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
  if not monster then
    ProtectCall(LogErrorInfo, monsterId, kill_zombie_difficulty_select, serverSelectLevel, kill_zombie_difficulty_level)
  end
  local monsterName = Localization:GetString(monster.name)
  self.level_info_lv:SetLocalText("all_level_limit_4", kill_zombie_difficulty_level)
  self.level_info_title:SetText(monsterName)
  self.level_info_desc:SetLocalText(300644, string.GetFormattedSeperatorNum(monster.recommend_power))
end

function KillZombieActivityPersonTask:OnChallengeClick()
  local kill_zombie_data = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_PLAYER_INFO)
  if kill_zombie_data and kill_zombie_data.finish == 1 then
    UIUtil.ShowTipsId("2010216")
    return
  end
  DataCenter.ActivityKillZombieManager:JumpToPersonMonster()
end

function KillZombieActivityPersonTask:OnDestroy()
  self.level_info_lv = nil
  self.level_info_title = nil
  self.level_info_desc = nil
  self.level_info_finish = nil
  self.level_btn_go = nil
  self.text = nil
  base.OnDestroy(self)
end

function KillZombieActivityPersonTask:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.UpdateData)
end

function KillZombieActivityPersonTask:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.UpdateData)
  base.OnRemoveListener(self)
end

return KillZombieActivityPersonTask
