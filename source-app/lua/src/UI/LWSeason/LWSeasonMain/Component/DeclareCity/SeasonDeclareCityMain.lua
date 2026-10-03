local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")
local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local SeasonDeclareCityMain = BaseClass("SeasonDeclareCityMain", base)
local Localization = CS.GameEntry.Localization
local SeasonDeclareInfo = require("UI.LWSeason.LWSeasonMain.Component.DeclareCity.SeasonDeclareInfo")
local SeasonDeclareMy = require("UI.LWSeason.LWSeasonMain.Component.DeclareCity.SeasonDeclareMy")
local SeasonDeclareOther = require("UI.LWSeason.LWSeasonMain.Component.DeclareCity.SeasonDeclareOther")
local tab_item1_path = "RightView/InfoRoot/TabRoot/TabItem1"
local tab_item2_path = "RightView/InfoRoot/TabRoot/TabItem2"
local red_point1_path = "RightView/InfoRoot/TabRoot/TabItem1/RedPoint1"
local red_point2_path = "RightView/InfoRoot/TabRoot/TabItem2/RedPoint2"
local no_alliance_path = "RightView/NoAlliance"
local btn_join_path = "RightView/Bottom/BtnJoin"
local info_btn_path = "RightView/Top/InfoBtn"
local open_time_path = "RightView/Top/TimeBg/openTime"
local city_list_btn_path = "RightView/Top/CityListBtn"
local gift_btn_path = "RightView/Top/GiftBtn"
local record_btn_path = "RightView/Top/RecordBtn"
local rank_btn_path = "RightView/Top/RankBtn"
local lock_root_path = "RightView/LockRoot"
local remain_time_path = "RightView/LockRoot/remainTime"
local info_root_path = "RightView/InfoRoot"
local declare_info_path = "RightView/InfoRoot/DeclareInfo"
local other_declare_path = "RightView/InfoRoot/OtherDeclare"
local my_declare_path = "RightView/InfoRoot/MyDeclare"
local btn_goal_path = "RightView/Bottom/BtnGoal"

function SeasonDeclareCityMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  DataCenter.AllianceDeclareWarManager:SetWarCityParam(nil)
end

function SeasonDeclareCityMain:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonDeclareCityMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonCrossDeclareWarInfo, self.OnCrossDeclareWarInfo)
  self:AddUIListener(EventId.LWSeasonCrossDeclareWarRedPointUpdate, self.OnCrossDeclareWarRedPointUpdate)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.OnAllianceDataUpdated)
end

function SeasonDeclareCityMain:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonCrossDeclareWarInfo, self.OnCrossDeclareWarInfo)
  self:RemoveUIListener(EventId.LWSeasonCrossDeclareWarRedPointUpdate, self.OnCrossDeclareWarRedPointUpdate)
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.OnAllianceDataUpdated)
  base.OnRemoveListener(self)
end

