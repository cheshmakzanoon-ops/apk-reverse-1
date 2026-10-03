local p_img_bg_alliance_war_time_path = "image/p_comp_alliance_war_time/p_img_bg_alliance_war_time"
local p_btn_icon_alliance_war_time_path = "image/p_comp_alliance_war_time/p_img_bg_alliance_war_time/p_btn_icon_alliance_war_time"
local p_img_icon_alliance_war_time_path = "image/p_comp_alliance_war_time/p_img_bg_alliance_war_time/p_btn_icon_alliance_war_time/p_img_icon_alliance_war_time"
local p_text_alliance_war_time_path = "image/p_comp_alliance_war_time/p_img_bg_alliance_war_time/p_text_alliance_war_time"
local p_img_state_alliance_war_time_path = "image/p_comp_alliance_war_time/p_img_bg_alliance_war_time/p_img_state_alliance_war_time"
local prefab_path = "Assets/Main/SeasonRes/S5/Prefabs/UI/AllianceWarTime/SeasonAllianceWarTimeBuildingHud.prefab"
local ResourceManager = CS.GameEntry.Resource
local base = UIBaseContainer
local SeasonAllianceWarTimeBuildingHud = BaseClass("SeasonAllianceWarTimeBuildingHud", UIBaseContainer)

function SeasonAllianceWarTimeBuildingHud:ComponentDefine()
  self.p_img_bg_alliance_war_time = self:AddComponent(UIImage, p_img_bg_alliance_war_time_path)
  self.p_btn_icon_alliance_war_time = self:AddComponent(UIButton, p_btn_icon_alliance_war_time_path)
  self.p_btn_icon_alliance_war_time:SetOnClick(BindCallback(self, self.OnWarTimeClicked))
  self.p_img_icon_alliance_war_time = self:AddComponent(UIImage, p_img_icon_alliance_war_time_path)
  self.p_text_alliance_war_time = self:AddComponent(UITextMeshProUGUIEx, p_text_alliance_war_time_path)
end

function SeasonAllianceWarTimeBuildingHud:ComponentDestroy()
  self.p_img_bg_alliance_war_time = nil
  self.p_btn_icon_alliance_war_time = nil
  self.p_img_icon_alliance_war_time = nil
  self.p_text_alliance_war_time = nil
  self.p_img_state_alliance_war_time = nil
end

function SeasonAllianceWarTimeBuildingHud:DataDefine()
end

function SeasonAllianceWarTimeBuildingHud:DataDestroy()
end

function SeasonAllianceWarTimeBuildingHud:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonAllianceWarTimeBuildingHud:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonAllianceWarTimeBuildingHud:OnAddListener()
  base.OnAddListener(self)
end

function SeasonAllianceWarTimeBuildingHud:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonAllianceWarTimeBuildingHud:__init(transform, serverId)
  local request = ResourceManager:InstantiateAsync(prefab_path)
  request:completed("+", function()
    local theWorld = CS.SceneManager.World
    if request.isError or transform == nil or theWorld == nil or IsNull(transform) then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(transform)
    go.transform:Set_localScale(0.01, 0.01, 0.01)
    go.transform:Set_localPosition(0, 0, 0)
    go.transform:Set_localRotation(0, 0, 0, 1)
    base.Reinit(self, go, "")
    self.initActiveSelf = true
    self:OnCreate()
    self:OnEnable()
    self:SetLod(theWorld:GetLodLevel())
    self:InitUi()
    self:UpdateUi()
  end)
  self.lodCache = 0
  self.request = request
end

function SeasonAllianceWarTimeBuildingHud:__delete()
  if self.gameObject ~= nil then
    self:OnDisable()
    self:OnDestroy()
  else
    self.holder = nil
  end
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
end

function SeasonAllianceWarTimeBuildingHud:ReInit(data, extraInfo)
  if self:InitData(data, extraInfo) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function SeasonAllianceWarTimeBuildingHud:InitData(data, extraInfo)
  if data ~= nil and extraInfo ~= nil then
    self.Data = data
    self.CityId = checknumber(data.id)
    self.CityType = checknumber(self.Data.type)
    self.ExtraInfo = extraInfo
    self.TimeIndex = checknumber(self.ExtraInfo.warTimeIndex)
    if self.ExtraInfo ~= nil then
      self.OpenTime = 0
      self.OpenTime = math.max(self.OpenTime, checknumber(self.ExtraInfo.openTime))
      self.OpenTime = math.max(self.OpenTime, checknumber(self.ExtraInfo.protectTime))
      self.OpenTime = self.OpenTime * 1000
      return true
    end
  end
  return false
