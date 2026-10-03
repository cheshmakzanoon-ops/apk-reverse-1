local base = UIBaseContainer
local TacticalChipPlanNeedStarItem = BaseClass("TacticalChipPlanNeedStarItem", UIBaseContainer)
local UIHeroSkillStar = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillStar")
local Localization = CS.GameEntry.Localization
local SQUAD_INDEX_ICON_PATH_FORMAT = "Assets/Main/Sprites/UI/LWUITacticalWeaponChip/FX_wurenjixingpian_fenpeibiandui0%s.png"

function TacticalChipPlanNeedStarItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TacticalChipPlanNeedStarItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TacticalChipPlanNeedStarItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compStars = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
end

function TacticalChipPlanNeedStarItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgIcon = nil
  self.textTitle = nil
  self.compStars = nil
  self.textDesc = nil
end

function TacticalChipPlanNeedStarItem:DataDefine()
end

function TacticalChipPlanNeedStarItem:DataDestroy()
end

function TacticalChipPlanNeedStarItem:OnAddListener()
  base.OnAddListener(self)
end

function TacticalChipPlanNeedStarItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function TacticalChipPlanNeedStarItem:SetData(planId, chipData)
  self.imgIcon:LoadSprite(string.format(SQUAD_INDEX_ICON_PATH_FORMAT, planId))
  self.textTitle:SetLocalText("drone_skillchip_detail_11_limit_5")
  local isMaxStar = chipData:IsMaxStar()
  local showPreview, ownNumStr, needNum = DataCenter.TacticalChipManager.GetUpgradeStarNeedNumFormat(chipData)
  if showPreview then
    self.textDesc:SetActive(true)
    self.textDesc:SetLocalText("drone_skillchip_detail_12_limit_10", ownNumStr, needNum)
    if chipData:GetStar() == 0 then
      self.textTitle:SetLocalText("drone_skillchip_make_16_limit_18")
    end
  elseif isMaxStar then
    self.textDesc:SetActive(true)
    self.textDesc:SetLocalText("drone_skillchip_detail_14_limit_12")
  else
    self.textDesc:SetActive(false)
  end
  self:SetStars(chipData:GetStar())
end

function TacticalChipPlanNeedStarItem:SetStars(starCount)
  if 0 < starCount then
    local showStarCount = math.min(starCount, 5)
    local leftWindow = math.max(0, starCount - 5)
    local rightWindow = starCount
    for i = 1, showStarCount do
      local starRequest = self:GameObjectInstantiateAsync(UIAssets.UIHeroSkillStar, function(request)
        if IsNull(request.gameObject) then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.compStars.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = i
        local cell = self.compStars:AddComponent(UIHeroSkillStar, go)
        cell:SetFilled(true)
        local viewStarIndex = rightWindow - i + 1
        cell:SetStarIndex(viewStarIndex)
        cell.transform:Set_sizeDelta(22.12, 23.26)
      end)
    end
  end
end

return TacticalChipPlanNeedStarItem
