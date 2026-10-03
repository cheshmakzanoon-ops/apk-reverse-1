local BirthdayDataManager = BaseClass("BirthdayDataManager")
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local birthdayRewardGetDayNum = 7
local BirthdayRedPacketShowEffectDictKey = "BirthdayRedPacketShowEffectDictKey"
local BirthdayRedPacketShowEffectExpireTimeDayNum = 100
local monthStrKeyDict = {
  [1] = "birthday_tips_40",
  [2] = "birthday_tips_41",
  [3] = "birthday_tips_42",
  [4] = "birthday_tips_43",
  [5] = "birthday_tips_44",
  [6] = "birthday_tips_45",
  [7] = "birthday_tips_46",
  [8] = "birthday_tips_47",
  [9] = "birthday_tips_48",
  [10] = "birthday_tips_49",
  [11] = "birthday_tips_50",
  [12] = "birthday_tips_51"
}

local function __init(self)
  self.birthday_function = nil
  self.isSelfBirthdayFuncOpen = false
  self.isBirthdayDataNeedSetTip = false
  self.isBirthdayDataInfoOpenNeedSetTip = false
  self.isSelfBirthdayDayOpen = false
  self.isBirthdayLetterRewardGetTip = false
  self.curFormat = nil
  self.curFormatExpiredTime = nil
  self.curRewardRangeFormat = {}
  self.ageListTab = nil
  self.birthdayHistories = nil
  self.birthdayHistoriesTab = nil
  self.birthdayRedPacketShowEffectDict = nil
  self:AddListener()
end

local function __delete(self)
  self:RemoveListener()
  self.birthday_function = nil
  self.isSelfBirthdayFuncOpen = nil
  self.isBirthdayDataNeedSetTip = nil
  self.isBirthdayDataInfoOpenNeedSetTip = nil
  self.isSelfBirthdayDayOpen = nil
  self.isBirthdayLetterRewardGetTip = nil
  self.curFormat = nil
  self.curFormatExpiredTime = nil
  self.curRewardRangeFormat = nil
  self.ageListTab = nil
  self.birthdayHistories = nil
  self.birthdayHistoriesTab = nil
  self.birthdayRedPacketShowEffectDict = nil
end

function BirthdayDataManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.MainLvUp, self.OnMainLvUpMsg)
  EventManager:GetInstance():AddListener(EventId.OnPassDay, self.OnPassDayMsg)
  EventManager:GetInstance():AddListener(EventId.OnFinishHandleInitMsg, self.OnFinishHandleInitMsg)
  EventManager:GetInstance():AddListener(EventId.BirthdaySetPanelOpenGuidServerRecord, self.OnGuidServerRecord)
  EventManager:GetInstance():AddListener(EventId.GF_item_refreshed, self.OnItemRefreshed)
  EventManager:GetInstance():AddListener(EventId.OnLetterRewardGet, self.OnLetterRewardGet)
  EventManager:GetInstance():AddListener(EventId.GF_enter_game, self.OnGFEnterGame)
  EventManager:GetInstance():AddListener(EventId.OnRewardGetPanelClose, self.OnRewardViewColse)
end

function BirthdayDataManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.MainLvUp, self.OnMainLvUpMsg)
  EventManager:GetInstance():RemoveListener(EventId.OnPassDay, self.OnPassDayMsg)
  EventManager:GetInstance():RemoveListener(EventId.OnFinishHandleInitMsg, self.OnFinishHandleInitMsg)
  EventManager:GetInstance():RemoveListener(EventId.BirthdaySetPanelOpenGuidServerRecord, self.OnGuidServerRecord)
  EventManager:GetInstance():RemoveListener(EventId.GF_item_refreshed, self.OnItemRefreshed)
  EventManager:GetInstance():RemoveListener(EventId.OnLetterRewardGet, self.OnLetterRewardGet)
  EventManager:GetInstance():RemoveListener(EventId.GF_enter_game, self.OnGFEnterGame)
  EventManager:GetInstance():RemoveListener(EventId.OnRewardGetPanelClose, self.OnRewardViewColse)
end

