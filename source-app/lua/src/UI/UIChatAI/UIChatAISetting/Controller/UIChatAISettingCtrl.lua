local UIChatAISettingCtrl = BaseClass("UIChapterSwitchCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UIChatAISettingCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIChatAISetting, {anim = true})
end

function UIChatAISettingCtrl:Close()
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

function UIChatAISettingCtrl:GetDataForUI()
  local ret = {
    {
      head = true,
      text = Localization:GetString(900500)
    }
  }
  local dataList = DataCenter.LWChatAIManager:GetSwitchRecv()
  for id, data in pairs(dataList) do
    table.insert(ret, {
      id = id,
      head = false,
      text = data:GetTitle(),
      detail = data:GetDetail()
    })
  end
  table.insert(ret, {
    head = true,
    text = Localization:GetString(900501)
  })
  dataList = DataCenter.LWChatAIManager:GetSwitchPush()
  for id, data in pairs(dataList) do
    table.insert(ret, {
      id = id,
      head = false,
      text = data:GetTitle(),
      detail = data:GetDetail()
    })
  end
  return ret
end

return UIChatAISettingCtrl
