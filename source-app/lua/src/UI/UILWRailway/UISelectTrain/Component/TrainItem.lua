local TrainItem = BaseClass("TrainItem", UIBaseContainer)
local base = UIBaseContainer

function TrainItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TrainItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TrainItem:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    UIUtil.OnClickWorldTroop(self.trainData.marchUid, true)
    if self.view and self.view.ctrl then
      self.view.ctrl:CloseSelf()
    end
  end)
  self.name = self:AddComponent(UIText, "name")
  self.quality = self:AddComponent(UIImage, "Quality")
end

function TrainItem:ComponentDestroy()
end

function TrainItem:SetData(trainData)
  self.trainData = trainData
  self.name:SetText(self.trainData:GetAbbrAndName())
  self.quality:LoadSprite(self.trainData:GetQualityPath())
end

function TrainItem:DataDefine()
end

function TrainItem:DataDestroy()
  self.trainData = nil
end

function TrainItem:OnEnable()
  base.OnEnable(self)
end

function TrainItem:OnDisable()
  base.OnDisable(self)
end

function TrainItem:OnAddListener()
  base.OnAddListener(self)
end

function TrainItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

return TrainItem
