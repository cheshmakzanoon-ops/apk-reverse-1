local LWUIMigrationView_ZoneList = BaseClass("LWUIMigrationView_ZoneList", UIAsyncContainer)
local base = UIAsyncContainer
local ZoneItem = require("UI.LWUIMigration.Component.LWUIMigrationView_ZoneItem")
local LINE_CNT = 4

function LWUIMigrationView_ZoneList:OnCreate()
  base.OnCreate(self)
  self.layout = self.gameObject:GetComponent(typeof(CS.BidirectionalHorizontalLayoutGroup))
  self.layout.enabled = true
  self.zones = {}
  for i = 1, LINE_CNT do
    self.zones[i] = self:AddComponent(ZoneItem, "ZoneItem" .. i)
  end
end

function LWUIMigrationView_ZoneList:OnDestroy()
  base.OnDestroy(self)
end

function LWUIMigrationView_ZoneList:SetData(idx)
  self.idx = idx
  self:RefreshView()
end

function LWUIMigrationView_ZoneList:UpdateData()
  if self.idx == nil then
    return
  end
  local idx = self.idx
  self.layout.childAlignment = idx % 2 == 1 and CS.UnityEngine.TextAnchor.MiddleLeft or CS.UnityEngine.TextAnchor.MiddleRight
  local actMgr = DataCenter.ActMigrationManager
  local actInfo = actMgr:GetActInfo()
  local serverIds = actInfo ~= nil and actInfo.serverIdList or {}
  for i, v in ipairs(self.zones) do
    local realI = LINE_CNT * (idx - 1) + i
    local sId = serverIds[realI]
    local serverInfo = actMgr:GetServerInfo(sId)
    if serverInfo then
      v:SetActive(true)
      v:SetData(serverInfo, true)
    else
      v:SetActive(false)
    end
  end
end

function LWUIMigrationView_ZoneList:GetZones()
  return self.zones
end

return LWUIMigrationView_ZoneList
