local GiftBoxRewardBoxItem = BaseClass("GiftBoxRewardBoxItem", UIBaseContainer)
local base = UIBaseContainer
local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")
local Localization = CS.GameEntry.Localization

function GiftBoxRewardBoxItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function GiftBoxRewardBoxItem:OnDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function GiftBoxRewardBoxItem:ComponentDefine()
  self._num_txt = self:AddComponent(UIText, "Num")
  self._box_img = self:AddComponent(UIImage, "BoxBtn/BoxImg")
  self._box_red_dot = self:AddComponent(UIBaseContainer, "RedPoint")
  self._effect = self:AddComponent(UIBaseContainer, "Effect")
  self._box_btn = self:AddComponent(UIButton, "BoxBtn")
  self._box_btn:SetOnClick(function()
    self:OnClickBox()
  end)
end

function GiftBoxRewardBoxItem:DataDefine()
end

function GiftBoxRewardBoxItem:DataDestroy()
end

function GiftBoxRewardBoxItem:ReInit(param, activityId)
  self.param = param
  self.activityId = activityId
  if self.param then
    self._num_txt:SetText("X" .. param.targetScore)
    local selfScore = DataCenter.ActGiftBoxData:GetActScoreById(tonumber(self.activityId))
    if self.param.state == 1 then
      self._box_img:LoadSprite("Assets/Main/Sprites/UI/UIActivityGiftBox/zyf_kongtouzhaohuan_dakaixiangzi.png")
      self._box_red_dot:SetActive(false)
      self._effect:SetActive(false)
    else
      self._box_img:LoadSprite("Assets/Main/Sprites/UI/UIActivityGiftBox/zyf_kongtouzhaohuan_xiangzi.png")
      self._box_red_dot:SetActive(selfScore >= param.targetScore)
      self._effect:SetActive(selfScore >= param.targetScore)
    end
  end
end

function GiftBoxRewardBoxItem:OnClickBox()
  if self.param then
    local selfScore = DataCenter.ActGiftBoxData:GetActScoreById(self.activityId)
    if self.param.state == 0 and selfScore >= self.param.targetScore then
      SFSNetwork.SendMessage(MsgDefines.GiftBoxReceive, toInt(self.activityId), self.param.index)
    else
      local param = UIPersonalArmsRewardTipView.ParamDataClass.New()
      param.position = self:GetPosition()
      if CommonUtil.IsArabicAutoMirrorOpen() then
        param.dir = param.position.x > -1150 and UIPersonalArmsRewardTipView.Direction.LEFT or UIPersonalArmsRewardTipView.Direction.RIGHT
        param.deltaX = param.dir == UIPersonalArmsRewardTipView.Direction.LEFT and 30 or -30
      else
        param.dir = param.position.x > -1150 and UIPersonalArmsRewardTipView.Direction.RIGHT or UIPersonalArmsRewardTipView.Direction.LEFT
        param.deltaX = param.dir == UIPersonalArmsRewardTipView.Direction.RIGHT and -30 or 30
      end
      param.rewardList = self.param.reward
      param.closePassClick = true
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsRewardTip, {anim = false}, param)
    end
  end
end

return GiftBoxRewardBoxItem
