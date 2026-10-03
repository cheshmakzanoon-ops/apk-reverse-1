local UIActivityCenterCommonUtil = BaseClass("UIActivityCenterCommonUtil")
local UnityTextMeshProEx = typeof(CS.TextMeshProUGUIEx)

local function __init(self)
end

local function __delete(self)
end

local function SetTopViewColor(titleObj, descObj, timeObj, showTemp)
  if showTemp == nil then
    return
  end
  local title_text
  if not IsNull(titleObj) then
    title_text = titleObj:GetComponent(UnityTextMeshProEx)
    if IsNull(title_text) then
      title_text = nil
    end
  end
  local desc_text, desc_outline, desc_shadow
  if not IsNull(descObj) then
    desc_text = descObj:GetComponent(typeof(CS.UnityEngine.UI.Text))
    desc_outline = descObj:GetComponent(typeof(CS.UnityEngine.UI.Outline))
    desc_shadow = descObj:GetComponent(typeof(CS.UnityEngine.UI.Shadow))
  end
  local time_text, time_outline, time_shadow
  if timeObj then
    time_text = timeObj:GetComponent(typeof(CS.UnityEngine.UI.Text))
    time_outline = timeObj:GetComponent(typeof(CS.UnityEngine.UI.Outline))
    time_shadow = timeObj:GetComponent(typeof(CS.UnityEngine.UI.Shadow))
    time_text = time_text or timeObj:GetComponent(UnityTextMeshProEx)
  end
  local targetColor = {
    255,
    255,
    255,
    255
  }
  targetColor = {
    255,
    255,
    255,
    255
  }
  if #showTemp.title_color_tab == 4 then
    targetColor = showTemp.title_color_tab
    if title_text then
      local color = Color.New(targetColor[1] / 255, targetColor[2] / 255, targetColor[3] / 255, targetColor[4] / 255)
      title_text.color = color
    end
  end
  if not string.IsNullOrEmpty(showTemp.title_material) and title_text then
    UIManager:GetInstance():SetNewTMProFontMaterial(string.format(LoadPath.TMPFontMaterialPath, showTemp.title_material), function(newMat)
      if not IsNull(title_text) then
        title_text:SetNewMaterial(newMat)
      end
    end)
  end
  targetColor = {
    30,
    3,
    6,
    255
  }
  if #showTemp.title_stroke_color_tab == 4 then
    targetColor = showTemp.title_stroke_color_tab
  end
  targetColor = {
    30,
    3,
    6,
    255
  }
  if #showTemp.title_shadow_color_tab == 4 then
    targetColor = showTemp.title_shadow_color_tab
  end
  if showTemp.title_size > 0 and not IsNull(title_text) then
    title_text.fontSize = showTemp.title_size
  end
  targetColor = {
    255,
    255,
    255,
    255
  }
  if #showTemp.desc_color_tab == 4 then
    targetColor = showTemp.desc_color_tab
    if not IsNull(desc_text) then
      desc_text:Set_color(targetColor[1] / 255, targetColor[2] / 255, targetColor[3] / 255, targetColor[4] / 255)
    end
  end
  targetColor = {
    203,
    80,
    6,
    255
  }
  if #showTemp.desc_stroke_color_tab == 4 then
    targetColor = showTemp.desc_stroke_color_tab
    if not IsNull(desc_outline) then
      desc_outline:Set_color(targetColor[1] / 255, targetColor[2] / 255, targetColor[3] / 255, targetColor[4] / 255)
    end
  end
  targetColor = {
    203,
    80,
    6,
    255
  }
  if #showTemp.desc_shadow_color == 4 then
    targetColor = showTemp.desc_shadow_color
    if not IsNull(desc_shadow) then
      desc_shadow:Set_color(targetColor[1] / 255, targetColor[2] / 255, targetColor[3] / 255, targetColor[4] / 255)
    end
  end
  targetColor = {
    255,
    255,
    255,
    255
  }
  if #showTemp.time_color_tab == 4 then
    targetColor = showTemp.time_color_tab
    if not IsNull(time_text) then
      time_text:Set_color(targetColor[1] / 255, targetColor[2] / 255, targetColor[3] / 255, targetColor[4] / 255)
    end
  end
  targetColor = {
    8,
    8,
    8,
    255
  }
  if #showTemp.time_stroke_color_tab == 4 then
    targetColor = showTemp.time_stroke_color_tab
    if not IsNull(time_outline) then
      time_outline:Set_color(targetColor[1] / 255, targetColor[2] / 255, targetColor[3] / 255, targetColor[4] / 255)
    end
  end
  targetColor = {
    8,
    8,
    8,
    255
  }
  if #showTemp.time_shadow_color_tab == 4 then
    targetColor = showTemp.time_shadow_color_tab
    if not IsNull(time_shadow) then
      time_shadow:Set_color(targetColor[1] / 255, targetColor[2] / 255, targetColor[3] / 255, targetColor[4] / 255)
    end
  end
end

