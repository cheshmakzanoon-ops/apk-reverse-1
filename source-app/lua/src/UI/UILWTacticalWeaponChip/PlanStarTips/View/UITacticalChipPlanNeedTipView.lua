local base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local UITacticalChipPlanNeedTipView = BaseClass("UITacticalChipPlanNeedTipView", base)
local Localization = CS.GameEntry.Localization
local TacticalChipPlanNeedStarItem = require("UI.UILWTacticalWeaponChip.PlanStarTips.TacticalChipPlanNeedStarItem")
local SCROLL_VIEW_SINGLE_H = 140
local SCROLL_VIEW_DEFAULT_H = 270

function UITacticalChipPlanNeedTipView:ComponentDefine()
  base.ComponentDefine(self)
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compPlanScrollView = self.viewSkin:AddComponent(self, UILayoutElement, 3)
  self.compPlanContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.textTitle:SetLocalText("drone_skillchip_detail_9_limit_18")
  self.textDes:SetLocalText("drone_skillchip_detail_10_limit_9")
end

function UITacticalChipPlanNeedTipView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.textDes = nil
  self.compPlanScrollView = nil
  self.compPlanContent = nil
  base.ComponentDestroy(self)
end

function UITacticalChipPlanNeedTipView:DataDefine()
end

function UITacticalChipPlanNeedTipView:DataDestroy()
end

function UITacticalChipPlanNeedTipView:OnAddListener()
  base.OnAddListener(self)
end

function UITacticalChipPlanNeedTipView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITacticalChipPlanNeedTipView:RefreshShow()
  base.RefreshShow(self)
  if self.param.width then
    self.contentContainer:SetSizeDeltaXY(self.param.width, 0)
    self.bgRoot:SetSizeDeltaXY(self.param.width + 40, 0)
  end
  if not self.param or not self.param.chipConfigId then
    return
  end
  self:RefreshList()
end

function UITacticalChipPlanNeedTipView:RefreshList()
  local chipParamList = DataCenter.TacticalChipManager:GetPlanSameChipList(self.param.chipConfigId)
  local chipsCount = #chipParamList
  self.compPlanScrollView:SetActive(0 < chipsCount)
  if chipsCount == 1 then
    self.compPlanScrollView:SetPreferredHeight(SCROLL_VIEW_SINGLE_H)
  elseif 2 <= chipsCount then
    self.compPlanScrollView:SetPreferredHeight(SCROLL_VIEW_DEFAULT_H)
  else
    self.textDes:SetLocalText("drone_skillchip_detail_13_limit_12")
  end
  local contentH = 20 + (chipsCount - 1) * 10 + chipsCount * 120
  self.compPlanContent:SetSizeDeltaY(contentH)
  for i, v in ipairs(chipParamList) do
    local planId = v.planId
    local chip = v.chip
    self:CreateItem(planId, chip, i)
  end
end

function UITacticalChipPlanNeedTipView:CreateItem(planId, chip, index)
  self:GameObjectInstantiateAsync(UIAssets.TacticalChipPlanNeedStarItem, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.gameObject:SetActive(true)
    go.transform:SetParent(self.compPlanContent.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.name = tostring(index)
    local cell = self.compPlanContent:AddComponent(TacticalChipPlanNeedStarItem, go)
    cell:SetData(planId, chip)
  end)
end

return UITacticalChipPlanNeedTipView
