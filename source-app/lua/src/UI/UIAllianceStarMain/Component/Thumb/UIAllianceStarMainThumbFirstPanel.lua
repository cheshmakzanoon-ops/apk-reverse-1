local UIAllianceStarMainThumbFirstPanel = BaseClass("UIAllianceStarMainThumbFirstPanel", UIBaseContainer)
local UIAllianceStarMainThumbItem = require("UI.UIAllianceStarMain.Component.Thumb.UIAllianceStarMainThumbItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICommonHead = require("Framework.UI.Component.UICommonHead")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.compUIPlayerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.textName = self:AddComponent(UITextMeshProUGUIEx, "NameText")
  self.textScore = self:AddComponent(UITextMeshProUGUIEx, "ScoreText")
  self.compThumbItemPanel = self:AddComponent(UIBaseContainer, "ThumbItemPanel")
  self.compUIPlayerHead:SetEnableClickShowInfo(true, true)
  self.thumbItemPool = self.transform:Find("ThumbItemPanel/ThumbItem").gameObject
  self.thumbItemPool:SetActive(false)
  self.thumbItemPool:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.compThumbItemPanel:RemoveComponents(UIAllianceStarMainThumbItem)
  self.thumbItemPool:GameObjectRecycleAll()
  self.thumbItemPool = nil
  self.compUIPlayerHead = nil
  self.textName = nil
  self.textScore = nil
  self.compThumbItemPanel = nil
end

local function DataDefine(self)
  self.thumbItems = {}
end

local function DataDestroy(self)
  self.thumbItems = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function Refresh(self, ceremonyInfo, roleInfo, score)
  if roleInfo then
    self.textName:SetText(roleInfo.name)
    self.compUIPlayerHead:ParseHeadInfo(roleInfo)
  end
  local starTemplate = ceremonyInfo:GetTemplateInfo()
  self.textScore:SetText(Localization:GetString(starTemplate.content, string.GetFormattedSeparatorNum(score)))
end

local function RefreshThumbsPanel(self, thumbInfo, closeThumb)
  local thumbsInfo = thumbInfo.thumbsInfo
  local infoCount = 0
  if thumbsInfo then
    for i = 1, DataCenter.AllianceStarManager:GetEmojiCount() do
      local num = thumbsInfo[tostring(i)]
      if num and 0 < num then
        infoCount = infoCount + 1
        local thumbItem = self.thumbItems[infoCount]
        if thumbItem == nil then
          local obj = self.thumbItemPool:GameObjectSpawn(self.compThumbItemPanel.transform)
          obj.name = "thumbItem" .. infoCount
          thumbItem = self.compThumbItemPanel:AddComponent(UIAllianceStarMainThumbItem, obj.name)
          self.thumbItems[infoCount] = thumbItem
        end
        thumbItem:SetActive(true)
        thumbItem:Refresh(i, num, thumbInfo.selfThumbs, thumbInfo.uid, thumbInfo.configId, closeThumb)
      end
    end
  end
  for i = infoCount + 1, #self.thumbItems do
    self.thumbItems[i]:SetActive(false)
  end
end

UIAllianceStarMainThumbFirstPanel.OnCreate = OnCreate
UIAllianceStarMainThumbFirstPanel.OnDestroy = OnDestroy
UIAllianceStarMainThumbFirstPanel.OnEnable = OnEnable
UIAllianceStarMainThumbFirstPanel.OnDisable = OnDisable
UIAllianceStarMainThumbFirstPanel.ComponentDefine = ComponentDefine
UIAllianceStarMainThumbFirstPanel.ComponentDestroy = ComponentDestroy
UIAllianceStarMainThumbFirstPanel.DataDefine = DataDefine
UIAllianceStarMainThumbFirstPanel.DataDestroy = DataDestroy
UIAllianceStarMainThumbFirstPanel.OnAddListener = OnAddListener
UIAllianceStarMainThumbFirstPanel.OnRemoveListener = OnRemoveListener
UIAllianceStarMainThumbFirstPanel.Refresh = Refresh
UIAllianceStarMainThumbFirstPanel.RefreshThumbsPanel = RefreshThumbsPanel
return UIAllianceStarMainThumbFirstPanel
