local UIFishBookView = BaseClass("UIFishBookView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local camp_toggle_list_path = "Content/CampToggleList"
local level_toggle_list_path = "Content/LevelToggleList"
local FishBookItem = require("UI.UIFishing.UIFishBook.FishBookItemComponent")
local CampKey = {
  "season_s6_activity_1200080_title03",
  "season_s6_activity_1200080_title04",
  "s6_fish_npc_camp_name"
}

function UIFishBookView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UIFishBookView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFishBookView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.scrollRectScrollView = self.viewSkin:AddComponent(self, UIScrollRect, 2)
  self.gridInfinityScrollViewContent = self.viewSkin:AddComponent(self, GridInfinityScrollView, 3)
  self.textCampProgress = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textAllProgress = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.btnBag = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnBag:SetOnClick(function()
    self:OnBtnBagClick()
  end)
  self.textButton = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.camp_toggle_list = self:AddComponent(UICommonTabGroupGenerator, camp_toggle_list_path)
  self.camp_toggle_list:SetOnTabChanged(function(index)
    self:OnCampTabChange(index)
  end)
  self.level_toggle_list = self:AddComponent(UICommonTabGroupGenerator, level_toggle_list_path)
  self.level_toggle_list:SetOnTabChanged(function(index)
    self:OnLevelTabChange(index)
  end)
  self.textTitle:SetLocalText("s6_fish_title_2")
  self.textButton:SetLocalText("s6_fish_title_3")
end

function UIFishBookView:ComponentDestroy()
  self:ClearItemCell()
  self.listGO = nil
  self.camp_toggle_list = nil
  self.level_toggle_list = nil
  self.viewSkin = nil
  self.textTitle = nil
  self.scrollRectScrollView = nil
  self.gridInfinityScrollViewContent = nil
  self.textCampProgress = nil
  self.textAllProgress = nil
  self.btnBack = nil
  self.btnBag = nil
  self.textButton = nil
end

function UIFishBookView:DataDefine()
  self.campParam, self.levelParam = self:GetUserData()
  DataCenter.FishingDataManager:FetchPondList(true)
  SFSNetwork.SendMessage(MsgDefines.SeasonFishGetPlayerFishInfo)
end

function UIFishBookView:DataDestroy()
  self.fishIdList = nil
end

function UIFishBookView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshMyFishList, self.RefreshFishList)
end

function UIFishBookView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshMyFishList, self.RefreshFishList)
  base.OnRemoveListener(self)
end

function UIFishBookView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UIFishBookView:OnBtnBagClick()
  DataCenter.LWSoundManager:PlaySound(6100020, false)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFishBag, {anim = true})
end

function UIFishBookView:Init()
  self:ClearItemCell()
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.gridInfinityScrollViewContent:Init(bindFunc1, bindFunc2, bindFunc3)
  local campNames = {}
  for _, v in ipairs(CampKey) do
    table.insert(campNames, Localization:GetString(v))
  end
  self.camp_toggle_list:GenerateTabs(campNames)
  if self.campParam and self.campParam > 0 then
    self.camp_toggle_list:SelectTab(self.campParam - 1, true)
    self.selectCamp = self.campParam
    self.campParam = nil
  else
    self.selectCamp = 1
  end
  self:RefreshLevelList()
end

function UIFishBookView:OnCampTabChange(index)
  DataCenter.LWSoundManager:PlaySound(6100022, false)
  self.selectCamp = index + 1
  self:RefreshLevelList()
end

function UIFishBookView:OnLevelTabChange(index)
  DataCenter.LWSoundManager:PlaySound(6100023, false)
  self.selectLevel = self.levelList[index + 1]
  self:RefreshFishList()
end

function UIFishBookView:RefreshLevelList()
  self.levelList = {0}
  local levelList = DataCenter.FishMetaManager:GetPondLevelList(self.selectCamp)
  local tabNames = {
    Localization:GetString("Desert_strom_tips1036")
  }
  for _, v in ipairs(levelList) do
    table.insert(tabNames, Localization:GetString(140002, v))
    table.insert(self.levelList, v)
  end
  if self.levelParam then
    local levelIndex = table.keyof(self.levelList, self.levelParam)
    if levelIndex then
      self.level_toggle_list:GenerateTabs(tabNames, nil, levelIndex - 1)
      self.selectLevel = self.levelList[levelIndex]
      self.levelParam = nil
    else
      self.level_toggle_list:GenerateTabs(tabNames)
      self.selectLevel = self.levelList[1]
    end
  else
    self.level_toggle_list:GenerateTabs(tabNames)
    self.selectLevel = self.levelList[1]
  end
  self:RefreshFishList()
end

function UIFishBookView:RefreshFishList()
  self.fishIdList = DataCenter.FishMetaManager:GetIdList(self.selectCamp, self.selectLevel)
  self.gridInfinityScrollViewContent:SetItemCount(#self.fishIdList)
  local myFishList = DataCenter.FishingDataManager:GetMyFishList()
  local allCollect = table.count(myFishList)
  local campHashSet = DataCenter.FishMetaManager:GetFishBookHash(self.selectCamp)
  local campCount = DataCenter.FishMetaManager:GetFishBookCount(self.selectCamp)
  local allCount = DataCenter.FishMetaManager:GetFishBookCount(0)
  local campCollect = 0
  for _, v in pairs(myFishList) do
    if campHashSet[v.id] then
      campCollect = campCollect + 1
    end
  end
  local campName = Localization:GetString(CampKey[self.selectCamp])
  self.textCampProgress:SetLocalText("s6_fish_limit_2", campName, campCollect, campCount)
  self.textAllProgress:SetLocalText("s6_fish_limit_3", allCollect, allCount)
end

function UIFishBookView:OnInitScroll(go, index)
  local item = self.scrollRectScrollView:AddComponent(FishBookItem, go)
  item:SetActive(false)
  self.listGO[go] = item
end

function UIFishBookView:OnUpdateScroll(go, index)
  local cellItem = self.listGO[go]
  if cellItem then
    local theIndex = index + 1
    cellItem:SetActive(true)
    cellItem:SetData(theIndex, self.fishIdList[theIndex])
  end
end

function UIFishBookView:OnDestroyScrollItem(go, index)
end

function UIFishBookView:ClearItemCell()
  self.listGO = {}
  self.scrollRectScrollView:SetVerticalNormalizedPosition(1)
  self.scrollRectScrollView:RemoveComponents(FishBookItem)
  self.gridInfinityScrollViewContent:DestroyChildNode()
end

return UIFishBookView