function BirthdayDataManager:InitData(initMsg)
  if initMsg.birthday_function then
    self.birthday_function = initMsg.birthday_function
  end
  if initMsg.birthdayHistories then
    self.birthdayHistories = initMsg.birthdayHistories
    self.birthdayHistoriesTab = nil
  end
end

function BirthdayDataManager:UpdateData(updateMsg)
  if updateMsg then
    if self.birthday_function == nil then
      self.birthday_function = {
        age = nil,
        birthday = nil,
        modifyTime = nil,
        receiveYear = nil,
        displayType = nil,
        zodType = nil,
        rewarded = nil
      }
    end
    if updateMsg.age ~= nil then
      self.birthday_function.age = updateMsg.age
    end
    if updateMsg.birthday ~= nil then
      self.birthday_function.birthday = updateMsg.birthday
    end
    if updateMsg.modifyTime ~= nil then
      self.birthday_function.modifyTime = updateMsg.modifyTime
    end
    if updateMsg.displayType ~= nil then
      self.birthday_function.displayType = updateMsg.displayType
    end
    if updateMsg.zodType ~= nil then
      self.birthday_function.zodType = updateMsg.zodType
    end
    if updateMsg.rewarded ~= nil then
      self.birthday_function.rewarded = updateMsg.rewarded
    end
  end
  self:TryRefreshBirthdaySetNeedTip()
  self:TryRefreshBirthdayDataInfoOpenNeedSetTip()
  self:TryRefreshIsSelfBirthdayDayOpen()
  self:TryRefreshBirthdayLetterRewardGetTip()
  self:TryRequestGetBirthdayCard()
end

function BirthdayDataManager.OnMainLvUpMsg()
  local self = DataCenter.BirthdayDataManager
  if self.isSelfBirthdayFuncOpen then
    return
  end
  self:TryRefreshIsSelfBirthdayFuncOpen()
  self:TryRefreshBirthdaySetNeedTip()
  self:TryRefreshBirthdayDataInfoOpenNeedSetTip()
  self:TryRefreshIsSelfBirthdayDayOpen()
end

function BirthdayDataManager.OnPassDayMsg()
  local self = DataCenter.BirthdayDataManager
  self:TryRefreshIsSelfBirthdayFuncOpen()
  self:TryRefreshBirthdaySetNeedTip()
  self:TryRefreshBirthdayDataInfoOpenNeedSetTip()
  self:TryRefreshIsSelfBirthdayDayOpen()
  self:TryRequestGetBirthdayCard()
end

function BirthdayDataManager.OnFinishHandleInitMsg()
  local self = DataCenter.BirthdayDataManager
  self:TryRefreshIsSelfBirthdayFuncOpen()
  self:TryRefreshBirthdaySetNeedTip()
  self:TryRefreshBirthdayDataInfoOpenNeedSetTip()
  self:TryRefreshIsSelfBirthdayDayOpen()
  self:TryRequestGetBirthdayCard()
end

function BirthdayDataManager.OnGuidServerRecord()
  local self = DataCenter.BirthdayDataManager
  self:TryRefreshBirthdaySetNeedTip()
  self:TryRefreshBirthdayDataInfoOpenNeedSetTip()
end

function BirthdayDataManager.OnItemRefreshed(itemdata)
  if itemdata == nil then
    return
  end
  if itemdata.goods == nil then
    return
  end
  local self = DataCenter.BirthdayDataManager
  if itemdata.goods.type == GOODS_TYPE.GOODS_TYPE_160 and itemdata.para1 == LetterGroupTypeStr.Birthday then
    self:TryRefreshBirthdayLetterRewardGetTip()
  end
end

function BirthdayDataManager.OnLetterRewardGet(msg)
  local isBirthday = false
  if msg and msg.itemId then
    local itemData = DataCenter.ItemData:GetItemById(msg.itemId)
    if itemData and itemData.goods.type == GOODS_TYPE.GOODS_TYPE_160 and itemData.para1 == LetterGroupTypeStr.Birthday then
      isBirthday = true
    end
  end
  if isBirthday == false then
    return
  end
  local self = DataCenter.BirthdayDataManager
  self:TryRefreshBirthdayLetterRewardGetTip()
  self:TryTipUseBirthdayRedPacket(msg)
