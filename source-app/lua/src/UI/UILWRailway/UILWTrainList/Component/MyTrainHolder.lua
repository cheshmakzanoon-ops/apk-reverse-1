local MyTrainHolder = BaseClass("MyTrainHolder", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local MyTrainItem = require("UI.UILWRailway.UILWTrainList.Component.MyTrainItem")

function MyTrainHolder:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MyTrainHolder:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MyTrainHolder:ComponentDefine()
  self.title = self:AddComponent(UIText, "Title")
  self.subTitle = self:AddComponent(UIText, "SubTitle")
  self.content = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content")
  self.trainItem = self.transform:Find("ScrollView/Viewport/Content/MyTrainItem").gameObject
  self.trainItem:GameObjectCreatePool()
  self.trainItem:SetActive(false)
  self.trainItemsList = {}
end

function MyTrainHolder:ComponentDestroy()
  self:RemoveTimer()
  self:RemoveList()
  self.content = nil
  self.trainItem = nil
end

function MyTrainHolder:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1.5, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function MyTrainHolder:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function MyTrainHolder:RefreshEverySec()
  for _, v in pairs(self.trainItemsList) do
    v:RefreshEverySec()
  end
end

function MyTrainHolder:DataDefine()
  self.timer_action = BindCallback(self, self.RefreshEverySec)
end

function MyTrainHolder:DataDestroy()
  self.timer_action = nil
end

function MyTrainHolder:OnEnable()
  base.OnEnable(self)
  self:AddTimer()
end

function MyTrainHolder:OnDisable()
  base.OnDisable(self)
  self:RemoveTimer()
end

function MyTrainHolder:OnAddListener()
  base.OnAddListener(self)
end

function MyTrainHolder:OnRemoveListener()
  base.OnRemoveListener(self)
end

function MyTrainHolder:RefreshContent()
  self:RefreshTitle()
  self:RefreshList()
end

function MyTrainHolder:RefreshTitle()
  local cur, max = DataCenter.LWMyStationDataManager:GetDepartureCount()
  self.subTitle:SetText(Localization:GetString(457565) .. ": " .. cur .. "/" .. max)
end

function MyTrainHolder:RemoveList()
  self.content:RemoveComponents(MyTrainItem)
  self.trainItem.gameObject:GameObjectRecycleAll()
  self.trainItemsList = {}
end

function MyTrainHolder:RefreshList()
  self:RemoveList()
  for i = 1, 4 do
    local item = self.trainItem:GameObjectSpawn(self.content.transform)
    item.name = "MyTrainItem" .. i
    self.trainItemsList[i] = self.content:AddComponent(MyTrainItem, item.name)
    self.trainItemsList[i]:SetData(i)
  end
end

return MyTrainHolder
