local UIOffSeasonBtn = BaseClass("UIOffSeasonBtn", UIAsyncContainer)
local base = UIAsyncContainer
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization
local LanguageType = CS.GameFramework.Localization.Language
local bg_path = "Bg"
local btn_text_path = "BtnText"
local red_point_num_path = "RedPointNum"
local text_path = "RedPointNum/Text"

function UIOffSeasonBtn:UpdateData()
  self:RefreshShowState()
end

function UIOffSeasonBtn:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:AddUIListener(EventId.RefreshActivityRedDot, self.OnRedPointRefresh)
end

function UIOffSeasonBtn:OnDestroy()
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.OnRedPointRefresh)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIOffSeasonBtn:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.btn_text = self:AddComponent(UIText, btn_text_path)
  self.red_point_num = self:AddComponent(UIBaseContainer, red_point_num_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function UIOffSeasonBtn:ComponentDestroy()
  self.bg = nil
  self.btn_text = nil
  self.red_point_num = nil
  self.text = nil
  self.btn = nil
end

function UIOffSeasonBtn:DataDefine()
  self.nextTryRefreshTime = -1
  self.isShow = false
end

function UIOffSeasonBtn:DataDestroy()
  self.nextTryRefreshTime = nil
  self.isShow = nil
end

function UIOffSeasonBtn:RefreshShowState(flag)
  if not self:AsyncLoadDone() then
    return
  end
  self.nextTryRefreshTime = -1
  self.isShow = false
  local mainLv = DataCenter.BuildManager.MainLv
  if mainLv and mainLv >= SEASON_MIN_LEVEL then
    local seasonBtnShowFlag = flag or SeasonUtil.IsOpen()
    local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
    local seasonTempData = DataCenter.SeasonTemplateManager:GetConfigData(seasonId)
    local config = DataCenter.SeasonDataManager:GetSeasonConfig()
    if config and seasonTempData then
      if seasonTempData.truce_name then
        self.btn_text:SetLocalText(seasonTempData.truce_name)
        local language = Localization.Language
        if language == LanguageType.Russian then
          local value = self.btn_text.GetText(self.btn_text)
          local result = string.gsub(value, "\239\188\154", "\239\188\154\n")
          self.btn_text:SetText(result)
        elseif language == LanguageType.Thai then
          local value = self.btn_text.GetText(self.btn_text)
          local result = string.gsub(value, "\239\188\154", "\n")
          self.btn_text:SetText(result)
        end
      end
      if not string.IsNullOrEmpty(seasonTempData.truce_icon) then
        self.bg:LoadSprite(string.format("Assets/Main/Sprites/UI/UISeason/Sprites/%s.png", seasonTempData.truce_icon))
      end
      local curSec = UITimeManager:GetInstance():GetServerSeconds()
      local truceEnterStartTime = 0
      local truceEnterEndTime = 0
      if seasonTempData.truceEnterStartTime and seasonTempData.truceEnterEndTime then
        local info = DataCenter.SeasonDataManager:GetUserSeasonInfo()
        if info then
          local zeroTime = UITimeManager:GetInstance():GetTodayZeroServerTime(info.seasonStartTime // 1000)
          truceEnterStartTime = zeroTime + seasonTempData.truceEnterStartTime * 24 * 60 * 60
          truceEnterEndTime = zeroTime + seasonTempData.truceEnterEndTime * 24 * 60 * 60
        end
      end
      if curSec < truceEnterStartTime then
        self.isShow = false
        self.nextTryRefreshTime = truceEnterStartTime
        if not seasonBtnShowFlag then
          local tmpList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.ActMigration.Type)
          local v = tmpList[1]
          local vType = v ~= nil and v:GetValidType() or ActivityValidType.Over
          local sTime = v ~= nil and v.startTime or 0
          local nLv = v ~= nil and v.needMainCityLevel or 0
          local MainLv = DataCenter.BuildManager.MainLv
          local curTime = UITimeManager:GetInstance():GetServerTime()
          if vType ~= ActivityValidType.Over and 0 < sTime and sTime <= curTime and nLv <= MainLv then
            self.isShow = true
            self.nextTryRefreshTime = truceEnterStartTime
          end
        end
      elseif curSec < truceEnterEndTime then
        self.isShow = true
        self.nextTryRefreshTime = truceEnterEndTime
      else
        self.isShow = false
        self.nextTryRefreshTime = -1
      end
    end
  end
  self:SetActive(self.isShow)
  self:OnRedPointRefresh()
end

function UIOffSeasonBtn:Update1000MS()
  if self.nextTryRefreshTime > 0 then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local deltaTime = self.nextTryRefreshTime - curTime
    if deltaTime < 0 then
      self:RefreshShowState()
    end
  end
end

function UIOffSeasonBtn:OnBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWOffSeason1Main, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  })
end

function UIOffSeasonBtn:OnRedPointRefresh()
  if self.isShow then
    local totalRedNum = 0
    local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
    local data = DataCenter.SeasonTemplateManager:GetConfigData(seasonId)
    if data == nil then
      return
    end
    for k, v in pairs(data.truceEnterActivityList) do
      local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(v)
      if not (activityData and activityData:IsValid()) or not DataCenter.ActivityListDataManager:GetTheActIsCanShow(tonumber(activityData.id)) then
      else
        local redNum = DataCenter.ActivityListDataManager:GetActivityRedDotCount(v)
        totalRedNum = totalRedNum + redNum
      end
    end
    self.red_point_num:SetActive(0 < totalRedNum)
    self.text:SetText(totalRedNum)
  end
end

return UIOffSeasonBtn
