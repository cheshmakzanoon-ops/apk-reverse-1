local NoWorkerContent = BaseClass("NoWorkerContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local NoWorkItem = require("UI.UIBuildHeroList.Component.NoWorkItem")
local no_worker_cell_path = "NoWorkerCell"
local content_path = "scrollView/Viewport/Content"
local worker_cell_list_path = "scrollView/Viewport/Content/workerCellList"
local bottom_btn_path = "bottomBtn"

function NoWorkerContent:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function NoWorkerContent:OnDestroy()
  self:ClearAllItem()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function NoWorkerContent:ComponentDefine()
  self.no_worker_cell = self:AddComponent(UIBaseContainer, no_worker_cell_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.worker_cell_list = self:AddComponent(UIBaseContainer, worker_cell_list_path)
  self.cellList = {}
  self.no_worker_cell:SetActive(false)
  self.no_worker_cell.gameObject:GameObjectCreatePool()
  self.bottom_btn = self:AddComponent(UIButton, bottom_btn_path)
  self.bottom_btn:SetOnClick(function()
    self:OnBottomBtnClick()
  end)
end

function NoWorkerContent:ComponentDestroy()
  self.no_worker_cell = nil
  self.content = nil
  self.worker_cell_list = nil
  self.bottom_btn = nil
end

function NoWorkerContent:DataDefine()
  self.curBuildIndex = nil
  self.slot = nil
end

function NoWorkerContent:DataDestroy()
  self.curBuildIndex = nil
  self.slot = nil
end

function NoWorkerContent:ClearAllItem()
  self.worker_cell_list:RemoveComponents(NoWorkItem)
  for _, v in ipairs(self.worker_cell_list.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.no_worker_cell.gameObject:GameObjectRecycleAll()
  self.cellList = {}
end

function NoWorkerContent:ReInit(curBuildIndex, slot)
  self.curBuildIndex = curBuildIndex
  self.slot = slot
  local buildData = self.view.ctrl:GetCurBuildData()
  local dataList = DataCenter.WorkerTemplateManager:GetAllWorkerForBuild(buildData.itemId)
  local showData = {}
  for _, v in ipairs(dataList) do
    table.insert(showData, v)
  end
  table.sort(showData, function(a, b)
    if a.quality ~= b.quality then
      return a.quality > b.quality
    end
    return a.id < b.id
  end)
  self.content:SetAnchoredPositionXY(0, 0)
  self:ClearAllItem()
  for showIndex, v in ipairs(showData) do
    local item = self.no_worker_cell.gameObject:GameObjectSpawn(self.worker_cell_list.transform)
    item.name = showIndex
    local obj = self.worker_cell_list:AddComponent(NoWorkItem, item.name)
    obj:SetActive(true)
    self.cellList[showIndex] = obj
    obj:ReInit(v.id)
  end
end

function NoWorkerContent:OnBottomBtnClick()
  GoToUtil.GotoWorkerRecruitView(true)
end

return NoWorkerContent
