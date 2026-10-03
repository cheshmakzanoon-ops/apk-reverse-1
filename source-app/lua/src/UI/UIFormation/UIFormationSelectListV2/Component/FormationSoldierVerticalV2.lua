local FormationSoldierVerticalV2 = BaseClass("FormationSoldierVerticalV2", UIBaseContainer)
local base = UIBaseContainer

function FormationSoldierVerticalV2:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function FormationSoldierVerticalV2:DataDefine()
end

function FormationSoldierVerticalV2:ComponentDefine()
  self.icon = self:AddComponent(UIImage, "WorkerIcon")
  self.countText = self:AddComponent(UIText, "WorkerCountText")
  self.levelText = self:AddComponent(UIText, "WorkerLevelText")
  self.qualityBg = self:AddComponent(UIImage, "QualityBg")
  self.btn = self:AddComponent(UIButton, "")
  if self.btn then
    self.btn:SetOnClick(function()
      if self.clickCallBack ~= nil then
        self.clickCallBack(self.soldierData, self.icon.transform.position)
      end
    end)
  end
end

function FormationSoldierVerticalV2:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function FormationSoldierVerticalV2:DataDestroy()
  self.soldierData = nil
end

function FormationSoldierVerticalV2:ComponentDestroy()
  self.icon = nil
  self.countText = nil
  self.levelText = nil
  self.btn = nil
end

function FormationSoldierVerticalV2:SetData(soldierData, clickCallBack)
  if soldierData == nil then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.soldierData = soldierData
  local soldierId = soldierData.id
  local count = soldierData.count
  local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(soldierId)
  local soldierLevel = soldierTemplate.lv
  local soldierIcon = string.format(LoadPath.ItemPath, soldierTemplate.icon)
  if soldierData.t11Data then
    soldierIcon = DataCenter.SoldierDataManager:GetSoldierIconById(soldierId, soldierData.t11Data)
  end
  self.levelText:SetText(string.format("Lv.%d", soldierLevel))
  self.icon:LoadSpriteAsync(soldierIcon)
  if count ~= nil then
    self.countText:SetText(string.GetFormattedStr(count))
  else
    self.countText:SetText("")
  end
  self.qualityBg:LoadSprite(UIUtil.GetItemQualityBg(soldierTemplate.quality))
  self.clickCallBack = clickCallBack
end

function FormationSoldierVerticalV2:SetInteractable(interactable)
  self.btn:SetInteractable(interactable)
end

function FormationSoldierVerticalV2:SetCountTextVisible(visible)
  self.countText:SetActive(visible)
end

function FormationSoldierVerticalV2:SetCountText(text)
  self.countText:SetText(text)
end

return FormationSoldierVerticalV2
