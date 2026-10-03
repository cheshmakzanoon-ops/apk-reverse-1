local UIHeroRecruitWishView = BaseClass("UIHeroRecruitWishView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local UIHeroRecruitWishComponent = require("UI/UIHero2/UIHeroRecruitWish/Component/UIHeroRecruitWishComponent")

function UIHeroRecruitWishView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UIHeroRecruitWishView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHeroRecruitWishView:ComponentDefine()
  self.anim = self:AddComponent(UIAnimator, "")
  self.btnPanel = self:AddComponent(UIButton, "Panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.compSpineRoot = self:AddComponent(UIBaseContainer, "MainContent/SpineView/SpineRoot")
  self.imgQualityIcon = self:AddComponent(UIImage, "MainContent/QualityIcon")
  self.imgHeroTypeIcon = self:AddComponent(UIImage, "MainContent/HeroTypeIcon")
  self.btnHeroTypeIcon = self:AddComponent(UIButton, "MainContent/HeroTypeIcon")
  self.btnHeroTypeIcon:SetOnClick(function()
    self:OnBtnHeroTypeIconClick()
  end)
  self.imgHeroJobIcon = self:AddComponent(UIImage, "MainContent/HeroJobIcon")
  self.btnHeroJobIcon = self:AddComponent(UIButton, "MainContent/HeroJobIcon")
  self.btnHeroJobIcon:SetOnClick(function()
    self:OnBtnHeroJobIconClick()
  end)
  self.btnInfo = self:AddComponent(UIButton, "MainContent/InfoBtn")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.textInfo = self:AddComponent(UIText, "MainContent/InfoBtn/InfoText")
  self.btnClose = self:AddComponent(UIButton, "MainContent/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textName = self:AddComponent(UIText, "MainContent/NameText")
  self.textDes = self:AddComponent(UIText, "MainContent/DesText")
  self.compHeroItem = self:AddComponent(UIHeroRecruitWishComponent, "MainContent/HeroItem")
  self.compHeroItem.gameObject:GameObjectCreatePool()
  self.compHeroItem:SetActive(false)
  self.compScroll = self:AddComponent(UIScrollRect, "MainContent/SkillContent/ScrollRect")
  self.compContent = self:AddComponent(UIBaseContainer, "MainContent/SkillContent/ScrollRect/Viewport/Content")
  self.textTips = self:AddComponent(UIText, "MainContent/TipsText")
  self.btnConfirm = self:AddComponent(UIButton, "MainContent/ConfirmBtn")
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.textBtn = self:AddComponent(UIText, "MainContent/ConfirmBtn/Btn/BtnText")
  self.textBtn:SetText(Localization:GetString("herorecruit_select_desc3"))
end

function UIHeroRecruitWishView:ComponentDestroy()
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
  self.anim = nil
  self.btnPanel = nil
  self.compSpineRoot = nil
  self.imgQualityIcon = nil
  self.imgHeroTypeIcon = nil
  self.btnHeroTypeIcon = nil
  self.imgHeroJobIcon = nil
  self.btnHeroJobIcon = nil
  self.btnInfo = nil
  self.btnClose = nil
  self.textName = nil
  self.textDes = nil
  self.compHeroItem = nil
  self.compContent = nil
  self.compScroll = nil
  self.textTips = nil
  self.btnConfirm = nil
  self.textBtn = nil
end

function UIHeroRecruitWishView:DataDefine()
  self.isClosing = false
end

function UIHeroRecruitWishView:DataDestroy()
end

function UIHeroRecruitWishView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroLotterySwitchWishSuccess, self.OnSwitchSuccess)
end

function UIHeroRecruitWishView:OnRemoveListener()
  self:RemoveUIListener(EventId.HeroLotterySwitchWishSuccess, self.OnSwitchSuccess)
  base.OnRemoveListener(self)
end

function UIHeroRecruitWishView:OnOpen()
  self.lotteryId = self:GetUserData()
  if self.lotteryId == nil then
    self.ctrl:CloseSelf()
    return
  end
  self.lotteryInfo = DataCenter.LotteryDataManager:GetLotteryDataById(self.lotteryId)
  if self.lotteryInfo == nil then
    self.ctrl:CloseSelf()
    return
  end
  self.wishList = self.lotteryInfo.wishList
  if table.IsNullOrEmpty(self.wishList) then
    self.ctrl:CloseSelf()
    return
  end
  self:InitCurSelect()
  self:ClearItems()
  self.itemList = {}
  local curIndex = 0
  local curHeroId = self.ctrl:GetFakeCurSelectHeroId(self.lotteryId)
  for i, v in pairs(self.wishList) do
    local item = self.compHeroItem.gameObject:GameObjectSpawn(self.compContent.transform)
    item.name = tostring(i)
    local obj = self.compContent:AddComponent(UIHeroRecruitWishComponent, item.name)
    obj:SetActive(true)
    obj:ReInit(v, self.lotteryId)
    self.itemList[i] = obj
    if v == curHeroId then
      curIndex = i
    end
  end
  if 4 < curIndex then
    local wishCount = table.count(self.wishList)
    if 1 < wishCount then
      local posX = (curIndex - 1) / (wishCount - 1)
      self.compScroll:SetHorizontalNormalizedPosition(posX)
    end
  end
  self:UpdateMainContent()
  self.anim:Play("Eff_UIHeroRecruitWish_In")
  PostEventLog.Track(PostEventLog.Defines.HeroRecruitWishOpen, {
    lotteryId = self.lotteryId
  })
end

function UIHeroRecruitWishView:ClearItems()
  self.compContent:RemoveComponents(UIHeroRecruitWishComponent)
  self.compHeroItem.gameObject:GameObjectRecycleAll()
  self.itemList = nil
end

function UIHeroRecruitWishView:InitCurSelect()
  if self.ctrl:GetFakeCurSelectHeroId(self.lotteryId) == nil then
    self.ctrl:SetFakeCurSelectHeroId(self.lotteryId, self.wishList[1])
  end
end

function UIHeroRecruitWishView:UpdateMainContent()
  local curSelectHeroId = self.ctrl:GetFakeCurSelectHeroId(self.lotteryId)
  if not curSelectHeroId then
    return
  end
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(curSelectHeroId)
  if heroTemplate then
    local quality = heroTemplate.quality
    self.imgQualityIcon:LoadSprite(HeroUtils.GetHeroQualityTagImg(quality))
    self.imgQualityIcon:SetNativeSize()
    local heroName = Localization:GetString(heroTemplate.name)
    self.textName:SetText(heroName)
    self.textDes:SetText(heroTemplate:GetDescription())
    self.imgHeroTypeIcon:LoadSprite(HeroUtils.GetHeroTypeIcon(heroTemplate.type))
    self.imgHeroTypeIcon:SetNativeSize()
    self.imgHeroJobIcon:LoadSprite(HeroUtils.GetHeroJobIcon(heroTemplate.job, 2))
    local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(heroTemplate.appearance)
    local spinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
    local request = ResourceManager:InstantiateAsync(spinePath)
    self.heroSpineLoadRequest = request
    request:completed("+", function()
      if request.isError or IsNull(request.gameObject) then
        request:Destroy()
        self.heroSpineLoadRequest = nil
        return
      end
      local obj = request.gameObject
      obj:SetActive(true)
      obj.transform:SetParent(self.compSpineRoot.transform)
      obj.transform.localPosition = Vector3.New(0, 0, 0)
      obj.transform.localScale = Vector3.New(1, 1, 1)
    end)
    local heroInfo = DataCenter.HeroDataManager:GetHeroByHeroId(curSelectHeroId)
    if heroInfo ~= nil and heroInfo:IsReachMaxRank() then
      self.textTips:SetText(Localization:GetString("herorecruit_select_desc2", Localization:GetString(HeroUtils.GetHeroNameByConfigId(curSelectHeroId))))
    else
      self.textTips:SetText(Localization:GetString("herorecruit_select_desc1"))
    end
  end
  local realSelectHeroId = self.lotteryInfo:GetCurSelectWishHeroId()
  local isSelectCur = realSelectHeroId ~= nil and curSelectHeroId == realSelectHeroId
  CS.UIGray.SetGray(self.btnConfirm.transform, isSelectCur, true)
  if isSelectCur then
    self.textBtn:SetLocalText("worker_building_button3")
  else
    self.textBtn:SetLocalText("herorecruit_select_desc3")
  end
end

function UIHeroRecruitWishView:OnSelectChange()
  if self.itemList then
    for i, v in pairs(self.itemList) do
      v:UpdateSelect()
    end
  end
  self:UpdateMainContent()
end

function UIHeroRecruitWishView:OnBtnPanelClick()
  self:Close()
end

function UIHeroRecruitWishView:OnBtnHeroTypeIconClick()
  if not self.lotteryId then
    return
  end
  local curSelectHeroId = self.ctrl:GetFakeCurSelectHeroId(self.lotteryId)
  if not curSelectHeroId then
    return
  end
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(curSelectHeroId)
  if heroTemplate then
    local pos = self.imgHeroTypeIcon.transform.position
    local tip = HeroUtils.GetHeroTipInfoTextByType(heroTemplate.type)
    local text = Localization:GetString("129213", Localization:GetString(tip))
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroArmyJobTip, {anim = true}, pos, text)
  end
end

function UIHeroRecruitWishView:OnBtnHeroJobIconClick()
  if not self.lotteryId then
    return
  end
  local curSelectHeroId = self.ctrl:GetFakeCurSelectHeroId(self.lotteryId)
  if not curSelectHeroId then
    return
  end
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(curSelectHeroId)
  if heroTemplate then
    local pos = self.imgHeroJobIcon.transform.position
    local tip = HeroUtils.GetHeroTipInfoTextByJob(heroTemplate.job)
    local text = Localization:GetString(tip)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroArmyJobTip, {anim = true}, pos, text)
  end
