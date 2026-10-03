local UIWorkerRow = BaseClass("UIWorkerRow", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray
local UIWorkerCell = require("UI.UILWWorker.UIWorkerListPanel.Component.UIWorkerCell")

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function ComponentDefine(self)
  self.worker1 = self:AddComponent(UIWorkerCell, "UIWorkerCell1")
  self.worker2 = self:AddComponent(UIWorkerCell, "UIWorkerCell2")
  self.worker3 = self:AddComponent(UIWorkerCell, "UIWorkerCell3")
  self.worker4 = self:AddComponent(UIWorkerCell, "UIWorkerCell4")
  self.workers = {
    self.worker1,
    self.worker2,
    self.worker3,
    self.worker4
  }
end

local function ComponentDestroy(self)
  self.worker1 = nil
  self.worker2 = nil
  self.worker3 = nil
  self.worker4 = nil
  self.workers = nil
end

local function SetData(self, workers, callBack, workerList, curRow, residentWorkerCount)
  if workers == nil then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  for i = 1, 4 do
    local worker = workers[i]
    local curWorkerIndex = (curRow - 1) * 4 + i
    curWorkerIndex = curWorkerIndex + (residentWorkerCount or 0)
    self.workers[i]:SetData(worker, callBack, curWorkerIndex, workerList)
  end
end

UIWorkerRow.OnCreate = OnCreate
UIWorkerRow.OnDestroy = OnDestroy
UIWorkerRow.OnEnable = OnEnable
UIWorkerRow.OnDisable = OnDisable
UIWorkerRow.DataDefine = DataDefine
UIWorkerRow.DataDestroy = DataDestroy
UIWorkerRow.ComponentDefine = ComponentDefine
UIWorkerRow.ComponentDestroy = ComponentDestroy
UIWorkerRow.SetData = SetData
return UIWorkerRow
