local base = UIBaseContainer
local UIHeroRecruitPreviewComponent = BaseClass("UIHeroRecruitPreviewComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIHeroRecruitPreviewTagComponent = require("UI/UIHero2/UIHeroRecruit/Component/Preview/UIHeroRecruitPreviewTagComponent")
UIHeroRecruitPreviewComponent.Type = {NextPreview = 1, CurNew = 2}

function UIHeroRecruitPreviewComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIHeroRecruitPreviewComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHeroRecruitPreviewComponent:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "Btn")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.imgBtn = self:AddComponent(UIImage, "Btn")
  self.textTime = self:AddComponent(UIText, "Btn/TimeText")
  self.compNewTag = self:AddComponent(UIBaseContainer, "Btn/NewTag")
  self.textNew = self:AddComponent(UIText, "Btn/NewTag/NewText")
  self.textNew:SetLocalText("vip_new_tip")
  self.compTabTemplate = self:AddComponent(UIHeroRecruitPreviewTagComponent, "TabTemplate")
  self.compTabTemplate.gameObject:GameObjectCreatePool()
  self.compTabTemplate:SetActive(false)
  self.compTabLayout = self:AddComponent(UIBaseContainer, "TabLayout")
  self.blocker = self:AddComponent(UIEventTrigger, "")
  self.blocker:OnBeginDrag(function(eventData)
    self:OnChildBeginDrag(eventData)
  end)
  self.blocker:OnEndDrag(function(eventData)
    self:OnChildEndDrag(eventData)
  end)
  self.blocker:OnDrag(function(eventData)
  end)
end

function UIHeroRecruitPreviewComponent:ComponentDestroy()
  self:ClearTabs()
  self.btn = nil
  self.imgBtn = nil
  self.textTime = nil
  self.compNewTag = nil
  self.textNew = nil
  self.compTabTemplate = nil
  self.compTabLayout = nil
  self.blocker = nil
end

function UIHeroRecruitPreviewComponent:DataDefine()
end

function UIHeroRecruitPreviewComponent:DataDestroy()
end

function UIHeroRecruitPreviewComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroLotteryPreviewEntranceUpdate, self.UpdateContent)
end

function UIHeroRecruitPreviewComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.HeroLotteryPreviewEntranceUpdate, self.UpdateContent)
  base.OnRemoveListener(self)
end

function UIHeroRecruitPreviewComponent:ReInit(lotteryId)
  self.lotteryId = lotteryId
  if not self.lotteryId then
    self.transform.gameObject:SetActive(false)
    return
  end
  self.lotteryInfo = DataCenter.LotteryDataManager:GetLotteryDataById(self.lotteryId)
  if not self.lotteryInfo then
    self.transform.gameObject:SetActive(false)
    return
  end
  self.previewHeroDataList = self.lotteryInfo:GetPreviewInfo()
  if table.IsNullOrEmpty(self.previewHeroDataList) then
    self.transform.gameObject:SetActive(false)
    return
  end
  self.transform.gameObject:SetActive(true)
  self:ClearTabs()
  self.tabList = {}
  for i, v in pairs(self.previewHeroDataList) do
    local item = self.compTabTemplate.gameObject:GameObjectSpawn(self.compTabLayout.transform)
    item.name = tostring(i)
    local obj = self.compTabLayout:AddComponent(UIHeroRecruitPreviewTagComponent, item.name)
    obj:SetActive(true)
    obj:ReInit({
      index = i,
      info = v,
      selectCallback = function()
        self.curShowIndex = i
        self:UpdateContent()
        self:UpdateTabSelect()
      end
    })
    self.tabList[i] = obj
  end
  self.curShowIndex = 1
  self:UpdateContent(false)
  self:UpdateTabSelect()
  for i, v in pairs(self.previewHeroDataList) do
    if v.type == self.Type.CurNew and v.lotteryId then
      DataCenter.LotteryDataManager:SetHasShownNewHero(v.lotteryId)
      EventManager:GetInstance():Broadcast(EventId.HeroLotteryBubbleUpdate)
    end
  end
end

function UIHeroRecruitPreviewComponent:Update1000MS()
  self:UpdateContent(true)
end

function UIHeroRecruitPreviewComponent:UpdateContent(isFromTick)
  if self.curShowIndex == nil or self.previewHeroDataList == nil then
    return
  end
  local heroData = self.previewHeroDataList[self.curShowIndex]
  if heroData == nil then
    return
  end
  if not isFromTick then
    local curShowHeroId = heroData.heroId
    local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(curShowHeroId)
    if heroTemplate then
      local iconPath = HeroUtils.GetHeroIconPath(heroTemplate.appearance, HeroIconType.recruit_preview_icon)
      if not string.IsNullOrEmpty(iconPath) then
        self.imgBtn:LoadSpriteAuto(iconPath)
      end
    end
    self.compNewTag:SetActive(heroData.type == self.Type.CurNew and not DataCenter.LotteryDataManager:IsHasShownNewHeroNewTag(heroData.lotteryId, curShowHeroId))
  end
  self.textTime:SetActive(heroData.startTime ~= nil)
  if heroData.startTime ~= nil then
    local now = UITimeManager:GetInstance():GetServerTime()
    local leftTime = math.max(0, heroData.startTime - now)
    local leftTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    self.textTime:SetText(leftTimeStr)
  end
end

function UIHeroRecruitPreviewComponent:UpdateTabSelect()
  if self.tabList then
    for i, v in pairs(self.tabList) do
      v:UpdateSelect(self.curShowIndex)
    end
  end
end

function UIHeroRecruitPreviewComponent:ClearTabs()
  self.compTabLayout:RemoveComponents(UIHeroRecruitPreviewTagComponent)
  self.compTabTemplate.gameObject:GameObjectRecycleAll()
  self.tabList = nil
end

function UIHeroRecruitPreviewComponent:OnBtnClick()
  if not table.IsNullOrEmpty(self.previewHeroDataList) then
    local param = {
      infoList = self.previewHeroDataList
    }
    if self.curShowIndex then
      param.index = self.curShowIndex
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruitPreview, {anim = false}, param)
  end
end

function UIHeroRecruitPreviewComponent:OnChildBeginDrag(eventData)
  self.lastDragPosX = eventData.position.x
end

function UIHeroRecruitPreviewComponent:OnChildEndDrag(eventData)
  if self.curShowIndex == nil then
    return
  end
  if not self.lastDragPosX then
    return
  end
  if not self.previewHeroDataList then
    return
  end
  local curDragPosX = eventData.position.x
  local offset = curDragPosX - self.lastDragPosX
  if offset < -15 then
    if CommonUtil.IsArabicAutoMirrorOpen() then
      if 1 <= self.curShowIndex - 1 then
        self.curShowIndex = self.curShowIndex - 1
        self:UpdateContent()
        self:UpdateTabSelect()
      end
    elseif self.curShowIndex + 1 <= #self.previewHeroDataList then
      self.curShowIndex = self.curShowIndex + 1
      self:UpdateContent()
      self:UpdateTabSelect()
    end
  elseif 15 < offset then
    if CommonUtil.IsArabicAutoMirrorOpen() then
      if self.curShowIndex + 1 <= #self.previewHeroDataList then
        self.curShowIndex = self.curShowIndex + 1
        self:UpdateContent()
        self:UpdateTabSelect()
      end
    elseif 1 <= self.curShowIndex - 1 then
      self.curShowIndex = self.curShowIndex - 1 * CommonUtil.ArabicAutoMirrorFactor()
      self:UpdateContent()
      self:UpdateTabSelect()
    end
  end
end

return UIHeroRecruitPreviewComponent
