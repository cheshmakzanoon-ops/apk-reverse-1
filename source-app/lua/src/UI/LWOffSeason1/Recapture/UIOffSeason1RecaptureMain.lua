local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIOffSeason1RecaptureMain = BaseClass("UIOffSeason1RecaptureMain", base)
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local UIOffSeason1RecaptureOtherContent = require("UI.LWOffSeason1.Recapture.UIOffSeason1RecaptureOtherContent")
local UIOffSeason1RecaptureBuffItem = require("UI.LWOffSeason1.Recapture.UIOffSeason1RecaptureBuffItem")
local UIOffSeason1RecaptureBuffLine = require("UI.LWOffSeason1.Recapture.UIOffSeason1RecaptureBuffLine")

function UIOffSeason1RecaptureMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIOffSeason1RecaptureMain:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIOffSeason1RecaptureMain:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnReward = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.textRewardBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textRemainTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textBubble = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTipText1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.compOtherContent = self.viewSkin:AddComponent(self, UIOffSeason1RecaptureOtherContent, 7)
  self.compBuffContent = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.compBuffItem1 = self.viewSkin:AddComponent(self, UIOffSeason1RecaptureBuffItem, 9)
  self.compBuffItem2 = self.viewSkin:AddComponent(self, UIOffSeason1RecaptureBuffItem, 10)
  self.compBuffItem3 = self.viewSkin:AddComponent(self, UIOffSeason1RecaptureBuffItem, 11)
  self.compBuffItem4 = self.viewSkin:AddComponent(self, UIOffSeason1RecaptureBuffItem, 12)
  self.compBuffItem5 = self.viewSkin:AddComponent(self, UIOffSeason1RecaptureBuffItem, 13)
  self.compBuffItem6 = self.viewSkin:AddComponent(self, UIOffSeason1RecaptureBuffItem, 14)
  self.compNoneContent = self.viewSkin:AddComponent(self, UIBaseComponent, 15)
  self.textTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.compBuffLineContent = self.viewSkin:AddComponent(self, UIBaseContainer, 17)
  self.textTitle:SetLocalText("s1_offseason_activity_recapture_title")
  self.textRewardBtn:SetLocalText("130065")
  self.textTip:SetLocalText("s1_offseason_activity_recapture_finish")
  self.btnTips = self:AddComponent(UIButton, "Content/TipsBtn")
  self.btnTips:SetOnClick(function()
    self:OnBtnTipsClick()
  end)
  self.redPoint = self:AddComponent(UICommonRedPoint, "Content/RewardBtn/CommonRedPoint")
  self.redPoint:SetType(CommonRedPointPriority.Level1)
  self.heroSpineContainer = self:AddComponent(UIBaseContainer, "Bg/HeroSpineContainer")
  self.closeTipBtn = self:AddComponent(UIButton, "CloseTipPanel")
  self.closeTipBtn:SetActive(false)
  self.closeTipBtn:SetOnClick(function()
    self:OnClickTipBtn()
  end)
  self.buffLinePool = self.transform:Find("Content/NoneContent/BuffScroll/Viewport/BuffLineContent/BuffLine").gameObject
  self.buffLinePool:SetActive(false)
  self.buffLinePool:GameObjectCreatePool()
end

function UIOffSeason1RecaptureMain:ComponentDestroy()
  self:ClearBuffLineContent()
  self.viewSkin = nil
  self.textTitle = nil
  self.btnReward = nil
  self.textRewardBtn = nil
  self.textRemainTime = nil
  self.textBubble = nil
  self.textTipText1 = nil
  self.compOtherContent = nil
  self.compBuffContent = nil
  self.compBuffItem1 = nil
  self.compBuffItem2 = nil
  self.compBuffItem3 = nil
  self.compBuffItem4 = nil
  self.compBuffItem5 = nil
  self.compBuffItem6 = nil
  self.compNoneContent = nil
  self.textTip = nil
  self.compBuffLineContent = nil
  self.redPoint = nil
  self.heroSpineContainer = nil
  self.closeTipBtn = nil
end

function UIOffSeason1RecaptureMain:DataDefine()
end

function UIOffSeason1RecaptureMain:DataDestroy()
  self.lastSpinePath = nil
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
end

function UIOffSeason1RecaptureMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PushCityBattleS1RestActivityInfoUpdateInView, self.SendCityBattleS1RestGainActivityInfo)
  self:AddUIListener(EventId.CityBattleS1RestGainActivityInfoRefresh, self.Refresh)
  self:AddUIListener(EventId.PushOffSeason1ActivityTaskInfoUpdate, self.RefreshRedDot)
  self:AddUIListener(EventId.OpenOffSeason1RecaptureMainCloseTipPanel, self.ShowClickTipBtn)
end

function UIOffSeason1RecaptureMain:OnRemoveListener()
  self:RemoveUIListener(EventId.PushCityBattleS1RestActivityInfoUpdateInView, self.SendCityBattleS1RestGainActivityInfo)
  self:RemoveUIListener(EventId.CityBattleS1RestGainActivityInfoRefresh, self.Refresh)
  self:RemoveUIListener(EventId.PushOffSeason1ActivityTaskInfoUpdate, self.RefreshRedDot)
  self:RemoveUIListener(EventId.OpenOffSeason1RecaptureMainCloseTipPanel, self.ShowClickTipBtn)
  base.OnRemoveListener(self)
end

function UIOffSeason1RecaptureMain:OnBtnRewardClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIOffSeason1Task, {anim = true}, OffSeason1TaskGroup.OffSeason1Recapture)
end

