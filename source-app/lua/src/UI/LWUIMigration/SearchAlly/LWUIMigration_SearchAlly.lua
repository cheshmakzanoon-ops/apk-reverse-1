local LWUIMigration_SearchAlly = BaseClass("LWUIMigration_SearchAlly", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UnityImage = typeof(CS.UnityEngine.UI.Image)
local LWUIMigration_AllyTagItem = require("UI.LWUIMigration.AllyRecruitPage.Component.LWUIMigration_AllyTagItem")
local LWUIMigration_DesertTimeSelection = require("UI.LWUIMigration.Component.LWUIMigration_DesertTimeSelection")

function LWUIMigration_SearchAlly:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function LWUIMigration_SearchAlly:OnDestroy()
  self:ClearTagItemReq()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIMigration_SearchAlly:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.compTopContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.compTagContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.compFavorItemTag = self.viewSkin:AddComponent(self, LWUIMigration_AllyTagItem, 6)
  self.compLanguageItemTag = self.viewSkin:AddComponent(self, LWUIMigration_AllyTagItem, 7)
  self.btnDrop = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnDrop:SetOnClick(function()
    self:OnBtnDropClick()
  end)
  self.textTmpTopName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.btnSearch = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnSearch:SetOnClick(function()
    self:OnBtnSearchClick()
  end)
  self.btnReset = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnReset:SetOnClick(function()
    self:OnBtnResetClick()
  end)
  self.btnTag0 = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnTag0:SetOnClick(function()
    self:OnBtnTag0Click()
  end)
  self.btnTag1 = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnTag1:SetOnClick(function()
    self:OnBtnTag1Click()
  end)
  self.btnTag2 = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnTag2:SetOnClick(function()
    self:OnBtnTag2Click()
  end)
  self.imgDrop = self.viewSkin:AddComponent(self, UIImage, 15)
  self.textTmpAllyStarName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.textTmpAllyStarVal = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.btnStar5 = self.viewSkin:AddComponent(self, UIButton, 18)
  self.btnStar5:SetOnClick(function()
    self:OnBtnStar5Click()
  end)
  self.compLWUIMigrationDesertTimeSelection = self.viewSkin:AddComponent(self, LWUIMigration_DesertTimeSelection, 19)
  self.btnStar4 = self.viewSkin:AddComponent(self, UIButton, 20)
  self.btnStar4:SetOnClick(function()
    self:OnBtnStar4Click()
  end)
  self.btnStar3 = self.viewSkin:AddComponent(self, UIButton, 21)
  self.btnStar3:SetOnClick(function()
    self:OnBtnStar3Click()
  end)
  self.btnStar2 = self.viewSkin:AddComponent(self, UIButton, 22)
  self.btnStar2:SetOnClick(function()
    self:OnBtnStar2Click()
  end)
  self.btnStar1 = self.viewSkin:AddComponent(self, UIButton, 23)
  self.btnStar1:SetOnClick(function()
    self:OnBtnStar1Click()
  end)
  self.textTitle:SetLocalText("100192")
  UIUtil.SetTextLit(self.btnReset.transform, "Img/BtnText", "151066")
  UIUtil.SetTextLit(self.btnSearch.transform, "Img/BtnText", "100192")
  self.textTmpAllyStarName:SetLocalText("migration_activity_recommend_limit10_1005")
  self.textTmpTopName:SetLocalText("migration_activity_interface_10152")
  self.callbackOnNormalTagClicked = Bind(self, self.OnCallbackOnNormalTagClicked)
  self.callbackOnFavClicked = Bind(self, self.OnCallbackOnFavClicked)
  self.callbackOnLanClicked = Bind(self, self.OnCallbackOnLanClicked)
  self:InitTags()
  self:HideTags()
  self:InitTopSelection()
  self:RefreshTopSelection()
  self:InitAllyStars()
  self:RefreshAllyStars()
  self.compLWUIMigrationDesertTimeSelection:Init({
    defaultDesertTime = self.filterData and self.filterData.desertTime or 7,
    onClickedCallback = Bind(self, self.OnClickedDesertTime),
    showServerTime = self.filterData.showServerTime
  })
end

function LWUIMigration_SearchAlly:ComponentDestroy()
  self.viewSkin = nil
  self.btnClose = nil
  self.textTitle = nil
  self.btnPanel = nil
  self.compTopContent = nil
  self.compTagContent = nil
  self.compFavorItemTag = nil
  self.compLanguageItemTag = nil
  self.btnDrop = nil
  self.textTmpTopName = nil
  self.btnSearch = nil
  self.btnReset = nil
  self.btnTag0 = nil
  self.btnTag1 = nil
  self.btnTag2 = nil
  self.imgDrop = nil
  self.textTmpAllyStarName = nil
  self.textTmpAllyStarVal = nil
  self.btnStar5 = nil
  self.compLWUIMigrationDesertTimeSelection = nil
  self.btnStar4 = nil
  self.btnStar3 = nil
  self.btnStar2 = nil
  self.btnStar1 = nil
  self.callbackOnNormalTagClicked = nil
  self.callbackOnFavClicked = nil
  self.callbackOnLanClicked = nil
end

function LWUIMigration_SearchAlly:DataDefine()
  local filterData = self:GetUserData() or {}
  self.filterData = DeepCopy(filterData)
  local searchTag = self.filterData.searchTag
  self.searchTagDic = {}
  if searchTag then
    for k, v in ipairs(searchTag) do
      self.searchTagDic[v] = true
    end
  end
end

function LWUIMigration_SearchAlly:DataDestroy()
  self.filterData = nil
  self.searchTagDic = nil
end

function LWUIMigration_SearchAlly:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActMigrationSetAllyTagToggleChanged, self.RefreshTopSelection)
end

