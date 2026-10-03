local base = UIBaseContainer
local TacticalChipItem = BaseClass("TacticalChipItem", UIBaseContainer)
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local UIHeroSkillStar = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillStar")
local Localization = CS.GameEntry.Localization
local ItemType = {Goods = 1, Chip = 2}
local bg_path = "Container/Bg"
local btn_path = "btn"

function TacticalChipItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TacticalChipItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TacticalChipItem:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.icon = self:AddComponent(UIImage, "Container/Icon")
  self.border = self:AddComponent(UIBaseContainer, "Container/border")
  self.skillChipTypeIcon = self:AddComponent(UIImage, "Container/SkillChipTypeIcon")
  self.starsLayout = self:AddComponent(UIBaseContainer, "Container/StarsLayout")
  self.countTxt = self:AddComponent(UIText, "Container/countTxt")
  self.masterBg = self:AddComponent(UIBaseContainer, "Container/masterBg")
  self.masterTxt = self:AddComponent(UIText, "Container/masterBg/masterTxt")
  self.productSelected = self:AddComponent(UIBaseContainer, "Container/productSelected")
  self.productFlag = self:AddComponent(UIBaseContainer, "Container/productFlag")
  self.normalSelected = self:AddComponent(UIBaseContainer, "Container/normalSelected")
  self.locked = self:AddComponent(UIBaseContainer, "Container/locked")
  self.redDot = self:AddComponent(UIBaseContainer, "Container/redDot")
  self.vfxNode = self:AddComponent(UIVfx, "Container/vfxNode")
  self.deleteBtn = self:AddComponent(UIButton, "Container/deleteBtn")
  self.deleteBtn:SetOnClick(function()
    self:OnBtnDeleteClick()
  end)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.evtTrigger = self:AddComponent(UIEventTrigger, "evtTrigger")
  self.evtTrigger:OnPointerClick(function()
    self:OnClick()
  end)
  self.evtTrigger:onLongPress(function()
    if self.longPressCallback then
      self.longPressCallback(self, self.skillChipInfo)
    end
  end)
  self.evtTrigger:OnBeginDrag(function(eventData)
    if self.beginDragCallback then
      self.beginDragCallback(eventData)
    end
  end)
  self.evtTrigger:OnEndDrag(function(eventData)
    if self.endDragCallback then
      self.endDragCallback(eventData)
    end
  end)
  self.evtTrigger:OnDrag(function(eventData)
    if self.dragCallback then
      self.dragCallback(eventData)
    end
  end)
  self.posIcon = self:AddComponent(UIImage, "Container/posIcon")
  if CommonUtil.IsArabic() and CommonUtil.ArabicAutoMirrorFactor() == -1 then
    self.posIcon:SetLocalScaleXYZ(-1, 1, 1)
  else
    self.posIcon:SetLocalScaleXYZ(1, 1, 1)
  end
  self:ResetDefaultVisible(true)
  self:SetCanClick(true)
end

function TacticalChipItem:SetCount(count)
  if count and 1 < count then
    self.countTxt:SetText(string.format("\195\151%d", count))
    self:SetCountVisible(true)
  else
    self:SetCountVisible(false)
  end
end

function TacticalChipItem:SetPlanMaster(planId)
  if planId and 0 < planId then
    self.masterTxt:SetText(planId)
    self:SetPlanMasterVisible(true)
  else
    self:SetPlanMasterVisible(false)
  end
end

function TacticalChipItem:ComponentDestroy()
  self.imgIcon = nil
  self.compBorder = nil
  self.imgSkillChipTypeIcon = nil
  self.compStarsLayout = nil
  self.textCountTxt = nil
  self.compMasterBg = nil
  self.textMasterTxt = nil
  self.compProductSelected = nil
  self.compProductFlag = nil
  self.compNormalSelected = nil
  self.compLocked = nil
  self.btnDelete = nil
end

function TacticalChipItem:DataDefine()
  self.stars = {}
end

function TacticalChipItem:DataDestroy()
end

function TacticalChipItem:Refresh()
  if self.chipInfo == nil then
    return
  end
  local uuid = self.chipInfo:GetUUID()
  local chipInfo = DataCenter.TacticalChipManager:GetChipInfo(uuid)
  self:SetData(chipInfo)
