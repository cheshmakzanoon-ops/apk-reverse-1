local UILWSeasonDonateFishCtrl = BaseClass("UILWSeasonDonateFishCtrl", UIBaseCtrl)

function UILWSeasonDonateFishCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonDonateFish)
end

function UILWSeasonDonateFishCtrl:SetLogic(logic)
  self.logicDonate = logic
  self.selectList = {}
end

function UILWSeasonDonateFishCtrl:AddSelectCount(id, count)
  local curCount = self:GetSelectCount(id)
  local opCount = count + curCount
  if 0 < opCount then
    self.selectList[id] = opCount
  else
    self.selectList[id] = nil
  end
end

function UILWSeasonDonateFishCtrl:GetSelectList()
  return self.selectList or {}
end

function UILWSeasonDonateFishCtrl:GetSelectCount(id)
  if self.selectList == nil then
    return 0
  end
  return self.selectList[id] or 0
end

function UILWSeasonDonateFishCtrl:GetCanAddToDonate()
  local donateInfo = self.logicDonate:GetDonateInfo()
  if donateInfo == nil then
    return false
  end
  local canDonateCount = donateInfo.curCount
  local hasCount = 0
  if self.selectList then
    for _, count in pairs(self.selectList) do
      hasCount = hasCount + count
    end
  end
  return canDonateCount > hasCount
end

function UILWSeasonDonateFishCtrl:SetSelectList(selectList)
  self.selectList = selectList
end

return UILWSeasonDonateFishCtrl
