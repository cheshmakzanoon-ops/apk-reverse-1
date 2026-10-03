local base = UIAsyncContainer
local LLMainBattle = BaseClass("LLMainBattle", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr
local BUILD_CLS = "UI.Landlord.Main.Component.LLBuildItem"
local BUILD_PREFAB = "Assets/Main/Prefabs/UI/Landlord/LLBuildItem.prefab"
local INFO_CLS = "UI.Landlord.Main.Component.LLMainBattleInfo"
local INFO_PREFAB = "Assets/Main/Prefabs/UI/Landlord/LLMainBattleInfo.prefab"
local SCORE_CLS = "UI.Landlord.Main.Component.LLMainBattleScore"
local SCORE_PREFAB = "Assets/Main/Prefabs/UI/Landlord/LLMainBattleScore.prefab"
local ICON_RED_PATH = "lrb_jinmai_beizhan_pocheng_hong.png"
local ICON_BLUE_PATH = "lrb_jinmai_beizhan_pocheng_lan.png"
local FILL_RED_PATH = "lrb_tongyong_jindutiao_hong.png"
local FILL_BLUE_PATH = "lyp_tongyong_jindutiao_lan.png"
local EffBasePath = "Assets/Main/Prefabs/Effect/Landlord/Eff_ui_LLBattle_%slayer_%s.prefab"

function LLMainBattle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLMainBattle:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLMainBattle:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compCenter = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.slider = self.viewSkin:AddComponent(self, UISlider, 2)
  self.imgFill = self.viewSkin:AddComponent(self, UIImage, 3)
  self.textPercent = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 5)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.btnRank = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.btnRecord = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnRecord:SetOnClick(function()
    self:OnBtnRecordClick()
  end)
  self.btnGo = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.compTips1 = self.viewSkin:AddComponent(self, UIBaseComponent, 12)
  self.compTips2 = self.viewSkin:AddComponent(self, UIBaseComponent, 13)
  self.compTips3 = self.viewSkin:AddComponent(self, UIBaseComponent, 14)
  self.compPreTips = self.viewSkin:AddComponent(self, UIBaseComponent, 15)
  self.textPreTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.btnSTips = self.viewSkin:AddComponent(self, UIButton, 17)
  self.btnSTips:SetOnClick(function()
    self:OnBtnSTipsClick()
  end)
  self.btnSlider = self.viewSkin:AddComponent(self, UIButton, 18)
  self.btnSlider:SetOnClick(function()
    self:OnBtnSliderClick()
  end)
  self.compDi = self.viewSkin:AddComponent(self, UIBaseComponent, 19)
  self.btnSGo = self.viewSkin:AddComponent(self, UIButton, 20)
  self.btnSGo:SetOnClick(function()
    self:OnBtnSGoClick()
  end)
  self.compTipsList = {
    self.compTips1,
    self.compTips2,
    self.compTips3
  }
end

function LLMainBattle:ComponentDestroy()
  self.viewSkin = nil
  self.compCenter = nil
  self.slider = nil
  self.imgFill = nil
  self.textPercent = nil
  self.imgIcon = nil
  self.textTitle = nil
  self.textTime = nil
  self.btnInfo = nil
  self.btnRank = nil
  self.btnRecord = nil
  self.btnGo = nil
  self.compTips1 = nil
  self.compTips2 = nil
  self.compTips3 = nil
  self.compPreTips = nil
  self.textPreTips = nil
  self.btnSTips = nil
  self.btnSlider = nil
  self.compDi = nil
  self.btnSGo = nil
  self.compTipsList = nil
end

function LLMainBattle:DataDefine()
  self.effWeekGoList = {}
  self.effWeekReqList = {}
  self.btnSTips:SetActive(false)
  local k11 = LuaEntry.DataConfig:TryGetStr("zonewar_landlord", "k11")
  self.textPreTips:SetLocalText("zonewar_landlord_desc_1041", k11)
  self.bottomItems = {}
  self.buildItems = {}
  self.buildItemsDelays = {}
end

function LLMainBattle:DataDestroy()
  if self.buildItemsDelays ~= nil then
    for _, v in pairs(self.buildItemsDelays) do
      if v ~= nil then
        v:Stop()
      end
    end
    self.buildItemsDelays = nil
  end
  if self.effWeekReqList ~= nil then
    for _, v in pairs(self.effWeekReqList) do
      if v ~= nil then
        v:Destroy()
      end
    end
    self.effWeekReqList = nil
  end
  self.effWeekGoList = nil
  self:CleanDelay()
  self.eTime = nil
  self.bottomItems = nil
  self.buildItems = nil
  self.baseRoot = nil
  self.initShow = false
end

function LLMainBattle:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LandlordActBattleInfo, self.OnActBattleInfoRefresh)
end

function LLMainBattle:OnRemoveListener()
  self:RemoveUIListener(EventId.LandlordActBattleInfo, self.OnActBattleInfoRefresh)
  base.OnRemoveListener(self)
end

function LLMainBattle:OnBtnInfoClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLRule)
end

function LLMainBattle:OnBtnRankClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLRank)
end

