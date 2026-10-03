local UIDesertBattleResultS0View = BaseClass("UIDesertBattleResultS0View", UIBaseView)
local ResourceManager = CS.GameEntry.Resource
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local Camera = CS.UnityEngine.Camera
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local BattleMvpItem = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleResult.Component.BattleMvpItem")
local BattleCheer = require("UI.UIActivityCenterTable.Component.DesertBattle.BattleResult.Component.BattleCheer")
local CHEER1_PREFAB = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/S0/BattleResultCheer1.prefab"
local CHEER2_PREFAB = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/S0/BattleResultCheer2.prefab"
local giftIconPath = "Assets/Main/Sprites/UI/LWUIGiftSystem/lyt_lw_icon.png"
local MyRand = math.random
local CHEER_ADD_1 = 2
local CHEER_ADD_2 = 1
local AUTO_CHEER_TIME_MIN = 1
local AUTO_CHEER_TIME_MAX = 3
local AUTO_CHEER_COUNT_MIN = 3
local AUTO_CHEER_COUNT_MAX = 10
local AUTO_CHEER2_COUNT_MIN = 1
local AUTO_CHEER2_COUNT_MAX = 5
local NEW_REWARD_SHOW = true

local function IsTest()
  if CommonUtil.IsDebug() and not string.IsNullOrEmpty(DataCenter.ActDragonManager.TEST_PARAM) then
    return true
  end
  return false
end

function UIDesertBattleResultS0View:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshUI()
end

function UIDesertBattleResultS0View:OnDestroy()
  self:CleanScene()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDesertBattleResultS0View:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.rawImgScene = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.imgLeftIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textLv = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compVictoryGo = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.textNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.compLoseGo = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.btnLeft = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnLeft:SetOnClick(function()
    self:OnBtnLeftClick()
  end)
  self.btnRight = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnRight:SetOnClick(function()
    self:OnBtnRightClick()
  end)
  self.textSliderNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.compBestGroup = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.slider = self.viewSkin:AddComponent(self, UISlider, 13)
  self.imgRightIon = self.viewSkin:AddComponent(self, UIImage, 14)
  self.imgArrow = self.viewSkin:AddComponent(self, UIImage, 15)
  self.compCheersContent = self.viewSkin:AddComponent(self, UIBaseContainer, 16)
  self.compFinal = self.viewSkin:AddComponent(self, UIBaseComponent, 17)
  self.animatorStar = self.viewSkin:AddComponent(self, UIAnimator, 18)
  self.compExplode = self.viewSkin:AddComponent(self, UIBaseComponent, 19)
  self.animatorBattleResultS0 = self.viewSkin:AddComponent(self, UIAnimator, 20)
  self.compBestSelf = self.viewSkin:AddComponent(self, BattleMvpItem, 21)
  self.compMvp = self.viewSkin:AddComponent(self, BattleMvpItem, 22)
  self.animatorLoseGo = self.viewSkin:AddComponent(self, UIAnimator, 23)
  self.animatorVictoryGo = self.viewSkin:AddComponent(self, UIAnimator, 24)
  self.btnRaycast = self.viewSkin:AddComponent(self, UIButton, 25)
  self.btnRaycast:SetOnClick(function()
    self:OnBtnRaycastClick()
  end)
  self.compReward = self.viewSkin:AddComponent(self, UIBaseComponent, 26)
  self.btnFinal = self.viewSkin:AddComponent(self, UIButton, 27)
  self.btnFinal:SetOnClick(function()
    self:OnBtnFinalClick()
  end)
  self.imgLeftCDFill = self.viewSkin:AddComponent(self, UIImage, 28)
  self.textLeftCD = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 29)
  self.imgRightCDFill = self.viewSkin:AddComponent(self, UIImage, 30)
  self.textRightCD = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 31)
  self.compEffCheer = self.viewSkin:AddComponent(self, UIBaseComponent, 32)
  self.compRContent = self.viewSkin:AddComponent(self, UIBaseContainer, 33)
  self.btnOK = self.viewSkin:AddComponent(self, UIButton, 34)
  self.btnOK:SetOnClick(function()
    self:OnBtnOKClick()
  end)
  self.rawImgFinalBtn = self.viewSkin:AddComponent(self, UIRawImage, 35)
  self.btnMvpGiftSend = self.viewSkin:AddComponent(self, UIButton, 36)
  self.btnMvpGiftSend:SetOnClick(function()
    local playerUId = self.giftPlayerUid
    local param = {
      playerUid = playerUId,
      dirType = GiftSystemConst.GiftSendPanelDirection.Up,
      openType = GiftSystemConst.GiftSendPanelType.Desert,
      target = self.btnMvpGiftSend,
      showItemAnim = true,
      clickAnim = true
    }
    DataCenter.GiftSystemManager:ShowQuick(param)
  end)
  self.imgMvpGiftSendIcon = self.viewSkin:AddComponent(self, UIImage, 37)
  self.root = self:AddComponent(UIBaseComponent, "Root")
  self.btnPanel:SetSafeClickMode(true)
  self.btnLeft:SetSafeClickMode(true)
  self.btnRight:SetSafeClickMode(true)
  self.imgLeftIcon:LoadSpriteAuto(string.format(LoadPath.ItemPath, "lrb_daojv_biaoqing03"))
  self.imgRightIon:LoadSpriteAuto(string.format(LoadPath.ItemPath, "lrb_daojv_biaoqing00"))
  self.imgRightIon:LoadSpriteAuto(string.format(LoadPath.ItemPath, "lrb_daojv_biaoqing00"))
  self.imgMvpGiftSendIcon:LoadSpriteAuto(giftIconPath)
  self.bestItems = {}
  for i = 1, 3 do
    self.bestItems[i] = self:AddComponent(BattleMvpItem, "Root/BestGroup/Best" .. i)
  end
  self.cheerReqs = {}
  self.rawImgScene:SetActive(false)
  self.compVictoryGo:SetActive(false)
  self.compLoseGo:SetActive(false)
  self.compMvp:SetActive(false)
  self.compBestGroup:SetActive(false)
  self.compBestSelf:SetActive(false)
  self.compFinal:SetActive(false)
  self.compEffCheer:SetActive(false)
  self.compReward:SetActive(false)
  self.compCheersContent:SetActive(false)
  self.btnLeft:SetActive(true)
  self.btnRight:SetActive(true)
