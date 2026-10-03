local UIChatReportItem = BaseClass("UIChatReportItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local selectBtn_path = "Bg/selectBtn"
local selectIcon_path = "Bg/selectBtn/Background/Checkmark"
local reasonTxt_path = "Bg/name"

local function OnCreate(self)
  base.OnCreate(self)
  self.selectBtnN = self:AddComponent(UIButton, selectBtn_path)
  self.mask = self:AddComponent(UIImage, "Bg/selectBtn/Background/mask")
  self.selectBtnN:SetOnClick(function()
    self:OnClickSelectBtn()
  end)
  self.selectIconN = self:AddComponent(UIImage, selectIcon_path)
  self.reasonTxtN = self:AddComponent(UIText, reasonTxt_path)
  self.selectType = SelectType.Radio
  self.isOn = false
  self:SetCanCilck(true)
end

local function OnDestroy(self)
  self.selectBtnN = nil
  self.selectIconN = nil
  self.reasonTxtN = nil
  base.OnDestroy(self)
end

local function SetItem(self, report, selectType)
  self.reportConf = report
  if selectType then
    self.selectType = selectType
  end
  self.reasonTxtN:SetLocalText(self.reportConf.Dialog)
  self.selectIconN:SetActive(false)
end

local function GetReportConf(self)
  return self.reportConf
end

local function OnClickSelectBtn(self)
  if self.selectType == SelectType.Radio then
    self.view:OnSelectOne(self)
    self.selectIconN:SetActive(true)
  else
    self.isOn = not self.isOn
    self.view:OnSelectOne(self)
    self.selectIconN:SetActive(self.isOn)
  end
end

local function SetSelected(self, isSelected)
  self.selectIconN:SetActive(isSelected)
end

function UIChatReportItem:SetType(selectType)
  self.selectType = selectType
end

function UIChatReportItem:SetCanCilck(isOn)
  self.mask:SetActive(not isOn)
  if not isOn then
    self.isOn = false
    self.selectIconN:SetActive(self.isOn)
  end
end

UIChatReportItem.OnCreate = OnCreate
UIChatReportItem.OnDestroy = OnDestroy
UIChatReportItem.SetItem = SetItem
UIChatReportItem.GetReportConf = GetReportConf
UIChatReportItem.SetSelected = SetSelected
UIChatReportItem.OnClickSelectBtn = OnClickSelectBtn
return UIChatReportItem
