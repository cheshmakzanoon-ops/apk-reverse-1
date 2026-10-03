local base = UIAsyncContainer
local OfficialNative = BaseClass("OfficialNative", base)
local Localization = CS.GameEntry.Localization
local KingItem = require("UI.UIGovernment.Official.Component.KingItem")
local CLS = "UI.UIGovernment.Official.Component.OfficialGovernor"
local PREFAB = "Assets/Main/Prefabs/UI/UIGovernment/OfficialCellYellow.prefab"

function OfficialNative:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function OfficialNative:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function OfficialNative:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.kingNode = self.viewSkin:AddComponent(self, KingItem, 1)
  self.king_icon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.king_icon2 = self.viewSkin:AddComponent(self, UIImage, 3)
  self.compColonistList = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.compNativeList = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
end

function OfficialNative:ComponentDestroy()
  self.viewSkin = nil
  self.kingNode = nil
  self.king_icon = nil
  self.king_icon2 = nil
  self.compColonistList = nil
  self.compNativeList = nil
end

function OfficialNative:DataDefine()
  self.nativeOfficialList = {}
end

function OfficialNative:DataDestroy()
  self.nativeOfficialList = nil
  self.serverId = nil
end

function OfficialNative:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GovernmentPresidentRefresh, self.UpdatePresidentData)
end

function OfficialNative:OnRemoveListener()
  self:RemoveUIListener(EventId.GovernmentPresidentRefresh, self.UpdatePresidentData)
  base.OnRemoveListener(self)
end

function OfficialNative:UpdatePresidentData()
  local presidentInfo = DataCenter.GovernmentManager:GetCurPresident(self.serverId)
  self.kingNode:ReInit(presidentInfo, self.serverId)
end

function OfficialNative:ReInit(serverId)
  self.serverId = serverId
  self:RefreshView()
end

function OfficialNative:UpdateData()
  if self.serverId == nil then
    return
  end
  self:UpdatePresidentData()
  local thePositions = DataCenter.GovernmentManager:GetKingdomPositionByServerId(self.serverId)
  local isConqueror = DataCenter.GovernmentManager:IsConqueror(self.serverId)
  for i = 1, 8 do
    local configData = DataCenter.GovernmentTemplateManager:GetTemplateByGroupAndOrder(GovOfficialGroup.Common, i)
    local governmentId = configData.id
    if governmentId ~= nil then
      local comp = self.nativeOfficialList[governmentId]
      if comp == nil then
        local isFront = i < 3
        local parent = isFront and self.compColonistList or self.compNativeList
        comp = self:LoadComponentAsync(CLS, PREFAB, parent, function()
          comp:SetBg(isFront)
        end)
        comp:SetName("cell" .. i)
        self.nativeOfficialList[governmentId] = comp
      end
      local showFlag = true
      if DataCenter.GovernmentTemplateManager:IsConqueror(governmentId) then
        showFlag = isConqueror
        comp:SetActive(isConqueror)
      end
      if showFlag then
        do
          local positionInfo = thePositions and thePositions[governmentId] or nil
          comp:SetData(governmentId, self.serverId, false, positionInfo)
        end
      end
    end
  end
  self.king_icon:SetActive(not isConqueror)
  self.king_icon2:SetActive(isConqueror)
end

return OfficialNative
