local UIPondView = BaseClass("UIPondView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local FishItemSmall = require("UI.UIFishing.UIPond.FishItemSmallComponent")
local PondCell = require("UI.UIFishing.UIPond.PondCellComponent")
local CampKey = {
  "season_s6_activity_1200080_title03",
  "season_s6_activity_1200080_title04",
  "s6_fish_npc_camp_name"
}

function UIPondView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UIPondView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPondView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textFishTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnLWInfo = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnLWInfo:SetOnClick(function()
    self:OnBtnLWInfoClick()
  end)
  self.compFishContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.compCampToggleList = self.viewSkin:AddComponent(self, UICommonTabGroupGenerator, 5)
  self.compLevelToggleList = self.viewSkin:AddComponent(self, UICommonTabGroupGenerator, 6)
  self.textPondTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.gridInfinityScrollViewPondContent = self.viewSkin:AddComponent(self, GridInfinityScrollView, 8)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.btnCommon = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnCommon:SetOnClick(function()
    self:OnBtnCommonClick()
  end)
  self.textButton = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textToggle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.btnToggle = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnToggle:SetOnClick(function()
    self:OnBtnToggleClick()
  end)
  self.textTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.compCheckmark = self.viewSkin:AddComponent(self, UIBaseComponent, 15)
  self.scrollRectPondScrollView = self.viewSkin:AddComponent(self, UIScrollRect, 16)
  self.compFishEmpty = self.viewSkin:AddComponent(self, UIBaseComponent, 17)
  self.compPondEmpty = self.viewSkin:AddComponent(self, UIBaseComponent, 18)
  self.compCampToggleList:SetOnTabChanged(function(index)
    self:OnCompTabChange(index)
  end)
  self.compLevelToggleList:SetOnTabChanged(function(index)
    self:OnLevelTabChange(index)
  end)
  self.btnToggle:SetSafeClickMode(true)
  self.listGO = {}
  local bindFunc1 = BindCallback(self, self.OnInitPondScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdatePondScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyPondScrollItem)
  self.gridInfinityScrollViewPondContent:Init(bindFunc1, bindFunc2, bindFunc3)
  self.textTitle:SetLocalText("s6_fish_title_4")
  self.textFishTitle:SetLocalText("s6_fish_title_5")
  self.textPondTitle:SetLocalText("s6_fish_btn_3")
  self.textButton:SetLocalText("s6_fish_btn_4")
  self.textToggle:SetLocalText("s6_fish_limit_5")
  self.textTip:SetLocalText("s6_fish_limit_4")
end

function UIPondView:ComponentDestroy()
  self.listGO = nil
  self:ClearFishList()
  self:ClearPondList()
  self.viewSkin = nil
  self.textTitle = nil
  self.textFishTitle = nil
  self.btnLWInfo = nil
  self.compFishContent = nil
  self.compCampToggleList = nil
  self.compLevelToggleList = nil
  self.textPondTitle = nil
  self.gridInfinityScrollViewPondContent = nil
  self.btnBack = nil
  self.btnCommon = nil
  self.textButton = nil
  self.textToggle = nil
  self.btnToggle = nil
  self.textTip = nil
  self.compCheckmark = nil
  self.scrollRectPondScrollView = nil
  self.compFishEmpty = nil
  self.compPondEmpty = nil
  self.compCampToggleList = nil
  self.compLevelToggleList = nil
end

function UIPondView:DataDefine()
  self.onlyShowOurPond = true
  self.toggleChange = 0
  DataCenter.FishingDataManager:FetchPondList(self.onlyShowOurPond)
  SFSNetwork.SendMessage(MsgDefines.SeasonFishGetPlayerFishInfo)
end

function UIPondView:DataDestroy()
end

function UIPondView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshFishPondList, self.RefreshFishPondList)
  self:AddUIListener(EventId.RefreshMyFishList, self.RefreshFishList)
end

function UIPondView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshFishPondList, self.RefreshFishPondList)
  self:RemoveUIListener(EventId.RefreshMyFishList, self.RefreshFishList)
  base.OnRemoveListener(self)
end

function UIPondView:RefreshFishPondList(onlyOur)
  if self.onlyShowOurPond ~= onlyOur then
    return
  end
  self:RefreshPondList()
end

function UIPondView:OnBtnToggleClick()
  DataCenter.LWSoundManager:PlaySound(6100021, false)
  self.onlyShowOurPond = not self.onlyShowOurPond
  self.compCheckmark:SetActive(self.onlyShowOurPond)
  self.toggleChange = self.toggleChange + 1
  if self.toggleChange == 1 then
    DataCenter.FishingDataManager:FetchPondList(self.onlyShowOurPond)
  end
  self:RefreshPondList()
end

function UIPondView:OnBtnCommonClick()
  DataCenter.LWSoundManager:PlaySound(6100020, false)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFishBook, {anim = true}, self.selectCamp, self.selectLevel)
end

function UIPondView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UIPondView:OnBtnLWInfoClick()
  DataCenter.LWSoundManager:PlaySound(6100021, false)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFishBook, {anim = true}, self.selectCamp, self.selectLevel)