end

function TacticalChipItem:SetData(chipInfo)
  if chipInfo == nil or chipInfo.template == nil then
    return
  end
  self:ClearChipInfo()
  self:ResetDefaultVisible(true)
  self.chipInfo = chipInfo
  self.bg:LoadSprite(DataCenter.RewardManager:GetRewardQualityBg(RewardType.TWSkillChip, chipInfo:GetId()))
  self.icon:LoadSpriteAuto(chipInfo:GetIcon())
  self.skillChipTypeIcon:LoadSprite(TacticalWeaponUtils.GetSkillChipTypeIcon(chipInfo:GetType()))
  self:SetPlanMaster(chipInfo:GetMasterSet())
  self:SetCount(chipInfo:GetNum())
  self.posIcon:LoadSprite(DataCenter.TacticalChipManager:GetChipPosIcon(chipInfo:GetType()))
  local starCount = self.chipInfo:GetStar()
  self:SetStars(starCount)
end

function TacticalChipItem:SetTemplate(chipId, star)
  if not chipId then
    return
  end
  local chipTemplate = DataCenter.TWSkillChipTemplateManager:GetTemplate(chipId)
  if not chipTemplate then
    return
  end
  self:ClearChipInfo()
  self:ResetDefaultVisible(true)
  self.bg:LoadSprite(DataCenter.RewardManager:GetRewardQualityBg(RewardType.TWSkillChip, chipId))
  self.icon:LoadSprite(DataCenter.RewardManager:GetPicByType(RewardType.TWSkillChip, chipId))
  self.skillChipTypeIcon:LoadSprite(TacticalWeaponUtils.GetSkillChipTypeIcon(chipTemplate.skill_type))
  self.posIcon:LoadSprite(DataCenter.TacticalChipManager:GetChipPosIcon(chipTemplate.skill_type))
  local starCount = star ~= nil and star or 0
  self:SetStars(starCount)
  self.chipTemplateId = chipId
  self.star = star
end

function TacticalChipItem:SetStars(starCount)
  self:ClearStars()
  if 0 < starCount then
    local showStarCount = math.min(starCount, 5)
    local rightWindow = starCount
    for i = 1, showStarCount do
      local starRequest = self:GameObjectInstantiateAsync(UIAssets.UIHeroSkillStar, function(request)
        if IsNull(request.gameObject) then
          return
        end
        local go = request.gameObject
        local transform = go.transform
        go.gameObject:SetActive(true)
        transform:SetParent(self.starsLayout.transform)
        transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = i
        local cell = self.starsLayout:AddComponent(UIHeroSkillStar, go)
        cell:SetFilled(true)
        local viewStarIndex = rightWindow - i + 1
        cell:SetStarIndex(viewStarIndex)
        cell.transform:Set_sizeDelta(21.04, 20.08)
      end)
      table.insert(self.stars, starRequest)
    end
  end
end

function TacticalChipItem:ResetDefaultVisible(isChip)
  self.border:SetActive(isChip)
  self:SetStarVisible(isChip)
  self:SetPosIconVisible(false)
  self:SetCountVisible(false)
  self:SetChipTypeVisible(false)
  self:SetPlanMasterVisible(false)
  self:SetProductSelectedVisible(false)
  self:SetProductFlagVisible(false)
  self:SetNormalSelectedVisible(false)
  self:SetLockedVisible(false)
  self:SetDeleteBtnVisible(false)
  self:SetEventTrigger(false)
  self:SetRedDotVisible(false)
end

function TacticalChipItem:SetPosIconVisible(visible)
  self.posIcon:SetActive(visible)
end

function TacticalChipItem:SetStarVisible(visible)
  self.starsLayout:SetActive(visible)
end

function TacticalChipItem:SetChipTypeVisible(visible)
  self.skillChipTypeIcon:SetActive(visible)
end

function TacticalChipItem:SetCountVisible(visible)
  self.countTxt:SetActive(visible)
end

function TacticalChipItem:SetPlanMasterVisible(visible)
  self.masterBg:SetActive(visible)
end

function TacticalChipItem:SetProductSelectedVisible(visible)
  self.productSelected:SetActive(visible)
