local WolfShadowDes = BaseClass("WolfShadowDes", UIAsyncContainer)
local base = UIAsyncContainer
local build_details_path = "BuildDetails"
local build_info_path = "BuildInfo"
local owner_path = "BuildInfo/top/owner"
local time_path = "BuildInfo/top/time"
local desc_path = "BuildInfo/bot/desc"

function WolfShadowDes:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function WolfShadowDes:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function WolfShadowDes:OnEnable()
  base.OnEnable(self)
end

function WolfShadowDes:OnDisable()
  base.OnDisable(self)
end

function WolfShadowDes:ComponentDefine()
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

function WolfShadowDes:ComponentDestroy()
end

function WolfShadowDes:DataDefine()
end

function WolfShadowDes:DataDestroy()
end

function WolfShadowDes:RefreshData(data)
  self.desc:SetLocalText("season_s4_blood_hunter_shadow_desc")
  self.des_txt:SetLocalText("season_s4_blood_hunter_shadow_desc")
  self.endTime = data.expireTime
  self:Update1000MS()
end

function WolfShadowDes:Update1000MS()
  local now = UITimeManager:GetInstance():GetServerTime()
  local remain = UITimeManager:GetInstance():MilliSecondToFmtString(self.endTime - now)
  self.time:SetText(remain)
  if now > self.endTime then
    self.view.ctrl:CloseSelf()
  end
end

function WolfShadowDes:OnInfoClick()
  self.animator:Enable(true)
  self.animator:Play("switchEnter", 0, 0)
end

function WolfShadowDes:OnReturnClick()
  self.animator:Enable(true)
  self.animator:Play("switchOut", 0, 0)
end

return WolfShadowDes
