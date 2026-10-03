local base = UIBaseContainer
local UIEBR_MyDataItem = BaseClass("UIEBR_MyDataItem", base)
local Localization = CS.GameEntry.Localization

function UIEBR_MyDataItem:OnCreate()
  base.OnCreate(self)
  self.img = self:AddComponent(UIImage, "Image")
  self.nameText = self:AddComponent(UITextMeshProUGUIEx, "NameText")
  self.scoreText = self:AddComponent(UITextMeshProUGUIEx, "ScoreText")
  self.averageText = self:AddComponent(UITextMeshProUGUIEx, "AverageText")
  self.highestText = self:AddComponent(UITextMeshProUGUIEx, "HighestText")
  self.new = self:AddComponent(UIBaseComponent, "HighestText")
end

function UIEBR_MyDataItem:OnDestroy()
  self.img = nil
  self.nameText = nil
  self.scoreText = nil
  self.averageText = nil
  self.highestText = nil
  self.new = nil
  base.OnDestroy(self)
end

function UIEBR_MyDataItem:SetData(idx, scoreInfo)
  local imgPath, cur, avg, max, key
  if idx == 1 then
    imgPath = "zyf_yibianzhanchang_icon_zongjifen.png"
    key = "YiBianJinQu_battle_result_tips_6"
    cur = scoreInfo.score
    avg = scoreInfo.scoreAvg
    max = scoreInfo.scoreMax
  elseif idx == 2 then
    imgPath = "zyf_yibianzhanchang_icon_gongji.png"
    key = "YiBianJinQu_battle_result_tips_7"
    cur = scoreInfo.battleScore
    avg = scoreInfo.battleAvgScore
    max = scoreInfo.battleMaxScore
  elseif idx == 3 then
    imgPath = "zyf_yibianzhanchang_icon_xiezhu.png"
    key = "YiBianJinQu_battle_result_tips_8"
    cur = scoreInfo.cooperationScore
    avg = scoreInfo.cooperationAvgScore
    max = scoreInfo.cooperationMaxScore
  elseif idx == 4 then
    imgPath = "zyf_yibianzhanchang_icon_zhanlue.png"
    key = "YiBianJinQu_battle_result_tips_9"
    cur = scoreInfo.tacticsScore
    avg = scoreInfo.tacticsAvgScore
    max = scoreInfo.tacticsScoreMax
  end
  if key == nil then
    return
  end
  self.img:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldEpidemicPath, imgPath))
  self.nameText:SetLocalText(key)
  self.scoreText:SetText(string.GetFormattedSeperatorNum(cur))
  self.averageText:SetText(Localization:GetString("YiBianJinQu_battle_result_tips_11") .. ": " .. string.GetFormattedSeperatorNum(avg))
  self.highestText:SetText(Localization:GetString("YiBianJinQu_battle_result_tips_12") .. ": " .. string.GetFormattedSeperatorNum(max))
  self.new:SetActive(cur == max)
end

return UIEBR_MyDataItem
