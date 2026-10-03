local base = UIAsyncContainer
local UIWS_H_HCell = BaseClass("UIWS_H_HCell", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function UIWS_H_HCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWS_H_HCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWS_H_HCell:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.sliderRed = self.viewSkin:AddComponent(self, UISlider, 3)
  self.textRedScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.sliderBlue = self.viewSkin:AddComponent(self, UISlider, 5)
  self.textBlueScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnMvp = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnMvp:SetOnClick(function()
    self:OnBtnMvpClick()
  end)
  self.imgMvp = self.viewSkin:AddComponent(self, UIImage, 8)
  self.compMyHead = self.viewSkin:AddComponent(self, UICommonHead, 9)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textLv = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.imgIcon3 = self.viewSkin:AddComponent(self, UIImage, 12)
  self.imgIcon2 = self.viewSkin:AddComponent(self, UIImage, 13)
  self.imgIcon1 = self.viewSkin:AddComponent(self, UIImage, 14)
  self.btnMore = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnMore:SetOnClick(function()
    self:OnBtnMoreClick()
  end)
  self.compArrow = self.viewSkin:AddComponent(self, UIBaseComponent, 16)
  self.compHead1 = self.viewSkin:AddComponent(self, UICommonHead, 17)
  self.compHead2 = self.viewSkin:AddComponent(self, UICommonHead, 18)
  self.compHead3 = self.viewSkin:AddComponent(self, UICommonHead, 19)
  self.compHead4 = self.viewSkin:AddComponent(self, UICommonHead, 20)
  self.btnShare = self.viewSkin:AddComponent(self, UIButton, 21)
  self.btnShare:SetOnClick(function()
    self:OnBtnShareClick()
  end)
  self.textState1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 22)
  self.textState2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 23)
end

function UIWS_H_HCell:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.textTime = nil
  self.sliderRed = nil
  self.textRedScore = nil
  self.sliderBlue = nil
  self.textBlueScore = nil
  self.btnMvp = nil
  self.imgMvp = nil
  self.compMyHead = nil
  self.textName = nil
  self.textLv = nil
  self.imgIcon3 = nil
  self.imgIcon2 = nil
  self.imgIcon1 = nil
  self.btnMore = nil
  self.compArrow = nil
  self.compHead1 = nil
  self.compHead2 = nil
  self.compHead3 = nil
  self.compHead4 = nil
  self.btnShare = nil
  self.textState1 = nil
  self.textState2 = nil
end

function UIWS_H_HCell:DataDefine()
  self.achievements = nil
  self.mvpDesc = nil
  self.heads = {
    self.compHead1,
    self.compHead2,
    self.compHead3,
    self.compHead4
  }
  self.icons = {
    self.imgIcon3,
    self.imgIcon2,
    self.imgIcon1
  }
  self.compMyHead:SetEnableClickShowInfo(true, true)
  self.compHead1:SetEnableClickShowInfo(true, true)
  self.compHead2:SetEnableClickShowInfo(true, true)
  self.compHead3:SetEnableClickShowInfo(true, true)
  self.compHead4:SetEnableClickShowInfo(true, true)
  self.btnShare:SetActive(true)
end

function UIWS_H_HCell:DataDestroy()
  self.achievements = nil
  self.mvpDesc = nil
  self.heads = nil
  self.icons = nil
  self.logData = nil
end

function UIWS_H_HCell:OnAddListener()
  base.OnAddListener(self)
end

function UIWS_H_HCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIWS_H_HCell:OnBtnMvpClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if not string.IsNullOrEmpty(self.mvpDesc) then
    UIUtil.ShowBubbleTips(self.mvpDesc, self.btnMvp.transform.position, 0, -30, 0)
  end
end

function UIWS_H_HCell:OnBtnMoreClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if table.IsNullOrEmpty(self.achievements) then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWinterStormAchievementList, {anim = true}, self.achievements)
end

