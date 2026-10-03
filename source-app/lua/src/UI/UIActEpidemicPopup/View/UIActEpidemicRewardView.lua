local UIActEpidemicRewardView = BaseClass("UIActEpidemicRewardView", UIBaseView)
local UIActEpidemicRewardViewToggle = require("UI.UIActEpidemicPopup.Component.UIActEpidemicRewardViewToggleItemRenderer")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshTopTabs()
  self:RefreshView()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RequestPlayerInfo()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.toggleScrollView = self.viewSkin:AddComponent(self, UIScrollView, 3)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.compSheets = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.btnBottom = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnBottom:SetOnClick(function()
    self:OnBtnBottomClick()
  end)
  self.textBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textTmpBtnNotice = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textTmpBottomNotice = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.compLargeBg = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.compSmallBg = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.compImgCurrent = self.viewSkin:AddComponent(self, UIBaseComponent, 13)
  self.imgTypeIcon = self.viewSkin:AddComponent(self, UIImage, 14)
  self.textTmpRole = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.compNotice = self.viewSkin:AddComponent(self, UIBaseComponent, 16)
  self.textTmpBtnNotice:SetAsFirstSibling()
  self.btnBottom:SetAsFirstSibling()
  self.toggleScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.toggleScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.textTitle:SetLocalText("YiBianJinQu_reward_tips_1")
  UIUtil.SetTextLit(self.compImgCurrent.transform, "label", "YiBianJinQu_reward_tips_3")
  self.currentRole = self:GetDefaultRole()
end

local function ComponentDestroy(self)
  self.viewSkin = nil
  self.textTitle = nil
  self.btnClose = nil
  self.toggleScrollView = nil
  self.compContent = nil
  self.compSheets = nil
  self.btnBottom = nil
  self.textBtn = nil
  self.textTmpBtnNotice = nil
  self.textTmpBottomNotice = nil
  self.compLargeBg = nil
  self.compSmallBg = nil
  self.btnPanel = nil
  self.compImgCurrent = nil
  self.imgTypeIcon = nil
  self.textTmpRole = nil
  self.compNotice = nil
end

function UIActEpidemicRewardView:OnItemMoveIn(itemObj, index)
  itemObj.name = string.format("UIActEpidemicRewardViewToggleItemRenderer_%s", index)
  local cellItem = self.toggleScrollView:AddComponent(UIActEpidemicRewardViewToggle, itemObj)
  cellItem:SetData(index, self.tabDataList[index], self)
  self.tabCells[index] = cellItem
end

function UIActEpidemicRewardView:GetDefaultRole()
  local role = ActEpidemicUtils.GetMyRole()
  if role == EpidemicZoneRole.Default then
    return EpidemicZoneRole.Lord
  end
  return role
end

function UIActEpidemicRewardView:OnToggleClicked(index)
  if not self.tabCells then
    return
  end
  if index == self.currentIndex then
    return
  end
  self.currentIndex = index
  self:RefreshTabCells()
  self:RefreshSheets()
  self:RefreshBottom()
end

function UIActEpidemicRewardView:OnItemMoveOut(itemObj, index)
  self.toggleScrollView:RemoveComponent(itemObj.name, UIActEpidemicRewardViewToggle)
  self.tabCells[index] = nil
end

function UIActEpidemicRewardView:ClearScroll()
  if self.toggleScrollView then
    self.toggleScrollView:ClearCells()
    self.toggleScrollView:RemoveComponents(UIActEpidemicRewardViewToggle)
  end
  self.tabCells = {}
end

function UIActEpidemicRewardView:RefreshTabCells()
  for k, v in pairs(self.tabCells) do
    v:SetSelection(self.currentIndex)
  end
end

local _MyPick

function UIActEpidemicRewardView:GetMyPickStr()
  if self.currentRole ~= ActEpidemicUtils.GetMyRole() then
    return ""
  end
  if not _MyPick then
    _MyPick = Localization:GetString("YiBianJinQu_trivial_tips_25")
  end
  return _MyPick
end