end

function BirthdayDataManager.OnGFEnterGame()
  local self = DataCenter.BirthdayDataManager
  self:TryRefreshBirthdayLetterRewardGetTip()
end

function BirthdayDataManager:TryRefreshIsSelfBirthdayFuncOpen()
  if self.isSelfBirthdayFuncOpen == false then
    self.isSelfBirthdayFuncOpen = self:GetCurIsSelfBirthdayFuncOpen()
    if self.isSelfBirthdayFuncOpen then
      EventManager:GetInstance():Broadcast(EventId.OnSelfBirthdayFuncOpen)
    end
  end
end

function BirthdayDataManager:TryRefreshBirthdaySetNeedTip()
  local curData = self:GetCurBirthdaySetNeedTip()
  if curData ~= self.isBirthdayDataNeedSetTip then
    self.isBirthdayDataNeedSetTip = curData
    EventManager:GetInstance():Broadcast(EventId.OnSelfBirthdaySetNeedTipStatusChange, curData)
  end
end

function BirthdayDataManager:TryRefreshBirthdayDataInfoOpenNeedSetTip()
  local curData = self:GetCurBirthdayDataInfoOpenNeedSetTip()
  if curData ~= self.isBirthdayDataInfoOpenNeedSetTip then
    self.isBirthdayDataInfoOpenNeedSetTip = curData
    EventManager:GetInstance():Broadcast(EventId.OnBirthdayDataInfoOpenNeedSetTipStatusChange, curData)
  end
end

function BirthdayDataManager:TryRefreshIsSelfBirthdayDayOpen()
  local curData = self:GetCurIsSelfBirthdayDayOpen()
  if curData ~= self.isSelfBirthdayDayOpen then
    self.isSelfBirthdayDayOpen = curData
    EventManager:GetInstance():Broadcast(EventId.OnSelfBirthdayDayStatusChange, curData)
  end
end

function BirthdayDataManager:TryRefreshBirthdayLetterRewardGetTip()
  local curData = self:GetCurBirthdayLetterRewardGetTip()
  if curData ~= self.isBirthdayLetterRewardGetTip then
    self.isBirthdayLetterRewardGetTip = curData
    EventManager:GetInstance():Broadcast(EventId.OnBirthdayLetterRewardGetTipStatusChange, curData)
  end
end

function BirthdayDataManager:TryRequestGetBirthdayCard()
  if self.isSelfBirthdayFuncOpen == false then
    return
  end
  if self.birthday_function == nil or self.curFormat == nil then
    return
  end
  self:TryRefreshCurFormat()
  local haveRewardDay = false
  local getYear = self.birthday_function.receiveYear
  local birthdayStr = self.birthday_function.birthday
  local birthdayMonth, birthdayDay
  if not string.IsNullOrEmpty(birthdayStr) then
    local birthdayArr = string.string2array_i_oneSep(birthdayStr, "-")
    if #birthdayArr == 2 then
      birthdayMonth = birthdayArr[1]
      birthdayDay = birthdayArr[2]
    end
  end
  if birthdayMonth and birthdayDay then
    for _, format in ipairs(self.curRewardRangeFormat) do
      if (getYear == nil or getYear < format.year) and birthdayMonth == format.month and birthdayDay == format.day then
        haveRewardDay = true
        break
      end
    end
  end
  if haveRewardDay then
    SFSNetwork.SendMessage(MsgDefines.UserBirthdayCard)
  end
end

function BirthdayDataManager:CheckIsSameTime(timeStr)
  self:TryRefreshCurFormat()
  local isSame = false
  if string.IsNullOrEmpty(timeStr) then
    return isSame
  end
  local timeArr = string.string2array_i_oneSep(timeStr, "-")
  if #timeArr == 2 and self.curFormat.month == tonumber(timeArr[1]) and self.curFormat.day == tonumber(timeArr[2]) then
    isSame = true
  end
  return isSame
end

