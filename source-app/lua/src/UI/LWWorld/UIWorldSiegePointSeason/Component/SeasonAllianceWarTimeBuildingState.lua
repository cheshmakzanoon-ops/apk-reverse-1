local p_img_bg_alliance_war_time_path = "p_img_bg_alliance_war_time"
local p_btn_icon_alliance_war_time_path = "p_img_bg_alliance_war_time/p_btn_icon_alliance_war_time"
local p_img_icon_alliance_war_time_path = "p_img_bg_alliance_war_time/p_btn_icon_alliance_war_time/p_img_icon_alliance_war_time"
local p_text_alliance_war_time_path = "p_img_bg_alliance_war_time/p_text_alliance_war_time"
local p_img_state_alliance_war_time_path = "p_img_bg_alliance_war_time/p_img_state_alliance_war_time"
local base = UIBaseContainer
local SeasonAllianceWarTimeBuildingState = BaseClass("SeasonAllianceWarTimeBuildingState", UIBaseContainer)

function SeasonAllianceWarTimeBuildingState:ComponentDefine()
  self.p_img_bg_alliance_war_time = self:AddComponent(UIImage, p_img_bg_alliance_war_time_path)
  self.p_btn_icon_alliance_war_time = self:AddComponent(UIButton, p_btn_icon_alliance_war_time_path)
  self.p_btn_icon_alliance_war_time:SetOnClick(BindCallback(self, self.OnWarTimeClicked))
  self.p_img_icon_alliance_war_time = self:AddComponent(UIImage, p_img_icon_alliance_war_time_path)
  self.p_text_alliance_war_time = self:AddComponent(UITextMeshProUGUIEx, p_text_alliance_war_time_path)
  self.p_img_state_alliance_war_time = self:AddComponent(UIImage, p_img_state_alliance_war_time_path)
  self.p_btn_img_war_icon = self:AddComponent(UIButton, p_img_state_alliance_war_time_path)
  self.p_btn_img_war_icon:SetOnClick(BindCallback(self, self.OnWarTimeIconClicked))
end

function SeasonAllianceWarTimeBuildingState:ComponentDestroy()
  self.p_img_bg_alliance_war_time = nil
  self.p_btn_icon_alliance_war_time = nil
  self.p_img_icon_alliance_war_time = nil
  self.p_text_alliance_war_time = nil
  self.p_img_state_alliance_war_time = nil
end

function SeasonAllianceWarTimeBuildingState:DataDefine()
end

function SeasonAllianceWarTimeBuildingState:DataDestroy()
end

function SeasonAllianceWarTimeBuildingState:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonAllianceWarTimeBuildingState:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonAllianceWarTimeBuildingState:OnAddListener()
  base.OnAddListener(self)
end

function SeasonAllianceWarTimeBuildingState:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonAllianceWarTimeBuildingState:ReInit(data, allianceId)
  if self:InitData(data, allianceId) then
    self:InitUi()
  end
end

function SeasonAllianceWarTimeBuildingState:InitData(data, allianceId)
  if data ~= nil then
    self.Data = data
    self.allianceId = allianceId
    self.PointInfo = CS.SceneManager.World:GetPointInfo(self.Data.PointId)
    if self.PointInfo ~= nil then
      self.PointType = self.PointInfo.PointType
      self.ExtraInfo = SeasonUtil.TryParseAllianceCityPointInfo(self.PointInfo.PointType, self.PointInfo.extraInfo)
      if self.ExtraInfo ~= nil then
        self.State = checknumber(self.ExtraInfo.state)
        self.BattleEndTime = checknumber(self.ExtraInfo.battleEndTime)
        self.OpenTime = checknumber(self.ExtraInfo.protectTime) * 1000
        local serverId = self.ExtraInfo.serverId
        local cityId = checknumber(self.ExtraInfo.cityId)
        if self.OpenTime == 0 then
          self.OpenTime = DataCenter.AllianceCityTipManager:GetProtectedTime(serverId, cityId)
        end
        self.allianceId = self.ExtraInfo.allianceId
        return true
      end
    end
  end
  return false
end

