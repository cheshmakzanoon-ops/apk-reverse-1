local GuideNpcUnit = require("DataCenter.LWGuideManager.GuideModel.GuideNpcUnit")
local GuideSoldie = BaseClass("GuideSoldie", GuideNpcUnit)

function GuideSoldie:OnArrivalTerminal()
  self.data.openUIFun()
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonPanelBtn)
  if window ~= nil and window.View ~= nil then
    window.View:SetCanClick(true)
  end
end

return GuideSoldie
