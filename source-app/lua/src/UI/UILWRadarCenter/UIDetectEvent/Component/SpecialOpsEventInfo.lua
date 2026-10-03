local SpecialOpsEventInfo = BaseClass("SpecialOpsEventInfo", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local title_text_path = "BG/Special_Event_Text"
local normal_path = "BG/Special_Event_Normal"
local normal_quality_title_path = "BG/Special_Event_Normal/Special_Event_Normal_Quality_Title"
local normal_quality_text_path = "BG/Special_Event_Normal/Special_Event_Normal_Quality_Text"
local normal_desc_path = "BG/Special_Event_Normal/Special_Event_Desc_Text"
local normal_goto_btn_path = "BG/Special_Event_Normal/SpecialEvent_Goto_Btn"
local normal_goto_btn_text_path = "BG/Special_Event_Normal/SpecialEvent_Goto_Btn/SpecialEvent_Goto_Btn_Text"
local cd_path = "BG/Special_In_CD"
local cd_des_path = "BG/Special_In_CD/Special_In_CD_Desc"
local cd_time_title_path = "BG/Special_In_CD/Special_In_CD_Time_Title"
local cd_time_text_path = "BG/Special_In_CD/timeBg/Special_In_CD_Time_Text"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.normal = self:AddComponent(UIBaseContainer, normal_path)
  self.normal_quality_title = self:AddComponent(UIText, normal_quality_title_path)
  self.normal_quality_title:SetLocalText(GameDialogDefine.DETECT_EVENT_QUALITY)
  self.normal_quality_text = self:AddComponent(UIText, normal_quality_text_path)
  self.normal_desc = self:AddComponent(UIText, normal_desc_path)
  self.normal_goto_btn = self:AddComponent(UIButton, normal_goto_btn_path)
  self.normal_goto_btn_text = self:AddComponent(UIText, normal_goto_btn_text_path)
  self.normal_goto_btn_text:SetLocalText(GameDialogDefine.GOTO)
  self.normal_goto_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.view.ctrl:Goto(self.data.uuid)
  end)
  self.cd = self:AddComponent(UIBaseContainer, cd_path)
  self.cd_des = self:AddComponent(UIText, cd_des_path)
  self.cd_des:SetLocalText(140082)
  self.cd_time_title = self:AddComponent(UIText, cd_time_title_path)
  self.cd_time_title:SetLocalText(140083)
  self.cd_time_text = self:AddComponent(UIText, cd_time_text_path)
end

local function DataDefine(self)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDestroy(self)
end

local function DataDestroy(self)
end

local function SetData(self, data)
  self.data = data
  self:RefreshView()
end

local function RefreshView(self)
  if self.data == nil then
    return
  end
  self.title_text:SetText(self.data.nameStr)
  if self.data.inCd then
    self.cd:SetActive(true)
    self.normal:SetActive(false)
  else
    self.cd:SetActive(false)
    self.normal:SetActive(true)
    local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.data.uuid)
    if data ~= nil then
      local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
      if template ~= nil then
        local qualityText = CommonUtil.GetDetectEventQualityName(template.quality)
        local color = CommonUtil.GetDetectEventQualityColor(template.quality)
        self.normal_quality_text:SetColor(color)
        self.normal_quality_text:SetLocalText(qualityText)
        self.normal_desc:SetLocalText(140081)
      end
    end
  end
end

local function RefreshTime(self)
  if self.data == nil then
    return
  end
  if self.data.inCd then
    local now = UITimeManager:GetInstance():GetServerTime()
    self.cd_time_text:SetText(UITimeManager:GetInstance():SecondToFmtString((self.data.endTime - now) / 1000))
  end
end

SpecialOpsEventInfo.RefreshTime = RefreshTime
SpecialOpsEventInfo.SetData = SetData
SpecialOpsEventInfo.RefreshView = RefreshView
SpecialOpsEventInfo.OnCreate = OnCreate
SpecialOpsEventInfo.OnDestroy = OnDestroy
SpecialOpsEventInfo.ComponentDefine = ComponentDefine
SpecialOpsEventInfo.ComponentDestroy = ComponentDestroy
SpecialOpsEventInfo.DataDefine = DataDefine
SpecialOpsEventInfo.DataDestroy = DataDestroy
return SpecialOpsEventInfo
