local WormHoleTipsV2 = BaseClass("WormHoleTipsV2", UIAsyncContainer)
local base = UIAsyncContainer

function WormHoleTipsV2:OnCreate()
  base.OnCreate(self)
  self.txt_worm_hole_tips = self:AddComponent(UITextMeshProUGUIEx, "Txt_WormHoleTips")
end

function WormHoleTipsV2:OnDestroy()
  self.txt_worm_hole_tips = nil
  base.OnDestroy(self)
end

function WormHoleTipsV2:RefreshData(wormHoleTipsMsg)
  self.wormHoleTipsMsg = wormHoleTipsMsg
  self:UpdateData()
end

function WormHoleTipsV2:UpdateData()
  if self.txt_worm_hole_tips ~= nil and self.wormHoleTipsMsg ~= nil then
    self.txt_worm_hole_tips:SetText(self.wormHoleTipsMsg)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.txt_worm_hole_tips.transform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
  end
end

return WormHoleTipsV2