end

function SeasonAllianceWarTimeBuildingHud:InitUi()
  if self.p_img_icon_alliance_war_time then
    self.p_img_icon_alliance_war_time:LoadSpriteAsync(DataCenter.UILWSeasonAllianceWarTimeManager:GetIconPath(self.TimeIndex))
  end
end

function SeasonAllianceWarTimeBuildingHud:UpdateData()
  return true
end

function SeasonAllianceWarTimeBuildingHud:UpdateUi()
  local baseTime = checknumber(self.OpenTime)
  if baseTime == 0 then
    baseTime = UITimeManager:GetInstance():GetServerTime()
  end
  if self.CityType == WorldAllianceCityType.Stronghold then
    local needCheckWeek = false
    local cityInfo = self.ExtraInfo
    if cityInfo and not string.IsNullOrEmpty(cityInfo.allianceId) and self.Data and self.Data:getIntValue("season", 0) == 6 then
      needCheckWeek = true
    end
    local startTime, endTime = DataCenter.UILWSeasonAllianceWarTimeManager:GetNextWarTime(baseTime, self.TimeIndex, needCheckWeek, true)
    self:ShowWarTime(startTime, endTime)
  elseif self.CityType == WorldAllianceCityType.City then
    local startTime, endTime = DataCenter.UILWSeasonAllianceWarTimeManager:GetNextWarTime(baseTime, self.TimeIndex, true, true)
    self:ShowWarTime(startTime, endTime)
  end
  self:Update1000MS()
end

function SeasonAllianceWarTimeBuildingHud:ShowWarTime(startTime, endTime)
  local now = UITimeManager:GetInstance():GetServerTime()
  local inWar = startTime <= now and endTime > now
  if inWar then
    self.TickTimeEnd = endTime
    self.TickTimeKey = "s5_alliance_battle_time_ui50"
    if self.ExtraInfo ~= nil and checknumber(self.ExtraInfo.battleStartTime) > 0 then
      self.TickTimeKey = "s5_alliance_battle_time_ui31"
    end
    if IsNotNull(self.p_img_bg_alliance_war_time) then
      self.p_img_bg_alliance_war_time:SetColor(Color.New(1, 0.8901960784313725, 0.8745098039215686, 1))
    end
    if IsNotNull(self.p_text_alliance_war_time) then
      self.p_text_alliance_war_time:SetColor(Color.New(0.9607843137254902, 0.23529411764705882, 0.23921568627450981))
    end
  else
    self.TickTimeEnd = startTime
    self.TickTimeKey = "s5_alliance_battle_time_ui30"
    if IsNotNull(self.p_img_bg_alliance_war_time) then
      self.p_img_bg_alliance_war_time:SetColor(Color.New(0.9450980392156862, 0.9294117647058824, 0.9215686274509803, 1))
    end
    if IsNotNull(self.p_text_alliance_war_time) then
      self.p_text_alliance_war_time:SetColor(Color.New(0.37254901960784315, 0.9372549019607843, 0.5294117647058824))
    end
  end
end

function SeasonAllianceWarTimeBuildingHud:SetLod(lod)
  self.lodCache = checknumber(lod)
  if IsNotNull(self.gameObject) then
    self:SetActive(self.lodCache ~= 0 and self.lodCache < 3)
  end
end

function SeasonAllianceWarTimeBuildingHud:Update1000MS()
  if self.lodCache >= 3 then
    return
  end
  if IsNull(self.gameObject) then
    return
  end
  if self.p_text_alliance_war_time then
    local leftTime = math.max(0, checknumber(self.TickTimeEnd) - UITimeManager:GetInstance():GetServerTime())
    self.p_text_alliance_war_time:SetLocalText(self.TickTimeKey, UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
  end
end

function SeasonAllianceWarTimeBuildingHud:OnWarTimeClicked()
  if self.Data ~= nil then
    local param = {}
    local pos = CS.SceneManager.World:WorldToScreenPoint(self.p_btn_icon_alliance_war_time.transform.position)
    local vec = Vector3.New(pos.x, pos.y, 0)
    param.screenPos = vec
    param.yPosFix = -20
    param.showArrow = true
    param.preferTop = true
    param.TimeIndex = self.TimeIndex
    if self.ExtraInfo then
      param.allianceId = self.ExtraInfo.allianceId
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonAllianceWarTimeStateTipsView, {anim = true}, param)
  end
end

return SeasonAllianceWarTimeBuildingHud
