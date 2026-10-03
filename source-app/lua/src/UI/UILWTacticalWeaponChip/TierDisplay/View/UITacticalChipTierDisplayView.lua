local UITacticalChipTierDisplayView = BaseClass("UITacticalChipTierDisplayView", UIBaseView)
local TacticalChipTierDisplayItem = require("UI.UILWTacticalWeaponChip.TierDisplay.TacticalChipTierDisplayItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UITacticalChipTierDisplayView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UITacticalChipTierDisplayView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITacticalChipTierDisplayView:ComponentDefine()
  self.btnBg = self:AddComponent(UIButton, "BgBtn")
  self.btnBg:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle = self:AddComponent(UIText, "Root/title")
  self.textTitle:SetLocalText("battlesystem_tier_info1")
  self.btnClose = self:AddComponent(UIButton, "Root/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compItemContent = self:AddComponent(UIBaseContainer, "Root/itemHolder/Viewport/ItemContent")
  self.textDesc = self:AddComponent(UITextMeshProUGUIEx, "Root/desc")
  self.textDesc:SetLocalText("battlesystem_tier_info2")
  self.textDesc:OnPointerClick(function(eventData)
    DataCenter.TacticalChipManager.UITextClickTips(eventData, self.textDesc)
  end)
end

function UITacticalChipTierDisplayView:ComponentDestroy()
  self.btnBg = nil
  self.textTitle = nil
  self.btnClose = nil
  self.compItemContent = nil
  self.textDesc = nil
end

function UITacticalChipTierDisplayView:DataDefine()
  self.reqs = {}
end

function UITacticalChipTierDisplayView:DataDestroy()
  self.curTier = nil
  self.dataList = nil
  self.reqs = nil
end

function UITacticalChipTierDisplayView:Init()
  self.curTier = self:GetUserData()
  self:RefreshDataList()
end

function UITacticalChipTierDisplayView:RefreshDataList()
  self.dataList = DataCenter.TacticalChipManager:GetTierTemplateSortList()
  if self.dataList and #self.dataList > 0 then
    for i, v in ipairs(self.dataList) do
      self.reqs = self:CreateTierItem(i, v)
    end
  end
end

function UITacticalChipTierDisplayView:CreateTierItem(i, v)
  return self:GameObjectInstantiateAsync(UIAssets.TacticalChipTierDisplayItem, function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    local name = "tierItem" .. i
    go.name = name
    go.transform:SetParent(self.compItemContent.transform)
    go.transform:Set_localScale(1, 1, 1)
    go.transform:Set_localPosition(0, 0, 0)
    local cell = self.compItemContent:AddComponent(TacticalChipTierDisplayItem, name)
    cell:SetLocalPositionXYZ(0, 0, 0)
    cell:SetData(v)
    cell:SetShowFlag(self.curTier)
  end)
end

function UITacticalChipTierDisplayView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return UITacticalChipTierDisplayView
