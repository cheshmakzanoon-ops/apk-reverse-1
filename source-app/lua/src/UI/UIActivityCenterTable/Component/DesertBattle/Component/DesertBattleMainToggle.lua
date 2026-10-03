local base = UIBaseContainer
local DesertBattleMainToggle = BaseClass("DesertBattleMainToggle", base)
local base_toggle_path = "ToggleType"

function DesertBattleMainToggle:OnCreate()
  base.OnCreate(self)
  self.toggles = {}
  for i = 1, 2 do
    local keyStr = base_toggle_path .. i
    local toggle = self:AddComponent(UIToggle, keyStr)
    toggle:SetOnValueChanged(function(tf)
      if self.cb then
        self.cb(i, tf)
      end
    end)
    self.toggles[i] = toggle
    local textSec1 = self:AddComponent(UIText, keyStr .. "/tabType_text" .. i)
    local flag = self:AddComponent(UIBaseComponent, keyStr .. "/Flag" .. i)
    if i == 2 then
      self.flag2 = flag
      self.text_sec1 = textSec1
      self.abd = self:AddComponent(UIBaseComponent, keyStr .. "/Abandon")
    else
      self.flag1 = flag
    end
  end
end

function DesertBattleMainToggle:OnDestroy()
  base.OnDestroy(self)
end

function DesertBattleMainToggle:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetDagonPlayerList, self.UpdateMyGroup)
end

function DesertBattleMainToggle:OnRemoveListener()
  self:RemoveUIListener(EventId.GetDagonPlayerList, self.UpdateMyGroup)
  base.OnRemoveListener(self)
end

function DesertBattleMainToggle:SetData(cb)
  self.cb = cb
end

function DesertBattleMainToggle:SetSel(idx, obbsFlag)
  local toggle = self.toggles[idx]
  if toggle then
    toggle:SetIsOn(true)
  end
  self.abd:SetActive(obbsFlag)
  self.text_sec1:SetActive(not obbsFlag)
  self:UpdateMyGroup()
end

function DesertBattleMainToggle:UpdateMyGroup()
  local myInfo = DataCenter.ActDragonManager:GetPlayerInfoByUID(LuaEntry.Player:GetUid())
  local group = myInfo ~= nil and myInfo.group or 0
  self.flag1:SetActive(group == 1)
  self.flag2:SetActive(group == 2)
end

return DesertBattleMainToggle
