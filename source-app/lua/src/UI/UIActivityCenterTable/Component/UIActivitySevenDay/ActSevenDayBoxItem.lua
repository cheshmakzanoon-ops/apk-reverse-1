local ActSevenDayBoxItem = BaseClass("ActSevenDayBoxItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Content_path = "Content"
local ItemIcon = "Content/ItemIcon"
local ImgQuality = "Content/ImgQuality"
local NumText = "Content/NumText"
local ImgRece = "ImgRece"
local CanReceiveBg = "Content/CanReceiveBg"
local ScoreTxt = "Txt_Progress"
local path = ""

function ActSevenDayBoxItem:OnCreate()
  base.OnCreate(self)
  self._content = self:AddComponent(UIBaseContainer, Content_path)
  self._icon_img = self:AddComponent(UIImage, ItemIcon)
  self._item_quality = self:AddComponent(UIImage, ImgQuality)
  self._can_receive_img = self:AddComponent(UIImage, CanReceiveBg)
  self._num_txt = self:AddComponent(UIText, NumText)
  self._score_txt = self:AddComponent(UIText, ScoreTxt)
  self._img_rece = self:AddComponent(UIImage, ImgRece)
  self._box_btn = self:AddComponent(UIButton, path)
  self._box_btn:SetOnClick(function()
    self:OnClickGo()
  end)
end

function ActSevenDayBoxItem:OnDestroy()
  self:StopRotation()
  self._icon_img = nil
  self._item_quality = nil
  self._can_receive_img = nil
  self._num_txt = nil
  self._img_rece = nil
  self._box_btn = nil
  self._score_txt = nil
  base.OnDestroy(self)
end

function ActSevenDayBoxItem:OnEnable()
  base.OnEnable(self)
end

function ActSevenDayBoxItem:OnDisable()
  base.OnDisable(self)
end

function ActSevenDayBoxItem:RefreshData(index, data, curscore, effect, actId)
  self.rewardData = data
  self.effect = effect
  self.state = self.rewardData.rewardFlag
  self.curscore = curscore
  self.index = index
  self.actId = actId
  self:RefreshBox()
  self:RefreshBoxState()
end

function ActSevenDayBoxItem:RefreshBox()
  if not next(self.rewardData.reward) then
    return
  end
  table.walk(self.rewardData.reward, function(k, v)
    self._icon_img:LoadSprite(DataCenter.RewardManager:GetPicByType(v.rewardType, v.itemId))
    self.itemName = DataCenter.RewardManager:GetNameByType(v.rewardType, v.itemId)
    self.itemDesc = DataCenter.RewardManager:GetDescByType(v.rewardType, v.itemId)
    self._item_quality:LoadSprite(DataCenter.RewardManager:GetRewardQualityBg(v.rewardType, v.itemId))
    self._num_txt:SetText(v.count)
  end)
  self._score_txt:SetText(self.rewardData.needScore)
  self._can_receive_img:SetActive(self.curscore >= self.rewardData.needScore and self.state == 0)
end

function ActSevenDayBoxItem:RefreshBoxState()
  CS.UIGray.SetGray(self.transform, self.state == 1, true)
  if self.state == 0 and self.curscore >= self.rewardData.needScore then
    self:PlayRotation()
    self.effect:SetActive(true)
    self.effect:Enable(true)
    return
  end
  self:StopRotation()
end

function ActSevenDayBoxItem:OnClickReward()
  local x = self.transform.position.x
  local y = self.transform.position.y
  local offset = 50
  local width = self._reward_btnTab[index].rectTransform.rect.width
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityRewardTip, Localization:GetString("370101"), ActivityEventType.PERSONAL, x, y, isLeft, self.eventInfo.rewardScoreIndexArr[index], width, offset)
end

function ActSevenDayBoxItem:OnClickGo()
  if self.state == 0 and self.curscore >= self.rewardData.needScore then
    SFSNetwork.SendMessage(MsgDefines.ReceiveSevenDayActReward, self.actId, self.index)
    return
  end
  local param = {}
  param.itemName = self.itemName
  param.itemDesc = self.itemDesc
  param.alignObject = self._icon_img
  param.isLocal = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

function ActSevenDayBoxItem:PlayRotation()
  if self.tween then
    return
  end
  if self._content then
    self._content.transform.localRotation = Quaternion.identity
    self.tween = DOTween.Sequence()
    self.tween:Append(self._content.transform:DOLocalRotate(Vector3(0, 0, 10), 0.1))
    self.tween:Append(self._content.transform:DOLocalRotate(Vector3(0, 0, 0), 0.1))
    self.tween:Append(self._content.transform:DOLocalRotate(Vector3(0, 0, -10), 0.1))
    self.tween:Append(self._content.transform:DOLocalRotate(Vector3(0, 0, 0), 0.1))
    self.tween:SetLoops(-1, CS.DG.Tweening.LoopType.Restart)
  end
end

function ActSevenDayBoxItem:StopRotation()
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
  if self._content then
    self._content.transform.localRotation = Quaternion.identity
  end
end

return ActSevenDayBoxItem
