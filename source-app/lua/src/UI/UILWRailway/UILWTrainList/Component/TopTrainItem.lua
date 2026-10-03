local base = require("UI.UILWRailway.UILWTrainList.Component.TrainItemBase")
local TopTrainItem = BaseClass("TopTrainItem", base)

function TopTrainItem:ComponentDefine()
  base.ComponentDefine(self)
  self.bg = self:AddComponent(UIRawImage, "bg")
end

function TopTrainItem:ComponentDestroy()
  base.ComponentDestroy(self)
  self.bg = nil
end

function TopTrainItem:RefreshEverySec()
  base.RefreshEverySec(self)
  self.title:SetLocalText("457511")
end

function TopTrainItem:SetData(trainData)
  base.SetData(self, trainData)
  self.bg:LoadSprite(string.format("Assets/Main/TextureEx/UILWRailway/cfm_chengjimaoyi_huocheyunxingshikebiao_pinzhi_%s.png", trainData.quality))
  self.desc4:SetLocalText("457513")
end

return TopTrainItem