function BirthdayDataManager:CheckIsPassSetShowArea(playerUid, allianceId, showArea)
  local isPass = false
  if showArea then
    if showArea == BirthdayShowArea.OnlySelf then
      if playerUid == LuaEntry.Player.uid then
        isPass = true
      end
    elseif showArea == BirthdayShowArea.Alliance then
      if playerUid == LuaEntry.Player.uid then
        isPass = true
      elseif allianceId and allianceId == LuaEntry.Player.allianceId then
        isPass = true
      end
    elseif showArea == BirthdayShowArea.All then
      isPass = true
    end
  end
  return isPass
end

function BirthdayDataManager:GetCurIsSelfBirthdayFuncOpen()
  local isOpen = false
  local configDays = LuaEntry.DataConfig:TryGetNum("player_birthday", "k1", 0)
  local cityLv = LuaEntry.DataConfig:TryGetNum("player_birthday", "k2", 0)
  local serverRange = LuaEntry.DataConfig:TryGetNum("player_birthday", "k9", 0)
  local openServerTime = LuaEntry.Player.openServerTime
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local openServerDay = math.floor((curTime - openServerTime) / 86400000) + 1
  local isCoppaLimit = CoppaUtil.IsCoppaLimit()
  local isServerOpen = self:CheckServerIsOpen(serverRange)
  if configDays <= openServerDay and cityLv <= DataCenter.BuildManager.MainLv and isCoppaLimit == false and isServerOpen then
    isOpen = true
  end
  return isOpen
end

function BirthdayDataManager:CheckServerIsOpen(serverRange)
  local selfServerId = LuaEntry.Player:GetSourceServerId()
  if CS.NetworkURLConfig.IsPressureTest then
    if serverRange == 1 then
      if selfServerId <= 46 then
        return true
      end
    elseif serverRange == 2 then
      return true
    end
  elseif CS.NetworkURLConfig.IsOnline then
    if serverRange == 1 then
      if selfServerId <= 68 then
        return true
      end
    elseif serverRange == 2 then
      return true
    end
  elseif serverRange == 1 or serverRange == 2 then
    return true
  end
  return false
end

function BirthdayDataManager:GetCurBirthdaySetNeedTip()
  local isNeedTip = false
  if self.isSelfBirthdayFuncOpen and not self:GetBirthdayGuidServerRecordHaveSet() and self.birthday_function == nil then
    isNeedTip = true
  end
  return isNeedTip
end

function BirthdayDataManager:GetCurBirthdayDataInfoOpenNeedSetTip()
  local isNeedTip = false
  if self.isSelfBirthdayFuncOpen and not self:GetBirthdayGuidServerRecordInfoOpenHaveSet() and self.birthday_function == nil then
    isNeedTip = true
  end
  return isNeedTip
end

function BirthdayDataManager:GetCurIsSelfBirthdayDayOpen()
  local isOpen = false
  if self.isSelfBirthdayFuncOpen and self.birthday_function and not string.IsNullOrEmpty(self.birthday_function.birthday) and self:CheckIsSameTime(self.birthday_function.birthday) then
    isOpen = true
  end
  return isOpen
end

function BirthdayDataManager:GetCurBirthdayLetterRewardGetTip()
  local isHaveTip = false
  local birthdayGroupType = LetterGroupTypeStr.Birthday
  local items = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_160)
  if items and 0 < #items then
    for _, item in ipairs(items) do
      if item.para1 == birthdayGroupType then
        local otherParamData = item:GetOtherParamTab()
        if otherParamData.state == nil or toInt(otherParamData.state) == 0 then
          isHaveTip = true
          break
        end
      end
    end
  end
  return isHaveTip
end

