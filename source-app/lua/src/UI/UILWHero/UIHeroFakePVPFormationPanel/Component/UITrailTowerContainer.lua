local UITrailTowerContainer = BaseClass("UITrailTowerContainer", UIBaseContainer)
local base = UIBaseContainer
local compBook = {
  {
    path = "bgLeft/txtPowerLeft",
    name = "txtPowerLeft",
    type = UIText
  },
  {
    path = "bgRight/txtPowerRight",
    name = "txtPowerRight",
    type = UIText
  },
  {
    path = "HeadLeft",
    name = "headLeft",
    type = UICommonHead
  },
  {
    path = "HeadRight",
    name = "headRight",
    type = UICommonHead
  },
  {
    path = "StageContent/StageText",
    name = "stageText",
    type = UIText
  },
  {
    path = "bgLeft",
    name = "bgLeftBtn",
    type = UIButton
  },
  {
    path = "bgLeft/imgPowerLeft",
    name = "imgPowerLeft",
    type = UIBaseContainer
  }
}

function UITrailTowerContainer:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UITrailTowerContainer:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITrailTowerContainer:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.bgLeftBtn:SetOnClick(function()
    self:ShowPowerInfo()
  end)
end

function UITrailTowerContainer:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UITrailTowerContainer:Refresh(playerInfoLeft, playerInfoRight, trailTowerLevelTemplate, powerDetailData)
  self.powerDetailData = powerDetailData
  self.txtPowerLeft:SetText(string.GetFormattedStr2(playerInfoLeft.power))
  self.txtPowerRight:SetText(string.GetFormattedStr2(playerInfoRight.power))
  self.headLeft:SetData(playerInfoLeft.uid, playerInfoLeft.pic, playerInfoLeft.picVer, nil, playerInfoLeft.headFrame)
  self.headRight:SetData(playerInfoRight.uid, playerInfoRight.pic, playerInfoRight.picVer, nil, playerInfoRight.headFrame)
  self.stageText:SetText(trailTowerLevelTemplate.levelGroup .. "-" .. trailTowerLevelTemplate.levelOrder)
end

function UITrailTowerContainer:ShowPowerInfo()
  if self.powerDetailData then
    UIUtil.ShowArmyFormationPowerTips(self.imgPowerLeft.transform.position, 0, -20, self.powerDetailData)
  end
end

return UITrailTowerContainer
