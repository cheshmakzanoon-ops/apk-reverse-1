local AlCompeteScheduleActivityItem = BaseClass("AlCompeteScheduleActivityItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local dayTxt_path = "dayTxt"
local memberTxt_path = "memeberTxt"
local scoreTxt_path = "scoreTxt"
local victoryTxt_path = "failureTxt"
local failureTxt_path = "victoryTxt"
local jump_btn_path = "JumpBtn"
local jump_btn_label_path = "JumpBtn/jumpBtnTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self.dayTxt = self:AddComponent(UIText, dayTxt_path)
  self.memberTxt = self:AddComponent(UIText, memberTxt_path)
  self.scoreTxt = self:AddComponent(UIText, scoreTxt_path)
  self.victoryTxt = self:AddComponent(UIText, victoryTxt_path)
  self.failureTxt = self:AddComponent(UIText, failureTxt_path)
  self.jump_btn = self:AddComponent(UIButton, jump_btn_path)
  self.jump_btn:SetOnClick(function()
    self:OnJumpBtnClick()
  end)
  self.jump_btn_label = self:AddComponent(UIText, jump_btn_label_path)
  self.jump_btn_label:SetLocalText(110036)
end

local function OnDestroy(self)
  self.dayTxt = nil
  self.memberTxt = nil
  self.scoreTxt = nil
  self.victoryTxt = nil
  self.failureTxt = nil
  self.jump_btn = nil
  self.jump_btn_label = nil
  base.OnDestroy(self)
end

local function RefreshData(self, activityId, score, isWin, dayText, showText, selfAlName, otherAlName)
  self.dayTxt:SetLocalText(dayText)
  self.memberTxt:SetLocalText(showText)
  self.scoreTxt:SetText(tostring(score))
  self.jumpId = activityId
  if isWin ~= nil then
    if isWin == 1 then
      self.victoryTxt:SetActive(true)
      self.victoryTxt:SetText("[" .. selfAlName .. "]")
      self.failureTxt:SetActive(false)
    else
      self.victoryTxt:SetActive(false)
      self.failureTxt:SetActive(true)
      self.failureTxt:SetText("[" .. otherAlName .. "]")
    end
    self.jump_btn:SetActive(false)
  else
    self.failureTxt:SetActive(false)
    self.victoryTxt:SetActive(false)
    if self.jumpId ~= nil and self.jumpId ~= "" then
      local now = UITimeManager:GetInstance():GetServerTime()
      local activityOpen = false
      local actData = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.jumpId))
      if actData ~= nil and now > actData.startTime and now < actData.endTime then
        activityOpen = true
      end
      self.jump_btn:SetActive(activityOpen)
    end
  end
end

local function OnJumpBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, {
    anim = true,
    hideTop = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, tonumber(self.jumpId))
end

AlCompeteScheduleActivityItem.OnCreate = OnCreate
AlCompeteScheduleActivityItem.OnDestroy = OnDestroy
AlCompeteScheduleActivityItem.RefreshData = RefreshData
AlCompeteScheduleActivityItem.OnJumpBtnClick = OnJumpBtnClick
return AlCompeteScheduleActivityItem
