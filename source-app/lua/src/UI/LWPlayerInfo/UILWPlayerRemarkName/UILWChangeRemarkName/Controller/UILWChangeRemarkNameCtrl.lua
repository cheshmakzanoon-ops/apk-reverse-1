local UILWChangeRemarkNameCtrl = BaseClass("UILWChangeRemarkNameCtrl", UIBaseCtrl)
local SettingConfig = {
  {
    name = "notify",
    text = "2900010",
    type = PlayerDetailBottomBtnType.Notify
  },
  {
    name = "sticky",
    text = "convo_top_set",
    type = PlayerDetailBottomBtnType.Sticky
  },
  {
    name = "block",
    text = "290007",
    type = PlayerDetailBottomBtnType.Block
  },
  {
    name = "report",
    text = "208251",
    type = PlayerDetailBottomBtnType.Report
  }
}
local PRIVATE_CHAT_STICKY_LIST = "PRIVATE_CHAT_STICKY_LIST"

function UILWChangeRemarkNameCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWChangeRemarkName)
end

function UILWChangeRemarkNameCtrl:GetSettingConfig(uid)
  local config = DeepCopy(SettingConfig)
  local initPush = DataCenter.PushSettingsManager:GetUserPushSetting(uid)
  local list = ChatManager2:GetInstance().Restrict:GetShieldInfoList()
  local initBlackSetting = false
  if list then
    for i, data in pairs(list) do
      if data.uid == uid then
        initBlackSetting = true
      end
    end
  end
  local stickyList = CommonUtil.PlayerPrefsGetTable(PRIVATE_CHAT_STICKY_LIST, {})
  local isShow = uid ~= nil and stickyList[tostring(uid)] ~= nil
  for i = 1, #config do
    if config[i].type == PlayerDetailBottomBtnType.Notify then
      config[i].isOn = initPush
    elseif config[i].type == PlayerDetailBottomBtnType.Sticky then
      config[i].isOn = isShow
    elseif config[i].type == PlayerDetailBottomBtnType.Block then
      config[i].isOn = initBlackSetting
    end
  end
  return config
end

function UILWChangeRemarkNameCtrl:CheckName(value, originalName)
  local type
  if #value < MIN_AL_NAME_CHAR then
    type = CheckNameType.MinNameChar
  elseif #value > MAX_AL_NAME_CHAR then
    type = CheckNameType.MaxNameChar
  end
  if value == originalName then
    type = CheckNameType.Unchanged
  end
  return type
end

function UILWChangeRemarkNameCtrl:SendChangeNameMessage(targetUid, remarkName)
  SFSNetwork.SendMessage(MsgDefines.RemarkNameChangeMessage, targetUid, remarkName)
end

return UILWChangeRemarkNameCtrl
