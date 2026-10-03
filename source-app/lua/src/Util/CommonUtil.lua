local CommonUtil = {}
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local Vibrator = CS.Vibrator
local PlayerPrefs = CS.UnityEngine.PlayerPrefs
local LastVibratorTime = 0
local VibratorDuringTime = 200
local IsArabicAutoMirrorOpenFlag
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")

local function SendErrorMessageToServer(curTime, delayTime, errorMsg)
  if LuaEntry.DataConfig:CheckSwitch("bug_report") == true then
    SFSNetwork.SendMessage(MsgDefines.ClientLog, curTime, delayTime, errorMsg)
  end
end

local function GetTimeDiamondCost(remainSec, useK4)
  if remainSec == nil or remainSec <= 0 then
    return 0
  end
  if remainSec < 1 then
    return 1
  end
  local costNum = 1
  local k1 = LuaEntry.DataConfig:TryGetNum("cd_gold", "k1")
  local k2 = LuaEntry.DataConfig:TryGetNum("cd_gold", "k2")
  local k3 = LuaEntry.DataConfig:TryGetNum("cd_gold", "k3")
  costNum = remainSec / (k1 * (remainSec / 3600) ^ (k2 / 100))
  costNum = math.ceil(costNum)
  if costNum <= 0 then
    costNum = 1
  end
  return costNum
end

local function GetResourceDescriptionByType(resourceType)
  local template = DataCenter.ResourceTemplateManager:GetResourceTemplate(resourceType)
  if template ~= nil then
    return CS.GameEntry.Localization:GetString(template.description)
  end
  return ""
end

local function GetResOrItemCount(resOrItemId)
  if resOrItemId > ResourceType.None and resOrItemId < ResourceType.Max then
    if resOrItemId == ResourceType.Gold then
      return LuaEntry.Player.gold
    end
    return LuaEntry.Resource:GetCntByResType(resOrItemId)
  end
  return DataCenter.ItemData:GetItemCount(resOrItemId)
end

local function GetResOrItemIcon(resOrItemId)
  resOrItemId = tonumber(resOrItemId)
  if resOrItemId > ResourceType.None and resOrItemId < ResourceType.Max then
    assert(DataCenter.ResourceManager:GetResourceIconByType(resOrItemId) ~= nil, "GetResOrItemIcon res icon is nil! resOrItemId:" .. tostring(resOrItemId))
    return DataCenter.ResourceManager:GetResourceIconByType(resOrItemId) or ""
  end
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(resOrItemId)
  assert(template ~= nil, "GetResOrItemIcon template is nil! resOrItemId:" .. tostring(resOrItemId))
  return string.format(LoadPath.ItemPath, template and template.icon or "")
end

local function GetBuildBaseType(id)
  return id - id % BuildLevelCap
end

local function GetBuildLv(id)
  return id % BuildLevelCap
end

local function GetScienceBaseType(id)
  return id - id % ScienceLevelCap
end

local function GetScienceLv(id)
  return id % ScienceLevelCap
end

DetectEventColor = {
  DETECT_EVENT_WHITE = 1,
  DETECT_EVENT_GREEN = 2,
  DETECT_EVENT_BLUE = 3,
  DETECT_EVENT_PURPLE = 4,
  DETECT_EVENT_ORANGE = 5,
  DETECT_EVENT_GOLDEN = 6
}

local function GetDetectEventQualityColor(quality)
  if quality == DetectEventColor.DETECT_EVENT_WHITE then
    return DetectEventWhiteColor
  elseif quality == DetectEventColor.DETECT_EVENT_GREEN then
    return DetectEventGreenColor
  elseif quality == DetectEventColor.DETECT_EVENT_BLUE then
    return DetectEventBlueColor
  elseif quality == DetectEventColor.DETECT_EVENT_PURPLE then
    return DetectEventPurpleColor
  elseif quality == DetectEventColor.DETECT_EVENT_ORANGE then
    return DetectEventOrangeColor
  elseif quality == DetectEventColor.DETECT_EVENT_GOLDEN then
    return DetectEventGoldenColor
  end
  return DetectEventWhiteColor
end

local function GetDetectEventQualityName(quality)
  if quality == DetectEventColor.DETECT_EVENT_WHITE then
    return GameDialogDefine.QUALITY_NAME_WHITE
  elseif quality == DetectEventColor.DETECT_EVENT_GREEN then
    return GameDialogDefine.QUALITY_NAME_GREEN
  elseif quality == DetectEventColor.DETECT_EVENT_BLUE then
    return GameDialogDefine.QUALITY_NAME_BLUE
  elseif quality == DetectEventColor.DETECT_EVENT_PURPLE then
    return GameDialogDefine.QUALITY_NAME_PURPLE
  elseif quality == DetectEventColor.DETECT_EVENT_ORANGE then
    return GameDialogDefine.QUALITY_NAME_ORANGE
  elseif quality == DetectEventColor.DETECT_EVENT_GOLDEN then
    return GameDialogDefine.QUALITY_NAME_GOLDEN
  end
  logErrorWithTag("GetQualityName", "Undefined quality_" .. quality)
  return ""
end

