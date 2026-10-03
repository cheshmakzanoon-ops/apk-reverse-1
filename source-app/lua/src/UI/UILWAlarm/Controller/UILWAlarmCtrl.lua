local UILWAlarmCtrl = BaseClass("UILWAlarmCtrl", UIBaseCtrl)
local SettingBtn = {
  {
    language = 801319,
    key = "Investigation",
    eventId = EventId.Alarm_Investigation_UpdateSetting
  },
  {
    language = 801321,
    key = "ScreenEffects",
    eventId = EventId.Alarm_ScreenEffects_UpdateSetting
  }
}

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UILWAlarm, {anim = true})
end

local function GetMarchDataList(self, alarmUIOpenType)
  if alarmUIOpenType == AlarmUIOpenType.DesertBattleUI then
    return MarchUtil.GetDesertBattleAlarmList()
  else
    return MarchUtil.GetaLlarmList()
  end
end

local function GetSettingBtn()
  return SettingBtn
end

local function IsShow(uidList, tempUid)
  for i, uid in pairs(uidList) do
    if tonumber(uid) == tempUid then
      return true
    end
  end
end

local function SetMaskUid(alarmUIOpenType)
  local isDesertBattle = alarmUIOpenType == AlarmUIOpenType.DesertBattleUI
  local list = DataCenter.WorldMarchDataManager:GetTargetMinAlarm(isDesertBattle)
  local str = ""
  if alarmUIOpenType == AlarmUIOpenType.DesertBattleUI then
    str = CommonUtil.PlayerPrefsGetString(SettingKeys.DESERT_BATTLE_MASK_ALARM_UID, "")
  else
    str = CommonUtil.PlayerPrefsGetString("maskAlarmUids", "")
  end
  if string.IsNullOrEmpty(str) then
    for i, v in pairs(list) do
      str = str .. "|" .. v.uuid
    end
  else
    local newStr = ""
    local uidList = string.split(str, "|")
    for i, uid in pairs(uidList) do
      for i, newListUid in pairs(list) do
        if tonumber(uid) == newListUid.uuid then
          if not string.IsNullOrEmpty(newStr) then
            newStr = newStr .. "|" .. uid
          else
            newStr = uid
          end
        end
      end
    end
    local uidList = string.split(newStr, "|")
    for i, newListUid in pairs(list) do
      if not IsShow(uidList, newListUid.uuid) then
        newStr = newStr .. "|" .. newListUid.uuid
      end
    end
    str = newStr
  end
  if alarmUIOpenType == AlarmUIOpenType.DesertBattleUI then
    CommonUtil.PlayerPrefsSetString(SettingKeys.DESERT_BATTLE_MASK_ALARM_UID, str)
  else
    CommonUtil.PlayerPrefsSetString("maskAlarmUids", str)
  end
  EventManager:GetInstance():Broadcast(EventId.Alarm_Investigation_UpdateSetting)
end

UILWAlarmCtrl.CloseSelf = CloseSelf
UILWAlarmCtrl.GetMarchDataList = GetMarchDataList
UILWAlarmCtrl.GetSettingBtn = GetSettingBtn
UILWAlarmCtrl.SetMaskUid = SetMaskUid
return UILWAlarmCtrl
