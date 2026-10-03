local base = UIBaseContainer
local UIOffSeason1TaskGoalItem = BaseClass("UIOffSeason1TaskGoalItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local ParticleSystem = CS.UnityEngine.ParticleSystem
local ParticleColor = {
  CS.UnityEngine.Color(0.4901961, 0.4901961, 0.4901961, 0.2196078),
  CS.UnityEngine.Color(0.3137255, 0.8705882, 0.1137255, 0.2196078),
  CS.UnityEngine.Color(0.003915994, 0.5723118, 0.8301887, 0.2196078),
  CS.UnityEngine.Color(0.7012566, 0.2042542, 0.9622642, 0.2196078),
  CS.UnityEngine.Color(0.9607843, 0.6765694, 0.2039215, 0.2196078)
}

function UIOffSeason1TaskGoalItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIOffSeason1TaskGoalItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIOffSeason1TaskGoalItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgClose = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgOpened = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textGoalPoint = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnGoalItem = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnGoalItem:SetOnClick(function()
    self:OnBtnGoalItemClick()
  end)
  self.imgCloseTrans = self.imgClose.transform
end

function UIOffSeason1TaskGoalItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgClose = nil
  self.imgOpened = nil
  self.textGoalPoint = nil
  self.btnGoalItem = nil
  self.bgEffectM = nil
  self.imgCloseTrans = nil
end

function UIOffSeason1TaskGoalItem:DataDefine()
end

function UIOffSeason1TaskGoalItem:DataDestroy()
  self:StopRotation()
  self.isSend = nil
  self.groupId = nil
  self.taskId = nil
  self.state = nil
end

function UIOffSeason1TaskGoalItem:OnAddListener()
  base.OnAddListener(self)
end

function UIOffSeason1TaskGoalItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIOffSeason1TaskGoalItem:OnBtnGoalItemClick()
  if self.state == TaskState.CanReceive then
    if self.isSend then
      return
    end
    self.isSend = true
    SFSNetwork.SendMessage(MsgDefines.CityBattleActivityGainTaskReward, tonumber(self.groupId), -2)
  elseif self.reward and self.imgOpened and not table.IsNullOrEmpty(self.reward) then
    local size = self.imgOpened:GetSizeDelta()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRewardContentTip, {anim = true}, self.imgOpened, self.reward, 0, -size.y / 2)
  end
end

function UIOffSeason1TaskGoalItem:PlayRotation()
  if self.tween then
    return
  end
  if self.imgClose then
    self.imgCloseTrans.localRotation = Quaternion.identity
    self.tween = DOTween.Sequence()
    self.tween:Append(self.imgCloseTrans:DOLocalRotate(Vector3(0, 0, 10), 0.1))
    self.tween:Append(self.imgCloseTrans:DOLocalRotate(Vector3(0, 0, 0), 0.1))
    self.tween:Append(self.imgCloseTrans:DOLocalRotate(Vector3(0, 0, -10), 0.1))
    self.tween:Append(self.imgCloseTrans:DOLocalRotate(Vector3(0, 0, 0), 0.1))
    self.tween:SetLoops(-1, CS.DG.Tweening.LoopType.Restart)
  end
end

function UIOffSeason1TaskGoalItem:StopRotation()
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
  if self.imgClose then
    self.imgCloseTrans.localRotation = Quaternion.identity
  end
end

function UIOffSeason1TaskGoalItem:SetData(groupId, taskInfo, index)
  self.groupId = groupId
  self.taskId = taskInfo.id
  self.state = taskInfo.hasReward
  self.reward = taskInfo.reward and DataCenter.RewardManager:ReturnRewardParamForMessage(taskInfo.reward)
  self.imgClose:LoadSprite("Assets/Main/Sprites/UI/LWOffSeason1/Recapture/lrb_zhouliuhuodong_baoxiangkai_0" .. index .. ".png")
  self.imgClose:SetActive(self.state ~= TaskState.Received)
  self.imgOpened:LoadSprite("Assets/Main/Sprites/UI/LWOffSeason1/Recapture/lrb_zhouliuhuodong_baoxiangguan_0" .. index .. ".png")
  self.imgOpened:SetActive(self.state == TaskState.Received)
  self.isSend = false
  self.textGoalPoint:SetText(taskInfo.totalNum)
  if self.state == TaskState.CanReceive then
    self:PlayRotation()
  else
    self:StopRotation()
  end
end

return UIOffSeason1TaskGoalItem