local function GetDirByPos(lastPos, curPos, nextPos)
  if (lastPos == nil or lastPos.x == 0 and lastPos.y == 0) and (nextPos == nil or nextPos.x == 0 and nextPos.y == 0) then
    return ConnectDirection.Right, ConnectDirection.LeftToRight
  elseif lastPos == nil or lastPos.x == 0 and lastPos.y == 0 then
    if nextPos.x == curPos.x then
      if nextPos.y < curPos.y then
        return ConnectDirection.Down, ConnectDirection.TopToDown
      else
        return ConnectDirection.Top, ConnectDirection.DownToTop
      end
    elseif nextPos.x < curPos.x then
      return ConnectDirection.Left, ConnectDirection.RightToLeft
    else
      return ConnectDirection.Right, ConnectDirection.LeftToRight
    end
  elseif nextPos == nil or nextPos.x == 0 and nextPos.y == 0 then
    if lastPos.x == curPos.x then
      if lastPos.y > curPos.y then
        return ConnectDirection.Top, ConnectDirection.TopToDown
      else
        return ConnectDirection.Down, ConnectDirection.DownToTop
      end
    elseif lastPos.x > curPos.x then
      return ConnectDirection.Right, ConnectDirection.RightToLeft
    else
      return ConnectDirection.Left, ConnectDirection.LeftToRight
    end
  elseif lastPos.x == curPos.x then
    if lastPos.y > curPos.y then
      if nextPos.x == curPos.x then
        if nextPos.y < curPos.y then
          return ConnectDirection.TopToDown, ConnectDirection.TopToDown
        else
          return ConnectDirection.Top, ConnectDirection.DownToTop
        end
      elseif nextPos.x > curPos.x then
        return ConnectDirection.TopToRight, ConnectDirection.TopToRight
      else
        return ConnectDirection.TopToLeft, ConnectDirection.TopToLeft
      end
    elseif nextPos.x == curPos.x then
      if nextPos.y > curPos.y then
        return ConnectDirection.DownToTop, ConnectDirection.DownToTop
      else
        return ConnectDirection.Down, ConnectDirection.TopToDown
      end
    elseif nextPos.x > curPos.x then
      return ConnectDirection.DownToRight, ConnectDirection.DownToRight
    else
      return ConnectDirection.DownToLeft, ConnectDirection.DownToLeft
    end
  elseif lastPos.x > curPos.x then
    if nextPos.y == curPos.y then
      if nextPos.x < curPos.x then
        return ConnectDirection.RightToLeft, ConnectDirection.RightToLeft
      else
        return ConnectDirection.Right, ConnectDirection.LeftToRight
      end
    elseif nextPos.y > curPos.y then
      return ConnectDirection.RightToTop, ConnectDirection.RightToTop
    else
      return ConnectDirection.RightToDown, ConnectDirection.RightToDown
    end
  elseif nextPos.y == curPos.y then
    if nextPos.x > curPos.x then
      return ConnectDirection.LeftToRight, ConnectDirection.LeftToRight
    else
      return ConnectDirection.Left, ConnectDirection.RightToLeft
    end
  elseif nextPos.y > curPos.y then
    return ConnectDirection.LeftToTop, ConnectDirection.LeftToTop
  else
    return ConnectDirection.LeftToDown, ConnectDirection.LeftToDown
  end
  return ConnectDirection.Right, ConnectDirection.LeftToRight
end

local function CheckIsScienceEnough(scienceId, scienceLv)
  if scienceId == nil or scienceLv == nil then
    return true
  else
    return scienceLv <= DataCenter.ScienceManager:GetScienceLevel(scienceId)
  end
end

local function CheckIsBuildEnough(buildId, buildLv)
  if buildId == nil or buildLv == nil then
    return true
  else
    return DataCenter.BuildManager:IsExistBuildByTypeLv(buildId, buildLv)
  end
end

local function CheckIsResourceGoodsEnough(needGoodsId, needGoodsNum)
  if needGoodsId == nil or needGoodsNum == nil then
    return true
  else
    local cnt = 0
    local item = DataCenter.ResourceItemDataManager:GetItemDataByItemId(needGoodsId)
    if item ~= nil then
      cnt = item.number
    end
    return needGoodsNum <= cnt
  end
end

local function CheckIsResourceEnough(needResourceType, needResourceNum)
  if needResourceType == nil or needResourceNum == nil then
    return true
  else
    local totalNum = needResourceNum
    return totalNum <= LuaEntry.Resource:GetCntByResType(needResourceType)
  end
end

