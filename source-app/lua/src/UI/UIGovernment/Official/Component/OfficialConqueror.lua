local base = UIAsyncContainer
local OfficialConqueror = BaseClass("OfficialConqueror", base)
local Localization = CS.GameEntry.Localization
local ConquerKingItem = require("UI.UIGovernment.Official.Component.ConquerKingItem")
local CLS = "UI.UIGovernment.Official.Component.OfficialGovernor"
local PREFAB = "Assets/Main/Prefabs/UI/UIGovernment/OfficialCellYellow.prefab"

function OfficialConqueror:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function OfficialConqueror:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function OfficialConqueror:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.ConquerKingNode = self.viewSkin:AddComponent(self, ConquerKingItem, 1)
  self.compGovernorList = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
end

function OfficialConqueror:ComponentDestroy()
  self.viewSkin = nil
  self.ConquerKingNode = nil
  self.compGovernorList = nil
end

function OfficialConqueror:DataDefine()
  self.governorList = {}
end

function OfficialConqueror:DataDestroy()
  self.governorList = nil
  self.conquerorServerId = nil
  self.serverId = nil
end

function OfficialConqueror:OnAddListener()
  base.OnAddListener(self)
end

function OfficialConqueror:OnRemoveListener()
  base.OnRemoveListener(self)
end

function OfficialConqueror:ReInit(conquerorServerId, serverId)
  self.conquerorServerId = conquerorServerId
  self.serverId = serverId
  self:RefreshView()
end

function OfficialConqueror:UpdateData()
  if self.serverId == nil then
    return
  end
  self.ConquerKingNode:ReInit(self.serverId)
  local conquerorPositions = DataCenter.GovernmentManager:GetConquerorPositionByServerId(self.serverId)
  for i = 1, 2 do
    local configData = DataCenter.GovernmentTemplateManager:GetTemplateByGroupAndOrder(GovOfficialGroup.Common, i)
    local governmentId = configData ~= nil and configData.id or nil
    if governmentId ~= nil then
      local comp = self.governorList[governmentId]
      if comp == nil then
        comp = self:LoadComponentAsync(CLS, PREFAB, self.compGovernorList, function()
          comp:SetBg(true)
        end)
        comp:SetName("governor" .. i)
        self.governorList[governmentId] = comp
      end
      comp:SetData(governmentId, self.conquerorServerId, true, conquerorPositions[governmentId])
    end
  end
end

return OfficialConqueror
