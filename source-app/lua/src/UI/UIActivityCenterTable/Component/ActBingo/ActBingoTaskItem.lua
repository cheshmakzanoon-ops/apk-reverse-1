local ActBingoTaskItem = BaseClass("ActBingoTaskItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local un_fin_content_path = "unFinContent"
local icon_path = "unFinContent/icon"
local red_point_path = "unFinContent/redPoint"

function ActBingoTaskItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActBingoTaskItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActBingoTaskItem:ComponentDefine()
  self.un_fin_content = self:AddComponent(UIButton, un_fin_content_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.un_fin_content:SetOnClick(function()
    self:OnClick()
  end)
end

function ActBingoTaskItem:ComponentDestroy()
  self.un_fin_content = nil
  self.icon = nil
  self.red_point = nil
end

function ActBingoTaskItem:DataDefine()
  self.activityId = nil
  self.taskData = nil
  self.index = nil
  self.activityDetailData = nil
end

function ActBingoTaskItem:DataDestroy()
  self.activityId = nil
  self.taskData = nil
  self.index = nil
  self.activityDetailData = nil
end

function ActBingoTaskItem:SetData(activityId, taskData, index, activityDetailData)
  self.activityId = activityId
  self.taskData = taskData
  self.index = index
  self.activityDetailData = activityDetailData
  local taskId = self.taskData.taskId
  local taskInfo = DataCenter.ActivityTaskTemplateManager:GetActTaskTemplate(taskId)
  self.icon:LoadSprite(string.format(LoadPath.ActBingoSpritePath, taskInfo.icon))
  local state = self.taskData.state
  if state == TaskState.Received then
    self.un_fin_content:SetActive(false)
  elseif state == TaskState.CanReceive then
    self.un_fin_content:SetActive(true)
    self.red_point:SetActive(true)
  else
    self.un_fin_content:SetActive(true)
    self.red_point:SetActive(false)
  end
end

function ActBingoTaskItem:OnClick()
  if self.taskData == nil then
    return
  end
  local state = self.taskData.state
  if state == TaskState.Received then
    return
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActBingoTaskInfo, {anim = true}, {
      activityId = self.activityId,
      taskData = self.taskData,
      index = self.index,
      activityDetailData = self.activityDetailData
    })
  end
end

return ActBingoTaskItem