function BirthdayDataManager:TryRefreshCurFormat()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.curFormatExpiredTime == nil or curTime > self.curFormatExpiredTime then
    local serverStartZeroTimeStamp = UITimeManager:GetInstance():GetTodayZeroServerTime(curTime // 1000) * 1000
    self.curFormatExpiredTime = serverStartZeroTimeStamp + 86400000
    local changeDeltaTime = UITimeManager:GetInstance():GetTimezoneOffset()
    local time = math.modf((curTime + changeDeltaTime) / 1000)
    self.curFormat = os.date("!*t", time)
    self.curRewardRangeFormat = {}
    table.insert(self.curRewardRangeFormat, self.curFormat)
    for i = 1, birthdayRewardGetDayNum - 1 do
      local addTime = math.modf((curTime + changeDeltaTime) / 1000 - i * 24 * 60 * 60)
      local addFormat = os.date("!*t", addTime)
      table.insert(self.curRewardRangeFormat, addFormat)
    end
  end
end

function BirthdayDataManager:GetBirthdayGuidServerRecordHaveSet()
  local val = DataCenter.GuideRecordDataManager:GetRecordTabData(GuidServerRecordType.BirthdayDataRecord)
  local haveSet = val ~= nil and val == "1"
  return haveSet
end

function BirthdayDataManager:SendBirthdayGuidServerRecord()
  SFSNetwork.SendMessage(MsgDefines.GuideRecord, GuidServerRecordType.BirthdayDataRecord, "1")
end

function BirthdayDataManager:GetBirthdayGuidServerRecordInfoOpenHaveSet()
  local val = DataCenter.GuideRecordDataManager:GetRecordTabData(GuidServerRecordType.BirthdayFuncAfterOpenInfoViewOpen)
  local haveSet = val ~= nil and val == "1"
  return haveSet
end

function BirthdayDataManager:SendBirthdayGuidServerRecordInfoOpen()
  SFSNetwork.SendMessage(MsgDefines.GuideRecord, GuidServerRecordType.BirthdayFuncAfterOpenInfoViewOpen, "1")
end

function BirthdayDataManager:GetSetData()
  return self.birthday_function
end

function BirthdayDataManager:GetBirthdayDataModifyTimeSpaceDayNum()
  local dayNum = LuaEntry.DataConfig:TryGetNum("player_birthday", "k6", 0)
  return dayNum
end

function BirthdayDataManager:GetIsSelfBirthdayFuncOpen()
  return self.isSelfBirthdayFuncOpen
end

function BirthdayDataManager:GetAgeListTab()
  if self.ageListTab == nil then
    self.ageListTab = {}
    local ageListStr = LuaEntry.DataConfig:TryGetStr("player_birthday", "k8", "")
    self.ageListTab = string.string2array_s(ageListStr, ";", "|")
  end
  return self.ageListTab
end

function BirthdayDataManager:GetVisibleNameByType(type)
  local name = ""
  if type == BirthdayShowArea.OnlySelf then
    name = Localization:GetString("birthday_tips_14")
  elseif type == BirthdayShowArea.Alliance then
    name = Localization:GetString("birthday_tips_13")
  elseif type == BirthdayShowArea.All then
    name = Localization:GetString("birthday_tips_12")
  end
  return name
end

function BirthdayDataManager:GetBirthdayCardReward(msg)
  if self.birthday_function and self.curFormat and self.curRewardRangeFormat then
    local getYear = self.birthday_function.receiveYear
    local birthdayStr = self.birthday_function.birthday
    local birthdayMonth, birthdayDay
    if not string.IsNullOrEmpty(birthdayStr) then
      local birthdayArr = string.string2array_i_oneSep(birthdayStr, "-")
      if #birthdayArr == 2 then
        birthdayMonth = birthdayArr[1]
        birthdayDay = birthdayArr[2]
      end
    end
    local isFind = false
    if birthdayMonth and birthdayDay then
      for _, format in ipairs(self.curRewardRangeFormat) do
        if (getYear == nil or getYear < format.year) and birthdayMonth == format.month and birthdayDay == format.day then
          self.birthday_function.receiveYear = format.year
          isFind = true
          break
        end
      end
    end
    if isFind == false then
      local curYear = self.curFormat.year
      self.birthday_function.receiveYear = curYear
    end
  end
end

function BirthdayDataManager:HaveGetSetReward()
  if self.birthday_function then
    self.birthday_function.rewarded = true
  end
end

function BirthdayDataManager:TryInitBirthdayHistoriesTab()
  if self.birthdayHistoriesTab == nil then
    self.birthdayHistoriesTab = {}
    if self.birthdayHistories and #self.birthdayHistories > 0 then
      for _, v in ipairs(self.birthdayHistories) do
        self.birthdayHistoriesTab[v] = true
      end
    end
  end
end

function BirthdayDataManager:GetIsHaveBirthdayHistoriey(uid)
  local isHave = false
  self:TryInitBirthdayHistoriesTab()
  if self.birthdayHistoriesTab[uid] then
    isHave = true
  end
  return isHave
end

function BirthdayDataManager:SetBirthdayHistoriey(uid)
  self:TryInitBirthdayHistoriesTab()
  self.birthdayHistoriesTab[uid] = true
end

function BirthdayDataManager:GetIsShowBirthdayIconByUserInfo(userInfo)
  local isShow = false
  if userInfo == nil then
    return isShow
  end
  local isHaveSet = false
  if userInfo.uid == LuaEntry.Player.uid then
    if not string.IsNullOrEmpty(userInfo.birthday) then
      isHaveSet = true
    end
  elseif not string.IsNullOrEmpty(userInfo.birthday) and DataCenter.BirthdayDataManager:CheckIsPassSetShowArea(userInfo.uid, userInfo.allianceId, userInfo.birthdayDisplay) then
    isHaveSet = true
  end
  if isHaveSet then
    isShow = DataCenter.BirthdayDataManager:CheckIsSameTime(userInfo.birthday)
  end
  return isShow
end

function BirthdayDataManager:GetSznTypeByMonth(month)
  local sznType = BirthdaySzn.Default
  local configStr = LuaEntry.DataConfig:TryGetStr("player_birthday", "k11", "")
  if not string.IsNullOrEmpty(configStr) then
    local data = string.string2array_i(configStr, ";", "|")
    for k, v in ipairs(data) do
      if #v == 3 then
        local szn = v[1]
        local monthS = v[2]
        local monthE = v[3]
        if monthS < monthE then
          if month >= monthS and month <= monthE then
            sznType = szn
            break
          end
        elseif month >= monthS or month <= monthE then
          sznType = szn
          break
        end
      end
    end
  end
  return sznType
end

function BirthdayDataManager:TryTipUseBirthdayRedPacket(msg)
  if CoppaUtil.IsCoppaLimitWithTips() then
    return
  end
  local targetItemId, targetItemData, targetRedPocketTemp
  if msg and msg.reward then
    local rewardList = msg.reward
    for _, reward in pairs(rewardList) do
      if reward.type and reward.type == RewardType.GOODS then
        local value = reward.value
        local itemId = value.itemId
        local itemData = DataCenter.ItemData:GetItemById(itemId)
        local template = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
        if itemData and template and template.type == GOODS_TYPE.GOODS_TYPE_139 then
          local redPocketTemp = DataCenter.RedPacketTemplateManager:GetTemplateByGoodsId(itemId)
          if redPocketTemp and redPocketTemp.type == RedPacketType.Birthday then
            targetItemId = itemId
            targetItemData = itemData
            targetRedPocketTemp = redPocketTemp
            break
          end
        end
      end
    end
  end
  if targetItemId == nil then
    return
  end
  self.haveTipUseBirthdayRedPacketTargetItemId = targetItemId
end

function BirthdayDataManager:OnRewardViewColse()
  local self = DataCenter.BirthdayDataManager
  if self.haveTipUseBirthdayRedPacketTargetItemId then
    self.haveTipUseBirthdayRedPacketTargetItemId = nil
    UIUtil.ShowMessage(Localization:GetString("birthday_tips_17"), 1, "birthday_btn_1", nil, function()
      GoToUtil.CloseAllWindows()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIRedPacketBag)
    end)
  end
