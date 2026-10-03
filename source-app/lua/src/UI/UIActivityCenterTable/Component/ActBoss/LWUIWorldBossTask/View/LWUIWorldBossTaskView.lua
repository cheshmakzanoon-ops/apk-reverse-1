local LWUIWorldBossTaskView = BaseClass("LWUIWorldBossTaskView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local LWUIWorldBossTaskItem = require("UI.UIActivityCenterTable.Component.ActBoss.LWUIWorldBossTask.Component.LWUIWorldBossTaskItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local reward_item_path = "PopUpTitle/Common_bg_orange2/RewardItem"
local cell_path = "PopUpTitle/Common_bg_orange2/cell"
local content_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content"

function LWUIWorldBossTaskView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self:ComponentDefine()
end

function LWUIWorldBossTaskView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIWorldBossTaskView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnActBossRankRefresh, self.Refresh)
end

function LWUIWorldBossTaskView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnActBossRankRefresh, self.Refresh)
  base.OnRemoveListener(self)
end

function LWUIWorldBossTaskView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("456065")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.scrollView = self:AddComponent(UIScrollView, "PopUpTitle/Common_bg_orange2/ScrollView")
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self:Refresh()
end

function LWUIWorldBossTaskView:ComponentDestroy()
  self.param = nil
  self.fakeIndex = nil
  self.showDatalist = nil
  self:ClearScroll()
  self.btn_back = nil
end

function LWUIWorldBossTaskView:Refresh()
  self:RefreshTaskData()
  if self.showDatalist and #self.showDatalist > 0 then
    self.scrollView:SetActive(true)
    self.scrollView:SetTotalCount(#self.showDatalist)
    self.scrollView:RefillCells()
  else
    self.scrollView:SetActive(false)
  end
end

function LWUIWorldBossTaskView:OnItemMoveIn(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollView:AddComponent(LWUIWorldBossTaskItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  local data = self.showDatalist[index]
  if self.fakeIndex and self.fakeIndex == index then
    item:ReInit(self.param, data.id, data, true)
  else
    item:ReInit(self.param, data.id, data, false)
  end
end

function LWUIWorldBossTaskView:OnItemMoveOut(itemObj, index)
end

function LWUIWorldBossTaskView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(LWUIWorldBossTaskItem)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.showDatalist = {}
end

function LWUIWorldBossTaskView:OnRefreshWorldBossAchievementShowInfoView()
  self:Refresh()
end

function LWUIWorldBossTaskView:RefreshTaskData()
  local taskList = DataCenter.ActBossDataManager.AchievementTaskData
  if taskList == nil then
    return
  end
  local showHighDamage = DataCenter.ActBossDataManager:GetMaxDamageShow()
  local sortTask = {}
  local fakeTaskInfo
  for _, v in ipairs(taskList) do
    if v.reward and (showHighDamage == 0 or showHighDamage >= v.damage) then
      if DataCenter.ActBossDataManager:JudgeAchievementTaskIsValid(v.id) then
        table.insert(sortTask, v)
      elseif fakeTaskInfo == nil or v.damageShowTime < fakeTaskInfo.damageShowTime then
        fakeTaskInfo = v
      end
    end
  end
  local order = {
    [TaskState.CanReceive] = 1,
    [TaskState.NoComplete] = 2,
    [TaskState.Received] = 3
  }
  table.sort(sortTask, function(a, b)
    if a.state ~= b.state then
      return order[a.state] < order[b.state]
    else
      return a.damage < b.damage
    end
  end)
  if fakeTaskInfo then
    local insertIndex = 1
    for i, v in ipairs(sortTask) do
      if v.state == TaskState.Received then
        insertIndex = i
        break
      end
    end
    table.insert(sortTask, insertIndex, fakeTaskInfo)
    self.fakeIndex = insertIndex
  else
    self.fakeIndex = nil
  end
  self.showDatalist = sortTask
end

return LWUIWorldBossTaskView
