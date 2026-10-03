local UIDetectSlotBoxOpenCtrl = BaseClass("UIDetectSlotBoxOpenCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDetectSlotBoxOpen)
end

function UIDetectSlotBoxOpenCtrl:BoxClickHandler(index, panelType, param)
  if panelType == UIDetectSlotBoxPanelType.DetectCaveExplorePanelType then
    DataCenter.CaveExplorationManager:TryNextStep(param.uuid, param.configId, param.index)
  end
end

UIDetectSlotBoxOpenCtrl.CloseSelf = CloseSelf
return UIDetectSlotBoxOpenCtrl
