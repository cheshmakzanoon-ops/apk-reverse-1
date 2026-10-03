local UIDesertBattleCommanderItem = BaseClass("UIDesertBattleCommanderItem", UIBaseContainer)
local base = UIBaseContainer
local bg2_path = "bg2"
local bg1_path = "bg1"
local head_path = "bg1/di/Head/UIPlayerHead"
local text_name_path = "bg1/di/NameText"
local text_state_path = "bg1/di/StateText"
local btn_praise_path = "bg1/di/PraiseBtn"
local text_praise_path = "bg1/di/PraiseBtn/PraiseText"
local pop_anim_path = "bg1/di/PopAnim"
local text_num_base_path = "bg1/line%d/NumText%d"

function UIDesertBattleCommanderItem:OnCreate()
  base.OnCreate(self)
  self.bg2 = self:AddComponent(UIBaseComponent, bg2_path)
  self.bg1 = self:AddComponent(UIBaseComponent, bg1_path)
  self.head = self:AddComponent(UICommonHead, head_path)
  self.head:SetEnableClickShowInfo(true, false)
  self.text_name = self:AddComponent(UIText, text_name_path)
  self.text_state = self:AddComponent(UIText, text_state_path)
  self.btn_praise = self:AddComponent(UIButton, btn_praise_path)
  self.btn_praise:SetSafeClickMode(true)
  self.btn_praise:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if self.uid then
      local thePlayerUid = self.uid
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      InteractiveUtil.TryThumbsUp(thePlayerUid, InteractiveUtil.ThumbsUpType.PlayerInfo, "DesertBattleCommander", function()
        local num
        local pInfo = DataCenter.ActDragonManager:GetCommanderByUid(thePlayerUid)
        if pInfo then
          pInfo.thumbsUpCount = pInfo.thumbsUpCount + 1
          num = pInfo.thumbsUpCount
        else
          num = toInt(self.text_praise:GetText()) + 1
        end
        self.text_praise:SetText(num)
        self:PlayAddAnim(num)
      end)
    end
  end)
  self.text_praise = self:AddComponent(UIText, text_praise_path)
  self.theHeartPopAnim = self.transform:Find(pop_anim_path).gameObject
  self.theHeartPopAnim:GameObjectCreatePool()
  self.text_nums = {}
  for i = 1, 3 do
    self.text_nums[i] = self:AddComponent(UIText, string.format(text_num_base_path, i, i))
  end
end

function UIDesertBattleCommanderItem:OnDestroy()
  self.theHeartPopAnim:GameObjectRecycleAll()
  self.uid = nil
  base.OnDestroy(self)
end

function UIDesertBattleCommanderItem:ReInit(data)
  if data == nil then
    self.bg1:SetActive(false)
    self.bg2:SetActive(true)
    return
  end
  self.bg1:SetActive(true)
  self.bg2:SetActive(false)
  self.uid = data.uid
  local pData = DataCenter.ActDragonManager:GetPlayerInfoByUID(data.uid)
  if pData then
    local showName = UIUtil.FormatAllianceAndName(nil, pData.name, pData.uid)
    self.text_name:SetText(showName)
    self.head:SetData(pData.uid, pData.pic, pData.picVer)
    self.text_praise:SetText(data.thumbsUpCount)
  end
  local inBattle = BattleFieldUtil.CheckPlayerInBF(data.uid)
  local keyId = inBattle and "Desert_strom_commander_1012" or "Desert_strom_commander_1013"
  local r = inBattle and 95 or 249
  local g = inBattle and 239 or 128
  local b = inBattle and 135 or 136
  self.text_state:SetLocalText(keyId)
  self.text_state:SetColorRGBA255(r, g, b, 255)
  self.text_nums[1]:SetText(data.orderCount or 0)
  self.text_nums[2]:SetText(data.finishCount or 0)
  self.text_nums[3]:SetText(data.joinCount or 0)
end

function UIDesertBattleCommanderItem:PlayAddAnim(count)
  local effectItem = self.theHeartPopAnim:GameObjectSpawn(self.btn_praise.transform)
  local textTrans = effectItem.transform:Find("PopAnimText")
  local unity_canvas_group = effectItem.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  local unity_text = textTrans.gameObject:GetComponent(typeof(CS.TextMeshProUGUIEx))
  if unity_text and unity_canvas_group then
    unity_text.text = "+1"
    effectItem.name = "Count" .. count
    effectItem:SetActive(true)
    unity_canvas_group.alpha = 1
    unity_canvas_group:DOFade(0, 0.75)
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Join(effectItem.transform:DOLocalMove(Vector3.New(0, 50, 0), 0.75):SetEase(CS.DG.Tweening.Ease.OutCirc))
    sequence:AppendCallback(function()
      effectItem:GameObjectRecycle()
    end)
  else
    effectItem:GameObjectRecycle()
  end
end

return UIDesertBattleCommanderItem