function LWUIMigration_SearchAlly:OnRemoveListener()
  self:RemoveUIListener(EventId.ActMigrationSetAllyTagToggleChanged, self.RefreshTopSelection)
  base.OnRemoveListener(self)
end

function LWUIMigration_SearchAlly:InitTopSelection()
  self.topTags = {}
  table.insert(self.topTags, {
    bg = self.btnTag0.transform:Find("Bg"):GetComponent(UnityImage),
    icon = self.btnTag0.transform:Find("Icon"):GetComponent(UnityImage)
  })
  table.insert(self.topTags, {
    bg = self.btnTag1.transform:Find("Bg"):GetComponent(UnityImage),
    icon = self.btnTag1.transform:Find("Icon"):GetComponent(UnityImage)
  })
  table.insert(self.topTags, {
    bg = self.btnTag2.transform:Find("Bg"):GetComponent(UnityImage),
    icon = self.btnTag2.transform:Find("Icon"):GetComponent(UnityImage)
  })
end

function LWUIMigration_SearchAlly:InitTags()
  local tableData = {}
  LocalController:instance():visitTable(TableName.LW_Migration_Alliance_Tag, function(id, lineData)
    local data = {
      id = id,
      searchTag = self.searchTagDic,
      type = ActMigrationAllianceTagType.Normal,
      isOn = self.searchTagDic[id],
      callback = self.callbackOnNormalTagClicked
    }
    table.insert(tableData, data)
  end)
  self:ClearTagItemReq()
  self.normalTags = {}
  for k, v in ipairs(tableData) do
    self.tagItemReq[k] = self:GameObjectInstantiateAsync(UIAssets.UIMigrationAllianceTagItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.compTagContent.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = k
      local cell = self.compTagContent:AddComponent(LWUIMigration_AllyTagItem, go.name)
      cell:SetData(tableData[k])
      table.insert(self.normalTags, cell)
    end)
  end
  self.compFavorItemTag:SetData({
    type = ActMigrationAllianceTagType.Favor,
    isOn = self.filterData and self.filterData.saveTag,
    callback = self.callbackOnFavClicked
  })
  self.compLanguageItemTag:SetData({
    type = ActMigrationAllianceTagType.Language,
    lang = self.filterData.searchLanguageId,
    isOn = self.filterData.saveLang,
    callback = self.callbackOnLanClicked
  })