local function GetResGoldByType(type, num)
  local ret = 0
  local a = 0
  local b = 0
  local c = 0
  local d = 0
  local k = 0
  local cost_k1 = LuaEntry.DataConfig:TryGetNum("resource_cost", "k1")
  local cost_k2 = LuaEntry.DataConfig:TryGetNum("resource_cost", "k2")
  local cost_k3 = LuaEntry.DataConfig:TryGetNum("resource_cost", "k3")
  local cost_k4 = LuaEntry.DataConfig:TryGetNum("resource_cost", "k4")
  if type == ResourceType.Oil then
    d = LuaEntry.DataConfig:TryGetNum("resource_num3", "k2")
  elseif type == ResourceType.Metal then
    d = LuaEntry.DataConfig:TryGetNum("resource_num3", "k4")
  elseif type == ResourceType.Electricity then
    d = LuaEntry.DataConfig:TryGetNum("resource_num3", "k5")
  elseif type == ResourceType.Food then
    d = LuaEntry.DataConfig:TryGetNum("resource_num3", "k6")
    k = LuaEntry.DataConfig:TryGetNum("resource_num3", "k7")
  elseif type == ResourceType.Water then
    d = LuaEntry.DataConfig:TryGetNum("resource_num3", "k8")
  elseif type == ResourceType.Wood then
    d = LuaEntry.DataConfig:TryGetNum("resource_num3", "k9")
  end
  local curNum = num * d
  if cost_k1 >= curNum then
    a = LuaEntry.DataConfig:TryGetNum("resource_num1", "k1")
    b = LuaEntry.DataConfig:TryGetNum("resource_num1", "k2")
    c = LuaEntry.DataConfig:TryGetNum("resource_num1", "k3")
  elseif cost_k1 < curNum and cost_k2 >= curNum then
    a = LuaEntry.DataConfig:TryGetNum("resource_num1", "k4")
    b = LuaEntry.DataConfig:TryGetNum("resource_num1", "k5")
    c = LuaEntry.DataConfig:TryGetNum("resource_num1", "k6")
  elseif cost_k2 < curNum and cost_k3 >= curNum then
    a = LuaEntry.DataConfig:TryGetNum("resource_num1", "k7")
    b = LuaEntry.DataConfig:TryGetNum("resource_num1", "k8")
    c = LuaEntry.DataConfig:TryGetNum("resource_num1", "k9")
  elseif cost_k3 < curNum and cost_k4 >= curNum then
    a = LuaEntry.DataConfig:TryGetNum("resource_num1", "k10")
    b = LuaEntry.DataConfig:TryGetNum("resource_num1", "k11")
    c = LuaEntry.DataConfig:TryGetNum("resource_num1", "k12")
  elseif cost_k4 < curNum then
    a = LuaEntry.DataConfig:TryGetNum("resource_num2", "k1")
    b = LuaEntry.DataConfig:TryGetNum("resource_num2", "k2")
    c = LuaEntry.DataConfig:TryGetNum("resource_num2", "k3")
  end
  if type == ResourceType.Food then
    ret = math.floor(Mathf.Pow(curNum, b) * k * a + c)
  else
    ret = math.floor(Mathf.Pow(curNum, b) * a + c)
  end
  ret = math.max(ret, 1)
  return ret
end

local function GetNameByParams(msgId, paramList)
  if msgId == nil or msgId == "" then
    return ""
  end
  local num = 0
  local text = ""
  if paramList ~= nil then
    num = #paramList
  end
  if num < 1 then
    text = CS.GameEntry.Localization:GetString(msgId)
  elseif num == 1 then
    text = CS.GameEntry.Localization:GetString(msgId, paramList[1])
  elseif num == 2 then
    text = CS.GameEntry.Localization:GetString(msgId, paramList[1], paramList[2])
  elseif num == 3 then
    text = CS.GameEntry.Localization:GetString(msgId, paramList[1], paramList[2], paramList[3])
  elseif num == 4 then
    text = CS.GameEntry.Localization:GetString(msgId, paramList[1], paramList[2], paramList[3], paramList[4])
  elseif num == 5 then
    text = CS.GameEntry.Localization:GetString(msgId, paramList[1], paramList[2], paramList[3], paramList[4], paramList[5])
  elseif num == 6 then
    text = CS.GameEntry.Localization:GetString(msgId, paramList[1], paramList[2], paramList[3], paramList[4], paramList[5], paramList[6])
  elseif num == 7 then
    text = CS.GameEntry.Localization:GetString(msgId, paramList[1], paramList[2], paramList[3], paramList[4], paramList[5], paramList[6], paramList[7])
  elseif num == 8 then
    text = CS.GameEntry.Localization:GetString(msgId, paramList[1], paramList[2], paramList[3], paramList[4], paramList[5], paramList[6], paramList[7], paramList[8])
  end
  return text
end

local function GetResourceNameByType(resourceType)
  return DataCenter.ResourceManager:GetResourceNameByType(resourceType)
end

local function CopyTextToClipboard(content)
  local te = CS.UnityEngine.TextEditor()
  te.text = content
  te:OnFocus()
  te:Copy()
end

