local GetGoodsTriggerEvent = BaseClass("GetGoodsTriggerEvent")

function GetGoodsTriggerEvent:__init()
end

function GetGoodsTriggerEvent:__delete()
end

function GetGoodsTriggerEvent:Execute(param, extra)
  local spl = string.split(param.para, "|")
  local goodsId = tonumber(spl[1])
  local goodsCount = tonumber(spl[2])
  DataCenter.LWBattleManager:GetCurBattleLogic():RecordGoods(goodsId, goodsCount)
  local isShowGetGoodsAnim = true
  if extra and extra.isShowGetGoodsAnim == false then
    isShowGetGoodsAnim = false
  end
  if isShowGetGoodsAnim then
    TimerManager:GetInstance():DelayInvoke(function()
      local para = {}
      para.goodsId = goodsId
      para.goodsCount = goodsCount
      para.worldPosition = extra
      EventManager:GetInstance():Broadcast(EventId.OnPVEBattleGetGoods, para)
    end, 0.3)
  end
end

return GetGoodsTriggerEvent
