local base = UIBaseContainer
local AllyDuelTodayGacha = BaseClass("AllyDuelTodayGacha", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function AllyDuelTodayGacha:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  DataCenter.AllyDuelScoreGachaManager:SendGetGachaInfoMessage()
end

function AllyDuelTodayGacha:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllyDuelTodayGacha:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnGachainfo = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnGachainfo:SetOnClick(function()
    self:OnBtnGachainfoClick()
  end)
  self.textGachaTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compLock = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.compUnlock = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.textMultiNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTxtTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textResourceNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textGachaTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.btnGachaJump = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnGachaJump:SetOnClick(function()
    self:OnBtnGachaJumpClick()
  end)
  self.textGachaJumpBtnTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.sliderGachaProgressScore = self.viewSkin:AddComponent(self, UISlider, 11)
  self.textGachaProgressNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.imgScienceIcon = self.viewSkin:AddComponent(self, UIImage, 13)
  self.textUnlockTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.btnGo = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.compGachaContentItem = self.viewSkin:AddComponent(self, UIBaseContainer, 16)
  self.compGachaLockMask = self.viewSkin:AddComponent(self, UIBaseContainer, 17)
  self.rawImgGachaContent = self.viewSkin:AddComponent(self, UIRawImage, 18)
  self.compRedPoint = self.viewSkin:AddComponent(self, UIBaseContainer, 19)
  self.textRedNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.btnLockScoreContent = self.viewSkin:AddComponent(self, UIButton, 21)
  self.btnLockScoreContent:SetOnClick(function()
    self:OnBtnLockScoreContentClick()
  end)
  self.textGachaTitle:SetLocalText("alliance_duel_gacha_tech_name")
  self.textUnlockTips:SetLocalText("alliance_duel_gacha_tips_1001")
  self.textGachaTips:SetLocalText("alliance_duel_gacha_tips_1014")
  self.textGachaJumpBtnTxt:SetLocalText("110003")
end

function AllyDuelTodayGacha:ComponentDestroy()
  self.viewSkin = nil
  self.btnGachainfo = nil
  self.textGachaTitle = nil
  self.compLock = nil
  self.compUnlock = nil
  self.textMultiNum = nil
  self.textTxtTime = nil
  self.textResourceNum = nil
  self.textGachaTips = nil
  self.btnGachaJump = nil
  self.textGachaJumpBtnTxt = nil
  self.sliderGachaProgressScore = nil
  self.textGachaProgressNum = nil
  self.imgScienceIcon = nil
  self.textUnlockTips = nil
  self.btnGo = nil
  self.compGachaContentItem = nil
  self.compGachaLockMask = nil
  self.rawImgGachaContent = nil
  self.compRedPoint = nil
  self.textRedNum = nil
  self.btnLockScoreContent = nil
end

function AllyDuelTodayGacha:DataDefine()
end

function AllyDuelTodayGacha:DataDestroy()
  self:ClearItems()
end

function AllyDuelTodayGacha:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllyDuelScoreGachaGotData, self.OnGotData)
  self:AddUIListener(EventId.AllyDuelScoreGachaEndGacha, self.OnEndGacha)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
  self:AddUIListener(EventId.AllyDuelScoreGachaWishClaim, self.RefreshRedDot)
  self:AddUIListener(EventId.AllyDuelScoreGachaUpdateScore, self.RefreshRedDot)
  self:AddUIListener(EventId.AllyDuelScoreGachaRedPointUpdate, self.RefreshRedDot)
end

function AllyDuelTodayGacha:OnRemoveListener()
  self:RemoveUIListener(EventId.AllyDuelScoreGachaGotData, self.OnGotData)
  self:RemoveUIListener(EventId.AllyDuelScoreGachaEndGacha, self.OnEndGacha)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
  self:RemoveUIListener(EventId.AllyDuelScoreGachaWishClaim, self.RefreshRedDot)
  self:RemoveUIListener(EventId.AllyDuelScoreGachaUpdateScore, self.RefreshRedDot)
  self:RemoveUIListener(EventId.AllyDuelScoreGachaRedPointUpdate, self.RefreshRedDot)
  base.OnRemoveListener(self)
end

function AllyDuelTodayGacha:OnGotData(configId)
  self.configId = configId
  self:ReInit()
end

function AllyDuelTodayGacha:OnEndGacha()
  self:ReInit()
end

function AllyDuelTodayGacha:OnPassDay()
  DataCenter.AllyDuelScoreGachaManager:SendGetGachaInfoMessage()
end

function AllyDuelTodayGacha:OnBtnGachainfoClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.AllyDuelScoreGachaRules, self.configId)
end

function AllyDuelTodayGacha:OnBtnGachaJumpClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.AllyDuelScoreGacha, {anim = true})
end

