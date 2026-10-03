local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local base = IChatItemPost
local BFWinterHistoryShare = BaseClass("BFWinterHistoryShare", IChatItemPost)
local Localization = CS.GameEntry.Localization
local ActWinterStormLogData = require("DataCenter.ActWinterStormManager.ActWinterStormLogData")
local rapidjson = require("rapidjson")

function BFWinterHistoryShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function BFWinterHistoryShare:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BFWinterHistoryShare:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textState1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.sliderRed = self.viewSkin:AddComponent(self, UISlider, 3)
  self.textRedScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.sliderBlue = self.viewSkin:AddComponent(self, UISlider, 5)
  self.textBlueScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.imgMvp = self.viewSkin:AddComponent(self, UIImage, 7)
  self.btnMvp = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnMvp:SetOnClick(function()
    self:OnBtnMvpClick()
  end)
  self.compMyHead = self.viewSkin:AddComponent(self, UICommonHead, 9)
  self.imgIcon3 = self.viewSkin:AddComponent(self, UIImage, 10)
  self.imgIcon2 = self.viewSkin:AddComponent(self, UIImage, 11)
  self.imgIcon1 = self.viewSkin:AddComponent(self, UIImage, 12)
  self.compArrow = self.viewSkin:AddComponent(self, UIBaseComponent, 13)
  self.btnMore = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnMore:SetOnClick(function()
    self:OnBtnMoreClick()
  end)
  self.textState2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
end

function BFWinterHistoryShare:ComponentDestroy()
  self.viewSkin = nil
  self.textState1 = nil
  self.textTime = nil
  self.sliderRed = nil
  self.textRedScore = nil
  self.sliderBlue = nil
  self.textBlueScore = nil
  self.imgMvp = nil
  self.btnMvp = nil
  self.compMyHead = nil
  self.imgIcon3 = nil
  self.imgIcon2 = nil
  self.imgIcon1 = nil
  self.compArrow = nil
  self.btnMore = nil
  self.textState2 = nil
end

function BFWinterHistoryShare:DataDefine()
  self.icons = {
    self.imgIcon3,
    self.imgIcon2,
    self.imgIcon1
  }
end

function BFWinterHistoryShare:DataDestroy()
  self.logData = nil
  self.achievements = nil
  self.mvpDesc = nil
end

function BFWinterHistoryShare:OnAddListener()
  base.OnAddListener(self)
end

function BFWinterHistoryShare:OnRemoveListener()
  base.OnRemoveListener(self)
end

function BFWinterHistoryShare:OnBtnMvpClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if not string.IsNullOrEmpty(self.mvpDesc) then
    UIUtil.ShowBubbleTips(self.mvpDesc, self.btnMvp.transform.position, 0, -30, 0)
  end
end

function BFWinterHistoryShare:OnBtnMoreClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if table.IsNullOrEmpty(self.achievements) then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWinterStormAchievementList, {anim = true}, self.achievements)
end

function BFWinterHistoryShare:OnLoaded()
  self._chatData = self:ChatData()
  self.logData = nil
  self.achievements = nil
  self.mvpDesc = nil
  if self._chatData == nil then
    return
  end
  self:DecodeData()
  self:RefreshUI()
end

function BFWinterHistoryShare:DecodeData()
  if self.logData ~= nil then
    return
  end
  if self._chatData and self._chatData.extra ~= nil and self._chatData.extra.attachmentId ~= nil then
    local jsonObj = rapidjson.decode(self._chatData.extra.attachmentId)
    if jsonObj then
      local logData = ActWinterStormLogData.New()
      logData:ParseData(jsonObj.logData)
      self.logData = logData
    end
  end
end

function BFWinterHistoryShare:RefreshUI()
  local logData = self.logData
  if logData == nil then
    return
  end
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

function BFWinterHistoryShare:RefreshScore(logData)
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

function BFWinterHistoryShare:RefreshAchievement(logData)
  local achievements = logData.achievement or {}
  self.achievements = achievements
  DataCenter.ActWinterStormManager:SortAchievement(self.achievements)
  local cnt = #achievements
  self.compArrow:SetActive(3 < cnt)
  for i, v in ipairs(self.icons) do
    local achievementId = achievements[i]
    v:SetActive(achievementId ~= nil)
    if achievementId then
      local iconName = LocalController:instance():getValue(TableName.LW_BattleField_Achievement, achievementId, "icon")
      if not string.IsNullOrEmpty(iconName) then
        v:LoadSprite(string.format(LoadPath.LWBattleFieldWinterAchievementPath, iconName))
      end
    end
  end
end

function BFWinterHistoryShare:RefreshHeads(logData)
  local mvpId = logData.mvpId or 0
  local tbName = DataCenter.ActWinterStormManager:GetCfgValue(BattleFieldTableKey.STAR)
  local line = 0 < mvpId and LocalController:instance():getLine(tbName, mvpId) or nil
  if line then
    local icon = line:getValue("icon")
    self.imgMvp:LoadSprite(string.format(LoadPath.LWBattleFieldMvpPath, icon))
    self.imgMvp:SetNativeSize()
    self.imgMvp:SetActive(true)
    self.mvpDesc = Localization:GetString(line:getValue("desc"), line:getValue("score"))
  else
    self.imgMvp:SetActive(false)
    self.mvpDesc = nil
  end
  local myInfo
  local team = logData.team or {}
  local myUid = LuaEntry.Player:GetUid()
  for _, v in ipairs(team) do
    if v.uid == myUid then
      myInfo = v
      break
    end
  end
  if myInfo then
    self.compMyHead:SetData(myInfo.uid, myInfo.head, myInfo.frame)
  end
end

return BFWinterHistoryShare
