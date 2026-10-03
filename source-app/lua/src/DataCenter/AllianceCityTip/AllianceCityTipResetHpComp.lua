local base = require("DataCenter.AllianceCityTip.AllianceCityTipBaseClass")
local AllianceCityTipResetHpComp = BaseClass("AllianceCityTipResetHpComp", base)
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local hp_bar_tween_path = "HpBarBg/HpBarTween"
local hp_bar_green_path = "HpBarBg/HpBarGreen"
local hp_bar_red_path = "HpBarBg/HpBarRed"
local hp_bar_num_path = "HpBarBg/HpBarNum"
local HP_BAR_LENGTH = 1.77
local HIDE_LOD = 3
local SpriteRenderer = CS.UnityEngine.SpriteRenderer
local SuperTextMesh = CS.SuperTextMesh

function AllianceCityTipResetHpComp:__init(gameObject)
  base.__init(self, gameObject)
  self.isVisible = nil
  self.oldHp = nil
  self.hpSeqDict = {}
end

function AllianceCityTipResetHpComp:__delete()
  if self.hpSeqDict then
    for i, v in pairs(self.hpSeqDict) do
      v:Kill()
    end
  end
  if self.hpDamageTip then
    self.hpDamageTip:GameObjectRecycleAll()
    self.hpDamageTip = nil
  end
  if self.soldierDamageTip then
    self.soldierDamageTip:GameObjectRecycleAll()
    self.soldierDamageTip = nil
  end
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
  self.reset_hp_root = nil
  self.hp_bar_tween = nil
  self.hp_bar_green = nil
  self.hp_bar_red = nil
  self.hp_bar_num = nil
  self.isVisible = nil
  self.oldHp = nil
  base.__delete(self)
end

function AllianceCityTipResetHpComp:SetLod(lod)
  base.SetLod(self, lod)
  self.isVisible = lod < HIDE_LOD
  if not self.isVisible then
    if self.reset_hp_root then
      self.reset_hp_root:SetActive(false)
    end
  else
    self:RefreshHpBar(false)
  end
end

function AllianceCityTipResetHpComp:RefreshHpBarView(withAnim, curHp)
  if self.reset_hp_root == nil then
    return
  end
  if self.oldHp == nil then
    withAnim = false
  end
  if curHp ~= self.oldHp then
    local hp_bar
    if 100 <= curHp then
      hp_bar = self.hp_bar_green
      self.hp_bar_green.gameObject:SetActive(true)
      self.hp_bar_red.gameObject:SetActive(false)
    else
      hp_bar = self.hp_bar_red
      self.hp_bar_green.gameObject:SetActive(false)
      self.hp_bar_red.gameObject:SetActive(true)
    end
    self.oldHp = curHp
    if 100 < curHp then
      curHp = 100
    elseif curHp < 0 then
      curHp = 0
    end
    local endValue = curHp / 100 * HP_BAR_LENGTH
    local vec = hp_bar.size
    vec.x = endValue
    if self.hpTween then
      self.hpTween:Kill()
      self.hpTween = nil
    end
    if withAnim then
      self.hpTween = DOTween.To(function()
        return self.hp_bar_tween.size.x
      end, function(x)
        local vec2 = self.hp_bar_tween.size
        vec2.x = x
        self.hp_bar_tween.size = vec2
      end, endValue, 1)
    else
      self.hp_bar_tween.size = vec
    end
    hp_bar.size = vec
    self.hp_bar_num.text = Localization:GetString("320362", curHp)
  end
end

function AllianceCityTipResetHpComp:CheckLod(lod)
  base.CheckLod(self, lod)
  local lastVisible = self.isVisible
  self.isVisible = lod < HIDE_LOD
  if not self.isVisible then
    if self.reset_hp_root then
      self.reset_hp_root:SetActive(false)
    end
  elseif self.isVisible ~= lastVisible then
    self:RefreshHpBar(false)
  end
end

function AllianceCityTipResetHpComp:ReInit(data)
  base.ReInit(self, data)
  local theWorld = CS.SceneManager.World
  self:SetLod(theWorld:GetLodLevel())
  self:RefreshHpBar()
end