end

function LWUIMigration_SearchAlly:ResetTags()
  if self.compFavorItemTag then
    self.compFavorItemTag:ResetSelection()
  end
  if self.compLanguageItemTag then
    self.compLanguageItemTag:ResetSelection()
    self.compLanguageItemTag:RefreshLanguage(self.filterData.searchLanguageId)
  end
  for k, v in ipairs(self.normalTags) do
    v:ResetSelection()
  end
  self.filterData.searchTag = {}
  self:RefreshTopSelection()
end

function LWUIMigration_SearchAlly:ShowTags()
  if self.showTags then
    return
  end
  self.showTags = true
  self.compTopContent:SetActive(true)
  self.imgDrop:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_1.png")
end

function LWUIMigration_SearchAlly:HideTags()
  if self.showTags == false then
    return
  end
  self.showTags = false
  self.compTopContent:SetActive(false)
  self.imgDrop:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2.png")
end

function LWUIMigration_SearchAlly:ClearTagItemReq()
  if self.tagItemReq then
    for k, v in ipairs(self.tagItemReq) do
      self:GameObjectDestroy(v)
    end
  end
  self.tagItemReq = {}
  self.normalTags = {}
  self.compTagContent:RemoveComponents(LWUIMigration_AllyTagItem)
end

function LWUIMigration_SearchAlly:RefreshTopSelection()
  if not self.topTags or not self.searchTagDic then
    return
  end
  local selectionIds = {}
  for k, v in pairs(self.searchTagDic) do
    table.insert(selectionIds, k)
  end
  local count = #self.topTags
  for i = 1, count do
    local icon = self.topTags[i].icon
    local bg = self.topTags[i].bg
    local id = selectionIds[i]
    if not id then
      icon.gameObject:SetActive(false)
      bg:LoadSpriteAuto("Assets/Main/Sprites/UI/LWUIMigration/lrb_kuafutongmeng_biaoqiankong.png")
    else
      local iconName = GetTableData(TableName.LW_Migration_Alliance_Tag, id, "icon") or ""
      icon:LoadSpriteAuto(string.format(LoadPath.LWUIMigrationIconPath, iconName))
      local bgName = GetTableData(TableName.LW_Migration_Alliance_Tag, id, "icon_bg") or ""
      bg:LoadSpriteAuto(string.format(LoadPath.LWUIMigrationIconPath, bgName))
      icon.gameObject:SetActive(true)
    end
  end
end

function LWUIMigration_SearchAlly:OnBtnDropClick()
  if not self.showTags then
    self:ShowTags()
  else
    self:HideTags()
  end
end

function LWUIMigration_SearchAlly:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function LWUIMigration_SearchAlly:OnBtnPanelClick()
end

function LWUIMigration_SearchAlly:OnBtnSearchClick()
  if not self.filterData or not self.searchTagDic then
    return
  end
  self.filterData.searchTag = {}
  for k, v in pairs(self.searchTagDic) do
    table.insert(self.filterData.searchTag, k)
  end
  self.filterData.showServerTime = self.compLWUIMigrationDesertTimeSelection and self.compLWUIMigrationDesertTimeSelection:ShowServerTime()
  EventManager:GetInstance():Broadcast(EventId.ActMigrationSetSearchFilter, self.filterData)
  EventManager:GetInstance():Broadcast(EventId.ActMigrationStartSearch)
  self.ctrl:CloseSelf()
end

function LWUIMigration_SearchAlly:InitAllyStars()
  self.stars = {}
  table.insert(self.stars, self.btnStar1.transform:Find("Icon").gameObject)
  table.insert(self.stars, self.btnStar2.transform:Find("Icon").gameObject)
  table.insert(self.stars, self.btnStar3.transform:Find("Icon").gameObject)
  table.insert(self.stars, self.btnStar4.transform:Find("Icon").gameObject)
  table.insert(self.stars, self.btnStar5.transform:Find("Icon").gameObject)
