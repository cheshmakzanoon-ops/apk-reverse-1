local LWMainDesertBattleInfo = BaseClass("LWMainDesertBattleInfo", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local blue_path = "flag/blue"
local num_blue_path = "flag/blue/num_blue"
local num_add_blue_path = "flag/blue/num_add_blue"
local red_path = "flag/red"
local num_red_path = "flag/red/num_red"
local num_add_red_path = "flag/red/num_add_red"
local user1_path = "blue/user1"
local speed1_path = "blue/speed1"
local user2_path = "red/user2"
local speed2_path = "red/speed2"
local time_path = "time"
local change_path = "change"
local tips_path = "tips"
local preparation_path = "tips/preparation"

function LWMainDesertBattleInfo:OnCreate()
  base.OnCreate(self)
  self.bMain = false
  self.num1 = self:AddComponent(UITextMeshProUGUIEx, num_blue_path)
  self.num2 = self:AddComponent(UITextMeshProUGUIEx, num_red_path)
  self.user1 = self:AddComponent(UITextMeshProUGUIEx, user1_path)
  self.user2 = self:AddComponent(UITextMeshProUGUIEx, user2_path)
  self.speed1 = self:AddComponent(UITextMeshProUGUIEx, speed1_path)
  self.speed2 = self:AddComponent(UITextMeshProUGUIEx, speed2_path)
  self.remain_time = self:AddComponent(UITextMeshProUGUIEx, time_path)
  self.change = self:AddComponent(UITextMeshProUGUIEx, change_path)
  self.tips = self:AddComponent(UIImage, tips_path)
  self.preparation = self:AddComponent(UITextMeshProUGUIEx, preparation_path)
  self.battle_info = self:AddComponent(UIButton, "")
  self.battle_info:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertBattleStatus)
  end)
  self.blue_num_root = self:AddComponent(UIBaseContainer, blue_path)
  self.red_num_root = self:AddComponent(UIBaseContainer, red_path)
  self.theBlueItem = self.transform:Find(num_add_blue_path).gameObject
  self.theBlueItem:GameObjectCreatePool()
  self.theRedItem = self.transform:Find(num_add_red_path).gameObject
  self.theRedItem:GameObjectCreatePool()
  self.ColorGreen = UIUtil.HexToColor("5fef87")
  self.ColorRed = UIUtil.HexToColor("f97077")
end

function LWMainDesertBattleInfo:OnDestroy()
  self.bMain = false
  self.theBlueItem:GameObjectRecycleAll()
  self.theRedItem:GameObjectRecycleAll()
  base.OnDestroy(self)
end

function LWMainDesertBattleInfo:OnEnable()
  base.OnEnable(self)
  DataCenter.ActDragonManager:UpdateMapBR()
  local BattleInfo = DataCenter.ActDragonManager:GetCurBattleInfo()
  if BattleInfo == nil then
    local group = DataCenter.ActDragonManager:GetCurGroupIdx()
    SFSNetwork.SendMessage(MsgDefines.DragonBattleInfo, group)
  end
  self:OnScoreRefresh()
  self:Update1000MS()
end

function LWMainDesertBattleInfo:OnDisable()
  base.OnDisable(self)
end

function LWMainDesertBattleInfo:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DragonScoreRefresh, self.OnScoreRefresh)
  self:AddUIListener(EventId.DragonPlayerNumRefresh, self.OnScoreRefresh)
end

function LWMainDesertBattleInfo:OnRemoveListener()
  self:RemoveUIListener(EventId.DragonScoreRefresh, self.OnScoreRefresh)
  self:RemoveUIListener(EventId.DragonPlayerNumRefresh, self.OnScoreRefresh)
  base.OnRemoveListener(self)
end

function LWMainDesertBattleInfo:OnScoreRefresh()
  local BattleInfo = DataCenter.ActDragonManager:GetCurBattleInfo()
  if BattleInfo == nil then
    return
  end
  local vsInfoArr = BattleInfo.vsInfoArr
  if vsInfoArr ~= nil then
    local tAllianceId = 0
    local detailInfo = BattleFieldUtil.GetDetailInfoByCfgId(10040)
    if detailInfo ~= nil then
      tAllianceId = detailInfo.AllianceId
    end
    for i, v in pairs(vsInfoArr) do
      if i == LuaEntry.Player:GetAllianceUid() then
        self.user1:SetText(v.currPlayerNum or 0)
        self.speed1:SetText("+" .. (v.pointAdd or 0) .. "/s")
        local effNum = BattleFieldUtil.GetEffectById(EffectDefine.LW_DRAGON_PRODUCE_ADD_PERCENT)
        local bMyUp = tAllianceId == i and effNum ~= nil and 0 < effNum
        self.speed1:SetColor(bMyUp and WorldGreenColor or WorldWhiteColor)
        self:SetBlueSideScore(BattleInfo.selfSideScore or 0, BattleInfo.changeType or -1)
      else
        self.user2:SetText(v.currPlayerNum or 0)
        self.speed2:SetText("+" .. (v.pointAdd or 0) .. "/s")
        local bEnemyUp = tAllianceId == i
        self.speed2:SetColor(bEnemyUp and WorldGreenColor or WorldWhiteColor)
        self:SetRedSideScore(BattleInfo.otherSideScore or 0, BattleInfo.changeType or -1)
      end
    end
  end
