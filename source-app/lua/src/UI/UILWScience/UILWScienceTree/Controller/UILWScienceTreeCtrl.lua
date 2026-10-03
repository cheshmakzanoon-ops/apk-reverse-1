local UILWScienceTreeCtrl = BaseClass("UILWScienceTreeCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function SetView(self, view)
  self.view = view
end

local function ClearView(self)
  self.view = nil
end

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWScienceTree)
end

local function IsScienceLvMax(self, scienceId)
  local curLv = DataCenter.ScienceManager:GetScienceLevel(scienceId)
  local maxLv = DataCenter.ScienceManager:GetScienceMaxLevel(scienceId)
  if curLv == maxLv then
    return true
  end
  return false
end

UILWScienceTreeCtrl.SetView = SetView
UILWScienceTreeCtrl.ClearView = ClearView
UILWScienceTreeCtrl.CloseSelf = CloseSelf
UILWScienceTreeCtrl.IsScienceLvMax = IsScienceLvMax
return UILWScienceTreeCtrl
