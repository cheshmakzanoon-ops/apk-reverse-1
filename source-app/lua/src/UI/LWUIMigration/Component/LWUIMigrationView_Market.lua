local LWUIMigration_TabBase = require("UI.LWUIMigration.Component.LWUIMigration_TabBase")
local LWUIMigrationView_Market = BaseClass("LWUIMigrationView_Market", LWUIMigration_TabBase)
local base = LWUIMigration_TabBase
local LWUIMigrationView_PersonMarketPage = require("UI.LWUIMigration.Component.LWUIMigrationView_PersonMarketPage")
local LWUIMigrationView_AllyRecruitPage = require("UI.LWUIMigration.AllyRecruitPage.Component.LWUIMigration_AllyRecruitPage")
local MARKET_PAGE = {
  [1] = {
    asset = UIAssets.UIMigrationAllianceMarket,
    cls = LWUIMigrationView_AllyRecruitPage
  },
  [2] = {
    asset = UIAssets.UIMigrationPersonMarket,
    cls = LWUIMigrationView_PersonMarketPage
  }
}
local toggle1_path = "TabHolder/Tab/toggle1"
local toggle2_path = "TabHolder/Tab/toggle2"
local toggle1_on_path = "TabHolder/Tab/toggle1/on1"
local toggle2_on_path = "TabHolder/Tab/toggle2/on2"
local toggle_txt_on1_path = "TabHolder/Tab/toggle1/on1/toggle_txt_on1"
local toggle_txt_on2_path = "TabHolder/Tab/toggle2/on2/toggle_txt_on2"
local toggle_txt_off1_path = "TabHolder/Tab/toggle1/toggle_txt_off1"
local toggle_txt_off2_path = "TabHolder/Tab/toggle2/toggle_txt_off2"
local content_path = "Content"

function LWUIMigrationView_Market:OnCreate()
  base.OnCreate(self)
  self.page_content = self:AddComponent(UIBaseContainer, content_path)
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggle_txt_on1 = self:AddComponent(UIText, toggle_txt_on1_path)
  self.toggle_txt_on2 = self:AddComponent(UIText, toggle_txt_on2_path)
  self.toggle_txt_off1 = self:AddComponent(UIText, toggle_txt_off1_path)
  self.toggle_txt_off2 = self:AddComponent(UIText, toggle_txt_off2_path)
  self.toggle1On = self:AddComponent(UIImage, toggle1_on_path)
  self.toggle2On = self:AddComponent(UIImage, toggle2_on_path)
  self.toggle1On:SetActive(false)
  self.toggle2On:SetActive(false)
  self.contentReq = {}
  self.pageComponents = {}
  self.toggle1:SetIsOn(false)
  self.toggle1:SetOnValueChanged(function(tf)
    self.toggle1On:SetActive(tf)
    if tf then
      self:SelectTab(1)
    end
  end)
  self.toggle2:SetIsOn(false)
  self.toggle2:SetOnValueChanged(function(tf)
    if tf then
      if not self:IsToggle2Open() then
        self.toggle1:SetIsOn(true)
        UIUtil.ShowTipsId("migration_activity_tips_20049")
        return
      end
      self:SelectTab(2)
    end
    self.toggle2On:SetActive(tf)
  end)
  self.toggle1:SetIsOn(true)
  self.k6 = LuaEntry.DataConfig:TryGetNum("lw_migration", "k6", 4)
end

function LWUIMigrationView_Market:OnDestroy()
  self.toggle1:SetIsOnWithoutNotify(false)
  self.toggle2:SetIsOnWithoutNotify(false)
  self.toggle1 = nil
  self.toggle2 = nil
  self.toggle_txt_on1 = nil
  self.toggle_txt_on2 = nil
  self.toggle_txt_off1 = nil
  self.toggle_txt_off2 = nil
  self.toggle1On = nil
  self.toggle2On = nil
  for k, v in pairs(MARKET_PAGE) do
    self.page_content:RemoveComponents(v.cls)
  end
  self.pageComponents = nil
  if self.contentReq then
    for k, v in pairs(self.contentReq) do
      self:GameObjectDestroy(v)
    end
    self.contentReq = nil
  end
  base.OnDestroy(self)
end

function LWUIMigrationView_Market:OnDisable()
  base.OnDisable(self)
end

function LWUIMigrationView_Market:OnAddListener()
  base.OnAddListener(self)
end

function LWUIMigrationView_Market:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIMigrationView_Market:SetData()
  base.SetData(self)
end

function LWUIMigrationView_Market:SearchAlliance(allianceName)
  self.memSearchAllianceName = allianceName
  self:SelectTab(1)
end

function LWUIMigrationView_Market:SelectTab(index)
  self.tabActive = index
  if not self.contentReq[index] then
    self.contentReq[index] = self:GameObjectInstantiateAsync(MARKET_PAGE[index].asset, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.page_content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      go.transform:Set_anchorMin(0, 0)
      go.transform:Set_anchorMax(1, 1)
      go.transform:Set_sizeDelta(-10, 0)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      self.pageComponents[index] = self.page_content:AddComponent(MARKET_PAGE[index].cls, nameStr)
      self.pageComponents[index]:SetData(self.memSearchAllianceName)
      self.memSearchAllianceName = nil
    end)
  elseif self.pageComponents[index] then
    self.pageComponents[index]:SetActive(true)
    self.pageComponents[index]:SetData(self.memSearchAllianceName)
    self.memSearchAllianceName = nil
  end
  for k, v in pairs(self.pageComponents) do
    if k ~= index then
      v:SetActive(false)
    end
  end
end

function LWUIMigrationView_Market:IsToggle2Open()
  local info
  local mgr = DataCenter.ActMigrationManager
  local idx = 1
  while true do
    info = mgr:GetStageInfo(idx)
    if info == nil or info.state == ActMigrationState.Migrate then
      break
    end
    idx = idx + 1
  end
  local sTime = info ~= nil and info.sTime or 0
  local min = sTime - self.k6 * OneDayTime * 1000
  local eTime = info ~= nil and info.eTime or 0
  local max = eTime + self.k6 * OneDayTime * 1000
  local curTime = UITimeManager:GetInstance():GetServerTime()
  return min <= curTime and max >= curTime
end

return LWUIMigrationView_Market
