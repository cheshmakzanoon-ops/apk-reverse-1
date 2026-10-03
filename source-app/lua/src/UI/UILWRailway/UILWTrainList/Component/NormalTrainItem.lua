local base = require("UI.UILWRailway.UILWTrainList.Component.TrainItemBase")
local NormalTrainItem = BaseClass("NormalTrainItem", base)

function NormalTrainItem:SetData(trainData, index)
  base.SetData(self, trainData)
  self.qualityImage:LoadSprite(trainData:GetQualityPath())
  if CS.CommonUtils.IsDebug() then
    self.desc4:SetText(tostring(index))
  end
end

return NormalTrainItem