end

function UIDesertBattleResultS0View:ComponentDestroy()
  self:CleanDelayAutoNext()
  if self.autoCheer2Timer then
    self.autoCheer2Timer:Stop()
    self.autoCheer2Timer = nil
  end
  if self.autoCheerTimer ~= nil then
    self.autoCheerTimer:Stop()
    self.autoCheerTimer = nil
  end
  if self.autoCheerList2 then
    for _, v in pairs(self.autoCheerList2) do
      if v then
        v:Stop()
      end
    end
    self.autoCheerList2 = nil
  end
  if self.autoCheerList then
    for _, v in pairs(self.autoCheerList) do
      if v then
        v:Stop()
      end
    end
    self.autoCheerList = nil
  end
  if self.cheerReqs then
    for _, v in pairs(self.cheerReqs) do
      if v ~= nil then
        v:Destroy()
      end
    end
    self.cheerReqs = nil
  end
  if self.giftEffectResList then
    for _, v in pairs(self.giftEffectResList) do
      if v ~= nil then
        v:Destroy()
      end
    end
    self.giftEffectResList = nil
  end
  if self.timerList then
    for i, timer in pairs(self.timerList) do
      if timer then
        timer:Stop()
      end
    end
    self.timerList = nil
  end
  DataCenter.GiftEffectManager:RemoveCheerComponents(self.compCheersContent)
  self.compCheersContent:RemoveComponents(BattleCheer)
  self.viewSkin = nil
  self.rawImgScene = nil
  self.imgLeftIcon = nil
  self.btnPanel = nil
  self.textLv = nil
  self.compVictoryGo = nil
  self.textNum = nil
  self.compLoseGo = nil
  self.btnLeft = nil
  self.btnRight = nil
  self.textSliderNum = nil
  self.compBestGroup = nil
  self.btnInfo = nil
  self.slider = nil
  self.imgRightIon = nil
  self.imgArrow = nil
  self.compCheersContent = nil
  self.compFinal = nil
  self.animatorStar = nil
  self.compExplode = nil
  self.animatorBattleResultS0 = nil
  self.compBestSelf = nil
  self.compMvp = nil
  self.animatorLoseGo = nil
  self.animatorVictoryGo = nil
  self.btnRaycast = nil
  self.compReward = nil
  self.btnFinal = nil
  self.imgLeftCDFill = nil
  self.textLeftCD = nil
  self.imgRightCDFill = nil
  self.textRightCD = nil
  self.compEffCheer = nil
  self.compRContent = nil
  self.btnOK = nil
  self.rawImgFinalBtn = nil
  self.btnMvpGiftSend = nil
  self.imgMvpGiftSendIcon = nil
