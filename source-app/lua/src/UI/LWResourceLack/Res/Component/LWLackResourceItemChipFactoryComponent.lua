local LWResourceLackCell = require("UI.LWResourceLack.Res.Component.LWResourceLackCell")
local base = UIBaseContainer
local LWLackResourceItemChipFactoryComponent = BaseClass("LWLackResourceItemChipFactoryComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWLackResourceItemChipFactoryComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWLackResourceItemChipFactoryComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWLackResourceItemChipFactoryComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.sliderGroup = self.viewSkin:AddComponent(self, UISliderGroup, 1)
  self.compCostNode = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.textCostTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textCostNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.imgCostQuality = self.viewSkin:AddComponent(self, UIImage, 5)
  self.imgCostIcon = self.viewSkin:AddComponent(self, UIImage, 6)
  self.textItemNameInfo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.imgDefaultQuality = self.viewSkin:AddComponent(self, UIImage, 8)
  self.imgQuality = self.viewSkin:AddComponent(self, UIImage, 9)
  self.imgItemIcon = self.viewSkin:AddComponent(self, UIImage, 10)
  self.btnGoto = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnGoto:SetOnClick(function()
    self:OnBtnGotoClick()
  end)
  self.textGotoBtnTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.btnMake = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnMake:SetOnClick(function()
    self:OnBtnMakeClick()
  end)
  self.textNotMakeTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.textMakeBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.textMakeBtn:SetLocalText("drone_skillchip_getmore_8_btn")
  self.MakeBtnNumText = self:AddComponent(UITextMeshProUGUIEx, "MakeBtn/MakeBtnNumText")
end

function LWLackResourceItemChipFactoryComponent:ComponentDestroy()
  self.viewSkin = nil
  self.silderGroup = nil
  self.compCostNode = nil
  self.textCostTitle = nil
  self.textCostNum = nil
  self.imgCostQuality = nil
  self.imgCostIcon = nil
  self.textItemNameInfo = nil
  self.imgDefaultQuality = nil
  self.imgQuality = nil
  self.imgItemIcon = nil
  self.btnGoto = nil
  self.textGotoBtnTxt = nil
  self.btnMake = nil
  self.textNotMakeTips = nil
  self.textMakeBtn = nil
end

function LWLackResourceItemChipFactoryComponent:DataDefine()
end

function LWLackResourceItemChipFactoryComponent:DataDestroy()
end

function LWLackResourceItemChipFactoryComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWLackResourceItemChipFactoryComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWLackResourceItemChipFactoryComponent:Refresh(lightBgActive, template, ctrl, context)
  if not (template and ctrl) or not context then
    return
  end
  self.data = template
  self.context = context
  self.ctrl = ctrl
  self.chipId = self.context.chipId
  self.chipTemplate = DataCenter.TacticalChipFactoryManager:GetChipTemplate(self.chipId)
  if not self.chipTemplate then
    Logger.LogError("chipTemplete is nil.   id:" .. tostring(self.chipId))
    return
  end
  self.building = self:GetChipFactoryBuilding()
  self.textItemNameInfo:SetLocalText(self.data.name)
  self.imgItemIcon:LoadSprite(DataCenter.RewardManager:GetPicByType(RewardType.TWSkillChip, self.chipId))
  local costItemId = self.chipTemplate.craft_material[1]
  self.imgCostQuality:LoadSprite(DataCenter.RewardManager:GetRewardQualityBg(RewardType.GOODS, costItemId))
  self.imgCostIcon:LoadSprite(DataCenter.RewardManager:GetPicByType(RewardType.GOODS, costItemId))
  local canMake = self:CanMakeByBuildingLevel()
  if canMake then
    self:RefreshSlider()
  else
    local needLevel = self.chipTemplate.craft_factory_level
    self.textNotMakeTips:SetLocalText("drone_skillchip_getmore_17_limit_20", needLevel)
    self.textGotoBtnTxt:SetLocalText("drone_skillchip_getmore_7_limit_5")
  end
  self.textNotMakeTips:SetActive(not canMake)
  self.sliderGroup:SetActive(canMake)
  self.compCostNode:SetActive(canMake)
  self.btnGoto:SetActive(not canMake)
  self.btnMake:SetActive(canMake)
end

function LWLackResourceItemChipFactoryComponent:GetChipFactoryBuilding()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILDING_TACTICAL_CHIP_FACTORY)
  if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
    return
  end
  return buildList[1]
end

