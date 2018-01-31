if myHero.charName ~= "Amumu" then return end

require 'DamageLib'
require 'Eternal Prediction'

class "DonAmumu"

function DonAmumu:__init()
	PrintChat("DonAmumu carregado com sucesso!")
	self:LoadSpells()
	self:LoadMenu()
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("Draw", function() self:Draw() end)
end

function DonAmumu.LoadSpells()
	Q = { range = 1100, delay = 0.25, speed = 2000, width = 60 }
	E = { range = 350, delay = 0.25, speed = math.huge, width = 350 }
	R = { range = 5350, delay = 0.25, speed = math.huge, width = 550 }
end

function DonAmumu:LoadMenu()
	DonAmumu.Menu = MenuElement({id = "DonAmumu", name = "Amumu", type = MENU, leftIcon ="https://www.mobafire.com/images/champion/icon/amumu.png"})
	DonAmumu.Menu:MenuElement({id = "Combo", name = "Combo", type = MENU})
	DonAmumu.Menu:MenuElement({id = "LaneClear", name = "LimparWaves", type = MENU})
	DonAmumu.Menu:MenuElement({id = "Harass", name = "Harass", type = MENU})
	DonAmumu.Menu:MenuElement({id = "LastHit", name = "LastHit", type = MENU})
	DonAmumu.Menu:MenuElement({id = "Killsteal", name = "Killsteal", type = MENU})
	DonAmumu.Menu:MenuElement({id = "Draw", name = "Desenhos", type = MENU})