function AllyDuelTodayGacha:OnBtnGoClick()
  GoToUtil.GotoScience(DataCenter.AllyDuelScoreGachaManager.unlockScienceId // 100 * 100)
end

function AllyDuelTodayGacha:OnBtnLockScoreContentClick()
  GoToUtil.GotoScience(DataCenter.AllyDuelScoreGachaManager.unlockScienceId // 100 * 100)
end

function AllyDuelTodayGacha:ReInit()
  local isUnlock = DataCenter.AllyDuelScoreGachaManager:IsUnlock()
  self.compLock:SetActive(not isUnlock)
  self.compUnlock:SetActive(isUnlock)
  self:RefreshIconContent(isUnlock)
  self:RefreshProgress()
  if isUnlock then
    self:RefreshUnlockNumBar()
    self:Update1000MS()
    self:RefreshRedDot()
  else
    self:RefreshLockRewardItems()
    self:RefreshLockScience()
  end
end

function AllyDuelTodayGacha:ClearItems()
  self.compGachaContentItem:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

function AllyDuelTodayGacha:RefreshLockRewardItems()
  local configData = DataCenter.AllyDuelScoreGachaManager:GetConfigData(self.configId)
  if configData == nil then
    return
  end
  self:ClearItems()
  local allItemData = configData:GetAllItemDataInOrder()
  for i, v in ipairs(allItemData) do
    local idx = i
    self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.compGachaContentItem.transform)
      go.transform:Set_localScale(0.55, 0.55, 0.55)
      go.transform:Set_pivot(0.5, 0.5)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = self.compGachaContentItem:AddComponent(UICommonResItem, nameStr)
      local para = {}
      para.rewardType = allItemData[idx].itemType
      para.itemId = allItemData[idx].itemId
      para.count = allItemData[idx].itemNum
      cell:ReInit(para)
    end)
  end
end

function AllyDuelTodayGacha:RefreshLockScience()
  local scienceTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(DataCenter.AllyDuelScoreGachaManager.unlockScienceId)
  if scienceTemplate then
    self.imgScienceIcon:LoadSpriteAuto(string.format(LoadPath.ScienceIcons, scienceTemplate.icon))
  end
end

function AllyDuelTodayGacha:RefreshUnlockNumBar()
  if self.configId == nil then
    self.textResourceNum:SetText(0)
    return
  end
  local infoTemplate = DataCenter.AllyDuelScoreGachaManager:GetConfigInfo(self.configId)
  if infoTemplate == nil then
    return
  end
  local configData = DataCenter.AllyDuelScoreGachaManager:GetConfigData(self.configId)
  local gachaOnceCost = DataCenter.AllyDuelScoreGachaManager.gachaOnceCost
  local curNum = configData.data.score // gachaOnceCost
  self.textResourceNum:SetText(string.GetFormattedStr(curNum))
end

function AllyDuelTodayGacha:RefreshProgress()
  local configData = DataCenter.AllyDuelScoreGachaManager:GetConfigData(self.configId)
  if configData then
    local gachaOnceCost = DataCenter.AllyDuelScoreGachaManager.gachaOnceCost
    self.textMultiNum:SetActive(DataCenter.AllyDuelScoreGachaManager:IsUnlock())
    self.textMultiNum:SetText(string.format("\226\156\150%d", configData.data.score // gachaOnceCost))
    local remainNum = configData.data.score % gachaOnceCost
    local haveScore = string.GetFormattedStr(remainNum)
    self.sliderGachaProgressScore:SetValue(remainNum / gachaOnceCost)
    self.textGachaProgressNum:SetText(string.format("%s/%s", haveScore, string.GetFormattedStr(gachaOnceCost)))
  end
end

function AllyDuelTodayGacha:Update1000MS()
  local remainTimeS = UITimeManager:GetInstance():GetResSeoncdsToNextMonday()
  local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(remainTimeS * 1000)
  self.textTxtTime:SetText(showTime)
end

local LOCK_BG_PATH = "Assets/Main/TextureEx/UIActivityBg/AllyDuelCommon/lrb_lianmengduijue_baoxiangbg01.png"
local UNLOCK_BG_PATH = "Assets/Main/TextureEx/UIActivityBg/AllyDuel/lrb_lianmengduijue_baoxiangbg00.png"

function AllyDuelTodayGacha:RefreshIconContent(isUnlock)
  self.rawImgGachaContent:LoadSpriteAuto(isUnlock and UNLOCK_BG_PATH or LOCK_BG_PATH)
  self.compGachaLockMask:SetActive(not isUnlock)
end

function AllyDuelTodayGacha:RefreshRedDot()
  local totalRedNum = DataCenter.AllyDuelScoreGachaManager:GetTotalRedDotNum()
  local nextWeekDayTime = UITimeManager:GetInstance():GetNextWeekDay(1)
  local lastRedNum = CommonUtil.PlayerPrefsGetInt(SettingKeys.ALLY_DUEL_GACHA_BTN_LAST_RED .. nextWeekDayTime, 0)
  self.compRedPoint:SetActive(0 < totalRedNum and totalRedNum ~= lastRedNum)
  self.textRedNum:SetText(99 < totalRedNum and "99+" or totalRedNum)
end

function AllyDuelTodayGacha:OnEnable()
  base.OnEnable(self)
  self:RefreshRedDot()
end

function AllyDuelTodayGacha:OnDisable()
  base.OnDisable(self)
end

return AllyDuelTodayGacha
