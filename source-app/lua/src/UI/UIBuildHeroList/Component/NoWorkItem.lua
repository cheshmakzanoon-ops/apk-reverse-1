local NoWorkItem = BaseClass("NoWorkItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIWorkerShowCell = require("UI.UILWWorker.UIWorkerOverviewList.Component.UIWorkerShowCell")
local u_i_worker_show_cell_path = "workerInfo/UIWorkerShowCell"

function NoWorkItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function NoWorkItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function NoWorkItem:ComponentDefine()
  self.u_i_worker_show_cell = self:AddComponent(UIWorkerShowCell, u_i_worker_show_cell_path)
  self.root = self:AddComponent(UIButton, "")
  self.root:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function NoWorkItem:ComponentDestroy()
  self.u_i_worker_show_cell = nil
  self.root = nil
end

function NoWorkItem:DataDefine()
end

function NoWorkItem:DataDestroy()
end

function NoWorkItem:ReInit(param)
  self.param = param
  self.u_i_worker_show_cell:SetData(param)
end

function NoWorkItem:OnBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorkerInfoDetail, {anim = true}, self.param)
end

return NoWorkItem
