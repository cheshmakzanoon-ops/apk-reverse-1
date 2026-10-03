local UILWAllianceFirstJoinCtrl = BaseClass("UILWAllianceFirstJoinCtrl", UIBaseCtrl)
local AllianceRecommendInfo = require("DataCenter.AllianceData.AllianceRecommendInfo")

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAllianceFirstJoin)
end

function UILWAllianceFirstJoinCtrl:ParseMsg(msg)
  local dataList = {}
  if msg and msg.recommendAllianceInfo then
    for i, v in ipairs(msg.recommendAllianceInfo) do
      local data = AllianceRecommendInfo.New()
      data:ParseMsg(v)
      dataList[i] = data
    end
  end
  return dataList
end

UILWAllianceFirstJoinCtrl.CloseSelf = CloseSelf
return UILWAllianceFirstJoinCtrl