function SeasonAllianceWarTimeBuildingState:InitUi()
  self.p_img_icon_alliance_war_time:LoadSpriteAsync(DataCenter.UILWSeasonAllianceWarTimeManager:GetIconPath(self.Data.TimeIndex))
  local baseTime = checknumber(self.OpenTime)
  if baseTime == 0 then
    baseTime = UITimeManager:GetInstance():GetServerTime()
  end
  if self.PointType == WorldPointType.WORLD_CITY_STRONGHOLD then
    local needCheckWeek = false
    if self.PointInfo and self.PointInfo.CityId then
      local data = SeasonUtil.GetCurServerConfig()
      if data and data:GetServerSubdivisionType(false) == SeasonMapType.NineNationRainforest then
        local CityId = self.PointInfo.CityId
        local cityInfo = self.PointInfo.StrongholdInfo
        if cityInfo ~= nil and not string.IsNullOrEmpty(cityInfo.AllianceId) then
          needCheckWeek = true
        end
      end
    end
    local startTime, endTime = DataCenter.UILWSeasonAllianceWarTimeManager:GetNextWarTime(baseTime, self.Data.TimeIndex, needCheckWeek, true)
    self:ShowWarTime(startTime, endTime)
  elseif self.PointType == WorldPointType.WORLD_ALLIANCE_CITY then
    local startTime, endTime = DataCenter.UILWSeasonAllianceWarTimeManager:GetNextWarTime(baseTime, self.Data.TimeIndex, true, true)
    self:ShowWarTime(startTime, endTime)
  end
  self:Update1000MS()
end

function SeasonAllianceWarTimeBuildingState:ShowWarTime(startTime, endTime)
  local now = UITimeManager:GetInstance():GetServerTime()
  self.InWar = startTime <= now and endTime > now
  if self.InWar then
    self.TickTimeEnd = endTime
    self.TickTimeKey = "s5_alliance_battle_time_ui50"
    if self.ExtraInfo ~= nil and checknumber(self.ExtraInfo.battleStartTime) > 0 then
      self.TickTimeKey = "s5_alliance_battle_time_ui31"
    end
    self.p_img_state_alliance_war_time:LoadSpriteAsync(DataCenter.UILWSeasonAllianceWarTimeManager:GetWarIconPath(true))
    self.p_img_bg_alliance_war_time:SetColor(Color.New(1, 0.8901960784313725, 0.8745098039215686, 1))
    self.p_text_alliance_war_time:SetColor(Color.New(0.9607843137254902, 0.23529411764705882, 0.23921568627450981))
  else
    self.TickTimeEnd = startTime
    self.TickTimeKey = "s5_alliance_battle_time_ui30"
    self.p_img_state_alliance_war_time:LoadSpriteAsync(DataCenter.UILWSeasonAllianceWarTimeManager:GetWarIconPath(false))
    if self.PointType == WorldPointType.WORLD_CITY_STRONGHOLD and SeasonUtil.GetSeasonSubdivisionType() == SeasonMapType.NineNationRainforest then
      self.p_img_bg_alliance_war_time:SetColor(Color.New(0.87, 0.94, 0.78, 1))
    else
      self.p_img_bg_alliance_war_time:SetColor(Color.New(0.9450980392156862, 0.9294117647058824, 0.9215686274509803, 1))
    end
    self.p_text_alliance_war_time:SetColor(Color.New(0.03529411764705882, 0.6078431372549019, 0.2901960784313726))
  end
end

function SeasonAllianceWarTimeBuildingState:Update1000MS()
  local leftTime = math.max(0, self.TickTimeEnd - UITimeManager:GetInstance():GetServerTime())
  self.p_text_alliance_war_time:SetLocalText(self.TickTimeKey, UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
end

function SeasonAllianceWarTimeBuildingState:OnWarTimeClicked()
  if self.Data ~= nil then
    local param = {}
    param.alignObject = self.p_btn_icon_alliance_war_time.transform
    param.yPosFix = -20
    param.showArrow = true
    param.preferTop = true
    param.allianceId = self.allianceId
    param.TimeIndex = self.Data.TimeIndex
    UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonAllianceWarTimeStateTipsView, {anim = true}, param)
  end
end

function SeasonAllianceWarTimeBuildingState:OnWarTimeIconClicked()
  local msg = CS.GameEntry.Localization:GetString("s5_alliance_battle_time_tips002")
  if self.InWar then
    msg = CS.GameEntry.Localization:GetString("s5_alliance_battle_time_tips001")
  end
  UIUtil.ShowBubbleTips(msg, self.p_btn_img_war_icon.transform.position, 0, -30, 0)
end

return SeasonAllianceWarTimeBuildingState
