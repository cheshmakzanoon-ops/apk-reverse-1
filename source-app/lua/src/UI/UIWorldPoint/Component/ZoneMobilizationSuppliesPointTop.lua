local base = UIBaseContainer
local ZoneMobilizationSuppliesPointTop = BaseClass("ZoneMobilizationSuppliesPointTop", base)
local detailBtn_path = "btn_detail"
local name_path = "NameText"
local shareBtn_path = "Btn_share"
local markBtn_path = "Btn_mark"
local returnBtn_path = "btn_return"

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
  self.detailBtn = self:AddComponent(UIButton, detailBtn_path)
  self.name = self:AddComponent(UIText, name_path)
  self.shareBtn = self:AddComponent(UIButton, shareBtn_path)
  self.markBtn = self:AddComponent(UIButton, markBtn_path)
  self.returnBtn = self:AddComponent(UIButton, returnBtn_path)
  self.detailBtn:SetOnClick(function()
    self:DetailBtn()
  end)
  self.shareBtn:SetOnClick(function()
    self:ShareBtn()
  end)
  self.markBtn:SetOnClick(function()
    self:MarkBtn()
  end)
  self.returnBtn:SetOnClick(function()
    self:ReturnBtn()
  end)
  self.shareBtn:SetActive(false)
  self.markBtn:SetActive(false)
end

local function ComponentDestroy(self)
  self.detailBtn = nil
  self.name = nil
  self.shareBtn = nil
  self.markBtn = nil
  self.returnBtn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.paramData = nil
end

function ZoneMobilizationSuppliesPointTop:Init(initData)
  self.paramData = initData
  self.detailBtn:SetActive(true)
  self.returnBtn:SetActive(false)
end

function ZoneMobilizationSuppliesPointTop:RefreshData(pointData)
  self.pointData = pointData
end

function ZoneMobilizationSuppliesPointTop:RefreshServerData(serverData)
  if serverData == nil or serverData.detailData == nil then
    return
  end
  local flag = DataCenter.SeasonDataManager:IsInBattleServerGroup(self.view.ctrl.serverId)
  self.shareBtn:SetActive(flag)
  self.markBtn:SetActive(flag)
  self.serverData = serverData
  local detailData = serverData and serverData.detailData
  if not detailData then
    return
  end
  local playerCount = detailData:GetPlayerCount()
  local count = detailData.totalLimit - playerCount
  if 0 < count then
    self.name:SetText(string.format("%s(<color=#0aa032>%s</color>/%s)", self.pointData.name, tostring(count), detailData.totalLimit))
  else
    self.name:SetText(string.format("%s(%s/%s)", self.pointData.name, tostring(count), detailData.totalLimit))
  end
end

function ZoneMobilizationSuppliesPointTop:DetailBtn()
  if self.paramData then
    self.paramData.detailBtn(self.paramData.host)
    self.detailBtn:SetActive(false)
    self.returnBtn:SetActive(true)
  end
end

function ZoneMobilizationSuppliesPointTop:ShareBtn()
  if CoppaUtil.IsCoppaLimitWithTips() then
    return
  end
  if self.paramData then
    self.paramData.shareBtn(self.paramData.host)
  end
end

function ZoneMobilizationSuppliesPointTop:MarkBtn()
  if self.paramData then
    self.paramData.markBtn(self.paramData.host)
  end
end

function ZoneMobilizationSuppliesPointTop:ReturnBtn()
  if self.paramData then
    self.paramData.returnBtn(self.paramData.host)
    self.detailBtn:SetActive(true)
    self.returnBtn:SetActive(false)
  end
end

ZoneMobilizationSuppliesPointTop.OnCreate = OnCreate
ZoneMobilizationSuppliesPointTop.OnDestroy = OnDestroy
ZoneMobilizationSuppliesPointTop.OnEnable = OnEnable
ZoneMobilizationSuppliesPointTop.OnDisable = OnDisable
ZoneMobilizationSuppliesPointTop.ComponentDefine = ComponentDefine
ZoneMobilizationSuppliesPointTop.ComponentDestroy = ComponentDestroy
ZoneMobilizationSuppliesPointTop.DataDefine = DataDefine
ZoneMobilizationSuppliesPointTop.DataDestroy = DataDestroy
return ZoneMobilizationSuppliesPointTop
