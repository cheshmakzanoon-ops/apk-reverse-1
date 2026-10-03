local base = UIBaseView
local SeasonGreenNotice = BaseClass("SeasonGreenNotice", base)
local btnClose_path = "PopUpTitle/CloseBtn"
local btnCheck_path = "PopUpTitle/BtnCheck"
local textCount_path = "PopUpTitle/textContent/textCount"
local content_path = "PopUpTitle/Content"
local descGroup_path = "PopUpTitle/Content/descGroup"

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
  self.btnClose = self:AddComponent(UIButton, btnClose_path)
  self.btnCheck = self:AddComponent(UIButton, btnCheck_path)
  self.textCount = self:AddComponent(UIText, textCount_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.descGroup = self:AddComponent(UIBaseContainer, descGroup_path)
  self.btnClose:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btnCheck:SetOnClick(function()
    DataCenter.SeasonGreenManager:GotoActivity()
    self.ctrl:CloseSelf()
  end)
  self:RefreshView()
end

local function ComponentDestroy(self)
  self.btnClose = nil
  self.btnCheck = nil
  self.textCount = nil
  self.content = nil
  self.descGroup = nil
end

local function DataDefine(self)
  self.hasRequest = false
end

local function DataDestroy(self)
end

function SeasonGreenNotice:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetActivitySuppliesShareInfoEvent, self.RefreshView)
end

function SeasonGreenNotice:OnRemoveListener()
  self:RemoveUIListener(EventId.GetActivitySuppliesShareInfoEvent, self.RefreshView)
  base.OnRemoveListener(self)
end

function SeasonGreenNotice:RefreshView()
  local shareData = DataCenter.SeasonSuppliesShareDataManager:GetActivityInfo(not self.hasRequest)
  self.hasRequest = true
  local count = shareData and shareData.remainData and shareData.remainData.totalNum or 0
  count = string.format("<size=50>%s</size>", count)
  self.textCount:SetLocalText("season_oasis_UI_33", count)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.descGroup.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
end

SeasonGreenNotice.OnCreate = OnCreate
SeasonGreenNotice.OnDestroy = OnDestroy
SeasonGreenNotice.OnEnable = OnEnable
SeasonGreenNotice.OnDisable = OnDisable
SeasonGreenNotice.ComponentDefine = ComponentDefine
SeasonGreenNotice.ComponentDestroy = ComponentDestroy
SeasonGreenNotice.DataDefine = DataDefine
SeasonGreenNotice.DataDestroy = DataDestroy
return SeasonGreenNotice
