local base = UIBaseContainer
local LWSeasonMainBanner = BaseClass("LWSeasonMainBanner", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local bg_path = "bg"
local vs_path = "vs"
local lost_power_path = "lostPower"
local soldier_slider2_path = "lostPower/SoldierSlider2"
local soldier_slider1_path = "lostPower/SoldierSlider1"
local slider_text1_path = "lostPower/SliderText1"
local slider_text2_path = "lostPower/SliderText2"
local group_title2_path = "icon2/GroupTitle2"
local pos2_path = "icon2/pos2"
local lost2_path = "icon2/lost2"
local win2_path = "icon2/win2"
local pos1_path = "icon1/pos1"
local group_title1_path = "icon1/GroupTitle1"
local lost1_path = "icon1/lost1"
local win1_path = "icon1/win1"
local timer_path = "Timer"
local icon2_path = "icon2"
local icon1_path = "icon1"

function LWSeasonMainBanner:OnCreate()
  base.OnCreate(self)
  self.params = nil
  self.icon2 = self:AddComponent(UIImage, icon2_path)
  self.icon1 = self:AddComponent(UIImage, icon1_path)
  self.bg = self:AddComponent(UIButton, bg_path)
  self.vs = self:AddComponent(UIRawImage, vs_path)
  self.power = self:AddComponent(UIBaseContainer, lost_power_path)
  self.soldier_slider2 = self:AddComponent(UISlider, soldier_slider2_path)
  self.soldier_slider1 = self:AddComponent(UISlider, soldier_slider1_path)
  self.slider_text1 = self:AddComponent(UITextMeshProUGUIEx, slider_text1_path)
  self.slider_text2 = self:AddComponent(UITextMeshProUGUIEx, slider_text2_path)
  self.group_title2 = self:AddComponent(UITextMeshProUGUIEx, group_title2_path)
  self.pos2 = self:AddComponent(UIImage, pos2_path)
  self.lost2 = self:AddComponent(UIImage, lost2_path)
  self.win2 = self:AddComponent(UIImage, win2_path)
  self.pos1 = self:AddComponent(UIImage, pos1_path)
  self.group_title1 = self:AddComponent(UITextMeshProUGUIEx, group_title1_path)
  self.lost1 = self:AddComponent(UIImage, lost1_path)
  self.win1 = self:AddComponent(UIImage, win1_path)
  self.timer = self:AddComponent(UITextMeshProUGUIEx, timer_path)
  self.bg:SetOnClick(function()
    self:OnShowClick()
  end)
  self.icon1:LoadSprite(DataCenter.SeasonFactionWarDataManager:GetCampIcon(SeasonFactionType.Rebels, true))
  self.icon2:LoadSprite(DataCenter.SeasonFactionWarDataManager:GetCampIcon(SeasonFactionType.Gendarmerie, true))
end

function LWSeasonMainBanner:OnDestroy()
  self.icon2 = nil
  self.icon1 = nil
  self.bg = nil
  self.vs = nil
  self.power = nil
  self.soldier_slider2 = nil
  self.soldier_slider1 = nil
  self.slider_text1 = nil
  self.slider_text2 = nil
  self.group_title2 = nil
  self.pos2 = nil
  self.lost2 = nil
  self.win2 = nil
  self.pos1 = nil
  self.group_title1 = nil
  self.lost1 = nil
  self.win1 = nil
  self.timer = nil
  base.OnDestroy(self)
end

function LWSeasonMainBanner:SetParams(params)
  self.params = params
end

function LWSeasonMainBanner:RefreshData()
  self:CalcStatus()
  self:Update1000MS()
end

function LWSeasonMainBanner:RefreshRankList(data)
  if data == nil then
    return
  end
  local camp1Score = 0
  local camp2Score = 0
  if data.campScore1 == nil or data.campScore2 == nil then
    return
  end
  if data.rank_type == SeasonRankType.CampRareLand then
    camp1Score = data.campScore1
    camp2Score = data.campScore2
  elseif data.rank_type == SeasonRankType.CampPower then
    camp1Score = checknumber(data.campScore1.campScore)
    camp2Score = checknumber(data.campScore2.campScore)
  end
  local maxScore = math.max(camp1Score, camp2Score)
  self.power:SetActive(true)
  if maxScore ~= 0 then
    self.soldier_slider1:SetValue(camp1Score / maxScore)
    self.soldier_slider2:SetValue(camp2Score / maxScore)
    if self.inSettleTime then
      if camp1Score < camp2Score then
        self.lost1:SetActive(true)
        self.win2:SetActive(true)
      else
        self.win1:SetActive(true)
        self.lost2:SetActive(true)
      end
    end
  else
    self.soldier_slider1:SetValue(0)
    self.soldier_slider2:SetValue(0)
    self.slider_text1:SetText("")
    self.slider_text2:SetText("")
  end
  local selfCampId = data.selfCampId
  if selfCampId then
    self.pos1:SetActive(selfCampId == SeasonFactionType.Rebels)
    self.pos2:SetActive(selfCampId == SeasonFactionType.Gendarmerie)
  end
end

function LWSeasonMainBanner:RefreshRankData()
  local myCampId = DataCenter.SeasonFactionWarDataManager.myCampId
  self.groupingShownMode = false
  self.power:SetActive(false)
  self.lost2:SetActive(false)
  self.win2:SetActive(false)
  self.lost1:SetActive(false)
  self.win1:SetActive(false)
  self.timer:SetActive(false)
  if self.params then
    if self.params.showBg ~= nil then
      if self.params.showBg then
        self.bg:SetLocalScaleXYZ(1, 1, 1)
      else
        self.bg:SetLocalScaleXYZ(0, 0, 0)
      end
    else
      self.bg:SetLocalScaleXYZ(1, 1, 1)
    end
    if self.params.showJustIconName then
      self.group_title2:SetActive(true)
      self.group_title1:SetActive(true)
      self.group_title1:SetText(DataCenter.SeasonFactionWarDataManager:GetCampName(SeasonFactionType.Rebels))
      self.group_title2:SetText(DataCenter.SeasonFactionWarDataManager:GetCampName(SeasonFactionType.Gendarmerie))
      self.pos2:SetActive(false)
      self.pos1:SetActive(false)
      return
    elseif self.params.showJustIcon then
      self.group_title2:SetActive(false)
      self.group_title1:SetActive(false)
      self.pos2:SetActive(false)
      self.pos1:SetActive(false)
      return
    end
  else
    self.bg:SetLocalScaleXYZ(1, 1, 1)
  end
  self.group_title1:SetActive(false)
  self.group_title2:SetActive(false)
  self.pos1:SetActive(myCampId == SeasonFactionType.Rebels)
  self.pos2:SetActive(myCampId == SeasonFactionType.Gendarmerie)
  local seasonType = SeasonUtil.GetSeasonType(true, true)
  if seasonType == SeasonMapType.NineNationRainforest then
    SFSNetwork.SendMessage(MsgDefines.GetSeasonRankInfo, SeasonRankType.CampPower)
  else
    SFSNetwork.SendMessage(MsgDefines.GetSeasonRankInfo, SeasonRankType.CampRareLand)
  end
end

function LWSeasonMainBanner:CalcStatus()
  if self.params and (self.params.showJustIcon or self.params.showJustIconName) then
    self:RefreshRankData()
    return
  end
  local seasonSettleTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if seasonSettleTime <= curTime then
    self.inSettleTime = true
    self:RefreshRankData()
    return
  end
  local factionWarActivityType = SeasonUtil.GetFactionWarActivityType()
  local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(factionWarActivityType)
  if table.count(dataList) > 0 then
    local activityId = dataList[1].id
    if activityId then
      self:RefreshRankData()
      return
    end
  end
  local seasonType = SeasonUtil.GetSeasonType(true, true)
  if seasonType == SeasonMapType.NineNationRainforest then
    self:RefreshRankData()
    return
  end
  local groupingShownMode = DataCenter.SeasonFactionWarDataManager:IsGroupingShownMode()
  if not groupingShownMode then
    dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(factionWarActivityType)
    if table.count(dataList) > 0 then
      local actData = dataList[1]
      if actData then
        local start = actData.startTime
        local para_1 = actData.para_1
        local para_8 = actData.para_8
        local v1, v2 = string.split_ii(para_8 or "0|0", "|")
        self.endTime = start + toInt(para_1) * 1000 + toInt(v1) * 1000 + toInt(v2) * 1000
      end
    end
  end
  if groupingShownMode then
    local campInfo = DataCenter.SeasonFactionWarDataManager:GetGroupingData()
    local camp1 = ""
    local camp2 = ""
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    local myCamp = 0
    self.power:SetActive(false)
    self.group_title2:SetActive(true)
    self.lost2:SetActive(false)
    self.win2:SetActive(false)
    self.pos2:SetActive(false)
    self.group_title1:SetActive(true)
    self.lost1:SetActive(false)
    self.win1:SetActive(false)
    self.pos1:SetActive(false)
    self.timer:SetActive(false)
    if campInfo ~= nil then
      local camp1List = {}
      local camp2List = {}
      for _, v in pairs(campInfo) do
        if v.campId == SeasonFactionType.Rebels then
          table.insert(camp1List, v.serverId)
        elseif v.campId == SeasonFactionType.Gendarmerie then
          table.insert(camp2List, v.serverId)
        end
        if mySourceServerId == v.serverId then
          myCamp = v.campId
        end
      end
      table.sort(camp1List, function(a, b)
        return a < b
      end)
      table.sort(camp2List, function(a, b)
        return a < b
      end)
      for _, serverId in ipairs(camp1List) do
        camp1 = camp1 .. " #" .. serverId
      end
      for _, serverId in ipairs(camp2List) do
        camp2 = camp2 .. " #" .. serverId
      end
    end
    self.group_title1:SetText(camp1)
    self.group_title2:SetText(camp2)
    self.pos1:SetActive(myCamp == SeasonFactionType.Rebels)
    self.pos2:SetActive(myCamp == SeasonFactionType.Gendarmerie)
  else
    self.power:SetActive(false)
    self.group_title2:SetActive(false)
    self.lost2:SetActive(false)
    self.win2:SetActive(false)
    self.pos2:SetActive(false)
    self.group_title1:SetActive(false)
    self.lost1:SetActive(false)
    self.win1:SetActive(false)
    self.pos1:SetActive(false)
    self.timer:SetActive(self.endTime ~= nil and self.endTime ~= 0)
  end
  self.groupingShownMode = groupingShownMode
end

function LWSeasonMainBanner:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonFactionInfoUpdate, self.RefreshData)
  self:AddUIListener(EventId.SeasonRankUpdate, self.RefreshRankList)