end

function TacticalChipItem:SetProductFlagVisible(visible)
  self.productFlag:SetActive(visible)
end

function TacticalChipItem:SetNormalSelectedVisible(visible)
  self.normalSelected:SetActive(visible)
end

function TacticalChipItem:SetLockedVisible(visible)
  self.locked:SetActive(visible)
end

function TacticalChipItem:SetDeleteBtnVisible(visible)
  self.deleteBtn:SetActive(visible)
end

function TacticalChipItem:SetEventTrigger(visible)
  self.evtTrigger:SetActive(visible)
  self.btn:SetActive(not visible)
end

function TacticalChipItem:SetRedDotVisible(visible)
  self.redDot:SetActive(visible)
end

function TacticalChipItem:SetOnClick(callback)
  self.onClick = callback
end

function TacticalChipItem:SetOnClickChipItem(callback)
  self.OnClickChipItem = callback
end

function TacticalChipItem:SetOnClickChipInfo(callback)
  self.onClickChipInfo = callback
end

function TacticalChipItem:SetCanClick(canClick)
  self.canClick = canClick
end

function TacticalChipItem:PlayVfx(path, param)
  self.vfxNode:Play(path, param)
end

function TacticalChipItem:RemoveVfx()
  self.vfxNode:Remove()
end

function TacticalChipItem:ClearStars()
  if self.stars then
    self.starsLayout:RemoveComponents(UIHeroSkillStar)
    for i, v in ipairs(self.stars) do
      self:GameObjectDestroy(v)
    end
    self.stars = {}
  end
end

function TacticalChipItem:ClearChipInfo()
  self.chipInfo = nil
  self.chipTemplateId = nil
  self.star = nil
end

function TacticalChipItem:OnClick()
  if not self.canClick then
    return
  end
  if self.OnClickChipItem then
    self.OnClickChipItem(self)
    return
  end
  if self.onClick then
    self.onClick(self.chipTemplateId)
    return
  end
  if self.onClickChipInfo and self.chipInfo then
    self.onClickChipInfo(self.chipInfo)
    return
  end
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWTWSkillChipDetail) then
    if self.chipInfo then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTWSkillChipDetail, {anim = true}, self.chipInfo, true, true)
    elseif self.chipTemplateId then
      if not self.chipTemplate then
        self.chipTemplate = TWSkillChipInfo.New()
      end
      self.chipTemplate:CreateFromTemplate(self.chipTemplateId, 1, self.star)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTWSkillChipDetail, {anim = true}, self.chipTemplate)
    end
  end
end

function TacticalChipItem:OnBtnDeleteClick()
end

function TacticalChipItem:SetOnLongPress(callback)
  self.longPressCallback = callback
  self:SetEventTrigger(true)
end

function TacticalChipItem:SetOnBeginDrag(callback)
  self.beginDragCallback = callback
  self:SetEventTrigger(true)
end

function TacticalChipItem:SetOnEndDrag(callback)
  self.endDragCallback = callback
  self:SetEventTrigger(true)
end

function TacticalChipItem:SetOnDrag(callback)
  self.dragCallback = callback
  self:SetEventTrigger(true)
end

function TacticalChipItem:SetItemInfo(itemInfo)
  if itemInfo.type == ItemType.Goods then
    self:ResetDefaultVisible(false)
    self:SetChipExpData(itemInfo)
  else
    self:ResetDefaultVisible(true)
    local chipInfo = DataCenter.TacticalChipManager:GetChipInfo(itemInfo.uuid)
    self:SetData(chipInfo)
    self:SetCount(itemInfo.useCount)
  end
end

function TacticalChipItem:SetChipExpData(chipExpItemInfo)
  if not chipExpItemInfo then
    return
  end
  self:ResetDefaultVisible(false)
  self.bg:LoadSprite(DataCenter.RewardManager:GetRewardQualityBg(RewardType.GOODS, chipExpItemInfo.configId))
  self.icon:LoadSprite(DataCenter.RewardManager:GetPicByType(RewardType.GOODS, chipExpItemInfo.configId))
  self:SetCount(chipExpItemInfo.useCount)
  self.chipExpItemInfo = chipExpItemInfo
end

return TacticalChipItem
