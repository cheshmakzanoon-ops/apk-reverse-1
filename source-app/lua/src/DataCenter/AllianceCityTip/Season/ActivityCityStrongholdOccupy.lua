local base = UIBaseContainer
local ActivityCityStrongholdOccupy = BaseClass("ActivityCityStrongholdOccupy", base)
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local image_path = "Image"
local icon_path = "Image/bg/icon"
local user_name_path = "Image/user_name"
local time_tip_path = "Image/time_tip"
local pro1_root_path = "Image/pro1_root"
local pro1_path = "Image/pro1_root/pro1"
local pro1_fill_path = "Image/pro1_root/pro1/FillArea/pro1_fill"
local pro1_abbr_path = "Image/pro1_root/pro1_abbr"
local pro1_num_path = "Image/pro1_root/pro1_num"
local pro2_root_path = "Image/pro2_root"
local pro2_path = "Image/pro2_root/pro2"
local pro2_fill_path = "Image/pro2_root/pro2/FillArea/pro2_fill"
local pro2_abbr_path = "Image/pro2_root/pro2_abbr"
local pro2_num_path = "Image/pro2_root/pro2_num"
local pro3_root_path = "Image/pro3_root"
local pro3_path = "Image/pro3_root/pro3"
local pro3_fill_path = "Image/pro3_root/pro3/FillArea/pro3_fill"
local pro3_abbr_path = "Image/pro3_root/pro3_abbr"
local pro3_num_path = "Image/pro3_root/pro3_num"
local end_time_tip_path = "Image/end_time_tip"

function ActivityCityStrongholdOccupy:__init(transform, serverId)
  local request = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/UI/AllianceCityTip/StrongholdOccupy.prefab")
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
    self:UpdateData()
    if self.cityId then
      SFSNetwork.SendMessage(MsgDefines.GetStrongholdOccupyProgress, self.cityId, serverId)
    end
  end)
  self.lodCache = 0
  self.request = request
end

function ActivityCityStrongholdOccupy:__delete()
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

function ActivityCityStrongholdOccupy:OnCreate()
  base.OnCreate(self)
  self.theCanvas = self:AddComponent(UICanvas, "")
  self.root = self:AddComponent(UIButton, image_path)
  self.stronghold_icon = self:AddComponent(UIImage, icon_path)
  self.user_name = self:AddComponent(UITextMeshProUGUIEx, user_name_path)
  self.time_tip = self:AddComponent(UITextMeshProUGUIEx, time_tip_path)
  self.pro1_root = self:AddComponent(UIBaseContainer, pro1_root_path)
  self.pro1 = self:AddComponent(UISlider, pro1_path)
  self.pro1_fill = self:AddComponent(UIImage, pro1_fill_path)
  self.pro1_abbr = self:AddComponent(UITextMeshProUGUIEx, pro1_abbr_path)
  self.pro1_num = self:AddComponent(UITextMeshProUGUIEx, pro1_num_path)
  self.pro2_root = self:AddComponent(UIBaseContainer, pro2_root_path)
  self.pro2 = self:AddComponent(UISlider, pro2_path)
  self.pro2_fill = self:AddComponent(UIImage, pro2_fill_path)
  self.pro2_abbr = self:AddComponent(UITextMeshProUGUIEx, pro2_abbr_path)
  self.pro2_num = self:AddComponent(UITextMeshProUGUIEx, pro2_num_path)
  self.pro3_root = self:AddComponent(UIBaseContainer, pro3_root_path)
  self.pro3 = self:AddComponent(UISlider, pro3_path)
  self.pro3_fill = self:AddComponent(UIImage, pro3_fill_path)
  self.pro3_abbr = self:AddComponent(UITextMeshProUGUIEx, pro3_abbr_path)
  self.pro3_num = self:AddComponent(UITextMeshProUGUIEx, pro3_num_path)
  self.end_time_tip = self:AddComponent(UITextMeshProUGUIEx, end_time_tip_path)
  self.root:SetOnClick(function()
    if self.occupyPlayer ~= nil and self.cityId then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOccupyRankDetail, self.cityId)
    end
  end)
end

function ActivityCityStrongholdOccupy:OnAddListener()
  base.OnAddListener(self)
  self.registerListener = true
  self:AddUIListener(EventId.CityStrongholdOccupyProgressRefresh, self.OnOccupyProgressRefresh)
end