end

function BirthdayDataManager:GetConstellationImgPathByDate(timeStr, isgray)
  local path
  local timeArr = string.string2array_i_oneSep(timeStr, "-")
  if #timeArr == 2 then
    local constellationType = self:GetConstellationTypeByDate(timeArr[1], timeArr[2])
    local constellationIconData = ConstellationIcon[constellationType]
    if constellationIconData then
      local iconName = ""
      if isgray then
        iconName = constellationIconData.gray
      else
        iconName = constellationIconData.normal
      end
      path = string.format(UIAssets.ConstellationSpritePath, iconName)
    end
  end
  return path
end

function BirthdayDataManager:GetConstellationTypeByDate(month, day)
  local constellationType = ConstellationType.Cap
  for i = 1, #ConstellationDateNum - 1 do
    local type = i
    local dateNum = ConstellationDateNum[i]
    local isPassS = false
    local isPassE = false
    if month > dateNum.s.m or month == dateNum.s.m and day >= dateNum.s.d then
      isPassS = true
    end
    if month < dateNum.e.m or month == dateNum.e.m and day <= dateNum.e.d then
      isPassE = true
    end
    if isPassS and isPassE then
      constellationType = type
      break
    elseif isPassS and not isPassE then
    else
      break
    end
  end
  return constellationType
