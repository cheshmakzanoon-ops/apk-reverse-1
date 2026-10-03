local base = UIBaseContainer
local UISurvivorPackListItem = BaseClass("UISurvivorPackListItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UISurvivorPackListItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.textNoChecked:SetText(Localization:GetString("100447"))
  self.textRecruitTxt:SetText(Localization:GetString("129011"))
end

function UISurvivorPackListItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISurvivorPackListItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgIconBg = self.viewSkin:AddComponent(self, UIImage, 2)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 3)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textCareer = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textRecruitTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textNoChecked = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.imgNoChecked = self.viewSkin:AddComponent(self, UIImage, 8)
  self.BtnClick = self.viewSkin:AddComponent(self, UIButton, 9)
  self.BtnClick:SetOnClick(function()
    self:OnBtnClickClick()
  end)
end

function UISurvivorPackListItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.imgIconBg = nil
  self.imgIcon = nil
  self.textName = nil
  self.textCareer = nil
  self.textRecruitTxt = nil
  self.textNoChecked = nil
  self.imgNoChecked = nil
  self.BtnClick = nil
end

function UISurvivorPackListItem:DataDefine()
  self.survivorListId = nil
end

function UISurvivorPackListItem:DataDestroy()
  self.survivorListId = nil
end

function UISurvivorPackListItem:OnAddListener()
  base.OnAddListener(self)
end

function UISurvivorPackListItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UISurvivorPackListItem:SetData(survivorListId)
  self.survivorListId = survivorListId
  local groupKey = DataCenter.SurvivorPackManager.list_group or ""
  self.survivorTemplate = DataCenter.ActivitySurvivorListTemplateManager:GetTemplate(survivorListId, groupKey)
  self.imgNoChecked:SetActive(not DataCenter.SurvivorPackManager:IsFreeRewardReceivedById(survivorListId))
  if not self.survivorTemplate or not self.survivorTemplate.worker_id then
    return
  end
  local workerId = tonumber(self.survivorTemplate.worker_id)
  if not workerId then
    return
  end
  local workerLine = LocalController:instance():getLine(TableName.LW_Worker, workerId)
  if not workerLine then
    return
  end
  if self.textName and workerLine.last_name then
    self.textName:SetText(Localization:GetString(workerLine.last_name))
  end
  if self.textCareer and workerLine.first_name then
    self.textCareer:SetText(Localization:GetString(workerLine.first_name))
  end
  local appearanceId = workerLine.appearance
  if appearanceId ~= nil and self.imgIcon then
    local iconPath = HeroUtils.GetHeroIconPath(tonumber(appearanceId), HeroIconType.half_portrait)
    if not string.IsNullOrEmpty(iconPath) then
      self.imgIcon:LoadSpriteAuto(iconPath)
    end
  end
  local q = tonumber(self.survivorTemplate.quality)
  local bgName
  if q == 1 then
    bgName = "Assets/Main/Sprites/UI/UISurvivorPack/wxy_xingcunzhe_libaodating_listlan.png"
  elseif q == 2 then
    bgName = "Assets/Main/Sprites/UI/UISurvivorPack/wxy_xingcunzhe_libaodating_listzi.png"
  elseif q == 3 then
    bgName = "Assets/Main/Sprites/UI/UISurvivorPack/wxy_xingcunzhe_libaodating_listcheng.png"
  end
  if self.imgBg and bgName then
    self.imgBg:LoadSpriteAuto(bgName)
  end
  if self.imgIconBg then
    self.imgIconBg:LoadSpriteAuto(WorkerUtil.GetWorkerQualityBg(tonumber(self.survivorTemplate.quality) + 2))
  end
end

function UISurvivorPackListItem:OnBtnClickClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISurvivorPackPopup, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, nil, self.survivorListId)
end

return UISurvivorPackListItem