end

function UIDesertBattleResultS0View:UpdatePos()
  local localPos = self.root.transform:InverseTransformPoint(self.btnRight.transform.position)
  self.cheer2X, self.cheer2Y = localPos.x, localPos.y
end

function UIDesertBattleResultS0View:DataDefine()
  self.curIdx = 0
  self.giftEffectResList = {}
  self.timerList = {}
  local data = DataCenter.ActDragonManager:GetDragonRecord()
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  self.data = data[myAllianceId]
  local config = LuaEntry.DataConfig:GetValue("dragon_battle_base", "k18", "50,5")
  local values = string.string2array_i_oneSep(config, ",")
  self.expMax = values[1] or 50
  self.lvMax = values[2] or 5
  config = LuaEntry.DataConfig:GetValue("dragon_battle_base", "k19", "1,3")
  values = string.string2array_i_oneSep(config, ",")
  AUTO_CHEER_TIME_MIN = values[1] or 1
  AUTO_CHEER_TIME_MAX = values[2] or 3
  if IsTest() then
    if self.data == nil then
      for _, v in pairs(data) do
        self.data = v
        break
      end
    end
    local tb = string.string2table_ii_toList(DataCenter.ActDragonManager.TEST_PARAM, ",", "|")
    if tb[1] then
      if tb[1][1] then
        AUTO_CHEER_COUNT_MIN = tb[1][1]
      end
      if tb[1][2] then
        AUTO_CHEER_COUNT_MAX = tb[1][2]
      end
    end
    if tb[2] then
      if tb[2][1] then
        AUTO_CHEER2_COUNT_MIN = tb[2][1]
      end
      if tb[2][2] then
        AUTO_CHEER2_COUNT_MAX = tb[2][2]
      end
    end
  end
  self.curSliderNum = 0
  self.curLv = 0
  self.cheerIdx = 0
  self.rewardShowFlag = false
end

function UIDesertBattleResultS0View:DataDestroy()
  self.curIdx = 0
  self.data = nil
  self.curSliderNum = 0
  self.curLv = 0
  self.bestItems = nil
  self.cheerIdx = 0
  self.rewardShowFlag = false
  if IsTest() then
    DataCenter.ActDragonManager.TEST_PARAM = nil
  end
end

function UIDesertBattleResultS0View:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DragonResultCheersSuccess, self.OnCheersSuccess)
  self:AddUIListener(EventId.DragonResultCheersPush, self.OnCheersPush)
  self:AddUIListener(EventId.PushDragonGiftReceived, self.OnGiftPush)
  self:AddUIListener(EventId.OnReceiveGiftList, self.OnGiftListAnim)
end

function UIDesertBattleResultS0View:OnRemoveListener()
  self:RemoveUIListener(EventId.DragonResultCheersSuccess, self.OnCheersSuccess)
  self:RemoveUIListener(EventId.DragonResultCheersPush, self.OnCheersPush)
  self:RemoveUIListener(EventId.PushDragonGiftReceived, self.OnGiftPush)
  self:RemoveUIListener(EventId.OnReceiveGiftList, self.OnGiftListAnim)
  base.OnRemoveListener(self)
end

