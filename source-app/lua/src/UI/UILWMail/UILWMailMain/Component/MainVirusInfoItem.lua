local MainVirusInfoItem = BaseClass("MainVirusInfoItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function MainVirusInfoItem:OnCreate()
  base.OnCreate(self)
  self.arrow = self:AddComponent(UIImage, "arrow")
  self.value1 = self:AddComponent(UIText, "Virus1/Value1")
  self.value2 = self:AddComponent(UIText, "Virus2/Value2")
  self.msg_btn = self:AddComponent(UIButton, "KangXingMsgBtn")
  self.msg_btn:SetOnClick(function()
    if self.reason_virus ~= nil then
      local str1 = Localization:GetString("season_infect_reason01")
      local str2 = Localization:GetString("season_infect_reason02")
      local str3 = Localization:GetString("season_infect_reason03")
      local str4 = Localization:GetString("s1_buff_desc704801")
      if self.reason_virus == 1 then
        UIUtil.ShowDetail(str1)
      elseif self.reason_virus == 2 then
        UIUtil.ShowDetail(str2)
      elseif self.reason_virus == 3 then
        UIUtil.ShowDetail(str3)
      elseif self.reason_virus == 4 then
        UIUtil.ShowDetail(str4)
      else
        UIUtil.ShowDetail(string.format([[
1. %s

2. %s

3. %s

4. %s
]], str1, str2, str3, str4))
      end
    end
  end)
end

function MainVirusInfoItem:OnDestroy()
  self.value1 = nil
  self.arrow = nil
  self.value2 = nil
  self.msg_btn = nil
  base.OnDestroy(self)
end

function MainVirusInfoItem:SetData(leftStr, rightStr, reasonId)
  self.value1:SetText(leftStr)
  self.value2:SetText(rightStr)
  self.reason_virus = math.abs(reasonId)
  if 0 < reasonId then
    self.arrow:SetEulerAnglesXYZ(0, 0, 0)
  else
    self.arrow:SetEulerAnglesXYZ(0, 0, 180)
  end
end

return MainVirusInfoItem
