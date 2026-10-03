local UIAllianceStarBookWinnerItem = BaseClass("UIAllianceStarBookWinnerItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICommonHead = require("Framework.UI.Component.UICommonHead")
local UIAllianceStarMainThumbItem = require("UI.UIAllianceStarMain.Component.Thumb.UIAllianceStarMainThumbItem")

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
  self.textAward = self:AddComponent(UIText, "TitleText")
  self.compUIPlayerHead = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.textName = self:AddComponent(UIText, "NameText")
  self.compUIPlayerHead:SetEnableClickShowInfo(true, true)
  self.textScore = self:AddComponent(UITextMeshProUGUIEx, "ScoreText")
  self.compThumbItemPanel = self:AddComponent(UIBaseContainer, "ThumbItemPanel")
  self.thumbItemPool = self.transform:Find("ThumbItemPanel/ThumbItem").gameObject
  self.thumbItemPool:SetActive(false)
  self.thumbItemPool:GameObjectCreatePool()
  self.imgMvp = self:AddComponent(UIImage, "MvpImg")
  self.btnTip = self:AddComponent(UIButton, "TipBtn")
  self.imgMvp:SetActive(false)
  self.btnTip:SetActive(false)
  self.btnTip:SetOnClick(function()
    if self.scoreTipList then
      local param = {}
      param.cfg = self.cfg
      param.preferTop = true
      param.alignObject = self.btnTip
      param.width = 430
      param.yPosFix = -20
      param.showArrow = true
      param.scoreTipList = self.scoreTipList
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceStarBookTip, {anim = true}, param)
    end
  end)
end

local function ComponentDestroy(self)
  self.compThumbItemPanel:RemoveComponents(UIAllianceStarMainThumbItem)
  self.thumbItemPool:GameObjectRecycleAll()
  self.thumbItemPool = nil
  self.textAward = nil
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
  self.scoreTipList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, ceremonyInfo, roleInfo)
  local cfgId = ceremonyInfo.configId
  local template = DataCenter.AllianceStarManager:GetAlStarTemplateInfo(cfgId)
  self.textAward:SetLocalText(template.name)
  self.textName:SetText(roleInfo.name)
  self.compUIPlayerHead:ParseHeadInfo(roleInfo)
  local ownInfo = ceremonyInfo.ceremonyInfoList[1]
  self.textScore:SetText(Localization:GetString(template.content, string.GetFormattedSeparatorNum(ownInfo.score)))
  self:RefreshThumbsPanel(ownInfo.thumbsInfo, ownInfo.selfThumbs)
  self.imgMvp:SetActive(DataCenter.AllianceStarManager:GetIsMvpByConfigId(cfgId))
  if template.scoreTipList and #template.scoreTipList > 0 then
    self.scoreTipList = template.scoreTipList
    self.btnTip:SetActive(true)
  else
    self.btnTip:SetActive(false)
  end
end

local function RefreshThumbsPanel(self, thumbsInfo, selfThumbs)
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
        thumbItem:Refresh(i, num, selfThumbs)
      end
    end
  end
  for i = infoCount + 1, #self.thumbItems do
    self.thumbItems[i]:SetActive(false)
  end
end

UIAllianceStarBookWinnerItem.OnCreate = OnCreate
UIAllianceStarBookWinnerItem.OnDestroy = OnDestroy
UIAllianceStarBookWinnerItem.OnEnable = OnEnable
UIAllianceStarBookWinnerItem.OnDisable = OnDisable
UIAllianceStarBookWinnerItem.ComponentDefine = ComponentDefine
UIAllianceStarBookWinnerItem.ComponentDestroy = ComponentDestroy
UIAllianceStarBookWinnerItem.DataDefine = DataDefine
UIAllianceStarBookWinnerItem.DataDestroy = DataDestroy
UIAllianceStarBookWinnerItem.OnAddListener = OnAddListener
UIAllianceStarBookWinnerItem.OnRemoveListener = OnRemoveListener
UIAllianceStarBookWinnerItem.SetData = SetData
UIAllianceStarBookWinnerItem.RefreshThumbsPanel = RefreshThumbsPanel
return UIAllianceStarBookWinnerItem
