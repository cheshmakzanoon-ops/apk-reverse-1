local LWOffSeason1MainItem = BaseClass("LWOffSeason1MainItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local lock_path = "Lock"
local info_btn_path = "Lock/InfoBtn"
local detail_btn_path = "Lock/DetailBtn"
local tips_path = "Lock/Tips"
local time_path = "Lock/TimeBg/Time"
local open_path = "Open"
local title_path = "Open/Title"
local tick_time_path = "Open/Tick/bg/TickTime"
local red_point_path = "RedPoint"
local red_num_path = "RedPoint/RedNum"

function LWOffSeason1MainItem:OnCreate()
  base.OnCreate(self)
  self.flash_effect = self:AddComponent(UIBaseContainer, "FlashEffect")
  self.breath_effect = self:AddComponent(UIBaseContainer, "BreathEffect")
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.red_num = self:AddComponent(UIText, red_num_path)
  self.btn = self:AddComponent(UIButton, "")
  self.img = self:AddComponent(UIRawImage, "")
  self.btn:SetOnClick(function()
    if self.activeNode == self.lockRoot then
      return
    end
    local titleTxt
    local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
    local data = DataCenter.SeasonTemplateManager:GetConfigData(seasonId)
    if data then
      local key = data.truce_name
      titleTxt = Localization:GetString(key)
    end
    if self.data.type == EnumActivity.ChampionDuelMain.Type then
      self:GoToChampionDuelMain()
    elseif self.data.type == EnumActivity.ActTrends.Type then
      UIManager:GetInstance():OpenWindow(UIWindowNames.SingleActivityContainerType2, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, self.data.id, nil)
    else
      SeasonUtil.OpenSeasonActivity(self.data, titleTxt)
    end
  end)
  self.lockRoot = self:AddComponent(UIBaseComponent, lock_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.detail_btn = self:AddComponent(UIButton, detail_btn_path)
  self.tips = self:AddComponent(UITextMeshProUGUIEx, tips_path)
  self.time = self:AddComponent(UITextMeshProUGUIEx, time_path)
  self.info_btn:SetOnClick(function()
    if self.activeNode ~= self.lockRoot or self.data == nil then
      return
    end
    if self.data.type == EnumActivity.ChampionDuelMain.Type then
      self:GoToChampionDuelInfo()
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonActivityDetail, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, self.data.id)
    end
  end)
  self.detail_btn:SetOnClick(function()
    if self.activeNode ~= self.lockRoot or self.data == nil or self.data.ppt_show == nil then
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorldTip, {anim = false}, self.data.ppt_show)
  end)
  self.detail_btn:SetActive(false)
  self.openRoot = self:AddComponent(UIBaseComponent, open_path)
  self.titleOpen = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.tick_time = self:AddComponent(UITextMeshProUGUIEx, tick_time_path)
  self.activeNode = self.lockRoot
  self.lockRoot:SetActive(true)
  self.openRoot:SetActive(false)
  self.red_num:SetText("")
  self.red_point:SetActive(false)
  self.flash_effect:SetActive(false)
  self.breath_effect:SetActive(false)
end

function LWOffSeason1MainItem:OnDestroy()
  base.OnDestroy(self)
  self.lockRoot:SetActive(false)
  self.openRoot:SetActive(false)
  self.red_point:SetActive(false)
  self.flash_effect:SetActive(false)
  self.breath_effect:SetActive(false)
  self.red_point = nil
  self.red_num = nil
  self.flash_effect = nil
  self.breath_effect = nil
  self.txt = nil
end

function LWOffSeason1MainItem:ReInit(data)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.data = data
  self.activeNode = nil
  if data and data.activityId then
    self.activityId = tostring(data.activityId)
  end
  if data and type(data.GetValidType) == "function" and data:GetValidType() == ActivityValidType.Now then
    self.activeNode = self.openRoot
    self.lockRoot:SetActive(false)
    self.openRoot:SetActive(true)
    self.titleOpen:SetLocalText(data.name)
    self.endTime = data.endTime
  else
    self.activeNode = self.lockRoot
    self.lockRoot:SetActive(true)
    self.openRoot:SetActive(false)
    self.tips:SetLocalText(data.name)
    self.endTime = data.startTime
  end
  if data and data.activityId then
    local list = DataCenter.ActivityListDataManager:GetItemActivityData()
    if list and list[data.activityId] then
      if list[data.activityId] == "0" then
        self.endTime = UITimeManager:GetInstance():GetTomorrowZero()
      else
        self.txt = Localization:GetString(list[data.activityId])
        self.endTime = -1
      end
    end
  end
  local seasonIconPath = SeasonUtil.GetSeasonShowIconPath(data)
  if seasonIconPath then
    if CS.GameEntry.Resource:HasAsset(seasonIconPath) then
      self.img:LoadSpriteAuto(seasonIconPath)
    else
      Logger.LogError(seasonIconPath)
    end
  end
  self:Update1000MS()
  self:SetRedPoint()
end

function LWOffSeason1MainItem:Update1000MS()
  if self.endTime ~= nil and self.activeNode ~= nil then
    local time_txt
    if self.activeNode == self.lockRoot then
      time_txt = self.time
    elseif self.activeNode == self.openRoot then
      time_txt = self.tick_time
    end
    if time_txt ~= nil then
      if self.endTime == -1 then
        time_txt:SetText(self.txt)
        return
      end
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local remainTime = self.endTime - curTime
      if 0 < remainTime then
        time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
      else
        time_txt:SetText("00:00:00")
      end
    end
  end
end

function LWOffSeason1MainItem:OnEnable()
  base.OnEnable(self)
  self:SetRedPoint()
end

function LWOffSeason1MainItem:OnDisable()
  base.OnDisable(self)
end

function LWOffSeason1MainItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.SetRedPoint)
end

function LWOffSeason1MainItem:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.SetRedPoint)
  base.OnRemoveListener(self)
end

function LWOffSeason1MainItem:SetRedPoint()
  local redNum = DataCenter.ActivityListDataManager:GetActivityRedDotCount(self.activityId)
  if self.data and self.data.type == EnumActivity.ActMigration.Type then
    self.red_num:SetText("")
  else
    self.red_num:SetText(redNum)
  end
  self.red_point:SetActive(0 < redNum)
end

function LWOffSeason1MainItem:GoToChampionDuelMain()
  if self.lockRoot:GetActive() then
    UIUtil.ShowTipsId("champion_duel_tips1053")
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelMain, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  }, self.data)
end

function LWOffSeason1MainItem:GoToChampionDuelInfo()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelDetail, {anim = true}, 0, self.data.startTime / 1000)
end

return LWOffSeason1MainItem