-- Combo Sub-Menu
	DonAmumu.Menu.Combo:MenuElement({id = "UseQ", name = "Usar Q [Bandagem]", value = true, leftIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/b/b5/Bandage_Toss.png/revision/latest?cb=20171130205725"})
	DonAmumu.Menu.Combo:MenuElement({id = "UseE", name = "Usar E", value = true, leftIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/b/b3/Tantrum.png/revision/latest?cb=20171129224902"})
	DonAmumu.Menu.Combo:MenuElement({id = "UseR", name = "Usar R", value = true, leftIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/7/72/Curse_of_the_Sad_Mummy.png/revision/latest?cb=20171130205438"})
	DonAmumu.Menu.Combo:MenuElement({id = "UseRTarget", name = "Alvos minimos para R", value = 2, min = 1, max = 5, step = 1, leftIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/7/72/Curse_of_the_Sad_Mummy.png/revision/latest?cb=20171130205438"})
-- LaneClear Sub-Menu
	DonAmumu.Menu.LaneClear:MenuElement({id = "UseE", name = "Usar E", value = true, leftIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/b/b3/Tantrum.png/revision/latest?cb=20171129224902"})
-- Harass Sub-Menu
	DonAmumu.Menu.Harass:MenuElement({id = "UseE", name = "Usar E", value = falsee, leftIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/b/b3/Tantrum.png/revision/latest?cb=20171129224902"})
-- LastHit Sub-Menu
	DonAmumu.Menu.LastHit:MenuElement({id = "UseE", name = "Usar E", value = false, leftIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/b/b3/Tantrum.png/revision/latest?cb=20171129224902"})
-- Draw Sub-Menu
	DonAmumu.Menu.Draw:MenuElement({id = "DrawReady", name = "Desenhar apenas habilidades [?]", value = false})
	DonAmumu.Menu.Draw:MenuElement({id = "DrawQ", name = "Desenhar Alcance Q", value = true, leftIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/b/b5/Bandage_Toss.png/revision/latest?cb=20171130205725"})
	DonAmumu.Menu.Draw:MenuElement({id = "DrawE", name = "Desenhar Alcance E", value = false, leftIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/b/b3/Tantrum.png/revision/latest?cb=20171129224902"})
	DonAmumu.Menu.Draw:MenuElement({id = "DrawR", name = "Desenhar Alcance R", value = false, leftIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/7/72/Curse_of_the_Sad_Mummy.png/revision/latest?cb=20171130205438"})
-- Killsteal Sub-Menu
	DonAmumu.Menu.Killsteal:MenuElement({id = "StealQ", name = "KS com o Q", value = true, leftIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/b/b5/Bandage_Toss.png/revision/latest?cb=20171130205725"})
	DonAmumu.Menu.Killsteal:MenuElement({id = "StealE", name = "KS com o E", value = false, leftIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/b/b3/Tantrum.png/revision/latest?cb=20171129224902"})
	DonAmumu.Menu.Killsteal:MenuElement({id = "StealR", name = "KS com o R", value = false, leftIcon = "https://vignette.wikia.nocookie.net/leagueoflegends/images/7/72/Curse_of_the_Sad_Mummy.png/revision/latest?cb=20171130205438"})
-- Infos
	DonAmumu.Menu:MenuElement({name = "Versao: 0.1", type = SPACE})
	DonAmumu.Menu:MenuElement({name = "Patch   : 8.3", type = SPACE})
	DonAmumu.Menu:MenuElement({name = "Feito por DonThierry", type = SPACE})

	PrintChat("DonThierry Amumu menu carregado com sucesso!")
end

function DonAmumu:Tick()
	if not myHero.alive then return end
	
	if DonAmumu:GetMode() == "Combo" then
		DonAmumu:Combo()
	elseif DonAmumu:GetMode() == "Harass" then
		DonAmumu:Harass()
	elseif DonAmumu:GetMode() == "Clear" then
		DonAmumu:LaneClear()
	end

	DonAmumu:StealableTarget()
end

function DonAmumu:GetTarget(range)
	if _G.SDK and _G.SDK.Orbwalker then
		local target = _G.SDK.TargetSelector:GetTarget(range, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		return target
	elseif _G.EOWLoaded then
		local target = EOW:GetTarget(range, easykill_acd)
		return target
	elseif _G.GOS then
		local target = GOS:GetTarget(range, "AD")
		return target
	else PrintChat("No TargetSelector Loaded ..?")
	end
end

function DonAmumu:CastQReset(target)
	if target == nil then return end
	if _G.SDK and _G.SDK.Orbwalker then
		_G.SDK.Orbwalker:OnPostAttack(DonAmumu:CastQ(target))
	elseif _G.EOWLoaded then
		EOW:AddCallback(EOW.AfterAttack, DonAmumu:CastQ(target))
	else 
		GOS:OnAttackComplete(DonAmumu:CastQ(target))
	end
end

--From Weedle
local intToMode = {
   		[0] = "",
   		[1] = "Combo",
   		[2] = "Harass",
   		[3] = "LastHit",
   		[4] = "Clear"
	}

--From Weedle
function DonAmumu:GetMode()
	if _G.EOWLoaded then
		return intToMode[EOW.CurrentMode]
	elseif _G.SDK and _G.SDK.Orbwalker then
		if _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO] then
			return "Combo"
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_HARASS] then
			return "Harass"	
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LANECLEAR] or _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_JUNGLECLEAR] then
			return "Clear"
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LASTHIT] then
			return "LastHit"
		end
	else
		return GOS.GetMode()
	end
end

function DonAmumu:Draw()
	if not myHero.alive then return end

	if DonAmumu.Menu.Draw.DrawReady:Value() then
		if DonAmumu:IsReady(_Q) and DonAmumu.Menu.Draw.DrawQ:Value() then
			Draw.Circle(myHero.pos, 1100, 3, Draw.Color(255, 255, 255, 100))
		end
		if DonAmumu:IsReady(_E) and DonAmumu.Menu.Draw.DrawQ:Value() then
			Draw.Circle(myHero.pos, 350, 3, Draw.Color(255, 255, 255, 100))
		end
		if DonAmumu:IsReady(_R) and DonAmumu.Menu.Draw.DrawQ:Value() then
			Draw.Circle(myHero.pos, 550, 3, Draw.Color(255, 255, 255, 100))
		end
	else
		if DonAmumu.Menu.Draw.DrawQ:Value() then
			Draw.Circle(myHero.pos, 1100, 3, Draw.Color(255, 255, 255, 100))
		end
		if DonAmumu.Menu.Draw.DrawE:Value() then
			Draw.Circle(myHero.pos, 350, 3, Draw.Color(255, 255, 255, 100))
		end
		if DonAmumu.Menu.Draw.DrawQ:Value() then
			Draw.Circle(myHero.pos, 550, 3, Draw.Color(255, 255, 255, 100))
	end
end

-- Début Vrai Script

function DonAmumu:Combo()
	if DonAmumu:GetTarget(Q.range) == nil then return end

	if DonAmumu.Menu.Combo.UseQ:Value() and DonAmumu:IsReady(_Q) then
		if myHero.activeSpell.valid then return end
		local target = DonAmumu:GetTarget(Q.range)
		if target == nil then return end
		local QPred = Prediction:SetSpell(Q, TYPE_LINE, true)
		local prediction = QPred:GetPrediction(target, myHero.pos)
		if prediction and prediction.hitChance >= 0.25 and prediction:mCollision() == 0 and prediction:hCollision() == 0 then
			Control.CastSpell(HK_Q, prediction.castPos)
		end
	end

	--[[Don Thierry :
	-Criador de scripts
	]]
end

function DonAmumu:Harass()
	if DonAmumu:GetTarget(Q.range) == nil then return end
	if DonAmumu.Menu.Combo.UseQ:Value() and DonAmumu:IsReady(_Q) then
		if myHero.activeSpell.valid then return end
		local target = DonAmumu:GetTarget(1100)
		if target == nil then return end
		local QPred = Prediction:SetSpell(Q, TYPE_LINE, true)
		local prediction = QPred:GetPrediction(target, myHero.pos)
		if prediction and prediction.hitChance >= 0.25 and prediction:mCollision() == 0 and prediction:hCollision() == 0 then
			Control.CastSpell(HK_Q, prediction.castPos)
		end
	end

end

function DonAmumu:LaneClear()
	--[[local GetValidMinion = GetValidMinion(E.range)

	for i = 1, #GetValidMinion do
		local minion = GetValidMinion[i]
		if DonAmumu.Menu.Laneclear.UseE:Value() and DonAmumu:IsReady(_E) then
			local prediction = minion:GetPrediction(E.speed, E.delay)
			Control.CastSpell(HK_E, prediction)
		end
	end]]

	--[[DonThierry :
	-Laneclear E le plus de creeps possibles
	]]
end

function DonAmumu:LastHit()
	--[[A FAIRE :
	-Lasthit un creep en prenant compte de la collision des autres creeps
	-Lasthit un creep sans push la lane
	]]
end

function DonAmumu:CheckR()
	--[[A FAIRE :
	-Auto R pendant le combo le nombre de targets minimum choisis
	]]
end


function DonAmumu:StealableTarget()
	if DonAmumu:GetTarget(Q.range) == nil then return end

	if DonAmumu.Menu.Killsteal.StealQ:Value() and DonAmumu:IsReady(_Q) then
		if myHero.activeSpell.valid then return end
		local target = DonAmumu:GetTarget(Q.range)
		if target.alive and (target.health + target.shieldAD + target.shieldAP) < getdmg("Q", target, myHero) then
			if target == nil then return end
			local QPred = Prediction:SetSpell(Q, TYPE_LINE, true)
			local prediction = QPred:GetPrediction(target, myHero.pos)
			if prediction and prediction.hitChance >= 0.25 and prediction:mCollision() == 0 and prediction:hCollision() == 0 then
				Control.CastSpell(HK_Q, prediction.castPos)
			end
		end
	end


	if DonAmumu:GetTarget(R.range) == nil then return end

	if DonAmumu:IsReady(_R) and not DonAmumu:IsReady(_Q) then
		if myHero.activeSpell.valid then return end
		local target = DonAmumu:GetTarget(R.range)
		if target.alive and (target.health + target.shieldAD + target.shieldAP) < getdmg("R", target, myHero) then
			if target == nil then return end
			local RPred = Prediction:SetSpell(R, TYPE_CIRCULAR, true)
			local prediction = RPred:GetPrediction(target, myHero.pos)
			if prediction and prediction.hitChance >= 0.25 and prediction:mCollision() == 0 and prediction:hCollision() == 0 then
				Control.CastSpell(HK_R, prediction.castPos)
			end
		end
	end
end

-- Funcoes necessarias

function DonAmumu:CCed(unit)
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i)
		if unit.buffCount > 0 then
			if buff and (buff.type == 5 or buff.type == 7 or buff.type == 8 or buff.type == 11 or buff.type == 21 or buff.type == 22 or buff.type == 24 or buff.type == 29 or buff.type == 30) then
				return true
			end
		end
	end
	return false
end

function DonAmumu:ValidTarget(target)
	if not target.dead and not target.IsImmortal and target.IsTargetable and target.IsEnemy then
		return true
		else return false
	end
end

function DonAmumu:GetValidMinion(range)
	EnemyMinions = {}
    for i = 1, Game.MinionCount() do
        local Minion = Game.Minion(i)
       	if  Minion.IsEnemy and (Minion:DistanceTo(myHero) < range) then
       		table.insert(EnemyMinions, Minion)
       		return EnemyMinions
       	end
    end
end

function DonAmumu:AARange()
	local level = myHero.levelData.lvl
	local range = ({125,125,125,125,125,125,125,125,125,125,125,125,125,125,125,125,125,125})[level]
	return range
end


function DonAmumu:IsReady(name)
	if myHero:GetSpellData(name).currentCd == 0 and myHero:GetSpellData(name).level > 0 then
		return name
	end
end

function DonAmumu:HasBuff(unit, buffname)
	for i, buff in pairs(DonAmumu:GetBuffs(unit)) do
		if buff.name == buffname then
			return true
		end
	end
	return false
end

function DonAmumu:GetBuffs(unit)
 	local t = {}
 	for i = 0, unit.buffCount do
    	local buff = unit:GetBuff(i)
    	if buff.count > 0 then
      		table.insert(t, buff)
    	end
	end
  return t
end


function OnLoad()
	DonAmumu()
end