function UIDesertBattleResultS0View:OnBtnOKClick()
  self.ctrl:CloseSelf()
end

function UIDesertBattleResultS0View:OnBtnFinalClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self:ShowRewards()
end

function UIDesertBattleResultS0View:OnBtnRaycastClick()
end

function UIDesertBattleResultS0View:OnBtnInfoClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertBattleResultDetailData)
end

function UIDesertBattleResultS0View:OnBtnRightClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local et = self.cdSec2 == nil and curSec or self.cdSec2 + CHEER_ADD_2 + 1
  local leftTime = et - curSec
  if leftTime <= 0 then
    if IsTest() then
      self:OnCheersSuccess(2)
    else
      SFSNetwork.SendMessage(MsgDefines.DragonResultCheers, 2)
    end
  else
    local str = Localization:GetString("Desert_strom_tips1087", leftTime)
    UIUtil.ShowTips(str)
  end
end

function UIDesertBattleResultS0View:OnBtnLeftClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local et = self.cdSec1 == nil and curSec or self.cdSec1 + CHEER_ADD_1 + 1
  local leftTime = et - curSec
  if leftTime <= 0 then
    if IsTest() then
      self:OnCheersSuccess(1)
    else
      SFSNetwork.SendMessage(MsgDefines.DragonResultCheers, 1)
    end
  else
    local str = Localization:GetString("Desert_strom_tips1087", leftTime)
    UIUtil.ShowTips(str)
  end
end

function UIDesertBattleResultS0View:OnBtnPanelClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIQuickGift)
  self.compEffCheer:SetActive(false)
  self:CleanDelayAutoNext()
  self:AddLv()
  self.curIdx = self.curIdx + 1
  if BattleFieldUtil.isObserve and self.curIdx > 1 then
    self.ctrl:CloseSelf()
    return
  end
  if self.curIdx == 1 then
    self.compVictoryGo:SetActive(false)
    self.compLoseGo:SetActive(false)
    self.compMvp:SetActive(false)
    self:ShowSingleGiftSendBtn(false)
    self:ShowBestGroup()
  elseif self.curIdx == 2 then
    self.compBestGroup:SetActive(false)
    self:RefreshSelf()
  elseif self.curIdx == 3 then
    self.compBestSelf:SetActive(false)
    self:RefreshFinal()
  elseif self.curIdx == 4 then
    self:ShowRewards()
  end
end

function UIDesertBattleResultS0View:RefreshUI()
  self:PlayAnimOut()
  self:AutoSlider()
  self:AutoCheer()
  local pNumber = self.data ~= nil and self.data.currPlayerNum or 0
  self.textNum:SetText(pNumber or 0)
  self:ShowResult()
end

function UIDesertBattleResultS0View:ShowResult()
  self.compCheersContent:SetActive(false)
  local bWin = self.data ~= nil and self.data.win or 0
  self.compVictoryGo:SetActive(bWin ~= 0)
  self.compLoseGo:SetActive(bWin == 0)
  local animator = bWin == 0 and self.animatorLoseGo or self.animatorVictoryGo
  local inAnimStr = bWin == 0 and "V_ui_desert_defeat_in" or "V_ui_desert_victory_in"
  local outAnimStr = bWin == 0 and "V_ui_desert_defeat_out" or "V_ui_desert_victory_out"
  animator:Play(inAnimStr)
  self:ShowRaycast(2, false, function()
    self:LoadScene(function()
      animator:Play(outAnimStr)
    end, function()
      animator:SetActive(false)
      self:ShowMvp()
    end)
  end)
end

function UIDesertBattleResultS0View:ShowMvp()
  local mvpData = self.data ~= nil and self.data.mvp or nil
  if mvpData ~= nil then
    self.compMvp:SetData(mvpData, 1)
    self.compMvp:ShowSendGiftBtn(false)
    self.giftPlayerUid = mvpData.playerData and mvpData.playerData.uid or LuaEntry.Player:GetUid()
    self.compEffCheer:SetActive(true)
    self:ShowSingleGiftSendBtn(true)
    DataCenter.GiftSystemManager:GetPanelGift(self.giftPlayerUid, GiftSystemConst.GiftSendPanelType.Desert)
  end
  self:DelayAutoNext()
