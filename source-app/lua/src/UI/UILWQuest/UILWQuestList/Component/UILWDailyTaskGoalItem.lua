local UILWDailyTaskGoalItem = BaseClass("UILWDailyTaskGoalItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local closePath = "Close"
local openedPath = "Opened"
local goalPointTextPath = "GoalPointBg/GoalPointText"
local effectPath = "EffectGo"
local showContentPath = "showContent"
local contentBtnPath = "showContent/contentImage"
local itemIconPath = "showContent/itemIcon"

function UILWDailyTaskGoalItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDailyTaskGoalItem:OnDestroy()
  self:StopRotation()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDailyTaskGoalItem:ComponentDefine()
  self.close = self:AddComponent(UIBaseContainer, closePath)
  self.opened = self:AddComponent(UIBaseContainer, openedPath)
  self.goalPointText = self:AddComponent(UIText, goalPointTextPath)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    if self.state == TaskState.CanReceive and self.index then
      if self.isSend then
        return
      end
      self.isSend = true
      SFSNetwork.SendMessage(MsgDefines.DailyQuestReward, -1)
    elseif self.goalPoint then
      local reward = DataCenter.DailyTaskManager:GetBoxRewardShow(self.goalPoint)
      if self.opened and not table.IsNullOrEmpty(reward) then
        local size = self.opened:GetSizeDelta()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIRewardContentTip, {anim = true}, self.opened, reward, 0, -size.y / 2)
      end
    end
  end)
  self.effect = self:AddComponent(UIBaseContainer, effectPath)
  self.showContent = self:AddComponent(UIBaseContainer, showContentPath)
  self.contentBtn = self:AddComponent(UIButton, contentBtnPath)
  self.contentBtn:SetOnClick(function()
    if self.state == TaskState.CanReceive and self.index then
      if self.isSend then
        return
      end
      self.isSend = true
      SFSNetwork.SendMessage(MsgDefines.DailyQuestReward, -1)
    elseif self.goalPoint then
      local reward = DataCenter.DailyTaskManager:GetBoxRewardShow(self.goalPoint)
      if self.opened and not table.IsNullOrEmpty(reward) then
        local size = self.opened:GetSizeDelta()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIRewardContentTip, {anim = true}, self.opened, reward, 0, -size.y / 2)
      end
    end
  end)
  self.itemIcon = self:AddComponent(UIImage, itemIconPath)
end

function UILWDailyTaskGoalItem:ComponentDestroy()
  self.close = nil
  self.opened = nil
  self.goalPointText = nil
  self.btn = nil
  self.effect = nil
  self.showContent = nil
  self.contentBtn = nil
  self.itemIcon = nil
end

function UILWDailyTaskGoalItem:DataDefine()
  self.isSend = false
end

function UILWDailyTaskGoalItem:DataDestroy()
end

function UILWDailyTaskGoalItem:SetData(index, goalPoint)
  self.index = index
  self.goalPoint = goalPoint
  self.goalPointText:SetText(self.goalPoint)
  self.isSend = false
end

function UILWDailyTaskGoalItem:PlayRotation()
  if self.tween then
    return
  end
  if self.close then
    self.close.transform.localRotation = Quaternion.identity
    self.tween = DOTween.Sequence()
    self.tween:Append(self.close.transform:DOLocalRotate(Vector3(0, 0, 10), 0.1))
    self.tween:Append(self.close.transform:DOLocalRotate(Vector3(0, 0, 0), 0.1))
    self.tween:Append(self.close.transform:DOLocalRotate(Vector3(0, 0, -10), 0.1))
    self.tween:Append(self.close.transform:DOLocalRotate(Vector3(0, 0, 0), 0.1))
    self.tween:SetLoops(-1, CS.DG.Tweening.LoopType.Restart)
  end
end

function UILWDailyTaskGoalItem:StopRotation()
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
  if self.close then
    self.close.transform.localRotation = Quaternion.identity
  end
end

function UILWDailyTaskGoalItem:SetState(state)
  self.state = state
  self.close:SetActive(self.state ~= TaskState.Received)
  self.opened:SetActive(self.state == TaskState.Received)
  self.isSend = false
  self.effect:SetActive(self.state == TaskState.CanReceive)
  if self.state == TaskState.CanReceive then
    self:PlayRotation()
  else
    self:StopRotation()
  end
  local showItemIcon = DataCenter.DailyTaskManager:GetBoxShowItemIcon(self.goalPoint)
  if not string.IsNullOrEmpty(showItemIcon) and self.state ~= TaskState.Received then
    self.showContent:SetActive(true)
    self.itemIcon:LoadSprite(showItemIcon)
  else
    self.showContent:SetActive(false)
  end
end

return UILWDailyTaskGoalItem
