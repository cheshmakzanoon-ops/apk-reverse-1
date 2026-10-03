local base = UIBaseContainer
local WorldSuppliesTop = BaseClass("WorldSuppliesTop", base)
local detailBtn_path = "btn_detail"
local name_path = "NameText"
local shareBtn_path = "Btn_share"
local markBtn_path = "Btn_mark"
local returnBtn_path = "btn_return"
local image_path = "Image"

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
  self.image = self:AddComponent(UIImage, image_path)
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
  self.image = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.paramData = nil
end

function WorldSuppliesTop:Init(initData)
  self.paramData = initData
  self.detailBtn:SetActive(true)
  self.returnBtn:SetActive(false)
  self:RefreshSeason()
end

function WorldSuppliesTop:RefreshData(pointData)
  self.pointData = pointData
end

function WorldSuppliesTop:RefreshServerData(serverData)
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
  self:RefreshSeason()
end

function WorldSuppliesTop:DetailBtn()
  if self.paramData then
    self.paramData.detailBtn(self.paramData.host)
    self.detailBtn:SetActive(false)
    self.returnBtn:SetActive(true)
  end
end

function WorldSuppliesTop:ShareBtn()
  if self.paramData then
    self.paramData.shareBtn(self.paramData.host)
  end
end

function WorldSuppliesTop:MarkBtn()
  if self.paramData then
    self.paramData.markBtn(self.paramData.host)
  end
end

function WorldSuppliesTop:ReturnBtn()
  if self.paramData then
    self.paramData.returnBtn(self.paramData.host)
    self.detailBtn:SetActive(true)
    self.returnBtn:SetActive(false)
  end
end

function WorldSuppliesTop:RefreshSeason()
  local detailData = self.serverData and self.serverData.detailData
  local type = detailData and detailData.type or WorldSuppliesType.IceSeasonType
  if type == WorldSuppliesType.DesertSeasonType then
    self.image:LoadSprite(string.format(LoadPath.UISeason3Path, "SeasonPoint/mcj_S3_gjlz_pop_bg"))
  elseif type == WorldSuppliesType.DarknessSeasonType or type == WorldSuppliesType.DarknessSeasonSmallType then
    self.image:LoadSprite(string.format(LoadPath.UISeason4Path, "Supplies/zxl_s4_wuzi_tips"))
  else
    self.image:LoadSprite(string.format(LoadPath.UISeason2Path, "FX_S2saiji_caijiziyuan_BG"))
  end
end

WorldSuppliesTop.OnCreate = OnCreate
WorldSuppliesTop.OnDestroy = OnDestroy
WorldSuppliesTop.OnEnable = OnEnable
WorldSuppliesTop.OnDisable = OnDisable
WorldSuppliesTop.ComponentDefine = ComponentDefine
WorldSuppliesTop.ComponentDestroy = ComponentDestroy
WorldSuppliesTop.DataDefine = DataDefine
WorldSuppliesTop.DataDestroy = DataDestroy
return WorldSuppliesTop