function UIActEpidemicRewardView:RefreshBottom()
  self.compImgCurrent:SetActive(false)
  if self.currentIndex == 2 then
    self.textTmpBottomNotice:SetActive(false)
    self.textTmpBtnNotice:SetActive(false)
    self.btnBottom:SetActive(false)
    self.compLargeBg:SetActive(true)
    self.compSmallBg:SetActive(false)
    self.compNotice:SetActive(false)
  elseif self.currentIndex == 1 then
    self.textBtn:SetLocalText("YiBianJinQu_reward_tips_11")
    self.textTmpBottomNotice:SetActive(false)
    self.btnBottom:SetActive(true)
    self.compLargeBg:SetActive(false)
    self.compSmallBg:SetActive(true)
    self:RefreshRoleNotice()
  elseif self.currentIndex == 3 then
    self.textBtn:SetLocalText("YiBianJinQu_reward_tips_11")
    self.textTmpBottomNotice:SetActive(false)
    self.btnBottom:SetActive(true)
    self.compLargeBg:SetActive(false)
    self.compSmallBg:SetActive(true)
    self:RefreshRoleNotice()
  end
end

function UIActEpidemicRewardView:RefreshRoleNotice()
  self.compNotice:SetActive(true)
  local noticeText = string.format("%s%s", ActEpidemicUtils.GetRoleNameByRoleId(self.currentRole), self:GetMyPickStr())
  self.textTmpBtnNotice:SetLocalText("YiBianJinQu_reward_tips_10", "")
  self.textTmpRole:SetText(noticeText)
  self.imgTypeIcon:LoadSprite(string.format(LoadPath.LWBattleFieldEpidemicPath, self.currentRole == EpidemicZoneRole.Lord and "mjc_YBJQ_zhenying_icon_s1" or "mjc_YBJQ_zhenying_icon_s2"))
end

function UIActEpidemicRewardView:RefreshSheets()
  if not self.sheets then
    return
  end
  if not self.sheets[self.currentIndex] then
    local tabData = self.tabDataList[self.currentIndex]
    if not tabData then
      return
    end
    local lua = tabData.lua
    local prefab = tabData.prefab
    self.sheets[self.currentIndex] = self:LoadComponentAsync(lua, prefab, self.compSheets.gameObject, function()
      self:RefreshSheets()
    end, nil, self)
    return
  end
  for k, v in pairs(self.sheets) do
    if v then
      v:SetActive(k == self.currentIndex)
      if k == self.currentIndex then
        v:RefreshSheet(self.currentRole)
      end
    end
  end
end

function UIActEpidemicRewardView:RefreshTopTabs()
  if #self.tabDataList > 0 then
    self.toggleScrollView:SetTotalCount(#self.tabDataList)
    self.toggleScrollView:RefillCells()
  end
  if self.currentIndex == nil then
    self.currentIndex = self:GetUserData() or 1
    self:RefreshTabCells()
    self:RefreshSheets()
    self:RefreshBottom()
  end
end

function UIActEpidemicRewardView:RefreshView()
end

local function DataDefine(self)
  self.tabCells = self.tabCells or {}
  self.sheets = self.sheets or {}
  if self.tabDataList == nil then
    self.tabDataList = self.ctrl:GetTabs()
  end
end

local function DataDestroy(self)
  self.sheets = nil
  self.tabCells = nil
  self:ClearScroll()
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
end

function UIActEpidemicRewardView:OnBtnBottomClick()
  self.currentRole = self.currentRole == EpidemicZoneRole.Lord and EpidemicZoneRole.Farmer or EpidemicZoneRole.Lord
  self:RefreshBottom()
  for k, v in pairs(self.sheets) do
    if v and k == self.currentIndex then
      v:RefreshCurrentRole(self.currentRole)
    else
      v:UpdateCurrentRole(self.currentRole)
    end
  end
end

function UIActEpidemicRewardView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIActEpidemicRewardView:RequestPlayerInfo()
  if DataCenter.ActEpidemicZoneManager:CanShowEnter() then
    DataCenter.ActEpidemicZoneManager:RequestActivityPlayerInfo()
  end
end

UIActEpidemicRewardView.OnCreate = OnCreate
UIActEpidemicRewardView.OnDestroy = OnDestroy
UIActEpidemicRewardView.OnEnable = OnEnable
UIActEpidemicRewardView.OnDisable = OnDisable
UIActEpidemicRewardView.ComponentDefine = ComponentDefine
UIActEpidemicRewardView.ComponentDestroy = ComponentDestroy
UIActEpidemicRewardView.DataDefine = DataDefine
UIActEpidemicRewardView.DataDestroy = DataDestroy
UIActEpidemicRewardView.OnAddListener = OnAddListener
UIActEpidemicRewardView.OnRemoveListener = OnRemoveListener
UIActEpidemicRewardView.OnBtnCloseClick = OnBtnCloseClick
return UIActEpidemicRewardView
