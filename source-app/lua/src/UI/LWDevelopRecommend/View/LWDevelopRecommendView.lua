local LWDevelopRecommendView = BaseClass("LWDevelopRecommendView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWDevelopRecommendGuideItem = require("UI/LWDevelopRecommend/Component/LWDevelopRecommendGuideItem")
local LWDevelopRecommendRateItem = require("UI/LWDevelopRecommend/Component/LWDevelopRecommendRateItem")
LWDevelopRecommendView.TabType = {Guide = 1, Rate = 2}

function LWDevelopRecommendView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.curSelectTab = self.TabType.Guide
  self:UpdateTab()
  self.hasInitGuideContent = false
  self.hasInitRateContent = false
  self:OnSelectTab(self.curSelectTab, true)
  DataCenter.LWDevelopRecommendManager:UpdateEntranceRed()
end

function LWDevelopRecommendView:ComponentDefine()
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText")
  self.textTitle:SetLocalText("develop_guide_tip3")
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/Common_bg_orange/CloseBtn")
  self.btnClose:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btnMask = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnMask:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.objTabLayout = self:AddComponent(UIBaseContainer, "Root/TabLayout")
  self.compTabList = {}
  for i, v in pairs(self.TabType) do
    local tab = {}
    tab.tabType = v
    local tabPath = "Root/TabLayout/Viewport/Content/Tab" .. tostring(v)
    tab.objRoot = self:AddComponent(UIBaseContainer, tabPath)
    tab.objSelect = tab.objRoot:AddComponent(UIBaseContainer, "Select")
    tab.objUnSelect = tab.objRoot:AddComponent(UIBaseContainer, "UnSelect")
    tab.text = tab.objRoot:AddComponent(UIText, "name")
    tab.btn = tab.objRoot:AddComponent(UIButton, "Btn")
    local index = v
    tab.btn:SetOnClick(function()
      self:OnSelectTab(index)
    end)
    self.compTabList[index] = tab
  end
  self.objGuide = self:AddComponent(UIBaseContainer, "Root/GuideRoot")
  self.objRate = self:AddComponent(UIBaseContainer, "Root/RateRoot")
  self.objContentGuide = self:AddComponent(UIBaseContainer, "Root/GuideRoot/ScrollGuide/ViewportGuide/ContentGuide")
  self.objContentRate = self:AddComponent(UIBaseContainer, "Root/RateRoot/ScrollRate/ViewportRate/ContentRate")
  self.objItemGuideTemplate = self:AddComponent(UIBaseContainer, "Root/GuideRoot/GuideItem")
  self.objItemGuideTemplate.gameObject:GameObjectCreatePool()
  self.objItemRateTemplate = self:AddComponent(UIBaseContainer, "Root/RateRoot/RateItemDetail")
  self.objItemRateTemplate.gameObject:GameObjectCreatePool()
  self.textMyName = self:AddComponent(UIText, "Root/RateRoot/RateItemMy/RateItemPlayer/RateItemPlayerName")
  self.textMyLevel = self:AddComponent(UIText, "Root/RateRoot/RateItemMy/RateItemPlayer/RateItemPlayerLevel")
  self.textMyPower = self:AddComponent(UIText, "Root/RateRoot/RateItemMy/RateItemPlayer/RateItemPlayerPower/RateItemPlayerPowerText")
  self.imgMyPowerIcon = self:AddComponent(UIImage, "Root/RateRoot/RateItemMy/RateItemMyIconBase/RateItemMyIcon")
  self.imgMyPowerClassSSS = self:AddComponent(UIImage, "Root/RateRoot/RateItemMy/RateItemClassIconSSS")
  self.imgMyPowerClassOther = self:AddComponent(UIImage, "Root/RateRoot/RateItemMy/RateItemClassIconOther")
  self.textMyPowerDes = self:AddComponent(UIText, "Root/RateRoot/RateItemMy/RateItemDetail")
end

function LWDevelopRecommendView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWDevelopRecommendView:ComponentDestroy()
  self.textTitle = nil
  self.btnClose = nil
  self.btnMask = nil
  self.compTabList = {}
end

function LWDevelopRecommendView:OnAddListener()
  base.OnAddListener(self)
end

function LWDevelopRecommendView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWDevelopRecommendView:OnSelectTab(tabType, forceUpdate)
  if tabType == self.curSelectTab and not forceUpdate then
    return
  end
  self.curSelectTab = tabType
  self.objGuide:SetActive(self.curSelectTab == self.TabType.Guide)
  self.objRate:SetActive(self.curSelectTab == self.TabType.Rate)
  if self.curSelectTab == self.TabType.Guide and not self.hasInitGuideContent then
    self:UpdateGuideContent()
    self.hasInitGuideContent = true
  end
  if self.curSelectTab == self.TabType.Rate and not self.hasInitRateContent then
    self:UpdateRateContent()
    self.hasInitRateContent = true
  end
  self:UpdateTab()
end

function LWDevelopRecommendView:UpdateGuideContent()
  self.objContentGuide:RemoveComponents(LWDevelopRecommendGuideItem)
  self.objItemGuideTemplate.gameObject:GameObjectRecycleAll()
  local allSourceTypeListOrdered = DataCenter.LWDevelopRecommendManager:GetMySourceTypeListOrderByClass()
  local template = DataCenter.LWDevelopRecommendManager:GetRecommendPowerConfigTemplate()
  if template ~= nil then
    local count = 0
    for i, sourceType in ipairs(allSourceTypeListOrdered) do
      if 3 <= count then
        break
      end
      if template:IsShowInRecommendGuide(sourceType) then
        local score = DataCenter.LWDevelopRecommendManager:GetScoreByPowerSourceType(sourceType)
        if score <= 0.95 then
          local item = self.objItemGuideTemplate.gameObject:GameObjectSpawn(self.objContentGuide.transform)
          item.name = "item" .. i
          local obj = self.objContentGuide:AddComponent(LWDevelopRecommendGuideItem, item.name)
          obj:SetActive(true)
          obj:UpdateAllUI(sourceType)
          count = count + 1
        end
      end
    end
    local hasContent = 0 < count
    self.objTabLayout:SetActive(hasContent)
    if not hasContent then
      self:OnSelectTab(self.TabType.Rate, true)
    end
  end
end

function LWDevelopRecommendView:UpdateRateContent()
  self:UpdateMyTotalPower()
  self.objContentRate:RemoveComponents(LWDevelopRecommendRateItem)
  self.objItemRateTemplate.gameObject:GameObjectRecycleAll()
  local powerTemplate = DataCenter.LWDevelopRecommendManager:GetRecommendPowerConfigTemplate()
  if powerTemplate ~= nil and DataCenter.LWDevelopRecommendManager.devScoreConfigTemplateDict ~= nil then
    for i, template in ipairs(DataCenter.LWDevelopRecommendManager.devScoreConfigTemplateDict) do
      local sourceType = template:GetSourceType()
      if powerTemplate:IsShowInRecommendRate(sourceType) then
        local item = self.objItemRateTemplate.gameObject:GameObjectSpawn(self.objContentRate.transform)
        item.name = "itemRate" .. i
        local obj = self.objContentRate:AddComponent(LWDevelopRecommendRateItem, item.name)
        obj:SetActive(true)
        obj:UpdateAllUI(template)
      end
    end
  end
end

function LWDevelopRecommendView:UpdateMyTotalPower()
  if LuaEntry.Player:IsInAlliance() then
    local allInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    self.textMyName:SetText("[" .. allInfo.abbr .. "]" .. LuaEntry.Player.name)
  else
    self.textMyName:SetText(LuaEntry.Player.name)
  end
  self.textMyPower:SetText(string.GetFormattedSeperatorNum(math.floor(LuaEntry.Player.power)))
  self.textMyLevel:SetText("Lv." .. LuaEntry.Player.level)
  local class = DataCenter.LWDevelopRecommendManager:GetClassByPowerSourceType(PowerOverviewPowerSourceType.playerPower)
  self.imgMyPowerClassSSS:SetActive(class == DataCenter.LWDevelopRecommendManager.Class.SSS)
  self.imgMyPowerClassOther:SetActive(class ~= DataCenter.LWDevelopRecommendManager.Class.SSS)
  if class ~= DataCenter.LWDevelopRecommendManager.Class.SSS then
    self.imgMyPowerClassOther:LoadSprite(DataCenter.LWDevelopRecommendManager:GetClassIconPath(class))
  end
  local mainBuildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  if mainBuildData ~= nil then
    self.imgMyPowerIcon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(mainBuildData.itemId, mainBuildData.level))
  end
  local rankValue = DataCenter.LWDevelopRecommendManager:GetPowerRate(PowerOverviewPowerSourceType.playerPower)
  if 0 < rankValue then
    local str = " <color=#099B4A>" .. tostring(rankValue) .. "%" .. "</color> "
    self.textMyPowerDes:SetLocalText("develop_guide_tip2", str)
  else
    self.textMyPowerDes:SetLocalText("")
  end
end

function LWDevelopRecommendView:UpdateTab()
  for i, v in pairs(self.compTabList) do
    local isSelect = self.curSelectTab == v.tabType
    v.objSelect:SetActive(isSelect)
    v.objUnSelect:SetActive(not isSelect)
    v.text:SetLocalText(self:GetTabLocalText(v.tabType))
  end
end

function LWDevelopRecommendView:GetTabLocalText(tabType)
  if tabType == self.TabType.Guide then
    return "develop_guide_tip4"
  end
  if tabType == self.TabType.Rate then
    return "develop_guide_tip5"
  end
  return ""
end

return LWDevelopRecommendView
