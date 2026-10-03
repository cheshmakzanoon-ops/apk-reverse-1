local UIAllyDuelScieneTipCtrl = BaseClass("UIAllyDuelScieneTipCtrl", UIBaseCtrl)
local ScienceNode = {
  {
    dialogId = 500030,
    scienceId = 90002200,
    jumpId = 90002200
  },
  {
    dialogId = 500031,
    scienceId = 90006200,
    jumpId = 90006200
  }
}

function UIAllyDuelScieneTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllyDuelScienceTip, {anim = true})
end

function UIAllyDuelScieneTipCtrl:JudgeShowType()
  local allyScienceId = 9
  local tabState = DataCenter.ScienceTemplateManager:GetTabState(allyScienceId)
  if tabState ~= ScienceTabState.UnLock then
    return {
      dialogId = 500029,
      scienceId = -1,
      jumpId = 10123000
    }
  else
    return self:JudgeCurrentNode()
  end
end

function UIAllyDuelScieneTipCtrl:JudgeCurrentNode()
  local count = 0
  for _, v in ipairs(ScienceNode) do
    local scienceInfo = DataCenter.ScienceDataManager:GetScienceById(v.scienceId)
    if scienceInfo == nil then
      return v
    end
    count = count + 1
  end
  if count == #ScienceNode then
    return {dialogId = 0, scienceId = 1}
  end
end

return UIAllyDuelScieneTipCtrl