function LLMainBattle:OnBtnRecordClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLBattleDetail)
end

function LLMainBattle:OnBtnGoClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  ActMgr:ReqMaxDestroyCity()
end

function LLMainBattle:OnBtnSTipsClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.btnSTips:SetActive(false)
end

function LLMainBattle:OnBtnSGoClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.btnSTips:SetActive(false)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLRule, {anim = true}, LLConst.RuleType.BattleAtk)
end

function LLMainBattle:OnBtnSliderClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.btnSTips:SetActive(true)
end

function LLMainBattle:OnActBattleInfoRefresh()
  local info = ActMgr:GetActCurStageInfo()
  local stage = info ~= nil and info.stage or LLConst.LandlordStage.PREVIEW
  self.curStage = stage
  self:RefreshCenter(stage)
end

function LLMainBattle:OnEnable()
  base.OnEnable(self)
  self.btnSTips:SetActive(false)
end

function LLMainBattle:SetView(view, refreshCur)
  self.baseRoot = view
  self.refreshCur = refreshCur
  if not refreshCur then
    self.initShow = true
    if self.buildItemsDelays ~= nil then
      for _, v in pairs(self.buildItemsDelays) do
        if v ~= nil then
          v:Stop()
        end
      end
    end
    self.buildItemsDelays = {}
  end
  self:SetActive(true)
  self:RefreshView()
end

function LLMainBattle:TryUpdateBattleInfo(curSec, bFastCheck)
  local checkTime = bFastCheck and 5 or 30
  if self.lastReqBITime == nil or checkTime < curSec - self.lastReqBITime then
    ActMgr:ReqActBattleInfo()
    self.lastReqBITime = curSec
  end
end

function LLMainBattle:UpdateData()
  if self.baseRoot == nil then
    return
  end
  local info = ActMgr:GetActCurStageInfo()
  local stage = info ~= nil and info.stage or LLConst.LandlordStage.GROUP
  self.curStage = stage
  self.eTime = info ~= nil and info.eTime or 0
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  self:TryUpdateBattleInfo(curSec, self.curStage == LLConst.LandlordStage.BATTLE)
  self:CleanDelay()
  self:RefreshTop()
  self:RefreshCenter(stage)
  self:RefreshBottom(stage)
  self:Update1000MS()
end

function LLMainBattle:CleanDelay()
  if self.preTipsDelay ~= nil then
    self.preTipsDelay:Stop()
    self.preTipsDelay = nil
  end
  if self.unlockTipsDelay ~= nil then
    self.unlockTipsDelay:Stop()
    self.unlockTipsDelay = nil
  end
end

function LLMainBattle:RefreshTop()
  local group = ActMgr:GetMyGroup()
  local bLord = group == LLConst.LandLordGroup.LORD
  self.imgFill:LoadSpriteAuto(string.format(LoadPath.CommonNewPath, bLord and FILL_RED_PATH or FILL_BLUE_PATH))
  self.imgIcon:LoadSpriteAuto(string.format(LoadPath.LandlordPath, bLord and ICON_RED_PATH or ICON_BLUE_PATH))
  if self.baseRoot.curIdx == 3 then
    for _, v in ipairs(self.compTipsList) do
      v:SetActive(false)
    end
    local bInBattle = ActMgr:IsInBattle()
    local eTime
    if bInBattle then
      eTime = ActMgr:GetNextBattleEndTime(true)
    else
      eTime = ActMgr:GetNextBattleStartTime(true)
    end
    self.eTime = eTime
    self.textTime.transform.parent.gameObject:SetActive(0 < eTime)
    if eTime == 0 then
      self.textTitle:SetLocalText("zonewar_landlord_limit_1084")
    else
      self.textTitle:SetLocalText(bInBattle and "zonewar_landlord_limit_1069" or "zonewar_landlord_limit_1049")
    end
  else
    local curWeek = ActMgr:GetCurWeek()
    for i, v in ipairs(self.compTipsList) do
      v:SetActive(curWeek == i)
      if curWeek == i then
        local key = "LL_BATTLE_UNLOCK_TIP_WEEK" .. i
        local signTime = CommonUtil.PlayerPrefsGetInt(key, 0)
        local actData = ActMgr:GetActData()
        local actETime = actData ~= nil and actData.endTime or 0
        if signTime < actETime then
          v:SetActive(true)
          CommonUtil.PlayerPrefsSetInt(key, actETime)
          self.unlockTipsDelay = TimerManager:GetInstance():DelayInvoke(function()
            v:SetActive(false)
            self.unlockTipsDelay = nil
          end, 5)
        else
          v:SetActive(false)
        end
      else
        v:SetActive(false)
      end
    end
    self.textTitle:SetLocalText("zonewar_landlord_limit_1070")
    self.textTime.transform.parent.gameObject:SetActive(false)
  end
end

