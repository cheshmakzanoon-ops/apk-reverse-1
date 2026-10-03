local UIWorldNewsTipsCtrl = BaseClass("UIWorldNewsTipsCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldNewsTips)
end

local function GetAreaData(self, pointId)
  local showList = {}
  local latestTime = 0
  local oneData = {}
  oneData.allianceAbbrList = {}
  local info = DataCenter.WorldNewsDataManager:GetAreaInfoByPointId(pointId)
  if info ~= nil then
    oneData.time = info.time
    latestTime = info.time
    oneData.pointId = info.id
    oneData.allianceAbbrList = info.alInfoList
    DataCenter.WorldNewsDataManager:SetLastGetAreaNewsTime(latestTime)
  end
  return oneData
end

UIWorldNewsTipsCtrl.CloseSelf = CloseSelf
UIWorldNewsTipsCtrl.GetAreaData = GetAreaData
return UIWorldNewsTipsCtrl
