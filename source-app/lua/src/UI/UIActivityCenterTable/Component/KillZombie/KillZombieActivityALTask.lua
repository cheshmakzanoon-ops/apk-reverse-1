local base = UIBaseContainer
local KillZombieActivityALTask = BaseClass("KillZombieActivityALTask", base)
local Localization = CS.GameEntry.Localization
local level_info_lv_path = "info/level_info_lv"
local level_info_title_path = "info/level_info_title"
local slider_path = "Slider"
local slider_value_path = "Slider/SliderValue"

function KillZombieActivityALTask:OnCreate()
  base.OnCreate(self)
  self.level_info_lv = self:AddComponent(UIText, level_info_lv_path)
  self.level_info_title = self:AddComponent(UIText, level_info_title_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider_value = self:AddComponent(UIText, slider_value_path)
end

function KillZombieActivityALTask:SetData(data)
  self.theData = data
end

function KillZombieActivityALTask:ReInit(difficulty)
  local kill_zombie_data = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_AL_INFO)
  local dataList = DataCenter.ActivityKillZombieManager:GetListByType(2)
  if dataList == nil or kill_zombie_data == nil then
    self.level_info_lv:SetText("")
    self.level_info_title:SetText("")
    self.slider:SetActive(false)
    return
  end
  self.difficulty = difficulty
  local dataServer = kill_zombie_data[tostring(difficulty)]
  local data = dataList.data[difficulty]
  if data == nil then
    data = dataList.data[1]
  end
  local monster = data.firstMonster
  if difficulty == 0 or dataServer == nil or monster == nil or dataServer.monster == nil then
    self.level_info_lv:SetText("")
    self.level_info_title:SetText("")
    self.slider:SetActive(false)
  else
    local monster_status = dataServer.monster
    self.slider:SetActive(true)
    self.level_info_lv:SetLocalText("all_level_limit_4", monster.level)
    self.level_info_title:SetText(Localization:GetString(monster.name))
    if monster_status == nil then
      self.slider_value:SetText("0")
      self.slider:SetValue(0)
    else
      local value = monster_status.curCount / monster_status.maxCount
      self.slider_value:SetText(string.format("%s/%s", monster_status.curCount, monster_status.maxCount))
      self.slider:SetValue(value * 100)
    end
  end
end

function KillZombieActivityALTask:OnDestroy()
  self.level_info_lv = nil
  self.level_info_title = nil
  self.level_info_desc = nil
  self.level_info_finish = nil
  self.level_btn_go = nil
  self.text = nil
  self.icon = nil
  base.OnDestroy(self)
end

return KillZombieActivityALTask