function AllianceCityTipResetHpComp:RefreshHpBar(withAnim)
  if self.data == nil or self.cityType ~= WorldAllianceCityType.City then
    self.showHp = false
    if self.reset_hp_root then
      self.reset_hp_root:SetActive(false)
    end
    return
  end
  self.showHp = DataCenter.OffSeason1QueenOfBloodManager:InQueenOfBloodBattle()
  if not self.showHp then
    if self.reset_hp_root then
      self.reset_hp_root:SetActive(false)
    end
    return
  end
  if not self.isVisible then
    if self.reset_hp_root then
      self.reset_hp_root:SetActive(false)
    end
    return
  end
  if self.reset_hp_root == nil then
    if self.request == nil then
      local request = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/UI/LWOffSeason1/AllianceCityTip/AllianceCityTipResetHpRoot.prefab")
      request:completed("+", function()
        local theWorld = CS.SceneManager.World
        if request.isError or self.transform == nil or theWorld == nil or IsNull(self.transform) then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.transform:Set_localPosition(0, -1.15, 0)
        go.transform:Set_localRotation(0, 0, 0, 1)
        local transform = go.transform
        self.reset_hp_root = transform.gameObject
        self.hp_bar_tween = transform:Find(hp_bar_tween_path):GetComponent(typeof(SpriteRenderer))
        self.hp_bar_green = transform:Find(hp_bar_green_path):GetComponent(typeof(SpriteRenderer))
        self.hp_bar_red = transform:Find(hp_bar_red_path):GetComponent(typeof(SpriteRenderer))
        self.hp_bar_num = transform:Find(hp_bar_num_path):GetComponent(typeof(SuperTextMesh))
        self.hpDamageTip = transform:Find("HpDamageTip").gameObject
        self.hpDamageTip:GameObjectCreatePool()
        self.hpDamageTip:SetActive(false)
        self.soldierDamageTip = transform:Find("SoldierDamageTip").gameObject
        self.soldierDamageTip:GameObjectCreatePool()
        self.soldierDamageTip:SetActive(false)
        self:RefreshHpBar(false)
      end)
      self.request = request
    end
  else
    local info = DataCenter.OffSeason1QueenOfBloodManager:GetCityInfoById(self.cityId)
    if info == nil or info.defendInfo == nil or info.defendInfo.hp == nil then
      self.reset_hp_root:SetActive(false)
      return
    end
    self.reset_hp_root:SetActive(true)
    local curHp = info.defendInfo.hp
    self:RefreshHpBarView(withAnim, curHp)
    if self.lodCache >= HIDE_LOD then
      self.reset_hp_root:SetActive(false)
    end
  end
end

function AllianceCityTipResetHpComp:ShowHpDamageTip(totalDamage)
  if self.hpDamageTip == nil then
    return
  end
  local hpTip = self.hpDamageTip:GameObjectSpawn(self.reset_hp_root.transform)
  local node = hpTip.transform
  local damage_text = node:Find("Icon/HpDamage"):GetComponent(typeof(CS.TextMeshProEx))
  damage_text.text = "-" .. string.percentage(totalDamage, 100, 0)
  hpTip.transform:Set_localScale(0.3, 0.3, 0.3)
  hpTip.transform:Set_localPosition(-0.252, 0.855, 0)
  hpTip.transform:Set_localRotation(0, 0, 0, 1)
  hpTip:SetActive(true)
  local offsetX = math.random(-10, 10)
  local moveX1 = offsetX / 10
  local moveX2 = moveX1 + offsetX / 20
  local seq = CS.DG.Tweening.DOTween.Sequence()
  seq:Insert(0, damage_text:DOFade(1, 0.01))
  seq:Append(node:DOMove(node.position + Vector3.New(moveX1, 2, 0), 0.5)):SetEase(CS.DG.Tweening.Ease.OutQuad)
  seq:Append(node:DOMove(node.position + Vector3.New(moveX2, 1, 0), 0.2)):SetEase(CS.DG.Tweening.Ease.InQuad)
  seq:Insert(0.5, damage_text:DOFade(0, 0.2)):SetEase(CS.DG.Tweening.Ease.OutQuad)
  
  function seq.onComplete()
    if not IsNull(hpTip) and type(hpTip.Destroy) == "function" then
      hpTip:GameObjectRecycle()
      if self.hpSeqDict then
        self.hpSeqDict[hpTip] = nil
      end
    end
  end
  
  self.hpSeqDict[hpTip] = seq
end

function AllianceCityTipResetHpComp:ShowSoldierDamageTip(totalDamage)
  if self.soldierDamageTip == nil then
    return
  end
  local hpTip = self.soldierDamageTip:GameObjectSpawn(self.reset_hp_root.transform)
  local node = hpTip.transform
  local damage_text = node:Find("Icon/SoldierDamage"):GetComponent(typeof(CS.TextMeshProEx))
  damage_text.text = "-" .. string.GetFormattedSeparatorNum(totalDamage)
  hpTip.transform:Set_localScale(0.3, 0.3, 0.3)
  hpTip.transform:Set_localPosition(-0.252, 0.855, 0)
  hpTip.transform:Set_localRotation(0, 0, 0, 1)
  hpTip:SetActive(true)
  local seq = CS.DG.Tweening.DOTween.Sequence()
  seq:Append(node:DOMove(node.position + Vector3.New(0, 2, 0), 0.5))
  seq:AppendInterval(0.2)
  
  function seq.onComplete()
    if not IsNull(hpTip) and type(hpTip.Destroy) == "function" then
      hpTip:GameObjectRecycle()
      if self.hpSeqDict then
        self.hpSeqDict[hpTip] = nil
      end
    end
  end
  
  self.hpSeqDict[hpTip] = seq
end

return AllianceCityTipResetHpComp
