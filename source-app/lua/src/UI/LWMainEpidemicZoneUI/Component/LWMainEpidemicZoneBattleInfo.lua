local LWMainEpidemicZoneBattleInfo = BaseClass("LWMainEpidemicZoneBattleInfo", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.ActEpidemicZoneManager
local MyMin = math.min
local time_path = "time"
local blue_slider_path = "progressGo/mask/blueSlider"
local red_slider_path = "progressGo/mask/redSlider"
local num1_path = "blue/score1/scoreNum1"
local user1_path = "blue/userNum1"
local speed1_path = "blue/speed1"
local typeIcon1_path = "blue/TypeIcon1"
local flag11_path = "blue/AL1/flag11"
local abbr11_path = "blue/AL1/flag11/abbr11"
local flag12_path = "blue/AL1/flag12"
local abbr12_path = "blue/AL1/flag12/abbr12"
local user2_path = "red/userNum2"
local speed2_path = "red/speed2"
local num2_path = "red/score2/scoreNum2"
local typeIcon2_path = "red/TypeIcon2"
local flag21_path = "red/AL2/flag21"
local abbr21_path = "red/AL2/flag21/abbr21"
local flag22_path = "red/AL2/flag22"
local abbr22_path = "red/AL2/flag22/abbr22"
local tips_path = "tips"
local preparation_path = "tips/preparation"
local blue_num1_path = "blue/score1"
local red_num2_path = "red/score2"
local num_add_blue_path = "blue/score1/numAdd1"
local num_add_red_path = "red/score2/numAdd2"
local diff_text_path = "diffText"

function LWMainEpidemicZoneBattleInfo:OnCreate()
  base.OnCreate(self)
  self.bMain = false
  self.clickCB = nil
  self.battle_info = self:AddComponent(UIButton, "")
  self.battle_info:SetOnClick(function()
    if ActEpidemicUtils.InBattleGuide() then
      ActEpidemicUtils.ContinueBattleGuide()
      return
    end
    if self.clickCB then
      self.clickCB()
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIEpidemicBattleStatus)
    end
  end)
  self.remain_time = self:AddComponent(UITextMeshProUGUIEx, time_path)
  self.blue_slider = self:AddComponent(UISlider, blue_slider_path)
  self.red_slider = self:AddComponent(UISlider, red_slider_path)
  self.num1 = self:AddComponent(UITextMeshProUGUIEx, num1_path)
  self.num2 = self:AddComponent(UITextMeshProUGUIEx, num2_path)
  self.user1 = self:AddComponent(UITextMeshProUGUIEx, user1_path)
  self.user2 = self:AddComponent(UITextMeshProUGUIEx, user2_path)
  self.speed1 = self:AddComponent(UITextMeshProUGUIEx, speed1_path)
  self.speed2 = self:AddComponent(UITextMeshProUGUIEx, speed2_path)
  self.typeIcon1 = self:AddComponent(UIImage, typeIcon1_path)
  self.flag11 = self:AddComponent(UIBaseComponent, flag11_path)
  self.abbr11 = self:AddComponent(UITextMeshProUGUIEx, abbr11_path)
  self.flag12 = self:AddComponent(UIBaseComponent, flag12_path)
  self.abbr12 = self:AddComponent(UITextMeshProUGUIEx, abbr12_path)
  self.typeIcon2 = self:AddComponent(UIImage, typeIcon2_path)
  self.flag21 = self:AddComponent(UIBaseComponent, flag21_path)
  self.abbr21 = self:AddComponent(UITextMeshProUGUIEx, abbr21_path)
  self.flag22 = self:AddComponent(UIBaseComponent, flag22_path)
  self.abbr22 = self:AddComponent(UITextMeshProUGUIEx, abbr22_path)
  self.tips = self:AddComponent(UIImage, tips_path)
  self.preparation = self:AddComponent(UITextMeshProUGUIEx, preparation_path)
  self.blue_num_root = self:AddComponent(UIBaseContainer, blue_num1_path)
  self.red_num_root = self:AddComponent(UIBaseContainer, red_num2_path)
  self.theBlueItem = self.transform:Find(num_add_blue_path).gameObject
  self.theBlueItem:GameObjectCreatePool()
  self.theRedItem = self.transform:Find(num_add_red_path).gameObject
  self.theRedItem:GameObjectCreatePool()
  self.diff_text = self:AddComponent(UITextMeshProUGUIEx, diff_text_path)
end

function LWMainEpidemicZoneBattleInfo:OnDestroy()
  self.bMain = false
  self.clickCB = nil
  self.theBlueItem:GameObjectRecycleAll()
  self.theRedItem:GameObjectRecycleAll()
  base.OnDestroy(self)
end

function LWMainEpidemicZoneBattleInfo:OnEnable()
  base.OnEnable(self)
  ActMgr:UpdateMapBR()
  local battleInfo = ActMgr:GetBattleInfo()
  if battleInfo == nil then
    ActMgr:ReqBattleScore()
  end
  self:RefreshUI()
  self:Update1000MS()
end

function LWMainEpidemicZoneBattleInfo:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EpidemicBattleScoreUpdate, self.RefreshUI)
end

function LWMainEpidemicZoneBattleInfo:OnRemoveListener()
  self:RemoveUIListener(EventId.EpidemicBattleScoreUpdate, self.RefreshUI)
  base.OnRemoveListener(self)
end