end

function UIHeroRecruitWishView:OnBtnInfoClick()
  if not self.lotteryId then
    return
  end
  local curSelectHeroId = self.ctrl:GetFakeCurSelectHeroId(self.lotteryId)
  if not curSelectHeroId then
    return
  end
  local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(curSelectHeroId)
  if heroData then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroData.uuid, {
      heroData.uuid
    })
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, curSelectHeroId, {curSelectHeroId})
  end
end

function UIHeroRecruitWishView:OnBtnCloseClick()
  self:Close()
end

function UIHeroRecruitWishView:OnBtnConfirmClick()
  if not self.lotteryId then
    return
  end
  local curSelectFakeHeroId = self.ctrl:GetFakeCurSelectHeroId(self.lotteryId)
  local lotteryInfo = DataCenter.LotteryDataManager:GetLotteryDataById(self.lotteryId)
  if lotteryInfo then
    local curSelectRealHeroId = lotteryInfo:GetCurSelectWishHeroId()
    if curSelectFakeHeroId ~= nil and (curSelectRealHeroId == nil or curSelectFakeHeroId ~= curSelectRealHeroId) then
      SFSNetwork.SendMessage(MsgDefines.HeroLotterySwitchWish, {
        lotteryId = self.lotteryId,
        wishHero = curSelectFakeHeroId
      })
    end
  end
end

function UIHeroRecruitWishView:OnSwitchSuccess()
  self.ctrl:CloseSelf()
end

function UIHeroRecruitWishView:Close()
  if self.isClosing then
    return
  end
  self.isClosing = true
  local ret, time = self.anim:PlayAnimationReturnTime("Eff_UIHeroRecruitWish_Out")
  if ret then
    self.closeTimer = TimerManager:GetInstance():GetTimer(time, function()
      if self.closeTimer ~= nil then
        self.closeTimer:Stop()
        self.closeTimer = nil
      end
      if self.ctrl then
        self.ctrl:CloseSelf()
      end
    end, self, true, false, false)
    self.closeTimer:Start()
  elseif self.ctrl then
    self.ctrl:CloseSelf()
  end
end

return UIHeroRecruitWishView