local function GetNodeActivePaths(obj, parentName, tblActive, tblInactive)
  local fullName
  if string.IsNullOrEmpty(parentName) then
    fullName = obj.name
  else
    fullName = parentName .. "/" .. obj.name
  end
  if obj.activeSelf then
    if tblActive then
      tblActive[#tblActive + 1] = fullName
    end
  elseif tblInactive then
    tblInactive[#tblInactive + 1] = fullName
  end
  local nodeRoot = obj.transform
  local childCount = nodeRoot.childCount
  for i = 0, childCount - 1 do
    local child = nodeRoot:GetChild(i).gameObject
    GetNodeActiveNames(child, fullName, tbl)
  end
end

local function SetNodeActivePaths(obj, tblActive, tblInactive)
  for k, v in ipairs(tblActive) do
    local t = obj.transform:Find(v)
    if t then
      t:SetActive(true)
    end
  end
  for k, v in ipairs(tblInactive) do
    local t = obj.transform:Find(v)
    if t then
      t:SetActive(false)
    end
  end
end

local function GetItemGoldByItemId(itemId, num)
  local ret = 0
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  if goods ~= nil and 0 < goods.price then
    local own = 0
    local item = DataCenter.ItemData:GetItemById(itemId)
    if item ~= nil then
      own = item.count
    end
    if num > own then
      ret = goods.price * (num - own)
    end
  end
  ret = math.max(ret, 1)
  return ret
end

local function GetValueWithLocalType(value, localType)
  if localType == EffectLocalType.Num then
    return string.GetFormattedSeperatorNum(value)
  elseif localType == EffectLocalType.Time then
    return UITimeManager:GetInstance():SecondToFmtString(value)
  elseif localType == EffectLocalType.Percent then
    return value .. "%"
  elseif localType == EffectLocalType.Dialog then
    return Localization:GetString(value)
  elseif localType == EffectLocalType.PositiveNum then
    return "+" .. string.GetFormattedSeperatorNum(value)
  elseif localType == EffectLocalType.NegativeNum then
    return "-" .. string.GetFormattedSeperatorNum(value)
  elseif localType == EffectLocalType.PositiveTime then
    return "+" .. UITimeManager:GetInstance():SecondToFmtString(value)
  elseif localType == EffectLocalType.NegativeTime then
    return "-" .. UITimeManager:GetInstance():SecondToFmtString(value)
  elseif localType == EffectLocalType.PositivePercent then
    return "+" .. value .. "%"
  elseif localType == EffectLocalType.NegativePercent then
    return "-" .. value .. "%"
  else
    return value
  end
end

local function GetEffectReasonDesc(reasonType)
  if reasonType == EffectReasonType.Science then
    return 100025
  elseif reasonType == EffectReasonType.Building then
    return 310148
  elseif reasonType == EffectReasonType.Hero then
    return 100275
  elseif reasonType == EffectReasonType.VIP then
    return 320293
  elseif reasonType == EffectReasonType.MONTH_CARD then
    return 320243
  elseif reasonType == EffectReasonType.PLAYER_LEVEL then
    return 120987
  elseif reasonType == EffectReasonType.Hero_Station then
    return 110179
  elseif reasonType == EffectReasonType.Science_Activity then
    return 100374
  elseif reasonType == EffectReasonType.Alliance_Science then
    return 390148
  elseif reasonType == EffectReasonType.World_Alliance_City then
    return 300724
  elseif reasonType == EffectReasonType.Status then
    return 100162
  elseif reasonType == EffectReasonType.Tank then
    return 131200
  elseif reasonType == EffectReasonType.Career then
    return 395000
  elseif reasonType == EffectReasonType.Alliance_Career then
    return 395003
  else
    return 100374
  end
end

local function PlayGameBgMusic()
  local guideBgmName = DataCenter.GuideManager:GetGuideBgmName()
  if guideBgmName ~= nil and guideBgmName ~= "" then
  elseif DataCenter.LWBGMManager:CheckHaveCanPlayBGMInSource() then
    DataCenter.LWBGMManager:TryPlayBGM()
  else
    DataCenter.LWBGMManager:ClearStopTimer()
    DataCenter.LWBGMManager:ClearData()
    local curScene = CS.SceneManager.CurrSceneID
    if BattleFieldUtil.InBattleField() then
      CS.GameEntry.Sound:StopAMBSound()
      local mgr = BattleFieldUtil.GetMgrActive()
      if mgr ~= nil and mgr.PrepareBGM then
        mgr:PrepareBGM()
      end
    elseif DataCenter.LWBattleManager:CanPlayBgm() then
      CS.GameEntry.Sound:StopAMBSound()
      DataCenter.LWBattleManager:PlayBgm()
    elseif curScene == SceneManagerSceneID.World then
      SceneUtils.PlayWorldBGM()
      SceneUtils.PlayWorldAMBSound()
    elseif not FIRST_TIME_ENTER_CITY then
      SceneUtils.PlayCityBGM()
      SceneUtils.PlayCityAMBSound()
    else
      SceneUtils.PlayCityBGM()
      SceneUtils.PlayCityAMBSound()
    end
    DataCenter.LWBattleSoundManager:CheckAndPlaySound()
  end
end

local function ClearGameBgMusicData()
  DataCenter.DecorationBGMManager:StopBGMData()
  DataCenter.LWBGMManager:ClearData()
end

local function VibratorLightImpact()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local durTime = curTime - LastVibratorTime
  if durTime >= VibratorDuringTime then
    LastVibratorTime = curTime
    Vibrator.LightImpact()
  end
end

local function GetAllProxy()
  local list = {}
  if CS.CommonUtils.IsDebug() then
    local oneData = {}
    oneData.lineName = "direct"
    oneData.lineUrl = CS.GameEntry.Network.GameServerUrl
    oneData.port = CS.GameEntry.Network.GameServerPort
    table.insert(list, oneData)
  else
    local port = CS.GameEntry.Network.GameServerPort
    for i = 1, #ProxyList do
      local oneData = {}
      oneData.lineName = ProxyName[i]
      oneData.lineUrl = ProxyList[i]
      oneData.port = port
      table.insert(list, oneData)
    end
  end
  return list
end

local function GetPortId(zoneId)
  return 17000 + tonumber(zoneId)
end

local function GetOwnCountByCommonCostType(needType, itemId)
  if needType == CommonCostNeedType.Resource then
    return LuaEntry.Resource:GetCntByResType(itemId)
  elseif needType == CommonCostNeedType.ResourceItem then
    return DataCenter.ResourceItemDataManager:GetCountByItemId(itemId)
  elseif needType == CommonCostNeedType.Goods then
    return DataCenter.ItemData:GetItemCount(itemId)
  end
end

local function MarchErrorLog(message)
  local errCode = message.errorCode
  if errCode ~= nil then
    if errCode == "110274" then
      local uuid = message.formationUuid
      if uuid ~= nil then
        SFSNetwork.SendMessage(MsgDefines.FormationMarchTime, uuid)
      end
    elseif errCode == "season5_reoccupy_tips01" and message.coolEndTime then
      local deltaTime = message.coolEndTime - UITimeManager:GetInstance():GetServerSeconds()
      local restTimeStr = UITimeManager:GetInstance():GetFormattedTime(deltaTime)
      UIUtil.ShowTips(Localization:GetString("season5_reoccupy_tips01", restTimeStr))
    elseif errCode == "season_builders_alliance_tips_45" and message.leftMS then
      local leftMS = UITimeManager:GetInstance():MilliSecondToFmtString(message.leftMS)
      UIUtil.ShowTips(Localization:GetString(errCode, leftMS))
    elseif errCode == "s5_map_ui_30" and message.needTime then
      local leftMS = UITimeManager:GetInstance():MilliSecondToFmtString(message.needTime)
      UIUtil.ShowTips(Localization:GetString(errCode, leftMS))
    elseif errCode == "season_s5_deposit_max01" then
      UIUtil.ShowTips(Localization:GetString(errCode, message.currNum, message.maxNum))
    elseif errCode == "season_cross_battle_tips01" and message.openTime then
      local now = UITimeManager:GetInstance():GetServerTime()
      local deltaTime = message.openTime - now
      if 0 < deltaTime then
        local leftMS = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
        UIUtil.ShowTips(Localization:GetString("season_cross_battle_tips01", leftMS))
      end
    elseif errCode == "season_s6_activity1200109_desc24" then
      if table.count(message.errorPara2) >= 2 then
        local serverId = LuaEntry.Player:GetSourceServerId()
        local cityCell1 = DataCenter.AllianceCityTemplateManager:GetTemplate(message.errorPara2[1], serverId)
        local cityCell2 = DataCenter.AllianceCityTemplateManager:GetTemplate(message.errorPara2[2], serverId)
        local msg = CS.GameEntry.Localization:GetString(errCode, cityCell1:GetFullName(), cityCell2:GetFullName())
        UIUtil.ShowTips(msg)
      else
        UIUtil.ShowTipsId(errCode)
      end
    else
      UIUtil.ShowTipsId(errCode)
    end
    if errCode == "season_s4_lighthouse_tips_12" then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPowerHouse, {anim = true}, 2)
    end
  end
end

local function PlayerPrefsGetBool(key, default)
  local uidKey = string.format("%s%s", LuaEntry.Player.uid, key)
  return PlayerPrefs.GetInt(uidKey, default and 1 or 0) == 1
end

local function PlayerPrefsSetBool(key, value)
  local uidKey = string.format("%s%s", LuaEntry.Player.uid, key)
  PlayerPrefs.SetInt(uidKey, value and 1 or 0)
end

local function GlobalPrefsGetBool(key, default)
  return PlayerPrefs.GetInt(key, default and 1 or 0) == 1
end

local function GlobalPrefsSetBool(key, value)
  PlayerPrefs.SetInt(key, value and 1 or 0)
end

local function PlayerPrefsGetInt(key, default)
  local uidKey = string.format("%s%s", LuaEntry.Player.uid, key)
  return PlayerPrefs.GetInt(uidKey, default)
end

local function PlayerPrefsSetInt(key, value)
  local uidKey = string.format("%s%s", LuaEntry.Player.uid, key)
  PlayerPrefs.SetInt(uidKey, value)
end

local function GlobalPrefsGetInt(key, default)
  return PlayerPrefs.GetInt(key, default)
end

local function GlobalPrefsSetInt(key, value)
  PlayerPrefs.SetInt(key, value)
end

local function PlayerPrefsGetFloat(key, default)
  local uidKey = string.format("%s%s", LuaEntry.Player.uid, key)
  return PlayerPrefs.GetFloat(uidKey, default)
end

local function PlayerPrefsSetFloat(key, value)
  local uidKey = string.format("%s%s", LuaEntry.Player.uid, key)
  PlayerPrefs.SetFloat(uidKey, value)
end

local function GlobalPrefsGetFloat(key, default)
  return PlayerPrefs.GetFloat(key, default)
end

local function GlobalPrefsSetFloat(key, value)
  PlayerPrefs.SetFloat(key, value)
end

local function PlayerPrefsGetString(key, default)
  local uidKey = string.format("%s%s", LuaEntry.Player.uid, key)
  return PlayerPrefs.GetString(uidKey, default)
end

local function PlayerPrefsSetString(key, value)
  local uidKey = string.format("%s%s", LuaEntry.Player.uid, key)
  PlayerPrefs.SetString(uidKey, value)
end

local function PlayerPrefsGetTable(key, default)
  local uidKey = string.format("%s%s", LuaEntry.Player.uid, key)
  local str = PlayerPrefs.GetString(uidKey)
  if string.IsNullOrEmpty(str) then
    return default
  else
    return rapidjson.decode(str)
  end
end

local function PlayerPrefsSetTable(key, value)
  local uidKey = string.format("%s%s", LuaEntry.Player.uid, key)
  local str = rapidjson.encode(value)
  PlayerPrefs.SetString(uidKey, str)
end

local function PlayerPrefsGetLong(key, default)
  local uidKey = string.format("%s%s", LuaEntry.Player.uid, key)
  return tonumber(PlayerPrefs.GetString(uidKey, tostring(default)))
end

local function PlayerPrefsSetLong(key, value)
  local uidKey = string.format("%s%s", LuaEntry.Player.uid, key)
  PlayerPrefs.SetString(uidKey, tostring(value))
end

local function IsResource(type)
  return type == ResourceType.Food or type == ResourceType.Metal or type == ResourceType.Wood
end

local function StringSplit(str, separator1, separator2)
  if string.IsNullOrEmpty(str) then
    return {}
  end
  local strArr = string.split(str, separator1)
  local ret = {}
  for i = 1, #strArr do
    ret[i] = string.split(strArr[i], separator2)
  end
  return ret
end

local function IsArabic()
  return Localization.Language == CS.GameFramework.Localization.Language.Arabic
end

local function IsArabicAutoMirrorOpen()
  return IsArabic() and CommonUtil.GetAutoArabicMirrorSwitch()
end

local function ArabicAutoMirrorFactor()
  return IsArabicAutoMirrorOpen() and -1 or 1
end

local function CallAutoArabicMirrorManually(data)
  if type(data) == typeof(CS.UnityEngine.GameObject) then
    CS.ArabicMirror.MirrorEntry(true, true, data)
  elseif data and not data.isUseCache and not IsNull(data.gameObject) then
    CS.ArabicMirror.MirrorEntry(true, true, data.gameObject)
  end
end

local function SetAutoArabicMirrorSwitch(isOpen)
  if type(isOpen) == "boolean" then
    IsArabicAutoMirrorOpenFlag = isOpen
    Setting:SetPrivateBool(SettingKeys.ARABIC_AUTO_MIRROR_SWITCH, isOpen)
  end
end

local function GetAutoArabicMirrorSwitch()
  if IsArabicAutoMirrorOpenFlag == nil then
    CommonUtil.RefreshAutoArabicMirrorSwitch()
  end
  return IsArabicAutoMirrorOpenFlag
end

local function RefreshAutoArabicMirrorSwitch()
  local defaultOpenServer = LuaEntry.DataConfig:TryGetNum("arabic_UI_open", "k1", 99999)
  local selfServerId = LuaEntry.Player:GetSourceServerId()
  local isOpen = defaultOpenServer < selfServerId
  IsArabicAutoMirrorOpenFlag = Setting:GetPrivateBool(SettingKeys.ARABIC_AUTO_MIRROR_SWITCH, isOpen)
  if not string.IsNullOrEmpty(LuaEntry.Player.uid) and Localization:GetLanguage() == Language.Arabic then
    PostEventLog.Track(PostEventLog.Defines.ArabicAutoMirrorOpen, {
      arabicMirrorOpen = tostring(IsArabicAutoMirrorOpenFlag)
    })
  end
end

local function IsGrayServer(startId, endId)
  startId = startId or 3
  endId = endId or 36
  if LuaEntry and LuaEntry.Player then
    local sid = LuaEntry.Player.serverId
    sid = tostring(sid)
    if sid ~= nil then
      local num = tonumber(string.match(sid, "%d+"))
      if num ~= nil and startId <= num and endId >= num then
        return true
      else
        return false
      end
    end
  end
  return false
end

local function IsJapanABTest()
  if not LuaEntry.Player:IsContainCountry("JP") then
    return false
  end
  local abTest = LuaEntry.Player.abTest
  if abTest ~= ABTestType.B then
    return false
  end
  local lang = CS.GameEntry.Localization:GetLanguage()
  local serverStr = LuaEntry.DataConfig:TryGetStr("lw_anime", "k1", "")
  local targetLang = LuaEntry.DataConfig:TryGetNum("lw_anime", "k2", 0)
  local serverList = {}
  if not string.IsNullOrEmpty(serverStr) then
    local str = string.split(serverStr, ",")
    for k, v in pairs(str) do
      table.insert(serverList, tonumber(v))
    end
  end
  if table.count(serverList) == 1 and serverList[1] == 0 then
    return lang == targetLang
  end
  local sourceServerId = LuaEntry.Player:GetSourceServerId()
  for k, v in pairs(serverList) do
    if sourceServerId == v and lang == targetLang then
      return true
    end
  end
  return false
end

local function ProtectCall(fun, errorHandle, finalHandle)
  local ok, msg = xpcall(fun, debug.traceback)
  if not ok then
    Logger.LogError(msg)
    if errorHandle ~= nil and type(errorHandle) == "function" then
      local ok2, errorMsg = pcall(errorHandle)
      if not ok2 and errorMsg then
        Logger.LogError(errorMsg)
      end
    end
  end
  if finalHandle ~= nil and type(finalHandle) == "function" then
    ok, msg = pcall(finalHandle)
    if not ok then
      Logger.LogError(msg)
    end
  end
end

local function ParseQuestionnaireURL(oriUrl)
  local newUrl = string.gsub(oriUrl, "%[([a-zA-Z0-9_]+)%]", function(key)
    if key == "vip_exp_value" then
      return tostring(LuaEntry.Player.payDollerTotal)
    elseif key == "lv_value" then
      return tostring(DataCenter.BuildManager.MainLv)
    elseif key == "vip_value" then
      local vipData = DataCenter.VIPManager:GetVipData()
      if vipData then
        return tostring(vipData.level)
      else
        return "0"
      end
    elseif key == "sid_value" then
      return tostring(LuaEntry.Player.serverId)
    elseif key == "openid_value" then
      return tostring(LuaEntry.Player.uid)
    else
      return key
    end
  end)
  return newUrl
end

local function CreatColorGammaToLinear255(r, g, b, a)
  local _r = r / 255
  _r = _r <= 0.04045 and _r / 12.92 or ((_r + 0.055) / 1.055) ^ 2.4
  local _g = g / 255
  _g = _g <= 0.04045 and _g / 12.92 or ((_g + 0.055) / 1.055) ^ 2.4
  local _b = b / 255
  _b = _b <= 0.04045 and _b / 12.92 or ((_b + 0.055) / 1.055) ^ 2.4
  local _a = a / 255
  return Color.New(_r, _g, _b, _a)
end

local IS_DEBUG

local function IsDebug()
  if IS_DEBUG == nil then
    IS_DEBUG = CS.CommonUtils.IsDebug()
  end
  return IS_DEBUG or false
end

local IS_EDITOR

local function IsEditor()
  if IS_EDITOR == nil then
    IS_EDITOR = CS.UnityEngine.Application.isEditor
  end
  return IS_EDITOR or false
end

local function AnalyseParam(sourceData, isIgnore)
  local param = {}
  for i = 1, #sourceData.params do
    if sourceData.trans[i] == 0 then
      param[i] = sourceData.params[i]
    elseif sourceData.trans[i] == 1 then
      param[i] = Localization:GetString(sourceData.params[i])
    elseif sourceData.trans[i] == 2 then
      local pos = SceneUtils.IndexToTilePos(tonumber(sourceData.params[i]), ForceChangeScene.World)
      if isIgnore then
        param[i] = Localization:GetString(GameDialogDefine.SHOW_POS, pos.x, pos.y)
      else
        param[i] = "<u>" .. Localization:GetString(GameDialogDefine.SHOW_POS, pos.x, pos.y) .. "</u>"
      end
      sourceData.pos = tonumber(sourceData.params[i])
    elseif sourceData.trans[i] == 3 then
      if not string.IsNullOrEmpty(sourceData.params[i]) then
        param[i] = "[" .. sourceData.params[i] .. "]"
      else
        param[i] = sourceData.params[i] or ""
      end
    elseif sourceData.trans[i] == 4 then
      if not string.IsNullOrEmpty(sourceData.params[i]) then
        param[i] = UITimeManager:GetInstance():TimeStampToTimeForServer(sourceData.params[i])
      else
        param[i] = sourceData.params[i] or ""
      end
    elseif sourceData.trans[i] == 5 then
      local split = string.split(sourceData.params[i], "|")
      local pos = SceneUtils.IndexToTilePos(tonumber(split[2]), ForceChangeScene.World)
      local link = {
        action = "Jump",
        x = pos.x,
        y = pos.y,
        server = tonumber(split[1])
      }
      param.link = link
      local json = rapidjson.encode(link)
      local linkId = base64.encode(json)
      param[i] = "<link='" .. linkId .. "'><u>(#" .. tonumber(split[1]) .. " X:" .. math.tointeger(pos.x) .. ", " .. "Y:" .. math.tointeger(pos.y) .. ")</u></link>"
    end
  end
  return param
end

local function GetStrLog(code, sourceData, isIgnore)
  if next(sourceData.params) then
    local template = CommonUtil.AnalyseParam(sourceData, isIgnore)
    CommonUtil.DealRemarkName(sourceData, template)
    return Localization:GetString(sourceData.code, table.unpack(template))
  end
  return Localization:GetString(sourceData.code)
end

local function DealRemarkName(sourceData, template)
  if (sourceData.code == "455064" or sourceData.code == "455065" or sourceData.code == "455072" or sourceData.code == "455073") and sourceData.params[7] and sourceData.params[8] then
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(sourceData.params[7], template[2])
    template[2] = showName
    showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(sourceData.params[8], template[4])
    template[4] = showName
  end
end

local function InitRandomSeedWithUID(uid)
  local t = SafeLocalOsTime()
  local c = math.floor(os.clock() * 1000000 % 1000000)
  local hash = 0
  if uid then
    for i = 1, #uid do
      hash = (hash * 31 + string.byte(uid, i)) % 1000000007
    end
  end
  math.randomseed((t + c + hash) % 2147483647)
  for i = 1, 3 do
    math.random()
  end
end

function CommonUtil.FeatureExplorationTrack(trackType)
  if trackType then
    PostEventLog.Track(PostEventLog.Defines.c_feature_exploration, {featureType = trackType})
  end
end

CommonUtil.IsResource = IsResource
CommonUtil.PlayerPrefsGetBool = PlayerPrefsGetBool
CommonUtil.PlayerPrefsSetBool = PlayerPrefsSetBool
CommonUtil.GlobalPrefsSetBool = GlobalPrefsSetBool
CommonUtil.GlobalPrefsGetBool = GlobalPrefsGetBool
CommonUtil.PlayerPrefsGetInt = PlayerPrefsGetInt
CommonUtil.PlayerPrefsSetInt = PlayerPrefsSetInt
CommonUtil.GlobalPrefsSetInt = GlobalPrefsSetInt
CommonUtil.GlobalPrefsGetInt = GlobalPrefsGetInt
CommonUtil.PlayerPrefsGetFloat = PlayerPrefsGetFloat
CommonUtil.PlayerPrefsSetFloat = PlayerPrefsSetFloat
CommonUtil.GlobalPrefsSetFloat = GlobalPrefsSetFloat
CommonUtil.GlobalPrefsGetFloat = GlobalPrefsGetFloat
CommonUtil.PlayerPrefsGetString = PlayerPrefsGetString
CommonUtil.PlayerPrefsSetString = PlayerPrefsSetString
CommonUtil.PlayerPrefsGetTable = PlayerPrefsGetTable
CommonUtil.PlayerPrefsSetTable = PlayerPrefsSetTable
CommonUtil.PlayerPrefsGetLong = PlayerPrefsGetLong
CommonUtil.PlayerPrefsSetLong = PlayerPrefsSetLong
CommonUtil.GetTimeDiamondCost = GetTimeDiamondCost
CommonUtil.GetResourceDescriptionByType = GetResourceDescriptionByType
CommonUtil.GetResOrItemCount = GetResOrItemCount
CommonUtil.GetResOrItemIcon = GetResOrItemIcon
CommonUtil.GetScienceBaseType = GetScienceBaseType
CommonUtil.GetScienceLv = GetScienceLv
CommonUtil.GetBuildBaseType = GetBuildBaseType
CommonUtil.GetBuildLv = GetBuildLv
CommonUtil.GetDetectEventQualityColor = GetDetectEventQualityColor
CommonUtil.GetDetectEventQualityName = GetDetectEventQualityName
CommonUtil.GetDirByPos = GetDirByPos
CommonUtil.CheckIsScienceEnough = CheckIsScienceEnough
CommonUtil.CheckIsBuildEnough = CheckIsBuildEnough
CommonUtil.CheckIsResourceGoodsEnough = CheckIsResourceGoodsEnough
CommonUtil.CheckIsResourceEnough = CheckIsResourceEnough
CommonUtil.GetResGoldByType = GetResGoldByType
CommonUtil.GetNameByParams = GetNameByParams
CommonUtil.GetResourceNameByType = GetResourceNameByType
CommonUtil.CopyTextToClipboard = CopyTextToClipboard
CommonUtil.GetNodeActivePaths = GetNodeActivePaths
CommonUtil.GetItemGoldByItemId = GetItemGoldByItemId
CommonUtil.SendErrorMessageToServer = SendErrorMessageToServer
CommonUtil.GetValueWithLocalType = GetValueWithLocalType
CommonUtil.GetEffectReasonDesc = GetEffectReasonDesc
CommonUtil.PlayGameBgMusic = PlayGameBgMusic
CommonUtil.ClearGameBgMusicData = ClearGameBgMusicData
CommonUtil.VibratorLightImpact = VibratorLightImpact
CommonUtil.GetAllProxy = GetAllProxy
CommonUtil.GetPortId = GetPortId
CommonUtil.GetOwnCountByCommonCostType = GetOwnCountByCommonCostType
CommonUtil.MarchErrorLog = MarchErrorLog
CommonUtil.StringSplit = StringSplit
CommonUtil.IsArabic = IsArabic
CommonUtil.IsArabicAutoMirrorOpen = IsArabicAutoMirrorOpen
CommonUtil.ArabicAutoMirrorFactor = ArabicAutoMirrorFactor
CommonUtil.CallAutoArabicMirrorManually = CallAutoArabicMirrorManually
CommonUtil.SetAutoArabicMirrorSwitch = SetAutoArabicMirrorSwitch
CommonUtil.GetAutoArabicMirrorSwitch = GetAutoArabicMirrorSwitch
CommonUtil.RefreshAutoArabicMirrorSwitch = RefreshAutoArabicMirrorSwitch
CommonUtil.IsGrayServer = IsGrayServer
CommonUtil.IsJapanABTest = IsJapanABTest
CommonUtil.ProtectCall = ProtectCall
CommonUtil.ParseQuestionnaireURL = ParseQuestionnaireURL
CommonUtil.CreatColorGammaToLinear255 = CreatColorGammaToLinear255
CommonUtil.IsDebug = IsDebug
CommonUtil.IsEditor = IsEditor
CommonUtil.AnalyseParam = AnalyseParam
CommonUtil.GetStrLog = GetStrLog
CommonUtil.DealRemarkName = DealRemarkName
CommonUtil.InitRandomSeedWithUID = InitRandomSeedWithUID
return ConstClass("CommonUtil", CommonUtil)