end

function BirthdayDataManager:GetMonthStrByNum(num)
  local str = ""
  if num and monthStrKeyDict[num] then
    str = Localization:GetString(monthStrKeyDict[num])
  else
    str = Localization:GetString("birthday_5_limit_6")
  end
  return str
end

function BirthdayDataManager:GetDayStrByNum(num)
  local str = ""
  if num then
    str = tostring(num)
  else
    str = Localization:GetString("birthday_6_limit_6")
  end
  return str
end

function BirthdayDataManager:IsSelfHaveSetBirthday()
  local isHaveSet = false
  if self.birthday_function and not string.IsNullOrEmpty(self.birthday_function.birthday) then
    isHaveSet = true
  end
  return isHaveSet
end

function BirthdayDataManager:IsHaveGetBirthdayFirstSetReward()
  local isHave = false
  if self.birthday_function and self.birthday_function.rewarded then
    isHave = true
  end
  return isHave
end

function BirthdayDataManager:FirstSetRewardHaveGetRedDot()
  local birthdayHaveSet = DataCenter.BirthdayDataManager:IsSelfHaveSetBirthday()
  local haveGet = DataCenter.BirthdayDataManager:IsHaveGetBirthdayFirstSetReward()
  if birthdayHaveSet and not haveGet then
    return true
  else
    return false
  end
end

function BirthdayDataManager:CheckDisplayTypeNotOnlySelf()
  local data = self.birthday_function
  if data and data.displayType and data.displayType ~= BirthdayShowArea.OnlySelf then
    return true
  else
    return false
  end
end

function BirthdayDataManager:GetBirthdayRedPacketShowEffectDict()
  if self.birthdayRedPacketShowEffectDict == nil then
    self.birthdayRedPacketShowEffectDict = CommonUtil.PlayerPrefsGetTable(BirthdayRedPacketShowEffectDictKey, {})
    local haveExpired = false
    local curTime = UITimeManager:GetInstance():GetServerTime()
    for seqId, createTime in pairs(self.birthdayRedPacketShowEffectDict) do
      if curTime - createTime > BirthdayRedPacketShowEffectExpireTimeDayNum * 24 * 60 * 60 * 1000 then
        self.birthdayRedPacketShowEffectDict[seqId] = nil
        haveExpired = true
      end
    end
    if haveExpired then
      CommonUtil.PlayerPrefsSetTable(BirthdayRedPacketShowEffectDictKey, self.birthdayRedPacketShowEffectDict)
    end
  end
  return self.birthdayRedPacketShowEffectDict
end

function BirthdayDataManager:AddBirthdayRedPacketShowEffectRecord(seqId, createTime)
  local dict = self:GetBirthdayRedPacketShowEffectDict()
  if dict[seqId] == nil then
    dict[seqId] = createTime
    CommonUtil.PlayerPrefsSetTable(BirthdayRedPacketShowEffectDictKey, dict)
  end
end

function BirthdayDataManager:CheckTimeIsExpiredInRedPacketShowEffect(time)
  if time == nil then
    time = 0
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime - time > BirthdayRedPacketShowEffectExpireTimeDayNum * 24 * 60 * 60 * 1000 then
    return true
  else
    return false
  end
end

BirthdayDataManager.__init = __init
BirthdayDataManager.__delete = __delete
return BirthdayDataManager
