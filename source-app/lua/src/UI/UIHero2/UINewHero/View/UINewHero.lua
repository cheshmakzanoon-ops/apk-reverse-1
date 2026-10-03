local UINewHero = BaseClass("UINewHero", UIBaseView)
local base = UIBaseView
local Resource = CS.GameEntry.Resource
local HeroModelViewer = require("UI.UIHero2.UIHeroInfo.Component.HeroModelViewer")
local UIHeroTagItem = require("UI.UILWHero.UIHeroQualityRecruitReward.Component.UIHeroTagItem")
local UIHeroSpecialItem = require("UI.UILWHero.UIHeroQualityRecruitReward.Component.UIHeroSpecialItem")
local UIHeroQualityIcon = require("UI.UILWHero.UIHeroQualityRecruitReward.Component.UIHeroQualityIcon")

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:OnOpen()
end

local function OnDestroy(self)
  self.camp = nil
  self.tagDescList = nil
  if self.bgModel ~= nil then
    self.bgModel:Destroy()
    self.bgModel = nil
  end
  self:ClearSpecialsAndTags()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  local btnClose = self:AddComponent(UIButton, "Panel")
  btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.modelViewer = self:AddComponent(HeroModelViewer, "RawImage", false, nil, BindCallback(self, self.OnTimeLineEvent))
  self.nodeRoot = self:AddComponent(UIBaseContainer, "Root")
  self.textTip = self:AddComponent(UIText, "Root/NodeCloseTip/TextTip")
  self.textTip:SetLocalText(129074)
  self.heroQualityIcon = self:AddComponent(UIHeroQualityIcon, "Root/NodeHeroInfo/UIHeroQualityIcon")
  self.heroNameText = self:AddComponent(UINewText, "Root/NodeHeroInfo/HeroInfo/TextHeroName")
  self.heroLevelText = self:AddComponent(UINewText, "Root/NodeHeroInfo/HeroInfo/TextHeroLevel")
  self.heroTagList = self:AddComponent(UIBaseContainer, "Root/NodeHeroInfo/TagList")
  self.heroSpecialList = self:AddComponent(UIBaseContainer, "Root/NodeHeroInfo/SpecialList")
  self.anim = self:AddComponent(UISimpleAnimation, "Root")
  self.leftBgEffect = self:AddComponent(UIBaseContainer, "Root/NodeHeroInfo/LeftBg/Eff_ui_hero_zhaomu_texie_zuo")
  self.rightBgEffect = self:AddComponent(UIBaseContainer, "Root/NodeHeroInfo/RightBg/Eff_ui_hero_zhaomu_texie_you")
end

local function DataDefine(self)
  self.specialItems = {}
  self.tagItems = {}
  self.specialReqs = {}
  self.tagReqs = {}
end

local function DataDestroy(self)
  self.specialDataList = nil
  self.tagIds = nil
  self.heroData = nil
end

local function ComponentDestroy(self)
  self.modelViewer = nil
  self.nodeRoot = nil
  self.heroQualityIcon = nil
  self.heroNameText = nil
  self.heroLevelText = nil
  self.heroTagList = nil
  self.heroSpecialList = nil
  self.textTip = nil
  self.anim = nil
  self.leftBgEffect = nil
  self.rightBgEffect = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
  pcall(function()
    CS.SceneManager.World:DisablePostProcess()
  end)
  EventManager:GetInstance():Broadcast(EventId.ToggleRecruitScene, false)
end

local function OnDisable(self)
  pcall(function()
    CS.SceneManager.World:EnablePostProcess()
  end)
  EventManager:GetInstance():Broadcast(EventId.ToggleRecruitScene, true)
  self.active = false
  base.OnDisable(self)
end

