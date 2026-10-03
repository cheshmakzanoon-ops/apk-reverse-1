local UICommonSoldierVertical = BaseClass("UICommonSoldierVertical", UIBaseContainer)
local base = UIBaseContainer

function UICommonSoldierVertical:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UICommonSoldierVertical:DataDefine()
end

function UICommonSoldierVertical:ComponentDefine()
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

function UICommonSoldierVertical:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICommonSoldierVertical:DataDestroy()
  self.soldierData = nil
end

function UICommonSoldierVertical:ComponentDestroy()
  self.icon = nil
  self.countText = nil
  self.levelText = nil
  self.btn = nil
end

function UICommonSoldierVertical:SetData(soldierData, clickCallBack)
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

function UICommonSoldierVertical:SetInteractable(interactable)
  self.btn:SetInteractable(interactable)
end

function UICommonSoldierVertical:SetCountTextVisible(visible)
  self.countText:SetActive(visible)
end

function UICommonSoldierVertical:SetCountText(text)
  self.countText:SetText(text)
end

return UICommonSoldierVertical