function SeasonDeclareCityMain:ComponentDefine()
  self.tab_item1 = self:AddComponent(UIToggle, tab_item1_path)
  self.tab_item2 = self:AddComponent(UIToggle, tab_item2_path)
  self.red_point1 = self:AddComponent(UIImage, red_point1_path)
  self.red_point2 = self:AddComponent(UIImage, red_point2_path)
  self.no_alliance = self:AddComponent(UIBaseContainer, no_alliance_path)
  self.btn_join = self:AddComponent(UIButton, btn_join_path)
  self.btn_join:SetOnClick(BindCallback(self, self.OnBtnClickJoin))
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.activity_time = self:AddComponent(UIText, open_time_path)
  self.city_list_btn = self:AddComponent(UIButton, city_list_btn_path)
  self.gift_btn = self:AddComponent(UIButton, gift_btn_path)
  self.record_btn = self:AddComponent(UIButton, record_btn_path)
  self.rank_btn = self:AddComponent(UIButton, rank_btn_path)
  self.info_btn:SetOnClick(BindCallback(self, self.OnBtnClickInfo))
  self.city_list_btn:SetOnClick(BindCallback(self, self.OnBtnClickCityList))
  self.gift_btn:SetOnClick(BindCallback(self, self.OnBtnClickGift))
  self.record_btn:SetOnClick(BindCallback(self, self.OnBtnClickRecord))
  self.rank_btn:SetOnClick(BindCallback(self, self.OnBtnClickRank))
  self.rank_btn:SetActive(true)
  self.lock_root = self:AddComponent(UIImage, lock_root_path)
  self.remain_time = self:AddComponent(UIText, remain_time_path)
  self.info_root = self:AddComponent(UIImage, info_root_path)
  self.declareByOther = self:AddComponent(SeasonDeclareOther, other_declare_path)
  self.declareOther = self:AddComponent(SeasonDeclareMy, my_declare_path)
  self.btn_goal = self:AddComponent(UIButton, btn_goal_path)
  self.btn_goal:SetOnClick(BindCallback(self, self.OnBtnClickGotoCity))
  self.btn_goal:SetActive(false)
  self.thePageItem = self.transform:Find(declare_info_path).gameObject
  self.thePageItem:GameObjectCreatePool()
  self.tab_item1:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(1, true)
    end
  end)
  self.tab_item2:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(2, true)
    end
  end)
  self.tab_item1:SetIsOn(true)
  self:OnTabChanged(self.tabIndex or 1, false)
  if LuaEntry.Player:IsInAlliance() then
    local curServerId = LuaEntry.Player:GetCurServerId()
    local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(curServerId)
    SFSNetwork.SendMessage(MsgDefines.AllianceGetCityDeclareTimes, curServerId, kingCityId)
    SFSNetwork.SendMessage(MsgDefines.GetCrossDeclareWarInfo)
  end
end

function SeasonDeclareCityMain:ComponentDestroy()
  self.declareByOther:cleanData()
  self.declareOther:cleanData()
  self.thePageItem:GameObjectRecycleAll()
end

function SeasonDeclareCityMain:OnAllianceDataUpdated()
  local hasAlliance = LuaEntry.Player:IsInAlliance()
  if hasAlliance and self.no_alliance:GetActive() then
    SFSNetwork.SendMessage(MsgDefines.GetCrossDeclareWarInfo)
  end
end

function SeasonDeclareCityMain:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.btn_goal:SetActive(false)
  local hasAlliance = LuaEntry.Player:IsInAlliance()
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if actData then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local seasonStartTime = DataCenter.SeasonDataManager:GetSeasonStartTime()
    local para1 = actData.para1
    local para4 = actData.para4
    local limitTime = actData.limitTime
    local startTime = actData.startTime
    local endTime = actData.endTime
    self.fightStartTime = startTime + toInt(para4) * OneHourTime * 1000
    self.fightEndTime = endTime
    self.activityData = actData
    DataCenter.SeasonDataManager.CrossDeclareWarStartTime = self.fightStartTime
    if curTime < self.fightStartTime then
      self.info_root:SetActive(false)
      self.lock_root:SetActive(hasAlliance)
    elseif curTime < self.fightEndTime then
      self.info_root:SetActive(hasAlliance)
      self.lock_root:SetActive(false)
    else
      self.info_root:SetActive(hasAlliance)
      self.lock_root:SetActive(false)
    end
    self:Update1000MS()
  else
    self.info_root:SetActive(false)
    self.lock_root:SetActive(hasAlliance)
    self.remain_time:SetText("")
  end
  self:OnCrossDeclareWarInfo()
end

function SeasonDeclareCityMain:Update1000MS()
  if self.activityData == nil then
    return
  end
  local deltaTime = 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.fightStartTime then
    deltaTime = self.fightStartTime - curTime
  elseif curTime < self.fightEndTime then
    deltaTime = self.fightEndTime - curTime
  end
  if 0 < deltaTime then
    local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
    self.activity_time:SetText(showTime)
  else
    self.activity_time:SetText("00:00:00")
  end
  if self.fightOpenTime then
    deltaTime = self.fightOpenTime - curTime
    if 0 < deltaTime then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.remain_time:SetText(showTime)
    else
      self.remain_time:SetText("")
    end
  else
    self.remain_time:SetText("")
  end
