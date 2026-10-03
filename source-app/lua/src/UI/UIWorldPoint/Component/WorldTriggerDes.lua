local WorldTriggerDes = BaseClass("WorldTriggerDes", UIAsyncContainer)
local base = UIAsyncContainer
local build_details_path = "BuildDetails"
local build_info_path = "BuildInfo"
local owner_path = "BuildInfo/top/owner"
local time_path = "BuildInfo/top/time"
local desc_path = "BuildInfo/bot/desc"

function WorldTriggerDes:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function WorldTriggerDes:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function WorldTriggerDes:OnEnable()
  base.OnEnable(self)
end

function WorldTriggerDes:OnDisable()
  base.OnDisable(self)
end

function WorldTriggerDes:ComponentDefine()
  self.animator = self:AddComponent(UIAnimator, "")
  self.build_details = self:AddComponent(UICanvasGroup, build_details_path)
  self.build_details:SetAlpha(1)
  self.build_info = self:AddComponent(UICanvasGroup, build_info_path)
  self.build_info:SetAlpha(1)
  self.owner = self:AddComponent(UITextMeshProUGUIEx, owner_path)
  self.time = self:AddComponent(UITextMeshProUGUIEx, time_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.des_txt = self:AddComponent(UIText, "BuildDetails/ScrollView/Viewport/Content0/desTxt")
end

function WorldTriggerDes:ComponentDestroy()
end

function WorldTriggerDes:DataDefine()
  self.data = nil
end

function WorldTriggerDes:DataDestroy()
  self.data = nil
end

function WorldTriggerDes:RefreshData(data)
  self.data = data
  local meta = DataCenter.WorldTriggerTemplateManager:GetMeta(data.cfgId)
  self.desc:SetLocalText(meta.desc)
  self.des_txt:SetLocalText(meta.desc_more, meta.desc_more_para)
  self.owner:SetText(UIUtil.FormatAllianceAndName(data.abbr, data.ownerName))
  self.endTime = data.endTime
  self:Update1000MS()
end

function WorldTriggerDes:Update1000MS()
  local now = UITimeManager:GetInstance():GetServerTime()
  local remain = UITimeManager:GetInstance():MilliSecondToFmtString(self.endTime - now)
  self.time:SetText(remain)
  if now > self.endTime then
    self.view.ctrl:CloseSelf()
  end
end

function WorldTriggerDes:OnInfoClick()
  self.animator:Enable(true)
  self.animator:Play("switchEnter", 0, 0)
end

function WorldTriggerDes:OnReturnClick()
  self.animator:Enable(true)
  self.animator:Play("switchOut", 0, 0)
end

return WorldTriggerDes
