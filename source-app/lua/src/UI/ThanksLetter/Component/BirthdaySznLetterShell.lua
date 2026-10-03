local BirthdaySznLetterShell = BaseClass("BirthdaySznLetterShell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Letter = require("UI.ThanksLetter.Component.ThanksLetterItem")
local BirthdaySznLetterItem = require("UI.ThanksLetter.Component.BirthdaySznLetterItem")
local BirthdayNumContent = require("UI.Birthday.BirthdayDataSetPanel.Component.BirthdayNumContent")
local BirthdayYearNumContent = require("UI.Birthday.BirthdayDataSetPanel.Component.BirthdayYearNumContent")
local mask_area_path = "UnOpenConent/Root/MaskArea"
local open_letter_btn_path = "UnOpenConent/Root/OpenLetterBtn"
local letter_item_point_path = "UnOpenConent/Root/MaskArea/LetterItemPoint"
local birthday_num_content_path = "UnOpenConent/Root/CoverImg/BG1/caidaiImg/BirthdayNumContent"
local root_path = "UnOpenConent/Root"
local birthday_year_num_content_path = "UnOpenConent/Root/CoverImg/BG1/BirthdayYearNumContent"

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
  if self.canvasGroup then
    self.canvasGroup:SetAlpha(0)
  end
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.maskRootObj = self:AddComponent(UIBaseContainer, mask_area_path)
  self.openLetterBtn = self:AddComponent(UIButton, open_letter_btn_path)
  self.openLetterBtn:SetOnClick(function()
    self:OpenLetter()
  end)
  self.letterAni = self:AddComponent(UISimpleAnimation, "")
  self.letterItemPoint = self:AddComponent(UIBaseContainer, letter_item_point_path)
  self.canvasGroup = self:AddComponent(UICanvasGroup, "")
  self.birthday_num_content = self:AddComponent(BirthdayNumContent, birthday_num_content_path)
  self.root = self:AddComponent(UICanvasGroup, root_path)
  self.birthday_year_num_content = self:AddComponent(BirthdayYearNumContent, birthday_year_num_content_path)
end

local function ComponentDestroy(self)
  if self.letterPrefabReq then
    self.letterPrefabReq:Destroy()
    self.letterPrefabReq = nil
  end
  self:StopAllTimer()
  self.birthday_num_content = nil
  self.root = nil
  self.birthday_year_num_content = nil
end

local function DataDefine(self)
  self.isCompleteExpand = false
end

local function DataDestroy(self)
  self.isCompleteExpand = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function BirthdaySznLetterShell:SetData(uuid, itemId, templateData, serverData, closeFunc)
  self:StopAllTimer()
  if not templateData then
    return
  end
  local letterContentPrefab = templateData.letter_content_prefab
  if string.IsNullOrEmpty(letterContentPrefab) then
    return
  end
  self.root:SetActive(false)
  self.letterPrefabReq = self:GameObjectInstantiateAsync(letterContentPrefab, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.letterItemPoint.transform)
    go.transform:Set_localPosition(0, 0, 0)
    go.transform:Set_localScale(1, 1, 1)
    local prefabName = "LetterItem"
    go.transform.name = prefabName
    local targetComponent = Letter
    if templateData.letter_content_type == LetterContentType.SznDateBirthday then
      targetComponent = BirthdaySznLetterItem
    end
    self.letterItem = self:AddComponent(targetComponent, string.format("%s/%s", letter_item_point_path, prefabName))
    self.letterItem:SetData(uuid, itemId, templateData, serverData, closeFunc)
    self.root:SetActive(true)
    self.letterAni:Stop()
    local ret, time = self.letterAni:PlayAnimationReturnTime("FadeIn")
    if ret then
      self.shellIdleTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.shellIdleTimer = nil
        self.letterAni:Play("Idle")
      end, time)
    end
  end)
  self.openLetterBtn:SetActive(true)
  local birthdayStr = serverData.birthday
  if not string.IsNullOrEmpty(birthdayStr) then
    local numArr = string.string2array_i_oneSep(birthdayStr, "-")
    if #numArr == 2 then
      self.birthday_num_content:SetActive(true)
      local sznType = DataCenter.BirthdayDataManager:GetSznTypeByMonth(numArr[1])
      self.birthday_num_content:SetData(numArr[1], numArr[2], sznType)
      self.birthday_year_num_content:SetData(serverData.receiveYear, sznType)
    else
      self.birthday_num_content:SetActive(false)
    end
  else
    self.birthday_num_content:SetActive(false)
  end
end

function BirthdaySznLetterShell:OpenLetter()
  if self.shellIdleTimer then
    self.shellIdleTimer:Stop()
    self.shellIdleTimer = nil
  end
  self.isCompleteExpand = false
  if not self.letterItem or not self.letterItem:isBannerLoadFinish() then
    return
  end
  local ret, time = self.letterAni:PlayAnimationReturnTime("Open")
  if ret then
    self.expandTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.isCompleteExpand = true
      self.expandTimer = nil
    end, time)
  else
    self.isCompleteExpand = true
  end
  if self.letterItem then
    self.letterItem:OnPlay()
  end
  self.openLetterBtn:SetActive(false)
end

function BirthdaySznLetterShell:PlayCloseAniAndGetAniTime()
  if not self.letterItem then
    return
  end
  return self.letterItem:PlayCloseAniAndGetAniTime()
end

function BirthdaySznLetterShell:StopAllTimer()
  if self.expandTimer then
    self.expandTimer:Stop()
    self.expandTimer = nil
  end
  if self.shellIdleTimer then
    self.shellIdleTimer:Stop()
    self.shellIdleTimer = nil
  end
end

BirthdaySznLetterShell.OnCreate = OnCreate
BirthdaySznLetterShell.OnDestroy = OnDestroy
BirthdaySznLetterShell.OnEnable = OnEnable
BirthdaySznLetterShell.OnDisable = OnDisable
BirthdaySznLetterShell.ComponentDefine = ComponentDefine
BirthdaySznLetterShell.ComponentDestroy = ComponentDestroy
BirthdaySznLetterShell.DataDefine = DataDefine
BirthdaySznLetterShell.DataDestroy = DataDestroy
BirthdaySznLetterShell.OnAddListener = OnAddListener
BirthdaySznLetterShell.OnRemoveListener = OnRemoveListener
return BirthdaySznLetterShell
