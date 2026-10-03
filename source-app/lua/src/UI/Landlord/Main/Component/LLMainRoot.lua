local base = require("UI.UIRaceEntrance.Component.ActDownloadNodeBase")
local LLMainRoot = BaseClass("LLMainRoot", base)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr
local NEWS_CLS = "UI.Landlord.Main.Component.LLMainNews"
local NEWS_PREFAB = "Assets/Main/Prefabs/UI/Landlord/LLMainNews.prefab"
local GROUP_CLS = "UI.Landlord.Main.Component.LLMainGroup"
local GROUP_PREFAB = "Assets/Main/Prefabs/UI/Landlord/LLMainGroup.prefab"
local BATTLE_CLS = "UI.Landlord.Main.Component.LLMainBattle"
local BATTLE_PREFAB = "Assets/Main/Prefabs/UI/Landlord/LLMainBattle.prefab"

function LLMainRoot:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLMainRoot:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLMainRoot:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compCenter = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.toggleToggle1 = self.viewSkin:AddComponent(self, UIToggle, 2)
  self.toggleToggle2 = self.viewSkin:AddComponent(self, UIToggle, 3)
  self.toggleToggle3 = self.viewSkin:AddComponent(self, UIToggle, 4)
  self.compRed3 = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.compRed1 = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.toggleToggleList = {
    self.toggleToggle1,
    self.toggleToggle2,
    self.toggleToggle3
  }
end

function LLMainRoot:ComponentDestroy()
  self.viewSkin = nil
  self.compCenter = nil
  self.toggleToggle1 = nil
  self.toggleToggle2 = nil
  self.toggleToggle3 = nil
  self.compRed3 = nil
  self.compRed1 = nil
  self.toggleToggleList = nil
end

function LLMainRoot:DataDefine()
  self:TyrReqActInfo(UITimeManager:GetInstance():GetServerSeconds(), true)
  local curStage = ActMgr:GetActCurStage()
  local curIdx = 1
  if curStage == LLConst.LandlordStage.BATTLE then
    curIdx = 3
  elseif curStage == LLConst.LandlordStage.PREPARE then
    curIdx = 2
  end
  if CommonUtil.IsDebug() and ActMgr.TEST_LL_NEWS then
    curIdx = 1
  end
  curIdx = Mathf.Clamp(curIdx, 1, #self.toggleToggleList)
  self.toggleToggleList[curIdx]:SetIsOn(true)
  for i, v in ipairs(self.toggleToggleList) do
    v:SetOnValueChanged(function(isOn)
      if isOn then
        self:OnToggleChanged(i)
      end
    end)
  end
  self:OnToggleChanged(curIdx, true)
  self:RefreshRed()
  local key = "LLFirstPlay"
  local firstFlag = CommonUtil.PlayerPrefsGetBool(key, false)
  if not firstFlag then
    local param = {
      howToPlayList = {500014}
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
    CommonUtil.PlayerPrefsSetBool(key, true)
  end
end

function LLMainRoot:DataDestroy()
  self.curIdx = nil
  self.curComp = nil
  self.compList = nil
end

function LLMainRoot:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LandlordActInfoRefresh, self.OnInfoRefresh)
  self:AddUIListener(EventId.LandlordActMainTabIndex, self.OnToggleChanged)
  self:AddUIListener(EventId.LandlordRedRefresh, self.RefreshRed)
end

function LLMainRoot:OnRemoveListener()
  self:RemoveUIListener(EventId.LandlordActInfoRefresh, self.OnInfoRefresh)
  self:RemoveUIListener(EventId.LandlordActMainTabIndex, self.OnToggleChanged)
  self:RemoveUIListener(EventId.LandlordRedRefresh, self.RefreshRed)
  base.OnRemoveListener(self)
end

function LLMainRoot:GetActType()
  return EnumActivity.ActLandlord.Type
end

function LLMainRoot:OnEnterNode()
end

function LLMainRoot:TyrReqActInfo(curSec, bForce)
  if bForce or self.lastReqTime == nil or curSec - self.lastReqTime >= 5 then
    self.lastReqTime = curSec
    ActMgr:ReqActInfo()
  end
end

function LLMainRoot:OnToggleChanged(idx, bForce)
  if not bForce and idx == self.curIdx then
    return
  end
  local curStage = ActMgr:GetActCurStage()
  if 1 < idx and curStage < LLConst.LandlordStage.GROUP then
    self.toggleToggleList[1]:SetIsOn(true)
    self:OnToggleChanged(1)
    UIUtil.ShowTipsId("zonewar_landlord_tips_1002")
    return
  end
  if self.curComp then
    self.curComp:SetActive(false)
  end
  self.curComp = nil
  self.curIdx = idx
  local compStageKey = self:FixCompStageKey()
  self:SetTargetShow(compStageKey)
end

function LLMainRoot:RefreshRed()
  local flag = ActMgr:CheckRed(1)
  self.compRed1:SetActive(flag)
  flag = ActMgr:CheckRed(3)
  self.compRed3:SetActive(flag)
end

function LLMainRoot:OnInfoRefresh()
  local compStageKey = self:FixCompStageKey()
  self:SetTargetShow(compStageKey, true)
  self:RefreshRed()
end

function LLMainRoot:FixCompStageKey()
  if self.curIdx == 1 and CommonUtil.IsDebug() and ActMgr.TEST_LL_NEWS ~= nil then
    return LLConst.LandlordStage.PREVIEW
  end
  local compStageKey
  if self.curIdx == 1 then
    local curStage = ActMgr:GetActCurStage()
    local previewFlag = curStage <= LLConst.LandlordStage.PREVIEW
    if not previewFlag and curStage == LLConst.LandlordStage.GROUP then
      previewFlag = ActMgr:CheckShowGroupNews()
    end
    compStageKey = previewFlag and LLConst.LandlordStage.PREVIEW or LLConst.LandlordStage.GROUP
  else
    compStageKey = LLConst.LandlordStage.BATTLE
  end
  return compStageKey
end

function LLMainRoot:SetTargetShow(compStageKey, refreshCur)
  self.compList = self.compList or {}
  local compStage = self.compList[compStageKey]
  if compStage ~= nil then
    self.curComp = compStage
    compStage:SetView(self, refreshCur)
    return
  end
  local cls, prefab
  if compStageKey == LLConst.LandlordStage.PREVIEW then
    cls = NEWS_CLS
    prefab = NEWS_PREFAB
  elseif compStageKey == LLConst.LandlordStage.GROUP then
    cls = GROUP_CLS
    prefab = GROUP_PREFAB
  elseif compStageKey == LLConst.LandlordStage.BATTLE then
    cls = BATTLE_CLS
    prefab = BATTLE_PREFAB
  end
  if cls == nil or prefab == nil then
    return
  end
  self.compList[compStageKey] = self:LoadComponentAsync(cls, prefab, self.compCenter, function(_, go, asyncComp)
    local x, y = asyncComp:GetOffsetMaxXY()
    asyncComp:SetOffsetMaxXY(x, -5)
    x, y = asyncComp:GetOffsetMinXY()
    asyncComp:SetOffsetMinXY(x, -5)
    if self:FixCompStageKey() ~= compStageKey then
      go:SetActive(false)
      return
    end
    self:SetTargetShow(compStageKey)
  end)
end

return LLMainRoot