function LWLackResourceItemChipFactoryComponent:CanMakeByBuildingLevel()
  if not self.building or not self.chipTemplate then
    return false
  end
  return self.building.level >= self.chipTemplate.craft_factory_level
end

function LWLackResourceItemChipFactoryComponent:RefreshSlider()
  local need = self.context.need
  local ownNum = DataCenter.TacticalChipManager:GetChipFreeCount(self.chipId)
  self.realNeed = need - ownNum
  local costItemId, costItemNum, ownItemNum = self:GetItemIdAndCostAndOwn()
  local canProductNum = ownItemNum // costItemNum
  self.sliderGroup:SetMinNum(1)
  self.sliderGroup:SetDefaultNum(1)
  self.sliderGroup:SetOnNumChangedHandler(function(num)
    self.MakeBtnNumText:SetText(tostring(num))
    self:RefreshItemCost()
  end)
  if canProductNum <= 0 then
    self.sliderGroup:SetMaxNum(1)
  else
    self.sliderGroup:SetMaxNum(canProductNum)
    local defaultNum = math.min(canProductNum, self.realNeed)
    self.sliderGroup:SetDefaultNum(defaultNum)
  end
  self.sliderGroup:ReInit()
end

function LWLackResourceItemChipFactoryComponent:RefreshItemCost()
  if self.chipId == nil then
    return
  end
  local costItemId, costItemNum, ownItemNum = self:GetItemIdAndCostAndOwn()
  costItemNum = costItemNum * self.sliderGroup:GetCurNum()
  if ownItemNum >= costItemNum then
    self.textCostNum:SetLocalText("battlesystem_factory_craft_desc4", ownItemNum, costItemNum)
  else
    self.textCostNum:SetLocalText("battlesystem_factory_craft_desc5", ownItemNum, costItemNum)
  end
end

function LWLackResourceItemChipFactoryComponent:GetItemIdAndCostAndOwn()
  if self.chipId == nil then
    return
  end
  local costItemId = self.chipTemplate.craft_material[1]
  local costItemNum = self.chipTemplate.craft_material[2]
  local itemInfo = DataCenter.ItemData:GetItemById(costItemId)
  local ownItemNum = 0
  if itemInfo then
    ownItemNum = itemInfo.count or 0
  end
  return costItemId, costItemNum, ownItemNum
end

function LWLackResourceItemChipFactoryComponent:OnBtnGotoClick()
  self:GuideToChipFactory()
end

function LWLackResourceItemChipFactoryComponent:OnBtnMakeClick()
  if self.building == nil or self.chipId == nil then
    return
  end
  local template = DataCenter.TacticalChipFactoryManager:GetChipTemplate(self.chipId)
  local costItemId = template.craft_material[1]
  local costItemNum = template.craft_material[2]
  local itemInfo = DataCenter.ItemData:GetItemById(costItemId)
  local ownItemNum = 0
  if itemInfo then
    ownItemNum = itemInfo.count or 0
  end
  if costItemNum > ownItemNum then
    return
  end
  if template:IsLock(self.building.level) then
    UIUtil.ShowTips(Localization:GetString("battlesystem_factory_error4"))
    return
  end
  local curSelectNum = self.sliderGroup:GetCurNum()
  if curSelectNum > self.realNeed then
    UIUtil.ShowConfirmNew({
      title = Localization:GetString("drone_skillchip_getmore_19_title"),
      contentText = Localization:GetString("drone_skillchip_getmore_18_desc"),
      btnNum = 2,
      showToggle = false,
      confirmBtnParam = {
        context = "drone_skillchip_getmore_20_btn",
        action = function()
          SFSNetwork.SendMessage(MsgDefines.TacticalChipProductNew, self.chipId, self.sliderGroup:GetCurNum())
        end
      },
      cancelBtnParam = {
        context = "drone_skillchip_getmore_21_btn",
        action = function()
          self:RefreshSlider()
        end
      }
    })
  else
    SFSNetwork.SendMessage(MsgDefines.TacticalChipProductNew, self.chipId, self.sliderGroup:GetCurNum())
  end
end

function LWLackResourceItemChipFactoryComponent:GuideToChipFactory()
  if not self.building then
    GoToUtil.GotoBuildListByBuildId(BuildingTypes.LW_BUILDING_TACTICAL_CHIP_FACTORY)
    return
  end
  GoToUtil.GotoCityByCondBuildId(BuildingTypes.LW_BUILDING_TACTICAL_CHIP_FACTORY, WorldTileBtnType.City_Upgrade)
end

function LWLackResourceItemChipFactoryComponent:RefreshLightBg()
end

return LWLackResourceItemChipFactoryComponent