function ActivityCityStrongholdOccupy:OnRemoveListener()
  if self.registerListener then
    self.registerListener = false
    self:RemoveUIListener(EventId.CityStrongholdOccupyProgressRefresh, self.OnOccupyProgressRefresh)
  end
  base.OnRemoveListener(self)
end

function ActivityCityStrongholdOccupy:OnDestroy()
  base.OnDestroy(self)
end

function ActivityCityStrongholdOccupy:SetLod(lod)
  self.lodCache = toInt(lod)
  if IsNotNull(self.gameObject) then
    self:SetActive(self.lodCache ~= 0 and self.lodCache < 3 and self.occupyPlayer ~= nil)
  end
end

function ActivityCityStrongholdOccupy:ReInit(data, attackInfo, extraInfo)
  self.data = data
  self.cityId = toInt(self.data.id)
  self.cityType = toInt(self.data.type)
  self.serverId = self.data:GetCurServerId()
  if (self.occupyPlayer == nil or self.occupyPlayer.allianceId ~= attackInfo.allianceId) and IsNotNull(self.gameObject) then
    SFSNetwork.SendMessage(MsgDefines.GetStrongholdOccupyProgress, self.cityId, self.serverId)
  end
  self.occupyPlayer = attackInfo
  self.theExtraInfo = extraInfo
  self:UpdateData()
end

function ActivityCityStrongholdOccupy:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  if self.occupyPlayer == nil or self.theExtraInfo == nil then
    if IsNotNull(self.gameObject) then
      self:SetActive(false)
    end
    return
  end
  self:SetActive(self.lodCache ~= 0 and self.lodCache < 3)
  self.battleStartTime = self.theExtraInfo.battleStartTime
  self.battleEndTime = self.theExtraInfo.battleEndTime
  local seasonType = SeasonUtil.CurServerTypeInSeason()
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  local maxPoint = self.data.stronghold_points or 600
  local v = self.occupyPlayer
  self.stronghold_occupy_startTime = toInt(self.theExtraInfo.buildStartTime)
  self.stronghold_occupy_point_max = maxPoint
  self.stronghold_occupy_point_speed = v.buildSpeed
  if SeasonUtil.SeasonHasMilitaryCenter(seasonType) then
    self.user_name:SetText(UIUtil.FormatAllianceAndName(v.alAbbr, v.alName))
  else
    self.user_name:SetText(UIUtil.FormatServerAllianceName(v.serverId, v.alAbbr, v.alName))
  end
  self.pro1_abbr:SetText(string.format("[%s]", v.alAbbr))
  if v.allianceId == myAllianceId and myAllianceId ~= nil and myAllianceId ~= "" then
    self.user_name:SetColorRGBA255(84, 196, 242, 255)
    self.pro1_abbr:SetColorRGBA255(84, 196, 242, 255)
    self.pro1_fill:SetColorRGBA255(84, 196, 242, 255)
  else
    self.user_name:SetColorRGBA255(229, 39, 39, 255)
    self.pro1_abbr:SetColorRGBA255(229, 39, 39, 255)
    self.pro1_fill:SetColorRGBA255(229, 39, 39, 255)
  end
  local cityIconType = toInt(self.data.stronghold_army_type)
  if cityIconType == 1 then
    self.stronghold_icon:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_tanke_da.png")
  elseif cityIconType == 2 then
    self.stronghold_icon:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_daodan_da.png")
  elseif cityIconType == 3 then
    self.stronghold_icon:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_feiji_da.png")
  end
  local serverId = self.serverId
  local OccupyProgress = DataCenter.WorldAllianceCityDataManager:GetStrongholdBattleData(serverId, self.cityId)
  if OccupyProgress == nil then
    self.pro2_root:SetActive(false)
    self.pro3_root:SetActive(false)
  else
    self:OnOccupyProgressRefresh(OccupyProgress)
  end
  self:Update100MS()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root.transform)
end