end

function LWUIMigration_SearchAlly:RefreshAllyStars()
  if not self.stars then
    return
  end
  local curStars = self.filterData and self.filterData.stars or 0
  for k, v in ipairs(self.stars) do
    v:SetActive(k <= curStars)
  end
  self.textTmpAllyStarVal:SetText(string.format("%.1f", curStars))
end

function LWUIMigration_SearchAlly:TrySetStar(stars)
  local curStars = self.filterData and self.filterData.stars or 0
  if stars == curStars then
    stars = stars - 1
  end
  self.filterData.stars = Mathf.Clamp(stars, 0, 5)
  self:RefreshAllyStars()
end

function LWUIMigration_SearchAlly:OnBtnStar1Click()
  self:TrySetStar(1)
end

function LWUIMigration_SearchAlly:OnBtnStar2Click()
  self:TrySetStar(2)
end

function LWUIMigration_SearchAlly:OnBtnStar3Click()
  self:TrySetStar(3)
end

function LWUIMigration_SearchAlly:OnBtnStar4Click()
  self:TrySetStar(4)
end

function LWUIMigration_SearchAlly:OnBtnStar5Click()
  self:TrySetStar(5)
end

function LWUIMigration_SearchAlly:OnClickedDesertTime(desertTime)
  if not self.filterData then
    return
  end
  if desertTime == self.filterData.desertTime then
    return
  end
  local newVal = 0
  for i = 1, 3 do
    if desertTime & 1 << i - 1 ~= 0 then
      newVal = newVal | 1 << i - 1
    end
  end
  if newVal & 7 == 0 then
    UIUtil.ShowTipsId("migration_activity_recommend_tips_1001")
    return
  end
  self.filterData.desertTime = newVal
  self:RefreshDesertTimeSelection()
end

function LWUIMigration_SearchAlly:RefreshDesertTimeSelection()
  if self.compLWUIMigrationDesertTimeSelection then
    self.compLWUIMigrationDesertTimeSelection:Refresh(self.filterData.desertTime)
  end
end

function LWUIMigration_SearchAlly:OnCallbackOnLanClicked(idLan, selected)
  if not self.filterData then
    return
  end
  self.filterData.saveLang = selected
  self.filterData.searchLanguageId = idLan
end

function LWUIMigration_SearchAlly:OnCallbackOnFavClicked(selected)
  self.filterData.saveTag = selected
end

function LWUIMigration_SearchAlly:OnCallbackOnNormalTagClicked(id, selected)
  if selected then
    if self.searchTagDic[id] then
      return
    elseif table.count(self.searchTagDic) >= 3 then
      return
    else
      self.searchTagDic[id] = true
    end
  else
    self.searchTagDic[id] = nil
  end
  self:RefreshTopSelection()
end

function LWUIMigration_SearchAlly:OnBtnTag0Click()
  self:ShowTags()
end

function LWUIMigration_SearchAlly:OnBtnTag1Click()
  self:ShowTags()
end

function LWUIMigration_SearchAlly:OnBtnTag2Click()
  self:ShowTags()
end

function LWUIMigration_SearchAlly:OnBtnResetClick()
  self:ResetAll()
end

function LWUIMigration_SearchAlly:ResetAll()
  if self.filterData then
    self.filterData.desertTime = 7
    self.filterData.stars = 0
    self.filterData.saveTag = nil
    self.filterData.searchTag = {}
    self.filterData.saveLang = nil
    self.filterData.searchLanguageId = Localization:GetLanguage()
  end
  if self.searchTagDic then
    table.clear(self.searchTagDic)
  end
  self:ResetTags()
  self:RefreshAllyStars()
  self:RefreshDesertTimeSelection()
end

return LWUIMigration_SearchAlly
