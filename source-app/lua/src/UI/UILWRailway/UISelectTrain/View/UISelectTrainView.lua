local UISelectTrainView = BaseClass("UISelectTrainView", UIBaseView)
local SelectTrainItem = require("UI.UILWRailway.UISelectTrain.Component.TrainItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UISelectTrainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UISelectTrainView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISelectTrainView:OnEnable()
  self:SetData(self:GetUserData())
end

function UISelectTrainView:OnDisable()
end

function UISelectTrainView:ComponentDefine()
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(function()
    self.ctrl.CloseSelf(self.ctrl)
  end)
  self.content = self:AddComponent(UIBaseContainer, "content")
  self.trainItem = self.transform:Find("content/train").gameObject
  self.trainItem:GameObjectCreatePool()
  self.trainItem:SetActive(false)
end

function UISelectTrainView:ComponentDestroy()
  self.content:RemoveComponents(SelectTrainItem)
  self.trainItem.gameObject:GameObjectRecycleAll()
  self.trainItem = nil
  self.content = nil
end

function UISelectTrainView:SetData(trainDatas)
  self.content:RemoveComponents(SelectTrainItem)
  self.trainItem.gameObject:GameObjectRecycleAll()
  local list = {}
  for _, v in pairs(trainDatas) do
    table.insert(list, v)
  end
  table.sort(list, function(a, b)
    return a.departureTs < b.departureTs
  end)
  for i = 1, #list do
    local item = self.trainItem:GameObjectSpawn(self.content.transform)
    item.name = "train" .. i
    local obj = self.content:AddComponent(SelectTrainItem, item.name)
    obj:SetData(list[i])
  end
end

return UISelectTrainView