end

function LWSeasonMainBanner:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonFactionInfoUpdate, self.RefreshData)
  self:RemoveUIListener(EventId.SeasonRankUpdate, self.RefreshRankList)
  base.OnRemoveListener(self)
end

function LWSeasonMainBanner:Update1000MS()
  if self.groupingShownMode then
  elseif self.endTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - curTime
    if 0 < remainTime then
      local msg = Localization:GetString("season_s3_ui_info001")
      self.timer:SetText(msg .. UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.timer:SetText("")
      self.endTime = nil
    end
  end
end

function LWSeasonMainBanner:OnShowClick()
  if self.params then
    if self.params.ignoreClick then
      return
    end
    if self.params.funClick ~= nil and type(self.params.funClick) == "function" then
      pcall(self.params.funClick)
      return
    end
  end
  local uiParam = {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }
  local seasonType = SeasonUtil.GetSeasonType(true, true)
  if seasonType == SeasonMapType.NineNationRainforest then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonRank, uiParam, 3)
    return
  end
  local seasonSettleTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if seasonSettleTime <= curTime then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonRank, uiParam, 3)
    return
  end
  local uiName = UIWindowNames.UILWSingleActivityContainer
  local factionSelectionActivityType = SeasonUtil.GetFactionSelectionActivityType()
  local factionWarActivityType = SeasonUtil.GetFactionWarActivityType()
  local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(factionSelectionActivityType)
  if table.count(dataList) > 0 then
    local groupingShownMode = DataCenter.SeasonFactionWarDataManager:IsGroupingShownMode()
    if not groupingShownMode then
      local activityId = dataList[1].id
      if activityId then
        UIManager:GetInstance():OpenWindow(uiName, uiParam, activityId)
        return
      end
    end
  end
  local battleStep = DataCenter.SeasonFactionWarDataManager:GetCurrStep()
  if battleStep == SeasonFactionDeclareWarStep.battle_before or battleStep == SeasonFactionDeclareWarStep.battle then
    dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(factionWarActivityType)
    if table.count(dataList) > 0 then
      local activityId = dataList[1].id
      if activityId then
        UIManager:GetInstance():OpenWindow(uiName, uiParam, activityId)
        return
      end
    end
  end
  dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.SeasonFactionKingWarActivity.Type)
  if table.count(dataList) > 0 then
    local activityId = dataList[1].id
    if activityId then
      UIManager:GetInstance():OpenWindow(uiName, uiParam, activityId)
      return
    end
  end
  dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(factionWarActivityType)
  if table.count(dataList) > 0 then
    local activityId = dataList[1].id
    if activityId then
      UIManager:GetInstance():OpenWindow(uiName, uiParam, activityId)
      return
    end
  end
  dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(factionSelectionActivityType)
  if table.count(dataList) > 0 then
    local data = dataList[1]
    if data and data.id then
      UIManager:GetInstance():OpenWindow(uiName, uiParam, data.id)
      return
    end
  end
  local declareActivity = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonCrossDeclareWarActivity.Type)
  if declareActivity ~= nil then
    SeasonUtil.OpenSeasonActivity(declareActivity)
    return
  end
end

return LWSeasonMainBanner
