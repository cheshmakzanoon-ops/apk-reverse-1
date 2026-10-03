local LWUIActEasterAnonymousEditView = BaseClass("LWUIActEasterAnonymousEditView", UIBaseView)
local LWUIActEasterAnonymousAvatarNode = require("UI.LWUIActEasterEgg.LWUIActEasterAnonymousEdit.Component.LWUIActEasterAnonymousAvatarNode")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local M = LWUIActEasterAnonymousEditView

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function M:OnDestroy()
  EventManager:GetInstance():Broadcast(EventId.EasterEggChatOnClickZone)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.imgCurAvatar = self:AddComponent(UIImage, "Bg/CurAvatarImage")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Bg/Title")
  self.btnRandomName = self:AddComponent(UIButton, "Bg/RandomNameBtn")
  self.btnRandomName:SetOnClick(function()
    self:OnBtnRandomNameClick()
  end)
  self.loopGridViewHeroAvatar = self:AddComponent(UILoopGridView, "Bg/AvatarNode/HeroAvatar")
  self.compContent = self:AddComponent(UIBaseContainer, "Bg/AvatarNode/HeroAvatar/Viewport/Content")
  self.btnUse = self:AddComponent(UIButton, "Bg/UseBtn")
  self.btnUse:SetOnClick(function()
    self:OnBtnUseClick()
  end)
  self.textCurName = self:AddComponent(UITextMeshProUGUIEx, "Bg/NameNode/CurNameText")
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btnLWClose = self:AddComponent(UIButton, "Bg/LW_Btn_Close")
  self.btnLWClose:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.textBtn = self:AddComponent(UITextMeshProUGUIEx, "Bg/UseBtn/LW_Btn_Common_New_Base/BtnText")
  self.textAvatar = self:AddComponent(UITextMeshProUGUIEx, "Bg/AvatarText")
  self.textTitle:SetLocalText("activity_99144_ui_40")
  self.textBtn:SetLocalText("activity_99144_ui_42")
  self.textAvatar:SetLocalText("activity_99144_ui_41")
  self.loopGridViewHeroAvatar:InitGridView(0, function(loopScroll, index, item)
    return self:OnGetItemByRowColumn(loopScroll, index)
  end)
end

function M:ComponentDestroy()
  if self.compContent then
    self.compContent:RemoveComponents(LWUIActEasterAnonymousAvatarNode)
  end
  if self.loopGridViewHeroAvatar then
    self.loopGridViewHeroAvatar:ClearAllItems()
  end
  self.imgCurAvatar = nil
  self.textTitle = nil
  self.btnRandomName = nil
  self.loopGridViewHeroAvatar = nil
  self.compContent = nil
  self.btnUse = nil
  self.compLWUIActEasterAnonymousAvatarNode = nil
  self.textCurName = nil
  self.btnPanel = nil
  self.btnLWClose = nil
  self.textBtn = nil
  self.textAvatar = nil
end

function M:DataDefine()
  self.headList = {}
  self.selectHeadIndex = nil
end

function M:DataDestroy()
  self.headList = nil
  self.selectHeadIndex = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EasterEggGetActivitySelectAnonymousAvatar, self.OnRecSelectAvatar)
  self:AddUIListener(EventId.EasterEggGetActivityUpdateAnonymousName, self.RefreshName)
  self:AddUIListener(EventId.EasterEggGetActivityUpdateAnonymousHead, self.OnRecChangeAvatar)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.EasterEggGetActivitySelectAnonymousAvatar, self.OnRecSelectAvatar)
  self:RemoveUIListener(EventId.EasterEggGetActivityUpdateAnonymousName, self.RefreshName)
  self:RemoveUIListener(EventId.EasterEggGetActivityUpdateAnonymousHead, self.OnRecChangeAvatar)
end

function M:OnBtnRandomNameClick()
  local activityData = DataCenter.ActEasterEggManager:GetActivityData()
  local state = activityData.anonymousState
  self.ctrl:RequestChangeAnonymous(state, self.selectHeadIndex, ActEasterAnonymousRequestType.RequestRandomName)
end

function M:OnBtnUseClick()
  local activityData = DataCenter.ActEasterEggManager:GetActivityData()
  local state = activityData.anonymousState
  self.ctrl:RequestChangeAnonymous(state, self.selectHeadIndex, ActEasterAnonymousRequestType.RequestSetAnonymousAvatar)
  self.ctrl:CloseSelf()
end

function M:InitView()
  self.headList = {}
  local configData = DataCenter.ActEasterEggManager:GetEggConfigData()
  self.headList = configData and configData.heroHeadList
  self:RefreshName()
  self:RefreshAvatar()
  self:InitAvatarScroll()
end

function M:InitAvatarScroll()
  local length = table.count(self.headList)
  self.loopGridViewHeroAvatar:SetListItemCount(length)
  self.loopGridViewHeroAvatar:RefreshAllShownItem()
end

function M:OnGetItemByRowColumn(loopScroll, index)
  if self.headList ~= nil then
    local count = #self.headList
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    local item = loopScroll:NewListViewItem("LWUIActEasterAnonymousAvatarNode")
    local script = self.compContent:GetComponent(item.gameObject.name, LWUIActEasterAnonymousAvatarNode)
    if script == nil then
      local name = "heroAvatar" .. UIUtil.GetLoopListItemIndex()
      item.gameObject.name = name
      script = self.compContent:AddComponent(LWUIActEasterAnonymousAvatarNode, name)
    end
    script:SetActive(true)
    local headId = self.headList[index]
    script:SetHeadImage(index, headId, self.selectHeadIndex, self.ctrl)
    return item
  end
end

function M:RefreshName()
  local activityData = DataCenter.ActEasterEggManager:GetActivityData()
  if activityData and activityData.anonymousName then
    local name = activityData.anonymousName
    local showName = DataCenter.ActEasterEggManager:GetTranslateName(name)
    self.textCurName:SetText(showName)
  end
end

function M:OnRecChangeAvatar()
  self:RefreshAvatar()
end

function M:RefreshAvatar()
  local activityData = DataCenter.ActEasterEggManager:GetActivityData()
  if activityData and activityData.anonymousHeadId then
    local iconPath = HeroUtils.GetHeroIconPath(activityData.anonymousHeadId)
    self.imgCurAvatar:LoadSpriteAuto(iconPath)
    local headIndex = 1
    for k, v in pairs(self.headList) do
      if v == activityData.anonymousHeadId then
        headIndex = k
        break
      end
    end
    self.ctrl:SetCurSelectHeadIndex(headIndex)
    self.selectHeadIndex = headIndex
  end
end

function M:OnRecSelectAvatar()
  local headIndex = self.ctrl:GetCurSelectHeadIndex()
  self.selectHeadIndex = headIndex
  self.ctrl:SetCurSelectHeadIndex(headIndex)
  local headIcon = ""
  if self.headList and self.headList[headIndex] then
    headIcon = self.headList[headIndex]
  end
  local iconPath = HeroUtils.GetHeroIconPath(headIcon)
  self.imgCurAvatar:LoadSpriteAuto(iconPath)
end

return LWUIActEasterAnonymousEditView
