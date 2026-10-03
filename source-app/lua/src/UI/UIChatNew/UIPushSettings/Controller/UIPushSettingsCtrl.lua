local UIPushSettingsCtrl = BaseClass("UIPushSettingsCtrl", UIBaseCtrl)

function UIPushSettingsCtrl:CloseSelf()
  if self.datas then
    local idList = {}
    local stateList = {}
    for _, data in ipairs(self.datas) do
      if data.id then
        table.insert(idList, data.id)
        table.insert(stateList, data.isOn and 1 or 0)
        if data.isOn then
          DataCenter.PushNoticeManager:CheckNoticeBySettings(data.id)
        else
          DataCenter.PushNoticeManager:CancelNoticeBySettings(data.id)
        end
      end
    end
    SFSNetwork.SendMessage(MsgDefines.LWSaveUserPushSettings, idList, stateList)
    DataCenter.PushSettingsManager:UpdateSettingsMsg(idList, stateList)
    EventManager:GetInstance():Broadcast(EventId.UIPushSettingChange)
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPushSettings)
end

function UIPushSettingsCtrl:OnCustomKeyCodeEscape()
  self:CloseSelf()
end

return UIPushSettingsCtrl