end

function UIDesertBattleResultS0View:ShowSingleGiftSendBtn(isShow)
  local isCanShowGift = DataCenter.GiftSystemManager:IsCanShowQuickBtn(GiftSystemConst.GiftSendPanelType.Desert)
  self.btnMvpGiftSend:SetActive(isCanShowGift and isShow)
end

function UIDesertBattleResultS0View:ShowBestGroup()
  local bestDatas = self.data ~= nil and self.data.bestGroup or {}
  if 0 < #bestDatas then
    self:PlaySceneAnim(1, function()
      self.compBestGroup:SetActive(true)
      local isCanShowGift = DataCenter.GiftSystemManager:IsCanShowQuickBtn(GiftSystemConst.GiftSendPanelType.Desert)
      for i = 1, 3 do
        local best = bestDatas[i]
        self.bestItems[i]:SetData(best, i + 1)
        if isCanShowGift then
          self.bestItems[i]:ShowSendGiftBtn(true)
        end
      end
      self.compEffCheer:SetActive(true)
      self:DelayAutoNext()
    end)
  else
    self:OnBtnPanelClick()
  end
end

function UIDesertBattleResultS0View:RefreshSelf()
  local myData = DataCenter.ActDragonManager:GetDragonSelfData()
  if myData ~= nil then
    self:PlaySceneAnim(2, function()
      self.giftPlayerUid = myData.playerData and myData.playerData.uid or LuaEntry.Player:GetUid()
      self.compBestSelf:SetData(myData, 0)
      self.compBestSelf:ShowSendGiftBtn(false)
      self.compEffCheer:SetActive(true)
    end)
    self:DelayAutoNext()
  else
    self:OnBtnPanelClick()
  end
end

function UIDesertBattleResultS0View:RefreshFinal()
  self:AddLv(true)
  self:PlaySceneAnim(1, function()
    self.compFinal:SetActive(true)
    self:DelayAutoNext()
  end)
end

function UIDesertBattleResultS0View:ShowRewards()
  if self.rewardShowFlag then
    self.ctrl:CloseSelf()
    return
  end
  local rewards = DataCenter.ActDragonManager:GetBattleResultReward()
  local cnt = rewards ~= nil and #rewards or 0
  if cnt == 0 then
    self.ctrl:CloseSelf()
    return
  end
  self.rewardShowFlag = true
  if NEW_REWARD_SHOW then
    self.compEffCheer:SetActive(true)
    self.compFinal:SetActive(false)
    self.btnLeft:SetActive(false)
    self.btnRight:SetActive(false)
    self.compCheersContent:SetActive(false)
    self.compReward:SetActive(true)
    self.rewards = {}
    for i, v in ipairs(rewards) do
      self.rewards[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
        if req.isError then
          return
        end
        local go = req.gameObject
        go.name = "Item" .. i
        go:SetActive(true)
        local tf = go.transform
        tf:SetParent(self.compRContent.transform)
        tf:Set_localScale(0.9, 0.9, 0.9)
        local cell = self.compRContent:AddComponent(UICommonResItem, go.name)
        cell:ReInit(v)
      end)
    end
  else
    self.rawImgFinalBtn:LoadSpriteAuto("Assets/Main/TextureEx/BF_Desert/part0/lrb_shamo_kaixiang.png")
    DataCenter.RewardManager:ShowCommonReward({reward = rewards})
  end
end

function UIDesertBattleResultS0View:AutoSlider()
  local time = MyRand(AUTO_CHEER_TIME_MIN, AUTO_CHEER_TIME_MAX)
  local count = MyRand(AUTO_CHEER2_COUNT_MIN, AUTO_CHEER2_COUNT_MAX)
  self.autoCheer2Timer = TimerManager:GetInstance():DelayInvoke(function()
    self.autoCheerList2 = {}
    for i = 1, count do
      local timer = TimerManager:GetInstance():DelayInvoke(function()
        self:AddCheerEff(2)
      end, i * time / count)
      table.insert(self.autoCheerList2, timer)
    end
    self:AutoSlider()
  end, time)
