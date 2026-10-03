local MailAllianceMark = BaseClass("MailAllianceMark", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local title_path = "UIMailItemTitle/txtMainTitle"
local subTitle_path = "UIMailItemTitle/txtSubTitle"
local time_path = "UIMailItemTitle/txtTime"
local icon_path = "ImageContainer/Image"
local tip_path = "Tip"
local name_path = "Name"
local btn_path = "btnGetReward"
local btnTxt_path = "btnGetReward/txtGetReward"

local function OnCreate(self)
  base.OnCreate(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.subTitleN = self:AddComponent(UIText, subTitle_path)
  self.timeN = self:AddComponent(UIText, time_path)
  self.iconN = self:AddComponent(UIImage, icon_path)
  self.tipN = self:AddComponent(UIText, tip_path)
  self.typeNameN = self:AddComponent(UIText, name_path)
  self.BtnN = self:AddComponent(UIButton, btn_path)
  self.BtnN:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickJumpBtn()
  end)
  self.btnTxtN = self:AddComponent(UIText, btnTxt_path)
  self.btnTxtN:SetLocalText(110003)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function setData(self, mailInfo)
  self.mailInfo = mailInfo
  self:ParseContent()
  self:RefreshUI()
end

local function ParseContent(self)
  if self.mailInfo == nil then
    return
  end
  if string.IsNullOrEmpty(self.mailInfo.contents) then
    return
  end
  local contentData = rapidjson.decode(self.mailInfo.contents)
  local data = contentData.obj
  local markInfo = {}
  markInfo.server = data.server
  markInfo.pointId = data.pointId
  markInfo.markName = data.markName
  markInfo.markType = data.markType
  markInfo.name = data.name
  markInfo.rank = data.rank
  self.markInfo = markInfo
end

local function RefreshUI(self)
  local strMainTitle = MailShowHelper.GetMainTitle(self.mailInfo)
  self.titleN:SetText(strMainTitle)
  local strSubTitle = MailShowHelper.GetMailSubTitle(self.mailInfo)
  self.subTitleN:SetText(strSubTitle)
  local strTime = MailShowHelper.GetAbstractCreateTime(self.mailInfo)
  self.timeN:SetText(strTime)
  local iconPath = string.format(LoadPath.AllianceMark, DataCenter.WorldFavoDataManager:GetBookMarkIconName(self.markInfo.markType))
  self.iconN:LoadSprite(iconPath)
  local param1 = self.markInfo.rank == 5 and Localization:GetString("390006") .. ": " or ""
  local param2 = self.markInfo.name
  local param3 = DataCenter.WorldFavoDataManager:GetBookMarkName(self.markInfo.markType, true)
  local param4 = ""
  if param3 ~= self.markInfo.markName then
    local tempMarkName = string.split(self.markInfo.markName, ";")
    if #tempMarkName == 1 then
      param4 = ": " .. self.markInfo.markName
    else
      param4 = ": " .. Localization:GetString(tempMarkName[2])
    end
  end
  self.tipN:SetLocalText(390815, param1, param2, param3, param4)
  self.typeNameN:SetText("")
end

local function OnClickJumpBtn(self)
  local targetPoint = (self.markInfo.pointId - self.markInfo.pointId % 10) / 10
  self.view.ctrl:OnClickAlMarkBtn(targetPoint)
end

MailAllianceMark.OnCreate = OnCreate
MailAllianceMark.OnDestroy = OnDestroy
MailAllianceMark.setData = setData
MailAllianceMark.OnClickJumpBtn = OnClickJumpBtn
MailAllianceMark.ParseContent = ParseContent
MailAllianceMark.RefreshUI = RefreshUI
return MailAllianceMark
