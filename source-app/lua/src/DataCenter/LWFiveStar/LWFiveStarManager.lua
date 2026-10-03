local LWFiveStarManager = BaseClass("LWFiveStarManager")

function LWFiveStarManager:__init()
  self:AddListener()
end

function LWFiveStarManager:__delete()
  self:RemoveListener()
  self.fiveStarFlag = false
end

function LWFiveStarManager:Startup()
end

function LWFiveStarManager:AddListener()
end

function LWFiveStarManager:RemoveListener()
end

function LWFiveStarManager:InitData(msg)
  if msg.five_star_evaluation ~= nil then
    self.fiveStarFlag = msg.five_star_evaluation == 1
  end
end

function LWFiveStarManager:SetFlag()
  self.fiveStarFlag = true
end

function LWFiveStarManager:CheckShowFiveStarView(typeStr)
  if self.fiveStarFlag then
    return false
  end
  DataCenter.LWFiveStarManager:DoShowFiveStarView(typeStr)
  return true
end

function LWFiveStarManager:DoShowFiveStarView(typeStr)
  DataCenter.UIPopWindowManager:Push(UIWindowNames.UIFiveStarGet, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  }, {type = typeStr})
end

return LWFiveStarManager