function LLMainBattle:RefreshCenter(stage)
  self:RefreshCenterEff()
  local destroyScore = ActMgr:GetDestroyScore()
  local destroyScoreMax = ActMgr:GetCityDestroyScoreMax()
  self.slider:SetValue(destroyScore / destroyScoreMax)
  self.textPercent:SetText(destroyScore)
  local dic = ActMgr:GetBattleTable()
  for k, v in pairs(dic) do
    local comp = self.buildItems[k]
    if comp ~= nil then
      comp:SetTemplate(v, stage)
    else
      comp = self:LoadComponentAsync(BUILD_CLS, BUILD_PREFAB, self.compCenter.transform)
      comp:SetName("BuildItem_" .. k)
      comp:SetTemplate(v, stage)
      self.buildItems[k] = comp
    end
    if self.initShow then
      comp:SetActive(false)
      do
        local cfgId = v.city_id
        local cityConfig = ActMgr:GetCityTemplate(cfgId)
        local unlockWeek = math.max(cityConfig ~= nil and cityConfig.unlock_week or 0, 1)
        local id = k
        self.buildItemsDelays[id] = TimerManager:GetInstance():DelayInvoke(function()
          self.buildItemsDelays[id] = nil
          comp:SetActive(true)
        end, 0.1 * (unlockWeek - 1))
      end
    end
  end
  self.initShow = false
end

function LLMainBattle:RefreshCenterEff()
  local max = ActMgr:GetBattleWeek()
  local curWeek = ActMgr:GetCurWeek()
  for i = 1, max do
    local weekGo = self.effWeekGoList[i]
    if weekGo then
      weekGo:SetActive(i <= curWeek)
    elseif i <= curWeek and not self.effWeekReqList[i] then
      local idx = i
      local group = ActMgr:GetMyGroup()
      local path = string.format(EffBasePath, idx, group == LLConst.LandLordGroup.LORD and "blue" or "red")
      self.effWeekReqList[idx] = self:GameObjectInstantiateAsync(path, function(req)
        local go = req.gameObject
        if req.isError or IsNull(go) then
          req:Destroy()
          self.effWeekReqList[idx] = nil
          return
        end
        go.name = "EffWeek_" .. idx
        go:SetActive(true)
        self.effWeekGoList[idx] = go
        local tf = go.transform
        tf.parent = self.compDi.transform
        tf:Reset()
      end)
    end
  end
end

function LLMainBattle:RefreshBottom(stage)
  local bIdx3 = self.baseRoot.curIdx == 3
  local passGroup = stage > LLConst.LandlordStage.GROUP
  self.btnRank:SetActive(bIdx3 and passGroup)
  self.btnRecord:SetActive(bIdx3 and passGroup)
  self.btnGo:SetActive(bIdx3)
  if bIdx3 and passGroup and self.curStage ~= LLConst.LandlordStage.BATTLE then
    local curWeek = ActMgr:GetCurWeek()
    local key = "LL_BATTLE_GO_TIP_WEEK" .. curWeek
    local signTime = CommonUtil.PlayerPrefsGetInt(key, 0)
    local actData = ActMgr:GetActData()
    local actETime = actData ~= nil and actData.endTime or 0
    if signTime < actETime then
      self.compPreTips:SetActive(true)
      CommonUtil.PlayerPrefsSetInt(key, actETime)
      self.preTipsDelay = TimerManager:GetInstance():DelayInvoke(function()
        self.compPreTips:SetActive(false)
        self.preTipsDelay = nil
      end, 5)
    else
      self.compPreTips:SetActive(false)
    end
  else
    self.compPreTips:SetActive(false)
  end
  local otherName = bIdx3 and "Info" or "Score"
  local comp = self.bottomItems[otherName]
  if comp ~= nil then
    comp:SetActive(false)
  end
  local name = bIdx3 and "Score" or "Info"
  comp = self.bottomItems[name]
  if comp == nil then
    local CLS = bIdx3 and SCORE_CLS or INFO_CLS
    local PREFAB = bIdx3 and SCORE_PREFAB or INFO_PREFAB
    comp = self:LoadComponentAsync(CLS, PREFAB, self.transform)
    comp:SetLocalPositionXYZ(0, bIdx3 and -370 or -470, 0)
    comp:SetSiblingIndex(1)
    comp:SetName(name)
    self.bottomItems[name] = comp
  end
  comp:RefreshCur(self.refreshCur)
  self.refreshCur = nil
end

function LLMainBattle:Update1000MS()
  if self.baseRoot == nil or self.eTime == nil or self.eTime == 0 then
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local remain = self.eTime - curSec
  if 0 < remain then
    self.textTime:SetText(UITimeManager:GetInstance():SecondToFmtString(remain))
    local bIdx2 = self.baseRoot.curIdx == 2
    if bIdx2 then
      if self.lastReqActTime == nil then
        self.lastReqActTime = curSec
      end
      if curSec - self.lastReqActTime > 30 then
        self.lastReqActTime = curSec
        self.baseRoot:TyrReqActInfo(curSec)
      end
    elseif self.curStage == LLConst.LandlordStage.BATTLE then
      self:TryUpdateBattleInfo(curSec, false)
    end
  else
    self.textTime:SetText(UITimeManager:GetInstance():SecondToFmtString(0))
    self.baseRoot:TyrReqActInfo(curSec)
  end
end

return LLMainBattle