local function RefreshHeroInfo(self)
  if self.heroData == nil then
    return
  end
  self.anim:Stop()
  self.anim:Play("Default", 0, 0)
  self.leftBgEffect:SetActive(true)
  self.rightBgEffect:SetActive(true)
  self.heroNameText:SetText(self.heroData:GetName())
  self.heroLevelText:SetText("Lv." .. self.heroData.level)
  self.heroQualityIcon:SetData(self.heroData.quality, true, true)
  self.tagIds = self.heroData.tagIds
  if self.tagIds ~= nil and table.count(self.tagIds) then
    local index = 0
    local tagItemCount = table.count(self.tagItems)
    for k, v in pairs(self.tagIds) do
      if index < tagItemCount then
        self.tagItems[index]:SetData(v)
      else
        local curIndex = index
        local req = Resource:InstantiateAsync(UIAssets.UIHeroTagItem)
        req:completed("+", function()
          if req.isError then
            return
          end
          if not self.gameObject or not self.active then
            req:Destroy()
            return
          end
          CommonUtil.CallAutoArabicMirrorManually(req)
          local go = req.gameObject
          if go == nil then
            return
          end
          go:SetActive(true)
          go.name = "Tag_" .. tostring(k)
          local tf = go.transform
          tf:SetParent(self.heroTagList.transform)
          tf.localScale = Vector3.New(1, 1, 1)
          local item = self.heroTagList:AddComponent(UIHeroTagItem, go)
          item:SetData(v)
          self.tagItems[curIndex] = item
          CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.heroTagList.transform)
          self.tagReqs[k] = req
        end)
      end
      index = index + 1
    end
    local tagDataCount = table.count(self.tagIds)
    if tagItemCount > tagDataCount then
      for i = tagDataCount, tagItemCount do
        self.tagItems[i]:SetData(nil)
      end
    end
  end
  self.specialDataList = self.heroData:GetHeroSpecials()
  local index = 0
  local specialItemCount = table.count(self.specialItems)
  for k, v in pairs(self.specialDataList) do
    if index < specialItemCount then
      self.specialItems[index]:SetData(v)
    else
      local curIndex = index
      local req = Resource:InstantiateAsync(UIAssets.UIHeroSpecialItem)
      req:completed("+", function()
        if req.isError then
          return
        end
        if not self.gameObject or not self.active then
          req:Destroy()
          return
        end
        CommonUtil.CallAutoArabicMirrorManually(req)
        local go = req.gameObject
        if go == nil then
          return
        end
        go:SetActive(true)
        go.name = "Special_" .. tostring(k)
        local tf = go.transform
        tf:SetParent(self.heroSpecialList.transform)
        tf.localScale = Vector3.New(1, 1, 1)
        local item = self.heroSpecialList:AddComponent(UIHeroSpecialItem, go)
        item:SetData(v)
        self.specialItems[curIndex] = item
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.heroSpecialList.transform)
        self.specialReqs[k] = req
      end)
    end
    index = index + 1
  end
  local specialDataCount = table.count(self.specialDataList)
  if specialItemCount > specialDataCount then
    for i = specialDataCount, specialItemCount do
      self.specialItems[i]:SetData(nil)
    end
  end
end

local function OnTimeLineEvent(self, event)
  if event ~= "stop" then
    return
  end
  self:RefreshHeroInfo()
  self.nodeRoot.transform:Set_localScale(1, 1, 1)
end

local function OnOpen(self)
  local heroUuid = self:GetUserData()
  self.heroUuid = heroUuid
  self.heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  self.modelViewer:SetHeroId(self.heroData.heroId, self.heroData.uuid, true)
  self.nodeRoot.transform:Set_localScale(0, 0, 0)
  self.leftBgEffect:SetActive(false)
  self.rightBgEffect:SetActive(false)
end

local function ClearSpecialsAndTags(self)
  self.specialItems = nil
  self.tagItems = nil
  for k, v in pairs(self.specialReqs) do
    v:Destroy()
  end
  for k, v in pairs(self.tagReqs) do
    v:Destroy()
  end
  self.specialReqs = nil
  self.tagReqs = nil
end

UINewHero.OnCreate = OnCreate
UINewHero.OnDestroy = OnDestroy
UINewHero.OnEnable = OnEnable
UINewHero.OnDisable = OnDisable
UINewHero.ComponentDefine = ComponentDefine
UINewHero.ComponentDestroy = ComponentDestroy
UINewHero.DataDefine = DataDefine
UINewHero.DataDestroy = DataDestroy
UINewHero.RefreshHeroInfo = RefreshHeroInfo
UINewHero.OnOpen = OnOpen
UINewHero.OnTimeLineEvent = OnTimeLineEvent
UINewHero.ClearSpecialsAndTags = ClearSpecialsAndTags
return UINewHero
