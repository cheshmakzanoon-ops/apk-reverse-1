local UILWPowerUpActivityRewardsView = BaseClass("UILWPowerUpActivityRewardsView", UIBaseView)
local LeadingQuestItem = require("UI.UILWPowerUpActivityRewards.Comp.PowerUpActivityRewardCell")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UILWPowerUpActivityRewardsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWPowerUpActivityRewardsView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWPowerUpActivityRewardsView:ComponentDefine()
  self.closeBtn = self:AddComponent(UIButton, "ImgBg")
  local time = CS.UnityEngine.Time.time
  self.closeBtn:SetOnClick(function()
    if CS.UnityEngine.Time.time - time < 0.618 then
      return
    end
    self.ctrl:CloseSelf()
  end)
  self.btnClose = self:AddComponent(UIButton, "Rect_Bottom/bg/btnClose")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.svQuestsN = self:AddComponent(UIScrollView, "Rect_Bottom/ScrollView")
  self.svQuestsN:SetOnItemMoveIn(function(itemObj, index)
    self:OnQuestItemMoveIn(itemObj, index)
  end)
  self.svQuestsN:SetOnItemMoveOut(function(itemObj, index)
    self:OnQuestItemMoveOut(itemObj, index)
  end)
  self:RefreshData()
end

function UILWPowerUpActivityRewardsView:RefreshData()
  local actId = DataCenter.ActivityListDataManager:GetOpenIdByType(EnumActivity.LeadingQuestV2.Type)
  if not actId then
    self.ctrl:CloseSelf()
    return
  end
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
  if not activityData then
    self.ctrl:CloseSelf()
    return
  end
  self.activityInfo = DataCenter.LWLeadingQuestV2Manager.info
  self.activityData = activityData
  self.taskList = self:GetTaskListSorted()
  if #self.taskList > 0 then
    self.svQuestsN:SetTotalCount(#self.taskList)
    self.svQuestsN:RefillCells()
  end
end

function UILWPowerUpActivityRewardsView:GetTaskListSorted()
  if not self.activityInfo then
    return {}
  end
  self.rawTaskList = DataCenter.LWLeadingQuestV2Manager:GetIndexedTasks()
  local tasks = self.activityInfo.taskArr
  table.sort(tasks, function(a, b)
    local taskValueA = a
    local taskValueB = b
    if not taskValueA then
      return false
    elseif not taskValueB then
      return true
    elseif taskValueA.state ~= taskValueB.state then
      if taskValueA.state == 1 then
        return true
      elseif taskValueB.state == 1 then
        return false
      elseif taskValueA.state == 2 then
        return false
      elseif taskValueB.state == 2 then
        return true
      end
    else
      return tonumber(a.taskId) < tonumber(b.taskId)
    end
  end)
  return tasks
end

function UILWPowerUpActivityRewardsView:OnQuestItemMoveIn(itemObj, index)
  itemObj.name = itemObj.name .. tostring(index)
  local cellItem = self.svQuestsN:AddComponent(LeadingQuestItem, itemObj)
  cellItem:SetItem(self.taskList[index], self.activityInfo.activityId, index, self.rawTaskList)
end

function UILWPowerUpActivityRewardsView:OnQuestItemMoveOut(itemObj, index)
  self.svQuestsN:RemoveComponent(itemObj.name, LeadingQuestItem)
end

function UILWPowerUpActivityRewardsView:ClearScroll()
  self.svQuestsN:ClearCells()
  self.svQuestsN:RemoveComponents(LeadingQuestItem)
end

function UILWPowerUpActivityRewardsView:ComponentDestroy()
  self.btnClose = nil
  self.scrollViewScrollView = nil
  self:ClearScroll()
end

function UILWPowerUpActivityRewardsView:DataDefine()
end

function UILWPowerUpActivityRewardsView:DataDestroy()
end

function UILWPowerUpActivityRewardsView:OnAddListener()
  base.OnAddListener(self)
end

function UILWPowerUpActivityRewardsView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWPowerUpActivityRewardsView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return UILWPowerUpActivityRewardsView
