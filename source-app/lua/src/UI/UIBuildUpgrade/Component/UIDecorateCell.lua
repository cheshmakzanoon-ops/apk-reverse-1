local UIDecorateCell = BaseClass("UIDecorateCell", UIBaseContainer)
local base = UIBaseContainer

function UIDecorateCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

function UIDecorateCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDecorateCell:OnEnable()
  base.OnEnable(self)
end

function UIDecorateCell:OnDisable()
  base.OnDisable(self)
end

function UIDecorateCell:ComponentDefine()
  self.NormalContent = self:AddComponent(UIBaseContainer, "NormalContent")
  self.TipsContent = self:AddComponent(UIBaseContainer, "TipsContent")
  self.bgIcon = self:AddComponent(UIImage, "NormalContent/BG")
  self.decorateIcon = self:AddComponent(UIImage, "NormalContent/BG/icon")
  self.level = self:AddComponent(UIText, "NormalContent/BG/level")
  self.count = self:AddComponent(UIText, "NormalContent/count")
  self.btn = self:AddComponent(UIButton, "NormalContent/BG/icon")
  self.btn:SetOnClick(function()
    if self.param.itemId == GLUE_GOOD_ID then
      local param = {}
      param.itemId = self.param.itemId
      param.alignObject = self.decorateIcon
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  end)
  self.level_tips = self:AddComponent(UIText, "TipsContent/Tip2")
end

function UIDecorateCell:ReInit(param, isShowNum)
  if param == nil then
    return
  end
  self.param = param
  self.NormalContent:SetActive(not param.isTip)
  self.TipsContent:SetActive(param.isTip)
  self.count:SetActive(isShowNum)
  if param.isTip then
    local oneLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(param.baseBuildingId, 1)
    self.level_tips:SetText("Lv1 X" .. param.count // oneLevelTemplate.equal_glue_value)
  else
    if self.param.itemId == GLUE_GOOD_ID then
      self.level:SetActive(false)
      self.bgIcon:LoadSprite(DataCenter.RewardManager:GetRewardQualityBg(RewardType.GOODS, GLUE_GOOD_ID))
      self.decorateIcon:LoadSprite(DataCenter.RewardManager:GetPicByType(RewardType.GOODS, GLUE_GOOD_ID))
    else
      self.level:SetActive(true)
      self.bgIcon:LoadSprite(UIUtil.GetItemQualityBg(BuildingUtils.GetDecorateColor(self.param.id, true)))
      self.level:SetText("Lv." .. self.param.id % BuildLevelCap)
      self.decorateIcon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.param.id // BuildLevelCap * BuildLevelCap, 1), DefaultImage)
    end
    if isShowNum then
      local curCount = self.param.count
      if self.param.levelTemplate ~= nil then
        local buildBaseId = self.param.levelTemplate.id // BuildLevelCap * BuildLevelCap
        curCount = BuildingUtils.GetDecorateCountByLevel(buildBaseId, self.param.levelTemplate.level)
      end
      if self.param.maxCount then
        if curCount >= self.param.maxCount then
          self.count:SetText(string.format("<color=#5FEF87>%d</color>/%d", curCount, self.param.maxCount))
        else
          self.count:SetText(string.format("<color=#F97077>%d</color>/%d", curCount, self.param.maxCount))
        end
      elseif self.param.nextScore then
        self.count:SetText(string.format("<color=#F97077>%d</color>/%d", curCount, self.param.nextScore))
      else
        self.count:SetText(string.format("<color=#5FEF87>%d</color>/%d", curCount, self.param.count))
      end
    end
  end
end

function UIDecorateCell:OnSelectBtnClick()
end

function UIDecorateCell:ComponentDestroy()
  self.bgIcon = nil
  self.decorateIcon = nil
  self.level = nil
  self.count = nil
end

return UIDecorateCell