end

function UIDesertBattleResultS0View:AutoCheer()
  local time = MyRand(AUTO_CHEER_TIME_MIN, AUTO_CHEER_TIME_MAX)
  local count = MyRand(AUTO_CHEER_COUNT_MIN, AUTO_CHEER_COUNT_MAX)
  self.autoCheerTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.autoCheerList = {}
    for i = 1, count do
      local timer = TimerManager:GetInstance():DelayInvoke(function()
        self:AddCheerEff(1)
      end, i * time / count)
      table.insert(self.autoCheerList, timer)
    end
    self:AutoCheer()
  end, time)
end

function UIDesertBattleResultS0View:AddSlider(operate)
  if self.curLv == self.lvMax then
    return true
  end
  self.curSliderNum = self.curSliderNum + (operate == 1 and CHEER_ADD_1 or CHEER_ADD_2)
  if self.curSliderNum > self.expMax then
    self.curSliderNum = 0
    self.curLv = self.curLv + 1
  end
  local bFinish = false
  if self.curLv >= self.lvMax then
    self.curLv = self.lvMax
    self.curSliderNum = self.expMax
    bFinish = true
  end
  if self.textLv ~= nil then
    self.textLv:SetText(Localization:GetString(151116) .. self.curLv)
  end
  if self.slider ~= nil then
    self.slider:SetValue(self.curSliderNum / self.expMax)
  end
  return bFinish
end

function UIDesertBattleResultS0View:AddLv(toMax)
  if self.curLv == self.lvMax or toMax then
    self.curLv = self.lvMax
    self.curSliderNum = self.expMax
  else
    self.curLv = self.curLv + 1
    self.curSliderNum = 0
  end
  self.textLv:SetText(Localization:GetString(151116) .. self.curLv)
  self.slider:SetValue(self.curSliderNum / self.expMax)
end

function UIDesertBattleResultS0View:OnCheersSuccess(operate)
  if operate == 1 then
    self.cdSec1 = UITimeManager:GetInstance():GetServerSeconds()
  elseif operate == 2 then
    self.cdSec2 = UITimeManager:GetInstance():GetServerSeconds()
  end
  self:RefreshBtnCD()
end

function UIDesertBattleResultS0View:Update1000MS()
  self:RefreshBtnCD()
end

function UIDesertBattleResultS0View:RefreshBtnCD()
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local showCd, leftTime, cd = false, 0, 1
  if self.imgLeftCDFill then
    if self.cdSec1 then
      cd = CHEER_ADD_1 + 1
      leftTime = self.cdSec1 + cd - curSec
      showCd = 0 < leftTime
    end
    self.imgLeftCDFill:SetActive(showCd)
    self.textLeftCD:SetActive(showCd)
    if showCd then
      self.imgLeftCDFill:SetFillAmount(leftTime / cd)
      self.textLeftCD:SetText(leftTime .. "s")
    end
  end
  if self.imgRightCDFill then
    showCd, leftTime, cd = false, 0, 1
    if self.cdSec2 then
      cd = CHEER_ADD_2 + 1
      leftTime = self.cdSec2 + cd - curSec
      showCd = 0 < leftTime
    end
    self.imgRightCDFill:SetActive(showCd)
    self.textRightCD:SetActive(showCd)
    if showCd then
      self.imgRightCDFill:SetFillAmount(leftTime / cd)
      self.textRightCD:SetText(leftTime .. "s")
    end
  end
end

function UIDesertBattleResultS0View:OnCheersPush(param)
  local operate = param ~= nil and param.operate or 1
  local player = param ~= nil and param.player or nil
  self:AddCheerEff(operate, player)
end

