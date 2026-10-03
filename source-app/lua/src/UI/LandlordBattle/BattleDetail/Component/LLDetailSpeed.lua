local base = UIAsyncContainer
local LLDetailSpeed = BaseClass("LLDetailSpeed", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr

function LLDetailSpeed:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

function LLDetailSpeed:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLDetailSpeed:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compDown = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.compUp = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.compSpeed = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.compLeft = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.compRight = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.theItem = self.compSpeed.gameObject
  self.theItem:GameObjectCreatePool()
  self.compSpeed:SetActive(false)
end

function LLDetailSpeed:ComponentDestroy()
  self.viewSkin = nil
  self.btnClose = nil
  self.compDown = nil
  self.compUp = nil
  self.textTips = nil
  self.compContent = nil
  self.compSpeed = nil
  self.compLeft = nil
  self.compRight = nil
end

function LLDetailSpeed:DataDefine()
  self.effectValueFactor = 1
end

function LLDetailSpeed:Refresh()
  self:ClearItems()
  self.items = {}
  self.curBg = {}
  if self.isThroneCity then
    local str1 = Localization:GetString("zonewar_landlord_desc_1035")
    local str2 = Localization:GetString("zonewar_landlord_desc_1001")
    self.textTips:SetText(str1 .. "\n" .. str2)
  else
    self.textTips:SetLocalText("zonewar_landlord_desc_1001")
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.textTips.transform)
  self.list = ActMgr:GetSpeedCalculateList(self.isThroneCity) or {}
  for i, info in ipairs(self.list) do
    local obj = self.theItem:GameObjectSpawn(self.compContent.transform)
    obj.name = "Speed_" .. i
    local item = self.compContent:AddComponent(UIBaseContainer, obj.name)
    self.items[i] = item
    local lastTime = 0
    if 1 < i then
      local lastInfo = self.list[i - 1]
      lastTime = lastInfo[1] or 0
    end
    self.curBg[i] = item:AddComponent(UIImage, "")
    if self.curBg[i] then
      self.curBg[i]:SetEnable(false)
    end
    local text1 = item:AddComponent(UITextMeshProUGUIEx, "Txt1")
    local curTime = info[1] or 0
    if text1 then
      if curTime == -1 or curTime == math.huge then
        text1:SetText(string.format("> %s", lastTime))
      else
        text1:SetText(string.format("%s - %s", lastTime, curTime))
      end
    end
    local text2 = item:AddComponent(UITextMeshProUGUIEx, "Txt2")
    if text2 then
      text2:SetText("+" .. string.formatDecimal((info[2] or 0) * (self.effectValueFactor or 1), 2))
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compContent.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
end

function LLDetailSpeed:ClearItems()
  if self.items ~= nil then
    for _, v in ipairs(self.items) do
      self.compContent:RemoveComponent(v:GetName(), UIBaseContainer)
    end
    self.items = nil
    self.theItem:GameObjectRecycleAll()
  end
end

function LLDetailSpeed:DataDestroy()
  self:ClearItems()
  self.pos = nil
  self.effectValueFactor = nil
end

function LLDetailSpeed:OnAddListener()
  base.OnAddListener(self)
end

function LLDetailSpeed:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLDetailSpeed:OnBtnCloseClick()
  self:SetActive(false)
end

function LLDetailSpeed:SetTargetPos(pos, isLeftOrRight, isThroneCity)
  self.isLeftOrRight = isLeftOrRight
  self.pos = pos
  self.isThroneCity = isThroneCity
  self:SetActive(true)
  self:RefreshView()
end

function LLDetailSpeed:UpdateData()
  if self.pos == nil then
    return
  end
  local x = self.pos.x
  local y = self.pos.y
  local z = self.pos.z
  if not self.isLeftOrRight then
    local bUp = 0 < y
    self.compUp:SetActive(bUp)
    self.compDown:SetActive(not bUp)
    self.compLeft:SetActive(false)
    self.compRight:SetActive(false)
    y = y + (bUp and -1 or 1) * 30
    x = x + CommonUtil.ArabicAutoMirrorFactor() * 30
    self:SetAnchorMaxXY(CommonUtil.IsArabicAutoMirrorOpen() and 0 or 1, bUp and 1 or 0)
    self:SetAnchorMinXY(CommonUtil.IsArabicAutoMirrorOpen() and 0 or 1, bUp and 1 or 0)
    self:SetPivotXY(CommonUtil.IsArabicAutoMirrorOpen() and 0 or 1, bUp and 1 or 0)
  else
    local offset = 30 * CommonUtil.ArabicAutoMirrorFactor()
    local isRight
    if CommonUtil.IsArabicAutoMirrorOpen() then
      isRight = 0 < x
    else
      isRight = x < 0
    end
    self.compUp:SetActive(false)
    self.compDown:SetActive(false)
    self.compLeft:SetActive(isRight)
    self.compRight:SetActive(not isRight)
    local anchorMaxMinX
    if isRight then
      x = x + offset
      anchorMaxMinX = CommonUtil.IsArabicAutoMirrorOpen() and 1 or 0
    else
      x = x - offset
      anchorMaxMinX = CommonUtil.IsArabicAutoMirrorOpen() and 0 or 1
    end
    self:SetAnchorMaxXY(anchorMaxMinX, 0.5)
    self:SetAnchorMinXY(anchorMaxMinX, 0.5)
    self:SetPivotXY(anchorMaxMinX, 0.5)
  end
  self:SetLocalPositionXYZ(x, y, z, true)
  self:Refresh()
end

function LLDetailSpeed:SetExtraValue(effectValue, occupyStartTime)
  self.effectValueFactor = effectValue or 1
  self.occupyStartTime = occupyStartTime
  if self:AsyncLoadDone() then
    self:Refresh()
    self:Update1000MS()
  end
end

function LLDetailSpeed:Update1000MS()
  if not self.occupyStartTime then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local occupyTime = (curTime - self.occupyStartTime) / 1000
  if 0 < occupyTime and self.list then
    local curTimeIndex = -1
    for k, v in ipairs(self.list) do
      if occupyTime < v[1] then
        curTimeIndex = k
        break
      end
    end
    for k, v in ipairs(self.curBg) do
      v:SetEnable(k == curTimeIndex)
    end
  end
end

return LLDetailSpeed
