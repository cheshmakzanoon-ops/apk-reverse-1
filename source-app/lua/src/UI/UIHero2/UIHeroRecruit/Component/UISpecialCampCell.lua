local UISpecialCampCell = BaseClass("UISpecialCampCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.imgIcon = self:AddComponent(UIText, "")
  self.textName = self:AddComponent(UIText, "TextName")
  self.textTime = self:AddComponent(UIText, "TextEndTime")
end

local function ComponentDestroy(self)
  self.imgIcon = nil
  self.textName = nil
  self.textTime = nil
end

local function DataDefine(self)
  self.lotteryData = nil
end

local function DataDestroy(self)
  self.lotteryData = nil
end

local function SetData(self, campId, lotteryId, isNextCamp)
  self.lotteryId = lotteryId
  self.lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(lotteryId)
  local campName, desc = HeroUtils.GetCampNameAndDesc(campId)
  self.textName:SetText(campName)
  self.textTime:SetActive(lotteryId ~= nil or isNextCamp)
  if isNextCamp then
    self.textTime:SetLocalText(110125)
  else
    self.textTime:SetText("")
    self:OnTimer()
  end
  local gray = lotteryId == nil
  UIGray.SetGray(self.transform, gray, false)
  self.textName:SetColor(Color.white * (gray and 0.67 or 1))
  local shadow = self.textName.transform:GetComponent(typeof(CS.UnityEngine.UI.Shadow))
  if shadow then
    shadow.enabled = not gray
  end
  local outline = self.textName.transform:GetComponent(typeof(CS.UnityEngine.UI.Outline))
  if outline then
    outline.effectColor = gray and Color.black or Color.New(0.18823529411764706, 0.24313725490196078, 0.047058823529411764)
    outline.enabled = true
  end
end

local function OnTimer(self)
  local lotteryData = self.lotteryData
  if lotteryData == nil or not lotteryData:IsShowTime() then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now > lotteryData.endTime then
    self.textTime:SetText("")
    return
  end
  local leftTime = math.max(0, lotteryData.endTime - now)
  self.textTime:SetLocalText(360011, UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
end

local function Update(self)
  self:OnTimer()
end

UISpecialCampCell.OnCreate = OnCreate
UISpecialCampCell.OnDestroy = OnDestroy
UISpecialCampCell.OnEnable = OnEnable
UISpecialCampCell.OnDisable = OnDisable
UISpecialCampCell.ComponentDefine = ComponentDefine
UISpecialCampCell.ComponentDestroy = ComponentDestroy
UISpecialCampCell.DataDefine = DataDefine
UISpecialCampCell.DataDestroy = DataDestroy
UISpecialCampCell.SetData = SetData
UISpecialCampCell.OnTimer = OnTimer
UISpecialCampCell.Update = Update
return UISpecialCampCell