function UIDesertBattleResultS0View:OnGiftListAnim(param)
  if not param or param.openType ~= GiftSystemConst.GiftSendPanelType.Desert then
    return
  end
  local giftList = param.giveInfo
  local playList = {}
  for _, info in ipairs(giftList) do
    for i = 1, info.number do
      table.insert(playList, {
        giftId = info.itemId,
        playerUid = info.suid
      })
    end
  end
  for index, data in ipairs(playList) do
    local delay = index * 0.5
    local timer = TimerManager:GetInstance():DelayInvoke(function()
      local showParam = {
        effectInfo = data,
        parent = self.compCheersContent
      }
      local res = DataCenter.GiftEffectManager:AddCheerEffect(showParam)
      table.insert(self.giftEffectResList, res)
    end, delay)
    table.insert(self.timerList, timer)
  end
end

function UIDesertBattleResultS0View:OnGiftPush(param)
  if not (param.targetUid and param.sendUid) or not param.giftId then
    return
  end
  local showParam = {
    effectInfo = {
      giftId = param.giftId,
      playerUid = param.sendUid
    },
    parent = self.compCheersContent
  }
  local res = DataCenter.GiftEffectManager:AddCheerEffect(showParam)
  table.insert(self.giftEffectResList, res)
end

function UIDesertBattleResultS0View:AddCheerEff(operate, player)
  if self.compCheersContent == nil then
    return
  end
  self:AddSlider(operate)
  local bL = MyRand(1, 100) > 50
  local cheerIdx = self.cheerIdx
  local fx, fy, moveTime
  local tarPos = Vector3.New(ResetPosition.x, ResetPosition.y + 1, ResetPosition.z)
  local hasPlayer = player ~= nil or IsTest()
  if operate == 1 then
    local rect = self.compCheersContent.rectTransform.rect
    local width = rect.width * 0.5
    if hasPlayer then
      fx = bL and 60 - width or width - 60
      fy = -150 + MyRand(0, 150)
    else
      fx = bL and 30 - width or width - 30
      fy = -250 + MyRand(0, 150)
    end
    tarPos.x = fx + (bL and 10 or -10)
    tarPos.y = fy + 10
    moveTime = 1.1
  else
    self:UpdatePos()
    local x, y = self.cheer2X, self.cheer2Y
    if hasPlayer then
      fx = bL and x + 50 or x - 50
      fy = y + 100
    else
      fx = x
      fy = y + 50
    end
    tarPos.x = fx + (bL and 50 or -50)
    tarPos.y = fy + 50
    moveTime = 1.1
  end
  self.cheerReqs[cheerIdx] = self:GameObjectInstantiateAsync(operate == 1 and CHEER1_PREFAB or CHEER2_PREFAB, function(req)
    if req.isError then
      self.cheerReqs[cheerIdx] = nil
      return
    end
    local go = req.gameObject
    go.name = "cheer_" .. cheerIdx
    go:SetActive(true)
    go.transform:Set_localScale(0.7, 0.7, 0.7)
    go.transform:SetParent(self.compCheersContent.transform)
    local theComp = self.compCheersContent:GetComponent(go.name, BattleCheer)
    if theComp == nil then
      theComp = self.compCheersContent:AddComponent(BattleCheer, go.name)
    end
    if theComp then
      theComp:SetData(bL, player, hasPlayer)
      theComp:SetLocalPositionXYZ(fx, fy, 0)
    end
    local tween = go.transform:DOLocalMove(tarPos, moveTime):SetDelay(0.1)
    tween:OnComplete(function()
      if self.compCheersContent ~= nil then
        self.compCheersContent:RemoveComponent(go.name, BattleCheer)
        req:Destroy()
        self.cheerReqs[cheerIdx] = nil
      end
    end)
  end)
  self.cheerIdx = self.cheerIdx + 1
end

function UIDesertBattleResultS0View:CleanDelayAutoNext()
  if self.delayAutoNext then
    self.delayAutoNext:Stop()
    self.delayAutoNext = nil
  end
end

function UIDesertBattleResultS0View:DelayAutoNext()
  self:CleanDelayAutoNext()
  self.delayAutoNext = TimerManager:GetInstance():DelayInvoke(function()
    if BattleFieldUtil.isObserve and self.curIdx > 0 then
      return
    end
    if not IsTest() then
      self:OnBtnPanelClick()
    end
  end, 10)