end

function SeasonDeclareCityMain:OnCrossDeclareWarRedPointUpdate()
  local count1 = SeasonRedPointUtils.GetCrossDeclareWarRedPoint("declareList", true)
  local count2 = SeasonRedPointUtils.GetCrossDeclareWarRedPoint("beDeclareList", true)
  self.red_point1:SetActive(0 < count1)
  self.red_point2:SetActive(0 < count2)
end

function SeasonDeclareCityMain:OnCrossDeclareWarInfo()
  self:OnCrossDeclareWarRedPointUpdate()
  local hasAlliance = LuaEntry.Player:IsInAlliance()
  if not hasAlliance then
    self.info_root:SetActive(false)
    self.lock_root:SetActive(false)
    self.no_alliance:SetActive(true)
    self.btn_join:SetActive(true)
    return
  end
  self.no_alliance:SetActive(false)
  self.btn_join:SetActive(false)
  local data = DataCenter.SeasonDataManager.CrossDeclareWarInfo
  if data == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.data = data
  self.fightOpenTime = data.nextOpenTime or data.curActBeginTime
  self.todayEndTime = data.currEndTime
  if data.isDeclareWarDay and (data.curActBeginTime == nil or curTime >= toInt(data.curActBeginTime)) then
    self.info_root:SetActive(true)
    self.lock_root:SetActive(false)
    self.declareOther:ReInit(self, data.declareList, self.thePageItem, "declareList")
    self.declareByOther:ReInit(self, data.beDeclareList, self.thePageItem, "beDeclareList")
  else
    self.info_root:SetActive(false)
    self.lock_root:SetActive(true)
    self.btn_goal:SetActive(false)
  end
  self:OnTabChanged(self.tabIndex, false)
end

function SeasonDeclareCityMain:OnTabChanged(tabIndex, switchByUser)
  self.tabIndex = tabIndex
  if tabIndex == 1 then
    self.btn_goal:SetActive(false)
    if switchByUser then
      self.declareOther:UpdateRedPoint(1)
    end
  else
    self.btn_goal:SetActive(self.declareByOther.dataCount > 0)
    if switchByUser then
      self.declareOther:UpdateRedPoint(1)
    end
  end
end

function SeasonDeclareCityMain:OnBtnClickJoin()
  if LuaEntry.Player:IsInSourceServer() then
    if LuaEntry.Player:IsFirstJoinAlliance() == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
    end
  else
    UIUtil.ShowTipsId("season_tips166")
  end
end

function SeasonDeclareCityMain:OnBtnClickGotoCity()
  if self.tab_item1:GetIsOn() then
    self.declareOther:OnBtnClickGotoCity()
  else
    self.declareByOther:OnBtnClickGotoCity()
  end
end

function SeasonDeclareCityMain:OnBtnClickCityList()
  SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyCityList)
  UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonDeclareCityList)
end

function SeasonDeclareCityMain:OnBtnClickRecord()
  UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonDeclareCityHistory)
end

function SeasonDeclareCityMain:OnBtnClickRank()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonRank, {anim = true}, {
    rank = 5,
    title = "season_trends_rank_name015",
    nameTxt = "390288",
    scoreTxt = "season_trends_rank_score_name005"
  })
end

function SeasonDeclareCityMain:OnBtnClickGift()
  UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonDeclareCityDetail)
end

function SeasonDeclareCityMain:OnBtnClickInfo()
  if self.activityData ~= nil and self.activityData.story ~= nil then
    local msg = Localization:GetString(self.activityData.story)
    UIUtil.ShowDetail(msg, nil, nil, true, true)
  end
end

return SeasonDeclareCityMain
