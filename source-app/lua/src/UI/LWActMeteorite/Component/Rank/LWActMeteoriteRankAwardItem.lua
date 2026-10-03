local LWActMeteoriteRankAwardItem = BaseClass("LWActMeteoriteRankAwardItem", UIBaseContainer)
local base = UIBaseContainer
local bg_path = "Bg"
local rank_img_path = "RankImg"
local rank_text1_path = "RankImg/RankText1"
local rank_text2_path = "RankText2"
local content_path = "ScrollView/Viewport/Content"
local tip_path = "Tip"
local tip_text_path = "Tip/TipText"
local RANK_BG_PATH = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_%d.png"
local RANK_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang0%d.png"

function LWActMeteoriteRankAwardItem:OnCreate()
  base.OnCreate(self)
  self.items = {}
  self.dataList = {}
  self.bg = self:AddComponent(UIImage, bg_path)
  self.rank_img = self:AddComponent(UIImage, rank_img_path)
  self.rank_text1 = self:AddComponent(UITextMeshProUGUIEx, rank_text1_path)
  self.rank_text2 = self:AddComponent(UITextMeshProUGUIEx, rank_text2_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.tip = self:AddComponent(UIBaseContainer, tip_path)
  self.tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
end

function LWActMeteoriteRankAwardItem:OnDestroy()
  self:SetAllRewardsDestroy()
  self.rank_img = nil
  self.rank_text1 = nil
  self.rank_text2 = nil
  self.content = nil
  self.tip = nil
  self.tip_text = nil
  self.items = {}
  self.dataList = {}
  base.OnDestroy(self)
end

function LWActMeteoriteRankAwardItem:SetAllRewardsDestroy()
  self.content:RemoveComponents(UICommonResItem)
  if self.rewardModels ~= nil then
    for _, v in pairs(self.rewardModels) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.rewardModels = {}
  self.rewardItemsList = {}
end

function LWActMeteoriteRankAwardItem:SetData(info, bPerson)
  local ranks = string.string2array_i_oneSep(info.para, ";")
  local fR = ranks[1] or 0
  local tR = ranks[2] or 0
  if 0 < fR and fR <= 3 and (tR == 0 or tR == fR) then
    self.rank_img:LoadSpriteAuto(string.format(RANK_PATH, fR))
    self.rank_img:SetActive(true)
    self.rank_text2:SetActive(false)
    self.rank_text1:SetText(fR)
    self.bg:LoadSpriteAuto(string.format(RANK_BG_PATH, fR))
  elseif 0 < fR and 0 < tR then
    self.rank_img:SetActive(false)
    self.rank_text2:SetActive(true)
    self.rank_text2:SetText(fR .. "-" .. tR)
    self.bg:LoadSpriteAuto(string.format(LoadPath.CommonApsNewPath, "ljq_tongyong_paihangbang_4.png"))
  end
  local actInfo = DataCenter.ActMeteoriteBattleManager:GetActInfo()
  local meteorites = actInfo ~= nil and actInfo.meteorites or {}
  local tipStr = {}
  for i, v in ipairs(meteorites) do
    local checkRank = bPerson and v.personRank or v.allianceRank
    if 0 < fR and fR <= 3 and (tR == 0 or tR == fR) then
      if checkRank == fR then
        table.insert(tipStr, i)
      end
    elseif 0 < fR and 0 < tR and fR <= checkRank and tR >= checkRank then
      table.insert(tipStr, i)
    end
  end
  local flag = 0 < #tipStr
  self.tip:SetActive(flag)
  if flag then
    self.tip_text:SetLocalText("yuntieBattle_interface_1048", table.concat(tipStr, "/"))
  end
  self:SetAllRewardsDestroy()
  local list = DataCenter.ActMeteoriteBattleManager:GetRewardsById(info.reward)
  self.rewardModelCount = 0
  for i, v in ipairs(list) do
    self.rewardModelCount = self.rewardModelCount + 1
    self.rewardModels[self.rewardModelCount] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform.localScale = Vector3.New(0.7, 0.7, 1)
      go.transform:Set_sizeDelta(150, 150)
      go.transform:Set_pivot(0, 1)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = self.content:AddComponent(UICommonResItem, nameStr)
      cell:ReInit(list[i])
      table.insert(self.rewardItemsList, cell)
    end)
  end
end

return LWActMeteoriteRankAwardItem
