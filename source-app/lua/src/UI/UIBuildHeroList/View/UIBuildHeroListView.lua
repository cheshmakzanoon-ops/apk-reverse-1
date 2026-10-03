local UIBuildHeroListView = BaseClass("UIBuildHeroListView", UIBaseView)
local base = UIBaseView
local WorkerSelectContent = require("UI.UIBuildHeroList.Component.WorkerSelectContent")
local NoWorkerContent = require("UI.UIBuildHeroList.Component.NoWorkerContent")
local title_path = "panel/Common_bg_orange/text_title"
local close_path = "panel"
local close_btn_path = "panel/Common_bg_orange/closeBtn"
local worker_select_content_path = "panel/Common_bg_orange/CenterContent/WorkerSelectContent"
local no_worker_content_path = "panel/Common_bg_orange/CenterContent/NoWorkerContent"

function UIBuildHeroListView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function UIBuildHeroListView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBuildHeroListView:DataDefine()
  self.curBuildIndex = nil
  self.heroDatalist = {}
  self.slot = nil
end

function UIBuildHeroListView:DataDestroy()
  self.heroDatalist = nil
  self.curBuildIndex = nil
  self.slot = nil
end

function UIBuildHeroListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.ReInit)
  self:AddUIListener(EventId.WorkerFragUnlock, self.ReInit)
end

function UIBuildHeroListView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.ReInit)
  self:RemoveUIListener(EventId.WorkerFragUnlock, self.ReInit)
end

function UIBuildHeroListView:ComponentDefine()
  self.close = self:AddComponent(UIButton, close_path)
  self.titleText = self:AddComponent(UIText, title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleText:SetLocalText(135187)
  self.worker_select_content = self:AddComponent(WorkerSelectContent, worker_select_content_path)
  self.no_worker_content = self:AddComponent(NoWorkerContent, no_worker_content_path)
end

function UIBuildHeroListView:ComponentDestroy()
end

function UIBuildHeroListView:ReInit()
  self.curBuildIndex, self.slot = self:GetUserData()
  self.ctrl:UpdateDispatchingHeroDic()
  self.ctrl:SetCurBuildIndex(self.curBuildIndex)
  self.heroDatalist = self.ctrl:GetBuildShowHeroDataList(self.curBuildIndex)
  if self.heroDatalist and #self.heroDatalist > 0 then
    local buildData = self.ctrl:GetCurBuildData()
    local targetUuid = buildData.assignedHeroList[self.slot + 1]
    if targetUuid and not string.IsNullOrEmpty(targetUuid) then
      local targetUuidNum = tonumber(targetUuid)
      local targetHeroData
      local targetIndex = -1
      for i, v in ipairs(self.heroDatalist) do
        if v.uid == targetUuidNum then
          targetIndex = i
          targetHeroData = v
          break
        end
      end
      if 0 < targetIndex then
        table.remove(self.heroDatalist, targetIndex)
        table.insert(self.heroDatalist, 1, targetHeroData)
      end
    end
    self.worker_select_content:SetActive(true)
    self.no_worker_content:SetActive(false)
    self.worker_select_content:ReInit(self.heroDatalist, self.curBuildIndex, self.slot)
  else
    self.worker_select_content:SetActive(false)
    self.no_worker_content:SetActive(true)
    self.no_worker_content:ReInit(self.curBuildIndex, self.slot)
  end
end

return UIBuildHeroListView