end

function UIDesertBattleResultS0View:ShowRaycast(delayTime, autoRaycast, cb)
  self.delayTime = delayTime or 3
  self.btnRaycast:SetActive(true)
  TimerManager:GetInstance():DelayInvoke(function()
    if self.rawImgScene == nil then
      return
    end
    if autoRaycast then
      self.btnRaycast:SetActive(false)
    end
    if cb then
      cb()
    end
  end, self.delayTime)
end

function UIDesertBattleResultS0View:PlayAnimIn(idx, cb)
  local animName = "V_ui_desert_star_move_mid"
  local delay = 0.5
  if idx == 1 then
    animName = "V_ui_desert_star_move_left"
    delay = 1
  elseif idx == 2 then
    animName = "V_ui_desert_star_move_right"
    delay = 1
  end
  self.animatorStar:SetActive(true)
  self.animatorStar:Play(animName)
  self:ShowRaycast(delay, true, function()
    self.animatorBattleResultS0:Play("V_ui_BattleResultS0_in")
    self.compExplode:SetActive(true)
    self.compCheersContent:SetActive(true)
    self:ShowRaycast(1, true)
    if cb then
      cb()
    end
  end)
end

function UIDesertBattleResultS0View:PlayAnimOut()
  self.animatorBattleResultS0:Play("V_ui_BattleResultS0_out")
  self.animatorStar:SetActive(false)
  self.compExplode:SetActive(false)
  self.compCheersContent:SetActive(false)
end

function UIDesertBattleResultS0View:CleanScene()
  if self.camera ~= nil then
    self.camera.targetTexture = nil
  end
  self.rawImgScene:SetTexture(nil)
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
  if self.scene ~= nil then
    self.scene:Destroy()
    self.scene = nil
  end
end

function UIDesertBattleResultS0View:LoadScene(loadCb, finishCb)
  self.scene = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/World/BF_Desert/Eff_ui_desert_result_scene.prefab")
  self.scene:completed("+", function()
    if self.scene.isError then
      return
    end
    if loadCb then
      loadCb()
    end
    local go = self.scene.gameObject
    local tf = go.transform
    go.name = "Desert_result_scene"
    go:SetActive(true)
    tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local pos = Vector3.New(-5000, 0, -5000)
    tf.position = pos
    self.camera = tf:Find("Sc_Root/Cam/Camera"):GetComponent(typeof(Camera))
    self.sceneAnim = tf:Find("Sc_Root"):GetComponent(typeof(CS.UnityEngine.Animator))
    self:OnRenderTexture(self.camera)
    self:PlaySceneAnim(0, finishCb)
  end)
end

function UIDesertBattleResultS0View:OnRenderTexture(camera)
  if camera == nil then
    Logger.LogError("UIDesertBattleResultS0View:OnRenderTexture camera is nil!")
    return
  end
  if self.renderTexture == nil then
    local rect = self.rawImgScene.rectTransform.rect
    self.renderTexture = RenderTexture.GetTemporary(toInt(rect.width), toInt(rect.height), 24, RenderTextureFormat.ARGB32)
    self.renderTexture.name = "ResultStar"
    self.rawImgScene:SetTexture(self.renderTexture)
    self.rawImgScene:SetActive(true)
    self.rawImgScene:SetColorRGBA(1, 1, 1, 1)
  end
  camera.targetTexture = self.renderTexture
end

function UIDesertBattleResultS0View:PlaySceneAnim(idx, cb)
  if self.scene == nil or IsNull(self.scene.gameObject) or self.sceneAnim == nil then
    return
  end
  if idx ~= 0 then
    self:PlayAnimOut()
  end
  local str, time
  if idx == 0 then
    str = "SC_Ani"
    time = 3.4
  elseif idx == 1 then
    str = "SC_Ani_02"
    time = 0.15
  else
    str = "SC_Ani_03"
    time = 0
  end
  self.sceneAnim:Play(str, 0, 0)
  self:ShowRaycast(time, true, function()
    self:PlayAnimIn(idx, cb)
  end)
end

return UIDesertBattleResultS0View
