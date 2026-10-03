local base = UIBaseContainer
local LWSeasonBossLoginBossItem = BaseClass("LWSeasonBossLoginBossItem", base)
local txt_name_path = "InfoPanel/txt_name"
local sli_Slider_path = "InfoPanel/Slider"
local txt_max_hp_path = "InfoPanel/txt_max_hp"
local btn_btn_path = "btn"
local txt_progress_path = "InfoPanel/Slider/txt_progress"
local txt_btn_time_path = "btn/txt_btn_time"
local img_RedDot_path = "btn/RedDot"

function LWSeasonBossLoginBossItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.bossData = {}
  self.newBoss = nil
end

function LWSeasonBossLoginBossItem:OnDestroy()
  self.bossData = nil
  self.newBoss = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonBossLoginBossItem:ComponentDefine()
  self.txt_name = self:AddComponent(UIText, txt_name_path)
  self.sli_Slider = self:AddComponent(UISlider, sli_Slider_path)
  self.txt_max_hp = self:AddComponent(UIText, txt_max_hp_path)
  self.btn_btn = self:AddComponent(UIButton, btn_btn_path)
  self.txt_progress = self:AddComponent(UIText, txt_progress_path)
  self.txt_btn_time = self:AddComponent(UIText, txt_btn_time_path)
  self.img_RedDot = self:AddComponent(UIImage, img_RedDot_path)
  self.btn_btn:SetOnClick(BindCallback(self, self.ClickBtn))
end

function LWSeasonBossLoginBossItem:ComponentDestroy()
  self.txt_name = nil
  self.sli_Slider = nil
  self.txt_max_hp = nil
  self.btn_btn = nil
  self.txt_progress = nil
  self.txt_btn_time = nil
  self.img_RedDot = nil
end

function LWSeasonBossLoginBossItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonVirusBossAchievementRefresh, self.RefreshDamage)
end

function LWSeasonBossLoginBossItem:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SeasonVirusBossAchievementRefresh, self.RefreshDamage)
end

function LWSeasonBossLoginBossItem:SetData(newBoss, bossData, img_boss, go_weakPanel, parent)
  self.parent = parent
  self.bossData = bossData
  self.newBoss = newBoss
  local config = DataCenter.LWSeasonBossLoginDataManager:GetConfigData()
  local boss_pic = config:getValue("boss_pic")
  local imageList = string.split(boss_pic, "|")
  local weakState = bossData.monsterJson.state == 1
  if newBoss then
    imageList = string.split(imageList[2], ";")
    img_boss:LoadSprite(weakState and imageList[2] or imageList[1])
  else
    imageList = string.split(imageList[1], ";")
    img_boss:LoadSprite(weakState and imageList[2] or imageList[1])
  end
  img_boss:SetNativeSize()
  local boss_pic_coordinate = config:getValue("boss_pic_coordinate")
  if boss_pic_coordinate ~= nil then
    local imagePosList = string.split(boss_pic_coordinate, "|")
    if newBoss then
      boss_pic_coordinate = string.split(imagePosList[2], ";")
      boss_pic_coordinate = string.split(weakState and boss_pic_coordinate[2] or boss_pic_coordinate[1], ",")
      img_boss:SetAnchoredPositionXY(tonumber(boss_pic_coordinate[1]), tonumber(boss_pic_coordinate[2]), true)
    else
      boss_pic_coordinate = string.split(imagePosList[1], ";")
      boss_pic_coordinate = string.split(weakState and boss_pic_coordinate[2] or boss_pic_coordinate[1], ",")
      img_boss:SetAnchoredPositionXY(tonumber(boss_pic_coordinate[1]), tonumber(boss_pic_coordinate[2]), true)
    end
  end
  go_weakPanel:SetActive(weakState)
  local bossName = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), bossData.monsterId, "name")
  self.txt_name:SetLocalText(bossName)
  self.sli_Slider:SetValue(bossData.monsterJson.hp / bossData.monsterJson.initHp)
  local bossHpPre = bossData.monsterJson.hp / bossData.monsterJson.initHp * 100
  local simplifiedPercentage = string.format("%.1f", bossHpPre)
  simplifiedPercentage = string.format("%g", simplifiedPercentage)
  self.txt_progress:SetText(simplifiedPercentage .. "%")
  if newBoss then
    self.txt_max_hp:SetLocalText("activity_s1pre_boss_damage_limit_7", string.GetFormattedStr(DataCenter.LWSeasonBossLoginDataManager.todayMaxDamage or 0))
  else
    self.txt_max_hp:SetLocalText("activity_s1pre_boss_damage_limit_7", string.GetFormattedStr(DataCenter.ActBossDataManager.todayMaxDamage or 0))
  end
  self.img_RedDot:SetActive(DataCenter.LWSeasonBossLoginDataManager:GetReddotType2())
end

function LWSeasonBossLoginBossItem:RefreshDamage()
  if self.newBoss then
    self.txt_max_hp:SetLocalText("activity_s1pre_boss_damage_limit_7", string.GetFormattedStr(DataCenter.LWSeasonBossLoginDataManager.todayMaxDamage or 0))
  else
    self.txt_max_hp:SetLocalText("activity_s1pre_boss_damage_limit_7", string.GetFormattedStr(DataCenter.ActBossDataManager.todayMaxDamage or 0))
  end
end

function LWSeasonBossLoginBossItem:ClickBtn()
  if self.parent ~= nil then
    self.parent:ClickGoTo(self.bossData)
  end
end

return LWSeasonBossLoginBossItem
