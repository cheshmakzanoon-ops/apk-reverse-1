local ActivityInfoData = BaseClass("ActivityInfoData")
local ActivityShowConfigTemplate = require("DataCenter.ActivityListData.ActivityShowConfigTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = ""
  self.noticeStartTime = 0
  self.startTime = 0
  self.endTime = 0
  self.readyTime = 0
  self.rewardTime = 0
  self.activityName = ""
  self.activityId = ""
  self.name = ""
  self.desc = ""
  self.desc_info = ""
  self.advertise_pic = ""
  self.story = ""
  self.activity_pic = ""
  self.type = 0
  self.subType = 0
  self.subViewType = 0
  self.needMainCityLevel = 0
  self.order = 0
  self.extraOrder = 0
  self.extra_priority = ""
  self.extra_priority_tab = nil
  self.forceOrderType = ActForceOrderType.None
  self.reward_goods = {}
  self.rank_reward_list = {}
  self.attack_time_reward_list = {}
  self.preOpenTime = nil
  self.actBossStartTime = 0
  self.actBossEndTime = 0
  self.stopSignUpTime = 0
  self.battleOpenTime = 0
  self.activity_daily = 0
  self.hideInActivityPanel = false
  self.shopId = 0
  self.costGoodsId = 0
  self.is_package = 0
  self.jumpTo = 0
  self.festivalEntrance = 0
  self.festivalEntranceName = ""
  self.festival_icon = ""
  self.isShowCenter = 1
  self.radar_pic_replace_big = ""
  self.radar_pic_replace_small = ""
  self.radar_dig_replace_image = ""
  self.radar_dig_replace_model = ""
  self.para = ""
  self.forSeason = false
  self.lastday_alert = 0
  self.detect_para = ""
  self.subActArr = nil
  self.donateStartTime = nil
  self.isShowOnMainUI = 0
  self.settleTime = nil
  self.festivalEntranceeffect = 0
  self.entrance_change = {}
  self.group_type = 0
  self.group_number = 0
  self.group_priority = 0
  self.isCanDropJump = true
  self.season_activity_bgm = nil
  self.season_activity_amb = nil
end

local function __delete(self)
  self.id = nil
  self.noticeStartTime = nil
  self.startTime = nil
  self.endTime = nil
  self.readyTime = nil
  self.rewardTime = nil
  self.activityName = nil
  self.activityId = nil
  self.name = nil
  self.desc = nil
  self.desc_info = nil
  self.advertise_pic = nil
  self.story = nil
  self.activity_pic = nil
  self.type = nil
  self.subType = nil
  self.subViewType = nil
  self.needMainCityLevel = nil
  self.order = nil
  self.extraOrder = nil
  self.extra_priority = nil
  self.extra_priority_tab = nil
  self.forceOrderType = nil
  self.reward_goods = nil
  self.activity_daily = nil
  self.hideInActivityPanel = nil
  self.shopId = nil
  self.costGoodsId = nil
  self.is_package = nil
  self.jumpTo = nil
  self.festivalEntrance = nil
  self.festivalEntranceName = nil
  self.festival_icon = nil
  self.isShowCenter = nil
  self.radar_pic_replace_big = nil
  self.radar_pic_replace_small = nil
  self.lastday_alert = nil
  self.radar_dig_replace_image = nil
  self.radar_dig_replace_model = nil
  self.detect_para = nil
  self.subActArr = nil
  self.donateStartTime = nil
  self.isShowOnMainUI = nil
  self.settleTime = nil
  self.festivalEntranceeffect = nil
  self.entrance_change = nil
  self.group_type = 0
  self.group_number = 0
  self.group_priority = 0
  self.isCanDropJump = nil
  self.season_activity_bgm = nil
  self.season_activity_amb = nil
end

local function ParseActivityData(self, activity)
  if activity == nil then
    return
  end
  self.forSeason = false
  if activity.id ~= nil then
    self.id = activity.id
    self.activityId = activity.id
  end
  if activity.preTime then
    self.noticeStartTime = activity.preTime
  end
  if activity.startTime ~= nil then
    self.startTime = activity.startTime
  end
  if activity.preOpenTime then
    self.preOpenTime = activity.preOpenTime
  end
  if activity.endTime ~= nil then
    self.endTime = activity.endTime
  end
  if activity.endViewTime ~= nil then
    self.endViewTime = activity.endViewTime
  end
  if activity.lastTime ~= nil then
    self.endTime = activity.lastTime
  end
  if activity.readyTime ~= nil then
    self.readyTime = activity.readyTime
  end
  if activity.rewardTime ~= nil then
    self.rewardTime = activity.rewardTime
  end
  if activity.shopId ~= nil then
    self.shopId = activity.shopId
  end
  if activity.costGoodsId ~= nil then
    self.costGoodsId = activity.costGoodsId
  end
  if activity.activityid ~= nil then
    self.activityId = activity.activityid
  end
  ActivityInfoData.FetchActivityConfigData(self, self.id)
  self.forSeason = false
  self.preSeason = false
  if DataCenter.SeasonDataManager.playerSeasonInfo then
    self.forSeason, self.preSeason, self.seasonType = DataCenter.SeasonDataManager:IsActivityForSeason(self.activityId)
    if self.seasonType == SeasonMapType.NineNation then
      self.seasonSubdivisionType = DataCenter.SeasonDataManager.playerSeasonInfo:GetServerSubdivisionType(false)
    else
      self.seasonSubdivisionType = self.seasonType
    end
  end
  if activity.subActArr ~= nil then
    self.subActArr = activity.subActArr
  end
  if activity.donateStartTime ~= nil then
    self.donateStartTime = activity.donateStartTime
  end
  if activity.settleTime ~= nil then
    self.settleTime = activity.settleTime
  end
  if activity.entrance_change ~= nil then
    self.entrance_change = activity.entrance_change
  end
  if activity.jumpFlag ~= nil then
    self.isCanDropJump = activity.jumpFlag == 1
  end
end

function ActivityInfoData:UpdateActivityInfo()
  if self.activityId then
    self.forSeason, self.preSeason, self.seasonType = DataCenter.SeasonDataManager:IsActivityForSeason(self.activityId)
  end
end

function ActivityInfoData.FetchActivityConfigData(obj, cfgId)
  local tabData = LocalController:instance():getLine(TableName.Activity, toInt(cfgId))
  if tabData ~= nil then
    obj.desc_info = tabData.bannerDes
    obj.type = tonumber(tabData.type)
    obj.timeType = tonumber(tabData.timeType)
    obj.tableInfo = tabData.tableInfo
    obj.subType = tonumber(tabData.tableInfoType)
    obj.subViewType = tonumber(tabData.showUiType) or 0
    obj.advertise_pic = tabData.Advertise_pic
    obj.activity_pic = tabData.banner
    obj.activity_pic_full = tabData.banner_new
    if CommonUtil.IsJapanABTest() and not string.IsNullOrEmpty(tabData.banner_B) then
      obj.activity_pic = tabData.banner_B
    end
    obj.bannerTittle = tabData.bannerTittle
    obj.story = tabData.desc
    obj.season_show_type = toInt(tabData.season_banner_type)
    obj.season_show_icon = tabData.season_activity_banner or tabData.banner
    obj.season_show_icon_full = tabData.season_activity_banner_new
    obj.ppt_show = toInt(tabData.ppt_show)
    obj.plot = tabData.plot
    obj.newStory = tabData.story
    obj.needMainCityLevel = tonumber(tabData.needMainCityLevel) or 0
    obj.order = tabData.priority
    obj.name = tabData.name
    obj.activityName = tabData.name
    obj.list_icon = tabData.icon
    obj.reward_goods = tabData.reward_goods
    obj.para1 = tabData.para1
    obj.para2 = tabData.para2
    obj.para3 = tabData.para3
    obj.para4 = tabData.para4
    obj.para5 = tabData.para5
    obj.para6 = tabData.para6
    obj.preview_time = toInt(tabData.pretime)
    obj.task_type = tabData.task_type
    obj.show_type = tabData.show_type
    obj.limitTime = tabData.limitTime
    obj.activity_tips = tabData.activity_tips
    obj.activity_tips_priority = tonumber(tabData.activity_tips_priority) or 0
    obj.dropInfoDetail = tonumber(tabData.dropInfoDetail) or 0
    obj.extra1 = tabData.extra1
    obj.extra2 = tabData.extra2
    obj.activity_hero = tabData.activity_hero or ""
    obj.extra_priority = tabData.extra_priority
    if LuaEntry.Player.JPUser then
      local newHero = DataCenter.LWSaveGirlManager:GetJPActivityHero(cfgId)
      if not string.IsNullOrEmpty(newHero) then
        obj.activity_hero = newHero
      end
    end
    obj.hero_para = tabData.hero_para or ""
    obj.jumpTo = tabData.jumpTo or ""
    obj.jumpTos = {}
    if not string.IsNullOrEmpty(obj.jumpTo) then
      local jumpTos = string.split(obj.jumpTo, "|")
      for i, v in pairs(jumpTos) do
        obj.jumpTos[#obj.jumpTos + 1] = tonumber(v)
      end
    end
    obj.jumpbtn_desc = tabData.jumpbtn_desc
    obj.festivalEntrance = tonumber(tabData.festivalEntrance) or 0
    obj.festival_icon = tabData.festival_icon or ""
    obj.festivalEntranceName = tabData.festivalEntranceName or ""
    obj.festivalEntranceeffect = tonumber(tabData.festivalEntranceeffect) or 0
    obj.isShowOnMainUI = tonumber(tabData.isShowOnMainUI) or 0
    obj.isShowCenter = tonumber(tabData.is_showcenter) or 1
    local festivalEntranceFunctionOn = tabData.festivalEntranceFunctionOn
    if not string.IsNullOrEmpty(festivalEntranceFunctionOn) then
      local split = string.split(festivalEntranceFunctionOn, ";")
      if LuaEntry.DataConfig:CheckSwitch(split[1]) then
        if not string.IsNullOrEmpty(split[2]) then
          obj.festivalEntrance = tonumber(split[2])
        end
        if not string.IsNullOrEmpty(split[3]) then
          obj.isShowCenter = tonumber(split[3])
        end
        if not string.IsNullOrEmpty(split[4]) then
          obj.order = tonumber(split[4])
        end
      end
    end
    local radar_pic_temp = tabData.radar_pic_replace
    if not string.IsNullOrEmpty(radar_pic_temp) then
      local picArray = string.split(radar_pic_temp, "|")
      if 1 < table.count(picArray) then
        obj.radar_pic_replace_big = picArray[1]
        obj.radar_pic_replace_small = picArray[2]
      end
    end
    local radar_dig_replace = tabData.radar_dig_replace
    if not string.IsNullOrEmpty(radar_dig_replace) then
      local picArray = string.split(radar_dig_replace, "|")
      if 1 < table.count(picArray) then
        obj.radar_dig_replace_image = picArray[1]
        obj.radar_dig_replace_model = picArray[2]
      end
    end
    local groupArr = string.split(obj.show_type or "", ";")
    if #groupArr == 2 then
      obj.tabGroup = groupArr[1]
      obj.tabGroupOrder = tonumber(groupArr[2])
    else
      obj.tabGroup = "372337"
      obj.tabGroupOrder = 10
    end
    obj.activity_daily = string.IsNullOrEmpty(tabData.activity_daily) and 0 or tonumber(tabData.activity_daily)
    local is_package = tabData.is_package
    if string.IsNullOrEmpty(is_package) then
      obj.hideInActivityPanel = false
    else
      obj.is_package = tonumber(is_package)
      obj.hideInActivityPanel = obj.is_package == ActivityEntranceType.Package or obj.is_package == ActivityEntranceType.ThemeActivity or obj.isShowCenter == 0
    end
    if obj.isShowCenter == 0 then
      obj.hideInActivityPanel = true
    end
    obj.lastday_alert = tonumber(tabData.lastday_alert) or 0
    obj.boss_type = tabData.boss_type
    obj.show_config = tonumber(tabData.show_config) or 0
    obj.show_config_temp = nil
    obj.para = tabData.para
    obj.para_1 = tabData.para_1
    obj.para_2 = tabData.para_2
    obj.para_3 = tabData.para_3
    obj.para_4 = tabData.para_4
    obj.para_5 = tabData.para_5
    obj.para_6 = tabData.para_6
    obj.para_7 = tabData.para_7
    obj.para_8 = tabData.para_8
    obj.para_9 = tabData.para_9
    obj.richman_para = tabData.richman_para
    obj.detect_para = tabData.detect_para
    obj.entry_type = tonumber(tabData.entry_type) or 0
    if LuaEntry.Player.JPUser then
      local newPara4 = DataCenter.LWSaveGirlManager:GetJPActivityPara4(cfgId)
      if not string.IsNullOrEmpty(newPara4) then
        obj.para_4 = newPara4
      end
      local newPara6 = DataCenter.LWSaveGirlManager:GetJPActivityPara6(cfgId)
      if not string.IsNullOrEmpty(newPara6) then
        obj.para_6 = newPara6
      end
    end
    if tabData.rankReward then
      obj.rankReward = tabData.rankReward
      local theType = type(tabData.rankReward)
      if theType == "string" then
        obj.rankRewardParam = string.split(tabData.rankReward, "|")
      else
        obj.rankRewardParam = {
          tostring(tabData.rankReward)
        }
      end
    else
      obj.rankRewardParam = nil
    end
    obj.howtoplay = tabData.howtoplay
    if tabData.festival_interface_config then
      obj.festival_interface_config = tonumber(tabData.festival_interface_config)
    end
    obj.reward_change_group = tabData.reward_change_group
    if not string.IsNullOrEmpty(tabData.entrance_change) then
      obj.entrance_change = string.split(tabData.entrance_change, ";")
    else
      obj.entrance_change = nil
    end
    obj.res_down = tabData.res_down or {}
    if not string.IsNullOrEmpty(tabData.login_sound) then
      obj.login_sound = tonumber(tabData.login_sound)
    end
    obj.group_type = checknumber(tabData.group_type)
    obj.group_number = checknumber(tabData.group_number)
    obj.group_priority = checknumber(tabData.group_priority)
    obj.enter_banner_unmirror = checknumber(tabData.enter_banner_unmirror)
    obj.login_sound_bgm = tabData.login_sound_bgm
    if not string.IsNullOrEmpty(tabData.season_activity_bgm) then
      local tmp = tonumber(tabData.season_activity_bgm)
      if tmp and 0 < tmp then
        obj.season_activity_bgm = tmp
      else
        obj.season_activity_bgm = nil
      end
    else
      obj.season_activity_bgm = nil
    end
    if not string.IsNullOrEmpty(tabData.season_activity_amb) then
      local tmp = tonumber(tabData.season_activity_amb)
      if tmp and 0 < tmp then
        obj.season_activity_amb = tmp
      else
        obj.season_activity_amb = nil
      end
    else
      obj.season_activity_amb = nil
    end
  end
end

function ActivityInfoData:GetShowEndTime()
  local result = self.endTime
  if self.rewardTime ~= nil and self.rewardTime > 0 then
    result = self.rewardTime
  end
  if self.endViewTime ~= nil and 0 < self.endViewTime then
    result = self.endViewTime
  end
  return result
end

function ActivityInfoData:GetShowStartTime()
  local result = self.startTime
  if self.readyTime ~= nil and self.readyTime > 0 then
    result = self.readyTime
  end
  return result
end

local function GetValidType(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local mainLv = DataCenter.BuildManager.MainLv
  if mainLv == nil then
    return ActivityValidType.None
  end
  if mainLv >= self.needMainCityLevel then
    local endTime = self:GetShowEndTime()
    local startTime = self:GetShowStartTime()
    if self.type == EnumActivity.MineCave.Type or self.type == EnumActivity.Arena.Type or self.type == EnumActivity.DispatchTreasure.Type or self.type == EnumActivity.DispatchTask.Type or self.type == EnumActivity.SurvivalVipGift.Type then
      return ActivityValidType.Now
    elseif curTime < startTime then
      return ActivityValidType.Later
    elseif curTime > endTime then
      return ActivityValidType.Over
    else
      local canAdd = true
      if self.type == EnumActivity.AllianceOrder.Type then
        local unlock = DataCenter.AllianceBaseDataManager:CheckIfAllianceFuncOpen(AllianceTaskFuncType.AllianceOrder)
        if not unlock then
          canAdd = false
        end
      elseif self.type == EnumActivity.BarterShop.Type or self.type == EnumActivity.BarterShopNotice.Type then
        if self.allianceId and self.allianceId ~= LuaEntry.Player.allianceId then
          canAdd = false
        end
      elseif self.type == EnumActivity.Questionnaire.Type then
        local list = DataCenter.LWQuestionnaireManager:GetAllCanShowQuestionnaireList()
        if table.count(list) == 0 then
          canAdd = false
        end
      end
      if canAdd then
        return ActivityValidType.Now
      end
    end
  end
  return ActivityValidType.None
end

local function IsValid(self)
  return GetValidType(self) == ActivityValidType.Now
end

local function CheckIfIsToEnd(self)
  if self.lastday_alert and self.lastday_alert > 0 then
    local remindStartTime = self.endTime - self.lastday_alert * OneDayTime * 1000
    local curTime = UITimeManager:GetInstance():GetServerTime()
    return remindStartTime < curTime
  else
    return false
  end
end

local function GetShowConfigTemp(self)
  local showTemp = self.show_config_temp
  local show_config = toInt(self.show_config)
  if 0 < show_config then
    if self.show_config_temp == nil then
      local temp = LocalController:instance():getLine(TableName.ACTIVITY_SHOW_CONFIG, show_config)
      if temp then
        self.show_config_temp = ActivityShowConfigTemplate.New()
        self.show_config_temp:InitData(temp)
      end
    end
    showTemp = self.show_config_temp
  end
  return showTemp
end

local function IsActivityForSeason(self)
  return self.forSeason
end

local function RefreshExtraOrderData(self)
  self.extraOrder = self.order
  if self.extra_priority_tab == nil then
    if not string.IsNullOrEmpty(self.extra_priority) then
      self.extra_priority_tab = string.string2array_num(self.extra_priority, "|", ";")
    else
      self.extra_priority_tab = {}
    end
  end
  if #self.extra_priority_tab > 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local startTime = self.startTime
    local curDay = math.floor((curTime - startTime) / (OneDayTime * 1000))
    for i, v in ipairs(self.extra_priority_tab) do
      if #v == 2 then
        local day = v[1]
        local order = v[2]
        if day > curDay + 1 then
          break
        end
        self.extraOrder = order
      end
    end
  end
end

local function GetFirstActiveJumpTo(self)
  local jumpTos = self.jumpTos
  if jumpTos and 0 < #jumpTos then
    for i = 1, #jumpTos do
      local id = jumpTos[i]
      if 0 < id then
        local actData = DataCenter.ActivityListDataManager:GetActivityDataById(id)
        if actData and actData:IsValid() then
          return id
        end
      end
    end
  end
  return 0
end

function ActivityInfoData:Description()
  local time = UITimeManager:GetInstance()
  local sb = StringBuilder.New()
  sb:Append(string.format("%s(id:%s),\231\177\187\229\158\139:%s,\230\151\182\233\151\180:%s ~ %s", self.activityName and Localization:GetString(self.activityName) or "???", self.id, self.type, time:TimeStampToTimeForServer(self:GetShowStartTime()), time:TimeStampToTimeForServer(self:GetShowEndTime())))
  return sb:ToString()
end

function ActivityInfoData:GetFestivalInterfaceCfgId()
  return self.festival_interface_config or 0
end

function ActivityInfoData:GetRewardChangeGroup()
  return checknumber(self.reward_change_group)
end

function ActivityInfoData:CanShowNewTag()
  return false
end

function ActivityInfoData:HasLoginSound()
  return self.login_sound and self.login_sound > 0
end

function ActivityInfoData:PlayLoginSound()
  if self:HasLoginSound() then
    DataCenter.LWSoundManager:PlaySound(self.login_sound, false)
  end
end

function ActivityInfoData:IsNeedCheckDownloadRes()
  return not table.IsNullOrEmpty(self.res_down)
end

function ActivityInfoData:GetDownloadResPackConfigIdList()
  return self.res_down
end

local function HasSeasonActivityBGM(self)
  return self.season_activity_bgm ~= nil and self.season_activity_bgm > 0
end

local function HasSeasonActivityAmb(self)
  return self.season_activity_amb ~= nil and self.season_activity_amb > 0
end

ActivityInfoData.__init = __init
ActivityInfoData.__delete = __delete
ActivityInfoData.ParseActivityData = ParseActivityData
ActivityInfoData.IsValid = IsValid
ActivityInfoData.GetValidType = GetValidType
ActivityInfoData.CheckIfIsToEnd = CheckIfIsToEnd
ActivityInfoData.GetShowConfigTemp = GetShowConfigTemp
ActivityInfoData.IsActivityForSeason = IsActivityForSeason
ActivityInfoData.GetFirstActiveJumpTo = GetFirstActiveJumpTo
ActivityInfoData.RefreshExtraOrderData = RefreshExtraOrderData
ActivityInfoData.HasSeasonActivityBGM = HasSeasonActivityBGM
ActivityInfoData.HasSeasonActivityAmb = HasSeasonActivityAmb
return ActivityInfoData