function UIOffSeason1RecaptureMain:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = tonumber(activityId)
  local data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if data == nil then
    return
  end
  self.activityData = data
  if self.activityData then
    self:ReloadHeroSpine(self.activityData.activity_hero)
  end
  self.showFirstIn = true
  self:SendCityBattleS1RestGainActivityInfo()
  self:Refresh()
  self:Update1000MS()
end

function UIOffSeason1RecaptureMain:Refresh()
  local monsterInfos = DataCenter.OffSeason1RecaptureManager:GetMonsterInfos()
  local effectList = DataCenter.OffSeason1RecaptureManager:GetEffectList()
  local haveMonster = false
  for i = 1, 6 do
    self["compBuffItem" .. i]:Refresh(i, effectList[i])
    if not haveMonster and monsterInfos and monsterInfos[i] and 0 < #monsterInfos[i] then
      haveMonster = true
    end
  end
  if haveMonster then
    self.textBubble:SetLocalText("s1_offseason_activity_recapture_desc1", "#" .. LuaEntry.Player:GetSourceServerId())
    self.compOtherContent:SetActive(true)
    self.compOtherContent:Refresh(monsterInfos, self.showFirstIn)
    self.compNoneContent:SetActive(false)
    self.textTipText1:SetLocalText("s1_offseason_activity_recapture_attackRemain", DataCenter.OffSeason1RecaptureManager:GetAtkTime())
    self.textTipText1:SetActive(true)
  else
    self.textBubble:SetLocalText("s1_offseason_activity_recapture_desc2", "#" .. LuaEntry.Player:GetSourceServerId())
    self.compOtherContent:SetActive(false)
    self.compNoneContent:SetActive(true)
    self.textTipText1:SetActive(false)
    if self.buffLineItems == nil then
      self.buffLineItems = {}
      for i = 1, 6 do
        local go = self.buffLinePool:GameObjectSpawn(self.compBuffLineContent.transform)
        go.name = "buffLine" .. i
        go:SetActive(true)
        local item = self.compBuffLineContent:AddComponent(UIOffSeason1RecaptureBuffLine, go)
        item:SetData(effectList[i])
        table.insert(self.buffLineItems, item)
      end
    end
  end
  self.showFirstIn = false
  self:RefreshRedDot()
end

function UIOffSeason1RecaptureMain:SendCityBattleS1RestGainActivityInfo(t)
  SFSNetwork.SendMessage(MsgDefines.CityBattleS1RestGainActivityInfo, t)
end

function UIOffSeason1RecaptureMain:Update1000MS()
  if not self.activityId then
    return
  end
  if self.activityData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = self.activityData.endTime
  local remainTime = endTime - curTime
  if 0 < remainTime then
    self.textRemainTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.textRemainTime:SetText("")
  end
end

function UIOffSeason1RecaptureMain:OnBtnTipsClick()
  if self.activityData and not table.IsNullOrEmpty(self.activityData.howtoplay) then
    local param = {}
    param.howToPlayList = self.activityData.howtoplay
    param.story = self.activityData.story
    param.defaultTitle = self.activityData.name
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
  end
end

function UIOffSeason1RecaptureMain:RefreshRedDot()
  self.redPoint:SetDefaultVisible(DataCenter.OffSeason1TaskDataManager:GetRedDotNum(tonumber(OffSeason1TaskGroup.OffSeason1Recapture)) > 0)
end

function UIOffSeason1RecaptureMain:ReloadHeroSpine(spinePath)
  if string.IsNullOrEmpty(spinePath) then
    return
  end
  if self.lastSpinePath ~= spinePath then
    if self.heroSpineLoadRequest ~= nil then
      self.heroSpineLoadRequest:Destroy()
      self.heroSpineLoadRequest = nil
    end
    local request = ResourceManager:InstantiateAsync(spinePath)
    self.heroSpineLoadRequest = request
    request:completed("+", function()
      if request.isError or request.gameObject == nil then
        self.heroSpineLoadRequest = nil
        return
      end
      self:ResetSpineTransform(request.gameObject)
    end)
    self.lastSpinePath = spinePath
  elseif self.heroSpineLoadRequest then
    self:ResetSpineTransform(self.heroSpineLoadRequest.gameObject)
  end
end

function UIOffSeason1RecaptureMain:ResetSpineTransform(obj)
  if not obj then
    return
  end
  local parent = self.heroSpineContainer
  if not parent then
    return
  end
  obj:SetActive(true)
  local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
  if rectTransform ~= nil then
    local spinePos = {0, 180}
    rectTransform:SetParent(parent.transform)
    rectTransform:Set_localScale(-1 * CommonUtil.ArabicAutoMirrorFactor(), 1, 1)
    rectTransform:Set_anchoredPosition(spinePos[1], spinePos[2], 0)
  end
end

function UIOffSeason1RecaptureMain:OnClickTipBtn()
  self.closeTipBtn:SetActive(false)
  EventManager:GetInstance():Broadcast(EventId.CloseOffSeason1RecaptureMainTipBubble)
end

function UIOffSeason1RecaptureMain:ShowClickTipBtn()
  self.closeTipBtn:SetActive(true)
end

function UIOffSeason1RecaptureMain:ClearBuffLineContent()
  self.buffLineItems = nil
  self.compBuffLineContent:RemoveComponents(UIOffSeason1RecaptureBuffLine)
  self.buffLinePool:GameObjectRecycleAll()
end

return UIOffSeason1RecaptureMain
