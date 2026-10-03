local CookingRewardBoxItem = BaseClass("CookingRewardBoxItem", UIBaseContainer)
local base = UIBaseContainer
local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")
local Localization = CS.GameEntry.Localization

function CookingRewardBoxItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CookingRewardBoxItem:OnDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function CookingRewardBoxItem:ComponentDefine()
  self._num_txt = self:AddComponent(UIText, "Num")
  self._box_img = self:AddComponent(UIImage, "BoxBtn/BoxImg")
  self._box_red_dot = self:AddComponent(UIBaseContainer, "RedPoint")
  self._effect = self:AddComponent(UIBaseContainer, "Effect")
  self._box_btn = self:AddComponent(UIButton, "BoxBtn")
  self._box_btn:SetOnClick(function()
    self:OnClickBox()
  end)
end

function CookingRewardBoxItem:DataDefine()
end

function CookingRewardBoxItem:DataDestroy()
end

function CookingRewardBoxItem:ReInit(param, activityId)
  self.param = param
  self.activityId = activityId
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  self.baseActData = activityInfo
  if self.param then
    if self.baseActData.type == EnumActivity.Cooking.Type then
      self._num_txt:SetText("X" .. param.targetScore)
    elseif self.baseActData.type == EnumActivity.Banquet.Type then
      self._num_txt:SetText("X" .. param.targetTotalScore)
    end
    if self.param.state == 1 then
      self._box_img:LoadSprite("Assets/Main/Sprites/UI/UIActivityGiftBox/zyf_kongtouzhaohuan_dakaixiangzi.png")
      self._box_red_dot:SetActive(false)
      self._effect:SetActive(false)
    else
      self._box_img:LoadSprite("Assets/Main/Sprites/UI/UIActivityGiftBox/zyf_kongtouzhaohuan_xiangzi.png")
      self._box_red_dot:SetActive(param.selfScore >= param.targetScore)
      self._effect:SetActive(param.selfScore >= param.targetScore)
    end
  end
end

function CookingRewardBoxItem:OnClickBox()
  if self.param then
    if self.param.state == 0 and self.param.targetScore <= self.param.selfScore then
      if self.baseActData.type == EnumActivity.Cooking.Type then
        local param = {}
        param.aid = self.activityId
        param.id = DataCenter.ActCookingData.actMakeFoodId
        param.score = self.param.targetScore
        SFSNetwork.SendMessage(MsgDefines.ActivityMakeFoodScoreReward, param)
      elseif self.baseActData.type == EnumActivity.Banquet.Type then
        local param = {}
        param.aid = self.activityId
        param.id = DataCenter.ActBanquetData.actBanquetId
        param.level = self.param.targetScore
        SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyLevelReward, param)
      end
    elseif self.baseActData.type == EnumActivity.Cooking.Type then
      local param = UIPersonalArmsRewardTipView.ParamDataClass.New()
      param.position = self:GetPosition()
      param.dir = param.position.x > -1150 and UIPersonalArmsRewardTipView.Direction.RIGHT or UIPersonalArmsRewardTipView.Direction.LEFT
      param.deltaX = param.dir == UIPersonalArmsRewardTipView.Direction.RIGHT and -30 or 30
      param.rewardList = self.param.reward
      param.closePassClick = true
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsRewardTip, {anim = false}, param)
    elseif self.baseActData.type == EnumActivity.Banquet.Type then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local openDays = UITimeManager:GetInstance():GetBetweenDaysForServer(self.baseActData.startTime / 1000, curTime / 1000)
      local openDic = DataCenter.ActBanquetData.actBanquetTemplate.open_dic
      local curLimitMaxLevel = 0
      for k, v in ipairs(openDic) do
        if k <= openDays + 1 then
          curLimitMaxLevel = math.max(curLimitMaxLevel, v)
        end
      end
      if curLimitMaxLevel < self.param.targetScore then
        UIUtil.ShowTipsId(100003)
      end
    end
  end
end

return CookingRewardBoxItem