function ActivityCityStrongholdOccupy:OnOccupyProgressRefresh(data)
  if IsNull(self.gameObject) then
    return
  end
  if data and data.progress and data.strongholdId and self.cityId == data.strongholdId and #data.progress > 0 then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local maxPoint = self.data.stronghold_points or 600
    local OccupyList = {}
    for _, v in ipairs(data.progress) do
      if self.occupyPlayer == nil or self.occupyPlayer.allianceId ~= v.allianceId then
        if 0 < toInt(v.speed) and not data.freeze then
          v.pointNow = v.point + v.speed * (curTime - v.buildStartTime)
        else
          v.pointNow = v.point
        end
        v.startTime = v.buildStartTime * 1000
        v.abbr = v.alAbbr
        v.name = v.alName
        v.icon = v.alIcon
        v.maxPoint = maxPoint
        table.insert(OccupyList, v)
      end
    end
    local dataCount = #OccupyList
    if 0 < dataCount then
      table.sort(OccupyList, function(a, b)
        return a.pointNow > b.pointNow
      end)
      self.pro2_root:SetActive(0 < dataCount)
      self.pro3_root:SetActive(1 < dataCount)
      self:SetOccupyData(OccupyList[1], self.pro2, self.pro2_fill, self.pro2_abbr, self.pro2_num)
      if 1 < dataCount then
        self:SetOccupyData(OccupyList[2], self.pro3, self.pro3_fill, self.pro3_abbr, self.pro3_num)
      end
    else
      self.pro2_root:SetActive(false)
      self.pro3_root:SetActive(false)
    end
  end
end

function ActivityCityStrongholdOccupy:SetOccupyData(data, pro, pro_fill, pro_abbr, pro_num)
  if data == nil then
    return
  end
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  pro_abbr:SetText(string.format("[%s]", data.abbr))
  if data.allianceId == myAllianceId and myAllianceId ~= nil and myAllianceId ~= "" then
    pro_abbr:SetColorRGBA255(84, 196, 242, 255)
    pro_fill:SetColorRGBA255(84, 196, 242, 255)
  else
    pro_abbr:SetColorRGBA255(229, 39, 39, 255)
    pro_fill:SetColorRGBA255(229, 39, 39, 255)
  end
  if data.pointNow == 0 then
    pro:SetValue(0)
    pro_num:SetText("0%")
  else
    local rate = data.pointNow / data.maxPoint
    pro:SetValue(math.min(math.max(rate, 0.05), 1))
    if data.pointNow >= data.maxPoint then
      pro_num:SetText("99.9%")
    else
      pro_num:SetText(string.percentage(data.pointNow, data.maxPoint, 1))
    end
  end
end

function ActivityCityStrongholdOccupy:Update100MS()
  if self.lodCache >= 3 then
    return
  end
  if self.occupyPlayer == nil or self.theExtraInfo == nil or IsNull(self.gameObject) then
    return
  end
  local attacker = self.occupyPlayer
  if attacker ~= nil and self.stronghold_occupy_startTime ~= nil and self.stronghold_occupy_point_max ~= nil then
    local timeMgr = UITimeManager:GetInstance()
    local curTime = timeMgr:GetServerSeconds()
    local pointNow = (curTime - self.stronghold_occupy_startTime) * attacker.buildSpeed + attacker.buildPoint
    local rate = pointNow / self.stronghold_occupy_point_max
    local occupyEndTime = self.battleEndTime
    if 1 < rate then
      rate = 1
      self.time_tip:SetText("")
      occupyEndTime = curTime
    else
      if rate < 1.0E-4 then
        rate = 1.0E-4
      end
      local remainTime = self.battleEndTime - curTime
      if attacker.buildSpeed == 0 then
        occupyEndTime = self.battleEndTime
        self.time_tip:SetText(Localization:GetString("season_s1_add_stronghold_desc01") .. timeMgr:SecondToFmtString(remainTime))
      else
        local buildTime = (self.stronghold_occupy_point_max - pointNow) / attacker.buildSpeed
        remainTime = math.min(remainTime, buildTime)
        occupyEndTime = curTime + remainTime
        self.time_tip:SetText(Localization:GetString("season_s1_add_stronghold_desc01") .. timeMgr:SecondToFmtString(remainTime))
      end
    end
    if pointNow == 0 then
      self.pro1:SetValue(0)
      self.pro1_num:SetText("0%")
    else
      self.pro1:SetValue(math.min(math.max(rate, 0.05), 1))
      self.pro1_num:SetText(string.percentage(pointNow, self.stronghold_occupy_point_max, 1))
    end
    local remainTime = self.battleEndTime - curTime
    if 0 <= remainTime then
      self.end_time_tip:SetText(Localization:GetString("season_s1_add_stronghold_desc02") .. timeMgr:SecondToFmtString(remainTime))
    else
      self.end_time_tip:SetText("")
    end
    if toInt(occupyEndTime) < self.battleEndTime then
      self.end_time_tip:SetColorRGBA255(121, 255, 66, 255)
    else
      self.end_time_tip:SetColorRGBA255(229, 39, 39, 255)
    end
  end
end

return ActivityCityStrongholdOccupy