function UIActivityCenterCommonUtil.GetActivityOpenRoundTimeType120(activityInfo)
  local oneDayTimeMS = 86400000
  local openServerTime = LuaEntry.Player.openServerTime
  local openServerDayZeroTimeMS = UITimeManager:GetInstance():GetTodayZeroServerTime(openServerTime / 1000) * 1000
  local initDayZeroTimeMS = openServerDayZeroTimeMS + checknumber(activityInfo.para1) * oneDayTimeMS
  local initDayZeroTimeWeekdayIndex = UITimeManager:GetInstance():GetWeekdayIndex(initDayZeroTimeMS)
  local requireWeekdayIndex = checknumber(activityInfo.para2)
  if requireWeekdayIndex <= 0 then
    return -1
  end
  local weekdayDelta = 0
  if initDayZeroTimeWeekdayIndex <= requireWeekdayIndex then
    weekdayDelta = requireWeekdayIndex - initDayZeroTimeWeekdayIndex
  else
    weekdayDelta = 7 - initDayZeroTimeWeekdayIndex + requireWeekdayIndex
  end
  local firstRoundDayZeroTimeMS = initDayZeroTimeMS + weekdayDelta * oneDayTimeMS
  local startTimeDelayMS = checknumber(activityInfo.limitTime) * oneDayTimeMS + checknumber(activityInfo.para4) * oneDayTimeMS * 7
  local curRoundStartTime = activityInfo:GetShowStartTime()
  local curRound = (curRoundStartTime - firstRoundDayZeroTimeMS) / startTimeDelayMS
  curRound = math.floor(curRound) + 1
  return curRound
end

function UIActivityCenterCommonUtil.GetActivityOpenRoundTimeType200(activityInfo)
  if checknumber(activityInfo.para2) == -1 or checknumber(activityInfo.para2) == 1 then
    return 1
  end
  local oneDayTimeMS = 86400000
  local curSeasonDay = SeasonUtil.GetSeasonDay()
  local initSeasonDay = checknumber(activityInfo.para1)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local curDayZeroTimeMS = UITimeManager:GetInstance():GetTodayZeroServerTime(curTime / 1000) * 1000
  local firstRoundDayZeroTimeMS = curDayZeroTimeMS + (initSeasonDay - curSeasonDay) * oneDayTimeMS
  local startTimeDelayMS = checknumber(activityInfo.limitTime) * oneDayTimeMS + checknumber(activityInfo.para3) * oneDayTimeMS
  local curRoundStartTime = activityInfo:GetShowStartTime()
  local curRound = (curRoundStartTime - firstRoundDayZeroTimeMS) / startTimeDelayMS
  curRound = math.floor(curRound) + 1
  return curRound
end

function UIActivityCenterCommonUtil.GetGetFestivalInterfaceCfgByActivity(activityId)
  if not activityId then
    return nil
  end
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if not activityInfo then
    return nil
  end
  local festivalInterfaceCfgId = activityInfo:GetFestivalInterfaceCfgId()
  local lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, festivalInterfaceCfgId)
  return lineData
end

function UIActivityCenterCommonUtil.GetActivityTabGroupCfg(activityId)
  local ret = {}
  local tabSelectBgDefaultPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_yeqian_erji_1.png"
  local tabUnselectBgDefaultPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_yeqian_erji_2.png"
  ret.selectPath = tabSelectBgDefaultPath
  ret.unSelectPath = tabUnselectBgDefaultPath
  local tabTextSelectDefaultColor = Color.white
  local tabTextUnselectDefaultColor = Color.New(1.0, 1.0, 1.0, 0.49411764705882355)
  ret.selectColor = tabTextSelectDefaultColor
  ret.unSelectColor = tabTextUnselectDefaultColor
  local lineData = UIActivityCenterCommonUtil.GetGetFestivalInterfaceCfgByActivity(activityId)
  if not lineData or string.IsNullOrEmpty(lineData.board_page) then
    return ret
  end
  local configList = string.split(lineData.board_page, "|")
  if 2 <= #configList then
    local activityThemPath = "Assets/Main/Sprites/UI/ActivityThemeSkin/%s"
    ret.selectPath = DataCenter.ActivityListDataManager:GetActivityModLoadPath(activityThemPath, configList[1])
    ret.unSelectPath = DataCenter.ActivityListDataManager:GetActivityModLoadPath(activityThemPath, configList[2])
  end
  if 4 <= #configList then
    local tmpColor255 = string.string2array_i_oneSep(configList[3], ",")
    ret.selectColor = Color.New(tmpColor255[1] / 255, tmpColor255[2] / 255, tmpColor255[3] / 255, tmpColor255[4] / 255)
    tmpColor255 = string.string2array_i_oneSep(configList[4], ",")
    ret.unSelectColor = Color.New(tmpColor255[1] / 255, tmpColor255[2] / 255, tmpColor255[3] / 255, tmpColor255[4] / 255)
  end
  return ret
end

UIActivityCenterCommonUtil.__init = __init
UIActivityCenterCommonUtil.__delete = __delete
UIActivityCenterCommonUtil.SetTopViewColor = SetTopViewColor
return UIActivityCenterCommonUtil
