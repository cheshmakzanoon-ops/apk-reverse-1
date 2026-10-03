local ActBingoBoxItem = BaseClass("ActBingoBoxItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")
local bg_path = "bg"
local box_icon_path = "boxIcon"
local can_get_path = "canGet"
local have_get_path = "haveGet"

function ActBingoBoxItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActBingoBoxItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActBingoBoxItem:ComponentDefine()
  self.bg = self:AddComponent(UIButton, bg_path)
  self.box_icon = self:AddComponent(UIImage, box_icon_path)
  self.can_get = self:AddComponent(UIBaseContainer, can_get_path)
  self.have_get = self:AddComponent(UIImage, have_get_path)
  self.bg:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function ActBingoBoxItem:ComponentDestroy()
  self.bg = nil
  self.box_icon = nil
  self.can_get = nil
  self.have_get = nil
end

function ActBingoBoxItem:DataDefine()
  self.activityId = nil
  self.rewardData = nil
  self.boxType = nil
  self.boxIndex = nil
  self.activityDetailData = nil
  self.state = nil
end

function ActBingoBoxItem:DataDestroy()
  self.activityId = nil
  self.rewardData = nil
  self.boxType = nil
  self.boxIndex = nil
  self.activityDetailData = nil
  self.state = nil
end

function ActBingoBoxItem:SetData(activityId, rewardData, boxType, boxIndex, activityDetailData)
  self.activityId = activityId
  self.rewardData = rewardData
  self.boxType = boxType
  self.boxIndex = boxIndex
  self.activityDetailData = activityDetailData
  self.state = self.activityDetailData:GetBoxState(self.boxType, self.boxIndex)
  local iconImg = ""
  if self.state == ActBingoBoxState.NoComplete then
    self.can_get:SetActive(false)
    self.have_get:SetActive(false)
    iconImg = "FX_binguohuodong_icon_xiangzi02"
  elseif self.state == ActBingoBoxState.CanReceive then
    self.can_get:SetActive(true)
    self.have_get:SetActive(false)
    iconImg = "FX_binguohuodong_icon_xiangzi02"
  elseif self.state == ActBingoBoxState.Received then
    self.can_get:SetActive(false)
    self.have_get:SetActive(true)
    iconImg = "FX_binguohuodong_icon_xiangzi01"
  end
  local iconPath = string.format(LoadPath.ActBingoSpritePath, iconImg)
  self.box_icon:LoadSprite(iconPath)
end

function ActBingoBoxItem:OnBtnClick()
  if self.activityId == nil then
    return
  end
  if self.state == ActBingoBoxState.CanReceive then
    SFSNetwork.SendMessage(MsgDefines.BingoBoxReceive, tonumber(self.activityId), self.boxType, self.boxIndex - 1)
  else
    local boxObj = self.bg
    local tipParam = UIPersonalArmsRewardTipView.ParamDataClass.New()
    tipParam.position = boxObj:GetPosition()
    if CommonUtil.IsArabicAutoMirrorOpen() then
      tipParam.dir = tipParam.position.x < -1150 and UIPersonalArmsRewardTipView.Direction.LEFT or UIPersonalArmsRewardTipView.Direction.RIGHT
      tipParam.deltaX = tipParam.dir == UIPersonalArmsRewardTipView.Direction.LEFT and -30 or 30
    else
      tipParam.dir = tipParam.position.x > -1150 and UIPersonalArmsRewardTipView.Direction.RIGHT or UIPersonalArmsRewardTipView.Direction.LEFT
      tipParam.deltaX = tipParam.dir == UIPersonalArmsRewardTipView.Direction.RIGHT and -30 or 30
    end
    tipParam.rewardList = DataCenter.RewardManager:ReturnRewardParamForView(self.rewardData.reward)
    tipParam.closePassClick = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsRewardTip, {anim = false}, tipParam)
  end
end

return ActBingoBoxItem
