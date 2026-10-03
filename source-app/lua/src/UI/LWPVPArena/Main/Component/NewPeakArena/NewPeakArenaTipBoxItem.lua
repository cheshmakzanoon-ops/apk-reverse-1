local NewPeakArenaTipBoxItem = BaseClass("NewPeakArenaTipBoxItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.imgIcon = self:AddComponent(UIImage, "IconImg")
  self.textNum = self:AddComponent(UIText, "NumBg/NumText")
  self.effect = self:AddComponent(UIBaseContainer, "Effect")
  self.btn = self:AddComponent(UIButton, "IconImg")
  self.btn:SetOnClick(function()
    self:OnClickBtn()
  end)
end

local function ComponentDestroy(self)
  self.imgIcon = nil
  self.textNum = nil
  self.effect = nil
  self.btn = nil
end

local function DataDefine(self)
  self.sendIndex = nil
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function Refresh(self, index, data, nowCount)
  self.sendIndex = nil
  self.textNum:SetText(data.needCount)
  self.effect:SetActive(false)
  self.data = data
  if data.rewarded == 1 then
    self.imgIcon:LoadSprite(NewPeakArenaBoxImg[index].openImg)
  else
    self.imgIcon:LoadSprite(NewPeakArenaBoxImg[index].closeImg)
    if nowCount >= data.needCount then
      self.sendIndex = index
      self.effect:SetActive(true)
    end
  end
end

local function OnClickBtn(self)
  if self.sendIndex then
    if self.holder.pvpType == PVPArenaType.NewGaleArena then
      SFSNetwork.SendMessage(MsgDefines.GaleArenaReward, self.sendIndex)
    else
      SFSNetwork.SendMessage(MsgDefines.NewArenaReward, self.sendIndex)
    end
  elseif self.data then
    local param = UIPersonalArmsRewardTipView.ParamDataClass.New()
    param.position = self.btn:GetPosition()
    param.deltaX = -30
    param.dir = UIPersonalArmsRewardTipView.Direction.RIGHT
    param.rewardList = self.data.reward
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsRewardTip, {anim = false}, param)
  end
end

NewPeakArenaTipBoxItem.OnCreate = OnCreate
NewPeakArenaTipBoxItem.OnDestroy = OnDestroy
NewPeakArenaTipBoxItem.OnEnable = OnEnable
NewPeakArenaTipBoxItem.OnDisable = OnDisable
NewPeakArenaTipBoxItem.ComponentDefine = ComponentDefine
NewPeakArenaTipBoxItem.ComponentDestroy = ComponentDestroy
NewPeakArenaTipBoxItem.DataDefine = DataDefine
NewPeakArenaTipBoxItem.DataDestroy = DataDestroy
NewPeakArenaTipBoxItem.OnAddListener = OnAddListener
NewPeakArenaTipBoxItem.OnRemoveListener = OnRemoveListener
NewPeakArenaTipBoxItem.Refresh = Refresh
NewPeakArenaTipBoxItem.OnClickBtn = OnClickBtn
return NewPeakArenaTipBoxItem
