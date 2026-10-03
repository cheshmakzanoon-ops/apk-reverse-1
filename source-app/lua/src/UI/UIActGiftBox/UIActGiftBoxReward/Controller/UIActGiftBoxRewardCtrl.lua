local UIActGiftBoxRewardCtrl = BaseClass("UIActGiftBoxRewardCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIActGiftBoxReward)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIActGiftBoxRewardNew)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function GetOptionParamList(self, activityId)
  local paramList = {}
  local templateList = DataCenter.ActGiftBoxData:GetOpenTemplateListByActId(activityId)
  for i = 1, table.count(templateList) do
    local template = templateList[i]
    local param = {}
    param.tabId = template.id
    param.title = Localization:GetString(template.settings_name)
    table.insert(paramList, param)
  end
  table.sort(paramList, function(a, b)
    return a.tabId < b.tabId
  end)
  return paramList
end

UIActGiftBoxRewardCtrl.CloseSelf = CloseSelf
UIActGiftBoxRewardCtrl.Close = Close
UIActGiftBoxRewardCtrl.GetOptionParamList = GetOptionParamList
return UIActGiftBoxRewardCtrl
