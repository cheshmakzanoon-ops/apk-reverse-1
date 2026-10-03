local WinterStormBattleTopSliderItemNew = BaseClass("WinterStormBattleTopSliderItemNew", UIBaseContainer)
local base = UIBaseContainer
local num_group_path = "NumGroup"
local text_add_num_path = "NumGroup/NumTextAdd"
local slider_path = "Slider"
local min_path = "Slider/FillRect/Fill/SignMin"
local text_num_path = "TextNum"
local text_speed_path = "TextSpeed"
local bg_tip_path = "bgTip"
local change_root_path = "bgTip/change"
local icon_path = "bgTip/change/Head/UIPlayerHead/HeadIcon"
local text_change_path = "bgTip/change/TextChange"
local text_name_path = "bgTip/change/TextName"
local percent_root_path = "bgTip/percent"
local text_p_num_path = "bgTip/percent/TextPNum"

function WinterStormBattleTopSliderItemNew:OnCreate()
  base.OnCreate(self)
  self.leftTipPercent = LuaEntry.DataConfig:TryGetNum("winter_battlefield", "k26", 1) / 100
  self.leftTipMin = LuaEntry.DataConfig:TryGetNum("winter_battlefield", "k27", 1)
  self.maxNum = LuaEntry.DataConfig:TryGetNum("winter_battlefield", "k23", 1)
  local percents = string.split(LuaEntry.DataConfig:TryGetStr("winter_battlefield", "k28", "50,75"), ",")
  self.rightPercents = {}
  if percents ~= nil and 0 < #percents then
    for i, v in ipairs(percents) do
      self.rightPercents[i] = tonumber(v) or 0
    end
  end
  self.theNum = nil
  self.lastNum = nil
  self.seq = nil
  self.side = 0
  self.num_group = self:AddComponent(UIBaseContainer, num_group_path)
  self.text_add_num = self.transform:Find(text_add_num_path).gameObject
  self.text_add_num:GameObjectCreatePool()
  self.slider = self:AddComponent(UISlider, slider_path)
  self.img_min = self:AddComponent(UIBaseContainer, min_path)
  self.text_num = self:AddComponent(UIText, text_num_path)
  self.text_speed = self:AddComponent(UIText, text_speed_path)
  self.bg_tip = self:AddComponent(UIBaseContainer, bg_tip_path)
  self.change_root = self:AddComponent(UIBaseContainer, change_root_path)
  self.icon = self:AddComponent(UIPlayerHead, icon_path)
  self.text_change = self:AddComponent(UIText, text_change_path)
  self.text_name = self:AddComponent(UIText, text_name_path)
  self.percent_root = self:AddComponent(UIBaseContainer, percent_root_path)
  self.text_p_num = self:AddComponent(UIText, text_p_num_path)
end

function WinterStormBattleTopSliderItemNew:OnDestroy()
  self:CleanSeq()
  self:CleanSeqTip(0)
  self.num_group = nil
  self.text_add_num:GameObjectRecycleAll()
  self.text_add_num = nil
  self.slider = nil
  self.img_min = nil
  self.text_num = nil
  self.text_speed = nil
  self.change_root = nil
  self.icon = nil
  self.text_change = nil
  self.text_name = nil
  self.percent_root = nil
  self.text_p_num = nil
  self.theNum = nil
  self.lastNum = nil
  self.side = 0
  base.OnDestroy(self)
end

function WinterStormBattleTopSliderItemNew:SetSide(side)
  self.side = side
end

function WinterStormBattleTopSliderItemNew:SetEff(eff, effPercent)
  self.eff = eff
  self.effPercent = effPercent
end

function WinterStormBattleTopSliderItemNew:CleanSeq()
  if self.seq ~= nil then
    self.seq:Pause()
    self.seq:Kill()
    self.seq = nil
  end
  if self.img_min then
    self.img_min:SetActive(false)
  end
end

function WinterStormBattleTopSliderItemNew:CheckMax()
  local cur = tonumber(self.text_num:GetText()) or 0
  return cur >= self.maxNum
end

function WinterStormBattleTopSliderItemNew:UpdateNum(numCur, playAnim)
  self:SetNum(numCur, playAnim)
end

function WinterStormBattleTopSliderItemNew:SetNum(numCur, playAnim)
  if self.theNum == numCur then
    return
  end
  self.text_num:SetText(numCur)
  if playAnim and self.theNum ~= nil then
    self:ShowAnim(numCur - self.theNum)
  end
  self.lastNum = self.theNum
  self.theNum = numCur
  self:UpdateSlider()
  self:UpdateEff()
end