function LWMainEpidemicZoneBattleInfo:RefreshUI()
  self.flag12:SetActive(false)
  self.flag22:SetActive(false)
  local actInfo = ActMgr:GetActInfo()
  if actInfo == nil then
    return
  end
  local curGroup = ActMgr:GetCurGroup()
  local myRole = curGroup ~= nil and curGroup.selfRole or 0
  local roles = curGroup ~= nil and curGroup.roles or {}
  local mIdx, eIdx = 0, 0
  for _, v in ipairs(roles) do
    local img, txt
    if v.role == myRole then
      img = mIdx == 0 and self.flag11 or self.flag12
      txt = mIdx == 0 and self.abbr11 or self.abbr12
      mIdx = mIdx + 1
    else
      img = eIdx == 0 and self.flag21 or self.flag22
      txt = eIdx == 0 and self.abbr21 or self.abbr22
      eIdx = eIdx + 1
    end
    local abbr, _, icon = actInfo:GetAlNameAndIcon(v.allianceId)
    txt:SetText("[" .. abbr .. "]")
    img:SetActive(true)
  end
  local path1 = string.format(LoadPath.LWBattleFieldEpidemicPath, "mjc_YBJQ_zhenying_icon_s1")
  local path2 = string.format(LoadPath.LWBattleFieldEpidemicPath, "mjc_YBJQ_zhenying_icon_s2")
  self.typeIcon1:LoadSpriteAsync(mIdx == 1 and path1 or path2)
  self.typeIcon2:LoadSpriteAsync(eIdx == 1 and path1 or path2)
  local battleInfo = ActMgr:GetBattleInfo()
  if battleInfo == nil then
    return
  end
  local vsInfoArr = battleInfo.vsInfo
  if vsInfoArr ~= nil then
    for i, v in pairs(vsInfoArr) do
      if i == myRole then
        self.user1:SetText(v.count or 0)
        self.speed1:SetText("+" .. (v.speed or 0) .. "/s")
        self:SetBlueSideScore(v.score or 0)
      else
        self.user2:SetText(v.count or 0)
        self.speed2:SetText("+" .. (v.speed or 0) .. "/s")
        self:SetRedSideScore(v.score or 0)
      end
    end
  end
end

local anim_count = 1

function LWMainEpidemicZoneBattleInfo:ShowAnim(bBlue, value)
  local parent = bBlue and self.blue_num_root or self.red_num_root
  local node = bBlue and self.theBlueItem or self.theRedItem
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
          theItem:SetLocalPositionXYZ(bBlue and 100 or -100, 0, 0)
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

local MAX_PERCENT = 0.93

function LWMainEpidemicZoneBattleInfo:UpdateSlider()
  local blue = self.theScoreBlue or 0
  local red = self.theScoreRed or 0
  if blue == red then
    if blue == 0 then
      self.blue_slider:SetValue(0)
      self.red_slider:SetValue(0)
    else
      self.blue_slider:SetValue(1)
      self.red_slider:SetValue(1)
    end
  elseif blue > red then
    self.blue_slider:SetValue(1)
    local percent = MyMin(red / blue, MAX_PERCENT)
    self.red_slider:SetValue(percent)
  else
    local percent = MyMin(blue / red, MAX_PERCENT)
    self.blue_slider:SetValue(percent)
    self.red_slider:SetValue(1)
  end
  local diff = blue - red
  self.diff_text:SetActive(self.bMain and diff ~= 0)
  if self.diff_text:GetActive() then
    self.diff_text:SetColorHex(0 < diff and "5fef87" or "f97077")
    self.diff_text:SetText(0 < diff and "+" .. diff or diff)
  end
end

function LWMainEpidemicZoneBattleInfo:SetBlueSideScore(score)
  if self.theScoreBlue == score then
    return
  end
  self.num1:SetText(string.GetFormattedSeparatorNum(score))
  if self.theScoreBlue ~= nil then
    self:ShowAnim(true, score - self.theScoreBlue)
  end
  self.theScoreBlue = score
  self:UpdateSlider()
end

function LWMainEpidemicZoneBattleInfo:SetRedSideScore(score)
  if self.theScoreRed == score then
    return
  end
  self.num2:SetText(string.GetFormattedSeparatorNum(score))
  if self.theScoreRed ~= nil then
    self:ShowAnim(false, score - self.theScoreRed)
  end
  self.theScoreRed = score
  self:UpdateSlider()
end

function LWMainEpidemicZoneBattleInfo:Update1000MS()
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local groupInfo = ActMgr:GetCurGroup()
  local sTime = groupInfo ~= nil and groupInfo.startTime or 0
  local eTime = groupInfo ~= nil and groupInfo.endTime or 0
  local remainTime = eTime - curSec
  if 0 < remainTime then
    self.remain_time:SetText(UITimeManager:GetInstance():SecondToFmtString(remainTime))
  else
    self.remain_time:SetText("")
  end
  if self.bMain and curSec < sTime then
    self.tips:SetActive(true)
    self.preparation:SetText(Localization:GetString("458119") .. "\n" .. UITimeManager:GetInstance():SecondToFmtString(sTime - curSec))
  else
    self.tips:SetActive(false)
  end
  self:CheckEnd(curSec, eTime)
end

function LWMainEpidemicZoneBattleInfo:SetMain(bMain, clickCB)
  self.bMain = bMain
  self.clickCB = clickCB
end

function LWMainEpidemicZoneBattleInfo:CheckEnd(curSec, battleEndTime)
  if not self.bMain then
    return
  end
  local bEnd = battleEndTime <= curSec
  if bEnd then
    local uiMgr = UIManager:GetInstance()
    if uiMgr:IsWindowOpen(UIWindowNames.UIEpidemicBattleResult) then
      self:SetActive(false)
      return
    end
    if self.signTime == nil then
      self.signTime = curSec
      return
    end
  else
    self.signTime = nil
    return
  end
  if curSec - self.signTime < 5 then
    return
  end
  self.signTime = curSec
  BattleFieldUtil.BackToCity(BattleFieldType.EpidemicZone)
end

return LWMainEpidemicZoneBattleInfo