function UIWS_H_HCell:OnBtnShareClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local share_param = {}
  share_param.post = PostType.BF_WINTER_HISTORY_SHARE
  share_param.postType = PostType.BF_WINTER_HISTORY_SHARE
  share_param.param = {
    logData = self.logData.rawData
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

function UIWS_H_HCell:ReInit(logData)
  self.logData = logData
  self:RefreshView()
end

function UIWS_H_HCell:UpdateData()
  if self.logData == nil then
    return
  end
  local logData = self.logData
  local conclusionKey = LocalController:instance():getValue("winter_battlefield_conclusion", logData.conclusionId, "name")
  local outcome = LocalController:instance():getIntValue("winter_battlefield_conclusion", logData.conclusionId, "outcome")
  self.textState1:SetActive(outcome == 1)
  self.textState2:SetActive(outcome ~= 1)
  if outcome == 1 then
    self.textState1:SetLocalText(conclusionKey)
  else
    self.textState2:SetLocalText(conclusionKey)
  end
  self.textTime:SetText(Localization:GetString("800811") .. UITimeManager:GetInstance():TimeStampToTimeForServerMinute(logData.time * 1000))
  self:RefreshScore(logData)
  self:RefreshAchievement(logData)
  self:RefreshHeads(logData)
end

function UIWS_H_HCell:RefreshScore(logData)
  local mScore = logData.side == 1 and logData.scoreA or logData.scoreB or 0
  local eScore = logData.side == 1 and logData.scoreB or logData.scoreA or 0
  local maxScore = math.max(mScore, eScore)
  if 0 < maxScore then
    self.sliderRed:SetValue(eScore / maxScore)
    self.sliderBlue:SetValue(mScore / maxScore)
  else
    self.sliderRed:SetValue(0)
    self.sliderBlue:SetValue(0)
  end
  self.textRedScore:SetText(string.GetFormattedSeparatorNum(eScore))
  self.textBlueScore:SetText(string.GetFormattedSeparatorNum(mScore))
end

function UIWS_H_HCell:RefreshAchievement(logData)
  local achievements = logData.achievement or {}
  if not table.IsNullOrEmpty(achievements) then
    DataCenter.ActWinterStormManager:SortAchievement(achievements)
  end
  self.achievements = achievements
  local cnt = #achievements
  self.compArrow:SetActive(3 < cnt)
  for i, v in ipairs(self.icons) do
    local achievementId = achievements[i]
    v:SetActive(achievementId ~= nil)
    if achievementId then
      local iconName = LocalController:instance():getValue(TableName.LW_BattleField_Achievement, achievementId, "icon")
      if not string.IsNullOrEmpty(iconName) then
        v:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldWinterAchievementPath, iconName))
      end
    end
  end
end

function UIWS_H_HCell:RefreshHeads(logData)
  local mvpId = logData.mvpId or 0
  local tbName = DataCenter.ActWinterStormManager:GetCfgValue(BattleFieldTableKey.STAR)
  local line = 0 < mvpId and LocalController:instance():getLine(tbName, mvpId) or nil
  if line then
    local icon = line:getValue("icon")
    self.imgMvp:LoadSpriteAsyncWithCallback(string.format(LoadPath.LWBattleFieldMvpPath, icon), function()
      if self.imgMvp then
        self.imgMvp:SetNativeSize()
      end
    end)
    self.imgMvp:SetActive(true)
    self.mvpDesc = Localization:GetString(line:getValue("desc"), line:getValue("score"))
  else
    self.imgMvp:SetActive(false)
    self.mvpDesc = nil
  end
  local myInfo
  local team = logData.team or {}
  local myUid = LuaEntry.Player:GetUid()
  local cnt = 1
  for i = 1, 5 do
    local head = self.heads[cnt]
    local v = team[i]
    if v then
      if v.uid == myUid then
        myInfo = v
      else
        if head then
          head:SetData(v.uid, v.head, v.frame)
          head:SetActive(true)
        end
        cnt = cnt + 1
      end
    else
      if head then
        head:SetActive(false)
      end
      cnt = cnt + 1
    end
  end
  if myInfo then
    self.compMyHead:SetData(myInfo.uid, myInfo.head, myInfo.frame)
    self.textName:SetText(UIUtil.FormatAllianceAndName(myInfo.allianceName, myInfo.name))
    self.textLv:SetLocalText(140002, myInfo.lv)
  else
    self.compMyHead:SetData()
    self.textName:SetText("")
    self.textLv:SetText("")
  end
end

return UIWS_H_HCell
