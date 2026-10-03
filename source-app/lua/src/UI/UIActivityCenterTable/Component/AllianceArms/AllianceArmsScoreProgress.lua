local AllianceArmsScoreProgress = BaseClass("AllianceArmsScoreProgress", UIBaseContainer)
local base = UIBaseContainer
local kPoints_path = "Points/Point_"
local kPointsNum_path = "Num_"
local progSlider_path = "Slider"

local function OnCreate(self)
  base.OnCreate(self)
  self.kPointsNum = {}
  self.kPoints = {}
  self.progSlider = self:AddComponent(UISlider, progSlider_path)
end

local function OnDestroy(self)
  self.kPoints = nil
  self.kPointsNum = nil
  self.progSlider = nil
  self.dataTb = nil
  base.OnDestroy(self)
end

local function Init(self, dataTb)
  self.dataTb = dataTb
  if not self.isInited then
    for i = 1, #self.dataTb do
      local tempPoint = self:AddComponent(UIBaseContainer, kPoints_path .. i)
      table.insert(self.kPoints, tempPoint)
      local tempTxt = tempPoint:AddComponent(UIText, kPointsNum_path .. i)
      table.insert(self.kPointsNum, tempTxt)
    end
  end
  self.isInited = true
  for i, v in ipairs(self.kPoints) do
    if i <= #self.dataTb and not self.dataTb[i].isHide then
      v:SetActive(true)
      self.kPointsNum[i]:SetText(string.GetFormattedSeperatorNum(self.dataTb[i].num) or "Err")
    else
      v:SetActive(false)
    end
  end
end

local function SetCurProg(self, curNum, dataTb)
  if dataTb then
    self:Init(dataTb)
  end
  if curNum >= self.dataTb[1].num then
    for i = #self.dataTb, 1, -1 do
      if curNum >= self.dataTb[i].num then
        local basePercent = self.dataTb[i].percent
        if i == #self.dataTb then
          self.progSlider:SetValue(1)
          do return end
          break
        end
        do
          local extraNum = curNum - self.dataTb[i].num
          local extraPercent = extraNum / (self.dataTb[i + 1].num - self.dataTb[i].num) * (self.dataTb[i + 1].percent - self.dataTb[i].percent)
          self.progSlider:SetValue(basePercent + extraPercent)
        end
        break
      end
    end
  else
    self.progSlider:SetValue(0)
  end
end

AllianceArmsScoreProgress.OnCreate = OnCreate
AllianceArmsScoreProgress.OnDestroy = OnDestroy
AllianceArmsScoreProgress.Init = Init
AllianceArmsScoreProgress.SetCurProg = SetCurProg
return AllianceArmsScoreProgress
