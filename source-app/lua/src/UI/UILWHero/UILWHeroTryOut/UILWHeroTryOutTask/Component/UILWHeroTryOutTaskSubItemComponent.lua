local base = UIBaseContainer
local UILWHeroTryOutTaskSubItemComponent = BaseClass("UILWHeroTryOutTaskSubItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UILWHeroTryOutTaskItemComponent = require("UI.UILWHero.UILWHeroTryOut.UILWHeroTryOutTask.Component.UILWHeroTryOutTaskItemComponent")
local TASK_ITEM_PREFAB_PATH = "Assets/Main/Prefabs/UI/UIHero/UILWHeroTryOut/UILWHeroTryOutTaskItem.prefab"

function UILWHeroTryOutTaskSubItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWHeroTryOutTaskSubItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWHeroTryOutTaskSubItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnArrow = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnArrow:SetOnClick(function()
    self:OnBtnArrowClick()
  end)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.compRedPoint = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.textSubTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compSubContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.compLock = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
end

function UILWHeroTryOutTaskSubItemComponent:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.btnArrow = nil
  self.imgIcon = nil
  self.compRedPoint = nil
  self.textSubTitle = nil
  self.compSubContent = nil
  self.compLock = nil
end

function UILWHeroTryOutTaskSubItemComponent:DataDefine()
  self.groupIndex = 0
  self.isOpen = false
  self.tagTemplate = nil
  self.isExpand = false
end

function UILWHeroTryOutTaskSubItemComponent:DataDestroy()
  self.groupIndex = nil
  self.isOpen = nil
  self.tagTemplate = nil
  self.isExpand = nil
end

function UILWHeroTryOutTaskSubItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWHeroTryOutTaskSubItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWHeroTryOutTaskSubItemComponent:ReInit(groupData, tagTemplate, isExpand)
  if groupData == nil or tagTemplate == nil then
    return
  end
  self.groupIndex = groupData.groupIndex
  self.tagTemplate = tagTemplate
  self.isOpen = tagTemplate:IsGroupTimeOpenByGroupIndex(self.groupIndex)
  self.textSubTitle:SetText(tagTemplate:GetGroupTitleTextByGroupIndex(self.groupIndex))
  if isExpand ~= nil then
    self.isExpand = isExpand
  end
  self.compLock:SetActive(not self.isOpen)
  self.compSubContent:SetActive(self.isExpand)
  if self.isExpand then
    self.imgIcon:LoadSpriteAsync("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_1.png")
  else
    self.imgIcon:LoadSpriteAsync("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_2.png")
  end
  self:ClearScroll()
  self.reqs = {}
  if not table.IsNullOrEmpty(groupData.tryOutTemplates) then
    for i, v in ipairs(groupData.tryOutTemplates) do
      local request = self:GameObjectInstantiateAsync(TASK_ITEM_PREFAB_PATH, function(req)
        if req.isError then
          return
        end
        local item = req.gameObject
        item.name = "task_item" .. i
        item:SetActive(true)
        item.transform:SetParent(self.compSubContent.transform)
        item.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local cell = self.compSubContent:AddComponent(UILWHeroTryOutTaskItemComponent, item.name)
        cell:ReInit(groupData, self.tagTemplate, v)
      end)
      table.insert(self.reqs, request)
    end
  end
end

function UILWHeroTryOutTaskSubItemComponent:Update1000MS()
  if self.tagTemplate == nil then
    return
  end
  if self.isOpen then
    return
  end
  local openTimeStr = self.tagTemplate:GetGroupTitleTextByGroupIndex(self.groupIndex)
  self.textSubTitle:SetText(openTimeStr)
end

function UILWHeroTryOutTaskSubItemComponent:OnBtnArrowClick()
  self.isExpand = not self.isExpand
  if self.isExpand then
    self.imgIcon:LoadSpriteAsync("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_1.png")
  else
    self.imgIcon:LoadSpriteAsync("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_2.png")
  end
  self.compSubContent:SetActive(self.isExpand)
end

function UILWHeroTryOutTaskSubItemComponent:ClearScroll()
  self.compSubContent:RemoveComponents(UILWHeroTryOutTaskItemComponent)
  if self.reqs then
    for i, v in pairs(self.reqs) do
      v:Destroy()
    end
    self.reqs = nil
  end
end

return UILWHeroTryOutTaskSubItemComponent