end

local anim_count = 1

function LWMainDesertBattleInfo:ShowAnim(parent, node, value)
  if node and parent and parent.transform and value and value ~= 0 then
    local goItem = node:GameObjectSpawn(parent.transform)
    if goItem then
      goItem.name = "anim" .. anim_count
      anim_count = anim_count + 1
      do
        local theItem = parent:AddComponent(UITextMeshProUGUIEx, goItem.name)
        if theItem then
          if 0 < value then
            theItem:SetText("+" .. value)
          else
            theItem:SetText(tostring(value))
          end
          theItem:SetActive(true)
          theItem:SetLocalPositionXYZ(0, 0, 0)
          theItem:SetAlpha(1)
          theItem.transform:DOLocalMoveY(100, 1.5)
          theItem.unity_tmpro:DOFade(0, 1.5)
          local sequence = CS.DG.Tweening.DOTween.Sequence()
          sequence:AppendInterval(1.6)
          sequence:AppendCallback(function()
            if parent ~= nil and not IsNull(parent.gameObject) then
              parent:RemoveComponent(goItem.name, UITextMeshProUGUIEx)
              if parent:GetComponentsCount() == 0 then
                parent:RemoveAllComponentes()
              end
              goItem:GameObjectRecycle()
            end
          end)
        else
          goItem:GameObjectRecycle()
        end
      end
    end
  end
end

function LWMainDesertBattleInfo:SetBlueSideScore(score, changeType)
  if self.theScoreBlue == score then
    return
  end
  self.num1:SetText(string.GetFormattedSeparatorNum(score))
  if self.theScoreBlue ~= nil then
    self:ShowAnim(self.blue_num_root, self.theBlueItem, score - self.theScoreBlue)
  end
  self.theScoreBlue = score
  self:RefreshChange()
end

function LWMainDesertBattleInfo:SetRedSideScore(score, changeType)
  if self.theScoreRed == score then
    return
  end
  self.num2:SetText(string.GetFormattedSeparatorNum(score))
  if self.theScoreRed ~= nil then
    self:ShowAnim(self.red_num_root, self.theRedItem, score - self.theScoreRed)
  end
  self.theScoreRed = score
  self:RefreshChange()
end

function LWMainDesertBattleInfo:RefreshChange()
  local value = 0
  if self.theScoreBlue ~= nil and self.theScoreRed ~= nil then
    value = self.theScoreBlue - self.theScoreRed
  end
  self.change:SetActive(value ~= 0)
  if value == 0 then
    return
  end
  local valueStr = string.GetFormattedSeparatorNum(value)
  local color
  if 0 < value then
    valueStr = "+" .. valueStr
    color = self.ColorGreen
  else
    color = self.ColorRed
  end
  self.change:SetText(valueStr)
  self.change:SetColor(color)
end

function LWMainDesertBattleInfo:Update1000MS()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local groupInfo = DataCenter.ActDragonManager:GetCurGroup()
  local timeInfo = groupInfo ~= nil and groupInfo.timeInfo or nil
  if timeInfo ~= nil then
    if timeInfo.endTime ~= nil then
      local remainTime = timeInfo.endTime - curTime
      if 0 < remainTime then
        self.remain_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
      else
        self.remain_time:SetText("")
      end
    end
    if timeInfo.battleOpenTime ~= nil and curTime <= timeInfo.battleOpenTime then
      self.tips:SetActive(true)
      self.preparation:SetText(Localization:GetString("458119") .. "\n" .. UITimeManager:GetInstance():MilliSecondToFmtString(timeInfo.battleOpenTime - curTime))
    else
      self.tips:SetActive(false)
    end
  else
    self.remain_time:SetText("")
  end
  self:CheckEnd(curTime, groupInfo)
end

function LWMainDesertBattleInfo:SetMain(bMain)
  self.bMain = bMain
end

function LWMainDesertBattleInfo:CheckEnd(curTime, groupInfo)
  if not self.bMain then
    return
  end
  local bEnd = false
  local timeInfo = groupInfo ~= nil and groupInfo.timeInfo or nil
  local endTime = timeInfo ~= nil and timeInfo.endTime or 0
  if curTime > endTime then
    bEnd = true
  end
  if bEnd then
    local uiMgr = UIManager:GetInstance()
    if uiMgr:IsWindowOpen(UIWindowNames.UIDesertBattleResultS0) or uiMgr:IsWindowOpen(UIWindowNames.UIDesertBattleResultDetailData) then
      return
    end
    if self.signTime == nil then
      self.signTime = curTime
      return
    end
  else
    self.signTime = nil
    return
  end
  if curTime - self.signTime < 5000 then
    return
  end
  self.signTime = curTime
  BattleFieldUtil.BackToCity(BattleFieldType.Desert)
end

return LWMainDesertBattleInfo
