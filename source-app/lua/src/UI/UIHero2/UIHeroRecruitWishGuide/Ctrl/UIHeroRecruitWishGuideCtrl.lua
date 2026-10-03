local UIHeroRecruitWishGuideCtrl = BaseClass("UIHeroRecruitWishGuideCtrl", UIBaseCtrl)
UIHeroRecruitWishGuideCtrl.IconPath = "Assets/Main/Sprites/UI/UIHeroRecruitWishGuide/%s"

function UIHeroRecruitWishGuideCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroRecruitWishGuide)
end

function UIHeroRecruitWishGuideCtrl:GetViewTextConfig()
  local res = {}
  local k3 = LuaEntry.DataConfig:TryGetStr("recruit_wish_config", "k4", "")
  if not string.IsNullOrEmpty(k3) then
    local k3Pair = string.split(k3, "|")
    for i, v in pairs(k3Pair) do
      table.insert(res, v)
    end
  end
  return res
end

function UIHeroRecruitWishGuideCtrl:GetViewImgConfig()
  local res = {}
  local k3 = LuaEntry.DataConfig:TryGetStr("recruit_wish_config", "k5", "")
  if not string.IsNullOrEmpty(k3) then
    local k3Pair = string.split(k3, "|")
    for i, v in pairs(k3Pair) do
      table.insert(res, string.format(self.IconPath, v))
    end
  end
  return res
end

function UIHeroRecruitWishGuideCtrl:GetShowLotteryId()
  local res = {}
  local k3 = LuaEntry.DataConfig:TryGetStr("recruit_wish_config", "k6", "")
  if not string.IsNullOrEmpty(k3) then
    local k3Pair = string.split(k3, "|")
    for i, v in pairs(k3Pair) do
      table.insert(res, v)
    end
  end
  for i, v in pairs(res) do
    local info = DataCenter.LotteryDataManager:GetLotteryDataById(v)
    if info and info:IsOpen() then
      return v
    end
  end
end

return UIHeroRecruitWishGuideCtrl
