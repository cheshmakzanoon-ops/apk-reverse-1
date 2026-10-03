local DesertBattleMainBattle = BaseClass("DesertBattleMainBattle", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.ActDragonManager
local UITimeMgr = UITimeManager:GetInstance()

function DesertBattleMainBattle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function DesertBattleMainBattle:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function DesertBattleMainBattle:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.attack_vs_user = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.attack_vs_score = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.text_finish_attack_vs = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.vs = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.flag_icon1 = self.viewSkin:AddComponent(self, UIImage, 5)
  self.flag_icon2 = self.viewSkin:AddComponent(self, UIImage, 6)
  self.server1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.server2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.name1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.name2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.count21 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.count11 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.count22 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.count12 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
end

function DesertBattleMainBattle:ComponentDestroy()
  self.viewSkin = nil
  self.attack_vs_user = nil
  self.attack_vs_score = nil
  self.text_finish_attack_vs = nil
  self.vs = nil
  self.flag_icon1 = nil
  self.flag_icon2 = nil
  self.server1 = nil
  self.server2 = nil
  self.name1 = nil
  self.name2 = nil
  self.count21 = nil
  self.count11 = nil
  self.count22 = nil
  self.count12 = nil
end

function DesertBattleMainBattle:DataDefine()
end

function DesertBattleMainBattle:DataDestroy()
  self.mainComp = nil
end

function DesertBattleMainBattle:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DragonScoreRefresh, self.ShowVSAlliance)
end

function DesertBattleMainBattle:OnRemoveListener()
  self:RemoveUIListener(EventId.DragonScoreRefresh, self.ShowVSAlliance)
  base.OnRemoveListener(self)
end

function DesertBattleMainBattle:SetMain(comp)
  self.mainComp = comp
end

function DesertBattleMainBattle:UpdateData()
  if not self:AsyncLoadDone() then
    return
  end
  self.isBattleOpen = false
  local actInfo = self.actInfo
  if self.mainComp == nil or self.mainComp:CheckDsbAct() or actInfo == nil or actInfo.stopSignUpTime == nil or actInfo.actEndTime ~= nil or not LuaEntry.Player:IsInAlliance() then
    self:ShowEnd()
    return
  end
  local curTime = UITimeMgr:GetServerTime()
  if curTime <= actInfo.stopSignUpTime then
    self:ShowEnd()
    return
  end
  local groupInfo = self.dragonInfo
  local signUp = groupInfo ~= nil and groupInfo.signUp or 0
  if signUp == ActMgr.SignUpState.NoSignUp then
    return
  end
  local timeInfo = groupInfo ~= nil and groupInfo.timeInfo or nil
  if curTime <= actInfo.marchEndTime then
  elseif curTime <= actInfo.battleOpenTime or timeInfo ~= nil and curTime <= timeInfo.prepTime or timeInfo ~= nil and curTime <= timeInfo.battleOpenTime or timeInfo ~= nil and curTime <= timeInfo.endTime then
    self.isBattleOpen = true
  else
    self:ShowEnd()
    return
  end
  self:ShowVSAlliance()
  local matchResult = groupInfo ~= nil and groupInfo.matchResult or 0
  if matchResult == 2 or matchResult == 3 or matchResult == 4 then
    self.attack_vs_user:SetActive(false)
    self.attack_vs_score:SetActive(false)
    self.text_finish_attack_vs:SetActive(true)
    self.text_finish_attack_vs:SetLocalText(matchResult == 4 and "Desert_strom_interface_1004" or "458272")
  end
end

function DesertBattleMainBattle:ShowVSAlliance()
  if not self:AsyncLoadDone() or self.mainComp == nil then
    return
  end
  local groupInfo = self.dragonInfo
  local vsInfoArr = groupInfo ~= nil and groupInfo.vsInfoArr or 0
  if table.IsNullOrEmpty(vsInfoArr) then
    self.vs:SetActive(false)
    self.attack_vs_user:SetActive(false)
    self.attack_vs_score:SetActive(false)
    self.text_finish_attack_vs:SetActive(true)
    return
  end
  self.vs:SetActive(true)
  self.attack_vs_user:SetActive(true)
  self.attack_vs_score:SetActive(true)
  self.text_finish_attack_vs:SetActive(false)
  local BattleInfo = ActMgr:GetBattleInfo(self.mainComp.curTabIdx)
  local selfScore, otherScore = 0, 0
  if BattleInfo ~= nil then
    selfScore = BattleInfo.selfSideScore or 0
    otherScore = BattleInfo.otherSideScore or 0
  else
    local curTime = UITimeMgr:GetServerTime()
    self.mainComp:TryReqBattleInfo(curTime)
  end
  local tmpState = 0
  if ActMgr:CanShowEnter(true, self.mainComp.curTabIdx) then
    tmpState = 1
  end
  for i = 1, 2 do
    local v = vsInfoArr[i]
    if v and v.allianceId == LuaEntry.Player:GetAllianceUid() then
      self.flag_icon1:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, tostring(v.icon)))
      self.server1:SetText("#" .. v.serverId)
      self.name1:SetText(v:GetFullName())
      if tmpState == 1 then
        self.count11:SetText(v.battleNum)
      elseif tmpState == 2 then
        self.count11:SetText(v.currPlayerNum)
      else
        self.count11:SetLocalText("Desert_strom_tips1023", v.mainNum)
      end
      self.count12:SetText(selfScore)
    elseif v ~= nil then
      self.flag_icon2:SetActive(true)
      self.flag_icon2:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, tostring(v.icon)))
      if self.isBattleOpen then
        self.server2:SetText("#" .. v.serverId)
        self.name2:SetText(v:GetFullName())
      else
        self.server2:SetText("")
        self.name2:SetText("")
      end
      if tmpState == 1 then
        self.count21:SetText(v.battleNum)
      elseif tmpState == 2 then
        self.count21:SetText(v.currPlayerNum)
      else
        self.count21:SetLocalText("Desert_strom_tips1023", v.mainNum)
      end
      self.count22:SetText(otherScore)
    else
      self.flag_icon2:SetActive(false)
      self.server2:SetText("")
      self.name2:SetText("")
      self.count21:SetText("")
      self.count22:SetText("")
    end
  end
end

function DesertBattleMainBattle:ShowEnd()
  self.vs:SetActive(false)
  self.attack_vs_user:SetActive(false)
  self.attack_vs_score:SetActive(false)
  self.text_finish_attack_vs:SetActive(true)
  self.text_finish_attack_vs:SetLocalText(458272)
end

local function getter_curTabIdx(self)
  return self.mainComp ~= nil and self.mainComp.curTabIdx or 0
end

local function getter_actInfo(self)
  return self.mainComp ~= nil and self.mainComp.actInfo
end

local function getter_dragonInfo(self)
  return self.mainComp ~= nil and self.mainComp.dragonInfo
end

DesertBattleMainBattle.getters.curTabIdx = getter_curTabIdx
DesertBattleMainBattle.getters.actInfo = getter_actInfo
DesertBattleMainBattle.getters.dragonInfo = getter_dragonInfo
return DesertBattleMainBattle