end

function UIPondView:OnCompTabChange(index)
  DataCenter.LWSoundManager:PlaySound(6100022, false)
  self.selectCamp = index + 1
  Setting:SetPrivateInt("UIPondHistoryCamp", self.selectCamp)
  self:RefreshLevelList()
end

function UIPondView:OnLevelTabChange(index)
  DataCenter.LWSoundManager:PlaySound(6100023, false)
  self.selectLevel = self.levelList[index + 1]
  Setting:SetPrivateInt("UIPondHistoryLevelIndex", index + 1)
  self:RefreshFishList()
  self:RefreshPondList()
end

function UIPondView:RefreshLevelList()
  local levelList = DataCenter.FishMetaManager:GetPondLevelList(self.selectCamp)
  local tabNames = {}
  for _, v in ipairs(levelList) do
    table.insert(tabNames, Localization:GetString(140002, v))
  end
  self.compLevelToggleList:GenerateTabs(tabNames)
  self.levelList = levelList
  if self.historyLevelIndex then
    self.compLevelToggleList:SelectTab(self.historyLevelIndex - 1, true)
    self.compLevelToggleList:ScrollToTab(self.historyLevelIndex - 1)
    self.selectLevel = self.levelList[self.historyLevelIndex]
    self.historyLevelIndex = nil
  else
    self.compLevelToggleList:SelectTab(0, true)
    self.compLevelToggleList:ScrollToTab(0)
    self.selectLevel = self.levelList[1]
    Setting:SetPrivateInt("UIPondHistoryLevelIndex", 1)
  end
  self:RefreshFishList()
  self:RefreshPondList()
end

function UIPondView:Init()
  self.compCheckmark:SetActive(self.onlyShowOurPond)
  local campNames = {}
  for _, v in ipairs(CampKey) do
    table.insert(campNames, Localization:GetString(v))
  end
  self.compCampToggleList:GenerateTabs(campNames)
  self.selectCamp = Setting:GetPrivateInt("UIPondHistoryCamp", DataCenter.SeasonFactionWarDataManager.myCampId)
  self.compCampToggleList:SelectTab(self.selectCamp - 1, true)
  self.historyLevelIndex = Setting:GetPrivateInt("UIPondHistoryLevelIndex", 1)
  self:RefreshLevelList()
end

function UIPondView:RefreshFishList()
  self:ClearFishList()
  local fishIdList = DataCenter.FishMetaManager:GetIdList(self.selectCamp, self.selectLevel)
  for _, id in ipairs(fishIdList) do
    local item = self.compFishContent:LoadComponentAsync(FishItemSmall, "Assets/Main/SeasonRes/S6/Prefabs/UI/Fishing/FishItemSmall.prefab")
    item:SetData(id)
    table.insert(self.fishItems, item)
  end
  self.compFishEmpty:SetActive(#self.fishItems == 0)
end

function UIPondView:ClearFishList()
  if self.fishItems then
    for _, v in pairs(self.fishItems) do
      self.compFishContent:RemoveAsyncComponent(v)
    end
  end
  self.fishItems = {}
end

function UIPondView:RefreshPondList()
  self.pondList = {}
  local pondList = DataCenter.FishingDataManager:GetPondList(self.onlyShowOurPond)
  for _, pond in ipairs(pondList) do
    if pond.cityTemplate == nil then
      pond.cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(pond.pondId)
    end
    local cityTemplate = pond.cityTemplate
    if cityTemplate and cityTemplate.level == self.selectLevel then
      if pond.pondServerId == nil then
        pond.pondServerId = cityTemplate:GetServerIdByEnum(ServerEnum.Source)
      end
      local pondServerId = pond.pondServerId
      if pond.pondCampId == nil then
        pond.pondCampId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(pondServerId)
      end
      if pond.pondCampId == self.selectCamp then
        table.insert(self.pondList, pond)
      end
    end
  end
  self.gridInfinityScrollViewPondContent:SetItemCount(#self.pondList)
  self.compPondEmpty:SetActive(#self.pondList == 0)
end

function UIPondView:OnInitPondScroll(go, index)
  local item = self.scrollRectPondScrollView:AddComponent(PondCell, go)
  item:SetActive(false)
  self.listGO[go] = item
end

function UIPondView:OnUpdatePondScroll(go, index)
  local cellItem = self.listGO[go]
  if cellItem then
    local theIndex = index + 1
    cellItem:SetActive(true)
    if self.pondList[theIndex] == nil then
      Logger.LogError("UIPondView:OnUpdatePondScroll index out of range " .. theIndex)
    end
    cellItem:SetData(self.pondList[theIndex])
  end
end

function UIPondView:OnDestroyPondScrollItem(go, index)
end

function UIPondView:ClearPondList()
  self.scrollRectPondScrollView:SetVerticalNormalizedPosition(1)
  self.scrollRectPondScrollView:RemoveComponents(PondCell)
  self.gridInfinityScrollViewPondContent:DestroyChildNode()
end

return UIPondView
