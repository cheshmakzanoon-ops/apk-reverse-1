local UILWHeroTryOutTaskView = BaseClass("UILWHeroTryOutTaskView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWHeroTryOutTaskItemComponent = require("UI.UILWHero.UILWHeroTryOut.UILWHeroTryOutTask.Component.UILWHeroTryOutTaskItemComponent")
local UILWHeroTryOutTaskSubItemComponent = require("UI.UILWHero.UILWHeroTryOut.UILWHeroTryOutTask.Component.UILWHeroTryOutTaskSubItemComponent")
local TASK_ITEM_PREFAB_PATH = "Assets/Main/Prefabs/UI/UIHero/UILWHeroTryOut/UILWHeroTryOutTaskItem.prefab"
local TASK_SUB_ITEM_PREFAB_PATH = "Assets/Main/Prefabs/UI/UIHero/UILWHeroTryOut/UILWHeroTryOutTaskSubItem.prefab"

function UILWHeroTryOutTaskView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UILWHeroTryOutTaskView:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWHeroTryOutTaskView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnUICommonBlackMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnSkip = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnSkip:SetOnClick(function()
    self:OnBtnSkipClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.rawImgNpc = self.viewSkin:AddComponent(self, UIRawImage, 5)
  self.btnLWInfo = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnLWInfo:SetOnClick(function()
    self:OnBtnLWInfoClick()
  end)
  self.compToggleGroup = self.viewSkin:AddComponent(self, UICommonTabGroupGenerator, 7)
  self.textButton = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.textSingleTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textTitle:SetLocalText("herotrial_title_01")
  self.compToggleGroup:SetOnTabChanged(function(index)
    self:OnSelectToggleIndex(index)
  end)
  self.btnSkip:SetSafeClickMode(true)
  self.btnSkip:SetSafeClickModeTime(1)
end

function UILWHeroTryOutTaskView:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.btnUICommonBlackMask = nil
  self.textTitle = nil
  self.btnSkip = nil
  self.btnClose = nil
  self.rawImgNpc = nil
  self.btnLWInfo = nil
  self.compToggleGroup = nil
  self.textButton = nil
  self.compContent = nil
  self.textSingleTitle = nil
end

function UILWHeroTryOutTaskView:DataDefine()
  self.heroId = nil
  self.tryOutHeroData = nil
  self.tagTemplates = nil
  self.curIndex = 0
end

function UILWHeroTryOutTaskView:DataDestroy()
  self.heroId = nil
  self.tryOutHeroData = nil
  self.tagTemplates = nil
  self.curIndex = nil
end

function UILWHeroTryOutTaskView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroTryOutSkipSuccess, self.OnSkipSuccess)
end

function UILWHeroTryOutTaskView:OnRemoveListener()
  self:RemoveUIListener(EventId.HeroTryOutSkipSuccess, self.OnSkipSuccess)
  base.OnRemoveListener(self)
end

function UILWHeroTryOutTaskView:OnOpen()
  local defaultTagId
  self.heroId, defaultTagId = self:GetUserData()
  if self.heroId == nil then
    self.ctrl:CloseSelf()
    return
  end
  self.tryOutHeroData = DataCenter.HeroTryOutManager:GetAllHeroTryOutIdDataByHeroId(self.heroId)
  self.tagTemplates = self.tryOutHeroData:GetAllOpenUnfinishTagTemplates()
  if table.IsNullOrEmpty(self.tagTemplates) then
    self.ctrl:CloseSelf()
    return
  end
  local tagCount = #self.tagTemplates
  local defaultIndex = 0
  self.textSingleTitle:SetActive(tagCount == 1)
  self.compToggleGroup:SetActive(1 < tagCount)
  if tagCount == 1 then
    self.textSingleTitle:SetLocalText(self.tagTemplates[1].tag_key)
  else
    local tagNameList = {}
    for i, v in ipairs(self.tagTemplates) do
      table.insert(tagNameList, Localization:GetString(v.tag_key))
      if defaultTagId ~= nil and v.id == defaultTagId then
        defaultIndex = i - 1
      end
    end
    self.compToggleGroup:GenerateTabs(tagNameList)
    self.compToggleGroup:SelectTab(defaultIndex, true)
  end
  self:OnSelectToggleIndex(defaultIndex)
  self.curIndex = defaultIndex
end

function UILWHeroTryOutTaskView:OnBtnUICommonBlackMaskClick()
  self.ctrl:CloseSelf()
end

function UILWHeroTryOutTaskView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILWHeroTryOutTaskView:OnBtnLWInfoClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("herotrial_desc_09")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function UILWHeroTryOutTaskView:ClearScroll()
  self.compContent:RemoveComponents(UILWHeroTryOutTaskItemComponent)
  self.compContent:RemoveComponents(UILWHeroTryOutTaskSubItemComponent)
  if self.reqs then
    for i, v in pairs(self.reqs) do
      v:Destroy()
    end
    self.reqs = nil
  end
end

function UILWHeroTryOutTaskView:OnSelectToggleIndex(index)
  self:ClearScroll()
  self.reqs = {}
  if self.tryOutHeroData == nil or self.tagTemplates == nil or self.tagTemplates[index + 1] == nil then
    return
  end
  local tagTemplate = self.tagTemplates[index + 1]
  local openTryOutTemplatesInGroup = tagTemplate:GetAllTryOutTemplatesInGroup()
  if tagTemplate:IsShowNewRed() then
    tagTemplate:SetHasShownTag()
    EventManager:GetInstance():Broadcast(EventId.HeroTryOutRedUpdate)
  end
  if not table.IsNullOrEmpty(openTryOutTemplatesInGroup) then
    local openGroupId
    for i, groupData in ipairs(openTryOutTemplatesInGroup) do
      if groupData.groupId == 0 then
        for i, tryOutTemplate in ipairs(groupData.tryOutTemplates) do
          local request = self:GameObjectInstantiateAsync(TASK_ITEM_PREFAB_PATH, function(req)
            if req.isError then
              return
            end
            local item = req.gameObject
            item.name = "task_item" .. i
            item:SetActive(true)
            item.transform:SetParent(self.compContent.transform)
            item.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            local cell = self.compContent:AddComponent(UILWHeroTryOutTaskItemComponent, item.name)
            cell:ReInit(groupData, tagTemplate, tryOutTemplate)
          end)
          table.insert(self.reqs, request)
        end
      else
        local isExpand = false
        if openGroupId == nil and tagTemplate:IsGroupTimeOpenByGroupIndex(groupData.groupIndex) then
          local isFinishedAll = true
          for _, tryOutTemplate in ipairs(groupData.tryOutTemplates) do
            if not tryOutTemplate:IsFinished() then
              isFinishedAll = false
              break
            end
          end
          if not isFinishedAll then
            isExpand = true
            openGroupId = groupData.groupId
          end
        end
        local request = self:GameObjectInstantiateAsync(TASK_SUB_ITEM_PREFAB_PATH, function(req)
          if req.isError then
            return
          end
          local item = req.gameObject
          item.name = "sub_task_item" .. i
          item:SetActive(true)
          item.transform:SetParent(self.compContent.transform)
          item.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          local cell = self.compContent:AddComponent(UILWHeroTryOutTaskSubItemComponent, item.name)
          cell:ReInit(groupData, tagTemplate, isExpand)
        end)
        table.insert(self.reqs, request)
      end
    end
  end
  local isShowSkip = tagTemplate:IsCanSkip()
  self.btnSkip:SetActive(isShowSkip)
  for i, v in ipairs(self.tagTemplates) do
    local isShowTagRed = false
    if v:IsCanSkip() then
      isShowTagRed = true
    else
      isShowTagRed = v:IsShowNewRed() == true and index + 1 ~= i
    end
    self.compToggleGroup:SetTabRedPoint(i - 1, isShowTagRed and 1 or 0)
  end
  self.curIndex = index
end

function UILWHeroTryOutTaskView:OnBtnSkipClick()
  UIUtil.ShowMessage(Localization:GetString("hero_try_out_desc_10"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    if self.tryOutHeroData == nil or self.tagTemplates == nil or self.tagTemplates[self.curIndex + 1] == nil then
      return
    end
    if not self.tagTemplates[self.curIndex + 1]:IsCanSkip() then
      return
    end
    DataCenter.HeroTryOutManager:SendHeroTryOutSkipMessage(self.tagTemplates[self.curIndex + 1].hero_id, self.tagTemplates[self.curIndex + 1].id)
  end)
end

function UILWHeroTryOutTaskView:OnSkipSuccess()
  self:OnSelectToggleIndex(self.curIndex)
end

return UILWHeroTryOutTaskView
