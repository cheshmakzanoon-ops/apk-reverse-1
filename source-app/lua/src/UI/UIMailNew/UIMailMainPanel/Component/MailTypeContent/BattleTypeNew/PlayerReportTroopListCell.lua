local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local PlayerReportTroopListCell = BaseClass("PlayerReportTroopListCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local txt_left_path = "txt_left"
local txt_center_path = "txt_center"
local txt_right_path = "txt_right"
local txt_more_btn_path = "txt_center/btnMoreDetail"
local txt_info_path = "txt_center/btnInfo"
local btn_info_left_path = "txt_left/leftBtnInfo"
local btn_info_right_path = "txt_right/rightBtnInfo"

function PlayerReportTroopListCell:OnCreate()
  base.OnCreate(self)
  self.txt_left = self:AddComponent(UIText, txt_left_path)
  self.txt_center = self:AddComponent(UIText, txt_center_path)
  self.txt_right = self:AddComponent(UIText, txt_right_path)
  self._btnMore = self:AddComponent(UIButton, txt_more_btn_path)
  self._btnMore:SetOnClick(BindCallback(self, self.OnMoreClick))
  self._btnInfo = self:AddComponent(UIButton, txt_info_path)
  self._btnInfo:SetOnClick(BindCallback(self, self.OnInfoClick))
  self._btnInfoLeft = self:AddComponent(UIButton, btn_info_left_path)
  self._btnInfoLeft:SetOnClick(BindCallback(self, self.OnInfoLeftClick))
  self._btnInfoRight = self:AddComponent(UIButton, btn_info_right_path)
  self._btnInfoRight:SetOnClick(BindCallback(self, self.OnInfoRightClick))
end

function PlayerReportTroopListCell:InitDialog(value, showType)
  self.txt_center:SetLocalText(value)
  self.showType = showType
  self._btnMore:SetActive(false)
  self._btnInfo:SetActive(false)
  self._btnInfoLeft:SetActive(showType == BattleReportShowType.CampValue)
  self._btnInfoRight:SetActive(showType == BattleReportShowType.CampValue)
end

function PlayerReportTroopListCell:SetRoundData(leftFightData, rightFightData)
  self.leftFightData = leftFightData
  self.rightFightData = rightFightData
  if self.showType == BattleReportShowType.Soldier and (self.leftFightData.unitData ~= nil or self.rightFightData.unitData ~= nil) then
    self._btnMore:SetActive(true)
  end
end

function PlayerReportTroopListCell:SetLeftValue(value)
  self.txt_left:SetText(value)
end

function PlayerReportTroopListCell:SetRightValue(value)
  self.txt_right:SetText(value)
end

function PlayerReportTroopListCell:SetValueList(leftNumList, rightNumList)
  self.leftNumList = leftNumList
  self.rightNumList = rightNumList
  local leftTotal = leftNumList.campAdd + leftNumList.campRestraint
  self.txt_left:SetText(string.GetFormattedPercentStr(leftTotal / 100))
  local rightTotal = rightNumList.campAdd + rightNumList.campRestraint
  self.txt_right:SetText(string.GetFormattedPercentStr(rightTotal / 100))
end

function PlayerReportTroopListCell:OnInfoLeftClick()
  local msg = ""
  if self.leftNumList ~= nil then
    msg = msg .. Localization:GetString("150230") .. ": " .. string.GetFormattedPercentStr(self.leftNumList.campAdd / 100) .. "\n"
    msg = msg .. Localization:GetString("150226") .. ": " .. string.GetFormattedPercentStr(self.leftNumList.campRestraint / 100)
  end
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self._btnInfoLeft.transform.position + Vector3.New(0, 15, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = msg
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 300
  param.pivot = 0.25
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

function PlayerReportTroopListCell:OnInfoRightClick()
  local msg = ""
  if self.rightNumList ~= nil then
    msg = msg .. Localization:GetString("150230") .. ": " .. string.GetFormattedPercentStr(self.rightNumList.campAdd / 100) .. "\n"
    msg = msg .. Localization:GetString("150226") .. ": " .. string.GetFormattedPercentStr(self.rightNumList.campRestraint / 100)
  end
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self._btnInfoRight.transform.position + Vector3.New(0, 15, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = msg
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 300
  param.pivot = 0.75
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

function PlayerReportTroopListCell:OnMoreClick()
  local param = {}
  param.leftFightData = self.leftFightData
  param.rightFightData = self.rightFightData
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMailTroopInfoListView, {anim = true}, param)
end

function PlayerReportTroopListCell:OnInfoClick()
  local desc = ""
  if self.showType ~= BattleReportShowType.Atk and self.showType ~= BattleReportShowType.Def then
    return
  end
  if self.showType == BattleReportShowType.Atk then
    desc = Localization:GetString("163136")
  end
  if self.showType == BattleReportShowType.Def then
    desc = Localization:GetString("163137")
  end
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self._btnInfo.transform.position + Vector3.New(0, 15, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = desc
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 250
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

return PlayerReportTroopListCell