function WinterStormBattleTopSliderItemNew:UpdateEff()
  if self.eff == nil then
    return
  end
  local percent = self.theNum / self.maxNum
  if percent >= self.effPercent then
    if not self.eff.gameObject.activeSelf then
      self.eff.gameObject:SetActive(true)
      self.eff:Simulate(0)
      self.eff:Play()
    end
  else
    self.eff.gameObject:SetActive(false)
    self.eff:Stop()
  end
end

function WinterStormBattleTopSliderItemNew:UpdateSlider()
  local curNum = self.lastNum
  if curNum == nil or self.img_min == nil then
    curNum = self.theNum
  end
  self.slider:SetValue(curNum / self.maxNum)
  self:CleanSeq()
  if curNum <= self.theNum then
    self.slider:SetValue(self.theNum / self.maxNum)
    return
  end
  self.img_min:SetActive(true)
  local seq = CS.DG.Tweening.DOTween.Sequence()
  seq:AppendInterval(0.5)
  
  function seq.onComplete()
    self.seq = nil
    self.img_min:SetActive(false)
    self.slider:SetValue(self.theNum / self.maxNum)
  end
  
  self.seq = seq
end

function WinterStormBattleTopSliderItemNew:UpdateSpeed(num)
  self.text_speed:SetText(num .. "/s")
end

local anim_count = 1

function WinterStormBattleTopSliderItemNew:ShowAnim(value)
  local parent = self.num_group
  local node = self.text_add_num
  if node and parent and parent.transform and value and value ~= 0 then
    local goItem = node:GameObjectSpawn(parent.transform)
    if goItem then
      goItem.name = "anim" .. anim_count
      anim_count = anim_count + 1
      do
        local theItem = parent:AddComponent(UIText, goItem.name)
        if theItem then
          if 0 < value then
            theItem:SetText("+" .. value)
          else
            theItem:SetText(tostring(value))
          end
          theItem:SetActive(true)
          local offSetX = math.random(0, 60) - 30
          local offSetY = math.random(0, 20) - 10
          theItem:SetLocalPositionXYZ(offSetX, offSetY, 0)
          theItem:SetAlpha(1)
          theItem.transform:DOLocalMoveY(50 + offSetY, 1.5)
          theItem.unity_tmpro:DOFade(0, 1.5)
          local sequence = CS.DG.Tweening.DOTween.Sequence()
          sequence:AppendInterval(1.6)
          sequence:AppendCallback(function()
            if parent ~= nil and not IsNull(parent.gameObject) then
              parent:RemoveComponent(goItem.name, UIText)
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

function WinterStormBattleTopSliderItemNew:CleanSeqTip(state)
  if self.seqTip ~= nil then
    self.seqTip:Pause()
    self.seqTip:Kill()
    self.seqTip = nil
  end
  self.bg_tip:SetActive(state ~= 0)
  self.percent_root:SetActive(state == 1)
  self.change_root:SetActive(state == 2)
end

function WinterStormBattleTopSliderItemNew:PlayTip(info)
  if info.updateScore <= 0 then
    return
  end
  local curScore = self.theNum or 0
  local seqFlag = self:PlayPercent(info, curScore)
  seqFlag = seqFlag or self:PlayChange(info, curScore)
  if seqFlag then
    local seq = CS.DG.Tweening.DOTween.Sequence()
    seq:AppendInterval(3)
    
    function seq.onComplete()
      self.seqTip = nil
      self.bg_tip:SetActive(false)
    end
    
    self.seqTip = seq
  end
end

function WinterStormBattleTopSliderItemNew:PlayPercent(info, curScore)
  local curPercent = curScore * 100 / self.maxNum
  local infoPercent = info.score * 100 / self.maxNum
  local percent = -1
  for _, p in ipairs(self.rightPercents) do
    if p > curPercent and p <= infoPercent then
      percent = p
      break
    end
  end
  if percent < 0 then
    return false
  end
  self:CleanSeqTip(1)
  self.text_p_num:SetText(percent .. "%")
  return true
end

function WinterStormBattleTopSliderItemNew:PlayChange(info, curScore)
  local teamArr = DataCenter.ActWinterStormManager:GetTeamArr(info.uid)
  if teamArr == nil then
    return false
  end
  local updateScore = info.updateScore or 0
  local checkNum = math.max(self.leftTipMin, curScore * self.leftTipPercent)
  if updateScore < checkNum then
    return false
  end
  self:CleanSeqTip(2)
  self.icon:SetData(teamArr.uid, teamArr.head, teamArr.frame)
  self.text_change:SetText(0 < updateScore and "+" .. updateScore or updateScore)
  local name = UIUtil.FormatServerAllianceName(teamArr.server, teamArr.allianceName, teamArr.name)
  self.text_name:SetText(name)
  return true
end

return WinterStormBattleTopSliderItemNew
